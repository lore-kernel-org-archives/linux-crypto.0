Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629953491D6;
	Sat,  7 Mar 2026 22:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772923578; cv=none; b=mLF1/b6Kqk5GfyIuf8iWWgMjh6BQQ9HdYZHqGozKGuQHPvHgBhv8jfP77tKH2xzy3NjJogFMYQ6ttB3BOu1i9TSozpKR3ARGQ4gPV6WQ9C2LmlViOqqwXHbz37ZQv6LVfXIWNEj5pGgpch8xiOYya4+ZU5cHA+zzQIPddtFIzz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772923578; c=relaxed/simple;
	bh=WQ9EOLjzb3i+YgCwyjm5urNHc/DtubdXpLVFU8D2oJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRnh+YDTrYRgJ0W7eBqGb6rQH7HUs/kMNgyLx/+Kx3/ou6eOMEPsawyuJk7xvM8lwotD7nkUrMXSRW+8kEcGqtNNZQnLgepQXx3Js4ERaMtJPSpzKLxS8wTnwb/dhTc6fV/saBrKsbNlOJucDYQjnJHXbsIggyNLY/W7B5sdBLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hEdIdGQk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hEdIdGQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFFA4C2BCB4;
	Sat,  7 Mar 2026 22:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772923578;
	bh=WQ9EOLjzb3i+YgCwyjm5urNHc/DtubdXpLVFU8D2oJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hEdIdGQkQS3a4EBY31JV8NJIMUIB2o6b44AA57ReuBEirsrD91dZ17hZimuZV+GAv
	 DzqFIvpNkCRaZ7xHspY16vCu9qUCGd5gjb9rUGNFxwJi50aeF3UEYNlw/dzE4hWPV6
	 an4KUpmXp+YBIlW64F0dbw55RBHDncqBtYOa6fzA0XD4nkO/8lE+D9eUdmr2nXv7mD
	 L2eTN6XYxgLVTJP15Ic3SCDTGKKY7hMJqXfRgfBT/I/t/7u21S+HJ6SYhw/O9GgMDo
	 b+rqhT26Aq+s3GLJT229Xwy6IbM6lO4hgnpiExBcqe6R06fBvMlDZKy8bqVIgZxBSw
	 JOTAXeyx2hkZQ==
From: Eric Biggers <ebiggers@kernel.org>
To: netdev@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [RFC PATCH 7/8] crypto: cipher - Remove support for cloning cipher tfms
Date: Sat,  7 Mar 2026 14:43:40 -0800
Message-ID: <20260307224341.5644-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260307224341.5644-1-ebiggers@kernel.org>
References: <20260307224341.5644-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the only caller of crypto_clone_cipher() was cmac_clone_tfm()
which has been removed, remove crypto_clone_cipher() as well.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/cipher.c                  | 28 ----------------------------
 include/crypto/internal/cipher.h |  2 --
 2 files changed, 30 deletions(-)

diff --git a/crypto/cipher.c b/crypto/cipher.c
index 1fe62bf79656b..c9dab656a622e 100644
--- a/crypto/cipher.c
+++ b/crypto/cipher.c
@@ -87,33 +87,5 @@ void crypto_cipher_decrypt_one(struct crypto_cipher *tfm,
 			       u8 *dst, const u8 *src)
 {
 	cipher_crypt_one(tfm, dst, src, false);
 }
 EXPORT_SYMBOL_NS_GPL(crypto_cipher_decrypt_one, "CRYPTO_INTERNAL");
-
-struct crypto_cipher *crypto_clone_cipher(struct crypto_cipher *cipher)
-{
-	struct crypto_tfm *tfm = crypto_cipher_tfm(cipher);
-	struct crypto_alg *alg = tfm->__crt_alg;
-	struct crypto_cipher *ncipher;
-	struct crypto_tfm *ntfm;
-
-	if (alg->cra_init)
-		return ERR_PTR(-ENOSYS);
-
-	if (unlikely(!crypto_mod_get(alg)))
-		return ERR_PTR(-ESTALE);
-
-	ntfm = __crypto_alloc_tfmgfp(alg, CRYPTO_ALG_TYPE_CIPHER,
-				     CRYPTO_ALG_TYPE_MASK, GFP_ATOMIC);
-	if (IS_ERR(ntfm)) {
-		crypto_mod_put(alg);
-		return ERR_CAST(ntfm);
-	}
-
-	ntfm->crt_flags = tfm->crt_flags;
-
-	ncipher = __crypto_cipher_cast(ntfm);
-
-	return ncipher;
-}
-EXPORT_SYMBOL_GPL(crypto_clone_cipher);
diff --git a/include/crypto/internal/cipher.h b/include/crypto/internal/cipher.h
index 5030f6d2df315..a9174ba902500 100644
--- a/include/crypto/internal/cipher.h
+++ b/include/crypto/internal/cipher.h
@@ -174,12 +174,10 @@ void crypto_cipher_encrypt_one(struct crypto_cipher *tfm,
  * the plaintext and ciphertext buffers are at least one block in size.
  */
 void crypto_cipher_decrypt_one(struct crypto_cipher *tfm,
 			       u8 *dst, const u8 *src);
 
-struct crypto_cipher *crypto_clone_cipher(struct crypto_cipher *cipher);
-
 struct crypto_cipher_spawn {
 	struct crypto_spawn base;
 };
 
 static inline int crypto_grab_cipher(struct crypto_cipher_spawn *spawn,
-- 
2.53.0

