From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: [PATCH RFC 07/11] crypto: caam - Unmap data prior to displaying data in print statements
Date: Mon, 15 Jun 2015 16:52:55 -0700
Message-ID: <1434412379-11623-8-git-send-email-vicki.milhoan@freescale.com>
References: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>,
	<ruchika.gupta@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0111.outbound.protection.outlook.com ([157.56.110.111]:35168
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750897AbbFOXxM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 19:53:12 -0400
In-Reply-To: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Move the dma unmap calls for data to occur before printing the data in
debug print statements.

Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
---
 drivers/crypto/caam/caamalg.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 29071a1..291a1a7 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -2234,6 +2234,11 @@ static void aead_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	edesc = (struct aead_edesc *)((char *)desc -
 		 offsetof(struct aead_edesc, hw_desc));
 
+	if (err)
+		caam_jr_strstatus(jrdev, err);
+
+	aead_unmap(jrdev, edesc, req);
+
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "dstiv  @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, req->iv,
@@ -2243,11 +2248,6 @@ static void aead_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 		       req->cryptlen - ctx->authsize, 1);
 #endif
 
-	if (err)
-		caam_jr_strstatus(jrdev, err);
-
-	aead_unmap(jrdev, edesc, req);
-
 	/*
 	 * verify hw auth check passed else return -EBADMSG
 	 */
@@ -2292,6 +2292,8 @@ static void ablkcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	if (err)
 		caam_jr_strstatus(jrdev, err);
 
+	ablkcipher_unmap(jrdev, edesc, req);
+
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "dstiv  @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, req->info,
@@ -2301,7 +2303,6 @@ static void ablkcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 		       edesc->dst_nents > 1 ? 100 : req->nbytes, 1);
 #endif
 
-	ablkcipher_unmap(jrdev, edesc, req);
 	kfree(edesc);
 
 	ablkcipher_request_complete(req, err);
@@ -2324,6 +2325,8 @@ static void ablkcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	if (err)
 		caam_jr_strstatus(jrdev, err);
 
+	ablkcipher_unmap(jrdev, edesc, req);
+
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "dstiv  @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, req->info,
@@ -2333,7 +2336,6 @@ static void ablkcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 		       edesc->dst_nents > 1 ? 100 : req->nbytes, 1);
 #endif
 
-	ablkcipher_unmap(jrdev, edesc, req);
 	kfree(edesc);
 
 	ablkcipher_request_complete(req, err);
-- 
2.1.4
