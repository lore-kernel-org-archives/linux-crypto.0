Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794558816;
	b=KYYEVpi+iCt+zXBfWFmgYABBJ2B0FF68soDVGUM3WnmmnsBvGNx4TDYqrrszravDqAKl
	 Jhrda65Vs2CZgRnWPgDYDZxFEKYFTCbw1fc77X3gJz77zERtKuIXhPck3Bu8R2lYTDU5f
	 vwMhaZs9XnuOMGbwWxhD1fHVrEsfvsag14kJG89qNrv2nNuZ/u1MpnC6lUj9XdPGuut3k
	 YPsd2H0S31MQ+3zh7L4aCkW157ICn0iodBzX9HZfEg+sEQZ+f+ccdf6B0Oim6YctLn0qq
	 7SH2dVqf+oKc0qpt441MzxTwdO6lSmkCMTZkFloIyUD3uvpbrrrWE/yP94P5g4BN6Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794558816;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=iOZzzH+qoWrcbFgtWcfp2P6+eAll0e3TAJJsDceNKmE=;
	b=evEgVXDPoSE5f0V3sIUekIu59szitEBUT/NuZIi2BHLIyAs+K69th4FZPq8Nv9lqjv0G
	 y3qc7MyfI06IzLOlKsHVDj6D8RTyVV1ztmV8q0V/gVZglr0pFqO5yDp9Z+cDwZYct4+vE
	 T0LkY3lbNy5Q0MLBF4z7JvDolyJGT8X4GYmD/nrHI2kpX+nUTRkRxEtno9PRPxh7mM4rh
	 s6XktFp1Wuqm+0s7d6kZ9xJOZhbZOfdnAmbOcJnp8fUt37W9F/StlGGjR4BqkuPldbGh1
	 FidIEDtyqr6Yi9UvHPBPOhU2Q2X9nt5aFc8Deq+OWZJkk7GgvQTxuPxib1r3IPqDBdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eOQcCMI6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F28606A327
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 08:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eOQcCMI6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DDE41F000C5;
	Fri, 13 Nov 2026 08:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794558816;
	bh=iOZzzH+qoWrcbFgtWcfp2P6+eAll0e3TAJJsDceNKmE=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=eOQcCMI60PDCfJRfWcReY6AaWW4TghwGr5oWntIppeDBZu36PWua9MYpMQyFINvop
	 YBsR41RRZYZ7TxRmWfDpDe2NGPk7n7ixktecYCRWHnbkTv9nVamANY7OEQJDXuNMFl
	 9pbEKEQHcYAcXkYGZztONrUJmAWvRb3ycnvYWffO4Q1qbqe6H1O4ala5tKv7t4iObr
	 qwrWLS+0nTBLAt+TAfC4si9U6+RcDzHjBsN2etXKzI4/LjtGTeO3sme4pbW7v00Acx
	 /xE9S/kqPIgUmzr5dZZeMQGwBQ+BSXmj6BH4jwRaQWzioylXGTGu6jRyQYUAJNiybO
	 kS6qyXGwcJOdQ==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id ABB6D198005A;
	Fri, 13 Nov 2026 03:33:33 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 13 Nov 2026 03:33:33 -0500
X-ME-Sender: <xms:XMv2ap2dVE_YH2qatbj9wP-6MW5Yz4mi1jDhoGetPuPonoCKUnug5w>
    <xme:XMv2aq797BozigB6KIbYbOBdScRmvbSy1L6xxUobWxD6oNB9B-aVEsd1ZFQXNF6-z
    voyFv5CA1A9XjWKVQjq2-uxQtEw6r9uPAdSTVZKa5LtToPkVOq3Amqg>
X-ME-Proxy-Cause: dmFkZTFyexHJmVFKl2quirxx5RzfKjnvPam97iJUjXKoTAhJzHFPCztFGb2XjFopBolqLP
    3llWHsZYh5V3VZ00WcWrdxP/7vtMnJTcFbW2tHlR//gTU4x4Zv8WTBPx5DG5V5m6aGlJ2K
    81iqmE4AGMHfYJm7O+/9NQpcYo3BP4SWKooeJH4DlX2PICkzzoL1H8N2gYlykOMLSHrIKY
    yFcEEuDgeDelh7wlHsLHThZAryD2h8jAfyRfmusAYaVsxeXya4WRfhl/F1muZyRH1Fe98t
    qnwA/SYV2YylpwPZno+STrMS1+fvzb2yZIqR8oVBkE4LFzu1VYkcglOyl0TOqkMxs+vsM7
    6xqV+0rdSmHs2npiJuXDeG4lh6m472DJRARtBjuYq+ET+1CzROA0m4Dg2yihRHLV4SMJrB
    DeDp5/3Me2fVYUNKDCeOSH4iPfjcclbxQWo1LLkvYwS/qpCkcILqrUKTGjAkBMTUXcwZ7p
    ENRb+/oXuUXxSXnZO1Z62Q91FqDsKax4l+4r6isRNlexdp5M6jEFfNnNDLIwfEAaRdS+y4
    Us5hspelhcjM4HOYsH2tNeOemkvY0c+gav1pNTTINIqyMJk6TcRyYKEhw/wZEBAyA+6FOo
    fUkQpBj8AUuT04dN/ODYbp9tIsTgqrfFAlbVKhYALyFZklHNfuzhN21kA0hA
X-ME-Proxy: <xmx:Xcv2alKSB7H7Z-1Ubi__AAiTBEAgrvZLPDKjeFDT4jYyWtXya6h0MQ>
    <xmx:Xcv2ak06uCSbXD4tfI6DtscUFUP-9CB9Haks_C41VPn7rWN8X0MucA>
    <xmx:Xcv2anhbkfS8d3bfU5i9N4m3oPpflv-t3wcyFEl_UpBIKQ3kpmES9A>
    <xmx:Xcv2atUxnwA_8QVlmtFVioRwU1y8XmZuER4ad8sx72DYmcPCZcCPlg>
    <xmx:Xcv2auVkX1fdHrv-n7LF9obrEBhQbhDSQsxIUUhKcMXS0NY8vShZiJ_k>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 51E2DF80093; Fri, 13 Nov 2026 03:33:32 -0500 (EST)
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
X-ThreadId: ABFLo8L0UoiV
Date: Fri, 13 Nov 2026 09:33:12 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>, x86@kernel.org
Message-Id: <90713381-4f8e-4d72-a448-ee50b1cdf3d5@app.fastmail.com>
In-Reply-To: <20261112082839.414786-2-ebiggers@kernel.org>
References: <20261112082839.414786-1-ebiggers@kernel.org>
 <20261112082839.414786-2-ebiggers@kernel.org>
Subject: Re: [PATCH 1/2] lib/crypto: x86/sha512: Partially roll up
 sha512_transform_avx()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Thu, 12 Nov 2026, at 09:28, Eric Biggers wrote:
> Currently, sha512_transform_avx() unrolls all 80 SHA-512 rounds,
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
> easily get access to) with the AVX2 code disabled.  SHA-512 throughput
> actually increased by 8% as a result of this commit, likely as a result
> of the code fitting much better into caches.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/x86/sha512-avx-asm.S | 124 +++++++++++++++++---------------
>  1 file changed, 67 insertions(+), 57 deletions(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>
