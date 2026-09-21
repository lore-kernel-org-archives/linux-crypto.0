Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21653537FE;
	Mon, 21 Sep 2026 05:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789967765; cv=none; b=RzKehFglIcYv3zF0kXM0sD0PNfKODH2ri2OSDoEYSzMdXobMXh5Q0VrnCJyXgcYrU38bAh+p6jfvmLcBVX4beP4L9pFIMvOfDd/K6rMEw0i43KdC9n4VOcVlJ6QMhSgmfaLJYyRlMD8QplqMNwIHjGFXJ0cPTeosNmsk3cWoWA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789967765; c=relaxed/simple;
	bh=auzSsUIFvJG2EtKpLFfnXxHUxfbBKvMt0g7pXMc4uvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nq7DaxoSemlYLyGeWqpnxUrcyPhgex1ojnXiUranvKBnMNWLZytEfh6pM6ZwIgzRz6nFo2xgj52IPsl/Y/1R6WM1Cza4CASZMLxzBb2nPYfvPWLFQiAfOFdDFWHM9r6Rjf1gk2AS7M+7iK2ld+m9G8Ly/6m0S7tBnw9D205MK8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KzCfrKiN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KzCfrKiN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8024D1F0089A;
	Mon, 21 Sep 2026 05:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789967763;
	bh=AmO1iCgpFBbB/kyTIAKSaYWoXnvuk8nhmmPYC4t0U3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KzCfrKiN5xbJknA8Z0bxouu+q1rvnE+ICUiYxL1KzsYDKbiThtDeVNj6Pug2wVWh8
	 jvwoWf7N+iOtxzCecOjlRNAtu+GBhAlTo5I/AB//qkzjSt3+o5bRwJH9Fo6/ggqSET
	 UWvp0IP55uxzUJugC7Gnv8xWCLhPa1UyxWMWa9fESruk15RUksMcoGCT+Y/AGDefHO
	 gA5qf06iF45qh3WU3q3EfS0iRJtYiPwoWoAg6w1FCP1FfirkOLeOmCU4N/GjhKivxJ
	 mfJoP1wInFh1wph6XccqJSKEgEJjAeUDLfxXvlS2VlMNGZMtq1JNLxDpFnpscTtJRi
	 /GVM6fPV+CRiQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	linux-riscv@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 01/20] crypto: aes - Fix undesired override of some optimized AES modes
Date: Sun, 20 Sep 2026 22:08:47 -0700
Message-ID: <20260921050910.296144-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921050910.296144-1-ebiggers@kernel.org>
References: <20260921050910.296144-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The new library APIs for AES encryption modes were wired up to the
traditional crypto API via crypto/aes.c.  However, for now the kernel is
still in a transitional state where various architectures still have
architecture-optimized implementations of AES modes in arch/*/crypto/,
wired up to the traditional crypto API only.  Because of that, the
crypto/aes.c algorithms were given a cra_priority of only 110 to prevent
them from overriding arch/*/crypto/ in the traditional crypto API.

However, because of how the traditional crypto API works, the
cra_priority trick doesn't work in cases where the relevant algorithm
isn't directly implemented by arch/*/crypto/ but rather is provided by a
template instance using other code in arch/*/crypto/.

For example, x86 doesn't have its own "ccm(aes)" but rather relies on
the "ccm" template constructing it from the x86-optimized "ctr(aes)".
The existence of the library-based "ccm(aes)" prevents that, even though
its priority is lower than what the template would produce.

Thus, "ccm(aes)" ends up using the slower single-block AES code.

Of course, this problem will go away as architecture-optimized
implementations of AES modes are migrated into the library.  But until
then, we need to ensure that code continues to be used.

Therefore, skip wiring up the relevant library-based code to the
traditional crypto API on architectures where this problem can occur, as
determined by what exists in arch/*/crypto/ for each architecture.

Note: "xts(aes)" is left alone.  Though the "xts" template can use
"ecb(aes)" as an inner algorithm, in practice this isn't very efficient
and a dedicated "xts(aes)" is already provided in all the important
cases anyway.  (This omission is also consistent with the fact that the
library isn't planned to provide a similar ECB-to-XTS "adapter".)

Fixes: 20df21a482aa ("crypto: aes - Add CBC and CBC-CTS support using library")
Fixes: 8ca62072faa1 ("crypto: aes - Add GCM support using library")
Fixes: f70ad727d1d6 ("crypto: aes - Add CCM support using library")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/aes.c | 39 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 36 insertions(+), 3 deletions(-)

diff --git a/crypto/aes.c b/crypto/aes.c
index 94791f481e98..e6ba3899d868 100644
--- a/crypto/aes.c
+++ b/crypto/aes.c
@@ -637,7 +637,17 @@ static struct skcipher_alg skcipher_algs[] = {
 		.decrypt = crypto_aes_cbc_decrypt,
 	},
 #endif
-#if IS_ENABLED(CONFIG_CRYPTO_CTS)
+#if IS_ENABLED(CONFIG_CRYPTO_CTS) && \
+	/*
+	 * Skip registering this when it might block a "better" implementation
+	 * from being instantiated via the "cts" template wrapping an arch-
+	 * optimized "cbc(aes)" that hasn't yet been migrated into the library.
+	 */ \
+	!(IS_ENABLED(CONFIG_ARM) || \
+	  IS_ENABLED(CONFIG_ARM64) || \
+	  IS_ENABLED(CONFIG_POWERPC) || \
+	  IS_ENABLED(CONFIG_S390) || \
+	  IS_ENABLED(CONFIG_SPARC))
 	{
 		.base.cra_name = "cts(cbc(aes))",
 		.base.cra_driver_name = "cts-cbc-aes-lib",
@@ -980,7 +990,18 @@ static __maybe_unused int crypto_aes_ccm_decrypt(struct aead_request *req)
 }
 
 static struct aead_alg aead_algs[] = {
-#if IS_ENABLED(CONFIG_CRYPTO_GCM)
+#if IS_ENABLED(CONFIG_CRYPTO_GCM) && \
+	/*
+	 * Skip registering these when they might block "better" implementations
+	 * from being instantiated via the corresponding templates using
+	 * arch-optimized code that hasn't yet been migrated into the library.
+	 */ \
+	!(IS_ENABLED(CONFIG_ARM) || \
+	  IS_ENABLED(CONFIG_ARM64) || \
+	  IS_ENABLED(CONFIG_POWERPC) || \
+	  IS_ENABLED(CONFIG_RISCV) || \
+	  IS_ENABLED(CONFIG_S390) || \
+	  IS_ENABLED(CONFIG_SPARC))
 	{
 		.base.cra_name = "gcm(aes)",
 		.base.cra_driver_name = "gcm-aes-lib",
@@ -1012,7 +1033,19 @@ static struct aead_alg aead_algs[] = {
 		.chunksize = AES_BLOCK_SIZE,
 	},
 #endif /* CONFIG_CRYPTO_GCM */
-#if IS_ENABLED(CONFIG_CRYPTO_CCM)
+#if IS_ENABLED(CONFIG_CRYPTO_CCM) && \
+	/*
+	 * Skip registering this when it might block a "better" implementation
+	 * from being instantiated via the "ccm" template wrapping an arch-
+	 * optimized "ctr(aes)" that hasn't yet been migrated into the library.
+	 */ \
+	!(IS_ENABLED(CONFIG_ARM) || \
+	  IS_ENABLED(CONFIG_ARM64) || \
+	  IS_ENABLED(CONFIG_POWERPC) || \
+	  IS_ENABLED(CONFIG_RISCV) || \
+	  IS_ENABLED(CONFIG_S390) || \
+	  IS_ENABLED(CONFIG_SPARC) || \
+	  IS_ENABLED(CONFIG_X86))
 	{
 		.base.cra_name = "ccm(aes)",
 		.base.cra_driver_name = "ccm-aes-lib",
-- 
2.55.0

