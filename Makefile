banner: # Typo: Allogator2 from https://manytools.org/hacker-tools/ascii-banner/
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

terraform: banner vault
	@echo "[terraform] Creating cluster infrastructure with terraform"
	@./bin/terraform.sh

ansible: banner vault
	@echo "[ansible] Configuring cluster infrastructure with ansible"
	@./bin/ansible.sh

deploy: banner terraform ansible
	@echo "[deploy] Finished bootstrapping cloud"
