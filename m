Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431994229B0
	for <linux-crypto@vger.kernel.org>; Sun, 18 Oct 2026 20:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792356572; cv=none; b=oN1NswvNyR0znZiHfqoOeF6GrQR+LDz4d1MP3/UKhWd/NuDKpYlEjWJLdR4CLyz91MH0AJkQIo08HSIzHAAd/6pX8U1YLlasXMVlflvwR4/2LNBxvO4O1FKCDi3D6lCByTkJJ49TuC89RxNphp8aQON0u2EjjonAHVNXIqVVTf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792356572; c=relaxed/simple;
	bh=AKci4zdjlHHy741qU3wITA+0Sdu8e40kxxZ/ujs+Rig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dufcboMP2fU9W0ydlErsxn+zucc3fC9NVmDiehWr6p/ADn/IU9ggh8LyAr2lsfxGgb+Xw4tdFndkQsIkKmhhqEV83OQeOKMXPCRR7C9m5cFrxoDN3a1TOJQ4QU3zZOlbrpQ+diAk6BbH4uGpAuQ36D0yvL+DlIQGVdkKlNWktQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W5DHNfoN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W5DHNfoN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E383D1F000C8;
	Sun, 18 Oct 2026 20:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792356571;
	bh=T1La5mXA/8Bo2JAF2AGEh5gN7dQ2To7/6GsfqBgEhik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W5DHNfoNIa4Lla5IliS8SMtwogkSW1Z2WQ1ioaxGN/VXOPnPp/OQi0jJHf2p6TwoO
	 euMmmJX2klLB0kF3aOBs9fYWDnmzJlvtc9UO+rMq3lXfdTGa6RIBzUvquOnY5b3ybt
	 YM4H9Mqy+FaTcsUFVoKHfQpMSH3fN76SLxdjVWm6m3DDzMet4mIl56bF6SBvTZqy1Q
	 LElq1s6Z4kncw5Hi1ziSjP/eink3mVXXXLLskq6sDYleRuOJiFIzxUR8DTTTHXKU5m
	 TeBe/Y+P8nCgLlFbWnfTVA+I5WDVcmzOWDRuEBdw/kH7vlmlOfLr3ilJ/YinQoMUNf
	 f2ptyb6BNb/HQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 14/14] crypto: stdrng - Make crypto_stdrng_get_bytes() take size_t
Date: Sun, 18 Oct 2026 13:46:18 -0700
Message-ID: <20261018204618.104876-15-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261018204618.104876-1-ebiggers@kernel.org>
References: <20261018204618.104876-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that both underlying RNG APIs that crypto_stdrng_get_bytes() uses
take size_t, make crypto_stdrng_get_bytes() itself take size_t too.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/drbg.c        | 2 +-
 include/crypto/rng.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 831178f7bc001..faa39045bdc6b 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -555,7 +555,7 @@ static void crypto_put_default_rng(void)
 	crypto_default_rng_refcnt--;
 }
 
-int __crypto_stdrng_get_bytes(void *buf, unsigned int len)
+int __crypto_stdrng_get_bytes(void *buf, size_t len)
 {
 	int err;
 
diff --git a/include/crypto/rng.h b/include/crypto/rng.h
index 087c04c118db6..719401225f92b 100644
--- a/include/crypto/rng.h
+++ b/include/crypto/rng.h
@@ -12,7 +12,7 @@
 #include <linux/fips.h>
 #include <linux/random.h>
 
-int __crypto_stdrng_get_bytes(void *buf, unsigned int len);
+int __crypto_stdrng_get_bytes(void *buf, size_t len);
 
 /**
  * crypto_stdrng_get_bytes() - get cryptographically secure random bytes
@@ -25,7 +25,7 @@ int __crypto_stdrng_get_bytes(void *buf, unsigned int len);
  * Context: May sleep
  * Return: 0 function was successful; < 0 if an error occurred
  */
-static inline int crypto_stdrng_get_bytes(void *buf, unsigned int len)
+static inline int crypto_stdrng_get_bytes(void *buf, size_t len)
 {
 	might_sleep();
 	if (fips_enabled)
-- 
2.56.0

