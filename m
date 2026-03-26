Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DB925A359;
	Thu, 26 Mar 2026 00:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774484221; cv=none; b=aSuoGw+ellrPRsnuFlGnJy2prbjOAvcteTj3JWEyMovMAPNTdscoKfSAn2zDCaFMqMyQA0lDkiCZ+cSn5kLGJR7t/DHk0gnW2vCWmlrhiNxhdDKXxd86Xg7x/nO7Nppr0YmbtHhc9JtR2SE0QjS75/egDh12lNR8KOnZGNmKh4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774484221; c=relaxed/simple;
	bh=gVYWGgvTQTyAkbaUOqtJ9FGKedJjaLzRIhTRebmsS/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PCbp6F0rRt+YV5NFp9vWaNect67bukWz4PQUmgsOk8fKzAKCj+13n3KeL34t5uoaR2I2q1WJNGaaBOlweZfaibXW9PH5Y3me36eO9y5hTUdtMW9uF+CRnCdt3W8GvvECW37K2Mh1o7lSIVpkbIYe5Kf6fS7smmOEll2NVKEQ4c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sQiXmush; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sQiXmush"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F05BC2BC9E;
	Thu, 26 Mar 2026 00:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774484217;
	bh=gVYWGgvTQTyAkbaUOqtJ9FGKedJjaLzRIhTRebmsS/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQiXmushjRFX85aNxUbM1ZY/DZ9tCednwHffvuZpzNAz6H1CQYDBPoRlG7BJOfsrB
	 5pCV1uq9LOaPchar9h6aSsMn62Wn3c+FNVenl9JOZ7CcGgHqRMzb9vA/V+4RtXQM/k
	 tbM1sKRhICww+Byp4h4J/qXfH32VNkH4X+MfIJCbbQ+tlVaDELjW596dFUdiig6hgG
	 tMRAAwVCC/nz/qmRQ7DlaRl9KXBM+6wx/hqrv6P/el3JPUt0lZF24u4jAywzOWC9Pe
	 FQYYfOBul4KKTVUF5O8bLXqHGmoXqfuQq1o8RRPdf0z/VAzL+P3emfqnG0aB3b3dIL
	 sQAJG3N/Jcv+A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Stephan Mueller <smueller@chronox.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 10/11] crypto: fips - Depend on CRYPTO_DRBG=y
Date: Wed, 25 Mar 2026 17:15:06 -0700
Message-ID: <20260326001507.66500-11-ebiggers@kernel.org>
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

Currently, the callers of crypto_stdrng_get_bytes() do 'select
CRYPTO_RNG_DEFAULT', which does 'select CRYPTO_DRBG_MENU'.

However, due to the change in how crypto_stdrng_get_bytes() is
implemented, CRYPTO_DRBG_MENU is now needed only when CRYPTO_FIPS.

But, 'select CRYPTO_DRBG_MENU if CRYPTO_FIPS' would cause a recursive
dependency, since CRYPTO_FIPS 'depends on CRYPTO_DRBG'.

Solve this by just making CRYPTO_FIPS depend on CRYPTO_DRBG=y (rather
than CRYPTO_DRBG i.e. CRYPTO_DRBG=y || CRYPTO_DRBG=m).  The distros that
use CRYPTO_FIPS=y already set CRYPTO_DRBG=y anyway, which makes sense.

This makes the CRYPTO_RNG_DEFAULT symbol (and its corresponding
selection of CRYPTO_DRBG_MENU) unnecessary.  A later commit removes it.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index e2b4106ac961..80492538e1f7 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -23,11 +23,11 @@ if CRYPTO
 
 menu "Crypto core or helper"
 
 config CRYPTO_FIPS
 	bool "FIPS 200 compliance"
-	depends on CRYPTO_DRBG && CRYPTO_SELFTESTS
+	depends on CRYPTO_DRBG=y && CRYPTO_SELFTESTS
 	depends on (MODULE_SIG || !MODULES)
 	help
 	  This option enables the fips boot option which is
 	  required if you want the system to operate in a FIPS 200
 	  certification.  You should say no unless you know what
-- 
2.53.0

