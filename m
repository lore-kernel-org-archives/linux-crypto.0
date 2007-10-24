From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1]: Add countersize to CTR
Date: Wed, 24 Oct 2007 08:42:30 +0800
Message-ID: <20071024004230.GA3806@gondor.apana.org.au>
References: <200710232026.l9NKQTkC000737@faith.austin.ibm.com> <20071023204007.GT1635@halcrow.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Joy Latten <latten@austin.ibm.com>, linux-crypto@vger.kernel.org,
	mikko.herranen@cs.helsinki.fi
To: Michael Halcrow <mike@halcrow.us>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3505 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753488AbXJXAmm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Oct 2007 20:42:42 -0400
Content-Disposition: inline
In-Reply-To: <20071023204007.GT1635@halcrow.us>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Oct 23, 2007 at 03:40:08PM -0500, Michael Halcrow wrote:
> On Tue, Oct 23, 2007 at 03:26:29PM -0500, Joy Latten wrote:
> > +	unsigned int countersize;
> 
> It's somewhat nicer to just use size_t in the kernel for these sorts
> of data types. If you care about the exact number of bytes used by the
> variable, types like u32 make the code more parsable.

I don't see how this makes a difference here at all.

> > +	err = crypto_attr_u32(tb[4], &countersize);
> > +	if (err)
> > +		goto out_put_alg;
> 
> It's also nice to have printk's along error paths. Syslogs down the
> road tend to be less cryptic.

Please don't.  That's what error return values are for.  Adding
printk's means that we'd have to think about limiting them later
when this is opened up for user-space access.

> > -		test_cipher("ctr(aes,4,8)", ENCRYPT, aes_ctr_enc_tv_template,
> > +		test_cipher("ctr(aes,4,8,4)", ENCRYPT, aes_ctr_enc_tv_template,
> >  			    AES_CTR_ENC_TEST_VECTORS);
> > -		test_cipher("ctr(aes,4,8)", DECRYPT, aes_ctr_dec_tv_template,
> > +		test_cipher("ctr(aes,4,8,4)", DECRYPT, aes_ctr_dec_tv_template,
> >  			    AES_CTR_DEC_TEST_VECTORS);
> 
> I have never been particularly thrilled about the the string-based
> method of parameterizing block ciphers for in-kernel API calls.

If you have a better suggestion I'd love to hear it!

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
