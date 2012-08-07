From: Tushar Behera <tushar.behera@linaro.org>
Subject: [PATCH] crypto: atmel - Remove possible typo error
Date: Tue,  7 Aug 2012 17:32:14 +0530
Message-ID: <1344340934-1319-1-git-send-email-tushar.behera@linaro.org>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
	patches@linaro.org, Nicolas Royer <nicolas@eukrea.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47883 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab2HGMDl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Aug 2012 08:03:41 -0400
Received: by yhmm54 with SMTP id m54so3543888yhm.19
        for <linux-crypto@vger.kernel.org>; Tue, 07 Aug 2012 05:03:41 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Commit bd3c7b5c2aba ("crypto: atmel - add Atmel AES driver") possibly
has a typo error of adding an extra CONFIG_.

CC: Nicolas Royer <nicolas@eukrea.com>
Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/crypto/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 7d74d09..26d7d67 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -340,7 +340,7 @@ config CRYPTO_DEV_ATMEL_AES
 	select CRYPTO_AES
 	select CRYPTO_ALGAPI
 	select CRYPTO_BLKCIPHER
-	select CONFIG_AT_HDMAC
+	select AT_HDMAC
 	help
 	  Some Atmel processors have AES hw accelerator.
 	  Select this if you want to use the Atmel module for
-- 
1.7.4.1
