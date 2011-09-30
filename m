From: Jamie Iles <jamie@jamieiles.com>
Subject: [PATCH] crypto: picoxcell: add dependency on HAVE_CLK
Date: Fri, 30 Sep 2011 23:26:41 +0100
Message-ID: <1317421601-7487-1-git-send-email-jamie@jamieiles.com>
Cc: Jamie Iles <jamie@jamieiles.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58384 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab1I3W0v (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Sep 2011 18:26:51 -0400
Received: by wwf22 with SMTP id 22so3344733wwf.1
        for <linux-crypto@vger.kernel.org>; Fri, 30 Sep 2011 15:26:50 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The picoxcell crypto driver requires the clk API, but the platform in
mainline does not currently support it.  Add an explicit dependency on
HAVE_CLK to avoid build breakage.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 drivers/crypto/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index e0b25de..4ac6d4d 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -266,7 +266,7 @@ config CRYPTO_DEV_OMAP_AES
 
 config CRYPTO_DEV_PICOXCELL
 	tristate "Support for picoXcell IPSEC and Layer2 crypto engines"
-	depends on ARCH_PICOXCELL
+	depends on ARCH_PICOXCELL && HAVE_CLK
 	select CRYPTO_AES
 	select CRYPTO_AUTHENC
 	select CRYPTO_ALGAPI
-- 
1.7.4.1
