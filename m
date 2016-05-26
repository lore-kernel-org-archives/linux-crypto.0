From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: SKB dst field is NULL when AEAD request complete() is called
Date: Thu, 26 May 2016 17:29:02 +0800
Message-ID: <20160526092902.GA1740@gondor.apana.org.au>
References: <CADREXsqviDO5RvN87LmDOQU3By_y8YPaGbcRxDpNW4Eyf62_6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Denis B <begun.denis@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42202 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbcEZJ3H (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 May 2016 05:29:07 -0400
Content-Disposition: inline
In-Reply-To: <CADREXsqviDO5RvN87LmDOQU3By_y8YPaGbcRxDpNW4Eyf62_6g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Denis B <begun.denis@gmail.com> wrote:
> Working with kernel 3.12.14, in AEAD mode, I register my crypto driver
> and the givencrypt() method in the driver gets called when I send
> IPSec traffic. I store the request, and later call its complete()
> method from a work queue. There is no actual encryption happening at
> the moment, I'm just testing flow. As stated, the complete() call
> stumbles upon a NULL pointer exception in xfrm_output_resume() because
> skb_dst(skb) is NULL. When I receive the request in givencrypt(), dst
> is not null in the SKB.
> 
> Why would the framework meddle with the SKB? Has anyone experienced
> anything similar?

This is probably the result of some kind of a bug in your driver.

If however you're sure that your driver is doing the right thing,
then the bug would be in the network stack.  You should discuss
networking issues on netdev@vger.kernel.org.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
