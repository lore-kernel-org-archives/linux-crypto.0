Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795840860;
	b=Y7Tl+t3FrpczJqKdzs6MyNbrEoCDhc7YCfDAVfBAbdmyQmYKgc5oyUKz2rCBdBW5kf8V
	 fTHTlsuleLYz94bh4gcHncJTB1skrYQ5stDh/6b71Rx+BGcBmJ8GrBZMSxrP5ftdte9ZS
	 tUqr1Qhzlo/6VNlqsIHnFxUevcJC8VBvWkq82QFu8cWi96LMvc4vXXc/jJYhdf7Gp4RGR
	 ahdjb28fb2EPVVpIHMb/M+6SApHE5VIH3JdTWFl5bEw2104IePh408MfpQFKNgw38m/5t
	 qtudene67WwvOAsbuiHL15fnK5rnRlbSRIIONyl2p/Px//ZPWInVFRlByfy4tB7zTfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795840860;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/e+gjhDDPVzKO+nGeln/tg0bHCY2Xhqwfq54kBjeRsw=;
	b=TSvWxavkzUNLxnOPZmBxkONnAgx4+onM9FSWyFw2t5v5XgbS/pWQO3ZZIOHzDyTLqiAg
	 q66OCRQh3Vh7I5e8MseD2SpPe7HlY1mUpudmgSgI9XS9zbZGYYWitulYAXfQR2eYkQ7PM
	 dp+agcMArTUYwNKAwbimuejWzo0Xb8gQcm2k+19MAc5SDzZNqKyvUkK/FHXiJYwObICEy
	 5wRwnCvTV/ofjZ/4tBuXcpeVDOz35zG79qYNxJ3/W025x5NZ6scMDMp7kLdmHBjzeUdOf
	 FaJgra1HCCxG1jAL4GqVX7eCIJuwQhsIuwhbenmelOIxXlyyApMhH5ZfvhAPmeJ/Mjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ojLIuJia;
	arc=none smtp.remote-ip=209.85.215.175
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0944606A31C
	for <linux-crypto@vger.kernel.org>; Sat, 28 Nov 2026 04:40:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0944606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ojLIuJia
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-ccca948203aso5998476a12.3
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 20:40:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795840859; x=1796445659; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/e+gjhDDPVzKO+nGeln/tg0bHCY2Xhqwfq54kBjeRsw=;
        b=ojLIuJiayorJtF2ZjT9RTAIhV7/BwK9jEkCXQ7ktudSdKHVGkuxbUcqP6F8DImGtnf
         6H3VtJuXk5ePRx0WUS74T+KBRYP65QjeLS2xtOAH7Ywc4rA0YpyE5OMHPV9SDUaai9lo
         5CRRTIXulydqHi1TFAagEJBQQ/VuhHZvivR9iNKUcCIojKKWv4WzJ8u1tZhhW9kTmLuk
         rnVb20xDw3otSUhgt3+Oqe+y4Txq+4F1JzAg8yab/+IgH81o3QcH7qCyWoa8/gFvFjq6
         zxhfe6wcxLaX9Btfaq84187C25n+7uQBEi25QajDc4duXNlfYpZJYitZ/pvgG4ggvszy
         2x0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795840859; x=1796445659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/e+gjhDDPVzKO+nGeln/tg0bHCY2Xhqwfq54kBjeRsw=;
        b=Y1ykxR0uU7rcameeuhg/jY32dsb9lg/Xm4DCEY7hajvg23od56Kk45SRsn32JYhQ5j
         9FIFD/DlwgTEPXzY4XCf/uy7dgOf6xoY0mS51lVF8b2CSQS87FzVvjkncNdWmkViHYUN
         CM2aObuKtWQaV1EWKvbGJxfjuoBRuKrBzzBVsCKGL1UAHZf6rQ8Vd6aAVoINe/Nxg10W
         nbIEXbKZ6u5iqByofSLrv0bYaTqLdiXYEnCqO7bCXPMp3jwzvC6hyvubE+jRfLECcJN4
         98546kC+j+9SS+a0zcpqxFKNMz5r986t/sVdzben7jWq03dsNAFnmt4IFoXBDMRc5TQd
         czkQ==
X-Gm-Message-State: APuU4Z8dcfKBi2n72YBBX72sC5ski+/ZLbnobKNy+5IiNXvWnWBb9zEl
	PpySCG1Ol8/aDjn5W9QvOMZhMn8RfeXV/z1Srj4htQ+uegGPEnPRGVqfZHEt2w==
X-Gm-Gg: AZFdTZcL8gmLDm/yX98jmVi2f1vrwwsnLpV29SVQJuQrCHH3Gxv/5IPEj5GU2JCVLWV
	1640kk66wYlCz/U3X9P8Q+Dq+1mpr2PC3iRiIpttAF2mw6dcoU3bRwS6FL+wLWxdnjGcJUFSQwi
	B+DxXwpoGoU2/2XHv6WGnXoX1jJb/TRKe8/bDTjmU3VOkKNmgWpCHl/qOCjofG3kGGzxlK2ym0N
	EaBFOcaBheK7aHiO1n5olKWbeXyByQpj16WqQOwEXVSVOm/UszH8w7AphOZJ2VUGzD8EKFsWOYW
	fTIsMlQIYfnS7UG9XxU5TTKqDKe5MVaQP/vfGF1d3+F4/a0J8yHHuJPtYn6CK2olFLA49Mr+5ZD
	t2H1bD1eQgcdMRA82tdNCXS3R3kkzv1AnDDGohxgNsQk08qozkvBMQ/2y9rCgs/veVGFwloQ1ZO
	qi3rY92H6YA7ViOZ80VWW+5L/a5gEiU8qDWpFeHw6z5BiRMFFDS2sP+W42jWjA9B4X42mdDIOJH
	ofRSpS2fYOcuNMtAX2BkmDHs8XNZtcVelOiClK4fWbep13YnpYWU7gxTxD3T9zYm+NmAPFduPGx
	8kspUx1M0JRGX7/aMifTjb3IetDFI0bIf5L2SGZcvgj1TBnA0sXBJGGm1nY90lhrA8C+iJXUXqq
	4436LneR1ZzGWPrKW+JDu2+7jq3d2o9UrPqagHnP6Se7b1QbVqH+xlkA0UQX7jTCCsQtRdAslFM
	WSOg==
X-Received: by 2002:a17:90b:2f8f:b0:3b3:ba43:54c3 with SMTP id 98e67ed59e1d1-3b41c942998mr23629818a91.33.1795840858936;
        Fri, 27 Nov 2026 20:40:58 -0800 (PST)
Received: from ryzen.lan ([2601:644:8000:37f::e34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41abb1b66sm42716729a91.1.2026.11.27.20.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 20:40:58 -0800 (PST)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Rosen Penev <rosenp@gmail.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Romain Perier <romain.perier@free-electrons.com>,
	stable@vger.kernel.org
Subject: [PATCH 4/8] crypto: cesa - finish the HMAC outer hash when padding by hand
Date: Fri, 27 Nov 2026 20:40:46 -0800
Message-ID: <20261128044050.722617-5-rosenp@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261128044050.722617-1-rosenp@gmail.com>
References: <20261128044050.722617-1-rosenp@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The engine applies the HMAC outer hash only when it finalises the
message itself, i.e. on a last or unfragmented operation that has data
and whose total length fits the descriptor field (0xffff). Otherwise
the driver pads the message by hand and runs the padding as a middle
fragment, which leaves the engine with a plain inner hash state. For
HMAC that is wrong twice over:

 - the padding encodes the message length only, while the inner hash
   also covers the ipad block, and
 - the outer hash is never computed, so the result read back from the
   IVDIG registers is H(ipad || m) instead of HMAC(k, m).

This hits every HMAC whose last request has no data left to hash, i.e.
any update()/final() sequence over a block-aligned length and any
finup() or digest() of an empty message, and every HMAC of 64 KiB or
more.

Count the ipad block in the manual padding of HMAC requests, and when
the result comes from the IVDIG registers on the last request of an
HMAC, finish the outer hash in software: import the opad state computed
at setkey time into a software hash, with one block already counted,
and hash the inner digest. Each HMAC transform allocates that software
hash at cra_init(). Select the software hashes so they are always
available.

Verified on an Armada 385 (WRT3200ACM) against the software HMACs,
single threaded with random lengths and update splits: about 0.5% of
HMAC-SHA1 and HMAC-SHA256 digests were wrong before, all of them with a
block-aligned total length, and none of about 195000 after, nor of
30000 more with lengths up to 140000 bytes. HMAC-MD5 was not tested:
the test kernel has no software MD5.

Fixes: db509a45339f ("crypto: marvell/cesa - add TDMA support")
Cc: stable@vger.kernel.org
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/marvell/Kconfig     |   3 +
 drivers/crypto/marvell/cesa/cesa.h |   9 +++
 drivers/crypto/marvell/cesa/hash.c | 113 +++++++++++++++++++++++++++--
 3 files changed, 119 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/marvell/Kconfig b/drivers/crypto/marvell/Kconfig
index aa269abb0499..965061abec3c 100644
--- a/drivers/crypto/marvell/Kconfig
+++ b/drivers/crypto/marvell/Kconfig
@@ -12,6 +12,9 @@ config CRYPTO_DEV_MARVELL_CESA
 	select CRYPTO_LIB_DES
 	select CRYPTO_SKCIPHER
 	select CRYPTO_HASH
+	select CRYPTO_MD5
+	select CRYPTO_SHA1
+	select CRYPTO_SHA256
 	select SRAM
 	select CRYPTO_DEV_MARVELL
 	help
diff --git a/drivers/crypto/marvell/cesa/cesa.h b/drivers/crypto/marvell/cesa/cesa.h
index 44351b252861..906d55fb6a3a 100644
--- a/drivers/crypto/marvell/cesa/cesa.h
+++ b/drivers/crypto/marvell/cesa/cesa.h
@@ -514,12 +514,15 @@ struct mv_cesa_hash_ctx {
  * struct mv_cesa_hash_ctx - CESA hmac operation context
  * @base:	base context structure
  * @iv:		initialization vectors
+ * @outer:	software hash used to finish the outer hash when the engine
+ *		could not finalise the message itself
  *
  * HMAC context structure.
  */
 struct mv_cesa_hmac_ctx {
 	struct mv_cesa_ctx base;
 	__be32 iv[16];
+	struct crypto_shash *outer;
 };
 
 /**
@@ -609,6 +612,10 @@ struct mv_cesa_ahash_dma_req {
  * @src_nents:		number of entries in the scatterlist
  * @last_req:		define whether the current operation is the last one
  *			or not
+ * @hmac:		HMAC request: manual padding must account for the ipad
+ *			block and the outer hash is finished in software
+ * @sw_outer:		the driver padded the last request by hand, so the
+ *			engine did not apply the HMAC outer hash
  * @state:		hash state
  */
 struct mv_cesa_ahash_req {
@@ -624,6 +631,8 @@ struct mv_cesa_ahash_req {
 	int src_nents;
 	bool last_req;
 	bool algo_le;
+	bool hmac;
+	bool sw_outer;
 	u32 state[8];
 };
 
diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index 9fd3d5c32312..f6894ed7c1cc 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -140,6 +140,14 @@ static int mv_cesa_ahash_pad_len(struct mv_cesa_ahash_req *creq)
 static int mv_cesa_ahash_pad_req(struct mv_cesa_ahash_req *creq, u8 *buf)
 {
 	unsigned int padlen;
+	u64 len = creq->len;
+
+	/* The HMAC inner hash also covers the ipad block. */
+	if (creq->hmac)
+		len += CESA_MAX_HASH_BLOCK_SIZE;
+
+	/* The engine will not apply the HMAC outer hash to this. */
+	creq->sw_outer = true;
 
 	buf[0] = 0x80;
 	/* Pad out to 56 mod 64 */
@@ -147,11 +155,11 @@ static int mv_cesa_ahash_pad_req(struct mv_cesa_ahash_req *creq, u8 *buf)
 	memset(buf + 1, 0, padlen - 1);
 
 	if (creq->algo_le) {
-		__le64 bits = cpu_to_le64(creq->len << 3);
+		__le64 bits = cpu_to_le64(len << 3);
 
 		memcpy(buf + padlen, &bits, sizeof(bits));
 	} else {
-		__be64 bits = cpu_to_be64(creq->len << 3);
+		__be64 bits = cpu_to_be64(len << 3);
 
 		memcpy(buf + padlen, &bits, sizeof(bits));
 	}
@@ -353,6 +361,59 @@ static int mv_cesa_ahash_process(struct crypto_async_request *req, u32 status)
 	return mv_cesa_ahash_std_process(ahashreq, status);
 }
 
+/*
+ * The engine only applies the HMAC outer hash when it finalises the message
+ * itself. When the driver had to pad by hand instead (no data left for the
+ * last fragment, or a message longer than the engine's total length field),
+ * the IVDIG registers hold the inner digest. Finish the outer hash in
+ * software, starting from the opad state computed at setkey time.
+ */
+static void mv_cesa_ahmac_outer(struct ahash_request *req)
+{
+	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	unsigned int digsize = crypto_ahash_digestsize(crypto_ahash_reqtfm(req));
+	SHASH_DESC_ON_STACK(desc, ctx->outer);
+	u8 inner[SHA256_DIGEST_SIZE];
+	union {
+		struct md5_state md5;
+		struct sha1_state sha1;
+		struct sha256_state sha256;
+	} st = {};
+	u32 *state;
+	u64 *count;
+	int i, ret;
+
+	switch (digsize) {
+	case MD5_DIGEST_SIZE:
+		state = st.md5.hash;
+		count = &st.md5.byte_count;
+		break;
+	case SHA1_DIGEST_SIZE:
+		state = st.sha1.state;
+		count = &st.sha1.count;
+		break;
+	default:
+		state = st.sha256.state;
+		count = &st.sha256.count;
+		break;
+	}
+
+	for (i = 0; i < digsize / 4; i++)
+		state[i] = be32_to_cpu(ctx->iv[8 + i]);
+	*count = CESA_MAX_HASH_BLOCK_SIZE;
+
+	memcpy(inner, req->result, digsize);
+	desc->tfm = ctx->outer;
+	ret = crypto_shash_import_core(desc, &st);
+	if (!ret)
+		ret = crypto_shash_finup(desc, inner, digsize, req->result);
+	WARN_ON_ONCE(ret);
+
+	shash_desc_zero(desc);
+	memzero_explicit(inner, sizeof(inner));
+	memzero_explicit(&st, sizeof(st));
+}
+
 static void mv_cesa_ahash_complete(struct crypto_async_request *req)
 {
 	struct ahash_request *ahashreq = ahash_request_cast(req);
@@ -394,6 +455,9 @@ static void mv_cesa_ahash_complete(struct crypto_async_request *req)
 				for (i = 0; i < digsize / 4; i++)
 					result[i] = cpu_to_be32(creq->state[i]);
 			}
+
+			if (creq->hmac && creq->sw_outer)
+				mv_cesa_ahmac_outer(ahashreq);
 		}
 	}
 }
@@ -452,6 +516,14 @@ static void mv_cesa_ahash_init(struct ahash_request *req,
 	creq->op_tmpl = *tmpl;
 	creq->len = 0;
 	creq->algo_le = algo_le;
+
+	switch (mv_cesa_get_op_cfg(tmpl) & CESA_SA_DESC_CFG_MACM_MSK) {
+	case CESA_SA_DESC_CFG_MACM_HMAC_MD5:
+	case CESA_SA_DESC_CFG_MACM_HMAC_SHA1:
+	case CESA_SA_DESC_CFG_MACM_HMAC_SHA256:
+		creq->hmac = true;
+		break;
+	}
 }
 
 static inline int mv_cesa_ahash_cra_init(struct crypto_tfm *tfm)
@@ -1242,10 +1314,14 @@ static int mv_cesa_ahmac_setkey(const char *hash_alg_name,
 	return ret;
 }
 
-static int mv_cesa_ahmac_cra_init(struct crypto_tfm *tfm)
+static int mv_cesa_ahmac_cra_init(struct crypto_tfm *tfm, const char *hash)
 {
 	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(tfm);
 
+	ctx->outer = crypto_alloc_shash(hash, 0, 0);
+	if (IS_ERR(ctx->outer))
+		return PTR_ERR(ctx->outer);
+
 	ctx->base.ops = &mv_cesa_ahash_req_ops;
 
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
@@ -1253,6 +1329,28 @@ static int mv_cesa_ahmac_cra_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
+static int mv_cesa_ahmac_md5_cra_init(struct crypto_tfm *tfm)
+{
+	return mv_cesa_ahmac_cra_init(tfm, "md5");
+}
+
+static int mv_cesa_ahmac_sha1_cra_init(struct crypto_tfm *tfm)
+{
+	return mv_cesa_ahmac_cra_init(tfm, "sha1");
+}
+
+static int mv_cesa_ahmac_sha256_cra_init(struct crypto_tfm *tfm)
+{
+	return mv_cesa_ahmac_cra_init(tfm, "sha256");
+}
+
+static void mv_cesa_ahmac_cra_exit(struct crypto_tfm *tfm)
+{
+	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	crypto_free_shash(ctx->outer);
+}
+
 static int mv_cesa_ahmac_md5_init(struct ahash_request *req)
 {
 	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
@@ -1318,7 +1416,8 @@ struct ahash_alg mv_ahmac_md5_alg = {
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct mv_cesa_hmac_ctx),
-			.cra_init = mv_cesa_ahmac_cra_init,
+			.cra_init = mv_cesa_ahmac_md5_cra_init,
+			.cra_exit = mv_cesa_ahmac_cra_exit,
 			.cra_module = THIS_MODULE,
 		}
 	}
@@ -1389,7 +1488,8 @@ struct ahash_alg mv_ahmac_sha1_alg = {
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = SHA1_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct mv_cesa_hmac_ctx),
-			.cra_init = mv_cesa_ahmac_cra_init,
+			.cra_init = mv_cesa_ahmac_sha1_cra_init,
+			.cra_exit = mv_cesa_ahmac_cra_exit,
 			.cra_module = THIS_MODULE,
 		}
 	}
@@ -1460,7 +1560,8 @@ struct ahash_alg mv_ahmac_sha256_alg = {
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = SHA256_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct mv_cesa_hmac_ctx),
-			.cra_init = mv_cesa_ahmac_cra_init,
+			.cra_init = mv_cesa_ahmac_sha256_cra_init,
+			.cra_exit = mv_cesa_ahmac_cra_exit,
 			.cra_module = THIS_MODULE,
 		}
 	}
-- 
2.56.1

