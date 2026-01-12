Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0387322B60;
	Mon, 12 Jan 2026 19:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768245810; cv=none; b=PxWhHvQ1SK616rWLRM1EN05MfPIoh9cmt1xoXLy+AiNQeWjL3Se6uU1MxoamJD/r7IyqyfncbebMOMmNDZ4zBO7EbETwwrErVXbZsRoch6EIkVnCMWZFcVRb7aiPUFMFUFGFNNCMBjI0B+ZLfknEY4fKsUoJjP2Ta/6669luPXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768245810; c=relaxed/simple;
	bh=XxVEddn0GZ4fAoRx75wvjk3qCu0xXHueABJbpQv5kcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RWVgxwu0gQ00JA5zoS98t2HD+9LKFEQEaREFtn/WGtq4YrNkRjNLM8wBsoLcH2PEi25tk7viJxsTuLsUe+nrq8pDcnSB90PfXKXIDxgy+CanNiCSa93GMhhNJKc31E7OdqXMmiCNQehhrIuME1nZfpWNrEJvKKi1VX/Fgg6nXmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qJkYL4tl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qJkYL4tl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5B2C2BC87;
	Mon, 12 Jan 2026 19:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768245810;
	bh=XxVEddn0GZ4fAoRx75wvjk3qCu0xXHueABJbpQv5kcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qJkYL4tlLseMCpjL0U8f9dN8rYOWty3Ia3FUjnNcg7VcooPjVOuyBHwvFmikb5DmU
	 pMtl8HaKrWDzqclqykHr8CmsyWul/bIEeKUlWjzKQ+F0jKg+XwG7e7VHsndtQvTEtZ
	 9f5XMP5x9WrcB8YwEFncIk56cJ8jSp4bcYHgrnHb2B6oz+d656hEfmVICWK40JTNU4
	 oe7522xHypkdJVq/s9K3C/nzvsTCTsM8mL1DYY7ZaPSQwUx3MYpNbwaSLQRBo1XF2G
	 XPJy92dYb9nUXQPduk/5+ffe80SJhQOL8169Svozyyh/NAO7RavagZZj7D1QMvjAhK
	 UTLHZ9ckPvfGw==
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
Subject: [PATCH v2 23/35] crypto: arm/ghash - Use new AES library API
Date: Mon, 12 Jan 2026 11:20:21 -0800
Message-ID: <20260112192035.10427-24-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260112192035.10427-1-ebiggers@kernel.org>
References: <20260112192035.10427-1-ebiggers@kernel.org>
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

Note that in addition to the change in the key preparation function and
the key struct type itself, the change in the type of the key struct
results in aes_encrypt() (which is temporarily a type-generic macro)
calling the new encryption function rather than the old one.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/arm/crypto/ghash-ce-glue.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/arm/crypto/ghash-ce-glue.c b/arch/arm/crypto/ghash-ce-glue.c
index a52dcc8c1e33..454adcc62cc6 100644
--- a/arch/arm/crypto/ghash-ce-glue.c
+++ b/arch/arm/crypto/ghash-ce-glue.c
@@ -202,24 +202,28 @@ int pmull_gcm_dec_final(int bytes, u64 dg[], char *tag,
 
 static int gcm_aes_setkey(struct crypto_aead *tfm, const u8 *inkey,
 			  unsigned int keylen)
 {
 	struct gcm_key *ctx = crypto_aead_ctx(tfm);
-	struct crypto_aes_ctx aes_ctx;
+	struct aes_enckey aes_key;
 	be128 h, k;
 	int ret;
 
-	ret = aes_expandkey(&aes_ctx, inkey, keylen);
+	ret = aes_prepareenckey(&aes_key, inkey, keylen);
 	if (ret)
 		return -EINVAL;
 
-	aes_encrypt(&aes_ctx, (u8 *)&k, (u8[AES_BLOCK_SIZE]){});
+	aes_encrypt(&aes_key, (u8 *)&k, (u8[AES_BLOCK_SIZE]){});
 
-	memcpy(ctx->rk, aes_ctx.key_enc, sizeof(ctx->rk));
+	/*
+	 * Note: this assumes that the arm implementation of the AES library
+	 * stores the standard round keys in k.rndkeys.
+	 */
+	memcpy(ctx->rk, aes_key.k.rndkeys, sizeof(ctx->rk));
 	ctx->rounds = 6 + keylen / 4;
 
-	memzero_explicit(&aes_ctx, sizeof(aes_ctx));
+	memzero_explicit(&aes_key, sizeof(aes_key));
 
 	ghash_reflect(ctx->h[0], &k);
 
 	h = k;
 	gf128mul_lle(&h, &k);
-- 
2.52.0

