From: Johannes Goetzfried
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Subject: Re: [PATCH] crypto: serpent - add x86_64/avx assembler
 implementation
Date: Wed, 30 May 2012 13:32:35 +0200
Message-ID: <20120530113235.GO17705@kronos.redsun>
References: <20120527145112.GF17705@kronos.redsun>
 <m2396il7xc.fsf@firstfloor.org>
 <20120530103025.19252e1urui8sfb4@www.81.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Tilo =?iso-8859-1?Q?M=FCller?=
	<Tilo.Mueller@informatik.uni-erlangen.de>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:50118 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab2E3Lcj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 30 May 2012 07:32:39 -0400
Content-Disposition: inline
In-Reply-To: <20120530103025.19252e1urui8sfb4@www.81.fi>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 30, 2012 at 10:30:25AM +0300, Jussi Kivilinna wrote:
> Quoting Andi Kleen <andi@firstfloor.org>:
> 
> >
> >The driver needs CPUID annotations now (since 3.3), so that it can be
> >autoloaded.  Something like:
> >
> 
> Is it really good idea to autoload crypto modules? Currently loading
> different cipher implementations is handled via module-aliases and
> cipher priorities. With autoloading by CPUID, crypto-modules would
> be loaded and be mostly unused. For example, serpent-sse2 would be
> autoloaded on all x86-64 kernels (well, on those that have it
> compiled as module => probably most of distros).
> 
> IMHO these should be loaded only when needed, as is done with
> generic i586/x86-64 assembler cipher implementations.

I agree with that. Currently when I boot my PC with a new 3.4 kernel all the
ciphers from the intel-aesni module get loaded whether I need them or not. As
Jussi stated most people using distros probably won't need the
serpent-avx-x86_64 module get loaded automatically, so it's probably better to
leave it that way.
