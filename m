Received: from outbound.mr.icloud.com (p-west2-cluster3-host12-snip4-10.eps.apple.com [57.103.69.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334E12E7F12
	for <linux-crypto@vger.kernel.org>; Mon,  8 Sep 2025 16:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.69.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757347975; cv=none; b=EfD0CRV9Jpw2povbDxzb9lJMIfCSg3iku1hkGqKwsc+fDulLIXQTJMezDi0VxLf7O9uzrg4W5ZJpFViNF3uX1AUzq6WnqFTjFXwysO/vNcLx+oOsnKjLLiv9wQu0lGf4wVEFbcEnLHvFSb1dR3/uN8FBEqCqEvNNTfY7F6D9Pyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757347975; c=relaxed/simple;
	bh=zdaNYbm8MeQoL6nou+7g27VbKL+FOqKNDUAWB/zsJD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKCgmyMNNdF73Wc2HT+1Eml9WvvjoiCTXIIKZcRURkTkh6Mot4bBogR2x3AyaObIwQAKks+V8AiiFzueE+w1+PEW8B7/an+PK+2T8rptRwORc6Be4+CaBEEHLcBU35UiqNVjjvRYMrheGLPf7PKTpdFUn6hXHp4xvP/95Y98cG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=danm.net; spf=pass smtp.mailfrom=danm.net; dkim=pass (2048-bit key) header.d=danm.net header.i=@danm.net header.b=c130O1L8; arc=none smtp.client-ip=57.103.69.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=danm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=danm.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danm.net header.i=@danm.net header.b="c130O1L8"
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-20-percent-2 (Postfix) with ESMTPS id 9208A1800856;
	Mon,  8 Sep 2025 16:12:51 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=danm.net; s=sig1; bh=BxR6Es+jHBGS3Dcb/o7sbGzq483CRQegevkqso1i/VU=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=c130O1L8R+QgqmxAmihTNbNADoebMLmy1+XNLhGWhCwhEymVna/M00DuoCIi/TXasiV1HMepKoppmbMxGWzZPslG6XhMzvrfXrgAiWDgsHY215ZUzE9YVHiHwVUalXwIQ0xRW8/2CHEuEhLC9sRldeSOoN0Hc60UeSdodScxapa00ZCFmp/Ln+Rtr2LIuk2lrfxAUUhw69o39tRt5M6Px5Ybx8JrQ3J5n/c9lqpU0uKjD9F2CZ7HaByg7pLnpMWl3NWa+fKHaTLgk2xJP/9dfGIWG0URVdQrnhdjCDSAQMDGng40ZLKiseJH2Zl5LFFOOKiACcy4P/cTBf2JRc4HdQ==
mail-alias-created-date: 1632196724000
Received: from hitch.danm.net (mr-asmtp-me-k8s.p00.prod.me.com [17.57.152.38])
	by p00-icloudmta-asmtp-us-west-2a-20-percent-2 (Postfix) with ESMTPSA id B55071800462;
	Mon,  8 Sep 2025 16:12:50 +0000 (UTC)
From: Dan Moulding <dan@danm.net>
To: dan@danm.net
Cc: davem@davemloft.net,
	herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	regressions@lists.linux.dev
Subject: [PATCH v5] crypto: acomp/scomp: Use same definition of context alloc and free ops
Date: Mon,  8 Sep 2025 10:12:43 -0600
Message-ID: <20250908161243.27239-1-dan@danm.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250908160002.26673-1-dan@danm.net>
References: <20250908160002.26673-1-dan@danm.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 0LzOZ-0YGPa-agYMJLbSNXsS8PEv2Aeu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2MSBTYWx0ZWRfX760CWkzhhFcs
 XP+kakD1g7JflrzGMGr4x1c2+e7bUmdsUj7U91voqEDd1ZCnN8TtnsYWAittO9Djqpr/xV/4wPO
 hSSmvrPBU6nRBh3rxsxw5kJg4HR+MYlg9YGX9+gpb6E1QcNLfhUNJTdetXroatE0Irm1pe2vFpJ
 E53kimaAF5esmLCu+eVEIJl5jsGUm2NN/vgZ1RC0Kois2z7Vwf0d2ETJjHYWFS7YByjr0uetKhp
 wtI2Xv0t/4owsZUmGuQ+jc75/gGvNwmwLg+SdoFSUsbv8zvmnlkqbueCMeQTed2rVjz32cPps=
X-Proofpoint-GUID: 0LzOZ-0YGPa-agYMJLbSNXsS8PEv2Aeu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 mlxscore=0 adultscore=0 phishscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 clxscore=1030 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2506270000 definitions=main-2509080161
X-JNJ: AAAAAAABuwVZ5hz3LdasHbnNhat10B6A6VxNjIPOP3XRvfeLpYQbR0cRz4TFxU9m4Nb/J0SnrZuWgty/y0YgyHXWAL1DoTsECMd5i5VygY09Yo7AsYM+HSOHmb2JRpPfGUXcNirCSiI3zTVGHePFDZ9Kh1tr82bsDc4nHM8UfK6vxfH+ISF3IjioamkVCo60z6U1gq36qUEXQniIxfhzlT7XpH0KX2/bPOwFocWzARmezpgk8owPsijTovFSFVr6vt6Du0mcE2srtggspJGeajqsy3c4lLOG7MlhLNUuwa2PtOwVULrdEHBXiSX/62O7Ai8Jsetx/NHYIwdtjWKsCCKwXshK3l2jgRrjWKO2+1KVIuYPFdXmkjPm7uv0vExCP0L9gaY4/g4CuHotrBBQuS1VPtvYs6zbKeNO0dxWsJpO2woXy650wloiJsbyi7Rkh9GdlaB2FhVipKH60M8guCXT3070N8imXdejkabaqA+bY04rmXlKDj6lmq7QcM4baBBFriBI+YcqgdvBCWLC6GDggTZKikhK4zwfMSh7D3v9gxVytn+OCHgU5uiU7tP7sB4PRYJzcMSfpHIrnVUqSm+m81O9emeX58ZK1XEhwdL0NWXmBX3PotWXcguPiHF/E9z5nRFEoldaTrE=

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
Changes in v4:
  * After the change in v3, the deflate algorithm was no longer
    affected, but the patch still had some whitespace changes in
    deflate.c. This version removes those (so deflate.c is no longer
    patched here).

Changes in v4:
  * Rebased on crypto-2.6/master (previous versions were based on
    stable v6.16).

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
 crypto/lz4.c                          |  6 ++++--
 crypto/lz4hc.c                        |  6 ++++--
 crypto/lzo-rle.c                      |  6 ++++--
 crypto/lzo.c                          |  6 ++++--
 drivers/crypto/nx/nx-common-powernv.c |  6 ++++--
 drivers/crypto/nx/nx-common-pseries.c |  6 ++++--
 include/crypto/internal/scompress.h   | 11 +----------
 8 files changed, 29 insertions(+), 24 deletions(-)

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

