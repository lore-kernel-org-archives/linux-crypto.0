Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF9A20C00A;
	Thu, 26 Mar 2026 00:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774484203; cv=none; b=UuFCbUcnP1NHtqzFPDXDslv4DLhugj+DLHWzYn0zRUZn9LHLCWRoWPjjMRIJ9wE/J5Lf5Z/9xAEm/Peg0q5jHd8yg/s2qVIwleH3QTBUi2RQdBiI9IYM9de1IKUtvk5cevBGcyyIqROo/IbBeP0NcnwtciiiB9EE/pNI605Z/xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774484203; c=relaxed/simple;
	bh=K59JVsZzzV61i6IGo6VkFRuwNYRboTvCPXe3QuBREyA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uU7fzMxW11xVQNl5fORxG9wYiOyXzpQa1XRP3stB5ku4AzUNwDC+hA0G3bvjpbmV6a3dHgOYBC91ljmApwSIAuElUV7UYs1ugOlDxX9N3POhqM8i7DK90B8ebaEugw/mjDnDmBnUtKx20rONDJnijQzG/YczO1revz/s7YcVtR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oNGuLDpe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oNGuLDpe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5CCC4CEF7;
	Thu, 26 Mar 2026 00:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774484203;
	bh=K59JVsZzzV61i6IGo6VkFRuwNYRboTvCPXe3QuBREyA=;
	h=From:To:Cc:Subject:Date:From;
	b=oNGuLDpe7lcS5xTSjWqewWtNgbkZX/K7vBnln5+Gr1O/BYVkgSkSoF47bFLOLWQ9a
	 D68Rt97a9Ra64wBhbDS7MTtGdDAyt20KmqfzvZNLytmyNrce34fGg7gob0Tb5HF7ph
	 pLHpa/z+YGh6Uh/Va1/Dw1bqLSysPM+lgzHqPHvz8J13QWN4ElSzuHt2uns9yEFFj8
	 EXMMg0iUkpza0hN1Xew8Oth6kmir9DKc6L14GqQ+WtyUtP8KwhWjdkOVg02FIRHbyF
	 TdmJ6AYQSoisTSApe13wESTv+3pBEHZkZQ8c7pE766JWtfLd/DfacEWDOvYYCT9YFO
	 VLqro4Un8nrHw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Stephan Mueller <smueller@chronox.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 00/11] Stop pulling DRBG code into non-FIPS kernels
Date: Wed, 25 Mar 2026 17:14:56 -0700
Message-ID: <20260326001507.66500-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Most kernels have CRYPTO_FIPS=n but still include crypto/drbg.c and
everything it depends on, including crypto/jitterentropy.c.

This dependency bloat happens because some kernel code gets random bytes
from "stdrng" in the crypto_rng API instead of from get_random_bytes().
(This is apparently done for FIPS certification reasons.)  Then, that
pulls crypto/drbg.c to provide a "stdrng" implementation.

This series fixes the dependency bloat by making "stdrng" be used only
in FIPS mode, and get_random_bytes_wait() be used otherwise.

This series is targeting cryptodev/master.

Eric Biggers (11):
  crypto: rng - Add crypto_stdrng_get_bytes()
  crypto: dh - Use crypto_stdrng_get_bytes()
  crypto: ecc - Use crypto_stdrng_get_bytes()
  crypto: geniv - Use crypto_stdrng_get_bytes()
  crypto: hisilicon/hpre - Use crypto_stdrng_get_bytes()
  crypto: intel/keembay-ocs-ecc - Use crypto_stdrng_get_bytes()
  net: tipc: Use crypto_stdrng_get_bytes()
  crypto: rng - Unexport "default RNG" symbols
  crypto: rng - Make crypto_stdrng_get_bytes() use normal RNG in
    non-FIPS mode
  crypto: fips - Depend on CRYPTO_DRBG=y
  crypto: rng - Don't pull in DRBG when CRYPTO_FIPS=n

 crypto/Kconfig                                |  9 +------
 crypto/dh.c                                   |  8 +-----
 crypto/ecc.c                                  | 11 +++-----
 crypto/geniv.c                                |  8 +-----
 crypto/rng.c                                  | 23 ++++++++++++-----
 drivers/crypto/hisilicon/hpre/hpre_crypto.c   | 12 ++-------
 .../crypto/intel/keembay/keembay-ocs-ecc.c    | 17 +++----------
 include/crypto/rng.h                          | 25 ++++++++++++++++---
 net/tipc/crypto.c                             | 13 ++--------
 9 files changed, 53 insertions(+), 73 deletions(-)


base-commit: f9bbd547cfb98b1c5e535aab9b0671a2ff22453a
-- 
2.53.0

