Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71AC25B090;
	Sun,  2 Aug 2026 22:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785709498; cv=none; b=qcv5BRMIRW1RORT1I259yTn2H64+yYm31O2R2Yoazh4yjljcSdVqhQMgQIvcffEdseesPiB58vA6RVQP2aOyolsb7ibDVz4pykad5NDvstbvZKrcneHrNdQb8Xj5osrG80hARie/e0JY3r/QboryRQbO1DGOnBikom5oZ6AwInY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785709498; c=relaxed/simple;
	bh=5VEojzyiuK/PHew9HHXrU+G7u9CQnCqhKEwnCeNH1Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pMG5UCnIfCHtmg3rKD23YT8pvHrBWPfxVZukBHHQt397Wp7YIUuV0BAUcQ0IcoUM5wAvwxJWBS89izy2d6S6RC7T9tMsc0+89qRpqppIA79Av7cKgLImkI0EyvBDSxClndFN3mVgo4ZZlCE5CXbZx1/w5g9yBiHP49YlfaB+9Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mZKXNWD3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mZKXNWD3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16FE41F000E9;
	Sun,  2 Aug 2026 22:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785709497;
	bh=dQkDJZg8inSXJfTeNqicKEZyOqwzO4RcB79OzZozd0s=;
	h=From:To:Cc:Subject:Date;
	b=mZKXNWD3ehjpaFQ8q3ldJCRzo0J2y82xKPn7CkYBqvHmAVM6ITpIVwWgMjz00vo8P
	 Kwryc9r4xHMQ9HfIyJWPbSR3ZBoex2doIUaf4j9OHAMX4WM1rZavK0Z6MhkXO6ufq8
	 7/OMb4Bs87imPTg1clX3EftabBZCvyvdMno50ieWGrrDfo2NnQkkvekBKiMQl1QmqD
	 HEGTgZxSijAJXUCnhPN06A6Jt9a2CX3Uginu2qGgW/jYBAP2z8zVmRVPMSHZe7D0J5
	 mxB8Dks8XZZCfUo22lCd1qyAYzADZvzR324pY2krsAa5DUmYE5lvMakm9mjKzh2og5
	 YUdLogpwpwSmg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/3] lib/crypto: FIPS self-tests for AES encryption modes
Date: Sun,  2 Aug 2026 15:24:05 -0700
Message-ID: <20260802222408.91757-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add FIPS self-tests for all the FIPS-approved AES modes implemented in
aes.c.  These are needed to exercise the inverse direction of the block
cipher, and to prepare for the planned integration of
architecture-optimized implementations of individual modes.

Eric Biggers (3):
  lib/crypto: fips: Split fips.h into fips-aes.h and fips-sha.h
  lib/crypto: aes: Add FIPS self-tests for unauthenticated modes
  lib/crypto: aes: Add FIPS self-tests for GCM and CCM

 lib/crypto/aes.c                    | 259 ++++++++++++++++++++++++++--
 lib/crypto/fips-aes.h               |  78 +++++++++
 lib/crypto/{fips.h => fips-sha.h}   |   6 +-
 lib/crypto/sha1.c                   |   2 +-
 lib/crypto/sha256.c                 |   2 +-
 lib/crypto/sha3.c                   |   2 +-
 lib/crypto/sha512.c                 |   2 +-
 scripts/crypto/gen-fips-testvecs.py | 164 ++++++++++++++----
 8 files changed, 459 insertions(+), 56 deletions(-)
 create mode 100644 lib/crypto/fips-aes.h
 rename lib/crypto/{fips.h => fips-sha.h} (90%)


base-commit: 6d22ec26295c1412d765e3d687e46224fc332928
-- 
2.55.0

