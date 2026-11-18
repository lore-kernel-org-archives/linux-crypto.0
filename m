Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794975055;
	b=kt9tmU0v3P1XV2L8R0Ls0JO3NOzJmJiRH9whmGt/zvz4PNmIt9awS2lUpfz7FZwCeeYX
	 1dxVXkWaKlibpg6qyctTw+Lw5zR3mvIC6Um13dxgqc50Sqi8Ky9McPQrdpaTMtzUf5m1Y
	 qjurUubZMhp6flQO7J1BbHMeq3z731QGnw7932jtLmZ7Kl89khNZuYNQEjuVY+PYViN8r
	 r2EYFWNsKfUm9v6hXSY4SpM/0ewRPlo/wXI+O6QjLk2LTtiTqaihj7EluB0INFxIws69I
	 zg8YsPsg/n2IlFkBXb9/Zs2lVRg6KZ24XNmznTfOzlJsaYbGA4qzGo9JrVyFUGHtCfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794975055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1aRJNlS1bNR9VCfuv4TEabITRH+PuerIEv0eYXqfLds=;
	b=hZVE9bWB1VP4/FQOfgKP42JeBESBrV0IUNJ06y4TgODNAMnC+Vcfn4+g93yRDwXQpc5z
	 8944rkYnzcAi/JTRk9J19A9fsTTzf8xR2AxdWhv6iZ1RdmjP4RTtSRiSLo3dXzmH2ssqZ
	 tSyYmMR+oC7Tx7Rc2FWlDui84iAk5XGDwsRaJ7BbHBzo6H5ZaAicaaIFJX/TFn418pP0h
	 3UQpslfkl4kYeTtGNu62HPhtkIzp5lOVHdEVN4zxiWjdwcuzunvj/4mQVyj6xDk2+aP7R
	 xk0beqz6sNuZg+2wqvj4ZwMIOTeMZEeyI/uGyyJKqKAGLcItdPTJX69Z0VMaVC6KdsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L8wylom9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024CF606A325;
	Wed, 18 Nov 2026 04:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L8wylom9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4597B1F000CA;
	Wed, 18 Nov 2026 04:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794975054;
	bh=1aRJNlS1bNR9VCfuv4TEabITRH+PuerIEv0eYXqfLds=;
	h=From:To:Cc:Subject:Date;
	b=L8wylom9tCgDm0bV8VAwNbWEggzkkZVvyoe/rK7ItxJOGkZttS7dvCBTlZcVOedE5
	 QYrZ8NVW5XY118w4aSCQ5a1ozCrUzilAQRUQQf6dNJLvvjdKTVV2FlK/ut26Hkbswr
	 dOQfU6rWN9rOLaOTyTw/1Zofa9M44sM7bhr7qPRNH2ZIptgjsdG1mruaEN95Tsxp5R
	 AaGm3nl/HEmSpY3T0hOgF3CWUagJOhQqCrGRMHsoHrKCaq2lE18SqmCbKEHZCeGdix
	 jPI6/0ZRAppIKE+7VgN8t+OKqr4ZJI13TkDtSarNnCjmz8xIm2QSxOAISQXpH5lXGW
	 objfUc2wihFyA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	sparclinux@vger.kernel.org,
	Andreas Larsson <andreas@gaisler.com>,
	"David S . Miller" <davem@davemloft.net>,
	Stian Halseth <stian@itx.no>,
	Magnus Lindholm <linmag7@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/4] Migrate SPARC64 accelerated AES modes into library
Date: Tue, 17 Nov 2026 20:10:29 -0800
Message-ID: <20261118041033.50014-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series is targeting libcrypto-next.  It can also be retrieved from:

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git aes-sparc-v1

This series migrates the SPARC64 crypto opcodes accelerated
implementations of AES-ECB, AES-CBC, and AES-CTR into lib/crypto/.

This makes the AES-ECB, AES-CBC, and AES-CTR library APIs be properly
accelerated on SPARC64, while still being available in the
crypto_skcipher API via crypto/aes.c.  As usual, the longstanding issue
of acceleration being disabled by default is also fixed.

After this, the only thing left in arch/sparc/crypto/ is Camellia.

Tested in QEMU (specifically commit 97c88c61d45d, which has Stian
Halseth's recent changes that added support for the AES, CRC32C, SHA1,
SHA256, and SHA512 opcodes) with the new ECB, CBC, and CTR KUnit tests
(https://lore.kernel.org/r/20261116062849.1071038-1-ebiggers@kernel.org/)
and CONFIG_CRYPTO_SELFTESTS_FULL=y, using Stian Halseth's patch that
makes the SPARC kernel detect QEMU's support for the crypto opcodes
(https://lore.kernel.org/r/20261117112914.2300417-1-stian@itx.no/).

Eric Biggers (4):
  lib/crypto: sparc/aes: Add and use round key load helper
  lib/crypto: sparc/aes-ctr: Migrate optimized code into library
  lib/crypto: sparc/aes-ecb: Migrate optimized code into library
  lib/crypto: sparc/aes-cbc: Migrate optimized code into library

 arch/sparc/crypto/Kconfig    |  10 -
 arch/sparc/crypto/Makefile   |   2 -
 arch/sparc/crypto/aes_glue.c | 344 ----------------------------------
 crypto/aes.c                 |  13 +-
 include/crypto/aes.h         |  39 ----
 lib/crypto/sparc/aes.h       | 348 +++++++++++++++++++++++++++++++----
 lib/crypto/sparc/aes_asm.S   |  24 ++-
 7 files changed, 334 insertions(+), 446 deletions(-)
 delete mode 100644 arch/sparc/crypto/aes_glue.c


base-commit: 30e5781e2cd0aeffd80d524bbdac176579a3235f
-- 
2.56.1

