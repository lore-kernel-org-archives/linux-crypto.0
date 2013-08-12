From: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Subject: Re: Questions about the Crypto API
Date: Mon, 12 Aug 2013 10:49:13 -0300
Message-ID: <20130812134913.GA5173@oc8526070481.ibm.com>
References: <20130805202557.GE5752@oc8526070481.ibm.com>
 <20130806070010.GB19754@gondor.apana.org.au>
 <065BBB7616BCE543832A2EF096986B940A05ADCD@039-SN2MPN1-011.039d.mgd.msft.net>
 <20130809125513.GA7674@oc8526070481.ibm.com>
 <A83C99F8370D4D42BEB2D2B3153A6BBC23D55A6E@NASANEXD02C.na.qualcomm.com>
 <20130810011541.GA6549@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Hsieh, Che-Min" <cheminh@qti.qualcomm.com>,
	Garg Vakul-B16394 <B16394@freescale.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:39064 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab3HLNtW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Aug 2013 09:49:22 -0400
Received: from /spool/local
	by e24smtp03.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <mhcerri@linux.vnet.ibm.com>;
	Mon, 12 Aug 2013 10:49:20 -0300
Received: from d24relay01.br.ibm.com (d24relay01.br.ibm.com [9.8.31.16])
	by d24dlp02.br.ibm.com (Postfix) with ESMTP id 62FB61DC0066
	for <linux-crypto@vger.kernel.org>; Mon, 12 Aug 2013 09:49:17 -0400 (EDT)
Received: from d24av01.br.ibm.com (d24av01.br.ibm.com [9.8.31.91])
	by d24relay01.br.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r7CDipiH1310912
	for <linux-crypto@vger.kernel.org>; Mon, 12 Aug 2013 10:44:51 -0300
Received: from d24av01.br.ibm.com (localhost [127.0.0.1])
	by d24av01.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id r7CDnGT9019563
	for <linux-crypto@vger.kernel.org>; Mon, 12 Aug 2013 10:49:16 -0300
Content-Disposition: inline
In-Reply-To: <20130810011541.GA6549@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

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
> Unless I've misunderstood Marcelo's question is different from
> what Garg was asking.
> 
> Marcelo: The tfm, be it blkcipher or ablkcipher can always be used
> in parallel by the user on different CPUs.  For example, IPsec may
> receive two packets on two CPUs through the same SA, in which case
> decryption will be carried out in parallel.

So does that means that it's possible to keep data in the tfm's context
that is the same for a single SA, such as the AES expanded key, but it's
not possible to keep data that is specific for the current operation,
such as an operation state that the driver might require?

Actually I think that probably I have misunderstood the blkcipher
interface, so here it is another question: is each encrypt/decrypt call
a complete operation? I mean, I'm considering that I could always chain
a series of calls to encrypt data in separated chunks, in a similar way
that is done for the hash interface and because that I'm assuming that I
would have to keep state between those calls if the device requires
that.

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
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
