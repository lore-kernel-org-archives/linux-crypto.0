Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C1126CE36;
	Sun, 26 Oct 2025 05:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761457985; cv=none; b=U+1Cpr8IYeQ2V+XTipj1uVQkp/SHfymqlBzNxwBDGSukfa9YmRwkBMaytEQjglNQEBmLV00CyKS1f3JL3ZMZBW66xNM/ffuD0Sj3WurZEH3KcuI3SCZyl0Tcb1BsKv1Mv6Gs1PzZBuru7Y9tYMhKwat+H78EPGBwaa9iNs+QOvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761457985; c=relaxed/simple;
	bh=CPnbj7IYQFMudI6yBXTtVoWUb+m8d0YI96zTtdLwMdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lymSErgj+ybUL2cqRBLF6KHhKuO/1/FQSvhqc1HUevCy1+WR3GXsAre9Rlm2eSNrMQ3a4/UjmRnXF2fLgg8ltO7wDPu71cU7FPiTCOxYXi6EQjs6O0uZRG8Oweb9/V7BeBjuTOlrs1TSc3ecZHmcXx0/i9BaJSuhS3IYHskWg5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mz4zHVc/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mz4zHVc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C2FC113D0;
	Sun, 26 Oct 2025 05:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761457984;
	bh=CPnbj7IYQFMudI6yBXTtVoWUb+m8d0YI96zTtdLwMdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mz4zHVc/OV+KduHUq6phOIHpr5Ks3IDeZpDxzUgbKqWaT6IbOQqKvj/PwBIZNUlFY
	 1NuJ71P3h+jIUNmrloAZU2n2Y7kcHbTX0m2c7tCalhzxKJFn+lswqvjkk/qEKZSDXr
	 H5WxnbORcGnUf/3ovcdCS4HwPfVM3ZO6E3tuu5/A4ax5PzYH5KqtD+UMHW4ACTjC0n
	 SKhi3bvDhWgdST782tg9/djTpUgH661wuSiU2xQ1pX934M98G+tMl9DZiyf0bpA/fF
	 goFJWa6WN7ElyZehVWZHh9Tgi7BwtiuD04mAmwv0NDmYVrTxflwnnskT2zVzzszuDL
	 WeVHD+Kd9BP7Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 02/15] crypto: arm64/sha3 - Rename conflicting function
Date: Sat, 25 Oct 2025 22:50:19 -0700
Message-ID: <20251026055032.1413733-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251026055032.1413733-1-ebiggers@kernel.org>
References: <20251026055032.1413733-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

Rename the arm64 sha3_update() function to have an "arm64_" prefix to
avoid a name conflict with the upcoming SHA-3 library.

Note: this code will be superseded later.  This commit simply keeps the
kernel building for the initial introduction of the library.

Signed-off-by: David Howells <dhowells@redhat.com>
[EB: dropped unnecessary rename of sha3_finup(), and improved commit
     message]
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/arm64/crypto/sha3-ce-glue.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/crypto/sha3-ce-glue.c b/arch/arm64/crypto/sha3-ce-glue.c
index b4f1001046c9a..f5c8302349337 100644
--- a/arch/arm64/crypto/sha3-ce-glue.c
+++ b/arch/arm64/crypto/sha3-ce-glue.c
@@ -29,12 +29,12 @@ MODULE_ALIAS_CRYPTO("sha3-384");
 MODULE_ALIAS_CRYPTO("sha3-512");
 
 asmlinkage int sha3_ce_transform(u64 *st, const u8 *data, int blocks,
 				 int md_len);
 
-static int sha3_update(struct shash_desc *desc, const u8 *data,
-		       unsigned int len)
+static int arm64_sha3_update(struct shash_desc *desc, const u8 *data,
+			     unsigned int len)
 {
 	struct sha3_state *sctx = shash_desc_ctx(desc);
 	struct crypto_shash *tfm = desc->tfm;
 	unsigned int bs, ds;
 	int blocks;
@@ -88,11 +88,11 @@ static int sha3_finup(struct shash_desc *desc, const u8 *src, unsigned int len,
 }
 
 static struct shash_alg algs[] = { {
 	.digestsize		= SHA3_224_DIGEST_SIZE,
 	.init			= crypto_sha3_init,
-	.update			= sha3_update,
+	.update			= arm64_sha3_update,
 	.finup			= sha3_finup,
 	.descsize		= SHA3_STATE_SIZE,
 	.base.cra_name		= "sha3-224",
 	.base.cra_driver_name	= "sha3-224-ce",
 	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
@@ -100,11 +100,11 @@ static struct shash_alg algs[] = { {
 	.base.cra_module	= THIS_MODULE,
 	.base.cra_priority	= 200,
 }, {
 	.digestsize		= SHA3_256_DIGEST_SIZE,
 	.init			= crypto_sha3_init,
-	.update			= sha3_update,
+	.update			= arm64_sha3_update,
 	.finup			= sha3_finup,
 	.descsize		= SHA3_STATE_SIZE,
 	.base.cra_name		= "sha3-256",
 	.base.cra_driver_name	= "sha3-256-ce",
 	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
@@ -112,11 +112,11 @@ static struct shash_alg algs[] = { {
 	.base.cra_module	= THIS_MODULE,
 	.base.cra_priority	= 200,
 }, {
 	.digestsize		= SHA3_384_DIGEST_SIZE,
 	.init			= crypto_sha3_init,
-	.update			= sha3_update,
+	.update			= arm64_sha3_update,
 	.finup			= sha3_finup,
 	.descsize		= SHA3_STATE_SIZE,
 	.base.cra_name		= "sha3-384",
 	.base.cra_driver_name	= "sha3-384-ce",
 	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
@@ -124,11 +124,11 @@ static struct shash_alg algs[] = { {
 	.base.cra_module	= THIS_MODULE,
 	.base.cra_priority	= 200,
 }, {
 	.digestsize		= SHA3_512_DIGEST_SIZE,
 	.init			= crypto_sha3_init,
-	.update			= sha3_update,
+	.update			= arm64_sha3_update,
 	.finup			= sha3_finup,
 	.descsize		= SHA3_STATE_SIZE,
 	.base.cra_name		= "sha3-512",
 	.base.cra_driver_name	= "sha3-512-ce",
 	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
-- 
2.51.1.dirty

