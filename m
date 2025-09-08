Received: from outbound.mr.icloud.com (p-west2-cluster4-host5-snip4-10.eps.apple.com [57.103.69.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764272FFDDB
	for <linux-crypto@vger.kernel.org>; Mon,  8 Sep 2025 16:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.69.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757347223; cv=none; b=R5Z+GSsZH3D3U/crwORKsHTzozBwtHtE6EcvmunvJYrnhymGfV543BL4aBiV/xD0tf4aTa3V/GdDkPe8QkxEA4PCblfJbvYeAm+gh3i7yNObUWuwXhpeV1bceJArC4yBb3jAR7ZaDn4nZ0jp/fNuXLOm6ZEHMocZMiw5M2KJwsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757347223; c=relaxed/simple;
	bh=nl1kADrvQmF1grDqtsvY60ihALanrqXaHtIrW05R8Yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ub046ONJCMczMAUeQ/euBRksPl0YFvrf+sz6/ubZ1vNtL6iovinZnJL263sIRICOIcOSlSVw1QPm8vIuTFJaBOxkU7qJQ2XgoCuEpV26Lkm7zed83Nd0vo5yPSDk/C8dWh7Ydg7s1G4s/R1DTdO4wNZmJCKLAG8LQ/zlRxbL8kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=danm.net; spf=pass smtp.mailfrom=danm.net; dkim=pass (2048-bit key) header.d=danm.net header.i=@danm.net header.b=gshDRdkq; arc=none smtp.client-ip=57.103.69.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=danm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=danm.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danm.net header.i=@danm.net header.b="gshDRdkq"
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-20-percent-1 (Postfix) with ESMTPS id 95AAB180011F;
	Mon,  8 Sep 2025 16:00:18 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=danm.net; s=sig1; bh=143GXK4f81n8UgBLDB+Lfcxek6oM+4KOhRh1gnXFQKQ=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=gshDRdkqLbckpjU+hdgdH3d1Q15fVfUbvryGTw36HPLJCTk9JZdqjPh2IjMGHlwQoDb4x1DzNTYc+gpek3ycOB3PGuQZJt3/2up5XBUMnLdvS6TsC/p4vGq7cZmqpTwn6ITxmRxueO/cAmhn7VJ/8uiQYsDulXVLW9bj9cFF4pSU96lWhe2vLEpzz1Twkxkhqh48noifwu5X9oAq3lVIOe5apjXepwGdkGckIFfljReXkRFxfybw8tiR5FImYwha1aZ+ZaaWD6MUZT5suXX8koPwSeth2sXKjlcsh4eDZ4Hq/SWy1y9Gv5FEe/7SoWVys6kNGIyfESLcA6ms9LYxbw==
mail-alias-created-date: 1632196724000
Received: from hitch.danm.net (mr-asmtp-me-k8s.p00.prod.me.com [17.57.152.38])
	by p00-icloudmta-asmtp-us-west-2a-20-percent-1 (Postfix) with ESMTPSA id DDC0A180037F;
	Mon,  8 Sep 2025 16:00:17 +0000 (UTC)
From: Dan Moulding <dan@danm.net>
To: dan@danm.net
Cc: davem@davemloft.net,
	herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	regressions@lists.linux.dev
Subject: [PATCH v4] crypto: acomp/scomp: Use same definition of context alloc and free ops
Date: Mon,  8 Sep 2025 10:00:02 -0600
Message-ID: <20250908160002.26673-1-dan@danm.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250907203615.7299-1-dan@danm.net>
References: <20250907203615.7299-1-dan@danm.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1NyBTYWx0ZWRfX5Ni4oTJNapmT
 DQa4MKTTfnBMKG0/6E4PjgLD0nJD/jJA8Cngvda1JBf6A1gUbWB1kDea+mNWWOgko2UapHEKaE7
 /fjsUq1zJW03k9Pqke6VCf5aGyqc8Rf5EMz5/PWMH4Bk3lGLPOMMdeEdiG/svCI3KJcPrNIYDN3
 HuJir8IVinKox9wq7YbiC+SkrKit4adnbrqKH+3JPQ9rlyhkKN21YdDWXq5eBKZXwAODIizrJhH
 aB+AvPdVkK9GqDQqzoIPwctcRRJB0MZCgHjrJklpiEI/KjGK4s1JOGOQjeSWCcq1023S0xEEA=
X-Proofpoint-GUID: vdTYWVQ6lEzAN35Ksh0TN9BbKjPJIm6v
X-Proofpoint-ORIG-GUID: vdTYWVQ6lEzAN35Ksh0TN9BbKjPJIm6v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_05,2025-09-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 malwarescore=0 adultscore=0
 clxscore=1030 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2509080157
X-JNJ: AAAAAAABubPFun+tW33USlyNh70lf7oICSeFgPhNzHcYAlO0CgbDCMOIYIDvLWQWgJUbT5pe+1MjMT07OezvZz/2wIz/nCQoNpU6AF3/RnMzrEj9OCaeF4mbNj2QphahhiFxuoF7KsOc1zdEd0UZwEYmocRfyJ88+j0UnfdQJ5JjiF/acfdFiUWPY40seFu4zarbsg7oD+ryXcXGcKTZW0iJato+qpIIF9Hkax1LcVj+DdpuLUwQsrx56be9k/YL0+t+G6J64t0bBjqDhUSD3OLBHUnoUCdq7dGp/kLClCpwxQXeRUqC9L9Yps7WmElzhEpKG8JLymnddjzGdQUIptzjcNskMM99E9ete0c3FeyPFnTDgJbXCdNca3kG9c/9JUuUU2+Fp5iPBhXST2sgDdwVvWlm6/I5kYXyFDEIgK4qfmoHmmH6TyRj+jW7jGZxzxYtOrGyXg3sL9SMgAEiwKrpBL52/rMcFay7bKJzwWn4Nqa0/5xmBl/IIBn9Ordui68o0pETynlZkz+REmE5fM6HoByoKL0PKb/pc0fbPyOT1ffFZErHtVY0ZZ8cios/avFrstdCEzX1mhBLfAfDEOwJG5JTINcBl2emnf8ehjs8THx8Jn1j4VdllT0DQrgskIVGxMKkof5f1MRl

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
 crypto/deflate.c                      |  4 ++--
 crypto/lz4.c                          |  6 ++++--
 crypto/lz4hc.c                        |  6 ++++--
 crypto/lzo-rle.c                      |  6 ++++--
 crypto/lzo.c                          |  6 ++++--
 drivers/crypto/nx/nx-common-powernv.c |  6 ++++--
 drivers/crypto/nx/nx-common-pseries.c |  6 ++++--
 include/crypto/internal/scompress.h   | 11 +----------
 9 files changed, 31 insertions(+), 26 deletions(-)

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

