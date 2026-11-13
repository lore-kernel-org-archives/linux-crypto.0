Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794539250;
	b=UB5zfzreByybJEWlsWLakhZ16i4drhEGpv/gG0jcfowiTBIltVp3mUclNSiRgMmNcOKv
	 O6wuk5tfnxvjbkEy6B+w9kwngstDcNfod0+CQkEY5jNKECRBzvKiGeTLCVa5zoLuz1I3t
	 jKBqZzPHYccm7eEP97ScfNbHOdaTKtn3lZtMt09UdRb9LlvXzkyQaz2QTTWguFjoXOV/f
	 8JmiLBYd7GHzwAKytiE+3z1bs0zpNIoT40FRzYitEMtPvDDIhJ44ykDW1T1pSBtkE09u3
	 8Sp3V7SDsdoEAdBwoCkNAJ6oy+aWxCA8gEOkQuXc2H9aGogSMV8lfsyfJ+qVbbSM3Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794539250;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=RuFwcs6knrKwtmFSX2PLOGne3qlkMGnxIsuhyqbJ7mg=;
	b=0rCT5Ekr6S1bjJ9a0nqnkdS6eaco+Sn3fepdfHbXgUORVcqmS5CGnwfgUTfrtWGLPLsn
	 E9P8WVikztzsvIyNqouzW70UlbFO0xxwaxScJ+LBOGqM46ajza2W77Fa3prKRgCm96WEU
	 Ml3CCekPrT51IieW5onChgH6ID6GI5D0ymbJfzqRga9Ora7kfY6qYMcEZNLGEh3RMXUdc
	 g/SBk4ngOZg8/PX/gJurfdzuxjjwS4sa20E56ediioyP7a5OG9p6A4GCrOPGrbH3pzy0l
	 p9jO5pIPuLWESmu6en1jFpCWpy8PfFrkJnhEctzmpv3MPdLIITrHlhEdvtAKvgTPo9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZCTPesQd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4711606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 03:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZCTPesQd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099F81F000C4;
	Fri, 13 Nov 2026 03:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794539250;
	bh=RuFwcs6knrKwtmFSX2PLOGne3qlkMGnxIsuhyqbJ7mg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZCTPesQd5p4pWqKOkGZYavcf2tCxPTq6lpDrZVuosO9qcZOSia9H92p1p6YOp5HN5
	 0qDez02nUBT/5OwghZxB0tZTALUfuB198YQ0tBQFuFvKXpryYyVgoW5djHDYcR9UeV
	 NZLAoQFYQxLSoWsaNsd/w55PsDamLV57a3EvGc7O9rkC3ULpdafKhGHRSZ5/bT1Chp
	 91x8SMRi9Z1FObIr5JxmaPSh9ltjGDQcRsYZd0SkuD7r4llj1EQctVPI9BO0LEFC8f
	 X3fKWnsoU6otWAeSW8/rt+PKEYvFXrcbd8baQnfWZl6T1Wv3C5A2UKqiXlfxmTx+pY
	 xhw6/Ci5ZTO4A==
Date: Thu, 12 Nov 2026 19:07:28 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Antonio Quartulli <antonio@openvpn.net>
Cc: linux-crypto@vger.kernel.org, Antonio Quartulli <antonio@mandelbit.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH 1/5] lib/crypto: tests: Make the AEAD dst clearing
 check effective
Message-ID: <20261113030728.GB1742@sol>
References: <20261112125432.3064939-1-antonio@openvpn.net>
 <20261112125432.3064939-2-antonio@openvpn.net>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112125432.3064939-2-antonio@openvpn.net>

On Thu, Nov 12, 2026 at 01:54:26PM +0100, Antonio Quartulli wrote:
> From: Antonio Quartulli <antonio@mandelbit.com>
> 
> The basic validation test checks that decryption clears dst on
> authentication failure, but its plaintext is all zeroes, so a
> decryption that leaves the recovered plaintext in dst passes the check
> too.  Use a random plaintext instead.
> 
> Signed-off-by: Antonio Quartulli <antonio@mandelbit.com>
> ---
>  lib/crypto/tests/aead-test-template.h | 5 +++++
>  1 file changed, 5 insertions(+)

Good catch, thanks!  I applied this patch to libcrypto-next.

- Eric
