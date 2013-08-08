From: "Hsieh, Che-Min" <cheminh@qti.qualcomm.com>
Subject: RE: Questions about the Crypto API
Date: Thu, 8 Aug 2013 14:04:05 +0000
Message-ID: <A83C99F8370D4D42BEB2D2B3153A6BBC23D55514@NASANEXD02C.na.qualcomm.com>
References: <20130805202557.GE5752@oc8526070481.ibm.com>
 <20130806070010.GB19754@gondor.apana.org.au>
 <20130806120540.GA364@oc8526070481.ibm.com>
 <20130806141612.GB364@oc8526070481.ibm.com>
 <20130808050139.GA9636@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:44283 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965501Ab3HHOEH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Aug 2013 10:04:07 -0400
In-Reply-To: <20130808050139.GA9636@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Thanks for Marcelo and Herbert for the questions and answers.
I have a few more questions related to the same subject of API.

1. In the crypto_async_request, is the list  element  available to the driver to use? I see most of drivers do "crypto_enqueue_request()"  to keep track of the outstanding async requests.  The only exception I have seen so far is talitos driver where they implement their FIFO to keep track the outstanding async requests.

2. The async driver simply returns instead of sleep.  The requestor of the async request, does wait_for_completion()  for the completion callback from driver.  Can it be wait_for_completion_interruptible() such as testmgr.c does?
If the sleep can be interruptible, how does driver know the request has been aborted?  The request can be still in the driver queue waiting for the hw to finish execution. How is driver aware to dequeue this aborted request? If not, the link list can be corrupted and cause kernel to crash potentially.

Chemin


-----Original Message-----
From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-owner@vger.kernel.org] On Behalf Of Herbert Xu
Sent: Thursday, August 08, 2013 1:02 AM
To: Marcelo Cerri
Cc: linux-crypto@vger.kernel.org
Subject: Re: Questions about the Crypto API

On Tue, Aug 06, 2013 at 11:16:12AM -0300, Marcelo Cerri wrote:
> Herbert,
> 
> Let me include a few more questions.
> 
> There are flags in several structures such as crypto_async_request, 
> blkcipher_desc and crypto_tfm. How they are intended to be used?
> 
> For example if I want to explicitly make a call that shouldn't sleep, 
> should I clear the CRYPTO_TFM_REQ_MAY_SLEEP in one of these structures?
> And in which one?
> 
> Since cryptographic methods can be called in softirq contexts, is the 
> caller responsible for setting this flag correctly based on the 
> context it is running?

Yes, although MAY_SLEEP is mostly used by synchronous implementations since async drivers can simply return instead of sleeping.

Cheers,
--
Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
