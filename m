Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D72212FB9;
	Thu, 26 Mar 2026 00:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774484204; cv=none; b=WvPakAxbA069dnQpK66kCLFZWKxOTgQ6Eu9fHljGPrh7hKiQJv2y6NY1J16uviFE32TDJQsNtHSDJsyqvMrJZVLqxkbfNh8fSNwogQISI0e9v6BxoD3Wa/fGoksjQaFB8aqWBSrCbQC1FswsDT99Iu2r2pQTxdZtOahwfjqMpcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774484204; c=relaxed/simple;
	bh=I13oG8V9Qw0EJ1RK6B5flh0vEd/GbGbzjICfCyx3nW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJi5DtNog24Ex0rjzvRx3UmxnSvyMu+Jj7yHQu2KOVwXGCfdFzvei8djOK6GNaJQWax6UYTlYeAoJAitMo+qOiLlsL/dhZOJ7D219JoRsjXfCGxLVSMrPTj9LWCmtddCJSonJt9XYVnVeEgYmIHczphzqoKsrW/BBDh23S8Lrrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g5QGL+he; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g5QGL+he"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E324C116C6;
	Thu, 26 Mar 2026 00:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774484204;
	bh=I13oG8V9Qw0EJ1RK6B5flh0vEd/GbGbzjICfCyx3nW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5QGL+heGcR6d4grOVKDMhwuQ4rBlh9vPBlh2Aoga7jy5ggBm3lQSu1vPVQrh/5EW
	 3ffJy4+lvAcN/C3RDJ+lqJ/BESRoUnv3NMABHpfBgJ8uxfFyt2R+ZcP/I+HYS+osr1
	 /QMDUfZN70GAhgc9S6hjOCoAtJ3qsxtnS599178ayncs24VSuevGgTSdDkLz4t5Lz2
	 jjBYpp3exbM0fbwWX+A7ZFsFkN276G4kDLM4OyV8O5PiQDPfsSdCmXqjxLgCQXSrHY
	 4LXMMZkvfaIiqiBDZ8IfesbggPvLUJ6/8gxHtlQesM8M3Snvg+CcI0RRCzvDEGEunQ
	 aA54qnaevnWsg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Stephan Mueller <smueller@chronox.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 01/11] crypto: rng - Add crypto_stdrng_get_bytes()
Date: Wed, 25 Mar 2026 17:14:57 -0700
Message-ID: <20260326001507.66500-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260326001507.66500-1-ebiggers@kernel.org>
References: <20260326001507.66500-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All callers of crypto_get_default_rng() use the following sequence:

    crypto_get_default_rng()
    crypto_rng_get_bytes(crypto_default_rng, ...)
    crypto_put_default_rng()

While it may have been intended that callers amortize the cost of
getting and putting the "default RNG" (i.e. "stdrng") over multiple
calls, in practice that optimization is never used.  The callers just
want a function that gets random bytes from the "stdrng".

Therefore, add such a function: crypto_stdrng_get_bytes().

Importantly, this decouples the callers from the crypto_rng API.  That
allows a later commit to make this function simply call
get_random_bytes_wait() unless the kernel is in "FIPS mode".

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/rng.c         | 14 ++++++++++++++
 include/crypto/rng.h | 13 +++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/crypto/rng.c b/crypto/rng.c
index c6165c8eb387..53a268ad5104 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -143,10 +143,24 @@ void crypto_put_default_rng(void)
 	crypto_default_rng_refcnt--;
 	mutex_unlock(&crypto_default_rng_lock);
 }
 EXPORT_SYMBOL_GPL(crypto_put_default_rng);
 
+int crypto_stdrng_get_bytes(void *buf, unsigned int len)
+{
+	int err;
+
+	err = crypto_get_default_rng();
+	if (err)
+		return err;
+
+	err = crypto_rng_get_bytes(crypto_default_rng, buf, len);
+	crypto_put_default_rng();
+	return err;
+}
+EXPORT_SYMBOL_GPL(crypto_stdrng_get_bytes);
+
 #if defined(CONFIG_CRYPTO_RNG) || defined(CONFIG_CRYPTO_RNG_MODULE)
 int crypto_del_default_rng(void)
 {
 	int err = -EBUSY;
 
diff --git a/include/crypto/rng.h b/include/crypto/rng.h
index d451b54b322a..db6c3962a7df 100644
--- a/include/crypto/rng.h
+++ b/include/crypto/rng.h
@@ -60,10 +60,23 @@ struct crypto_rng {
 extern struct crypto_rng *crypto_default_rng;
 
 int crypto_get_default_rng(void);
 void crypto_put_default_rng(void);
 
+/**
+ * crypto_stdrng_get_bytes() - get cryptographically secure random bytes
+ * @buf: output buffer holding the random numbers
+ * @len: length of the output buffer
+ *
+ * This function fills the caller-allocated buffer with random numbers using the
+ * highest-priority "stdrng" algorithm in the crypto_rng subsystem.
+ *
+ * Context: May sleep
+ * Return: 0 function was successful; < 0 if an error occurred
+ */
+int crypto_stdrng_get_bytes(void *buf, unsigned int len);
+
 /**
  * DOC: Random number generator API
  *
  * The random number generator API is used with the ciphers of type
  * CRYPTO_ALG_TYPE_RNG (listed as type "rng" in /proc/crypto)
-- 
2.53.0

