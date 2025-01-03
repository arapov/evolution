{ config, pkgs, ... }:
let
  stdenv = pkgs.stdenv;

  URIEncode = pkgs.perlPackages.buildPerlPackage {
    pname = "URI-Encode";
    version = "1.1.1";
    src = pkgs.fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MITHUN/URI-Encode-v1.1.1.tar.gz";
      sha256 = "0fr410f2hiscm9dv85fwr2hyz1jjb445ady2z6617h0nf17cxfab";
    };
    meta = {
      license = with pkgs.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  perl = pkgs.perl.withPackages(p: [
    p.Moo p.LWPUserAgent
    p.URI URIEncode
    p.LWPProtocolHttps
    p.Clone p.YAMLLibYAML   # for QueryApp
  ]);

  workPath = "/Users/anton/Foundation";
  dataPath = "${workPath}/data";
  toolsPath = "${workPath}/tools";
  omcToolsPath = "${workPath}/omc-tools";

  scriptFor = name: pkgs.writeShellScript name ''
    export PATH="${perl}/bin:@SELF_PATH@:$PATH"
    export DATA="${dataPath}"
    export GITADDREV="${toolsPath}/review-tools/gitaddrev"
    PERL5LIB="${omcToolsPath}/OpenSSL-Query/lib:${omcToolsPath}/QueryApp/lib" exec \
      "${perl}/bin/perl" "${toolsPath}/review-tools/${name}" "$@"
  '';
in stdenv.mkDerivation rec {
    name = "ossl-tools";

    addrev = scriptFor "addrev";
    ghmerge = scriptFor "ghmerge";
    pickToBranch = scriptFor "pick-to-branch";

    builder = pkgs.writeShellScript "builder.sh" ''
      "${pkgs.coreutils}/bin/mkdir" -p "$out/bin"
      "${pkgs.coreutils}/bin/cp" "$addrev" "$out/bin/addrev"
      "${pkgs.coreutils}/bin/cp" "$ghmerge" "$out/bin/ghmerge"
      "${pkgs.coreutils}/bin/cp" "$pickToBranch" "$out/bin/pick-to-branch"
      for x in $out/bin/*; do
        "${pkgs.gnused}/bin/sed" -i "s#@SELF_PATH@#$out#" "$x"
      done
    '';
}
