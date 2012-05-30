From: Johannes Goetzfried
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Subject: Re: [PATCH] crypto: serpent - add x86_64/avx assembler
 implementation
Date: Wed, 30 May 2012 19:49:01 +0200
Message-ID: <20120530174901.GR17705@kronos.redsun>
References: <20120527145112.GF17705@kronos.redsun>
 <m2396il7xc.fsf@firstfloor.org>
 <20120530113651.GP17705@kronos.redsun>
 <20120530162645.GT27374@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Tilo =?iso-8859-1?Q?M=FCller?=
	<Tilo.Mueller@informatik.uni-erlangen.de>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:50112 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab2E3RtH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 30 May 2012 13:49:07 -0400
Content-Disposition: inline
In-Reply-To: <20120530162645.GT27374@one.firstfloor.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 30, 2012 at 06:26:45PM +0200, Andi Kleen wrote:
> > I tried to be consistent with the existing ciphers in arch/x86/crypto.
> > In serpent_sse2_glue.c and sha1_ssse3_glue.c it is done exactly that way, so if
> > it will be decided to remove the printk in this patch it probably should also
> > be removed in the other modules.
> 
> 
> They are wrong and need to be fixed.
> 
> Drivers can be loaded for all kinds of reasons, but they are not supposed
> to spam your kernel log when they do nothing.
> 
> In fact I fixed all the existing ones with the cpuid changes, unfortunately
> somehow snuck in wrong code :-(

Hm, ok, removing the printk stuff is no big deal. I would fix this together
with the cpuid probing, when I'm sure that this is the preferred "new" way :-)

- Johannes
