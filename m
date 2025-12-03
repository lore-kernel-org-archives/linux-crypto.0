Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC64933E36A
	for <linux-crypto@vger.kernel.org>; Wed,  3 Dec 2025 16:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779894; cv=none; b=Nb5oOF634/zZLjdQb6BehBqYfup5hpq/HdhVuRNNHyfXEc71hfMhUtjlLJb4DEddfJk5LY4UNW83uQodPyAEGgRx2pQWUfazg0mqlS4i7bFF/wYEZueraTlaNlBg6tYYOs4g7GWj+35j6TP397nUBwb/Gu/nr/kjgKMnC6RwjUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779894; c=relaxed/simple;
	bh=FsnD99zCt0OJVlSqJHF7KG4E83p7vHtZLxom3RUz8OM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RTT5a41cA07zQ2lVVg+pQlQdkqvp2qiSEhL3TXHOn54oEB6atzBR0i1YEgHsKyioKlpUXIu9BJE7fYSfhb/aw1EW2g+LiT9YiwtFGQUJHwR71rSpX8D9uluEeaur4H563xRLVh28Zs9Bpb3AexF92l6X+sZCSrytjOJ0Yv4CCXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DTWFG44a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DTWFG44a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9993EC116C6;
	Wed,  3 Dec 2025 16:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764779894;
	bh=FsnD99zCt0OJVlSqJHF7KG4E83p7vHtZLxom3RUz8OM=;
	h=From:To:Cc:Subject:Date:From;
	b=DTWFG44aQJFOJxI7XP/wH1CBRkvxvKjmtqw/u7JQ+pARjE9iAp65qiyUkFi2K88bJ
	 NbngfVYoDpAKD3caJwGCeHSl3nj8PRwAFe3oeldyqzB1WqkpzSMDCLopQY1rgy4fV9
	 DWjwUMRcXrdUhpV0D/2RyXyssXzNF33eElmpso83TYMLriG8V7RC8Ydbrqzqa4yqCB
	 8c04+yGeGZEbvcV+zJGbov4x9tYIttL8reSmbXNdTy8stl1SbK5zQ7VeHOUEvMzfJk
	 o/49Flg4w/zAthEjOTmmAbiXCF2SJqgTmsYB0rzpDp2dp9QVyIUZZbCi9Y8/JnQdEv
	 3lIW6xT9wZ2kQ==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/2] crypto/arm64: Reduce stack bloat from scoped ksimd
Date: Wed,  3 Dec 2025 17:38:04 +0100
Message-ID: <20251203163803.157541-4-ardb@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=822; i=ardb@kernel.org; h=from:subject; bh=FsnD99zCt0OJVlSqJHF7KG4E83p7vHtZLxom3RUz8OM=; b=owGbwMvMwCVmkMcZplerG8N4Wi2JIdMgPedxcdP5pb78S4Wenj766Ejx8Z5klV67F1PvzliWc rfEKk2go5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEzkQBTD/7I8b6nmZe9/fKz7 N4tr4dp/2cwLLprW6/tK+hs+kr+W28LIMC+69Y1cjWiG34r5y8+yn/t/JVRFT8ZGXXhW0SHZ5wm 1TAA=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

Arnd reports that the new scoped ksimd changes result in excessive stack
bloat in the XTS routines in some cases. Fix this for AES-XTS and
SM4-XTS.

Note that the offending patches went in via the libcrypto tree, so these
changes should either go via the same route, or wait for -rc1

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>

Ard Biesheuvel (2):
  crypto/arm64: aes/xts - Using single ksimd scope to reduce stack bloat
  crypto/arm64: sm4/xts: Merge ksimd scopes to reduce stack bloat

 arch/arm64/crypto/aes-glue.c        | 75 ++++++++++----------
 arch/arm64/crypto/aes-neonbs-glue.c | 44 ++++++------
 arch/arm64/crypto/sm4-ce-glue.c     | 42 ++++++-----
 3 files changed, 77 insertions(+), 84 deletions(-)

-- 
2.47.3

