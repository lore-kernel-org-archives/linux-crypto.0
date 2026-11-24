Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795518033;
	b=MMJNvdAlIYfpZTxLI8cLDI/vmu4GHZTn1GB62jlaOsqxbH9uHDtRpKhI/c+zVxSB+fAZ
	 nNFb7XLaYvQMT+SO8IaIZghjgQpZhb/IeOqUlYGh/CH/eKTzIp0DH3RqMsdbDE0MGVmzO
	 kHkRpCEuwitF6fa0mNZB7QJ01esZ6GG6ecAk9uLpaKsaZOm7CCZNR77EJWT0rgBMpY//U
	 xwAwZbKH08+Ql0/3SXq5ZcSa0RZy5r7Ij7liUiXaXx7PeXxXy0HW6K7EXF4vuliJ/9ZDL
	 FQCYtphYSrDCEKx7tO0IaifEUCxBim3XuTc34r1qCG7JLlA/eGwuY1q0N3i59kFqgzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795518033;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=/YnvXwhTfGENQSJLu9WY4HBVit7NDNLJeltgAJUPW+E=;
	b=IM89vRsXGFz0VAutbq1iOhUYaLvCNyFXcSzj3egNq1mtg/lq94MrHqOVo19egNQ5p+96
	 f2sIDel+V3VsqeSkxgNPkJxO0cy2L5wS6BnQhYS02RHRR9OgjFDjOSoRXX28QrV1jnMFe
	 6YMYhwjRDl8Ma682ZyTGD0+6cePs6B7zibPi+GIjCPacJvyHnoI5XA/4vkxRdQOdZE0Cy
	 z8bu3tdsIrysWxehr4qzb+VZqUz5U0JRZ3whS5PQQWuqYCQIUcbscKl91BOQtWLNTh9V5
	 nOr4t+crt4YPBDLbRU1ZRpNdl08rDubjrB2xwjc/XtJBw7sIvxpi/mHZF3e/Oq25dZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m9b4aVK7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F5D606A31E
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 11:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m9b4aVK7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 476191F000EB;
	Tue, 24 Nov 2026 11:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795518032;
	bh=/YnvXwhTfGENQSJLu9WY4HBVit7NDNLJeltgAJUPW+E=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=m9b4aVK79ZFJPnt9lrqa6wysXzxD/k8LT5iLO/iBLanWWfJev0V5AZRQmlL2m/eHf
	 7ZeIy3JQrtlyVNE3mKkeuIV4MZZsu7W54IImQtLyacs5DByWZXhX5SZ8hS/YdbjBj1
	 Vx/3ci02RRld1KIkMdQYkeGJcXW012RZRU+yM5K5woB0TmDf3s4INhNDaHAI493djz
	 7w7PeVge8VMtR/5C1NJpDm12XCKwMG0+WsPgD3CPSadLZgyq3Lq8//VeyCuWB9J8X7
	 qo5hx5MuqM3vQwSrzcnPqekaaUy56Z+NIi2tjOmuPksZ5Dej6byEX1yYPCsTnEUCa3
	 OmfaB8wroRLUQ==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 77ECE198003A;
	Tue, 24 Nov 2026 06:00:30 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Tue, 24 Nov 2026 06:00:30 -0500
X-ME-Sender: <xms:TW4Fa_qYCSp2GbYlxxtafpfUhFcdk-e9wZFWjd3edHclCjWbC3uorg>
    <xme:TW4Fa0eSjTPnTcSVh86htfu8JNEC3uZj5Tjnx7d2MpILbifdxtpNpmZheEG3T3_-C
    13LqIeSQwfxa90-ghkhma4EAyDB1ELfc9bksfBcOKOCF4Qfm6UkQMA>
X-ME-Proxy-Cause: dmFkZTGyYgaL6rQaJ7+1Q0ddbTbPL1X0kuudJhX9Q9dzEYls4gZo2Ga6gCRoHTYTnC4W4K
    DFISewG/vz9PxD8J8hyCbLWY8qlDx4ZF7tkw/Nqf6i92G4n9SQ63ati6zbcoiSX4J7XS3A
    35AkJvUrHYTiQulZi/ACqu9LlQDs6OVPF/QJM5g/ocEl58r4KUVXPP3xtbnA4XIvmvURWO
    gdLsq6A++2OXq10/j4A15MevibzutD5zfm/zANnKUUZdeYRKr/8kn/vZk56AFeT9pebeHo
    phg6LsihGPlLbXgs0qFCt9SXee5prxe3acczdkndvEWeNpr3GaI7c9myUMAzPUq0aesVin
    wOHdIjm24jmwjzvHDcq3LvYbYRuiOoXB3EGSVhaG4Bc/DIXaj8pSnNKl9w/7qt1ocQtrWw
    rttGO5YdJ1nigRb+42kdu5atzoLY/WkNxzJE2l9JvWGcWIvLePftj7/cMlc7x7rD6vkbFJ
    jd7lDw428CHOs0kbX2pMHe54PfzzFQndHIGW/ukotowKGa1BkIoPaiyGlDXXPAKlYZGmEP
    UCESvEoLVjeLBa0Nit6+brIwVPwEn0lHpPRR5IJte6YLAJlAqbmlCyR6MXNA+Ffkt0dNaI
    h44SKCd+k53BIDr53ou0gXojnMMTE1b+fxHm5wG52ETb3kqBjVr1Rq9uj8FQ
X-ME-Proxy: <xmx:Tm4Fa0cZnbzUZhHXUvnuXxYVg7n4sZ-PYpCgcKwxl_88MYB2p9dSCQ>
    <xmx:Tm4Fa57OfkplrpEXsZ3bBxXhQeqkitSBrxig63uVTV9uhQBm_6RM2Q>
    <xmx:Tm4Fa_VHC2y7ggJ3UnsxU4X5t8vlVivOYcoXRPXq05LtrKO2HujAqA>
    <xmx:Tm4Faw4xPdPV5P9C1HRQ_eqW183Q3V3-LScBHXexaT1wOSA1j8g-Rw>
    <xmx:Tm4FaypGfq40ucRDqrbGHCVfpRbZKUawN1PWipyDpSb8JcecmQhhKoJZ>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 2E228F8009A; Tue, 24 Nov 2026 06:00:29 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Tue, 24 Nov 2026 12:00:08 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>, x86@kernel.org
Message-Id: <bdfe4687-e7a2-4693-89fd-b1352e7f1ff8@app.fastmail.com>
In-Reply-To: <20261123031321.403308-1-ebiggers@kernel.org>
References: <20261123031321.403308-1-ebiggers@kernel.org>
Subject: Re: [PATCH 0/4] lib/crypto: Clean up and optimize sha512-avx2-asm.S
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, 23 Nov 2026, at 04:13, Eric Biggers wrote:
> A refresh for sha512-avx2-asm.S (the SHA-512 implementation that's used
> on all AVX2 capable CPUs), bringing the following small benefits:
>
>   - 6% faster SHA-512 on AMD Ryzen 9 9950X (Zen 5) and
>     9% faster SHA-512 on Intel Sapphire Rapids.
>
>   - Negative 288 line diffstat.
>
>   - Slight reductions in text and rodata size.
>
>   - Better comments.
>
> Eric Biggers (4):
>   lib/crypto: x86/sha512-avx2: Clean up loading and byte-swapping the
>     data
>   lib/crypto: x86/sha512-avx2: Optimize message schedule
>   lib/crypto: x86/sha512-avx2: Factor out SHA512_Round
>   lib/crypto: x86/sha512-avx2: Optimize SHA512_Round
>
>  lib/crypto/x86/sha512-avx2-asm.S | 550 ++++++++-----------------------
>  1 file changed, 131 insertions(+), 419 deletions(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>
