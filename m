Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E5F23EA97
	for <linux-crypto@vger.kernel.org>; Thu,  9 Jul 2026 15:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783611329; cv=none; b=UsoFUyMxK44JUjtC1FKL+Elk72kfJU4fuUXDSdEjm8/JBMjDdXT08MeCSvyIg282IqE6DU89iJxpiITrl6BB/Q4Tg1b7lpdrspF+lhmGS1X1MxwHD6XHob/fLKtFVjm/1GV78cRVJTe7vPvyUjKYzum5ce7Tu3oZIEOFQqg683M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783611329; c=relaxed/simple;
	bh=39xfaljgl0gfI/LA+64AvAG3ZZgzjVm+dpob5hcuWE4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NZmF7xXx02nxVXrqFzO16uV6rjYhxuc+UtSnpzCp/HpwvKtFuSSAW6z0TNDsLIfwa+J5KOPAISSlGWe+4jdR8daYBzWkwn2F2SyN5mE6gazH5Ue6fxZlaJo5cJ3rMiGD3zki+D/wN0rj5iwrXRfKHzZtKdhQcUlEILu+howTdlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NXGfb7u3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NXGfb7u3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8993B1F000E9;
	Thu,  9 Jul 2026 15:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783611327;
	bh=hJ12/Y+Kpni0Xzsi9fIAojbU42sSAcWsBlUBoEmM50U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NXGfb7u3WDO0+PNMjZjoITUOgCzCfcZiwBhJYD1PZhA0Ly+iVJ4u1CaRfIY2sFBYJ
	 iRry3HPf+W7eKC17e8UV5ffcEDhMoWnClcV7askuQVNBgko5zesRT2Pe2SrflpBkfE
	 sYhvw/8YtYiCie1f1pfPpTFanQrlwZR1qaVhUSdePhOh+ZNyddWeP33osJwM8u7UWZ
	 5JWQ/gH2O5Y4otpMlarhvgsuc85ooAnLWT5u8j7ECwZtXhu9uRlIguURl2VkGIxA2K
	 NCuly08ViQ8xlpAseHbRe5uVHP7ZJ7i+ILtzH9hCzECRSzASVUAc6uaVUK6vdsRdJB
	 9VJbwCrYkEbMQ==
Date: Thu, 9 Jul 2026 11:35:25 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: Milan Broz <gmazyland@gmail.com>
Cc: Christoph Anton Mitterer <calestyo@scientia.org>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: AF_ALG deprecation fallout
Message-ID: <20260709153525.GA6853@quark>
References: <27816cc353731e8e5484adad7d0fc447777727d8.camel@scientia.org>
 <20260708011112.GA3890@sol>
 <04fbbc8611699e469f44edbccdf3cf1ac65075d3.camel@scientia.org>
 <20260708030153.GA14700@sol>
 <aac82bdd-6a28-4e65-97f4-3d5942d2a6af@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aac82bdd-6a28-4e65-97f4-3d5942d2a6af@gmail.com>

On Thu, Jul 09, 2026 at 12:47:06PM +0200, Milan Broz wrote:
> On 7/8/26 5:01 AM, Eric Biggers wrote:
> > On Wed, Jul 08, 2026 at 04:14:04AM +0200, Christoph Anton Mitterer wrote:
> > > [X]Chacha, IIRC, would anyway be used without XTS...
> > 
> > It's possible that some of the "aead" ciphers will need to continue to
> > be supported in AF_ALG too (in addition to privileged use of "ccm(aes)",
> > which already is on the list since bluez uses it).
> > 
> > But we need a specific list.
> 
> Cryptsetup can use AF_ALG to check if AEAD is supported, but it tries to use
> it later anyway, just error messages are more cryptic (hidden in DM kernel log).
> 
> So we should not depend on AEAD AF_ALG support.

What about the keyslot encryption?

> > > Well, I personally don't use any others, but of course other might.
> > > What about all these legacy modes that were used for years in examples,
> > > like cast5-cbc-essiv, aes-cbc-essiv, etc.?
> > 
> > First, the essiv component is not relevant, as far as I can tell.
> > algif_skcipher actually does have essiv support, but it's a relatively
> > recent addition and cryptsetup doesn't use it.
> > 
> > So the potential AF_ALG uses there would be "cbc(cast5)" and "cbc(aes)".
> > 
> > > Does your list have any effects on things like chained algos (which I
> > > think cryptsetup allows to use for tcrypt).
> > 
> > AF_ALG has never supported cipher cascades itself.
> 
> TCRYPT (Truecrypt/Veractypt compatible) supports it, but it handles chain in own code,
> calling always only one cipher to decryot.
> For activation it stacks several dm-crypt devices, so no chain in crypto API is needed.
> 
> My intention was to support all, even historic, combinations, because people
> have old containers. (Note, we only support existing container, we cannot create it.)
> 
> Current Veracrypt supports these individual ciphers (and some chains of them),
> that is what we can use through AF_ALG:
> 
> - AES, Serpent, Twofish, Camellia, Kuznyechik (not in mainline only as external
> package, in Debian as gost-crypto-dkms package), all in XTS mode.
> 
> Historic containers (TrueCrypt) can use:
> - AES, Serpent, Twofish in LRW mode
> - AES, Serpent, Twofish, Cast5, in CBC mode

So all of those need to be allowed in AF_ALG (minus Kuznyechik which
doesn't exist in mainline)?  Can we at least make them privileged only?

> > 
> > > I've wrote just before on the cryptsetup mailing list, that we have the
> > > nice integrity support in cryptsetup for quite some years now, but I
> > > guess only few people actually use it because all the available
> > > algorithms/modes were kinda recommended against[0].
> > > 
> > > I think XChacha20+Poly1305 might be in reach (but still not actually
> > > usable?), having finally a large enough nonce (192bits?).
> > 
> > The kernel has had XChaCha20Poly1305 support internally since 2019, but
> > support for it hasn't been added to dm-crypt yet.
> 
> See my explanation here
> https://gitlab.com/cryptsetup/cryptsetup/-/merge_requests/420#note_2520172869

Again, the kernel supports XChaCha20Poly1305 internally since 2019.
WireGuard uses it.  It's just not supported in dm-crypt yet (or AF_ALG
for that matter).

- Eric
