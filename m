Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794500426;
	b=aW2ZNjwOWgWpqRFXWAkpoIybABM2cYow5ENQx61Z5H2nJ+NsVRGLIilJ1dVIKdEEC4/6
	 uXvrPu8aU012psDquN3kVu4LvESAaIz7GX/G6YEplaAGJerTm9HrH+fqIc84c2WscG0xx
	 tz085uFI47w/F6nFBjpb5A+W+i1kwQWIN8Sb6SZKNdWjy7mENRJSzUeZpxmRKEf1pyYrv
	 Bd6BHbB02g3lGcX2/GyOwNwU9yXEuj3MguBMbtBuw6a/F/twJun2XG9fhN6VmXpH1+g9s
	 4LLsfhnDuA+Jy+VuAzohjTcRBWZ0WxW/QlrIFwHczQioYovCqmAezhm3+x0ASE/64kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794500426;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=dNCfrHBpRmRNa7Gswo6HSlGa1At52OBt8g4cO4mvDE0=;
	b=F5XuqBXb+qZUSBO2Y01iuPFHgSWPxFdqqtMovJ//F41FSK1o9ekOErjccXp5IaaBklKE
	 p5vsmQu8uO1fbBWF420+VAFA1w1GpWVjLALsYPTA+tv9waXI5otiAnQ5+M09rddFgTgXm
	 YmonVnWm+1sQKhF4qvJOXvFGD3LcbEE1ekCY/IhZbWwAi5iH58tqKnxzUv6KgSLVi4Lj2
	 /DN6GtfW3jkh7p3ZnKPO4e5lbdwE1uuuBZL5QVI6omAS23xwf6f9sGFFd0fWBzaomuVLE
	 gsLd/Ak3QgfiJ/E85ZII75wRTHQ0omXpAOS+NsNE3MN3N9J/kB54XLwXl+tqHu+ANFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fJIs5x2p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804FF606A327
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 16:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fJIs5x2p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45B31F000C4;
	Thu, 12 Nov 2026 16:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794500426;
	bh=dNCfrHBpRmRNa7Gswo6HSlGa1At52OBt8g4cO4mvDE0=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=fJIs5x2psk2ToojAwv71vfPF2ggriYJLDQD6bZbB8EFAZrOn5P4+rk3LoNhfEhqzN
	 uX/WGbKhd3fN+Xk/NRKIuWsnQfUBrd2zgELl3TT8lHHqSxXbaIT9ygefDElvKkVPXv
	 9Ic17xo6Y8pTE+Qfd9V9sdfuTMv6A0ZxAiGj02ntkPIsYvkawsA/xkdv44/BjCbzgx
	 isPLC3tti2A0RE5oQ/SMXdG3aHEhqbHSiAiBIeOE4lwct+eoePNm2AqfW4GeNjL8G0
	 uq/ZhcTeTx8WDch1BD3RaIXr2QR62wJTTNH0i2igcEa+QXa0BUDWuEHmeUT2nQlqRw
	 fOwqHAS85ZZ4A==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 0611D1980047;
	Thu, 12 Nov 2026 11:20:23 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 12 Nov 2026 11:20:24 -0500
X-ME-Sender: <xms:Ref1altNSs_yp7himxjazOL0UGRHbSTtvrf-jUW2Q1JAPVEUInTSdA>
    <xme:Ref1apSFlRmBZU_MkY63RcoQonFn4PCn015HeZU5CUcvIuXGYmZ2tohwbhcpaPuDm
    BSaZ93-tP30rnsbjrvnRcrK4Dq0BJW1SLaC2NpVltvcFHu71FDlDN8>
X-ME-Proxy-Cause: dmFkZTEbQOowYef7VyDwomYDk8ihuQS4wJiXzuFxQOc/aZivBSaqTY6YbbWbi2YAE+A/Zd
    VlXHGDj7LVnBAQnggfdsZ2eZSTucqH+gbUHwed3/6AGCloPuXYZKYr8gooYq/hf5iOxqxO
    x6YijWIC6rFOCiI1WG6FaBu1HyNgv0G1wHcqvm56fAdqaa4X863q6rHtPGANJbzjohQ03P
    9PTQPumIkghVBxRnawmyOPvLuJ3VpWRTCzDx/LO8doPTsyCkAA8WKJWhKNfbNqSgw2gz8f
    WX6RzDogq/czVUPPK+NKMfvoChQ9kQ6mEDsKPowYy3tFFPVyDXG6VeRaUxs5HgE1X6TGkz
    9hh64qXBJ1pvRAc+INlusvPHIY+Uw+vMCwSezFxmQGye996AtFIoV6o7FMfLxxFlMOEQcs
    69W/Qla4E3u0F2XeQMMVpat90OYqW+vw6GrWeEKorgQG+x6jWH7m5MupCXjhEYBmAOaljL
    jJZdNXVWcmtBLGNv/2duIDrezb32xKfIldL/Izj2GfAc3DOfk+waQTKDwRaulXoFgaldmu
    STXS/XGax+vhaUb59Ik/1tbWwF7JcQ0a0ZC7zSpgAgk4xSNvbgYjNwi4smOXvHRxk1tHjE
    ar77GHlkXzSiV8Gek4K5X77pkOAqu1LMGGDPfOZKLmMXzmckiAgF5zym5VUA
X-ME-Proxy: <xmx:R-f1anQgjLgfTXV6gVzfq93GwtiO5SyoI55j9Iwi-rDL7o1epYUevw>
    <xmx:R-f1arANkPrds7w59VprE0BzeeyEh0tGOHb7lIBqP5N4PJnoq84YQg>
    <xmx:R-f1avHPJUUhBQ01XFXJ4xbqquOQ-MudYiF0r6I5t5M_n-bp9xRNvw>
    <xmx:R-f1atB9x6iZiV1VltYapoWl6Yl-qQsyQr3EfzjAnEj5c8shAxDdPQ>
    <xmx:R-f1avVFbruFqWkoj4zTAGndryQCmdKgdxS8tt3ehy35BoU9PdO0rIku>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 396C3F80096; Thu, 12 Nov 2026 11:20:21 -0500 (EST)
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
Date: Thu, 12 Nov 2026 17:20:00 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Antonio Quartulli" <antonio@openvpn.net>, linux-crypto@vger.kernel.org
Cc: "Antonio Quartulli" <antonio@mandelbit.com>,
 "Eric Biggers" <ebiggers@kernel.org>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>
Message-Id: <1906b5ed-7650-484c-9eb0-a99c8e27c943@app.fastmail.com>
In-Reply-To: <20261112125432.3064939-1-antonio@openvpn.net>
References: <20261112125432.3064939-1-antonio@openvpn.net>
Subject: Re: [RFC PATCH 0/5] lib/crypto: Add AEGIS-128X4
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello Antonio,

On Thu, 12 Nov 2026, at 13:54, Antonio Quartulli wrote:
> From: Antonio Quartulli <antonio@mandelbit.com>
>
> This series adds AEGIS-128X4, the 4-way parallel variant of AEGIS-128L
> specified in RFC 10032 (Informational, September 2026), as a crypto
> library with an x86_64 VAES-AVX512 implementation, a KUnit test suite
> and benchmark, and a crypto API wrapper.
>
> AEGIS-128X4 runs four AEGIS-128L instances, one per 128-bit lane of a
> 512-bit vector, so that each state update is eight VAESENC instructions
> on zmm registers.  On CPUs with VAES and AVX-512 it is very fast even for
> short messages, which is what makes it attractive for network protocols.
>
> The intended user is ovpn, the OpenVPN data channel offload driver. In
> single-stream ovpn tests over a 100 Gbit/s link, with both ciphers used
> through the crypto API, the sending CPU spent 1266 cycles per packet with
> AEGIS-128X4 against 1448 with AES-GCM over TCP, and 1032 against 1122
> with UDP GSO input. It is posted as an RFC because ovpn can't use it
> yet.
>

We used to have implementations of aegis128l and aegis256 in the kernel as
well (along with morus), but we removed them on the basis that it was
aegis128 that won the competition.

As far as I know, nobody actually uses any of that code, though, so I am
quite to surprised to see now that it was aegis128 that was dropped
from the portfolio, and aegis128l and aegis256 have made a miraculous
return, along with some other variants that appear to be tied to the
register width. What happens when 8-way vector registers become
commonplace? Create yet another aegis variant that case use them
efficiently?

So I'm struggling to see why we should take this RFC seriously, to be
honest ...



