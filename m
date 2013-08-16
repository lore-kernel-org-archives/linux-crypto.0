From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Questions about the Crypto API
Date: Fri, 16 Aug 2013 16:37:42 +1000
Message-ID: <20130816063742.GB6859@gondor.apana.org.au>
References: <20130805202557.GE5752@oc8526070481.ibm.com>
 <20130806070010.GB19754@gondor.apana.org.au>
 <065BBB7616BCE543832A2EF096986B940A05ADCD@039-SN2MPN1-011.039d.mgd.msft.net>
 <20130809125513.GA7674@oc8526070481.ibm.com>
 <A83C99F8370D4D42BEB2D2B3153A6BBC23D55A6E@NASANEXD02C.na.qualcomm.com>
 <20130810011541.GA6549@gondor.apana.org.au>
 <20130812134913.GA5173@oc8526070481.ibm.com>
 <A83C99F8370D4D42BEB2D2B3153A6BBC23D569CE@NASANEXD02C.na.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: "Hsieh, Che-Min" <cheminh@qti.qualcomm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:33847 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750764Ab3HPGhq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 Aug 2013 02:37:46 -0400
Content-Disposition: inline
In-Reply-To: <A83C99F8370D4D42BEB2D2B3153A6BBC23D569CE@NASANEXD02C.na.qualcomm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 13, 2013 at 07:25:50PM +0000, Hsieh, Che-Min wrote:
> > Garg: For any tfm, blkcipher or ablkcipher, they must return results 
> > in the order they were given.  For a blkcipher which is synchronous, 
> > this is always true by definition since we return only after the 
> > result has been completed.  For an async ablkcipher, this means that 
> > if you receive two requests on the same CPU, then the first request 
> > must be served and completed before the second request's completion 
> > can be initiated.
> 
> Herbert, can you give further clarification:
> (*) This ordering of  result  is also true for others, such as  aead and hashing, right?

Correct.

> Can  you  confirm, or correct the following statements:
> (*)To perform hashing on a long data stream, it may come in multiple requests to the driver;  in a sequence of one .init request,   one or more than one .update requests, and lastly one .final  request.  In this sequence, a request has to be complete, before next one to be issued to the driver. Those requests  should always come in the same struct crypto_async_request.
> Is this correct?

No.  Operations can always be interleaved, i.e., two different
requests can both start with init and then update in lock-step.

For hashes all state must be confined to the context area of
ahash_request.  That is, the hardware must not maintain internal
state, or if it does, it must be prepared to refresh its state if
an ahash_request comes in that does not agree with the hardware's
current state.

Now, I understand that not all hardware makes it easy to do this,
that is why we don't require all hardware to provide the
init/update/final interface.  The hardware can provide only the
digest interface (and most likely the finup interface) and then
rely on a software fall-back for the "stateless" init/update/final
operations.

Accordingly, on the user side we encourage everyone to use digest
and/or finup wherever possible so that the chances of hardware
acceleration is maximised.

> If driver needs to maintain state variables for such (init, update, final), the state variables can be maintained in the request implementation context, instead of tfm context. Right?

Right.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
