Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B001B37757A;
	Thu, 30 Apr 2026 06:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777530582; cv=none; b=bbAEBfsPg5IWE12FVHiSUn2msD3JkiQ52aa0iSRtpa2uh8BQlTs/mINWGt3XxqwB9TXGIOqsmyBt9D6Q40+s4HG93thruMcSxsjdlsmcEE/KiM7aEezH2h73kkpz4UWofsSfTHoMGw/ioxJXCy/N9QUCv4OTUDVxFiIUs/wJZMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777530582; c=relaxed/simple;
	bh=F+39f7/oLkprlIlCyai3ZYzfL09sOWhLTdLOzk0MTis=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n1wmsPAY0fHApJnGp6l28N3SOX62PvYNuf0Cu7164K5gEOOAweCR351jCeeqO2HFdoziR23iUw14iiohYPeFj/VUqG3CoO0SE2CS05EX7U7LPfA1t7ZjTYc5pt3SbnEpXNg16obgHR8Qgu5+eSBm/zM6scEii+krPsWCxCR76u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZAY0GBet; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZAY0GBet"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184FBC2BCB8;
	Thu, 30 Apr 2026 06:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777530582;
	bh=F+39f7/oLkprlIlCyai3ZYzfL09sOWhLTdLOzk0MTis=;
	h=From:To:Cc:Subject:Date:From;
	b=ZAY0GBetU1aCCFMXuHvMhXifaooWZUNl5YDcLW23CAa/glgMnjApWWZG77PNoi4xQ
	 GYbWNw368b4kecQPuaK+iE4+zTL4D22/GcZjw+vLFQowTvG3RbMK3lvXp03qIcNemn
	 uPaxQmqVLqDXYvDATr815qDh52jUF83XnjXuCAlwCiK6yebPfBwrm3EgGtiOyfvLKS
	 HexMo94R82zkFaG+FJul0M0Kct92MmaB0/8MwXiZIxb4uOzRuucO542vCaZT5pC2kB
	 DixefJK1by9TIKLuUllIar5eZPN7aaTaD+s63gxKGcxYg69HX0VECzCmrLNHhqSaom
	 a6gx2iehMyf0A==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.1 0/9] AF_ALG fixes
Date: Wed, 29 Apr 2026 23:27:22 -0700
Message-ID: <20260430062731.140497-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series backports recent AF_ALG fixes to 6.1.  First 8 commits are
taken from the 6.12 / 6.6 backport
(https://lore.kernel.org/linux-crypto/20260430060702.110091-1-ebiggers@kernel.org)
rebased onto 6.1 with some conflicts resolved.  Commit 9 is another fix
missing on 6.1.

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
 include/crypto/scatterwalk.h |  31 ++++++
 9 files changed, 216 insertions(+), 292 deletions(-)


base-commit: 7c87defbd336df289c8c0280f019647864ff70c6
-- 
2.54.0

