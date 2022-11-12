banner:
	@echo "##########################################################################"
	@echo "##                                                                      ##"
	@echo "##  :::::::::      :::      ::::::::  :::    ::: :::    ::: :::::::::   ##" 
	@echo "##  :+:    :+:   :+: :+:   :+:    :+: :+:   :+:  :+:    :+: :+:    :+:  ##"
	@echo "##  +:+    +:+  +:+   +:+  +:+        +:+  +:+   +:+    +:+ +:+    +:+  ##" 
	@echo "##  +#++:++#+  +#++:++#++: +#+        +#++:++    +#+    +:+ +#++:++#+   ##"
	@echo "##  +#+    +#+ +#+     +#+ +#+        +#+  +#+   +#+    +#+ +#+         ##"
	@echo "##  #+#    #+# #+#     #+# #+#    #+# #+#   #+#  #+#    #+# #+#         ##"   
	@echo "##  #########  ###     ###  ########  ###    ###  ########  ###         ##"
	@echo "##                                                                      ##"
	@echo "##########################################################################"
	@echo "                                                                          "

vault: banner
	@echo "[vault] Getting configuration and secrets from Vault"
	@./bin/vault.sh

ansible: banner vault
	@echo "[ansible] Configuring proxmox cluster with ansible"
	@./bin/ansible.sh

terraform: banner vault
	@echo "[terraform] Creating proxmox resources with terraform"
	@./bin/terraform.sh

deploy: banner ansible terraform 
	@echo "[deploy] Finished bootstrapping proxmox cluster"
