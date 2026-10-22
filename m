Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792661489;
	b=r7ww3MYP8b6nax4HK9st7z29EUmKobZAERCvHv4pVLdjGxcwBB15nClhF3xNHh0QA7eT
	 k+a/mj5csYZrBWphsh63DjiTVRa5XmYDRnINoU4BtX3frEmejpng+M2sgOgS0UW7ha6hU
	 614EbopuhBoMyZ5fWBYJ7eY+V3c9uCgpTSMOZX36+SAsw03svvEnKkmvRCFRnwR7nnrLM
	 FQBf4dWBmR+rubwan87g1hlKxbKb3sTZytLvoGSokGz9v0gUPizg4T94cEmydvQBROszZ
	 ScDGhei5nhA9/M2lj+LCQnfA3lNCi+iKxOXel5/BH2FwUmt4/eWvy/z4VTE+N9NxjOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792661489;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=5RVGwZT8t4e1zVjXKKi0e2LIbMh0nK8upWy9XAQnYqk=;
	b=xZBoH0YW77yLp9iFejZlBzyZmCimAHoMIyymvug5RJ5hLje4/bGxRngufSccBBGf1Q62
	 9ngtapZ5aV6vYg28eS54eX/wfbSBl0RDCOH6NNsg9pbMj7vDxiYk7Q55lCSLaT4QrHwD6
	 8ddAHHkn6+3OFiaqaz/SfnqopNEk1carJzPzAv3AfWLCYiFU9cIk6h5ji6z7qF4NqyQIS
	 cqtnNFPXPj3KX/9hVGWgYnPpPqYxH4zhlYFMipIUpvuy1ciThBDSj8kCRI0pibkx1P5z4
	 77et/a+WJ+8tLJjSkR35X8uyFeodF1Td+sejWW1zS9M+H0L8JbVLK2opmn3OH0AYYFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XFxrZI4K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3B9606A31B;
	Thu, 22 Oct 2026 09:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XFxrZI4K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F541F000C2;
	Thu, 22 Oct 2026 09:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792661487;
	bh=5RVGwZT8t4e1zVjXKKi0e2LIbMh0nK8upWy9XAQnYqk=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=XFxrZI4KDUHJ5r7WGLaFrHG6vxCNwbHrTcvVV9q90uuCxSkdwG8bajQG2EvZT/qPK
	 9IzfunmsTTm0+VAzTrqsBUQIgjJUYaiQZUNze/5y2JS53SddYU52paizZySzeGagpO
	 0pUz5B7sqL2btYtNYrzHmUPh2IKNmw0km/TYOCAPWTwc2u0Hi2T+GuQvfhoIEyqJcN
	 /r6k7K1srEmd3I6T2W/V8/I1zSKaZxezLjTzXaKrpysPYZc+3ywBEGU1GOjVGrEF9w
	 ZqNQSOfP6ezr59ASwo7mzEIAp+jw4M4M0aYScf6+7sytlQ8E4aVyBV/q1wMwgmBIa8
	 AyqjfweJLbVMQ==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id B8876198003A;
	Thu, 22 Oct 2026 05:31:25 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 22 Oct 2026 05:31:25 -0400
X-ME-Sender: <xms:69fZaqQVwK1DFmdVlAoU2bxJ_E28AzXZnczp1Smr41RqUhpz-BLUlw>
    <xme:69fZaqli-ZSdZd43vyDjdOc5PkJreKYp2Sm1xUHu51_HEVnMk7H2-aPFcVAvrTJs7
    9qXLj3wGSSSAshC7Z8RXTG2wXOCo67StvEqIN6vfPQPUma5i3DhjLkdMw>
X-ME-Proxy-Cause: dmFkZTG0yNsCHIv43dX9nlqrm6DZoOzZrDEcMcejC9UYmP2BqAxOZkNM5VrjFz5aZYVxdY
    YJ0uxjzCchmGI0EEDIqUjVB95pRmB+py2X4nj3BTe8suTrDbq9sEbkO+dScUYAdp74FWbS
    2eEhL2agWbq9FGXjhcju7qvhHIZljJCT+gwgGAreouqyKbrKFAEYLD1CxLN66+awuzbmFQ
    y7nD6Sd3MnXPeBNFP5C24iqg5L/cA0VY0ws0QHOLEngMAkiA6MWBIXOc7jP1bo5qEsNuF7
    hhk6J8Rk5mu8j4B/qBQq98Rj6xHZKoZaZykv6LbipCWV+GCWvPRjQvhHP4pD1jL18APaRD
    fqU74uW5GFbgpWReW7YD5jTROrU55tWPWg1/ofw2dzG+X6ekUnK2hYuaQvMWB4ylVE7VTk
    hvk4U5I/nRcdET2cnXxzCgUw+/PxYlmYxh024BMO2oTayUpotTU80psPK+/4yelcycPcJR
    Hexny9E06HWl/icHwk/NtOs3fnUf/u7lulq/Kq4OmT/FjWGuWUkMwORPICHg15teBeroMw
    GmLP2BJCY36TxT0PSSsl7gJmK34SjZ+zclc6jzlimyykmDl3oQdQKZQDvN2G4QRKHd/N2C
    P35JkbKYy5PjCFnn2sb5WYtH8yBE/Iz+qEmos2wiX1J1eLSB1QCbjpkO4qXg
X-ME-Proxy: <xmx:7dfZanyHPPsKIL31IXY9JXk8gnle0lL2d-6_kfCSgt1zGPM1Hex87w>
    <xmx:7dfZar3-mkDMAMtXx5cZi50kORsKrYCtzKtRyxO5Xe2M02Lp319Q3g>
    <xmx:7dfZalx9vvIMdmee0OzhAKwKdeexltv9Q2TQppeN7gCiaydrCMG6Cg>
    <xmx:7dfZaoUJAQmNHQRaikfFM4qU7BB7GIYI_pdbuW3bnvRhTHWuoP02MQ>
    <xmx:7dfZap9juDy-mV7hJBscy4KhOdwvEZrbGllpe9O7zxU86mFTvC_E-KhP>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 82660F8008E; Thu, 22 Oct 2026 05:31:23 -0400 (EDT)
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
Date: Thu, 22 Oct 2026 11:31:03 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>, linux-mips@vger.kernel.org,
 "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>,
 "Aaro Koskinen" <aaro.koskinen@iki.fi>, stable@vger.kernel.org
Message-Id: <40d8586f-6572-4d98-b271-ffef69d8f78b@app.fastmail.com>
In-Reply-To: <20261022054450.20746-1-ebiggers@kernel.org>
References: <20261022054450.20746-1-ebiggers@kernel.org>
Subject: Re: [PATCH] lib/crypto: mips: Disable Octeon SHA code on little-endian kernels
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Thu, 22 Oct 2026, at 07:44, Eric Biggers wrote:
> Kernels built for the MIPS64-based Cavium Octeon SoCs are normally
> big-endian, but little-endian builds are also supported.  Currently, the
> SHA-1, SHA-256, and SHA-512 code using the Octeon crypto co-processor is
> enabled in both builds.
>
> This code is untestable without the hardware.  However, based on the
> code itself, it is implausible that it computes hash values correctly in
> little-endian builds.  Such builds write many incorrect values to COP2:
>
>   - SHA-1 and SHA-256: The 64-bit integer that contains the last two
>     32-bit message words of each block is written to COP2 entirely
>     byte-reflected, due to missing endianness conversion in
>     octeon_sha1_start() and octeon_sha256_start() to compensate for
>     using native 64-bit loads from the message bytes.  This differs from
>     all the earlier message words which are written correctly.
>
>     Furthermore, the state is written to COP2 with each 32-bit word
>     byte-reflected within each 64-bit integer, due to incorrect use of
>     64-bit endianness conversion in write_octeon_64bit_hash_dword() when
>     the state is kept in memory in native-endian 32-bit words.
>
>   - SHA-512: All the 64-bit message words are written to COP2
>     byte-reflected, due to missing endianness conversion in
>     write_octeon_64bit_block_sha512() and octeon_sha512_start().  The
>     SHA-512 state words seem to be written correctly.
>
> Big-endian kernels aren't affected by these bugs.  These bugs also
> aren't new; this code has been broken on little-endian ever since it and
> Octeon little-endian support were first added in v4.1.
>
> Commit d2a948d2db68 ("MIPS: Octeon: Make octeon-md5 driver
> endian-agnostic") made the MD5 code work on little-endian kernels by
> adding 64-bit endianness conversions to the COP2 macros used by MD5
> (some of which are shared by SHA-1 and SHA-256, despite those algorithms
> keeping the state words in native-endian instead of MD5's little-endian,
> causing some of the strange behavior described above).  However, SHA-1,
> SHA-256, and SHA-512 were never fixed to work on little-endian kernels.
>
> Therefore, disable the Octeon SHA-1, SHA-256, and SHA-512 code in
> little-endian kernels.  This causes the generic code that actually
> computes hash values correctly to be used instead.
>
> Fixes: 82be2dcfa6a1 ("crypto: octeon - add SHA1 module")
> Fixes: c3d0def62001 ("crypto: octeon - add SHA256 module")
> Fixes: fbaa4dfd51a0 ("crypto: octeon - add SHA512 module")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---

Acked-by: Ard Biesheuvel <ardb@kernel.org>
