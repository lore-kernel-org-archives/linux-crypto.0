Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B433422A4F9;
	Mon, 10 Mar 2025 13:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741613214; cv=none; b=aEhaMqfPh2xOo+yewVFhDMsiNVq9EYJL0JB3WBGuZhA5DCan2/Z5j49fEM+s5MjNrNtF5yQMHrXQH9f1+Xc3vUufpv38zjnQjtKa3TKJ1Rby2bkXbq6YmZH/1vzDSOxjiXHww5c5680qqfNdD1nLMjDXx5ni43Ghn12eb5Jps60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741613214; c=relaxed/simple;
	bh=N3LqAtv9xgwiczLq5mos8p80DeKbjKQ3HWsoMCPz7gU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dewtq247hptUNyINXrHhPNFKCJs3MyblOECkLx06Nsjv3rOiM1L0oulke79U7Aq5WsRoZNjboDpCzaaDiO8W03O68oBYN+408vltBuHbIcK5QAzhmOCBa+TAjwEamRWgh7ASj3g8fNtWiSEnLWOqIC57udLo11D6w1iARbzl4nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RdoV3IkE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RdoV3IkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B65C4CEE5;
	Mon, 10 Mar 2025 13:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741613214;
	bh=N3LqAtv9xgwiczLq5mos8p80DeKbjKQ3HWsoMCPz7gU=;
	h=From:To:Cc:Subject:Date:From;
	b=RdoV3IkEjFTCyjk+vh4wApBzmZacRcFGQqPHY3m+PCSB48NEV/x2g81eMefHoVqPJ
	 vvdvfuOdjadGy0ldTzBL/j8Ia4Zk5PUYf+mJi+TgK+2uxGGUbHPwGlHXJcYCynX2ua
	 9deX9syIJ/c0qLVKHcL5FGEzKZ0FUav2On+msnFRe+tumEzulYyhHYwz1ixeYciW9N
	 THLtQtMu0gHmqQfzIZBrY7AXj5Qq11CnScrN0VcNrb0exKRi9gFh3LE1xVE90JUpvh
	 bFvqyJamIH1HqzU/dC1x3z/nX5WT5dfm48Ynl6U2R5337jmipSJOURIdlY6NpnMNR5
	 6N2O6IV1O77Zg==
From: Arnd Bergmann <arnd@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Stephan Mueller <smueller@chronox.de>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] crypto: fix dependencies on lib/crypto modules
Date: Mon, 10 Mar 2025 14:26:39 +0100
Message-Id: <20250310132647.3256818-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

The crypto subsystem helpers for chacha, poly1305 and curve25519 were
changed to select the 'INTERNAL' Kconfig symbols, but the code references
the generic implementation instead, which leads to a link failure when
nothing else selects it.

ld.lld-21: error: undefined symbol: chacha_crypt_generic
>>> referenced by chacha_generic.c
>>>               crypto/chacha_generic.o:(chacha_stream_xor) in archive vmlinux.a

ld.lld-21: error: undefined symbol: poly1305_final_generic
>>> referenced by poly1305_generic.c
>>>               crypto/poly1305_generic.o:(crypto_poly1305_final) in archive vmlinux.a

The INTERNAL version turns on the architecture specific optimized cipher,
which normally usually also enables the generic version, but this is not
the case on all architectures. Selecting only the GENERIC version here is
not sufficient since the architecture specific ones are now hidden symbols
and are only built when the INTERNAL symbol is also available.

Fixes: 17ec3e71ba79 ("crypto: lib/Kconfig - Hide arch options from user")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 crypto/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index aac27a4668fd..76693e3edff8 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -317,6 +317,7 @@ config CRYPTO_ECRDSA
 config CRYPTO_CURVE25519
 	tristate "Curve25519"
 	select CRYPTO_KPP
+	select CRYPTO_LIB_CURVE25519_GENERIC
 	select CRYPTO_LIB_CURVE25519_INTERNAL
 	help
 	  Curve25519 elliptic curve (RFC7748)
@@ -615,6 +616,7 @@ config CRYPTO_ARC4
 
 config CRYPTO_CHACHA20
 	tristate "ChaCha"
+	select CRYPTO_LIB_CHACHA_GENERIC
 	select CRYPTO_LIB_CHACHA_INTERNAL
 	select CRYPTO_SKCIPHER
 	help
@@ -936,6 +938,7 @@ config CRYPTO_POLYVAL
 config CRYPTO_POLY1305
 	tristate "Poly1305"
 	select CRYPTO_HASH
+	select CRYPTO_LIB_POLY1305_GENERIC
 	select CRYPTO_LIB_POLY1305_INTERNAL
 	help
 	  Poly1305 authenticator algorithm (RFC7539)
-- 
2.39.5

