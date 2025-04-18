Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B8E268FE4
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 03:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945277; cv=none; b=r/k8NWjTWmaidHdNrpuXuU3/pM/gTMEyVS/HCBGWk7/kaZk8wz+GTPN4PgWK33z+qydGFGisIMLkCNB+nhNjZ4aFes4zNC8zJrb0y0NAi7RtltW7hxFVRAE/gTJQPLl6ZOWlZKLECFXUAgrY7qfFIJTuFUnmRY/pA3T2ZuesN+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945277; c=relaxed/simple;
	bh=cpkeOZqQXw28VPMShYvmfWmO6+Etmelgc0EFDxpkTeQ=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=aKeoejMrZm4XXPtdlEMPfi0eApV+ldh+1BWoMa8+IISzPK6Lnw6B0qkm/hXRKn99Wt1zErjuQ3w4j1XWS0zQkF265vyzm4LPLxjgOh4rJAW9yleJ0zzwzMMkzpfkqJwDdHIGxzRAkYZu0bmv8pHf4XWr06QpqEoFjehvTP1yypM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=akzDXSDR; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="akzDXSDR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=46cBG9CxAlz0AslgzxhTDWL5S99886idVQ7ORj8X7qI=; b=akzDXSDR7/JczgdJS2pulMjF+n
	cXjoMj3KVwpacBLYQHNMn0vu1/8KVQsb39CkBVA3UynWdeVafA0wAQ/e5b9lQaM78dMPY1hKDQW7l
	tvGYYwx1AhBFvheLQkXFplq3GORBtlrYlY1PKpWiPUBjHoW3Kdt4zRWux5G/y5/GSyq0dEwUtew4G
	o8dimjwwivwTeECWWrO4loR0aT8kt7BB1zQAx5CdzYJxWDV+1RCD2oKFM2mWr8V2RKppfbvXTgorh
	gpNdVEU3OV4r1PEs0Pbm9IIW1M9exM1yFW5DhWPPFLoa6ecemPqMwpaAA+m8blc9aWodCOGJqMhiQ
	30hl/fVQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5byZ-00GeKJ-1p;
	Fri, 18 Apr 2025 11:01:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 11:01:11 +0800
Date: Fri, 18 Apr 2025 11:01:11 +0800
Message-Id: <f0e71c0f0cf20a2736e4938c637bda12826e29bb.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 66/67] crypto: nx - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Also switch to the generic export format.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/nx/nx-aes-xcbc.c | 128 +++++++++-------------------
 drivers/crypto/nx/nx-sha256.c   | 130 ++++++++++++-----------------
 drivers/crypto/nx/nx-sha512.c   | 143 +++++++++++++-------------------
 drivers/crypto/nx/nx.c          |  15 ++--
 drivers/crypto/nx/nx.h          |   6 +-
 5 files changed, 161 insertions(+), 261 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-xcbc.c b/drivers/crypto/nx/nx-aes-xcbc.c
index eb5c8f689360..bf465d824e2c 100644
--- a/drivers/crypto/nx/nx-aes-xcbc.c
+++ b/drivers/crypto/nx/nx-aes-xcbc.c
@@ -7,13 +7,14 @@
  * Author: Kent Yoder <yoder1@us.ibm.com>
  */
 
-#include <crypto/internal/hash.h>
 #include <crypto/aes.h>
-#include <crypto/algapi.h>
+#include <crypto/internal/hash.h>
+#include <linux/atomic.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/types.h>
-#include <linux/crypto.h>
-#include <asm/vio.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
 
 #include "nx_csbcpb.h"
 #include "nx.h"
@@ -21,8 +22,6 @@
 
 struct xcbc_state {
 	u8 state[AES_BLOCK_SIZE];
-	unsigned int count;
-	u8 buffer[AES_BLOCK_SIZE];
 };
 
 static int nx_xcbc_set_key(struct crypto_shash *desc,
@@ -58,7 +57,7 @@ static int nx_xcbc_set_key(struct crypto_shash *desc,
  */
 static int nx_xcbc_empty(struct shash_desc *desc, u8 *out)
 {
-	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(&desc->tfm->base);
+	struct nx_crypto_ctx *nx_ctx = crypto_shash_ctx(desc->tfm);
 	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
 	struct nx_sg *in_sg, *out_sg;
 	u8 keys[2][AES_BLOCK_SIZE];
@@ -135,9 +134,9 @@ static int nx_xcbc_empty(struct shash_desc *desc, u8 *out)
 	return rc;
 }
 
-static int nx_crypto_ctx_aes_xcbc_init2(struct crypto_tfm *tfm)
+static int nx_crypto_ctx_aes_xcbc_init2(struct crypto_shash *tfm)
 {
-	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(tfm);
+	struct nx_crypto_ctx *nx_ctx = crypto_shash_ctx(tfm);
 	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
 	int err;
 
@@ -166,31 +165,24 @@ static int nx_xcbc_update(struct shash_desc *desc,
 			  const u8          *data,
 			  unsigned int       len)
 {
+	struct nx_crypto_ctx *nx_ctx = crypto_shash_ctx(desc->tfm);
 	struct xcbc_state *sctx = shash_desc_ctx(desc);
-	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(&desc->tfm->base);
 	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
 	struct nx_sg *in_sg;
 	struct nx_sg *out_sg;
-	u32 to_process = 0, leftover, total;
 	unsigned int max_sg_len;
 	unsigned long irq_flags;
+	u32 to_process, total;
 	int rc = 0;
 	int data_len;
 
 	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
 
+	memcpy(csbcpb->cpb.aes_xcbc.out_cv_mac, sctx->state, AES_BLOCK_SIZE);
+	NX_CPB_FDM(csbcpb) |= NX_FDM_INTERMEDIATE;
+	NX_CPB_FDM(csbcpb) |= NX_FDM_CONTINUATION;
 
-	total = sctx->count + len;
-
-	/* 2 cases for total data len:
-	 *  1: <= AES_BLOCK_SIZE: copy into state, return 0
-	 *  2: > AES_BLOCK_SIZE: process X blocks, copy in leftover
-	 */
-	if (total <= AES_BLOCK_SIZE) {
-		memcpy(sctx->buffer + sctx->count, data, len);
-		sctx->count += len;
-		goto out;
-	}
+	total = len;
 
 	in_sg = nx_ctx->in_sg;
 	max_sg_len = min_t(u64, nx_driver.of.max_sg_len/sizeof(struct nx_sg),
@@ -200,7 +192,7 @@ static int nx_xcbc_update(struct shash_desc *desc,
 
 	data_len = AES_BLOCK_SIZE;
 	out_sg = nx_build_sg_list(nx_ctx->out_sg, (u8 *)sctx->state,
-				  &len, nx_ctx->ap->sglen);
+				  &data_len, nx_ctx->ap->sglen);
 
 	if (data_len != AES_BLOCK_SIZE) {
 		rc = -EINVAL;
@@ -210,56 +202,21 @@ static int nx_xcbc_update(struct shash_desc *desc,
 	nx_ctx->op.outlen = (nx_ctx->out_sg - out_sg) * sizeof(struct nx_sg);
 
 	do {
-		to_process = total - to_process;
-		to_process = to_process & ~(AES_BLOCK_SIZE - 1);
+		to_process = total & ~(AES_BLOCK_SIZE - 1);
 
-		leftover = total - to_process;
-
-		/* the hardware will not accept a 0 byte operation for this
-		 * algorithm and the operation MUST be finalized to be correct.
-		 * So if we happen to get an update that falls on a block sized
-		 * boundary, we must save off the last block to finalize with
-		 * later. */
-		if (!leftover) {
-			to_process -= AES_BLOCK_SIZE;
-			leftover = AES_BLOCK_SIZE;
-		}
-
-		if (sctx->count) {
-			data_len = sctx->count;
-			in_sg = nx_build_sg_list(nx_ctx->in_sg,
-						(u8 *) sctx->buffer,
-						&data_len,
-						max_sg_len);
-			if (data_len != sctx->count) {
-				rc = -EINVAL;
-				goto out;
-			}
-		}
-
-		data_len = to_process - sctx->count;
 		in_sg = nx_build_sg_list(in_sg,
 					(u8 *) data,
-					&data_len,
+					&to_process,
 					max_sg_len);
 
-		if (data_len != to_process - sctx->count) {
-			rc = -EINVAL;
-			goto out;
-		}
-
 		nx_ctx->op.inlen = (nx_ctx->in_sg - in_sg) *
 					sizeof(struct nx_sg);
 
 		/* we've hit the nx chip previously and we're updating again,
 		 * so copy over the partial digest */
-		if (NX_CPB_FDM(csbcpb) & NX_FDM_CONTINUATION) {
-			memcpy(csbcpb->cpb.aes_xcbc.cv,
-				csbcpb->cpb.aes_xcbc.out_cv_mac,
-				AES_BLOCK_SIZE);
-		}
+		memcpy(csbcpb->cpb.aes_xcbc.cv,
+		       csbcpb->cpb.aes_xcbc.out_cv_mac, AES_BLOCK_SIZE);
 
-		NX_CPB_FDM(csbcpb) |= NX_FDM_INTERMEDIATE;
 		if (!nx_ctx->op.inlen || !nx_ctx->op.outlen) {
 			rc = -EINVAL;
 			goto out;
@@ -271,28 +228,24 @@ static int nx_xcbc_update(struct shash_desc *desc,
 
 		atomic_inc(&(nx_ctx->stats->aes_ops));
 
-		/* everything after the first update is continuation */
-		NX_CPB_FDM(csbcpb) |= NX_FDM_CONTINUATION;
-
 		total -= to_process;
-		data += to_process - sctx->count;
-		sctx->count = 0;
+		data += to_process;
 		in_sg = nx_ctx->in_sg;
-	} while (leftover > AES_BLOCK_SIZE);
+	} while (total >= AES_BLOCK_SIZE);
 
-	/* copy the leftover back into the state struct */
-	memcpy(sctx->buffer, data, leftover);
-	sctx->count = leftover;
+	rc = total;
+	memcpy(sctx->state, csbcpb->cpb.aes_xcbc.out_cv_mac, AES_BLOCK_SIZE);
 
 out:
 	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
 	return rc;
 }
 
-static int nx_xcbc_final(struct shash_desc *desc, u8 *out)
+static int nx_xcbc_finup(struct shash_desc *desc, const u8 *src,
+			 unsigned int nbytes, u8 *out)
 {
+	struct nx_crypto_ctx *nx_ctx = crypto_shash_ctx(desc->tfm);
 	struct xcbc_state *sctx = shash_desc_ctx(desc);
-	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(&desc->tfm->base);
 	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
 	struct nx_sg *in_sg, *out_sg;
 	unsigned long irq_flags;
@@ -301,12 +254,10 @@ static int nx_xcbc_final(struct shash_desc *desc, u8 *out)
 
 	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
 
-	if (NX_CPB_FDM(csbcpb) & NX_FDM_CONTINUATION) {
-		/* we've hit the nx chip previously, now we're finalizing,
-		 * so copy over the partial digest */
-		memcpy(csbcpb->cpb.aes_xcbc.cv,
-		       csbcpb->cpb.aes_xcbc.out_cv_mac, AES_BLOCK_SIZE);
-	} else if (sctx->count == 0) {
+	if (nbytes) {
+		/* non-zero final, so copy over the partial digest */
+		memcpy(csbcpb->cpb.aes_xcbc.cv, sctx->state, AES_BLOCK_SIZE);
+	} else {
 		/*
 		 * we've never seen an update, so this is a 0 byte op. The
 		 * hardware cannot handle a 0 byte op, so just ECB to
@@ -320,11 +271,11 @@ static int nx_xcbc_final(struct shash_desc *desc, u8 *out)
 	 * this is not an intermediate operation */
 	NX_CPB_FDM(csbcpb) &= ~NX_FDM_INTERMEDIATE;
 
-	len = sctx->count;
-	in_sg = nx_build_sg_list(nx_ctx->in_sg, (u8 *)sctx->buffer,
-				 &len, nx_ctx->ap->sglen);
+	len = nbytes;
+	in_sg = nx_build_sg_list(nx_ctx->in_sg, (u8 *)src, &len,
+				 nx_ctx->ap->sglen);
 
-	if (len != sctx->count) {
+	if (len != nbytes) {
 		rc = -EINVAL;
 		goto out;
 	}
@@ -362,18 +313,19 @@ struct shash_alg nx_shash_aes_xcbc_alg = {
 	.digestsize = AES_BLOCK_SIZE,
 	.init       = nx_xcbc_init,
 	.update     = nx_xcbc_update,
-	.final      = nx_xcbc_final,
+	.finup      = nx_xcbc_finup,
 	.setkey     = nx_xcbc_set_key,
 	.descsize   = sizeof(struct xcbc_state),
-	.statesize  = sizeof(struct xcbc_state),
+	.init_tfm   = nx_crypto_ctx_aes_xcbc_init2,
+	.exit_tfm   = nx_crypto_ctx_shash_exit,
 	.base       = {
 		.cra_name        = "xcbc(aes)",
 		.cra_driver_name = "xcbc-aes-nx",
 		.cra_priority    = 300,
+		.cra_flags	 = CRYPTO_AHASH_ALG_BLOCK_ONLY |
+				   CRYPTO_AHASH_ALG_FINAL_NONZERO,
 		.cra_blocksize   = AES_BLOCK_SIZE,
 		.cra_module      = THIS_MODULE,
 		.cra_ctxsize     = sizeof(struct nx_crypto_ctx),
-		.cra_init        = nx_crypto_ctx_aes_xcbc_init2,
-		.cra_exit        = nx_crypto_ctx_exit,
 	}
 };
diff --git a/drivers/crypto/nx/nx-sha256.c b/drivers/crypto/nx/nx-sha256.c
index c3bebf0feabe..5b29dd026df2 100644
--- a/drivers/crypto/nx/nx-sha256.c
+++ b/drivers/crypto/nx/nx-sha256.c
@@ -9,9 +9,12 @@
 
 #include <crypto/internal/hash.h>
 #include <crypto/sha2.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
-#include <asm/vio.h>
-#include <asm/byteorder.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+#include <linux/unaligned.h>
 
 #include "nx_csbcpb.h"
 #include "nx.h"
@@ -19,12 +22,11 @@
 struct sha256_state_be {
 	__be32 state[SHA256_DIGEST_SIZE / 4];
 	u64 count;
-	u8 buf[SHA256_BLOCK_SIZE];
 };
 
-static int nx_crypto_ctx_sha256_init(struct crypto_tfm *tfm)
+static int nx_crypto_ctx_sha256_init(struct crypto_shash *tfm)
 {
-	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(tfm);
+	struct nx_crypto_ctx *nx_ctx = crypto_shash_ctx(tfm);
 	int err;
 
 	err = nx_crypto_ctx_sha_init(tfm);
@@ -40,11 +42,10 @@ static int nx_crypto_ctx_sha256_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
-static int nx_sha256_init(struct shash_desc *desc) {
+static int nx_sha256_init(struct shash_desc *desc)
+{
 	struct sha256_state_be *sctx = shash_desc_ctx(desc);
 
-	memset(sctx, 0, sizeof *sctx);
-
 	sctx->state[0] = __cpu_to_be32(SHA256_H0);
 	sctx->state[1] = __cpu_to_be32(SHA256_H1);
 	sctx->state[2] = __cpu_to_be32(SHA256_H2);
@@ -61,30 +62,18 @@ static int nx_sha256_init(struct shash_desc *desc) {
 static int nx_sha256_update(struct shash_desc *desc, const u8 *data,
 			    unsigned int len)
 {
+	struct nx_crypto_ctx *nx_ctx = crypto_shash_ctx(desc->tfm);
 	struct sha256_state_be *sctx = shash_desc_ctx(desc);
-	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(&desc->tfm->base);
 	struct nx_csbcpb *csbcpb = (struct nx_csbcpb *)nx_ctx->csbcpb;
+	u64 to_process, leftover, total = len;
 	struct nx_sg *out_sg;
-	u64 to_process = 0, leftover, total;
 	unsigned long irq_flags;
 	int rc = 0;
 	int data_len;
 	u32 max_sg_len;
-	u64 buf_len = (sctx->count % SHA256_BLOCK_SIZE);
 
 	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
 
-	/* 2 cases for total data len:
-	 *  1: < SHA256_BLOCK_SIZE: copy into state, return 0
-	 *  2: >= SHA256_BLOCK_SIZE: process X blocks, copy in leftover
-	 */
-	total = (sctx->count % SHA256_BLOCK_SIZE) + len;
-	if (total < SHA256_BLOCK_SIZE) {
-		memcpy(sctx->buf + buf_len, data, len);
-		sctx->count += len;
-		goto out;
-	}
-
 	memcpy(csbcpb->cpb.sha256.message_digest, sctx->state, SHA256_DIGEST_SIZE);
 	NX_CPB_FDM(csbcpb) |= NX_FDM_INTERMEDIATE;
 	NX_CPB_FDM(csbcpb) |= NX_FDM_CONTINUATION;
@@ -105,41 +94,17 @@ static int nx_sha256_update(struct shash_desc *desc, const u8 *data,
 	}
 
 	do {
-		int used_sgs = 0;
 		struct nx_sg *in_sg = nx_ctx->in_sg;
 
-		if (buf_len) {
-			data_len = buf_len;
-			in_sg = nx_build_sg_list(in_sg,
-						 (u8 *) sctx->buf,
-						 &data_len,
-						 max_sg_len);
+		to_process = total & ~(SHA256_BLOCK_SIZE - 1);
 
-			if (data_len != buf_len) {
-				rc = -EINVAL;
-				goto out;
-			}
-			used_sgs = in_sg - nx_ctx->in_sg;
-		}
-
-		/* to_process: SHA256_BLOCK_SIZE aligned chunk to be
-		 * processed in this iteration. This value is restricted
-		 * by sg list limits and number of sgs we already used
-		 * for leftover data. (see above)
-		 * In ideal case, we could allow NX_PAGE_SIZE * max_sg_len,
-		 * but because data may not be aligned, we need to account
-		 * for that too. */
-		to_process = min_t(u64, total,
-			(max_sg_len - 1 - used_sgs) * NX_PAGE_SIZE);
-		to_process = to_process & ~(SHA256_BLOCK_SIZE - 1);
-
-		data_len = to_process - buf_len;
+		data_len = to_process;
 		in_sg = nx_build_sg_list(in_sg, (u8 *) data,
 					 &data_len, max_sg_len);
 
 		nx_ctx->op.inlen = (nx_ctx->in_sg - in_sg) * sizeof(struct nx_sg);
 
-		to_process = data_len + buf_len;
+		to_process = data_len;
 		leftover = total - to_process;
 
 		/*
@@ -162,26 +127,22 @@ static int nx_sha256_update(struct shash_desc *desc, const u8 *data,
 		atomic_inc(&(nx_ctx->stats->sha256_ops));
 
 		total -= to_process;
-		data += to_process - buf_len;
-		buf_len = 0;
-
+		data += to_process;
+		sctx->count += to_process;
 	} while (leftover >= SHA256_BLOCK_SIZE);
 
-	/* copy the leftover back into the state struct */
-	if (leftover)
-		memcpy(sctx->buf, data, leftover);
-
-	sctx->count += len;
+	rc = leftover;
 	memcpy(sctx->state, csbcpb->cpb.sha256.message_digest, SHA256_DIGEST_SIZE);
 out:
 	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
 	return rc;
 }
 
-static int nx_sha256_final(struct shash_desc *desc, u8 *out)
+static int nx_sha256_finup(struct shash_desc *desc, const u8 *src,
+			   unsigned int nbytes, u8 *out)
 {
+	struct nx_crypto_ctx *nx_ctx = crypto_shash_ctx(desc->tfm);
 	struct sha256_state_be *sctx = shash_desc_ctx(desc);
-	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(&desc->tfm->base);
 	struct nx_csbcpb *csbcpb = (struct nx_csbcpb *)nx_ctx->csbcpb;
 	struct nx_sg *in_sg, *out_sg;
 	unsigned long irq_flags;
@@ -197,25 +158,19 @@ static int nx_sha256_final(struct shash_desc *desc, u8 *out)
 			nx_ctx->ap->databytelen/NX_PAGE_SIZE);
 
 	/* final is represented by continuing the operation and indicating that
-	 * this is not an intermediate operation */
-	if (sctx->count >= SHA256_BLOCK_SIZE) {
-		/* we've hit the nx chip previously, now we're finalizing,
-		 * so copy over the partial digest */
-		memcpy(csbcpb->cpb.sha256.input_partial_digest, sctx->state, SHA256_DIGEST_SIZE);
-		NX_CPB_FDM(csbcpb) &= ~NX_FDM_INTERMEDIATE;
-		NX_CPB_FDM(csbcpb) |= NX_FDM_CONTINUATION;
-	} else {
-		NX_CPB_FDM(csbcpb) &= ~NX_FDM_INTERMEDIATE;
-		NX_CPB_FDM(csbcpb) &= ~NX_FDM_CONTINUATION;
-	}
+	 * this is not an intermediate operation
+	 * copy over the partial digest */
+	memcpy(csbcpb->cpb.sha256.input_partial_digest, sctx->state, SHA256_DIGEST_SIZE);
+	NX_CPB_FDM(csbcpb) &= ~NX_FDM_INTERMEDIATE;
+	NX_CPB_FDM(csbcpb) |= NX_FDM_CONTINUATION;
 
+	sctx->count += nbytes;
 	csbcpb->cpb.sha256.message_bit_length = (u64) (sctx->count * 8);
 
-	len = sctx->count & (SHA256_BLOCK_SIZE - 1);
-	in_sg = nx_build_sg_list(nx_ctx->in_sg, (u8 *) sctx->buf,
-				 &len, max_sg_len);
+	len = nbytes;
+	in_sg = nx_build_sg_list(nx_ctx->in_sg, (u8 *)src, &len, max_sg_len);
 
-	if (len != (sctx->count & (SHA256_BLOCK_SIZE - 1))) {
+	if (len != nbytes) {
 		rc = -EINVAL;
 		goto out;
 	}
@@ -251,18 +206,34 @@ static int nx_sha256_final(struct shash_desc *desc, u8 *out)
 static int nx_sha256_export(struct shash_desc *desc, void *out)
 {
 	struct sha256_state_be *sctx = shash_desc_ctx(desc);
+	union {
+		u8 *u8;
+		u32 *u32;
+		u64 *u64;
+	} p = { .u8 = out };
+	int i;
 
-	memcpy(out, sctx, sizeof(*sctx));
+	for (i = 0; i < SHA256_DIGEST_SIZE / sizeof(*p.u32); i++)
+		put_unaligned(be32_to_cpu(sctx->state[i]), p.u32++);
 
+	put_unaligned(sctx->count, p.u64++);
 	return 0;
 }
 
 static int nx_sha256_import(struct shash_desc *desc, const void *in)
 {
 	struct sha256_state_be *sctx = shash_desc_ctx(desc);
+	union {
+		const u8 *u8;
+		const u32 *u32;
+		const u64 *u64;
+	} p = { .u8 = in };
+	int i;
 
-	memcpy(sctx, in, sizeof(*sctx));
+	for (i = 0; i < SHA256_DIGEST_SIZE / sizeof(*p.u32); i++)
+		sctx->state[i] = cpu_to_be32(get_unaligned(p.u32++));
 
+	sctx->count = get_unaligned(p.u64++);
 	return 0;
 }
 
@@ -270,19 +241,20 @@ struct shash_alg nx_shash_sha256_alg = {
 	.digestsize = SHA256_DIGEST_SIZE,
 	.init       = nx_sha256_init,
 	.update     = nx_sha256_update,
-	.final      = nx_sha256_final,
+	.finup      = nx_sha256_finup,
 	.export     = nx_sha256_export,
 	.import     = nx_sha256_import,
+	.init_tfm   = nx_crypto_ctx_sha256_init,
+	.exit_tfm   = nx_crypto_ctx_shash_exit,
 	.descsize   = sizeof(struct sha256_state_be),
 	.statesize  = sizeof(struct sha256_state_be),
 	.base       = {
 		.cra_name        = "sha256",
 		.cra_driver_name = "sha256-nx",
 		.cra_priority    = 300,
+		.cra_flags	 = CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize   = SHA256_BLOCK_SIZE,
 		.cra_module      = THIS_MODULE,
 		.cra_ctxsize     = sizeof(struct nx_crypto_ctx),
-		.cra_init        = nx_crypto_ctx_sha256_init,
-		.cra_exit        = nx_crypto_ctx_exit,
 	}
 };
diff --git a/drivers/crypto/nx/nx-sha512.c b/drivers/crypto/nx/nx-sha512.c
index 1ffb40d2c324..f74776b7d7d7 100644
--- a/drivers/crypto/nx/nx-sha512.c
+++ b/drivers/crypto/nx/nx-sha512.c
@@ -9,8 +9,12 @@
 
 #include <crypto/internal/hash.h>
 #include <crypto/sha2.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
-#include <asm/vio.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+#include <linux/unaligned.h>
 
 #include "nx_csbcpb.h"
 #include "nx.h"
@@ -18,12 +22,11 @@
 struct sha512_state_be {
 	__be64 state[SHA512_DIGEST_SIZE / 8];
 	u64 count[2];
-	u8 buf[SHA512_BLOCK_SIZE];
 };
 
-static int nx_crypto_ctx_sha512_init(struct crypto_tfm *tfm)
+static int nx_crypto_ctx_sha512_init(struct crypto_shash *tfm)
 {
-	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(tfm);
+	struct nx_crypto_ctx *nx_ctx = crypto_shash_ctx(tfm);
 	int err;
 
 	err = nx_crypto_ctx_sha_init(tfm);
@@ -43,8 +46,6 @@ static int nx_sha512_init(struct shash_desc *desc)
 {
 	struct sha512_state_be *sctx = shash_desc_ctx(desc);
 
-	memset(sctx, 0, sizeof *sctx);
-
 	sctx->state[0] = __cpu_to_be64(SHA512_H0);
 	sctx->state[1] = __cpu_to_be64(SHA512_H1);
 	sctx->state[2] = __cpu_to_be64(SHA512_H2);
@@ -54,6 +55,7 @@ static int nx_sha512_init(struct shash_desc *desc)
 	sctx->state[6] = __cpu_to_be64(SHA512_H6);
 	sctx->state[7] = __cpu_to_be64(SHA512_H7);
 	sctx->count[0] = 0;
+	sctx->count[1] = 0;
 
 	return 0;
 }
@@ -61,30 +63,18 @@ static int nx_sha512_init(struct shash_desc *desc)
 static int nx_sha512_update(struct shash_desc *desc, const u8 *data,
 			    unsigned int len)
 {
+	struct nx_crypto_ctx *nx_ctx = crypto_shash_ctx(desc->tfm);
 	struct sha512_state_be *sctx = shash_desc_ctx(desc);
-	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(&desc->tfm->base);
 	struct nx_csbcpb *csbcpb = (struct nx_csbcpb *)nx_ctx->csbcpb;
+	u64 to_process, leftover, total = len;
 	struct nx_sg *out_sg;
-	u64 to_process, leftover = 0, total;
 	unsigned long irq_flags;
 	int rc = 0;
 	int data_len;
 	u32 max_sg_len;
-	u64 buf_len = (sctx->count[0] % SHA512_BLOCK_SIZE);
 
 	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
 
-	/* 2 cases for total data len:
-	 *  1: < SHA512_BLOCK_SIZE: copy into state, return 0
-	 *  2: >= SHA512_BLOCK_SIZE: process X blocks, copy in leftover
-	 */
-	total = (sctx->count[0] % SHA512_BLOCK_SIZE) + len;
-	if (total < SHA512_BLOCK_SIZE) {
-		memcpy(sctx->buf + buf_len, data, len);
-		sctx->count[0] += len;
-		goto out;
-	}
-
 	memcpy(csbcpb->cpb.sha512.message_digest, sctx->state, SHA512_DIGEST_SIZE);
 	NX_CPB_FDM(csbcpb) |= NX_FDM_INTERMEDIATE;
 	NX_CPB_FDM(csbcpb) |= NX_FDM_CONTINUATION;
@@ -105,45 +95,17 @@ static int nx_sha512_update(struct shash_desc *desc, const u8 *data,
 	}
 
 	do {
-		int used_sgs = 0;
 		struct nx_sg *in_sg = nx_ctx->in_sg;
 
-		if (buf_len) {
-			data_len = buf_len;
-			in_sg = nx_build_sg_list(in_sg,
-						 (u8 *) sctx->buf,
-						 &data_len, max_sg_len);
+		to_process = total & ~(SHA512_BLOCK_SIZE - 1);
 
-			if (data_len != buf_len) {
-				rc = -EINVAL;
-				goto out;
-			}
-			used_sgs = in_sg - nx_ctx->in_sg;
-		}
-
-		/* to_process: SHA512_BLOCK_SIZE aligned chunk to be
-		 * processed in this iteration. This value is restricted
-		 * by sg list limits and number of sgs we already used
-		 * for leftover data. (see above)
-		 * In ideal case, we could allow NX_PAGE_SIZE * max_sg_len,
-		 * but because data may not be aligned, we need to account
-		 * for that too. */
-		to_process = min_t(u64, total,
-			(max_sg_len - 1 - used_sgs) * NX_PAGE_SIZE);
-		to_process = to_process & ~(SHA512_BLOCK_SIZE - 1);
-
-		data_len = to_process - buf_len;
+		data_len = to_process;
 		in_sg = nx_build_sg_list(in_sg, (u8 *) data,
 					 &data_len, max_sg_len);
 
 		nx_ctx->op.inlen = (nx_ctx->in_sg - in_sg) * sizeof(struct nx_sg);
 
-		if (data_len != (to_process - buf_len)) {
-			rc = -EINVAL;
-			goto out;
-		}
-
-		to_process = data_len + buf_len;
+		to_process = data_len;
 		leftover = total - to_process;
 
 		/*
@@ -166,30 +128,29 @@ static int nx_sha512_update(struct shash_desc *desc, const u8 *data,
 		atomic_inc(&(nx_ctx->stats->sha512_ops));
 
 		total -= to_process;
-		data += to_process - buf_len;
-		buf_len = 0;
-
+		data += to_process;
+		sctx->count[0] += to_process;
+		if (sctx->count[0] < to_process)
+			sctx->count[1]++;
 	} while (leftover >= SHA512_BLOCK_SIZE);
 
-	/* copy the leftover back into the state struct */
-	if (leftover)
-		memcpy(sctx->buf, data, leftover);
-	sctx->count[0] += len;
+	rc = leftover;
 	memcpy(sctx->state, csbcpb->cpb.sha512.message_digest, SHA512_DIGEST_SIZE);
 out:
 	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
 	return rc;
 }
 
-static int nx_sha512_final(struct shash_desc *desc, u8 *out)
+static int nx_sha512_finup(struct shash_desc *desc, const u8 *src,
+			   unsigned int nbytes, u8 *out)
 {
 	struct sha512_state_be *sctx = shash_desc_ctx(desc);
-	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(&desc->tfm->base);
+	struct nx_crypto_ctx *nx_ctx = crypto_shash_ctx(desc->tfm);
 	struct nx_csbcpb *csbcpb = (struct nx_csbcpb *)nx_ctx->csbcpb;
 	struct nx_sg *in_sg, *out_sg;
 	u32 max_sg_len;
-	u64 count0;
 	unsigned long irq_flags;
+	u64 count0, count1;
 	int rc = 0;
 	int len;
 
@@ -201,30 +162,23 @@ static int nx_sha512_final(struct shash_desc *desc, u8 *out)
 			nx_ctx->ap->databytelen/NX_PAGE_SIZE);
 
 	/* final is represented by continuing the operation and indicating that
-	 * this is not an intermediate operation */
-	if (sctx->count[0] >= SHA512_BLOCK_SIZE) {
-		/* we've hit the nx chip previously, now we're finalizing,
-		 * so copy over the partial digest */
-		memcpy(csbcpb->cpb.sha512.input_partial_digest, sctx->state,
-							SHA512_DIGEST_SIZE);
-		NX_CPB_FDM(csbcpb) &= ~NX_FDM_INTERMEDIATE;
-		NX_CPB_FDM(csbcpb) |= NX_FDM_CONTINUATION;
-	} else {
-		NX_CPB_FDM(csbcpb) &= ~NX_FDM_INTERMEDIATE;
-		NX_CPB_FDM(csbcpb) &= ~NX_FDM_CONTINUATION;
-	}
-
+	 * this is not an intermediate operation
+	 * copy over the partial digest */
+	memcpy(csbcpb->cpb.sha512.input_partial_digest, sctx->state, SHA512_DIGEST_SIZE);
 	NX_CPB_FDM(csbcpb) &= ~NX_FDM_INTERMEDIATE;
+	NX_CPB_FDM(csbcpb) |= NX_FDM_CONTINUATION;
 
-	count0 = sctx->count[0] * 8;
+	count0 = sctx->count[0] + nbytes;
+	count1 = sctx->count[1];
 
-	csbcpb->cpb.sha512.message_bit_length_lo = count0;
+	csbcpb->cpb.sha512.message_bit_length_lo = count0 << 3;
+	csbcpb->cpb.sha512.message_bit_length_hi = (count1 << 3) |
+						   (count0 >> 61);
 
-	len = sctx->count[0] & (SHA512_BLOCK_SIZE - 1);
-	in_sg = nx_build_sg_list(nx_ctx->in_sg, sctx->buf, &len,
-				 max_sg_len);
+	len = nbytes;
+	in_sg = nx_build_sg_list(nx_ctx->in_sg, (u8 *)src, &len, max_sg_len);
 
-	if (len != (sctx->count[0] & (SHA512_BLOCK_SIZE - 1))) {
+	if (len != nbytes) {
 		rc = -EINVAL;
 		goto out;
 	}
@@ -246,7 +200,7 @@ static int nx_sha512_final(struct shash_desc *desc, u8 *out)
 		goto out;
 
 	atomic_inc(&(nx_ctx->stats->sha512_ops));
-	atomic64_add(sctx->count[0], &(nx_ctx->stats->sha512_bytes));
+	atomic64_add(count0, &(nx_ctx->stats->sha512_bytes));
 
 	memcpy(out, csbcpb->cpb.sha512.message_digest, SHA512_DIGEST_SIZE);
 out:
@@ -257,18 +211,34 @@ static int nx_sha512_final(struct shash_desc *desc, u8 *out)
 static int nx_sha512_export(struct shash_desc *desc, void *out)
 {
 	struct sha512_state_be *sctx = shash_desc_ctx(desc);
+	union {
+		u8 *u8;
+		u64 *u64;
+	} p = { .u8 = out };
+	int i;
 
-	memcpy(out, sctx, sizeof(*sctx));
+	for (i = 0; i < SHA512_DIGEST_SIZE / sizeof(*p.u64); i++)
+		put_unaligned(be64_to_cpu(sctx->state[i]), p.u64++);
 
+	put_unaligned(sctx->count[0], p.u64++);
+	put_unaligned(sctx->count[1], p.u64++);
 	return 0;
 }
 
 static int nx_sha512_import(struct shash_desc *desc, const void *in)
 {
 	struct sha512_state_be *sctx = shash_desc_ctx(desc);
+	union {
+		const u8 *u8;
+		const u64 *u64;
+	} p = { .u8 = in };
+	int i;
 
-	memcpy(sctx, in, sizeof(*sctx));
+	for (i = 0; i < SHA512_DIGEST_SIZE / sizeof(*p.u64); i++)
+		sctx->state[i] = cpu_to_be64(get_unaligned(p.u64++));
 
+	sctx->count[0] = get_unaligned(p.u64++);
+	sctx->count[1] = get_unaligned(p.u64++);
 	return 0;
 }
 
@@ -276,19 +246,20 @@ struct shash_alg nx_shash_sha512_alg = {
 	.digestsize = SHA512_DIGEST_SIZE,
 	.init       = nx_sha512_init,
 	.update     = nx_sha512_update,
-	.final      = nx_sha512_final,
+	.finup      = nx_sha512_finup,
 	.export     = nx_sha512_export,
 	.import     = nx_sha512_import,
+	.init_tfm   = nx_crypto_ctx_sha512_init,
+	.exit_tfm   = nx_crypto_ctx_shash_exit,
 	.descsize   = sizeof(struct sha512_state_be),
 	.statesize  = sizeof(struct sha512_state_be),
 	.base       = {
 		.cra_name        = "sha512",
 		.cra_driver_name = "sha512-nx",
 		.cra_priority    = 300,
+		.cra_flags	 = CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize   = SHA512_BLOCK_SIZE,
 		.cra_module      = THIS_MODULE,
 		.cra_ctxsize     = sizeof(struct nx_crypto_ctx),
-		.cra_init        = nx_crypto_ctx_sha512_init,
-		.cra_exit        = nx_crypto_ctx_exit,
 	}
 };
diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index 4e4a371ba390..78135fb13f5c 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -124,8 +124,6 @@ struct nx_sg *nx_build_sg_list(struct nx_sg *sg_head,
 		}
 
 		if ((sg - sg_head) == sgmax) {
-			pr_err("nx: scatter/gather list overflow, pid: %d\n",
-			       current->pid);
 			sg++;
 			break;
 		}
@@ -702,14 +700,14 @@ int nx_crypto_ctx_aes_ecb_init(struct crypto_skcipher *tfm)
 				  NX_MODE_AES_ECB);
 }
 
-int nx_crypto_ctx_sha_init(struct crypto_tfm *tfm)
+int nx_crypto_ctx_sha_init(struct crypto_shash *tfm)
 {
-	return nx_crypto_ctx_init(crypto_tfm_ctx(tfm), NX_FC_SHA, NX_MODE_SHA);
+	return nx_crypto_ctx_init(crypto_shash_ctx(tfm), NX_FC_SHA, NX_MODE_SHA);
 }
 
-int nx_crypto_ctx_aes_xcbc_init(struct crypto_tfm *tfm)
+int nx_crypto_ctx_aes_xcbc_init(struct crypto_shash *tfm)
 {
-	return nx_crypto_ctx_init(crypto_tfm_ctx(tfm), NX_FC_AES,
+	return nx_crypto_ctx_init(crypto_shash_ctx(tfm), NX_FC_AES,
 				  NX_MODE_AES_XCBC_MAC);
 }
 
@@ -744,6 +742,11 @@ void nx_crypto_ctx_aead_exit(struct crypto_aead *tfm)
 	kfree_sensitive(nx_ctx->kmem);
 }
 
+void nx_crypto_ctx_shash_exit(struct crypto_shash *tfm)
+{
+	nx_crypto_ctx_exit(crypto_shash_ctx(tfm));
+}
+
 static int nx_probe(struct vio_dev *viodev, const struct vio_device_id *id)
 {
 	dev_dbg(&viodev->dev, "driver probed: %s resource id: 0x%x\n",
diff --git a/drivers/crypto/nx/nx.h b/drivers/crypto/nx/nx.h
index b1f6634a1644..36974f08490a 100644
--- a/drivers/crypto/nx/nx.h
+++ b/drivers/crypto/nx/nx.h
@@ -3,6 +3,7 @@
 #ifndef __NX_H__
 #define __NX_H__
 
+#include <asm/vio.h>
 #include <crypto/ctr.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/hash.h>
@@ -147,14 +148,15 @@ struct scatterlist;
 /* prototypes */
 int nx_crypto_ctx_aes_ccm_init(struct crypto_aead *tfm);
 int nx_crypto_ctx_aes_gcm_init(struct crypto_aead *tfm);
-int nx_crypto_ctx_aes_xcbc_init(struct crypto_tfm *tfm);
+int nx_crypto_ctx_aes_xcbc_init(struct crypto_shash *tfm);
 int nx_crypto_ctx_aes_ctr_init(struct crypto_skcipher *tfm);
 int nx_crypto_ctx_aes_cbc_init(struct crypto_skcipher *tfm);
 int nx_crypto_ctx_aes_ecb_init(struct crypto_skcipher *tfm);
-int nx_crypto_ctx_sha_init(struct crypto_tfm *tfm);
+int nx_crypto_ctx_sha_init(struct crypto_shash *tfm);
 void nx_crypto_ctx_exit(struct crypto_tfm *tfm);
 void nx_crypto_ctx_skcipher_exit(struct crypto_skcipher *tfm);
 void nx_crypto_ctx_aead_exit(struct crypto_aead *tfm);
+void nx_crypto_ctx_shash_exit(struct crypto_shash *tfm);
 void nx_ctx_init(struct nx_crypto_ctx *nx_ctx, unsigned int function);
 int nx_hcall_sync(struct nx_crypto_ctx *ctx, struct vio_pfo_op *op,
 		  u32 may_sleep);
-- 
2.39.5

