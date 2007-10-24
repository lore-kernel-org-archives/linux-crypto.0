From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1]: Add countersize to CTR
Date: Wed, 24 Oct 2007 09:19:05 +0800
Message-ID: <20071024011905.GA4063@gondor.apana.org.au>
References: <200710232026.l9NKQTkC000737@faith.austin.ibm.com> <20071023204007.GT1635@halcrow.us> <20071024004230.GA3806@gondor.apana.org.au> <20071024005922.GU1635@halcrow.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Joy Latten <latten@austin.ibm.com>, linux-crypto@vger.kernel.org,
	mikko.herranen@cs.helsinki.fi
To: Michael Halcrow <mike@halcrow.us>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3748 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753334AbXJXBTK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Oct 2007 21:19:10 -0400
Content-Disposition: inline
In-Reply-To: <20071024005922.GU1635@halcrow.us>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Oct 23, 2007 at 07:59:22PM -0500, Michael Halcrow wrote:
>
> It is usually appropriate to print something to the system log when
> there is an error condition in the kernel code. That can help triage
> down the road when people have troubles.
> 
> The only reason I can think of as to why we would *not* want
> explanations in the syslog for failures is if frequent failures are
> expected in a significant fraction of deployments.

These paths can be triggered from user-space in future so printks
are not appropriate.

> > > > -		test_cipher("ctr(aes,4,8)", ENCRYPT, aes_ctr_enc_tv_template,
> > > > +		test_cipher("ctr(aes,4,8,4)", ENCRYPT, aes_ctr_enc_tv_template,
> > > >  			    AES_CTR_ENC_TEST_VECTORS);
> > > > -		test_cipher("ctr(aes,4,8)", DECRYPT, aes_ctr_dec_tv_template,
> > > > +		test_cipher("ctr(aes,4,8,4)", DECRYPT, aes_ctr_dec_tv_template,
> > > >  			    AES_CTR_DEC_TEST_VECTORS);
> > > 
> > > I have never been particularly thrilled about the the string-based
> > > method of parameterizing block ciphers for in-kernel API calls.
> > 
> > If you have a better suggestion I'd love to hear it!
> 
> Well, for calls made internally from kernel functions to kernel
> functions, pretty much anything other than writing sequences of
> comma-delimited parameters into to a character string.

Again these parameters ultimately come from user-space so this
doesn't sound very practical.

Even for the kernel users how would you type these parameters?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
