Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9510832E69F;
	Mon,  5 Jan 2026 05:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767590112; cv=none; b=ca4lW5ntE85WQdzIb56XE6AS0eb8Irp9rwD02LG9cCAcNRsnsC/cFx91p6G5TLULVZp/DByqxTeray3ikhFA+Sd/1bMCwGu6/3J10dkcFLdUuJB5nIH66IHiSgmfVooMYreW1WlDHycZhw1H1G1pQIZh+epQcvhblmH1XjYiI88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767590112; c=relaxed/simple;
	bh=6GiGUP+X4gmyZFn4wILAzmE5Daf6tx/zz/5Ty9L/V2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOT7aAxlYxbZod0omeQFhJEbtAJb67aGoFauKGR29C2c/KnNlMUFc1CnmuW9OlRoFdJ/uZ+fib4VHjrYW1p/CAvzvkcml4KdS+BXPbbTOu41QVjUKvDeoGHgguO4VS3icixSu333LtpguV0SjN4j9rHwHnpdAj3XBh38Gz88ihk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hn+T5ja7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hn+T5ja7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC91C2BCB0;
	Mon,  5 Jan 2026 05:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767590112;
	bh=6GiGUP+X4gmyZFn4wILAzmE5Daf6tx/zz/5Ty9L/V2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hn+T5ja72OrFlu0ck1rY36j7hbDeSAIJtr1r2XfD5CZBBnXK82U0S2S5vVueu6vnL
	 Ghn7LwihQM4Z1AZgO8m2aTE58Q+/Bjc/ZK+eWiEUcVhHFW0NBhChppDwY4rzIw+g+C
	 9p8jFujFM0C3hdvjFzSGjopv0y2xHajarIJvzOiV6qYl0h0iSEtW22Hz9i75CDqSyT
	 1QIjgA+t/pE1tWp7u+IpsDLawczDOM+9cHXE3mm2OstI914Q9UN3LNYriQKKxBDTTM
	 ALoc6OJvSK74qp7/vu/2Sm30b3bE6cpISIQX3QSUh3SiADUd6TRP9CGyKcBloveSWy
	 OJK/pBYjbcdtw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 33/36] lib/crypto: aesgcm: Use new AES library API
Date: Sun,  4 Jan 2026 21:13:06 -0800
Message-ID: <20260105051311.1607207-34-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260105051311.1607207-1-ebiggers@kernel.org>
References: <20260105051311.1607207-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Switch from the old AES library functions (which use struct
crypto_aes_ctx) to the new ones (which use struct aes_enckey).  This
eliminates the unnecessary computation and caching of the decryption
round keys.  The new AES en/decryption functions are also much faster
and use AES instructions when supported by the CPU.

Note: aes_encrypt_new() will be renamed to aes_encrypt() once all
callers of the old aes_encrypt() have been updated.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/crypto/gcm.h |  2 +-
 lib/crypto/aesgcm.c  | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/crypto/gcm.h b/include/crypto/gcm.h
index fd9df607a836..b524e47bd4d0 100644
--- a/include/crypto/gcm.h
+++ b/include/crypto/gcm.h
@@ -64,11 +64,11 @@ static inline int crypto_ipsec_check_assoclen(unsigned int assoclen)
 	return 0;
 }
 
 struct aesgcm_ctx {
 	be128			ghash_key;
-	struct crypto_aes_ctx	aes_ctx;
+	struct aes_enckey	aes_key;
 	unsigned int		authsize;
 };
 
 int aesgcm_expandkey(struct aesgcm_ctx *ctx, const u8 *key,
 		     unsigned int keysize, unsigned int authsize);
diff --git a/lib/crypto/aesgcm.c b/lib/crypto/aesgcm.c
index ac0b2fcfd606..19106fe008fd 100644
--- a/lib/crypto/aesgcm.c
+++ b/lib/crypto/aesgcm.c
@@ -10,11 +10,11 @@
 #include <crypto/ghash.h>
 #include <linux/export.h>
 #include <linux/module.h>
 #include <asm/irqflags.h>
 
-static void aesgcm_encrypt_block(const struct crypto_aes_ctx *ctx, void *dst,
+static void aesgcm_encrypt_block(const struct aes_enckey *key, void *dst,
 				 const void *src)
 {
 	unsigned long flags;
 
 	/*
@@ -24,11 +24,11 @@ static void aesgcm_encrypt_block(const struct crypto_aes_ctx *ctx, void *dst,
 	 * mitigates this risk to some extent by pulling the entire S-box into
 	 * the caches before doing any substitutions, but this strategy is more
 	 * effective when running with interrupts disabled.
 	 */
 	local_irq_save(flags);
-	aes_encrypt(ctx, dst, src);
+	aes_encrypt_new(key, dst, src);
 	local_irq_restore(flags);
 }
 
 /**
  * aesgcm_expandkey - Expands the AES and GHASH keys for the AES-GCM key
@@ -47,16 +47,16 @@ int aesgcm_expandkey(struct aesgcm_ctx *ctx, const u8 *key,
 {
 	u8 kin[AES_BLOCK_SIZE] = {};
 	int ret;
 
 	ret = crypto_gcm_check_authsize(authsize) ?:
-	      aes_expandkey(&ctx->aes_ctx, key, keysize);
+	      aes_prepareenckey(&ctx->aes_key, key, keysize);
 	if (ret)
 		return ret;
 
 	ctx->authsize = authsize;
-	aesgcm_encrypt_block(&ctx->aes_ctx, &ctx->ghash_key, kin);
+	aesgcm_encrypt_block(&ctx->aes_key, &ctx->ghash_key, kin);
 
 	return 0;
 }
 EXPORT_SYMBOL(aesgcm_expandkey);
 
@@ -95,11 +95,11 @@ static void aesgcm_mac(const struct aesgcm_ctx *ctx, const u8 *src, int src_len,
 	aesgcm_ghash(&ghash, &ctx->ghash_key, assoc, assoc_len);
 	aesgcm_ghash(&ghash, &ctx->ghash_key, src, src_len);
 	aesgcm_ghash(&ghash, &ctx->ghash_key, &tail, sizeof(tail));
 
 	ctr[3] = cpu_to_be32(1);
-	aesgcm_encrypt_block(&ctx->aes_ctx, buf, ctr);
+	aesgcm_encrypt_block(&ctx->aes_key, buf, ctr);
 	crypto_xor_cpy(authtag, buf, (u8 *)&ghash, ctx->authsize);
 
 	memzero_explicit(&ghash, sizeof(ghash));
 	memzero_explicit(buf, sizeof(buf));
 }
@@ -117,11 +117,11 @@ static void aesgcm_crypt(const struct aesgcm_ctx *ctx, u8 *dst, const u8 *src,
 		 * inadvertent IV reuse, which must be avoided at all cost for
 		 * stream ciphers such as AES-CTR. Given the range of 'int
 		 * len', this cannot happen, so no explicit test is necessary.
 		 */
 		ctr[3] = cpu_to_be32(n++);
-		aesgcm_encrypt_block(&ctx->aes_ctx, buf, ctr);
+		aesgcm_encrypt_block(&ctx->aes_key, buf, ctr);
 		crypto_xor_cpy(dst, src, buf, min(len, AES_BLOCK_SIZE));
 
 		dst += AES_BLOCK_SIZE;
 		src += AES_BLOCK_SIZE;
 		len -= AES_BLOCK_SIZE;
-- 
2.52.0

