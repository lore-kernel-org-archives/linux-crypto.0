Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795593302;
	b=DzmWXe0wICzEDYfSeOJufSiIyWTxLUy6OtcQC7BuR22EaiqA8dKgEVoRboNNU3Dl9h4O
	 ojuOGBN8EXdPFcJvOiEC5kIESa2bgt3Cp6R+NXHHTVv2jz1EgnBmQkludiDI6R/qtjYv6
	 +32NaJQ96gzWb9RP7KFNN011ozBfBj3eMdFtk0eQ45vZe4Y9msdlsceGIFfq1fHDeOvAf
	 zacRdglNqbPxVp6nblqo/ht8Z9OcN7LV7Gn5mIVZm+WFbQpnWSpPN+Q0h5l4GvN+6wkKr
	 yVL87Tsc6i1yfTlNTzUhyNqjfcIqvYysu57dKR+3s2Odl9SZm/J22TMJ/GrIUEViljA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795593302;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=P+PWn8R1dfahCELKeZx6no3ZOpWkF5jrmgHuoRjRM3M=;
	b=qJ+M9hWX1o/j1vZgK5yvr+owYmOaeQFyWLK8VydqGsh9HGxOwqvg4TbQGnJs6I5G6SqQ
	 aOhdc2+f8b2yFX4fqgvOW1jUwNtPpph9UFEIvu3hKjDckgZyLxdWAEvsCTwgqxY8f45aE
	 lfLQHMcv6ykGhWeQrRZTAYL2o6mUiWTTuvnOPrvxvyFeWBWQrC1P1/pOkKu12eBv8tBh7
	 OidqunvV159B3cn1FPWopl5uDq7+wk/mdwx2hsKd2I3FBUXJ023Wf7Z4r8LAF8LosYQBC
	 0ott9f7bxhJjZHTHRIfMl7okQlNtRHndv4VnUTte1mhhMeDKxb3p+N5bzFPuS3w5+kA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IT4LQQG9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996DB606A31E
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 07:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IT4LQQG9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C1B1F000C0;
	Wed, 25 Nov 2026 07:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795593302;
	bh=P+PWn8R1dfahCELKeZx6no3ZOpWkF5jrmgHuoRjRM3M=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=IT4LQQG9tdjR2DLYmzjKHpPiTOMej5WgZ8hb1Fz1SI/JFdKhywBWcAOOwSoPVYnuP
	 AWptBUy74jLRbFwVt+2vM2FWpYHWaVGHybovDJ3wvYfFX2RfsRm9+m3Ah5X1V3nOAL
	 kWehASTH8RAoxzv/y+gwPGI5x4F6CgfV8BInIWmjOKbqXmFg1VDr6SEp9v/swxCdH7
	 bYP9vAK8vGaijjqoicrSKDKXJBpvHwz8jL/RIq2bYptYzkFISnYj1erVehTVOVnVG8
	 AENxbISj2shBCg6ImOaNB7kKoknOFibG8yCL5Ll5h9R9xkdTaC7fS9r+48AHomUaSh
	 W61R28Ub2yoww==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id C2E21198003A;
	Wed, 25 Nov 2026 02:54:59 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Wed, 25 Nov 2026 02:54:59 -0500
X-ME-Sender: <xms:UpQGa-XBy8NLMkemcu6UJFQev3Ll7mQh4IVGd9ePm04S6tbSDJuCcA>
    <xme:UpQGa1YgoJ46tz129i3hudkcKTgcfsOuUsAVQsIZ_Ia-7u_Vuvcl8DOz4-ErPNHYF
    J3i9yQnBbgjddlIUInmLloQ1nwClaNYRW9vup2l8VsuO1NODhfL5aDb>
X-ME-Proxy-Cause: dmFkZTFAZXmaHtRlLs+ivBkhqF5xCCsnnDNe0p7PGHyxjPk1qTRm7sbpD7uvTaZkaqbTzy
    ohDEqmYL968d2wwt53JNxRTKcxnHFb7y0qsb0FyXi0JEGwMQD9lOH3w+biXnODI8WZNSnf
    9NLax91NrcGeeE/D33lsymTutdAZ8Ewr+o0pnDb8gSCkRemiZ+b8goboOYO4sAPLKOgxew
    avYRsKornSAGGbxQ512gggqI+X1zLOdPl6Mp0qxOWEvfZ2jWpnn5lwfKNWQ+8ZQNcBzkl5
    vgGEUgog4GUb1DCKb/KKwKyQwz3xHUUUupDz9sNF7sTLvvI3v4kOI5q4hlke8fSbAPkmqo
    L+m6qzoPw5Z/guQ7xAjtxDpdi0MlCfXHUm0IgL5apC+OGYyc18YCdcyDqOEMI4JcXqMrPn
    PyLTl9v/m25gHBom/4f3Ss1g/fgT84Js7Q6eji+5+E813OQlzpOi22tXz9X+Gmz2INDVkI
    Lf54tUAkaPlZ/6FOp9MYxz23HF/l6YCwQItgeuez44ved5bAAt5aZjzhurzBeUAS1A8eKX
    Arjg9VCk5dqo84VRyG2qgyJ9DYGd0E5xeNSW7AeZ0sKepj+44opPsC5mbiKc04dvrWKZUG
    +JmcLG22Nqiw/yulEL5XpOl9FpiMrpYeWJ5flkkfdPhEfCg4JXUh2+LHwTPQ
X-ME-Proxy: <xmx:U5QGa1p4TienryjHSp4q018gvkniZQskvyfsjPsUygdbHC9-0vmzFA>
    <xmx:U5QGa7Vb8zKq_cUcvYYpBlmrUuRQfN-3sMw_erzP7gdFiaGGBmYXXw>
    <xmx:U5QGa8AEoh8KJciV9uEUsNGP_CYtyYabeOQ2NmEef7kak7usTqFARg>
    <xmx:U5QGa331Lc1-Ihp6871Z1zHaCGxBwHAB_yIowUc5ZveXnqwivtIXWA>
    <xmx:U5QGa22j0cI5QB9hqOpotSqNcHwNjHINNGxkzkK68XUWTK57VTGXAjDI>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 30678F80093; Wed, 25 Nov 2026 02:54:58 -0500 (EST)
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
Date: Wed, 25 Nov 2026 08:54:37 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>, x86@kernel.org
Message-Id: <c3d3e98a-ad1f-4b00-86f0-a3f80fa4a0f3@app.fastmail.com>
In-Reply-To: <20261125043159.192004-1-ebiggers@kernel.org>
References: <20261125043159.192004-1-ebiggers@kernel.org>
Subject: Re: [PATCH] lib/crypto: x86/sha512-ssse3: Roll up rounds and reduce stack
 usage
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Wed, 25 Nov 2026, at 05:31, Eric Biggers wrote:
> Currently, sha512_transform_ssse3() unrolls all 80 SHA-512 rounds,
> producing 13.4 KB of text.  It also stores all 80 message schedule words
> in a 640-byte stack buffer, which wasn't being zeroized on exit either.
>
> Shrink both of these to more reasonable sizes (4.7 KB of text, and a
> 136-byte stack buffer that's zeroized on exit) by doing rounds 14
> through 77 in a loop that does 4 iterations of 16 rounds each, and by
> using a circular buffer to hold the message schedule words.
>
> The circular buffer works well because each message schedule word in
> SHA-512 is computed only from words in the last 16 words.  The number of
> rounds per iteration is set to 16 to match the circular buffer size.
> (It's also a multiple of 8, which is how often the state cycles around.)
>
> The message schedule could also be stored in XMM registers, but that
> approach was found to add additional overhead on older CPUs.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> This is an alternative to the series
> https://lore.kernel.org/linux-crypto/20261122022030.296468-1-ebiggers@kernel.org/
> It does 16 rounds per iteration instead of 8, and it replaces the huge
> on-stack buffer with a circular buffer instead of with XMM registers.
> This hopefully avoids any measurable regression on older CPUs, while
> still achieving the two main cleanups.
>
>  lib/crypto/x86/sha512-ssse3-asm.S | 157 +++++++++++++++++-------------
>  1 file changed, 92 insertions(+), 65 deletions(-)
>

This version does not regress in performance on my Sandy Bridge box.

Tested-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
