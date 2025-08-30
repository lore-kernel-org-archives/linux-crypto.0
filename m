Received: from outbound.mr.icloud.com (p-west2-cluster1-host12-snip4-9.eps.apple.com [57.103.68.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62F22C237F
	for <linux-crypto@vger.kernel.org>; Sat, 30 Aug 2025 17:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.68.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756574963; cv=none; b=lQix0Mzqs+heR2Di69/yON8WFvxNb8LtyvkDuzvilODLHbiy4j5B+3ML7En5WHvTSQqQskB2da78SagWV77NTX9y7ZF4E3OT58Ftxh+e6eWMTJRX9exqnDEeYXjmgsHsOUeZYhQHhujpgB482WGXA8kpwJUMi9ashijNtZLn3c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756574963; c=relaxed/simple;
	bh=DIERJkRrJK9puBZWtdHmc4b3UIwlZYb+TgAqoQGpbSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owPCIdZzXnrysxMlxxnrm1AMATj+wC+wwCphE5oI8zcaPSoepuIU4llHtVTC7A0Q2q0x03abHtZ+KqSPrnN6KlT+JVV3n1Gj84D6s3bYmJ7neTK78vjz2tAWK7vEnn2HesQiJY9/+xEajk2cD8CR8YEji+kQ387Uof8wnTwcU+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=danm.net; spf=pass smtp.mailfrom=danm.net; dkim=pass (2048-bit key) header.d=danm.net header.i=@danm.net header.b=amUIbkCh; arc=none smtp.client-ip=57.103.68.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=danm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=danm.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danm.net header.i=@danm.net header.b="amUIbkCh"
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-20-percent-2 (Postfix) with ESMTPS id AD28B18001DB;
	Sat, 30 Aug 2025 17:29:18 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=danm.net; s=sig1; bh=v5ueKS1UZY89i14LOMD59Ed6Eyy8uNKzkv3j0KgEDs8=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=amUIbkCh1hOd2TBUPgoFAMe8Hyh3FsnjhhpwjNbqCynYWH+DoJ6C2iat02+omMOF3tZj6+BOAmxmBRz23I6Ogh392e1c7zAWcXBGi0pHMW0e+pC+OHej7CIsi8hgEGlTW/M5sAykKDSQVrqnnKG/yj+AqwBXLedswhvQuIzIuGefbnYAS+4fVJ/GFI6hGxqtFlnRElLReaK+39c70J+bhLcakp/srHH7F4OD/+JB8A1B5issf5fCzMRPF7ZAWp7d2T6XcSCu+DIvO3MfZ6HasOXbknZLO1Fi3dO1ZYH52JmguCIytNMs/9ifePO2F0JsFohEMO1LMii7injUIpZy5w==
mail-alias-created-date: 1632196724000
Received: from hitch.danm.net (mr-asmtp-me-k8s.p00.prod.me.com [17.57.152.38])
	by p00-icloudmta-asmtp-us-west-2a-20-percent-2 (Postfix) with ESMTPSA id 500B218009D1;
	Sat, 30 Aug 2025 17:29:17 +0000 (UTC)
From: Dan Moulding <dan@danm.net>
To: dan@danm.net
Cc: davem@davemloft.net,
	herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	regressions@lists.linux.dev
Subject: [PATCH v2] crypto: acomp: Use shared struct for context alloc and free ops
Date: Sat, 30 Aug 2025 11:28:01 -0600
Message-ID: <20250830172801.6889-1-dan@danm.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250830032839.11005-2-dan@danm.net>
References: <20250830032839.11005-2-dan@danm.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDE4NSBTYWx0ZWRfX6VDDrPqmnpbu
 MhDI/ey/h2YlSYu2WW+7h9FDVZoqlc9DVd8m96k04RJc95oQ0MdeY/BBMSKRPqxA2MNY+sJFizc
 1gmw/kerUrySHjfIRqgXJrxg4xMKhaIxv5Q7t06KyKzDyZzre8DDOdVhtkNQSsk66Rfs7FOrKOE
 1OAYYY1Mx4ROqiJl02dSrxuFHee5aOz1GYF53uguLb3jP55O4+44glD9DBE2YIzI9jm6hTvit2c
 GlkdQAPaJjUbyMIrknmdti4+61XUqS6v0vQHHl8EdiJANK0ltt39ri8QgHY6yxvZDULcbm8VE=
X-Proofpoint-ORIG-GUID: J5X9G7NX8XuUSdV5iwIKF9-ZuzYU723Q
X-Proofpoint-GUID: J5X9G7NX8XuUSdV5iwIKF9-ZuzYU723Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-30_07,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 clxscore=1030 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2508300185
X-JNJ: AAAAAAABZ2zJSC3CG2hD5s2cVq9X+D/fiDr2TbvwjfxYgSYqywA0nBZVWoPnpJ1XW0ukA/E2UjcxEU17kznYeqN1mJnkHjB4yEwFbFqJIO8lH+Nqx4GwW3oQE1jIuNFdxtglrZV/Xk37ujgqk6VOcoO2mDcdWSmb9+0hkSub9+aIPBEoymYTOCIBueTLNcbEu70Flzdm8qBNguVhjHTFdi1evbn+T7b8As7SLn7bIJD1MSMlOAsaWBSEGz88jX03F7GF7/3EX8+DcDDvXDq9czBpyRTGU3yWO6D9nSwCjkKZomlcCnZhW10pmG9fOHj2J6FdzzEj7djnLUjlefqho7yIAzdJqtCoSqHi9nOD406GJe/DF5Z14llWfm6819I+PCs5GSYjAmMbocXgp8j2sMY+2tgYndua1HMtxMO9tNAQPUCPjYXU5K5lJEaxKpwp7smrZ8N/p5vhrhdGW25xF3rdLtc8Zo6mDYrdbhV4MkEH3LdPtb2upY8Akz+s/r6yLmbbUF9KFTVuChtdSN9kwvkXI99Aku7lloveNTuUTsohalbyXW3ExJpkgmS6FC0lF1AtQZ+QteawCaqprMBKdwXY

In commit 42d9f6c77479 ("crypto: acomp - Move scomp stream allocation
code into acomp"), the crypto_acomp_streams struct was made to rely on
having the alloc_ctx and free_ctx operations defined in the same order
as the scomp_alg struct. But in that same commit, the alloc_ctx and
free_ctx members of scomp_alg may be randomized by structure layout
randomization, since they are contained in a pure ops structure
(containing only function pointers). If the pointers within scomp_alg
are randomized, but those in crypto_acomp_streams are not, then
the order may no longer match. This fixes the problem by defining a
shared structure that both crypto_acomp_streams and scomp_alg share:
acomp_ctx_ops. This new pure ops structure may now be randomized,
while still allowing both crypto_acomp_streams and scomp_alg to have
matching layout.

Signed-off-by: Dan Moulding <dan@danm.net>
Fixes: 42d9f6c77479 ("crypto: acomp - Move scomp stream allocation code into acomp")
---
Changes in v2:
  * Also patch all other crypto algorithms that use struct scomp_alg
    (v1 patch only patched LZ4).
  * Fix whitespace errors.

 crypto/842.c                          |  6 ++++--
 crypto/acompress.c                    |  6 +++---
 crypto/deflate.c                      |  6 ++++--
 crypto/lz4.c                          |  6 ++++--
 crypto/lz4hc.c                        |  6 ++++--
 crypto/lzo-rle.c                      |  6 ++++--
 crypto/lzo.c                          |  6 ++++--
 crypto/zstd.c                         |  6 ++++--
 drivers/crypto/nx/nx-common-powernv.c |  6 ++++--
 drivers/crypto/nx/nx-common-pseries.c |  6 ++++--
 include/crypto/internal/acompress.h   | 10 +++++++---
 include/crypto/internal/scompress.h   |  5 +----
 12 files changed, 47 insertions(+), 28 deletions(-)

diff --git a/crypto/842.c b/crypto/842.c
index 8c257c40e2b9..e0fa2de0cb88 100644
--- a/crypto/842.c
+++ b/crypto/842.c
@@ -54,8 +54,10 @@ static int crypto842_sdecompress(struct crypto_scomp *tfm,
 }
 
 static struct scomp_alg scomp = {
-	.alloc_ctx		= crypto842_alloc_ctx,
-	.free_ctx		= crypto842_free_ctx,
+	.ctx_ops		= {
+		.alloc_ctx	= crypto842_alloc_ctx,
+		.free_ctx	= crypto842_free_ctx,
+	},
 	.compress		= crypto842_scompress,
 	.decompress		= crypto842_sdecompress,
 	.base			= {
diff --git a/crypto/acompress.c b/crypto/acompress.c
index be28cbfd22e3..ff910035ee42 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -375,7 +375,7 @@ static void acomp_stream_workfn(struct work_struct *work)
 		if (ps->ctx)
 			continue;
 
-		ctx = s->alloc_ctx();
+		ctx = s->ctx_ops.alloc_ctx();
 		if (IS_ERR(ctx))
 			break;
 
@@ -398,7 +398,7 @@ void crypto_acomp_free_streams(struct crypto_acomp_streams *s)
 		return;
 
 	cancel_work_sync(&s->stream_work);
-	free_ctx = s->free_ctx;
+	free_ctx = s->ctx_ops.free_ctx;
 
 	for_each_possible_cpu(i) {
 		struct crypto_acomp_stream *ps = per_cpu_ptr(streams, i);
@@ -427,7 +427,7 @@ int crypto_acomp_alloc_streams(struct crypto_acomp_streams *s)
 	if (!streams)
 		return -ENOMEM;
 
-	ctx = s->alloc_ctx();
+	ctx = s->ctx_ops.alloc_ctx();
 	if (IS_ERR(ctx)) {
 		free_percpu(streams);
 		return PTR_ERR(ctx);
diff --git a/crypto/deflate.c b/crypto/deflate.c
index 21404515dc77..5ea6e857871f 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -54,8 +54,10 @@ static void deflate_free_stream(void *ctx)
 }
 
 static struct crypto_acomp_streams deflate_streams = {
-	.alloc_ctx = deflate_alloc_stream,
-	.free_ctx = deflate_free_stream,
+	.ctx_ops		= {
+		.alloc_ctx	= deflate_alloc_stream,
+		.free_ctx	= deflate_free_stream,
+	},
 };
 
 static int deflate_compress_one(struct acomp_req *req,
diff --git a/crypto/lz4.c b/crypto/lz4.c
index 7a984ae5ae52..f7eb0702e175 100644
--- a/crypto/lz4.c
+++ b/crypto/lz4.c
@@ -68,8 +68,10 @@ static int lz4_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 }
 
 static struct scomp_alg scomp = {
-	.alloc_ctx		= lz4_alloc_ctx,
-	.free_ctx		= lz4_free_ctx,
+	.ctx_ops		= {
+		.alloc_ctx	= lz4_alloc_ctx,
+		.free_ctx	= lz4_free_ctx,
+	},
 	.compress		= lz4_scompress,
 	.decompress		= lz4_sdecompress,
 	.base			= {
diff --git a/crypto/lz4hc.c b/crypto/lz4hc.c
index 9c61d05b6214..e6ab1f35b6cb 100644
--- a/crypto/lz4hc.c
+++ b/crypto/lz4hc.c
@@ -66,8 +66,10 @@ static int lz4hc_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 }
 
 static struct scomp_alg scomp = {
-	.alloc_ctx		= lz4hc_alloc_ctx,
-	.free_ctx		= lz4hc_free_ctx,
+	.ctx_ops		= {
+		.alloc_ctx	= lz4hc_alloc_ctx,
+		.free_ctx	= lz4hc_free_ctx,
+	},
 	.compress		= lz4hc_scompress,
 	.decompress		= lz4hc_sdecompress,
 	.base			= {
diff --git a/crypto/lzo-rle.c b/crypto/lzo-rle.c
index ba013f2d5090..48352c213937 100644
--- a/crypto/lzo-rle.c
+++ b/crypto/lzo-rle.c
@@ -70,8 +70,10 @@ static int lzorle_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 }
 
 static struct scomp_alg scomp = {
-	.alloc_ctx		= lzorle_alloc_ctx,
-	.free_ctx		= lzorle_free_ctx,
+	.ctx_ops		= {
+		.alloc_ctx	= lzorle_alloc_ctx,
+		.free_ctx	= lzorle_free_ctx,
+	},
 	.compress		= lzorle_scompress,
 	.decompress		= lzorle_sdecompress,
 	.base			= {
diff --git a/crypto/lzo.c b/crypto/lzo.c
index 7867e2c67c4e..9d53aca2491e 100644
--- a/crypto/lzo.c
+++ b/crypto/lzo.c
@@ -70,8 +70,10 @@ static int lzo_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 }
 
 static struct scomp_alg scomp = {
-	.alloc_ctx		= lzo_alloc_ctx,
-	.free_ctx		= lzo_free_ctx,
+	.ctx_ops		= {
+		.alloc_ctx	= lzo_alloc_ctx,
+		.free_ctx	= lzo_free_ctx,
+	},
 	.compress		= lzo_scompress,
 	.decompress		= lzo_sdecompress,
 	.base			= {
diff --git a/crypto/zstd.c b/crypto/zstd.c
index 7570e11b4ee6..057a1f5f93cb 100644
--- a/crypto/zstd.c
+++ b/crypto/zstd.c
@@ -175,8 +175,10 @@ static int zstd_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 }
 
 static struct scomp_alg scomp = {
-	.alloc_ctx		= zstd_alloc_ctx,
-	.free_ctx		= zstd_free_ctx,
+	.ctx_ops		= {
+		.alloc_ctx	= zstd_alloc_ctx,
+		.free_ctx	= zstd_free_ctx,
+	},
 	.compress		= zstd_scompress,
 	.decompress		= zstd_sdecompress,
 	.base			= {
diff --git a/drivers/crypto/nx/nx-common-powernv.c b/drivers/crypto/nx/nx-common-powernv.c
index fd0a98b2fb1b..5f7aff7d43e6 100644
--- a/drivers/crypto/nx/nx-common-powernv.c
+++ b/drivers/crypto/nx/nx-common-powernv.c
@@ -1043,8 +1043,10 @@ static struct scomp_alg nx842_powernv_alg = {
 	.base.cra_priority	= 300,
 	.base.cra_module	= THIS_MODULE,
 
-	.alloc_ctx		= nx842_powernv_crypto_alloc_ctx,
-	.free_ctx		= nx842_crypto_free_ctx,
+	.ctx_ops		= {
+		.alloc_ctx	= nx842_powernv_crypto_alloc_ctx,
+		.free_ctx	= nx842_crypto_free_ctx,
+	},
 	.compress		= nx842_crypto_compress,
 	.decompress		= nx842_crypto_decompress,
 };
diff --git a/drivers/crypto/nx/nx-common-pseries.c b/drivers/crypto/nx/nx-common-pseries.c
index f528e072494a..221dbb9e6b48 100644
--- a/drivers/crypto/nx/nx-common-pseries.c
+++ b/drivers/crypto/nx/nx-common-pseries.c
@@ -1020,8 +1020,10 @@ static struct scomp_alg nx842_pseries_alg = {
 	.base.cra_priority	= 300,
 	.base.cra_module	= THIS_MODULE,
 
-	.alloc_ctx		= nx842_pseries_crypto_alloc_ctx,
-	.free_ctx		= nx842_crypto_free_ctx,
+	.ctx_ops		= {
+		.alloc_ctx	= nx842_pseries_crypto_alloc_ctx,
+		.free_ctx	= nx842_crypto_free_ctx,
+	},
 	.compress		= nx842_crypto_compress,
 	.decompress		= nx842_crypto_decompress,
 };
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 2d97440028ff..c84a17ac26ca 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -55,15 +55,19 @@ struct acomp_alg {
 	};
 };
 
+struct acomp_ctx_ops {
+	void *(*alloc_ctx)(void);
+	void (*free_ctx)(void *);
+};
+
 struct crypto_acomp_stream {
 	spinlock_t lock;
 	void *ctx;
 };
 
 struct crypto_acomp_streams {
-	/* These must come first because of struct scomp_alg. */
-	void *(*alloc_ctx)(void);
-	void (*free_ctx)(void *);
+	/* This must come first because of struct scomp_alg. */
+	struct acomp_ctx_ops ctx_ops;
 
 	struct crypto_acomp_stream __percpu *streams;
 	struct work_struct stream_work;
diff --git a/include/crypto/internal/scompress.h b/include/crypto/internal/scompress.h
index 533d6c16a491..1d807a15aef2 100644
--- a/include/crypto/internal/scompress.h
+++ b/include/crypto/internal/scompress.h
@@ -35,10 +35,7 @@ struct scomp_alg {
 			  void *ctx);
 
 	union {
-		struct {
-			void *(*alloc_ctx)(void);
-			void (*free_ctx)(void *ctx);
-		};
+		struct acomp_ctx_ops ctx_ops;
 		struct crypto_acomp_streams streams;
 	};
 
-- 
2.49.1

