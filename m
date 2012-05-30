From: Johannes Goetzfried
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Subject: Re: [PATCH] crypto: serpent - add x86_64/avx assembler
 implementation
Date: Wed, 30 May 2012 19:36:36 +0200
Message-ID: <20120530173636.GQ17705@kronos.redsun>
References: <20120527145112.GF17705@kronos.redsun>
 <m2396il7xc.fsf@firstfloor.org>
 <20120530103025.19252e1urui8sfb4@www.81.fi>
 <20120530113235.GO17705@kronos.redsun>
 <20120530153949.GS27374@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Tilo =?iso-8859-1?Q?M=FCller?=
	<Tilo.Mueller@informatik.uni-erlangen.de>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:53704 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739Ab2E3Rgm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 30 May 2012 13:36:42 -0400
Content-Disposition: inline
In-Reply-To: <20120530153949.GS27374@one.firstfloor.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 30, 2012 at 05:39:49PM +0200, Andi Kleen wrote:
> > I agree with that. Currently when I boot my PC with a new 3.4 kernel all the
> > ciphers from the intel-aesni module get loaded whether I need them or not. As
> > Jussi stated most people using distros probably won't need the
> > serpent-avx-x86_64 module get loaded automatically, so it's probably better to
> > leave it that way.
> 
> That means you got a 50% chance to use the wrong serpent.
> 
> This was a continuous problem with AESNI and the accelerated CRC,
> that is why the cpuid probing was implemented.
> 
> Without some form of auto probing you may as well not bother with
> the optimization.

Seems like I missunderstood the priority concept of the crypto API. I thought
both algorithms have module alias "serpent", so they get both loaded when they
are needed, for example by the device mapper, and after that the algorithm with
higher priority is selected. Where do you get the 50% chance of using the wrong
serpent?

If there is for some reason no possibility to make it work this way then cpuid
probing might be the better choice.

- Johannes
