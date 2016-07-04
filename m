From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 2/2] crypto: powerpc: Add POWER8 optimised crc32c
Date: Mon, 4 Jul 2016 00:57:44 -0500
Message-ID: <20160704055744.GA31609@gate.crashing.org>
References: <1467325185-21091-1-git-send-email-anton@ozlabs.org> <1467325185-21091-2-git-send-email-anton@ozlabs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
To: Anton Blanchard <anton@ozlabs.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:45690 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbcGDF6S (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Jul 2016 01:58:18 -0400
Content-Disposition: inline
In-Reply-To: <1467325185-21091-2-git-send-email-anton@ozlabs.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Anton,

On Fri, Jul 01, 2016 at 08:19:45AM +1000, Anton Blanchard wrote:
> +#ifdef BYTESWAP_DATA
> +	addis	r3,r2,.byteswap_constant@toc@ha
> +	addi	r3,r3,.byteswap_constant@toc@l
> +
> +	lvx	byteswap,0,r3
> +	addi	r3,r3,16
> +#endif

You already have r0=0, so you can just do

	lvsr byteswap,0,r0
	vnot byteswap,byteswap

(the top bits of the permute vector bytes aren't used after all).

Or if you find that distasteful,

	lvsl byteswap,0,r0
	vspltisb v0,15
	vxor byteswap,byteswap,v0

Btw, the value in r3 isn't used after this, that last addi is useless?

> +	/*
> +	 * The reflected version of Barrett reduction. Instead of bit
> +	 * reflecting our data (which is expensive to do), we bit reflect our
> +	 * constants and our algorithm, which means the intermediate data in
> +	 * our vector registers goes from 0-63 instead of 63-0. We can reflect
> +	 * the algorithm because we don't carry in mod 2 arithmetic.
> +	 */

Expensive?  Ha!

	vgbbd v0,v0
	vperm v0,v0,v0,byteswap
	vgbbd v0,v0
	vperm v0,v0,v0,byteswap
	vsldoi v0,v0,v0,8

(or fold these last two together, needs another constant though).

> +	lvx	v0,0,r4
> +	lvx	v16,0,r3
> +	VPERM(v0,v0,v16,byteswap)
> +	vxor	v0,v0,v8	/* xor in initial value */
> +	VPMSUMW(v0,v0,v16)
> +	bdz	.Lv0

That VPERM looks strange...  You probably want v0 instead of v16.  Not
that it matters here.


Segher
