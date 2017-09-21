From: Janani Sankara Babu <jananis37@gmail.com>
Subject: [PATCH] staging:ccree Fix code style issues
Date: Thu, 21 Sep 2017 12:07:46 +0530
Message-ID: <1505975866-28226-1-git-send-email-jananis37@gmail.com>
Cc: gilad@benyossef.com, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Janani Sankara Babu <jananis37@gmail.com>
To: gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35599 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751743AbdIUGml (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Sep 2017 02:42:41 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch solves the coding style issues by giving same indent for 
switch and case

Signed-off-by: Janani Sankara Babu <jananis37@gmail.com>
---
 drivers/staging/ccree/ssi_hash.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 08eaa56..60a13c2 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -1176,12 +1176,12 @@ static int ssi_xcbc_setkey(struct crypto_ahash *ahash,
 	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 
 	switch (keylen) {
-		case AES_KEYSIZE_128:
-		case AES_KEYSIZE_192:
-		case AES_KEYSIZE_256:
-			break;
-		default:
-			return -EINVAL;
+	case AES_KEYSIZE_128:
+	case AES_KEYSIZE_192:
+	case AES_KEYSIZE_256:
+		break;
+	default:
+		return -EINVAL;
 	}
 
 	ctx->key_params.keylen = keylen;
@@ -1264,12 +1264,12 @@ static int ssi_cmac_setkey(struct crypto_ahash *ahash,
 	ctx->is_hmac = true;
 
 	switch (keylen) {
-		case AES_KEYSIZE_128:
-		case AES_KEYSIZE_192:
-		case AES_KEYSIZE_256:
-			break;
-		default:
-			return -EINVAL;
+	case AES_KEYSIZE_128:
+	case AES_KEYSIZE_192:
+	case AES_KEYSIZE_256:
+		break;
+	default:
+		return -EINVAL;
 	}
 
 	ctx->key_params.keylen = keylen;
-- 
1.9.1
