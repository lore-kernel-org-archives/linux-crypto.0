From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] crypto: serpent - add x86_64/avx assembler implementation
Date: Wed, 30 May 2012 17:39:49 +0200
Message-ID: <20120530153949.GS27374@one.firstfloor.org>
References: <20120527145112.GF17705@kronos.redsun> <m2396il7xc.fsf@firstfloor.org> <20120530103025.19252e1urui8sfb4@www.81.fi> <20120530113235.GO17705@kronos.redsun>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	Andi Kleen <andi@firstfloor.org>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Tilo =?iso-8859-1?Q?M=FCller?=
	<Tilo.Mueller@informatik.uni-erlangen.de>
To: Johannes Goetzfried
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:48230 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab2E3Pjz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 30 May 2012 11:39:55 -0400
Content-Disposition: inline
In-Reply-To: <20120530113235.GO17705@kronos.redsun>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> I agree with that. Currently when I boot my PC with a new 3.4 kernel all the
> ciphers from the intel-aesni module get loaded whether I need them or not. As
> Jussi stated most people using distros probably won't need the
> serpent-avx-x86_64 module get loaded automatically, so it's probably better to
> leave it that way.

That means you got a 50% chance to use the wrong serpent.

This was a continuous problem with AESNI and the accelerated CRC,
that is why the cpuid probing was implemented.

Without some form of auto probing you may as well not bother with
the optimization.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
