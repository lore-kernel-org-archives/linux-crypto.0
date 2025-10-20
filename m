Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E2E1A76BC;
	Mon, 20 Oct 2025 00:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760921613; cv=none; b=IrD+95Uf7qhViYsjo4CWrrNUVD5UG/OXeG+wyNzpQ5v21lLj/LWpWqOMxolP7jDw3178Ea1gD/ZQHzsRD513OWLyjFrdh3pvKIVtHXeoIYsCDDgnUcX9nl+ITBgV4BIjyBQ+1hyTy6x79SAf1pgiizPrWacTNeDZoNyRaG3ObJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760921613; c=relaxed/simple;
	bh=TSUPKbwNLbb7mhNbu9L6HinZjxHA1TP1J2/JSwQ69+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lt/3jG6vtfp2xNXwQQMB/NgWqwnnYMQOpQUoV/bcuiRaHHAtOZxRxRZJ+UleyqdJNX6S1R//0P+ObjDAEdx6A4j6yanDK8QCjjX8vo2M/1F9ROB0HUuO7bNbYelaHGryhxnprKW56M4EblpMuCnJWoO6SgITNH2VhIIQp53FBGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o3rU/5QW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o3rU/5QW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6E1C113D0;
	Mon, 20 Oct 2025 00:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760921612;
	bh=TSUPKbwNLbb7mhNbu9L6HinZjxHA1TP1J2/JSwQ69+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o3rU/5QWIxEz/SJlv0INtTPIO8SahTbcLR5YnA1j8KGobBvcuYKZyMZj/6uFoEhmr
	 dmc/KBdlm1jdOKogUbfx2oCPDiwiMsReEhsEkvMr8nXrNotGlxBVH+PWZNIl6zPHXX
	 UviGV9j0yHXwJOJp8S/VzCqeRTDMqPKUj0AlPMobVLo2TSGjHd9vGJqc+DyVaqxwVa
	 LKRGVl/SV574HPIgAlNslrefv4kKsPXiH+IRGipWIbrMPoQtDVOR/KgZCpNk56+7A5
	 y5UPX61iygmt9y1F5M8ITlF6BwmY9k1bFaJbDxvnG244+mPh6+gztopsvoa/LWZQCR
	 cJ+B1wJmtA2Rw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 02/17] arm64/sha3: Rename conflicting functions
Date: Sun, 19 Oct 2025 17:50:23 -0700
Message-ID: <20251020005038.661542-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251020005038.661542-1-ebiggers@kernel.org>
References: <20251020005038.661542-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

Rename the arm64 sha3_* functions to have an "arm64_" prefix to avoid
conflict with generic code.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Eric Biggers <ebiggers@kernel.org>
cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
cc: Ard Biesheuvel <ardb@kernel.org>
cc: Catalin Marinas <catalin.marinas@arm.com>
cc: Will Deacon <will@kernel.org>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: Stephan Mueller <smueller@chronox.de>
cc: linux-crypto@vger.kernel.org
cc: linux-arm-kernel@lists.infradead.org
Link: https://lore.kernel.org/r/20251017144311.817771-3-dhowells@redhat.com
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/arm64/crypto/sha3-ce-glue.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/crypto/sha3-ce-glue.c b/arch/arm64/crypto/sha3-ce-glue.c
index b4f1001046c9a..426d8044535ab 100644
--- a/arch/arm64/crypto/sha3-ce-glue.c
+++ b/arch/arm64/crypto/sha3-ce-glue.c
@@ -29,11 +29,11 @@ MODULE_ALIAS_CRYPTO("sha3-384");
 MODULE_ALIAS_CRYPTO("sha3-512");
 
 asmlinkage int sha3_ce_transform(u64 *st, const u8 *data, int blocks,
 				 int md_len);
 
-static int sha3_update(struct shash_desc *desc, const u8 *data,
+static int arm64_sha3_update(struct shash_desc *desc, const u8 *data,
 		       unsigned int len)
 {
 	struct sha3_state *sctx = shash_desc_ctx(desc);
 	struct crypto_shash *tfm = desc->tfm;
 	unsigned int bs, ds;
@@ -53,12 +53,12 @@ static int sha3_update(struct shash_desc *desc, const u8 *data,
 		blocks = rem;
 	} while (blocks);
 	return len;
 }
 
-static int sha3_finup(struct shash_desc *desc, const u8 *src, unsigned int len,
-		      u8 *out)
+static int arm64_sha3_finup(struct shash_desc *desc, const u8 *src, unsigned int len,
+			    u8 *out)
 {
 	struct sha3_state *sctx = shash_desc_ctx(desc);
 	struct crypto_shash *tfm = desc->tfm;
 	__le64 *digest = (__le64 *)out;
 	u8 block[SHA3_224_BLOCK_SIZE];
@@ -88,48 +88,48 @@ static int sha3_finup(struct shash_desc *desc, const u8 *src, unsigned int len,
 }
 
 static struct shash_alg algs[] = { {
 	.digestsize		= SHA3_224_DIGEST_SIZE,
 	.init			= crypto_sha3_init,
-	.update			= sha3_update,
-	.finup			= sha3_finup,
+	.update			= arm64_sha3_update,
+	.finup			= arm64_sha3_finup,
 	.descsize		= SHA3_STATE_SIZE,
 	.base.cra_name		= "sha3-224",
 	.base.cra_driver_name	= "sha3-224-ce",
 	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
 	.base.cra_blocksize	= SHA3_224_BLOCK_SIZE,
 	.base.cra_module	= THIS_MODULE,
 	.base.cra_priority	= 200,
 }, {
 	.digestsize		= SHA3_256_DIGEST_SIZE,
 	.init			= crypto_sha3_init,
-	.update			= sha3_update,
-	.finup			= sha3_finup,
+	.update			= arm64_sha3_update,
+	.finup			= arm64_sha3_finup,
 	.descsize		= SHA3_STATE_SIZE,
 	.base.cra_name		= "sha3-256",
 	.base.cra_driver_name	= "sha3-256-ce",
 	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
 	.base.cra_blocksize	= SHA3_256_BLOCK_SIZE,
 	.base.cra_module	= THIS_MODULE,
 	.base.cra_priority	= 200,
 }, {
 	.digestsize		= SHA3_384_DIGEST_SIZE,
 	.init			= crypto_sha3_init,
-	.update			= sha3_update,
-	.finup			= sha3_finup,
+	.update			= arm64_sha3_update,
+	.finup			= arm64_sha3_finup,
 	.descsize		= SHA3_STATE_SIZE,
 	.base.cra_name		= "sha3-384",
 	.base.cra_driver_name	= "sha3-384-ce",
 	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
 	.base.cra_blocksize	= SHA3_384_BLOCK_SIZE,
 	.base.cra_module	= THIS_MODULE,
 	.base.cra_priority	= 200,
 }, {
 	.digestsize		= SHA3_512_DIGEST_SIZE,
 	.init			= crypto_sha3_init,
-	.update			= sha3_update,
-	.finup			= sha3_finup,
+	.update			= arm64_sha3_update,
+	.finup			= arm64_sha3_finup,
 	.descsize		= SHA3_STATE_SIZE,
 	.base.cra_name		= "sha3-512",
 	.base.cra_driver_name	= "sha3-512-ce",
 	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
 	.base.cra_blocksize	= SHA3_512_BLOCK_SIZE,
-- 
2.51.1.dirty

