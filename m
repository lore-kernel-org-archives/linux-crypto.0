From: Johannes Goetzfried
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Subject: Re: [PATCH] crypto: serpent - add x86_64/avx assembler
 implementation
Date: Wed, 30 May 2012 13:36:51 +0200
Message-ID: <20120530113651.GP17705@kronos.redsun>
References: <20120527145112.GF17705@kronos.redsun>
 <m2396il7xc.fsf@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Tilo =?iso-8859-1?Q?M=FCller?=
	<Tilo.Mueller@informatik.uni-erlangen.de>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:64793 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab2E3Lg6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 30 May 2012 07:36:58 -0400
Content-Disposition: inline
In-Reply-To: <m2396il7xc.fsf@firstfloor.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 29, 2012 at 07:27:43PM -0700, Andi Kleen wrote:
> Also drivers should never print anything when they cannot find hardware.
> Remove that printk.

I tried to be consistent with the existing ciphers in arch/x86/crypto.
In serpent_sse2_glue.c and sha1_ssse3_glue.c it is done exactly that way, so if
it will be decided to remove the printk in this patch it probably should also
be removed in the other modules.

- Johannes
