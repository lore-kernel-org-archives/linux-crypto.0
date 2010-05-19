From: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 1/4] mm: Move ARCH_SLAB_MINALIGN and ARCH_KMALLOC_MINALIGN
 to <linux/slab_def.h>
Date: Wed, 19 May 2010 22:23:28 +0300
Message-ID: <4BF43AB0.2010606@cs.helsinki.fi>
References: <1274266725.6930.9823.camel@macbook.infradead.org> <1274266902.6930.9834.camel@macbook.infradead.org> <4BF437EA.9010904@cs.helsinki.fi> <alpine.DEB.2.00.1005191418520.5729@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Woodhouse <dwmw2@infradead.org>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	manfred@colorfullife.com, David Miller <davem@davemloft.net>,
	mpm@selenic.com, ken@codelabs.ch, geert@linux-m68k.org,
	michael-dev@fami-braun.de, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, anemo@mba.ocn.ne.jp
To: Christoph Lameter <cl@linux.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54382 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab0ESTXy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 May 2010 15:23:54 -0400
In-Reply-To: <alpine.DEB.2.00.1005191418520.5729@router.home>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Christoph Lameter wrote:
> Maybe we can consolidate that into slab.h so that the alignment is the
> same for all allocators?

But we don't want that for SLOB as discussed in the other thread. It 
really wants to be sizeof(unsigned long), not sizeof(unsigned long long).

			Pekka
