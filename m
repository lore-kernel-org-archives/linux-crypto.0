From: Martin Hicks <mort@bork.org>
Subject: [PATCH v2 2/5] crypto: talitos: Remove MD5_BLOCK_SIZE
Date: Tue,  3 Mar 2015 08:21:34 -0500
Message-ID: <1425388897-5434-3-git-send-email-mort@bork.org>
References: <1425388897-5434-1-git-send-email-mort@bork.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@freescale.com>,
	Martin Hicks <mort@bork.org>
To: Kim Phillips <kim.phillips@freescale.com>,
	Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:40564 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061AbbCCNVv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Mar 2015 08:21:51 -0500
Received: by igal13 with SMTP id l13so27201249iga.5
        for <linux-crypto@vger.kernel.org>; Tue, 03 Mar 2015 05:21:50 -0800 (PST)
In-Reply-To: <1425388897-5434-1-git-send-email-mort@bork.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is properly defined in the md5 header file.

Signed-off-by: Martin Hicks <mort@bork.org>
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
