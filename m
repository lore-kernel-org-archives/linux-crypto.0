From: David Miller <davem@davemloft.net>
Subject: Re: Fixing gave up waiting for init of module libcrc32c.
Date: Fri, 19 Mar 2010 22:23:25 -0700 (PDT)
Message-ID: <20100319.222325.260105122.davem@davemloft.net>
References: <20100320010849.GA30654@gondor.apana.org.au>
	<20100320042103.GB5127@jenkins>
	<20100320042434.GA32294@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: brandon@ifup.org, linux-crypto@vger.kernel.org,
	rusty@rustcorp.com.au
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45938
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752244Ab0CTFXD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 20 Mar 2010 01:23:03 -0400
In-Reply-To: <20100320042434.GA32294@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Sat, 20 Mar 2010 12:24:34 +0800

> On Fri, Mar 19, 2010 at 09:21:03PM -0700, Brandon Philips wrote:
>>
>> Do you see how it is getting stuck though with modprobe bnx2 and
>> modprobe libcrc32c going at the same time though?
> 
> Yes I agree that's a bug.  Something in those paths should simply
> fail instead of waiting around.

I hear what you're saying Herbert, but thinking about this a bit I
really think we should make this situation work instead of fail.
