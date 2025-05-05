Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087591C4A10
	for <linux-crypto@vger.kernel.org>; Mon,  5 May 2025 19:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746472297; cv=none; b=S99pXpgGmXlwjRYM47XAcPg51O1vTSLtPnknKiyRZr3C963rUAXjM9MuYjBI+Kl8p+YXywkMO3E2b3Pfs2vXTeULmyvWH+VhfqL3y6YmQ5iUATQfm1jznLQkMM1m7z0Eoq5WOnlxob0u24lh2GXzvpDLxRfYRKusNSMle44n4hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746472297; c=relaxed/simple;
	bh=545WPwM6y3Q6zBeQifF5epe0nNsoSuS7rgBqDtHSSV0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=AcP7UvunMBhzlBa+E1IYtAW/ShMNPBzORSafsUAO9MotRL4cSSSwMg6z4+LqpbfY4Q/HF+MvuIuv5EzvgUU1hyxzQtc2BEbOoSEplVhQVevjdLOwNTwQ/JLU5YSyCfHGGFtZimME+mJFxeOI7kG7ERzqN/ctRrQe8PG03/8/b4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iDYzhnCK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iDYzhnCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D812C4CEE4
	for <linux-crypto@vger.kernel.org>; Mon,  5 May 2025 19:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746472296;
	bh=545WPwM6y3Q6zBeQifF5epe0nNsoSuS7rgBqDtHSSV0=;
	h=From:To:Subject:Date:From;
	b=iDYzhnCK4uk0ijziMT7rXg/PPwT0ueHZ89YkyBAe9xTaizxJFzi+OfQNYO2J35+PW
	 7vchDRTuYXMXy2wcukBMIpR8+eUBME+DiVy9OOp2N83IHj1/njBEQoVNvKTVzf3dMr
	 5d6PNBrpABhHGFN2Fmaxc6ykqqADR47opkxFkLeZDll37YZFKfnx5ZpqLKbjVUvmBJ
	 N9ijTmPrr1xOaJxFVfPKK4A9ve/hvrUNGh7dm3wdb8MfUp6Br8fAVudT5IWEjwnGaR
	 5KWvo1crwYqOhbI3JTxbs13X/FLOgkRNBn1Ubr9mVzAKmVkBJ0IvYLh9dYeDfgFpKJ
	 uG0ZLP1atzbaQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 0/8] crypto: use memcpy_sglist() instead of null skcipher
Date: Mon,  5 May 2025 12:10:37 -0700
Message-ID: <20250505191045.763835-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For copying data between two scatterlists, just use memcpy_sglist()
instead of the so-called "null skcipher".  This is much simpler.

Eric Biggers (8):
  crypto: algif_aead - use memcpy_sglist() instead of null skcipher
  crypto: authenc - use memcpy_sglist() instead of null skcipher
  crypto: gcm - use memcpy_sglist() instead of null skcipher
  crypto: geniv - use memcpy_sglist() instead of null skcipher
  crypto: krb5enc - do not select CRYPTO_NULL
  crypto: null - remove the default null skcipher
  crypto: null - merge CRYPTO_NULL2 into CRYPTO_NULL
  crypto: null - use memcpy_sglist()

 crypto/Kconfig                  |  15 +----
 crypto/Makefile                 |   2 +-
 crypto/algif_aead.c             | 101 ++++++--------------------------
 crypto/authenc.c                |  32 +---------
 crypto/authencesn.c             |  38 +-----------
 crypto/crypto_null.c            |  70 ++--------------------
 crypto/echainiv.c               |  18 +-----
 crypto/gcm.c                    |  41 ++-----------
 crypto/geniv.c                  |  13 +---
 crypto/seqiv.c                  |  17 +-----
 include/crypto/internal/geniv.h |   1 -
 include/crypto/null.h           |   3 -
 12 files changed, 41 insertions(+), 310 deletions(-)


base-commit: 64745a9ca890ed60d78162ec511e1983e1946d73
-- 
2.49.0

