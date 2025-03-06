
self: prev: {
  blueprint-compiler = prev.blueprint-compiler.overrideAttrs (oldAttrs: {
    version = "0.16.0";
    src = prev.fetchFromGitLab {
      domain = "gitlab.gnome.org";
      owner = "jwestman";
      repo = "blueprint-compiler";
      rev = "v0.16.0";
      sha256 = "1y40kf9yfrjlfr5ax27j7ksv27fsznl7jhvvkzbfifdymjv10wqn";
    };
    patches = (prev.patches or []) ++ [
      ./skip-docs.patch
    ];
  });
}
