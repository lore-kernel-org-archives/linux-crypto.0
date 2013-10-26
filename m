From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH] CRYPTO: omap-sham: Add missing modalias
Date: Sat, 26 Oct 2013 23:00:41 +0200
Message-ID: <1382821241-31180-1-git-send-email-pali.rohar@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Joni Lapilainen <joni.lapilainen@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:57258 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab3JZVBF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 26 Oct 2013 17:01:05 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Joni Lapilainen <joni.lapilainen@gmail.com>

Signed-off-by: Joni Lapilainen <joni.lapilainen@gmail.com>
---
 drivers/crypto/omap-sham.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 8bdde57..236db0a 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -2033,3 +2033,4 @@ module_platform_driver(omap_sham_driver);
 MODULE_DESCRIPTION("OMAP SHA1/MD5 hw acceleration support.");
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Dmitry Kasatkin");
+MODULE_ALIAS("platform:omap-sham");
-- 
1.7.10.4
