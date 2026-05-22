Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5825A39D6DF;
	Fri, 22 May 2026 05:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779427865; cv=none; b=VvEP6aSmaTLolq4C1MENpilnQztmC8xSLSgnC2lZFmIue/vnYB684AIuJmFphqzjug4IGY1/URcDaLdkUYvquSd7CbP+cy0W/xreK+YCmnH8caIxmleCY7zAKgk67RIyS0BBD5xCCk1u2AVplIi4uVhD8kTySG1SzvL2lZDzCIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779427865; c=relaxed/simple;
	bh=+Trog/DKdhmgYtXN6C0Fts331pgzew035r+29P3Lo4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=agaIrpHm8K751i4BN0W8wLX7hNCE9+KBHARf+fvzmxfe5ncDVBgcLFBaXbuv96UDcXdtv3+rRsfryHMm6JRicffrriYF3KY+BOq1wYiiJ69X3nyYn2hA3CPR+vPUfus2AXBde5pnavd+VTN6c23LbKQYc95sZbIe/QUjBxA/Tkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XXWodOLc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XXWodOLc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB7C1F00A3F;
	Fri, 22 May 2026 05:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779427864;
	bh=lyuadyceyVHMbEkzNYbCGqNjcN+CZzGorS75xcstP58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XXWodOLcvfa1ECwHoMOsPozSdLobKtwmwcXhHI8tcprhY/CzxjGMODlBJDNQDhLUp
	 s/5skVzSdv/MWyWWUEtkNqpJTyAU0TnYoG3EJn2imdCRWsop0uuXZ79ZB1XMfeGQii
	 vpEoBC/k4Eo3hI4mnNXYND9ulL6zcGAhhdNIiv72hIFkl/lDZ4Of/irXeosFX/+KnU
	 qPdYqdURzWuWMFRQMWa9hQ9LIG9uilULsRLdZHCpWBlLzWrAXDu0u0JOESJne5tRRy
	 UbSywIi6jgaAYxl95hqcDEYUifHJelX/NbOv9idYpaExhyaSqGSlKoJgN5VfddqGiO
	 ExJPxUmIpkUUQ==
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
Subject: [PATCH net-next 2/6] crypto: cipher - Remove crypto_clone_cipher()
Date: Fri, 22 May 2026 00:30:24 -0500
Message-ID: <20260522053028.91165-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260522053028.91165-1-ebiggers@kernel.org>
References: <20260522053028.91165-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the only caller of crypto_clone_cipher() was cmac_clone_tfm()
which has been removed, remove crypto_clone_cipher() as well.

Note that no tests need to be removed, as this function had no tests.

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/cipher.c                  | 28 ----------------------------
 include/crypto/internal/cipher.h |  2 --
 2 files changed, 30 deletions(-)

diff --git a/crypto/cipher.c b/crypto/cipher.c
index 1fe62bf79656..c9dab656a622 100644
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
index 5030f6d2df31..a9174ba90250 100644
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
2.54.0

