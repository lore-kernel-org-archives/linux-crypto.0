Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9110248891;
	Thu, 26 Mar 2026 00:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774484218; cv=none; b=cD7hQW9RrFcyNh/I4IkJRr8r1W/lheQiTkfSrs9SfLIXsNsrSK5uGQr8vTgAuApVbT6azTgn2bfyjMyV/t8y06w+XrRcPiKKYqATLSJyxWB2DV7MeYc7Ofm3faUaFNMghEbrpzxcjKtdZJaOrno8YQ07ILQHrco0Xte22hsg1y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774484218; c=relaxed/simple;
	bh=HMZzVUFcD9miX9WpRk/PMHOpf3ZyoinWJzLJ9kgTXYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Egu6Sw1y5axNV1HQhdWEE7WBpVH/N2SPJlOPk95UlIm7MEwpJ6e1k/Q1ZgTmgCiFe30EBgTnphBsl5wWwapuR87InP0KDDmmVbbEUzD9aoKmwcb9kPb9zXYjFBmr4heAVU3fHQKvQx+CI9voOxYrZejCeiehwwFI5Mw3oo1a6Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EQZaxAQg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EQZaxAQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E92C2BCB2;
	Thu, 26 Mar 2026 00:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774484218;
	bh=HMZzVUFcD9miX9WpRk/PMHOpf3ZyoinWJzLJ9kgTXYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EQZaxAQgytO6JTxWUmhI2BJcJwz+pIMmqaQms/j0I2v26SEx+xoz0PhDCqV9gCNuL
	 fYgdcxmaqqb5Je4Q1kg5XNvCpvXFdxLCJSO/FCBtdcxI8aDD5ggJv5SVH6HE8Rpwmx
	 /tbZSVNdSE/DANAI5p8fZQAVkf3X/RdNQusR7cQcd8HcmahMP+re30gJVqJKIFYgMy
	 MmwNKnxKxUOoNSaLr+3WXp22QmTm5a212hgKkjlos13q6DM51vTyIwI7oTp0NigcsX
	 ppiufvcDFfBuAc2QObERI4EDCvOMdn9j1WzMhwqqHI1m3qjf1Q4usIroWOiFaMeJQP
	 L2xG9tJyQFY8g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Stephan Mueller <smueller@chronox.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 11/11] crypto: rng - Don't pull in DRBG when CRYPTO_FIPS=n
Date: Wed, 25 Mar 2026 17:15:07 -0700
Message-ID: <20260326001507.66500-12-ebiggers@kernel.org>
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

crypto_stdrng_get_bytes() is now always available:

    - When CRYPTO_FIPS=n it is an inline function that always calls into
      the always-built-in drivers/char/random.c.

    - When CRYPTO_FIPS=y it is an inline function that calls into either
      random.c or crypto/rng.c, depending on the value of fips_enabled.
      The former is again always built-in.  The latter is built-in as
      well in this case, due to CRYPTO_FIPS=y.

Thus, the CRYPTO_RNG_DEFAULT symbol is no longer needed.  Remove it.

This makes it so that CRYPTO_DRBG_MENU (and hence also CRYPTO_DRBG,
CRYPTO_JITTERENTROPY, and CRYPTO_LIB_SHA3) no longer gets unnecessarily
pulled into CRYPTO_FIPS=n kernels.  I.e. CRYPTO_FIPS=n kernels are no
longer bloated with code that is relevant only to FIPS certifications.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 80492538e1f7..13686f033413 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -107,14 +107,10 @@ config CRYPTO_RNG
 
 config CRYPTO_RNG2
 	tristate
 	select CRYPTO_ALGAPI2
 
-config CRYPTO_RNG_DEFAULT
-	tristate
-	select CRYPTO_DRBG_MENU
-
 config CRYPTO_AKCIPHER2
 	tristate
 	select CRYPTO_ALGAPI2
 
 config CRYPTO_AKCIPHER
@@ -294,11 +290,10 @@ config CRYPTO_DH
 	  DH (Diffie-Hellman) key exchange algorithm
 
 config CRYPTO_DH_RFC7919_GROUPS
 	bool "RFC 7919 FFDHE groups"
 	depends on CRYPTO_DH
-	select CRYPTO_RNG_DEFAULT
 	help
 	  FFDHE (Finite-Field-based Diffie-Hellman Ephemeral) groups
 	  defined in RFC7919.
 
 	  Support these finite-field groups in DH key exchanges:
@@ -306,11 +301,10 @@ config CRYPTO_DH_RFC7919_GROUPS
 
 	  If unsure, say N.
 
 config CRYPTO_ECC
 	tristate
-	select CRYPTO_RNG_DEFAULT
 
 config CRYPTO_ECDH
 	tristate "ECDH (Elliptic Curve Diffie-Hellman)"
 	select CRYPTO_ECC
 	select CRYPTO_KPP
@@ -802,11 +796,10 @@ config CRYPTO_GCM
 
 config CRYPTO_GENIV
 	tristate
 	select CRYPTO_AEAD
 	select CRYPTO_MANAGER
-	select CRYPTO_RNG_DEFAULT
 
 config CRYPTO_SEQIV
 	tristate "Sequence Number IV Generator"
 	select CRYPTO_GENIV
 	help
-- 
2.53.0

