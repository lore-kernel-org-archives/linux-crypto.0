Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795519764;
	b=zXsv+ynTOc+0vQ0NcHFsVogklz3ZAti+/eYW0ByQK/FG7XmG1QAvMCqYrA5eVA257c4f
	 J7nQ2dLetz0w4WIsFDn6KsvbRN3pH2e2GrKSf7J+vv00yo3oztiZKjzAcKmlE15mhD5C6
	 NDxIZ3o6aAhPPaA/HMGxQhLA5waMWgWWdop8LXxJ4c+Th5VNED3V0rpjkd7+QeXct8Yfw
	 XQdMIzUPLvNsgrw/TasKgrXrb/Zovkui6suRyrJhaWLbOD3evNhAIUgAgozpUa4qfQx/d
	 XHxT9pcKPQIvAXNqHreSDcozAWk/y0opF5MFoT9NmGUPRhzVr5pSG6O+Yu7fEMCinyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795519764;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=pXtHtsZoNfv0qMhggWoMh6/Hrs7VJgKYLWO8UN74DcA=;
	b=JjSdXz6fOObVPpy9wKnVPBB16buIv4byvEuVT6GF0Q0AAr7OkpV9mHeGp4Bb3y3AtNZs
	 8RT0S9RJTlqN7F9VjJ7l1WR8Oz9UXq3ejOZH6a+WRmH2143Gru8eMPJ1O6EQqg+wHrSFm
	 9mB/VCNtvr9b285VIHq5LNuuxEiocNpbZ4c66KZg+tIXZZPEazaOUYi0dIv/C3TSjozUj
	 2pKUfk/D+7voSvX4lgeR8/bPLLayRocw3pSBTQSKV80QAf6Asdltx9ICBaHKMpagxB4Zj
	 OpVdUYyXnIESp2wFXIxk1P4Z76A6p/+9VMINKuKsIuR+PydEJr3g+Us89JmBUsAY2tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bsHD6ivX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3EC606A31E
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 11:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bsHD6ivX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E8C1F000D2;
	Tue, 24 Nov 2026 11:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795519764;
	bh=pXtHtsZoNfv0qMhggWoMh6/Hrs7VJgKYLWO8UN74DcA=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=bsHD6ivXuoljUVEDIpzqTvSselInCbK68+8SY1CQtsTtP+tw0ukfh9fvdCagAXygT
	 /IWEUqpu07w3L8pNktMHF3e3jrd4JFP8noddJrqb+NKuOqm1ZfaDR9h3i/8NjoQ/vq
	 JJMTc6w9JXrsWoXYeC4IJsCNEyTRKAIdu8OjO2Ml+GG6IaPEBueeNR8vtix/X4txQ1
	 GVhZpWDgse3gmC1uAeg4AJCnVPy7EmW7rTLxNY/nVSwgQimdSRbeS/pR+mh2wFskbQ
	 O+/DYGB99PLqjAcf6WDFFxk1SpLl92HLanZAf2bDMBrzr6aaYeJ98ZmIoNVaS+ga1t
	 /1kwm2Yz+yojA==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 4F4FF198003A;
	Tue, 24 Nov 2026 06:29:22 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Tue, 24 Nov 2026 06:29:22 -0500
X-ME-Sender: <xms:EHUFa17Z8x9JKlyqvzHMFh7tHanSVoAy5jUPPJDAExj5Wt2BxINEkA>
    <xme:EHUFa9vUVHIglVJPsQ2fsnib-WMw0XIZOnLfB2YirSoxt7NSnx9aKZPhv2tSK3Cx4
    sxeUvspW9c3jvkhGnar2V-uMifpSDqhtL01-ubk2PZyXEL4eSsdB-ZE>
X-ME-Proxy-Cause: dmFkZTFtfxC8Oas3461N9p3SxIa6xhDg1wMh1Bpd5achPsjmIQ1Nr5xT8yo6b8PY9DvhEn
    ggzrNs1e8P/xEGpDlpVr4UOhHhgCNrkFHxqk585ggELGYVm9bSwE29Zs5mB2psd4QC6sKi
    gwCBItyJq4iyihRaGjVRi5TfgE7wxl6Ejo32qRZBxo52+AYUcA8uhXmQag888DxB3AobC/
    Ck6OUDGjGuBKj1wLJ7N2n+yyRMXpqvyAzU26yWZjbGsYcOeCZjS5a57dMGKJPUiPgHsqus
    bguB0cMg1DEfM0KIThnkjfzcdLdtTRjvync7Xt2aMT1nCD4h4J12HMWLAn0z5WlnYFOFlb
    vGkelUyhX1W6N2jl9Zqt4E6KgBld1tbOofzyJhTvb4Y0/i/joMJuNd2nT0w8NOUarvd4Hg
    slqw5jv3OLLUX30zoHlFe45sPMi7Hlb0P283KeX779bVXJ/gy3V4DKOvKC+hmwWQCCAOB2
    eptNS8koApbFeTUD/WyW2dBLxa2opLYIRkczOIK9NegK2AU08KVKr8EO8JEIPHcV/brLSi
    1oFI2j7LXbiKjiGAe8Ru2VdElVPZKmd4SyMwOz5lmo/D4KE9D72F46rgpPBqfgHV3v/CW+
    tQW9dA3GjbwibeHlcpZ/Uxt/OheQDiGEw32wIBKGAqCbBgVs/FgX2vU7872Q
X-ME-Proxy: <xmx:EnUFa4voJhpgLa7QuGxfpY_EvotXDRYcxolWUFP5xexEhubrN_8Wnw>
    <xmx:EnUFa5ImE_lZBjRv0jKMYezE4o6m_nX5_Enr-X4IM2ZgOSVgoSOYcQ>
    <xmx:EnUFa9nyKbW-pHShQgExEs8G_qRXiHiUsCSmvEWhuBiiLS9q70t_bQ>
    <xmx:EnUFayLMBMWJlyewqmu0aNv_7UCv7e4g93SosR6lNx_oAiLUfZxkBA>
    <xmx:EnUFa65FP0T06CmXpFHSKzZU0zbngZBj0AhZvy6O91Kc8Yqr1PA1-l_u>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 83F11F80096; Tue, 24 Nov 2026 06:29:20 -0500 (EST)
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
Date: Tue, 24 Nov 2026 12:27:22 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>, x86@kernel.org
Message-Id: <1a78f7c9-59de-4ac4-8adf-aee0538d813c@app.fastmail.com>
In-Reply-To: <20261122022030.296468-1-ebiggers@kernel.org>
References: <20261122022030.296468-1-ebiggers@kernel.org>
Subject: Re: [PATCH 0/8] lib/crypto: De-bloat and optimize sha512-ssse3-asm.S
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Sun, 22 Nov 2026, at 03:20, Eric Biggers wrote:
> This series reduces the text size of sha512-ssse3-asm.o by over 10 KB,
> eliminates an excessively large stack frame that wasn't being zeroized,
> and implements various additional optimizations.  Many of these
> optimizations were already being used in other code such as
> sha512-avx2-asm.o; this older file was just never updated properly.
>
> I don't have access to an x86_64 CPU that lacks AVX2 support, but
> running this code on a more recent CPU shows a 30% increase in SHA-512
> throughput.  Since the benefit of the 'shld' hack in sha512-avx-asm.S on
> Sandy Bridge was allegedly 20%, it's plausible that this more than
> closes the gap after the removal of that file.  But even if it doesn't,
> it should be a worthwhile cleanup, especially because of the text and
> stack size reductions and increased consistency with other files.
>
> Patch 1 is an updated version of
> https://lore.kernel.org/linux-crypto/20261112082839.414786-3-ebiggers@kernel.org/
>
> Eric Biggers (8):
>   lib/crypto: x86/sha512: Partially roll up sha512_transform_ssse3()
>   lib/crypto: x86/sha512: Keep message schedule in XMM registers
>   lib/crypto: x86/sha512: Keep W[t]+K[t] in %xmm5 instead of stack
>   lib/crypto: x86/sha512: Keep XMM_QWORD_BSWAP in %xmm14 across blocks
>   lib/crypto: x86/sha512: Use pshufb for ror64(x, 8) in SSSE3 s0
>   lib/crypto: x86/sha512: Keep state in registers across blocks in SSSE3
>   lib/crypto: x86/sha512: Shorten critical-path additions in SSSE3
>   lib/crypto: x86/sha512: Use local labels for data
>

I gave this a spin on my Sandy Bridge machine, which indeed takes a 20%
performance hit from removing the AVX version.

These changes regress it by another 3-4%

