From: Martin Hicks <mort@bork.org>
Subject: [PATCH 2/5] crypto: talitos: Remove MD5_BLOCK_SIZE
Date: Fri, 20 Feb 2015 11:21:13 -0500
Message-ID: <1424449276-5288-3-git-send-email-mort@bork.org>
References: <1424449276-5288-1-git-send-email-mort@bork.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	Martin Hicks <mort@bork.org>
To: Kim Phillips <kim.phillips@freescale.com>,
	Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:40731 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbbBTQVv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Feb 2015 11:21:51 -0500
Received: by iebtr6 with SMTP id tr6so8924964ieb.7
        for <linux-crypto@vger.kernel.org>; Fri, 20 Feb 2015 08:21:50 -0800 (PST)
In-Reply-To: <1424449276-5288-1-git-send-email-mort@bork.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is properly defined in the md5 header file.
---
 drivers/crypto/talitos.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index c49d977..89cf4d5 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -637,8 +637,6 @@ static void talitos_unregister_rng(struct device *dev)
 #define TALITOS_MAX_KEY_SIZE		96
 #define TALITOS_MAX_IV_LENGTH		16 /* max of AES_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE */
 
-#define MD5_BLOCK_SIZE    64
-
 struct talitos_ctx {
 	struct device *dev;
 	int ch;
@@ -2195,7 +2193,7 @@ static struct talitos_alg_template driver_algs[] = {
 			.halg.base = {
 				.cra_name = "md5",
 				.cra_driver_name = "md5-talitos",
-				.cra_blocksize = MD5_BLOCK_SIZE,
+				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
 					     CRYPTO_ALG_ASYNC,
 			}
@@ -2285,7 +2283,7 @@ static struct talitos_alg_template driver_algs[] = {
 			.halg.base = {
 				.cra_name = "hmac(md5)",
 				.cra_driver_name = "hmac-md5-talitos",
-				.cra_blocksize = MD5_BLOCK_SIZE,
+				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
 					     CRYPTO_ALG_ASYNC,
 			}
-- 
1.7.10.4
