From: Imre Kaloz <kaloz@openwrt.org>
Subject: [PATCH] The IXP4xx crypto driver should select CRYPTO_AUTHENC
Date: Fri, 11 Jul 2008 22:15:02 +0200
Message-ID: <12158073023807-git-send-email-kaloz@openwrt.org>
Cc: chohnstaedt@innominate.com, Imre Kaloz <kaloz@openwrt.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:32334 "EHLO
	viefep21-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759575AbYGKUQ0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Jul 2008 16:16:26 -0400
Received: from edge04.upc.biz ([192.168.13.239]) by viefep26-int.chello.at
          (InterMail vM.7.08.02.00 201-2186-121-20061213) with ESMTP
          id <20080711201508.PMNT24211.viefep26-int.chello.at@edge04.upc.biz>
          for <linux-crypto@vger.kernel.org>;
          Fri, 11 Jul 2008 22:15:08 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Without CRYPTO_AUTHENC the driver fails to build:
drivers/built-in.o: In function `ixp_module_init':
ixp4xx_crypto.c:(.init.text+0x3250): undefined reference to `crypto_aead_type'

Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
---
 drivers/crypto/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index eb2ec2e..e522144 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -195,6 +195,7 @@ config CRYPTO_DEV_IXP4XX
 	depends on ARCH_IXP4XX
 	select CRYPTO_DES
 	select CRYPTO_ALGAPI
+	select CRYPTO_AUTHENC
 	select CRYPTO_BLKCIPHER
 	help
 	  Driver for the IXP4xx NPE crypto engine.
-- 
1.5.2.5

