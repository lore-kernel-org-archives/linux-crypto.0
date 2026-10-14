Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B79554088;
	Wed, 14 Oct 2026 15:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791991629; cv=none; b=ldJtcHeLweaWgQu4g8bTLQ/1cwvIfoV8jnXgMHz8Zptk+rVE2HfTvrJ8e6JbDuZqnDxj1IRuq+ZE53+a/XGpPyRmNPOdiE1YjZi12qjrwf7Sv/Z2ejp8NN971cf/sf7EJphWXJEAsokcnTFuWzwCvW0oOJRb5oWJi5BDcbCloZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791991629; c=relaxed/simple;
	bh=v8OUnttuZU7RuY8wgMzx9E/vknuw6Pb0en7/tTwdQSA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KV2X96+8V/1uO9eQ86h7YzaY6DkiUZ2b9tEmcIG6lIxluGcjP75AWbsWVqXq78HST/F6aGiSdc6BGzQz2D+yiD/FTHoV8QxZ3p8UZxXnJCDg5MFQXbP7i9eot4yV3DXIJet2yCxzgUFIZfsgnDP5O4QyiFDoh+k35f6p8XEAA3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XgD0sNsB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XgD0sNsB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC461F000C4;
	Wed, 14 Oct 2026 15:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791991627;
	bh=Jhe7eZQZFQgn9dtfO2FFpyi1BEJY38i0MQYvqTHTFpM=;
	h=From:To:Cc:Subject:Date;
	b=XgD0sNsBZjV98IVJzmM5dernI5JLraTdtY6aqVoS4XjK6yi1Sls31aGGcm8bvbrDJ
	 zhtIuFug7MsdhvlKV5N4frCM6GYy6Iut0R/6HaOgu+MROsbuXihmnjYBOdjcetSjDi
	 0WR/+ssn4lA2G/VgsBIZHOI+lDc1KTXvSrUzu2R1ShvDApL7ZO/8bZaTAfFriu2hBs
	 5/6C/jtucS6dxBVCYjdj+iz97xqYfbzO7a+1khrZgUMCtg+UJfCjNNJM1QT8VPXYuj
	 MgOeyZeog+X4Yyxdz/pd1uSNmqgClKx2aR/e7j1OhxbW+hpkIpgpO6wSGvr/Im6Vsc
	 fx9wyurc92Rbg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-mips@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Vladimir Kukharenko <vladimir@genproof.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/2] lib/crypto: Use size_t lengths for Poly1305 and ChaCha
Date: Wed, 14 Oct 2026 17:26:02 +0200
Message-ID: <20261014152604.323310-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series upgrades the Poly1305 and ChaCha functions to use size_t
lengths, matching the rest of the crypto library.

It also fixes the (not currently reached) handling of lengths above
S32_MAX bytes, and (not currently known to matter in practice) the
assembly functions depending on unspecified high register bits.

This more comprehensively addresses the issues identified in
https://lore.kernel.org/r/20261012-libcrypto-4gib-lengths-v1-0-ea566c129a2e@genproof.com

This series is targeting libcrypto-next.

Eric Biggers (2):
  lib/crypto: poly1305: Use size_t length
  lib/crypto: chacha: Use size_t length

 include/crypto/chacha.h                |  6 ++--
 include/crypto/internal/poly1305.h     |  4 +--
 include/crypto/poly1305.h              |  4 +--
 lib/crypto/arm/chacha-scalar-core.S    |  2 +-
 lib/crypto/arm/chacha.h                | 14 ++++-----
 lib/crypto/arm/poly1305.h              |  8 +++---
 lib/crypto/arm64/chacha.h              | 10 +++----
 lib/crypto/arm64/poly1305.h            |  6 ++--
 lib/crypto/chacha.c                    |  8 +++---
 lib/crypto/mips/chacha.h               |  5 ++--
 lib/crypto/mips/poly1305.h             |  2 +-
 lib/crypto/poly1305-donna32.c          |  2 +-
 lib/crypto/poly1305-donna64.c          |  2 +-
 lib/crypto/poly1305.c                  | 10 +++----
 lib/crypto/powerpc/chacha-p10le-8x.S   |  2 +-
 lib/crypto/powerpc/chacha.h            | 10 +++----
 lib/crypto/powerpc/poly1305-p10le_64.S | 23 ++++++++-------
 lib/crypto/powerpc/poly1305.h          |  8 ++++--
 lib/crypto/riscv/chacha.h              |  6 ++--
 lib/crypto/riscv/poly1305.h            |  2 +-
 lib/crypto/s390/chacha.h               |  2 +-
 lib/crypto/x86/chacha.h                | 40 +++++++++++++-------------
 lib/crypto/x86/poly1305.h              |  4 +--
 23 files changed, 91 insertions(+), 89 deletions(-)


base-commit: 40f47fa10a1d19c74f48a13d97b2eb19d5fb938d
-- 
2.56.0

