From: David Miller <davem@davemloft.net>
Subject: Re: [BUG] SLOB breaks Crypto
Date: Tue, 18 May 2010 13:59:45 -0700 (PDT)
Message-ID: <20100518.135945.180391159.davem@davemloft.net>
References: <20100518102701.GA7293@gondor.apana.org.au>
	<20100518.122512.73694279.davem@davemloft.net>
	<1274211235.11603.1205.camel@calx>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, ken@codelabs.ch, geert@linux-m68k.org,
	michael-dev@fami-braun.de, penberg@cs.helsinki.fi,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	anemo@mba.ocn.ne.jp
To: mpm@selenic.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34617
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752881Ab0ERU7h (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 May 2010 16:59:37 -0400
In-Reply-To: <1274211235.11603.1205.camel@calx>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Matt Mackall <mpm@selenic.com>
Date: Tue, 18 May 2010 14:33:55 -0500

> SLOB honors ARCH_KMALLOC_MINALIGN. If your arch has alignment
> requirements, I recommend you set it.

I recommend that the alignment provided by the allocator is not
determined by which allocator I happen to have enabled.

The values and ifdef'ery should be identical in all of our
allocators.
