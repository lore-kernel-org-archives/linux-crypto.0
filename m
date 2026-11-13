Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794558873;
	b=uAWwFngT89VY6Av1y25tmsxmYceMShwjeFIvHwpgWMNjh1dU8eaeH27hGTk9DpNHkKMR
	 90qUimoQ8eT3OLJ1Yw2rNoDHTv+k9AuRnfetjjKRzmgfQ03SSK+/svb4O/+21RW55Eyiq
	 UtjbIR0Fs2x1OFCPDEpTSnIoKWUQwJlKtDfem1DTLlbGr4TpMcFH76nQDE4nvC2Gk6Fsj
	 r+/bPWl+qen/QFaNYEC4wq3afeS3as/tT8Ohtv6/O6oCqm1kbbrz3vtu+XznpviOPHBT9
	 HmhR5puXBLz0wJ2FNb7icH8WgpvoMwGsDP6vuOJwn5Yk3ozNApc8ASEg3viMpu/M+RA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794558873;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=TbLj4ohyqbBMK3ackuowCrIpuEQq6wrOzDZPJTdJYDc=;
	b=FZob24DneX9xfvXcfQe8RGYN9qxo01XmzrbKndVRik5lSGvjMKw0dADkIbRewiTii5ea
	 6NTQKQPGSdCJQMT5eVWotSZl3PYEExQL992RzaGx5mGpn2CprQFHP0uF2kSIE9yO9ZWwG
	 /5BdM9mwYCRE2nMQB+t5yED1WRhJ0RLS/a2eXEsPE/C9D4lQocpTFDayuqFNntuI4AaDX
	 p+gMVY6Xke9Vv+h+1X67t5kNrln6tY3NJZFPZ6rsXMw0VkcFyHa8PHgcQgMbfIEHDz3Ew
	 o4q/4ve5F6EjI0aa7ZbN5UFADl3c0/u1mt757d1noMm9zJNhwyrsljLbxRyjHaFBnhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hTR8AAPv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A7B606B1C0
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 08:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hTR8AAPv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3141F000C6;
	Fri, 13 Nov 2026 08:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794558873;
	bh=TbLj4ohyqbBMK3ackuowCrIpuEQq6wrOzDZPJTdJYDc=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=hTR8AAPvKfbl8uTRDqmBBUf1ifj6+1Lhw6jf2+TM9buaT4z5LQHe64ZnBPYWZ1hA7
	 G4PPEskVBmBglj8MAl3uTr3DuODq9aEJ0tSyqUx/lEqNOJ7aXZfjB4xEWzWRtQSBLL
	 LuC/p0xWWWLyxqDTLk98PjE6K+fG9uEHZ75HHznkIT6vZWvn04q6V01Zi4y/DspJRR
	 /U8EBeGg/lN9cwgL5p9i5AyUoW9cYCwr8iDWCQE/7hTK2GIwlyTE6hfhHP7tuEgXmN
	 Bgb4ALrjn3l2sGEMq9aG7/TraiOeOFfKnKkwhRs9Gm6VLwodowi7Sv9Pn7rImEQ6Ku
	 OQz9AQ35tg86w==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 1227F198005A;
	Fri, 13 Nov 2026 03:34:31 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 13 Nov 2026 03:34:31 -0500
X-ME-Sender: <xms:lcv2akYpBa3ehsk1B6vPHcdqxavak9EsHdv9CXCD41b2XggiUoOlYA>
    <xme:lcv2aqNKXuoMLxPtqJ283LXqBq0JGaxbmsb7msg0VhPW77o22Fc78j_CZEzivZbYm
    WwdtS7lZkSU7noKbkOtBPVEo9w2vdmiUiCpIDJYzDTWd8r614SXRFg_OQ>
X-ME-Proxy-Cause: dmFkZTENlgeGbbctmMadMzAB9gj24MlouTzoGKVFMoI0AhWl5rWs9GXHo+4pyPLzJ0BmZq
    Sjn45Qscz9eXIv81rbScxVdw9G7c/Eo7UNEwUPv2D6yTFq9UuUSux8YnoLF/78hMYKkWk9
    Zx+3rmN3IihoajPQXxs1/7oTqRYaBT1K8XntnnEywveidQbe8CmRpJcFGzye5wEpadOhVg
    iswL+jFfOYOFRFHIEh2ClvEx7VHtQj1SKqpr2wk3gqygA5+kSvXf4Y5gNDnp1JHpsobii2
    3n8/CzpA/rND1e3+cUCAbRaU+HkP85SeIyn43PDEexd1U7PyoFmD5Cco4nkLQqGQ8jmUCS
    abERd/X+zRrNzkh1zwKXkyIW25zluu10/9SQq44jRY/msuMvX2FBMFcoLlCVZFyqWQAEIj
    6OTJC9gQCEtbJKmuTnn9h/eQ2kX8RHkNn2SHHziDMc8Qvz+HsDU4Aar1XVvAH1ruYzQFVc
    XvbwaXl8+TiazTQSQKh4yHInBPNfGfMoX4U6Zlbc8+AjdnS8USsm0JJv3XqCYUagSwpbtA
    zG5Z6bxyZKCchZoS8BywEQbLWEADnNEqPtsVxiPCuSnx+wLmcYj7mf+nl1e8Vp6r+WNiNI
    Hvctyfg63J/gq0blmjTOUdvCYCLjM9XaC5TRKq3mLxaBR3OiKQnaKzG+Y9xQ
X-ME-Proxy: <xmx:l8v2ahqSJpo-jBaXkZMCb8Va8KYYEdGru5Y4VoSgyCHpWvGcMzyrkw>
    <xmx:l8v2asHras5-YI9xkwz4rPY4eI_pC8q3mUQwLlh6-T-ddtMC2N6v4Q>
    <xmx:l8v2auo2L4vKXyZxqwFysFZjsRIn4Q96rAAY5jzHKTW5zU7B9c_HEg>
    <xmx:l8v2atZsnqC8byf-QwXuW12p4GZLiZRy08VzLrg5NpZwTka6XqUXTg>
    <xmx:l8v2avW5tDGAGJkiZp7q9cvlMkWbr5Ermr7RlAg6Y4kSQ6i4UvwzFCmc>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id AE26AF8008E; Fri, 13 Nov 2026 03:34:29 -0500 (EST)
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
X-ThreadId: AtFHdaj1YZoV
Date: Fri, 13 Nov 2026 09:34:09 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>, x86@kernel.org
Message-Id: <32ed95d5-1422-4821-837e-53619b6aaa1c@app.fastmail.com>
In-Reply-To: <20261112082839.414786-3-ebiggers@kernel.org>
References: <20261112082839.414786-1-ebiggers@kernel.org>
 <20261112082839.414786-3-ebiggers@kernel.org>
Subject: Re: [PATCH 2/2] lib/crypto: x86/sha512: Partially roll up
 sha512_transform_ssse3()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Thu, 12 Nov 2026, at 09:28, Eric Biggers wrote:
> Currently, sha512_transform_ssse3() unrolls all 80 SHA-512 rounds,
> generating 13.4 KB of text.  This is wasted on most systems, which
> execute the AVX2 code anyway.  And it's also likely to be harmful on
> systems that do run this code, due to cache pollution.
>
> Roll up rounds 14 through 77 into 8 groups of 8 rounds.  This requires
> some additional GPRs, as the offsets into the message schedule words and
> round constants are no longer immediates.  Therefore, free up two GPRs
> by spilling the 'digest' and 'msglen' arguments to the stack; use them
> to store a pointer to the round constants and an offset into it.
>
> This reduces the text size from 13.4 KB to 3.3 KB.  (For some
> perspective, the 10.1 KB saved is greater than the size of all four
> variants of the AES-XTS assembly code combined at 7.5 KB.)
>
> I also ran the sha512 benchmark on a Haswell system (the oldest I could
> easily get access to) with the AVX and AVX2 code disabled.  SHA-512
> throughput actually increased by 5% as a result of this commit, likely
> as a result of the code fitting much better into caches.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/x86/sha512-ssse3-asm.S | 126 ++++++++++++++++--------------
>  1 file changed, 68 insertions(+), 58 deletions(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>
