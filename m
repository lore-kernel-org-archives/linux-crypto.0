Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B688726ADC
	for <linux-crypto@vger.kernel.org>; Wed,  8 Jul 2026 03:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783479824; cv=none; b=M46oLc2UUOl5p6eaZ6jCn8gCkZpLteGyD2ZZkFcPkTADTu8YWiefs/2cm9cCE9ZaaYJMVvcAh7+z1FkL2WDdM8UW+CoUdlTimgRn2/lJ/kF8zkElZ+AZ1B2fGHwAl4Vx8zLkjqGfsaw9Hpur2a5r2a5SIMZ5ReBzFkvQndxCLGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783479824; c=relaxed/simple;
	bh=sDnbCYS6Z9ZOxNFgHgGnv695m/8z+6kcWLGoxYnTnnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pfLd3LgFodjrV73cKpqjyQXojSlbUYiDDMz3PP0NIvlg/uoT4fpbs3bL5tdanZEgrTLX/izz1HPNg0qKGVfRJO62rKz7zkQ5iohXORMp3b5V9S653hNLCOe95J12u0x0YVBcrvdBmwl9bZ52qZckZ274E0RpaGfQWSFvcYIET64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Aq+oTsO2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Aq+oTsO2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458071F000E9;
	Wed,  8 Jul 2026 03:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783479823;
	bh=CB8pQGkG6Qaw+/RUsh+AKXbwpn49Y+Oo2JFWa/dmNtQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Aq+oTsO2SojGRi1aTV5M5HuPQKRP1Sqp8DB7TBKtDU6JFyfIGUx2AMyUHwxZOFSM0
	 mu2ls/Ez0wWi+MFAn6pUtXHUHOwswOVyND3J/nJKtXlR4qlVMZFGS53LcmAvjf7+Pa
	 UlA5CyIjvZIV7aMtmm6bMG8tU8TgHrGWVm1lFlbUQvll9TmzzKdyewl4islVBdKwpY
	 muFsmBuyfVEPP4Ue5wYKb7/7eRooGkWVbKsVrotndBtzqPhAnDzFpeMU6pJpTv1lEi
	 WOkWjmGC9N7GzeK9Poj+ms2XUD20jgND0ETnZ8IhGlxZXnIwRbLs/FgiVvgJyJsuEb
	 TvgAh8wpH74rA==
Date: Tue, 7 Jul 2026 20:01:53 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Anton Mitterer <calestyo@scientia.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	Milan Broz <gmazyland@gmail.com>
Subject: Re: AF_ALG deprecation fallout
Message-ID: <20260708030153.GA14700@sol>
References: <27816cc353731e8e5484adad7d0fc447777727d8.camel@scientia.org>
 <20260708011112.GA3890@sol>
 <04fbbc8611699e469f44edbccdf3cf1ac65075d3.camel@scientia.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <04fbbc8611699e469f44edbccdf3cf1ac65075d3.camel@scientia.org>

On Wed, Jul 08, 2026 at 04:14:04AM +0200, Christoph Anton Mitterer wrote:
> Hey Eric.
> 
> Thanks for your fast reply :-)
> 
> On Tue, 2026-07-07 at 18:11 -0700, Eric Biggers wrote:
> > In 7.3 we'll indeed be introducing an algorithm allowlist for AF_ALG.
> > But I already proposed including "xts(serpent)", "xts(twofish)", and
> > "xts(camellia)" on it
> > (
> > https://lore.kernel.org/linux-crypto/20260705184419.40762-1-ebiggers@k
> > ernel.org/)
> > based on their mention in various online documentation for
> > cryptsetup,
> > which suggests they indeed likely have some (rare) real-world use.
> 
> Good :-)
> 
> 
> 
> > I'm interested in allowing any other algorithms that still have
> > real-world use via AF_ALG, if any exist.  If you're aware of any,
> > please
> > speak up.
> 
> [X]Chacha, IIRC, would anyway be used without XTS...

It's possible that some of the "aead" ciphers will need to continue to
be supported in AF_ALG too (in addition to privileged use of "ccm(aes)",
which already is on the list since bluez uses it).

But we need a specific list.

> Well, I personally don't use any others, but of course other might.
> What about all these legacy modes that were used for years in examples,
> like cast5-cbc-essiv, aes-cbc-essiv, etc.?

First, the essiv component is not relevant, as far as I can tell.
algif_skcipher actually does have essiv support, but it's a relatively
recent addition and cryptsetup doesn't use it.

So the potential AF_ALG uses there would be "cbc(cast5)" and "cbc(aes)".

> Does your list have any effects on things like chained algos (which I
> think cryptsetup allows to use for tcrypt).

AF_ALG has never supported cipher cascades itself.

> I've wrote just before on the cryptsetup mailing list, that we have the
> nice integrity support in cryptsetup for quite some years now, but I
> guess only few people actually use it because all the available
> algorithms/modes were kinda recommended against[0].
> 
> I think XChacha20+Poly1305 might be in reach (but still not actually
> usable?), having finally a large enough nonce (192bits?).

The kernel has had XChaCha20Poly1305 support internally since 2019, but
support for it hasn't been added to dm-crypt yet.

> So any chances that the kernel provides a usable AEAD mode for AES (or
> maybe even Serpent ;-P)? 
> 
> Like with GCM but a larger nonce?

We probably should add XAES-256-GCM support at some point, which takes
192-bit nonces.  Historically it hasn't been feasible to do anything
that uses per-request AES keys in the kernel, since the kernel's crypto
API wasn't designed for that.  But we're now moving to a simpler API
where the algorithms including AES-GCM are implemented using regular
functions.  We can build XAES-256-GCM support on top of that.

- Eric
