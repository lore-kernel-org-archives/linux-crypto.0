From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Questions about the Crypto API
Date: Fri, 16 Aug 2013 16:30:43 +1000
Message-ID: <20130816063043.GA6859@gondor.apana.org.au>
References: <20130805202557.GE5752@oc8526070481.ibm.com>
 <20130806070010.GB19754@gondor.apana.org.au>
 <065BBB7616BCE543832A2EF096986B940A05ADCD@039-SN2MPN1-011.039d.mgd.msft.net>
 <20130809125513.GA7674@oc8526070481.ibm.com>
 <A83C99F8370D4D42BEB2D2B3153A6BBC23D55A6E@NASANEXD02C.na.qualcomm.com>
 <20130810011541.GA6549@gondor.apana.org.au>
 <20130812134913.GA5173@oc8526070481.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Hsieh, Che-Min" <cheminh@qti.qualcomm.com>,
	Garg Vakul-B16394 <B16394@freescale.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:48917 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752504Ab3HPGbD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 Aug 2013 02:31:03 -0400
Content-Disposition: inline
In-Reply-To: <20130812134913.GA5173@oc8526070481.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 12, 2013 at 10:49:13AM -0300, Marcelo Cerri wrote:
> 
> So does that means that it's possible to keep data in the tfm's context
> that is the same for a single SA, such as the AES expanded key, but it's
> not possible to keep data that is specific for the current operation,
> such as an operation state that the driver might require?

Correct.

> Actually I think that probably I have misunderstood the blkcipher
> interface, so here it is another question: is each encrypt/decrypt call
> a complete operation? I mean, I'm considering that I could always chain
> a series of calls to encrypt data in separated chunks, in a similar way
> that is done for the hash interface and because that I'm assuming that I
> would have to keep state between those calls if the device requires
> that.

You could always chain blkcipher operations together, however, the
only state that can be stored is the IV.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
