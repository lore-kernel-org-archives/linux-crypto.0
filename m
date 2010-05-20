From: David Miller <davem@davemloft.net>
Subject: Re: [BUG] SLOB breaks Crypto
Date: Wed, 19 May 2010 20:46:11 -0700 (PDT)
Message-ID: <20100519.204611.254862260.davem@davemloft.net>
References: <1274278307.11603.1264.camel@calx>
	<20100519.123325.123438307.davem@davemloft.net>
	<20100520124026G.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: mpm@selenic.com, geert@linux-m68k.org, dwmw2@infradead.org,
	herbert@gondor.hengli.com.au, penberg@cs.helsinki.fi,
	ken@codelabs.ch, michael-dev@fami-braun.de,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	anemo@mba.ocn.ne.jp
To: fujita.tomonori@lab.ntt.co.jp
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46151
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753553Ab0ETDqF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 May 2010 23:46:05 -0400
In-Reply-To: <20100520124026G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 20 May 2010 12:38:01 +0900

> On Wed, 19 May 2010 12:33:25 -0700 (PDT)
> David Miller <davem@davemloft.net> wrote:
> 
>> From: Matt Mackall <mpm@selenic.com>
>> Date: Wed, 19 May 2010 09:11:47 -0500
>> 
>> > I still think we should add it to all of them as positive documentation
>> > that this issue has been considered. And then make the kernel not
>> > compile without it so new arch implementors can't miss it.
>> 
>> I agree and would even go so far as to suggest that we break all
>> architectures not setting it now.
> 
> About documentation, I think that ARCH_KMALLOC_MINALIGN description
> would fit in "Platform Issues" section in DMA-API-HOWTO. I'll add it
> later.

Ok, good idea.
