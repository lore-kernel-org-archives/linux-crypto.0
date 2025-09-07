Received: from outbound.mr.icloud.com (p-west2-cluster5-host1-snip4-6.eps.apple.com [57.103.71.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D917E20E00B
	for <linux-crypto@vger.kernel.org>; Sun,  7 Sep 2025 20:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.71.109
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277411; cv=none; b=FIdbD9E9YdiciknT/trRBt7HUOxMZcbecKTuYqDJhnzYnPZn+uBVkpXrr8rjdv+OHLJ63VA0Vx2r99WICXjDGQjV+DUO0neFVw41V0w33nEW8TfMSBLswYsJ+ICEsmehBUHmbKhdDQ/FcXwh4Z+7WHRlktTQIVN1yJ+LjVSxGq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277411; c=relaxed/simple;
	bh=3c62H5k9nCkPbSmcFLdG+4b3AGXfrfBvKOIR5xZhuO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sya4PvK1odxoA4KLMzlL2vzUqGXB+EWuVHqWYtPZMUMn6qfdRHasNKYH26KpKB2mezrSpZWJjtawqMur5liLyECWUQt6DIM8uVKhqGvBAltUxMKDaywkBd3hzZf7D7NBkilmxN6RFuISDI4H0/wHwAxqkUWLb3K1cViPTWBhIm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=danm.net; spf=pass smtp.mailfrom=danm.net; dkim=pass (2048-bit key) header.d=danm.net header.i=@danm.net header.b=OKIFF2nn; arc=none smtp.client-ip=57.103.71.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=danm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=danm.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danm.net header.i=@danm.net header.b="OKIFF2nn"
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-1 (Postfix) with ESMTPS id 4D9FA180019C;
	Sun,  7 Sep 2025 20:36:48 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=danm.net; s=sig1; bh=KfwNyNM7C3ST2Fy6/q43RqTuX7h0qZJRlv48C1hrvYc=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=OKIFF2nn1BbURtuJ04otEFNg3bDOlGZNvXIDkLfxhaR96q9g+cv2ZGVLJ8/YuK2AUhXlCqlJ18eXNx5i44Hpo1ScnPGBaIQdXz5fEmmxWKijvw09IT++b6ug7BQgvhBzFCGiu1I+pMve1rv/XWtchLExt0dXilH/7zpUB0AxXv74vyp5SU+xgTNI9yLnPnJ7WKziNjuc/4WoAIluWOHyEHgldj83S7M2p8tYK4rl89xsXnuQ/jkXUKVsDeJluX2cItERRyKDwYCyZs2tgQ1ucsE9SdLaM/hcqb2antPwFyQOMjv2YgMzPTlaIttaBQi3LIfhZqVPKVniQJ3TrI1xRA==
mail-alias-created-date: 1632196724000
Received: from hitch.danm.net (mr-asmtp-me-k8s.p00.prod.me.com [17.57.152.38])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-1 (Postfix) with ESMTPSA id 9A89B18000A8;
	Sun,  7 Sep 2025 20:36:47 +0000 (UTC)
From: Dan Moulding <dan@danm.net>
To: herbert@gondor.apana.org.au
Cc: dan@danm.net,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	regressions@lists.linux.dev
Subject: [PATCH v3] crypto: acomp/scomp: Use same definition of context alloc and free ops
Date: Sun,  7 Sep 2025 14:36:15 -0600
Message-ID: <20250907203615.7299-1-dan@danm.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <aLvo__F7Q1jISpaE@gondor.apana.org.au>
References: <aLvo__F7Q1jISpaE@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA3MDIxNCBTYWx0ZWRfXw/MF8fwEZ8AK
 2zI5THsmEPtjVA6c5Vm8j+99Q7cs1McbdeWU+2EEp6X1ZUKHeBcLnffnjj1NFY2YyxY+woHrXOq
 gCRf1ssSuWpR0FX1EkPhUaUiuSBXKcXFipOvAtpCDxuz0BHi2eOkunwIg0tthFtDpQG6ogCY9CI
 Yx65JCb/JidHlVMBcBSvrinu3yvheGwtm5/UcG3I8AfBLCl0FpZn1lnKJxtgv/r+VXsBy1xrwuP
 Set/3HMGk5h2pELh4nq9PROjoJGG7bRUr/g4e2jXA34JilYh5WiRypkmuonirBgIaBTStdQNA=
X-Proofpoint-ORIG-GUID: uiiFqCissVTTKS_s_zxwewe14Vs1KczY
X-Proofpoint-GUID: uiiFqCissVTTKS_s_zxwewe14Vs1KczY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-07_08,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 clxscore=1030
 mlxlogscore=999 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2509070214
X-JNJ: AAAAAAAB15g5OyuEmShOAM4Xc8BC8rXfGG4I1BCj4uvzaqd86Z5/YlVzsv4YwglmhSu6dF+zRcqUmTZFvr0OA4r2+IBT0i8jznnQtYtWDc0B1EZdOk9JSDhq0HtILj46k/u4xE2LvcBZxg1+KIIpKY+/SIXcUIQK9mlDL6f/BIjv9hYQhOnL6ppvMYX0hEEE3tEoV6hflwiRlEbY2WM0pt1APFvPW2swF5FBQ4fADlfMDTK7lmocPXqkPTren8DZcP/e7EqhYdLgZlxd6hA8WQVnK1mcg91cG6Uc7qtLp9nl7p/KSMiIXuOwBzQs97cAE94uMU9mTS1a7OGShKWBqoCvdEGxSOiusOkR9ygbplQc+SHaly/rF8eemB+KcSlVUOHo9RYfG++Z10Zfowvt6q+6BXvYNdtrT2nY0Sd54yReBlrIt5/c1gmtA2Biu53xMv9M/tsHQn58exK+t8RQXRCuyBz1HDmtIKhYTJbnw0KFY9JYylnsse8wFb1Vi3brhZS/06KeY+ijB12+qOu2pR9+VYvNVxlAgS4cuxF/EPCFPbgJtagwDs3QMiutpETniE0dmw3IiwWxr53RC0uhRgonIdC8yXSaHGt/RpnLTatHHqNKy61ZKXSeHP2rFJFIte4vLa68kg==

In commit 42d9f6c77479 ("crypto: acomp - Move scomp stream allocation
code into acomp"), the crypto_acomp_streams struct was made to rely on
having the alloc_ctx and free_ctx operations defined in the same order
as the scomp_alg struct. But in that same commit, the alloc_ctx and
free_ctx members of scomp_alg may be randomized by structure layout
randomization, since they are contained in a pure ops structure
(containing only function pointers). If the pointers within scomp_alg
are randomized, but those in crypto_acomp_streams are not, then
the order may no longer match. This fixes the problem by removing the
union from scomp_alg so that both crypto_acomp_streams and scomp_alg
will share the same definition of alloc_ctx and free_ctx, ensuring
they will always have the same layout.

Signed-off-by: Dan Moulding <dan@danm.net>
Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Fixes: 42d9f6c77479 ("crypto: acomp - Move scomp stream allocation code into acomp")
---
Changes in v3:
  * Intead of adding a new struct containing alloc and free function
    pointers, which both crypto_acomp_streams and scomp_alg can share,
    simply remove the union that was added to scomp_alg, forcing it to
    share the same definition of the function pointers from
    crypto_acomp_streams. The pointers won't be randomized in this
    version (since there is no pure ops struct any longer), but
    overall the structure layout is simpler and more sensible this
    way. This change was suggested by Herbert Xu.

Changes in v2:
  * Also patch all other crypto algorithms that use struct scomp_alg
    (v1 patch only patched LZ4).
  * Fix whitespace errors.

 crypto/842.c                          |  6 ++++--
 crypto/deflate.c                      |  4 ++--
 crypto/lz4.c                          |  6 ++++--
 crypto/lz4hc.c                        |  6 ++++--
 crypto/lzo-rle.c                      |  6 ++++--
 crypto/lzo.c                          |  6 ++++--
 crypto/zstd.c                         |  6 ++++--
 drivers/crypto/nx/nx-common-powernv.c |  6 ++++--
 drivers/crypto/nx/nx-common-pseries.c |  6 ++++--
 include/crypto/internal/scompress.h   | 11 +----------
 10 files changed, 35 insertions(+), 28 deletions(-)

diff --git a/crypto/842.c b/crypto/842.c
index 8c257c40e2b9..4007e87bed80 100644
--- a/crypto/842.c
+++ b/crypto/842.c
@@ -54,8 +54,10 @@ static int crypto842_sdecompress(struct crypto_scomp *tfm,
 }
 
 static struct scomp_alg scomp = {
-	.alloc_ctx		= crypto842_alloc_ctx,
-	.free_ctx		= crypto842_free_ctx,
+	.streams		= {
+		.alloc_ctx	= crypto842_alloc_ctx,
+		.free_ctx	= crypto842_free_ctx,
+	},
 	.compress		= crypto842_scompress,
 	.decompress		= crypto842_sdecompress,
 	.base			= {
diff --git a/crypto/deflate.c b/crypto/deflate.c
index 21404515dc77..f602ea038bb7 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -54,8 +54,8 @@ static void deflate_free_stream(void *ctx)
 }
 
 static struct crypto_acomp_streams deflate_streams = {
-	.alloc_ctx = deflate_alloc_stream,
-	.free_ctx = deflate_free_stream,
+	.alloc_ctx	= deflate_alloc_stream,
+	.free_ctx	= deflate_free_stream,
 };
 
 static int deflate_compress_one(struct acomp_req *req,
diff --git a/crypto/lz4.c b/crypto/lz4.c
index 7a984ae5ae52..57b713516aef 100644
--- a/crypto/lz4.c
+++ b/crypto/lz4.c
@@ -68,8 +68,10 @@ static int lz4_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 }
 
 static struct scomp_alg scomp = {
-	.alloc_ctx		= lz4_alloc_ctx,
-	.free_ctx		= lz4_free_ctx,
+	.streams		= {
+		.alloc_ctx	= lz4_alloc_ctx,
+		.free_ctx	= lz4_free_ctx,
+	},
 	.compress		= lz4_scompress,
 	.decompress		= lz4_sdecompress,
 	.base			= {
diff --git a/crypto/lz4hc.c b/crypto/lz4hc.c
index 9c61d05b6214..bb84f8a68cb5 100644
--- a/crypto/lz4hc.c
+++ b/crypto/lz4hc.c
@@ -66,8 +66,10 @@ static int lz4hc_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 }
 
 static struct scomp_alg scomp = {
-	.alloc_ctx		= lz4hc_alloc_ctx,
-	.free_ctx		= lz4hc_free_ctx,
+	.streams		= {
+		.alloc_ctx	= lz4hc_alloc_ctx,
+		.free_ctx	= lz4hc_free_ctx,
+	},
 	.compress		= lz4hc_scompress,
 	.decompress		= lz4hc_sdecompress,
 	.base			= {
diff --git a/crypto/lzo-rle.c b/crypto/lzo-rle.c
index ba013f2d5090..794e7ec49536 100644
--- a/crypto/lzo-rle.c
+++ b/crypto/lzo-rle.c
@@ -70,8 +70,10 @@ static int lzorle_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 }
 
 static struct scomp_alg scomp = {
-	.alloc_ctx		= lzorle_alloc_ctx,
-	.free_ctx		= lzorle_free_ctx,
+	.streams		= {
+		.alloc_ctx	= lzorle_alloc_ctx,
+		.free_ctx	= lzorle_free_ctx,
+	},
 	.compress		= lzorle_scompress,
 	.decompress		= lzorle_sdecompress,
 	.base			= {
diff --git a/crypto/lzo.c b/crypto/lzo.c
index 7867e2c67c4e..d43242b24b4e 100644
--- a/crypto/lzo.c
+++ b/crypto/lzo.c
@@ -70,8 +70,10 @@ static int lzo_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 }
 
 static struct scomp_alg scomp = {
-	.alloc_ctx		= lzo_alloc_ctx,
-	.free_ctx		= lzo_free_ctx,
+	.streams		= {
+		.alloc_ctx	= lzo_alloc_ctx,
+		.free_ctx	= lzo_free_ctx,
+	},
 	.compress		= lzo_scompress,
 	.decompress		= lzo_sdecompress,
 	.base			= {
diff --git a/crypto/zstd.c b/crypto/zstd.c
index 7570e11b4ee6..83f967eb57d4 100644
--- a/crypto/zstd.c
+++ b/crypto/zstd.c
@@ -175,8 +175,10 @@ static int zstd_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 }
 
 static struct scomp_alg scomp = {
-	.alloc_ctx		= zstd_alloc_ctx,
-	.free_ctx		= zstd_free_ctx,
+	.streams		= {
+		.alloc_ctx	= zstd_alloc_ctx,
+		.free_ctx	= zstd_free_ctx,
+	},
 	.compress		= zstd_scompress,
 	.decompress		= zstd_sdecompress,
 	.base			= {
diff --git a/drivers/crypto/nx/nx-common-powernv.c b/drivers/crypto/nx/nx-common-powernv.c
index fd0a98b2fb1b..0493041ea088 100644
--- a/drivers/crypto/nx/nx-common-powernv.c
+++ b/drivers/crypto/nx/nx-common-powernv.c
@@ -1043,8 +1043,10 @@ static struct scomp_alg nx842_powernv_alg = {
 	.base.cra_priority	= 300,
 	.base.cra_module	= THIS_MODULE,
 
-	.alloc_ctx		= nx842_powernv_crypto_alloc_ctx,
-	.free_ctx		= nx842_crypto_free_ctx,
+	.streams		= {
+		.alloc_ctx	= nx842_powernv_crypto_alloc_ctx,
+		.free_ctx	= nx842_crypto_free_ctx,
+	},
 	.compress		= nx842_crypto_compress,
 	.decompress		= nx842_crypto_decompress,
 };
diff --git a/drivers/crypto/nx/nx-common-pseries.c b/drivers/crypto/nx/nx-common-pseries.c
index f528e072494a..fc0222ebe807 100644
--- a/drivers/crypto/nx/nx-common-pseries.c
+++ b/drivers/crypto/nx/nx-common-pseries.c
@@ -1020,8 +1020,10 @@ static struct scomp_alg nx842_pseries_alg = {
 	.base.cra_priority	= 300,
 	.base.cra_module	= THIS_MODULE,
 
-	.alloc_ctx		= nx842_pseries_crypto_alloc_ctx,
-	.free_ctx		= nx842_crypto_free_ctx,
+	.streams		= {
+		.alloc_ctx	= nx842_pseries_crypto_alloc_ctx,
+		.free_ctx	= nx842_crypto_free_ctx,
+	},
 	.compress		= nx842_crypto_compress,
 	.decompress		= nx842_crypto_decompress,
 };
diff --git a/include/crypto/internal/scompress.h b/include/crypto/internal/scompress.h
index 533d6c16a491..6a2c5f2e90f9 100644
--- a/include/crypto/internal/scompress.h
+++ b/include/crypto/internal/scompress.h
@@ -18,11 +18,8 @@ struct crypto_scomp {
 /**
  * struct scomp_alg - synchronous compression algorithm
  *
- * @alloc_ctx:	Function allocates algorithm specific context
- * @free_ctx:	Function frees context allocated with alloc_ctx
  * @compress:	Function performs a compress operation
  * @decompress:	Function performs a de-compress operation
- * @base:	Common crypto API algorithm data structure
  * @streams:	Per-cpu memory for algorithm
  * @calg:	Cmonn algorithm data structure shared with acomp
  */
@@ -34,13 +31,7 @@ struct scomp_alg {
 			  unsigned int slen, u8 *dst, unsigned int *dlen,
 			  void *ctx);
 
-	union {
-		struct {
-			void *(*alloc_ctx)(void);
-			void (*free_ctx)(void *ctx);
-		};
-		struct crypto_acomp_streams streams;
-	};
+	struct crypto_acomp_streams streams;
 
 	union {
 		struct COMP_ALG_COMMON;
-- 
2.49.1

