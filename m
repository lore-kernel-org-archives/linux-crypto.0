Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0D8DC2B9F4
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 08:00:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72FC36101A
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 08:00:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbhFQIC0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Jun 2021 04:02:26 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50720 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230043AbhFQICW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jun 2021 04:02:22 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1ltmwg-0003gi-NT; Thu, 17 Jun 2021 16:00:14 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ltmwe-0002l6-R2; Thu, 17 Jun 2021 16:00:12 +0800
Date:   Thu, 17 Jun 2021 16:00:12 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Breno =?iso-8859-1?Q?Leit=E3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH] crypto: nx - Fix numerous sparse byte-order warnings
Message-ID: <20210617080012.GB10496@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The nx driver started out its life as a BE-only driver.  However,
somewhere along the way LE support was partially added.  This never
seems to have been extended all the way but it does trigger numerous
warnings during build.

This patch fixes all those warnings, but it doesn't mean that the
driver will work on LE.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/nx/nx-aes-cbc.c b/drivers/crypto/nx/nx-aes-cbc.c
index d6314ea9ae89..0e440f704a8f 100644
--- a/drivers/crypto/nx/nx-aes-cbc.c
+++ b/drivers/crypto/nx/nx-aes-cbc.c
@@ -88,7 +88,7 @@ static int cbc_aes_nx_crypt(struct skcipher_request *req,
 
 		memcpy(req->iv, csbcpb->cpb.aes_cbc.cv, AES_BLOCK_SIZE);
 		atomic_inc(&(nx_ctx->stats->aes_ops));
-		atomic64_add(csbcpb->csb.processed_byte_count,
+		atomic64_add(be32_to_cpu(csbcpb->csb.processed_byte_count),
 			     &(nx_ctx->stats->aes_bytes));
 
 		processed += to_process;
diff --git a/drivers/crypto/nx/nx-aes-ccm.c b/drivers/crypto/nx/nx-aes-ccm.c
index e7384d107573..3793885f928d 100644
--- a/drivers/crypto/nx/nx-aes-ccm.c
+++ b/drivers/crypto/nx/nx-aes-ccm.c
@@ -391,7 +391,7 @@ static int ccm_nx_decrypt(struct aead_request   *req,
 
 		/* update stats */
 		atomic_inc(&(nx_ctx->stats->aes_ops));
-		atomic64_add(csbcpb->csb.processed_byte_count,
+		atomic64_add(be32_to_cpu(csbcpb->csb.processed_byte_count),
 			     &(nx_ctx->stats->aes_bytes));
 
 		processed += to_process;
@@ -460,7 +460,7 @@ static int ccm_nx_encrypt(struct aead_request   *req,
 
 		/* update stats */
 		atomic_inc(&(nx_ctx->stats->aes_ops));
-		atomic64_add(csbcpb->csb.processed_byte_count,
+		atomic64_add(be32_to_cpu(csbcpb->csb.processed_byte_count),
 			     &(nx_ctx->stats->aes_bytes));
 
 		processed += to_process;
diff --git a/drivers/crypto/nx/nx-aes-ctr.c b/drivers/crypto/nx/nx-aes-ctr.c
index 13f518802343..873f1e3aa540 100644
--- a/drivers/crypto/nx/nx-aes-ctr.c
+++ b/drivers/crypto/nx/nx-aes-ctr.c
@@ -102,7 +102,7 @@ static int ctr_aes_nx_crypt(struct skcipher_request *req, u8 *iv)
 		memcpy(iv, csbcpb->cpb.aes_cbc.cv, AES_BLOCK_SIZE);
 
 		atomic_inc(&(nx_ctx->stats->aes_ops));
-		atomic64_add(csbcpb->csb.processed_byte_count,
+		atomic64_add(be32_to_cpu(csbcpb->csb.processed_byte_count),
 			     &(nx_ctx->stats->aes_bytes));
 
 		processed += to_process;
diff --git a/drivers/crypto/nx/nx-aes-ecb.c b/drivers/crypto/nx/nx-aes-ecb.c
index 7a729dc2bc17..502a565074e9 100644
--- a/drivers/crypto/nx/nx-aes-ecb.c
+++ b/drivers/crypto/nx/nx-aes-ecb.c
@@ -86,7 +86,7 @@ static int ecb_aes_nx_crypt(struct skcipher_request *req,
 			goto out;
 
 		atomic_inc(&(nx_ctx->stats->aes_ops));
-		atomic64_add(csbcpb->csb.processed_byte_count,
+		atomic64_add(be32_to_cpu(csbcpb->csb.processed_byte_count),
 			     &(nx_ctx->stats->aes_bytes));
 
 		processed += to_process;
diff --git a/drivers/crypto/nx/nx-aes-gcm.c b/drivers/crypto/nx/nx-aes-gcm.c
index fc9baca13920..4a796318b430 100644
--- a/drivers/crypto/nx/nx-aes-gcm.c
+++ b/drivers/crypto/nx/nx-aes-gcm.c
@@ -382,7 +382,7 @@ static int gcm_aes_nx_crypt(struct aead_request *req, int enc,
 		NX_CPB_FDM(csbcpb) |= NX_FDM_CONTINUATION;
 
 		atomic_inc(&(nx_ctx->stats->aes_ops));
-		atomic64_add(csbcpb->csb.processed_byte_count,
+		atomic64_add(be32_to_cpu(csbcpb->csb.processed_byte_count),
 			     &(nx_ctx->stats->aes_bytes));
 
 		processed += to_process;
diff --git a/drivers/crypto/nx/nx-sha256.c b/drivers/crypto/nx/nx-sha256.c
index b0ad665e4bda..c3bebf0feabe 100644
--- a/drivers/crypto/nx/nx-sha256.c
+++ b/drivers/crypto/nx/nx-sha256.c
@@ -16,6 +16,11 @@
 #include "nx_csbcpb.h"
 #include "nx.h"
 
+struct sha256_state_be {
+	__be32 state[SHA256_DIGEST_SIZE / 4];
+	u64 count;
+	u8 buf[SHA256_BLOCK_SIZE];
+};
 
 static int nx_crypto_ctx_sha256_init(struct crypto_tfm *tfm)
 {
@@ -36,7 +41,7 @@ static int nx_crypto_ctx_sha256_init(struct crypto_tfm *tfm)
 }
 
 static int nx_sha256_init(struct shash_desc *desc) {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
+	struct sha256_state_be *sctx = shash_desc_ctx(desc);
 
 	memset(sctx, 0, sizeof *sctx);
 
@@ -56,7 +61,7 @@ static int nx_sha256_init(struct shash_desc *desc) {
 static int nx_sha256_update(struct shash_desc *desc, const u8 *data,
 			    unsigned int len)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
+	struct sha256_state_be *sctx = shash_desc_ctx(desc);
 	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(&desc->tfm->base);
 	struct nx_csbcpb *csbcpb = (struct nx_csbcpb *)nx_ctx->csbcpb;
 	struct nx_sg *out_sg;
@@ -175,7 +180,7 @@ static int nx_sha256_update(struct shash_desc *desc, const u8 *data,
 
 static int nx_sha256_final(struct shash_desc *desc, u8 *out)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
+	struct sha256_state_be *sctx = shash_desc_ctx(desc);
 	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(&desc->tfm->base);
 	struct nx_csbcpb *csbcpb = (struct nx_csbcpb *)nx_ctx->csbcpb;
 	struct nx_sg *in_sg, *out_sg;
@@ -245,7 +250,7 @@ static int nx_sha256_final(struct shash_desc *desc, u8 *out)
 
 static int nx_sha256_export(struct shash_desc *desc, void *out)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
+	struct sha256_state_be *sctx = shash_desc_ctx(desc);
 
 	memcpy(out, sctx, sizeof(*sctx));
 
@@ -254,7 +259,7 @@ static int nx_sha256_export(struct shash_desc *desc, void *out)
 
 static int nx_sha256_import(struct shash_desc *desc, const void *in)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
+	struct sha256_state_be *sctx = shash_desc_ctx(desc);
 
 	memcpy(sctx, in, sizeof(*sctx));
 
@@ -268,8 +273,8 @@ struct shash_alg nx_shash_sha256_alg = {
 	.final      = nx_sha256_final,
 	.export     = nx_sha256_export,
 	.import     = nx_sha256_import,
-	.descsize   = sizeof(struct sha256_state),
-	.statesize  = sizeof(struct sha256_state),
+	.descsize   = sizeof(struct sha256_state_be),
+	.statesize  = sizeof(struct sha256_state_be),
 	.base       = {
 		.cra_name        = "sha256",
 		.cra_driver_name = "sha256-nx",
diff --git a/drivers/crypto/nx/nx-sha512.c b/drivers/crypto/nx/nx-sha512.c
index c29103a1a0b6..1ffb40d2c324 100644
--- a/drivers/crypto/nx/nx-sha512.c
+++ b/drivers/crypto/nx/nx-sha512.c
@@ -15,6 +15,11 @@
 #include "nx_csbcpb.h"
 #include "nx.h"
 
+struct sha512_state_be {
+	__be64 state[SHA512_DIGEST_SIZE / 8];
+	u64 count[2];
+	u8 buf[SHA512_BLOCK_SIZE];
+};
 
 static int nx_crypto_ctx_sha512_init(struct crypto_tfm *tfm)
 {
@@ -36,7 +41,7 @@ static int nx_crypto_ctx_sha512_init(struct crypto_tfm *tfm)
 
 static int nx_sha512_init(struct shash_desc *desc)
 {
-	struct sha512_state *sctx = shash_desc_ctx(desc);
+	struct sha512_state_be *sctx = shash_desc_ctx(desc);
 
 	memset(sctx, 0, sizeof *sctx);
 
@@ -56,7 +61,7 @@ static int nx_sha512_init(struct shash_desc *desc)
 static int nx_sha512_update(struct shash_desc *desc, const u8 *data,
 			    unsigned int len)
 {
-	struct sha512_state *sctx = shash_desc_ctx(desc);
+	struct sha512_state_be *sctx = shash_desc_ctx(desc);
 	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(&desc->tfm->base);
 	struct nx_csbcpb *csbcpb = (struct nx_csbcpb *)nx_ctx->csbcpb;
 	struct nx_sg *out_sg;
@@ -178,7 +183,7 @@ static int nx_sha512_update(struct shash_desc *desc, const u8 *data,
 
 static int nx_sha512_final(struct shash_desc *desc, u8 *out)
 {
-	struct sha512_state *sctx = shash_desc_ctx(desc);
+	struct sha512_state_be *sctx = shash_desc_ctx(desc);
 	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(&desc->tfm->base);
 	struct nx_csbcpb *csbcpb = (struct nx_csbcpb *)nx_ctx->csbcpb;
 	struct nx_sg *in_sg, *out_sg;
@@ -251,7 +256,7 @@ static int nx_sha512_final(struct shash_desc *desc, u8 *out)
 
 static int nx_sha512_export(struct shash_desc *desc, void *out)
 {
-	struct sha512_state *sctx = shash_desc_ctx(desc);
+	struct sha512_state_be *sctx = shash_desc_ctx(desc);
 
 	memcpy(out, sctx, sizeof(*sctx));
 
@@ -260,7 +265,7 @@ static int nx_sha512_export(struct shash_desc *desc, void *out)
 
 static int nx_sha512_import(struct shash_desc *desc, const void *in)
 {
-	struct sha512_state *sctx = shash_desc_ctx(desc);
+	struct sha512_state_be *sctx = shash_desc_ctx(desc);
 
 	memcpy(sctx, in, sizeof(*sctx));
 
@@ -274,8 +279,8 @@ struct shash_alg nx_shash_sha512_alg = {
 	.final      = nx_sha512_final,
 	.export     = nx_sha512_export,
 	.import     = nx_sha512_import,
-	.descsize   = sizeof(struct sha512_state),
-	.statesize  = sizeof(struct sha512_state),
+	.descsize   = sizeof(struct sha512_state_be),
+	.statesize  = sizeof(struct sha512_state_be),
 	.base       = {
 		.cra_name        = "sha512",
 		.cra_driver_name = "sha512-nx",
diff --git a/drivers/crypto/nx/nx_csbcpb.h b/drivers/crypto/nx/nx_csbcpb.h
index 493f8490ff94..e64f7e36fb92 100644
--- a/drivers/crypto/nx/nx_csbcpb.h
+++ b/drivers/crypto/nx/nx_csbcpb.h
@@ -140,8 +140,8 @@ struct cop_status_block {
 	u8 crb_seq_number;
 	u8 completion_code;
 	u8 completion_extension;
-	u32 processed_byte_count;
-	u64 address;
+	__be32 processed_byte_count;
+	__be64 address;
 } __packed;
 
 /* Nest accelerator workbook section 4.4 */
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
