Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795403624;
	b=ODb0mlpVGekrPek+ABIFaEjg13tWwDLVLHQXqoNUIIQPB4xaDHvWy928JHmO2rz9YV4C
	 A9j7BqY6zWuZ7E8TD34sFn2mBIQ8lB5LEg3QjFpfATaTKdHPBOMPlZ1GXJTNt785i2UN6
	 jtFBcSkCpYkVPNuLLzaf9eYhCgsDdX7BSMd4efQZjJahbNRqbvNw5NhFc925XXm724gho
	 9hVFqHRiFb+h2tH7XW9+sdBM2E/PajngnyRkCZ5yfSg2WMfvKotnaVRYFOtUt9YBLXbbw
	 LD2nxVnyvD04QG/bciXEKkxMXBoU4lRQpwHqWrzCEmhO/P1EATPyaZJSOwbixanjnPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795403624;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/xhecgJAhRXiJus1TqrwRJeSjDsfQbNnTdU8Yk7hvM8=;
	b=msmk8jGjwDvLEoGeL0Py7jO5nGCLooC9OyrBrd/uBpqujzSV4Wi/cQesQ6hH1nNXboDn
	 XZUHwfMs+1bgD8ddZlaZJHfuNHJ2jSP+mALv3hv9uxrqkHvTyJMQLbGfx2K+ItRyIjfaP
	 uzkH3gQIgTaaFy2Dn7EOpkcJfEx9pcMafFsHGPAhKKUoQuRpNl/F/iM44OXbn6R/3cMbo
	 2swjpmoWUzljpZUbhP2C1pFQ98rsIeY0vtPoAC7sKvPavUMApCuVdMOXCoMNwqcrkOtGP
	 C9akBpFM09J2aVEfAP7EL/KzzPYQZTkhIihtSHKLfAilxnh3FSCiL+81ay33hN+uhEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cMpQO5H5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E955606A31A
	for <linux-crypto@vger.kernel.org>; Mon, 23 Nov 2026 03:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cMpQO5H5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12501F000C0;
	Mon, 23 Nov 2026 03:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795403624;
	bh=/xhecgJAhRXiJus1TqrwRJeSjDsfQbNnTdU8Yk7hvM8=;
	h=From:To:Cc:Subject:Date;
	b=cMpQO5H5qVee1jWY8QDWiPYu/1s9sP6jKZtT3SffMPYJLwQwvyQaH4KkvpQJXQjPo
	 Dsn7HVvHuM34u7oRNIsblBP4qqEjbAblyotPpsxJbOGOm3re99rmIF0IIiAGckayNT
	 xmS8oL6aiq2Tlcld6hnV4TbISRK5n9QFYXP5F8z5OjyIyZQhf3As/aTr41BRV7dKTI
	 +Bgq0RROnSIhExh3QfHgJbbm9hwAKNHtz7jSTZtYx3IeX09a3+H+XHbnSNFJzwFIHL
	 WqlHZnV9cWD6NesmL0I8RYMFa/gIpgCUI8SPOWKbwfdo++8eNSRFBOAriz6pcogbR7
	 yzCmtaXrebh2w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/4] lib/crypto: Clean up and optimize sha512-avx2-asm.S
Date: Sun, 22 Nov 2026 19:13:17 -0800
Message-ID: <20261123031321.403308-1-ebiggers@kernel.org>
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

A refresh for sha512-avx2-asm.S (the SHA-512 implementation that's used
on all AVX2 capable CPUs), bringing the following small benefits:

  - 6% faster SHA-512 on AMD Ryzen 9 9950X (Zen 5) and
    9% faster SHA-512 on Intel Sapphire Rapids.

  - Negative 288 line diffstat.

  - Slight reductions in text and rodata size.

  - Better comments.

Eric Biggers (4):
  lib/crypto: x86/sha512-avx2: Clean up loading and byte-swapping the
    data
  lib/crypto: x86/sha512-avx2: Optimize message schedule
  lib/crypto: x86/sha512-avx2: Factor out SHA512_Round
  lib/crypto: x86/sha512-avx2: Optimize SHA512_Round

 lib/crypto/x86/sha512-avx2-asm.S | 550 ++++++++-----------------------
 1 file changed, 131 insertions(+), 419 deletions(-)


base-commit: b6a9fa34ce4187cb69d3c588a4bbffc31ce5db8f
-- 
2.56.1

