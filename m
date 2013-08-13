From: "Hsieh, Che-Min" <cheminh@qti.qualcomm.com>
Subject: RE: Questions about the Crypto API
Date: Tue, 13 Aug 2013 19:25:50 +0000
Message-ID: <A83C99F8370D4D42BEB2D2B3153A6BBC23D569CE@NASANEXD02C.na.qualcomm.com>
References: <20130805202557.GE5752@oc8526070481.ibm.com>
 <20130806070010.GB19754@gondor.apana.org.au>
 <065BBB7616BCE543832A2EF096986B940A05ADCD@039-SN2MPN1-011.039d.mgd.msft.net>
 <20130809125513.GA7674@oc8526070481.ibm.com>
 <A83C99F8370D4D42BEB2D2B3153A6BBC23D55A6E@NASANEXD02C.na.qualcomm.com>
 <20130810011541.GA6549@gondor.apana.org.au>
 <20130812134913.GA5173@oc8526070481.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:14323 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758627Ab3HMTZw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Aug 2013 15:25:52 -0400
In-Reply-To: <20130812134913.GA5173@oc8526070481.ibm.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> Garg: For any tfm, blkcipher or ablkcipher, they must return results 
> in the order they were given.  For a blkcipher which is synchronous, 
> this is always true by definition since we return only after the 
> result has been completed.  For an async ablkcipher, this means that 
> if you receive two requests on the same CPU, then the first request 
> must be served and completed before the second request's completion 
> can be initiated.

Herbert, can you give further clarification:
(*) This ordering of  result  is also true for others, such as  aead and hashing, right?

Can  you  confirm, or correct the following statements:
(*)To perform hashing on a long data stream, it may come in multiple requests to the driver;  in a sequence of one .init request,   one or more than one .update requests, and lastly one .final  request.  In this sequence, a request has to be complete, before next one to be issued to the driver. Those requests  should always come in the same struct crypto_async_request.
Is this correct?
If driver needs to maintain state variables for such (init, update, final), the state variables can be maintained in the request implementation context, instead of tfm context. Right?

Thanks.

Chemin
 



-----Original Message-----
From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-owner@vger.kernel.org] On Behalf Of Marcelo Cerri
Sent: Monday, August 12, 2013 9:49 AM
To: Herbert Xu
Cc: Hsieh, Che-Min; Garg Vakul-B16394; linux-crypto@vger.kernel.org
Subject: Re: Questions about the Crypto API

On Sat, Aug 10, 2013 at 11:15:41AM +1000, Herbert Xu wrote:
> On Fri, Aug 09, 2013 at 01:09:12PM +0000, Hsieh, Che-Min wrote:
> > Marcelo/Herbert:
> > 
> > I believe It is. Herbert, please correct me if I am wrong.
> > A single tfm is used as a user context to crypto, so to speak. But a user is not a thread.
> > Let us use ipsec as example.
> > For each security association (SA), it will take up a tfm.
> > Assume I have IP sec setup between my local host and remote host.  I might have two SA's, one for each direction.
> > Now, I might run ping. Simultaneously, I might run iperf. I might run a lot of different things  between these two ip hosts.
> > But only two tfm's are involved.
> > I have seen this happening   in our system with ipsec setup as described above.
> > While an  async request is outstanding in the driver,  another request is  issued to the same driver for the same tfm.
> 
> Yes you're absolutely right.
> 
> Unless I've misunderstood Marcelo's question is different from what 
> Garg was asking.
> 
> Marcelo: The tfm, be it blkcipher or ablkcipher can always be used in 
> parallel by the user on different CPUs.  For example, IPsec may 
> receive two packets on two CPUs through the same SA, in which case 
> decryption will be carried out in parallel.

So does that means that it's possible to keep data in the tfm's context that is the same for a single SA, such as the AES expanded key, but it's not possible to keep data that is specific for the current operation, such as an operation state that the driver might require?

Actually I think that probably I have misunderstood the blkcipher interface, so here it is another question: is each encrypt/decrypt call a complete operation? I mean, I'm considering that I could always chain a series of calls to encrypt data in separated chunks, in a similar way that is done for the hash interface and because that I'm assuming that I would have to keep state between those calls if the device requires that.

> 
> Garg: For any tfm, blkcipher or ablkcipher, they must return results 
> in the order they were given.  For a blkcipher which is synchronous, 
> this is always true by definition since we return only after the 
> result has been completed.  For an async ablkcipher, this means that 
> if you receive two requests on the same CPU, then the first request 
> must be served and completed before the second request's completion 
> can be initiated.
> 
> Sorry for any confusion this might have caused.
> 
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page: 
> http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-crypto" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-crypto" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
