From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Mon, 14 Oct 2013 11:18:16 -0400
Message-ID: <CACXcFm=M2Jrra3tttWyhwfs-a6iVm0joiKi=wHKuANe_s_F-Sw@mail.gmail.com>
References: <2579337.FPgJGgHYdz@tauon>
	<CACXcFm=3Ee1+HGYRpsjhFMwqn2t15qAZNnMpZ8jOsE_HkB2CPg@mail.gmail.com>
	<CACXcFmnDjSWHrU-4dR=Nb5n-9t=0PmM9Bc_pOFMTi3eotR2g6A@mail.gmail.com>
	<3593500.a7fOuGKlEX@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vb0-f47.google.com ([209.85.212.47]:38653 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081Ab3JNPSS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 14 Oct 2013 11:18:18 -0400
In-Reply-To: <3593500.a7fOuGKlEX@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 14, 2013 at 10:40 AM, Stephan Mueller <smueller@chronox.de> wrote:

> Another thing: when you start adding whitening functions, other people
> are starting (and did -- thus I added section 4.3 to my documentation)
> to complain that you hide your weaknesses behind the whiteners. I simply
> want to counter that argument and show that RNG produces white noise
> without a whitener.

Yes, you absolutely have to test the unwhitened input entropy, and
provide a way for others to test it so they can have confidence in your
code and it can be tested again if it is going to be used on some new
host. You do a fine job of that; your paper has the most detailed
analysis I have seen. Bravo.

However, having done that, I see no reason not to add mixing.
Using bit() for getting one bit of input and rotl(x) for rotating
left one bit, your code is basically, with 64-bit x:

   for( i=0, x = 0 ; i < 64; i++, x =rotl(x) )
        x |= bit()

Why not declare some 64-bit constant C with a significant
number of bits set and do this:

   for( i=0, x = 0 ; i < 64; i++, x =rotl(x) ) // same loop control
      if( bit() ) x ^= C ;

This makes every output bit depend on many input bits
and costs almost nothing extra.

In the unlikely event that the overhead here matters,
your deliberately inefficient parity calculation in bit()
could easily be made faster to compensate.
