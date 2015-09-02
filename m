From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH] crypto: Kconfig: Allow MXS_DCP to be used on MX6SL
Date: Wed,  2 Sep 2015 12:05:18 -0300
Message-ID: <1441206318-27717-1-git-send-email-festevam@gmail.com>
Cc: marex@denx.de, horia.geanta@freescale.com,
	linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yk0-f178.google.com ([209.85.160.178]:33305 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbbIBPFk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Sep 2015 11:05:40 -0400
Received: by ykei199 with SMTP id i199so12590846yke.0
        for <linux-crypto@vger.kernel.org>; Wed, 02 Sep 2015 08:05:39 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

MX6SL has the same DCP crypto block as in MX23/MX28, so allow it to be
built for ARCH_MXC.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 07bc7aa..99b4795 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -429,7 +429,7 @@ endif
 
 config CRYPTO_DEV_MXS_DCP
 	tristate "Support for Freescale MXS DCP"
-	depends on ARCH_MXS
+	depends on (ARCH_MXS || ARCH_MXC)
 	select CRYPTO_CBC
 	select CRYPTO_ECB
 	select CRYPTO_AES
-- 
1.9.1
