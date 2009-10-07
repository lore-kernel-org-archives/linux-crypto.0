From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/2] padata: generic interface for parallel processing
Date: Wed, 07 Oct 2009 13:44:04 -0700 (PDT)
Message-ID: <20091007.134404.09793111.davem@davemloft.net>
References: <20090831091249.GC32705@secunet.com>
	<20090919231958.GA8097@gondor.apana.org.au>
	<20091007142241.GF15653@secunet.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: steffen.klassert@secunet.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32983
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754374AbZJGUoJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 Oct 2009 16:44:09 -0400
In-Reply-To: <20091007142241.GF15653@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Steffen Klassert <steffen.klassert@secunet.com>
Date: Wed, 7 Oct 2009 16:22:41 +0200

> On Sat, Sep 19, 2009 at 04:19:59PM -0700, Herbert Xu wrote:
>> On Mon, Aug 31, 2009 at 11:12:49AM +0200, Steffen Klassert wrote:
>> > This patch introduces an interface to process data objects
>> > in parallel. On request it is possible to serialize again.
>> > The parallelized objects return after serialization in the
>> > same order as they were before the parallelization.
>> > 
>> > Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
>> 
>> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
>> 
>> Looks good to me.  Dave, do you want to pick this one up?
>> 
> 
> I plan to send a rebased patchset tomorrow,
> so who wants to take this one?

I'll take the padata change, as I agreed with Herbert to do.
But the rest goes to Herbert.
