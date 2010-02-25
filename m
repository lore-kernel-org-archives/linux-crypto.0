From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] sha: prevent removal of memset as dead store in
 sha1_update()
Date: Thu, 25 Feb 2010 07:37:29 -0800 (PST)
Message-ID: <20100225.073729.174987294.davem@davemloft.net>
References: <4B8692E3.9030509@gmail.com>
	<20100225.071759.98314060.davem@davemloft.net>
	<25e057c01002250731q68bb9e28ld009163f2a009f48@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, mikpe@it.uu.se,
	linux-crypto@vger.kernel.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
To: roel.kluin@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60674
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759190Ab0BYPhL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Feb 2010 10:37:11 -0500
In-Reply-To: <25e057c01002250731q68bb9e28ld009163f2a009f48@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: roel kluin <roel.kluin@gmail.com>
Date: Thu, 25 Feb 2010 16:31:36 +0100

> On Thu, Feb 25, 2010 at 4:17 PM, David Miller <davem@davemloft.net> wrote:
>> From: Roel Kluin <roel.kluin@gmail.com>
>> Date: Thu, 25 Feb 2010 16:10:27 +0100
>>
>>> Due to optimization A call to memset() may be removed as a dead store when
>>> the buffer is not used after its value is overwritten.
>>>
>>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>>
>> Solution is wrong and overkill in my mind.
>>
>> It's overkill because the whole reason it's using a stack buffer is to
>> avoid the overhead of a kmalloc() call.
>>
>> And it's wrong because the reason the memset() is there seems to be
>> to clear out key information that might exist kernel stack so that
>> it's more difficult for rogue code to get at things.
> 
> If the memset is optimized away then the clear out does not occur. Do you
> know a different way to fix this?

Not offhand.  Maybe we can make some external helper function for the
crypto layer that just does the memset, but is not visible from any of
the call sites.  GCC doesn't know the side effects, so it can't
elide the call to that helper function.

That could be subverted by whole-program-optimizations but
currently that really isn't something to worry about.
