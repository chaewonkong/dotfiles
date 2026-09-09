{pkgs,lib, ...}:
{
    home.packages = with pkgs; [
        colima
        docker-compose
        docker-client
    ];

    home.file.".docker/cli-plugins/docker-compose".source ="${pkgs.docker-compose}/bin/docker-compose";
    home.file.".colima/default/colima.yaml".text = lib.generators.toYAML { } ({
        cpu = 4;
        memory = 8;
        disk = 60;
        runtime = "docker";
    } // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
        vmType = "vz";
        mountType = "virtiofs";
        rosetta = true; 
    });
}