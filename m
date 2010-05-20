From: Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH 1/4] mm: Move ARCH_SLAB_MINALIGN and ARCH_KMALLOC_MINALIGN
 to <linux/slab_def.h>
Date: Thu, 20 May 2010 18:49:43 +0200
Message-ID: <4BF56827.6070507@colorfullife.com>
References: <1274266725.6930.9823.camel@macbook.infradead.org> <1274266902.6930.9834.camel@macbook.infradead.org> <20100519133028.GA26659@sig21.net>  <4BF427D4.40600@colorfullife.com> <1274292638.6930.10394.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Johannes Stezenbach <js@sig21.net>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	David Miller <davem@davemloft.net>, penberg@cs.helsinki.fi,
	mpm@selenic.com, ken@codelabs.ch, geert@linux-m68k.org,
	michael-dev@fami-braun.de, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, anemo@mba.ocn.ne.jp
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61473 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab0ETQsH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 May 2010 12:48:07 -0400
In-Reply-To: <1274292638.6930.10394.camel@macbook.infradead.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/19/2010 08:10 PM, David Woodhouse wrote:
>> * Unless debug options are enabled, the kernel uses cache_line_size()
>> automatically.
>>      
> ... that's a lie.
>
>    
You are right, I didn't notice that there are now 8 and 16-byte kmalloc 
caches.

Apart from that:

KMALLOC_FLAGS is SLAB_HWCACHE_ALIGN.
SLAB_HWCACHE_ALIGN defaults the alignment to cache_line_size().


Did I overlook anything else?

--
     Manfred
