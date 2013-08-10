From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Questions about the Crypto API
Date: Sat, 10 Aug 2013 11:21:28 +1000
Message-ID: <20130810012128.GB6549@gondor.apana.org.au>
References: <20130805202557.GE5752@oc8526070481.ibm.com>
 <20130806070010.GB19754@gondor.apana.org.au>
 <20130806120540.GA364@oc8526070481.ibm.com>
 <20130806141612.GB364@oc8526070481.ibm.com>
 <20130808050139.GA9636@gondor.apana.org.au>
 <A83C99F8370D4D42BEB2D2B3153A6BBC23D55514@NASANEXD02C.na.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: "Hsieh, Che-Min" <cheminh@qti.qualcomm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:35058 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S968331Ab3HJBVe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Aug 2013 21:21:34 -0400
Content-Disposition: inline
In-Reply-To: <A83C99F8370D4D42BEB2D2B3153A6BBC23D55514@NASANEXD02C.na.qualcomm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 08, 2013 at 02:04:05PM +0000, Hsieh, Che-Min wrote:
> Thanks for Marcelo and Herbert for the questions and answers.
> I have a few more questions related to the same subject of API.
> 
> 1. In the crypto_async_request, is the list  element  available to the driver to use? I see most of drivers do "crypto_enqueue_request()"  to keep track of the outstanding async requests.  The only exception I have seen so far is talitos driver where they implement their FIFO to keep track the outstanding async requests.

You should use your own list element since this may interfere
with the crypto API's own queueing mechanism, if any (meaning
that even if in your particular case this field is unused by
the time you see it this may change in future).

> 2. The async driver simply returns instead of sleep.  The requestor of the async request, does wait_for_completion()  for the completion callback from driver.  Can it be wait_for_completion_interruptible() such as testmgr.c does?
> If the sleep can be interruptible, how does driver know the request has been aborted?  The request can be still in the driver queue waiting for the hw to finish execution. How is driver aware to dequeue this aborted request? If not, the link list can be corrupted and cause kernel to crash potentially.

If the requester is using the async interface then in general
the requester should not be sitting around waiting for it to
complete.  See for example how we handle this in IPsec.

As for an aborted wait, the user must guarantee that any memory
associated with the request is not freed until the driver has
called the completion function.  IOW we don't currently provide
a kill mechanism to the user.

Do you have a particular case where a kill mechanism would be
useful (memory corruption caused by the user freeing the request
early is just a bug)?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
