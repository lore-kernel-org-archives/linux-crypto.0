From: Johannes Goetzfried
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Subject: Re: [PATCH] crypto: serpent - add x86_64/avx assembler
 implementation
Date: Mon, 28 May 2012 16:10:32 +0200
Message-ID: <20120528141032.GK17705@kronos.redsun>
References: <20120527145112.GF17705@kronos.redsun>
 <20120528093709.20517gw0jqzuyvbs@naisho.dyndns.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Tilo =?iso-8859-1?Q?M=FCller?=
	<Tilo.Mueller@informatik.uni-erlangen.de>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:56268 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab2E1OKh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 May 2012 10:10:37 -0400
Content-Disposition: inline
In-Reply-To: <20120528093709.20517gw0jqzuyvbs@naisho.dyndns.info>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

> Should be serpent_sse2_glue.c?

Yeah, same error as in the other patch :-)

> >+}, {
> >+	.cra_name		= "ecb(serpent)",
> >+	.cra_driver_name	= "ecb-serpent-avx",
> >+	.cra_priority		= 400,
> 
> serpent_sse2_glue.c has priority 400 too, so you should increase
> priority here to 500.

You are right. Actually it is useless to load both modules at the same time and
so this shouldn't be a problem. But better be safe. I'll resend this patch as
well.

> Actually about duplicating glue code.. is it really needed? On
> x86_64, both avx and sse2 versions process 8-blocks parallel and
> therefore glue code could be easily shared (as is done in SHA1
> SSSE3/AVX).

I thought about doing it the way as it is done in the SHA1-Module. But I don't
think that's a good idea, because then I had to compile both implementations in
the same module and decide at runtime which one to use depending on the
processor capabilities. This would result in an increasing object size and on a
specific processor only one implementation is used. I think it's better to
decide statically at compile-time which implementation to use.
I agree, the code duplication is ugly, and have a different approach. All the
glue code shared by both implementations can be moved to a serpent_common_glue.c
file and only the module init stuff needs to be seperate. This should reduce
the code size and keeps the possibility of compiling only one implementation. I
will send a second patch which should do the job.

- Johannes
