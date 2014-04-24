From: Marek Vasut <marex@denx.de>
Subject: [PATCH 01/11] crypto: caam: Contain caam_jr_strstatus() ugliness
Date: Thu, 24 Apr 2014 20:05:12 +0200
Message-ID: <1398362722-16430-2-git-send-email-marex@denx.de>
References: <1398362722-16430-1-git-send-email-marex@denx.de>
Cc: Marek Vasut <marex@denx.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Horia Geanta <horia.geanta@freescale.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:35612 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758634AbaDXSFd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 Apr 2014 14:05:33 -0400
In-Reply-To: <1398362722-16430-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The tentacles of this function were firmly attached to various
places in the CAAM code. Just cut them, or this cthulhu function
will sprout them anew.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/caam/caamalg.c  | 28 ++++++++--------------------
 drivers/crypto/caam/caamhash.c | 28 ++++++++--------------------
 drivers/crypto/caam/caamrng.c  |  7 ++-----
 drivers/crypto/caam/error.c    |  5 +++--
 drivers/crypto/caam/error.h    |  2 +-
 drivers/crypto/caam/key_gen.c  |  7 ++-----
 6 files changed, 24 insertions(+), 53 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 5f89125..339277c7 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -918,11 +918,8 @@ static void aead_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	edesc = (struct aead_edesc *)((char *)desc -
 		 offsetof(struct aead_edesc, hw_desc));
 
-	if (err) {
-		char tmp[CAAM_ERROR_STR_MAX];
-
-		dev_err(jrdev, "%08x: %s\n", err, caam_jr_strstatus(tmp, err));
-	}
+	if (err)
+		caam_jr_strstatus(jrdev, err);
 
 	aead_unmap(jrdev, edesc, req);
 
@@ -969,11 +966,8 @@ static void aead_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 		       req->cryptlen - ctx->authsize, 1);
 #endif
 
-	if (err) {
-		char tmp[CAAM_ERROR_STR_MAX];
-
-		dev_err(jrdev, "%08x: %s\n", err, caam_jr_strstatus(tmp, err));
-	}
+	if (err)
+		caam_jr_strstatus(jrdev, err);
 
 	aead_unmap(jrdev, edesc, req);
 
@@ -1018,11 +1012,8 @@ static void ablkcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	edesc = (struct ablkcipher_edesc *)((char *)desc -
 		 offsetof(struct ablkcipher_edesc, hw_desc));
 
-	if (err) {
-		char tmp[CAAM_ERROR_STR_MAX];
-
-		dev_err(jrdev, "%08x: %s\n", err, caam_jr_strstatus(tmp, err));
-	}
+	if (err)
+		caam_jr_strstatus(jrdev, err);
 
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "dstiv  @"__stringify(__LINE__)": ",
@@ -1053,11 +1044,8 @@ static void ablkcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 
 	edesc = (struct ablkcipher_edesc *)((char *)desc -
 		 offsetof(struct ablkcipher_edesc, hw_desc));
-	if (err) {
-		char tmp[CAAM_ERROR_STR_MAX];
-
-		dev_err(jrdev, "%08x: %s\n", err, caam_jr_strstatus(tmp, err));
-	}
+	if (err)
+		caam_jr_strstatus(jrdev, err);
 
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "dstiv  @"__stringify(__LINE__)": ",
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 0378328..430df39 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -631,11 +631,8 @@ static void ahash_done(struct device *jrdev, u32 *desc, u32 err,
 
 	edesc = (struct ahash_edesc *)((char *)desc -
 		 offsetof(struct ahash_edesc, hw_desc));
-	if (err) {
-		char tmp[CAAM_ERROR_STR_MAX];
-
-		dev_err(jrdev, "%08x: %s\n", err, caam_jr_strstatus(tmp, err));
-	}
+	if (err)
+		caam_jr_strstatus(jrdev, err);
 
 	ahash_unmap(jrdev, edesc, req, digestsize);
 	kfree(edesc);
@@ -669,11 +666,8 @@ static void ahash_done_bi(struct device *jrdev, u32 *desc, u32 err,
 
 	edesc = (struct ahash_edesc *)((char *)desc -
 		 offsetof(struct ahash_edesc, hw_desc));
-	if (err) {
-		char tmp[CAAM_ERROR_STR_MAX];
-
-		dev_err(jrdev, "%08x: %s\n", err, caam_jr_strstatus(tmp, err));
-	}
+	if (err)
+		caam_jr_strstatus(jrdev, err);
 
 	ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len, DMA_BIDIRECTIONAL);
 	kfree(edesc);
@@ -707,11 +701,8 @@ static void ahash_done_ctx_src(struct device *jrdev, u32 *desc, u32 err,
 
 	edesc = (struct ahash_edesc *)((char *)desc -
 		 offsetof(struct ahash_edesc, hw_desc));
-	if (err) {
-		char tmp[CAAM_ERROR_STR_MAX];
-
-		dev_err(jrdev, "%08x: %s\n", err, caam_jr_strstatus(tmp, err));
-	}
+	if (err)
+		caam_jr_strstatus(jrdev, err);
 
 	ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_FROM_DEVICE);
 	kfree(edesc);
@@ -745,11 +736,8 @@ static void ahash_done_ctx_dst(struct device *jrdev, u32 *desc, u32 err,
 
 	edesc = (struct ahash_edesc *)((char *)desc -
 		 offsetof(struct ahash_edesc, hw_desc));
-	if (err) {
-		char tmp[CAAM_ERROR_STR_MAX];
-
-		dev_err(jrdev, "%08x: %s\n", err, caam_jr_strstatus(tmp, err));
-	}
+	if (err)
+		caam_jr_strstatus(jrdev, err);
 
 	ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len, DMA_TO_DEVICE);
 	kfree(edesc);
diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 3529b54..8c07d31 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -103,11 +103,8 @@ static void rng_done(struct device *jrdev, u32 *desc, u32 err, void *context)
 	bd = (struct buf_data *)((char *)desc -
 	      offsetof(struct buf_data, hw_desc));
 
-	if (err) {
-		char tmp[CAAM_ERROR_STR_MAX];
-
-		dev_err(jrdev, "%08x: %s\n", err, caam_jr_strstatus(tmp, err));
-	}
+	if (err)
+		caam_jr_strstatus(jrdev, err);
 
 	atomic_set(&bd->empty, BUF_NOT_EMPTY);
 	complete(&bd->filled);
diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index 9f25f52..ba426d9 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -243,8 +243,9 @@ static void report_cond_code_status(u32 status, char *outstr)
 	SPRINTFCAT(outstr, "%s() not implemented", __func__, sizeof(__func__));
 }
 
-char *caam_jr_strstatus(char *outstr, u32 status)
+void caam_jr_strstatus(struct device *jrdev, u32 status)
 {
+	char outstr[CAAM_ERROR_STR_MAX];
 	static const struct stat_src {
 		void (*report_ssed)(u32 status, char *outstr);
 		char *error;
@@ -265,6 +266,6 @@ char *caam_jr_strstatus(char *outstr, u32 status)
 	if (status_src[ssrc].report_ssed)
 		status_src[ssrc].report_ssed(status, outstr);
 
-	return outstr;
+	dev_err(jrdev, "%08x: %s\n", status, outstr);
 }
 EXPORT_SYMBOL(caam_jr_strstatus);
diff --git a/drivers/crypto/caam/error.h b/drivers/crypto/caam/error.h
index 02c7baa..b6350b0 100644
--- a/drivers/crypto/caam/error.h
+++ b/drivers/crypto/caam/error.h
@@ -7,5 +7,5 @@
 #ifndef CAAM_ERROR_H
 #define CAAM_ERROR_H
 #define CAAM_ERROR_STR_MAX 302
-extern char *caam_jr_strstatus(char *outstr, u32 status);
+void caam_jr_strstatus(struct device *jrdev, u32 status);
 #endif /* CAAM_ERROR_H */
diff --git a/drivers/crypto/caam/key_gen.c b/drivers/crypto/caam/key_gen.c
index ea2e406..871703c 100644
--- a/drivers/crypto/caam/key_gen.c
+++ b/drivers/crypto/caam/key_gen.c
@@ -19,11 +19,8 @@ void split_key_done(struct device *dev, u32 *desc, u32 err,
 	dev_err(dev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 #endif
 
-	if (err) {
-		char tmp[CAAM_ERROR_STR_MAX];
-
-		dev_err(dev, "%08x: %s\n", err, caam_jr_strstatus(tmp, err));
-	}
+	if (err)
+		caam_jr_strstatus(dev, err);
 
 	res->err = err;
 
-- 
1.9.2
