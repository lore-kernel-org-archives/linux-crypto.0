Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7782B395259;
	Thu, 30 Apr 2026 07:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777532610; cv=none; b=ipT0XEXneKB+t3flMCkH8hj5G1XCXq0mF0FEWjFWn99OzGE9iMS/JB1KZUoDulEzruGQ1jbiIgvZsdF4FKVK/ld1t8BuR8wvV2G0Ui3GfCRxOoXt6mgeBHKAkfqyxs3CTD4KV74O4mL/9SVbHeQ9Q0KsvXU511pev3tJigA8uaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777532610; c=relaxed/simple;
	bh=ldHduypkfg8LNl5PWslKxZaIFVNY3iE0K9zRSjzyDOE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JKj+OEaSs7F9DGL/O1lS0p5KTC820bl8vfsNtyvnEBXHg36YxcFyVcmdJCIvbYlrh6Qf3M4qvjG9fqpgf1NIZYlk79pYXy/K0szGgQgLPj47PToYiP9uQ9i6AlCsp7A4Yw1Ko2IHFKUttgX+VGD3Aj2J9uzOWrnntSBXesXDV6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sPAfy6AC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sPAfy6AC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4A9C2BCB3;
	Thu, 30 Apr 2026 07:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777532610;
	bh=ldHduypkfg8LNl5PWslKxZaIFVNY3iE0K9zRSjzyDOE=;
	h=From:To:Cc:Subject:Date:From;
	b=sPAfy6ACvgYEcvNTWIYswdN1gRRtTpwosZwUL2RVXlrfryvXzyg3fwahI+7R4OX7W
	 fHcyNpeoGttOWYHo0iAYb7TwMbN1U7G1aZ/kxRVM989/f5mrrIqTWGVyCToy6gPIlT
	 ENF7b4vkPsC8oqwVxtpy/ScnZnpBJNBknXcVptBUFWSy1eqbbKUwWVwF3ZuN8vcq0i
	 nB+F2a3Z2nZUqwpnIIQgmPoJJwZ5B2CRMrN2H8AycOKTIo6Lw0q2y00dRebyYFOOXf
	 t8Mc3i1Hl/6m+vUkHFxua43FOo8mLW9qtDx+XEXIHxAoGbR3I0BaZhRxaPCWjAEGp3
	 ujZMyWaET+yPQ==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.10 00/10] AF_ALG fixes
Date: Thu, 30 Apr 2026 00:01:18 -0700
Message-ID: <20260430070128.219863-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series backports recent AF_ALG fixes to 5.10.  Compared to the 5.15
series
(https://lore.kernel.org/linux-crypto/20260430063604.173525-1-ebiggers@kernel.org)
I changed memcpy_sglist() to use atomic kmaps instead of local kmaps,
since local kmaps are not available in 5.10.  I also added "crypto: doc
- fix kernel-doc notation in chacha.c and af_alg.c" to make a later
commit cherry-pick cleanly.

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

Randy Dunlap (1):
  crypto: doc - fix kernel-doc notation in chacha.c and af_alg.c

 crypto/Kconfig               |   2 -
 crypto/af_alg.c              | 137 +++++++++++------------
 crypto/algif_aead.c          | 203 ++++++++---------------------------
 crypto/algif_skcipher.c      |   6 +-
 crypto/authenc.c             |  32 +-----
 crypto/authencesn.c          |  84 ++++++---------
 crypto/scatterwalk.c         |  98 +++++++++++++++++
 include/crypto/if_alg.h      |   5 +-
 include/crypto/scatterwalk.h |  32 ++++++
 lib/crypto/chacha.c          |   4 +-
 10 files changed, 272 insertions(+), 331 deletions(-)


base-commit: 49e5d20074c20b20773c6dc0f8dce0635591093b
-- 
2.54.0

