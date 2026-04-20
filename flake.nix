{
  description = "Biolizard Project Template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
	let
	  pkgs = nixpkgs.legacyPackages.x86_64-linux;
    rpkgs = pkgs.rPackages;
    r-env = with rpkgs; [
      readxl
      dplyr
      tidyr
      readr

      edgeR
      randomForest
      caret
      pheatmap
      DEqMS
      tidySummarizedExperiment
      tidybulk
      ranger
      UpSetR
      MLmetrics
      GO_db
      org_Hs_eg_db

      testthat
      renv
      languageserver
    ];
	in
	{

    devShells.x86_64-linux.project-start = pkgs.mkShellNoCC {
		  packages = [
				pkgs.cruft
        pkgs.conda
			];
			shellHook = ''
        echo "#####################"
        echo "cruft create -f https://github.com/lizard-bio/cookiecutter-analytical-project"
        echo "cd <your-project-name>
git init
git remote add origin git@github.com:lizard-bio/<your-project-name>.git
git branch -m main
git add --all
git commit -m "first commit"
git push -f origin main"
echo "#####################"
			'';
		};

    packages.x86_64-linux.rstudio = pkgs.rstudioWrapper.override{ packages = r-env; };
    packages.x86_64-linux.radian = pkgs.radianWrapper.override{ packages = r-env; };
    packages.x86_64-linux.R = pkgs.rWrapper.override{ packages = r-env; };

    devShells.x86_64-linux.dev = pkgs.mkShellNoCC {
      packages = [
        pkgs.conda
        self.packages.x86_64-linux.R
        self.packages.x86_64-linux.radian
        self.packages.x86_64-linux.rstudio
      ];
    };

    devShells.x86_64-linux.default = self.devShells.x86_64-linux.dev;

  };
}
