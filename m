From: "Hsieh, Che-Min" <cheminh@qti.qualcomm.com>
Subject: RE: Questions about the Crypto API
Date: Sat, 10 Aug 2013 02:15:10 +0000
Message-ID: <A83C99F8370D4D42BEB2D2B3153A6BBC23D55E11@NASANEXD02C.na.qualcomm.com>
References: <20130805202557.GE5752@oc8526070481.ibm.com>
 <20130806070010.GB19754@gondor.apana.org.au>
 <20130806120540.GA364@oc8526070481.ibm.com>
 <20130806141612.GB364@oc8526070481.ibm.com>
 <20130808050139.GA9636@gondor.apana.org.au>
 <A83C99F8370D4D42BEB2D2B3153A6BBC23D55514@NASANEXD02C.na.qualcomm.com>
 <20130810012128.GB6549@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:45555 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031757Ab3HJCPM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Aug 2013 22:15:12 -0400
In-Reply-To: <20130810012128.GB6549@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Thanks for Herbert response to my burning questions. Please see my follow on comments. Please correct me if my comments are not correct.


>> You should use your own list element

This is the conclusion I reached when I looked into our problem. I looked at other drivers and tailtos driver. I believe the only correct implementation is to use our own list, similar way as tailtos driver. Thanks for your confirmation.

Our problem is like the following.  In our current implementation, we follow most of other drivers, (or we were lazy like rest of people, and just took easy way out :-)).  We use the async request list structure, and API to maintain the outstanding requests.
We also develop a set of loadable modules, as test vehicle to test our driver.  Our test module modeling  after  tcrypt, and testmgr,  it is sitting in a loop, issuing various  async request, and then wait_for_completion_interruptable().  
So after issuing modprobe test_module to start a test,  if I hit control C, kernel panic left to right, complaining about list broken....  

>> As for an aborted wait, the user must guarantee that any memory 
>> associated with the request is not freed until the driver has called the >> completion function.  IOW we don't currently provide a kill mechanism >> to the user.

So the correct behavior, is, driver should not be aware of the aborted request above.  It should always do completion callback. That means, after it accepts an async request (return with -EINPROGRESS), the request and the resource are guaranteed to the driver until driver finishes the requests, and do the completion callback. It is the requestor's responsibility to ensure this happening.

>> See for example how we handle this in IPsec.
Can you point to me a list of kernel  module names that handle this.  I can easily look into it for reference.

>> .  IOW we don't currently provide a kill mechanism to the user.

Good. Tcrypt.c and Testmgr is only a bad example?

>> Do you have a particular case where a kill mechanism would be useful >> (memory corruption caused by the user freeing the request early is just >>a bug)?

I don't see a need of it. As long as the responsibility of each is well understood and observed. The crypto api to the driver is like a disk i/o request from above to a disk driver. To the driver, once it is requested, it should run to its completion. However, the driver implementation should always include a timeout function to make sure HW function properly. There is no hanging somewhere. I don't see too many people doing that (including us).

Cheers, 
Chemin

-----Original Message-----
From: Herbert Xu [mailto:herbert@gondor.apana.org.au] 
Sent: Friday, August 09, 2013 9:21 PM
To: Hsieh, Che-Min
Cc: Marcelo Cerri; linux-crypto@vger.kernel.org
Subject: Re: Questions about the Crypto API

On Thu, Aug 08, 2013 at 02:04:05PM +0000, Hsieh, Che-Min wrote:
> Thanks for Marcelo and Herbert for the questions and answers.
> I have a few more questions related to the same subject of API.
> 
> 1. In the crypto_async_request, is the list  element  available to the driver to use? I see most of drivers do "crypto_enqueue_request()"  to keep track of the outstanding async requests.  The only exception I have seen so far is talitos driver where they implement their FIFO to keep track the outstanding async requests.

You should use your own list element since this may interfere with the crypto API's own queueing mechanism, if any (meaning that even if in your particular case this field is unused by the time you see it this may change in future).

> 2. The async driver simply returns instead of sleep.  The requestor of the async request, does wait_for_completion()  for the completion callback from driver.  Can it be wait_for_completion_interruptible() such as testmgr.c does?
> If the sleep can be interruptible, how does driver know the request has been aborted?  The request can be still in the driver queue waiting for the hw to finish execution. How is driver aware to dequeue this aborted request? If not, the link list can be corrupted and cause kernel to crash potentially.

If the requester is using the async interface then in general the requester should not be sitting around waiting for it to complete.  See for example how we handle this in IPsec.

As for an aborted wait, the user must guarantee that any memory associated with the request is not freed until the driver has called the completion function.  IOW we don't currently provide a kill mechanism to the user.

Do you have a particular case where a kill mechanism would be useful (memory corruption caused by the user freeing the request early is just a bug)?

Cheers,
--
Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
