From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: [PATCH] geode-aes.c: Convert pci_module_init() to pci_register_driver()
Date: Fri, 12 Jan 2007 14:36:25 +0100
Message-ID: <45A78ED9.1030106@student.ltu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:35372 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbXALNwE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Jan 2007 08:52:04 -0500
To: herbert@gondor.apana.org.au, davem@davemloft.net
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 43a6839..31ea405 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -457,7 +457,7 @@ static struct pci_driver geode_aes_driver = {
 static int __init
 geode_aes_init(void)
 {
-	return pci_module_init(&geode_aes_driver);
+	return pci_register_driver(&geode_aes_driver);
 }
 
 static void __exit
