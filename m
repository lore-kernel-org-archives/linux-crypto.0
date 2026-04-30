Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0721E8320;
	Thu, 30 Apr 2026 06:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777531074; cv=none; b=oxWAzGXHZXbnQ2FjJpw18MEPFZv7q55w8c1jvcEphY1HwK03IZxzhRUqpe6wtfiBQWTFsDykhg2pChznU/qNy+YGNUeAinShzp5qMrUX2GllIQ8GHDEDw3AwfbD7V/sCnm9XntZ985eEQoMvkEQYDBdEsFFRWhIAvRJ72Vwijg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777531074; c=relaxed/simple;
	bh=T+emv/Wme0bgNZhGlWfxDRmABjkXpGtwrSZbvP4pOm4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dpmJquwEokJGmRq5IPsIuyTcVAgeAmYu4llrMmPM9XivigVxyy8xrRMnyTWjMwtm7dYDfZisgxSbf4d71zHJ/MQOaVhbj38YAe+7owh37/zssJQRLZ94b2Y3Y5n6ikycXMMyHnmUpwwLnwJ1nO1Fcbu4IhEth4GCQV3QYqJoqzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jwdXblR+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jwdXblR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC23C2BCB8;
	Thu, 30 Apr 2026 06:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777531073;
	bh=T+emv/Wme0bgNZhGlWfxDRmABjkXpGtwrSZbvP4pOm4=;
	h=From:To:Cc:Subject:Date:From;
	b=jwdXblR+GERpGG/Uq4rF423U/s6G0FPfFxKKnPBBtfIFSHNi8YS/d0IM7r2tZ1eWr
	 nTuCEenqLbcBhib3AldnDMLwhVfsx+JWoarr7hMeU2pJcdB1K2tgHCxX8dxKVnm1Hj
	 +DvlXvYlJt5xppVny5ToPZ+apnl6Fu7cLYLGlnGX2oAuDMjyodSSDpYm3whrTCi75Y
	 xkBexlSMkdhsRIkaQppAG9E+JxHKk2xnk6J1kSoEQRdgPQtljuMKbbaGwe82PvNEkA
	 hbCoqiacKvk/4aPwzL5rytcp1nAC4yLDQzsjyNqh2HbWCsexe96NZWawxndkI9C3zZ
	 jcXum+BGcoCQw==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.15 0/9] AF_ALG fixes
Date: Wed, 29 Apr 2026 23:35:55 -0700
Message-ID: <20260430063604.173525-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series backports recent AF_ALG fixes to 5.15.  Same as the 6.1
series
(https://lore.kernel.org/linux-crypto/20260430062731.140497-1-ebiggers@kernel.org/),
just with patch 1 adjusted for compatibility with -std=gnu89.

Douya Le (1):
  crypto: algif_aead - snapshot IV for async AEAD requests

Eric Biggers (3):
  crypto: scatterwalk - Backport memcpy_sglist()
  crypto: algif_aead - use memcpy_sglist() instead of null skcipher
  crypto: authenc - use memcpy_sglist() instead of null skcipher

Herbert Xu (5):
  crypto: algif_aead - Revert to operating out-of-place
  crypto: authencesn - Do not place hiseq at end of dst for out-of-place
    decryption
  crypto: authencesn - Fix src offset when decrypting in-place
  crypto: af_alg - Fix page reassignment overflow in af_alg_pull_tsgl
  crypto: algif_aead - Fix minimum RX size check for decryption

 crypto/Kconfig               |   2 -
 crypto/af_alg.c              |  51 ++-------
 crypto/algif_aead.c          | 203 ++++++++---------------------------
 crypto/algif_skcipher.c      |   6 +-
 crypto/authenc.c             |  32 +-----
 crypto/authencesn.c          |  84 ++++++---------
 crypto/scatterwalk.c         |  94 ++++++++++++++++
 include/crypto/if_alg.h      |   5 +-
 include/crypto/scatterwalk.h |  32 ++++++
 9 files changed, 217 insertions(+), 292 deletions(-)


base-commit: b9d57c40a767db4d2ef905abb91f73cbe0a791e1
-- 
2.54.0

