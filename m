Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFA1BC7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 13:46:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C01F522CE8
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 13:46:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388333AbfGZNqp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 09:46:45 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:43335 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387830AbfGZNqo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 09:46:44 -0400
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 19CA9200004;
        Fri, 26 Jul 2019 13:46:41 +0000 (UTC)
Date:   Fri, 26 Jul 2019 15:46:40 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 2/3] crypto: inside-secure - added support for
 rfc3686(ctr(aes))
Message-ID: <20190726134640.GD5031@kwain>
References: <1562309364-942-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1562309364-942-3-git-send-email-pvanleeuwen@verimatrix.com>
 <20190726123305.GD3235@kwain>
 <MN2PR20MB2973C6D05EED9B878D2EC4B9CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MN2PR20MB2973C6D05EED9B878D2EC4B9CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

On Fri, Jul 26, 2019 at 01:28:13PM +0000, Pascal Van Leeuwen wrote:
> > On Fri, Jul 05, 2019 at 08:49:23AM +0200, Pascal van Leeuwen wrote:
> 
> > > -		/* H/W capabilities selection */
> > > -		val = EIP197_FUNCTION_RSVD;
> > > -		val |= EIP197_PROTOCOL_ENCRYPT_ONLY | EIP197_PROTOCOL_HASH_ONLY;
> > > -		val |= EIP197_PROTOCOL_ENCRYPT_HASH | EIP197_PROTOCOL_HASH_DECRYPT;
> > > -		val |= EIP197_ALG_DES_ECB | EIP197_ALG_DES_CBC;
> > > -		val |= EIP197_ALG_3DES_ECB | EIP197_ALG_3DES_CBC;
> > > -		val |= EIP197_ALG_AES_ECB | EIP197_ALG_AES_CBC;
> > > -		val |= EIP197_ALG_MD5 | EIP197_ALG_HMAC_MD5;
> > > -		val |= EIP197_ALG_SHA1 | EIP197_ALG_HMAC_SHA1;
> > > -		val |= EIP197_ALG_SHA2 | EIP197_ALG_HMAC_SHA2;
> > > -		writel(val, EIP197_PE(priv) + EIP197_PE_EIP96_FUNCTION_EN(pe));
> > > +		/* H/W capabilities selection: just enable everything */
> > > +		writel(EIP197_FUNCTION_ALL,
> > > +		       EIP197_PE(priv) + EIP197_PE_EIP96_FUNCTION_EN(pe));
> > 
> > This should be in a separate patch.
> >
> It was added specifically to  get this functionality working as CTR mode was not
> enabled.  So I don't see why it should be a seperate patch, really?
> Instead of adding CTR mode to the list (which would have been perfectly valid
> in this context anyway), I just chose to enable everything instead.

Because it's not the same thing to enable everything and to add one extra
alg. This makes bissecting the driver harder because one would not except
this change in this kind of patch.

> > I'm also not sure about it, as
> > controlling exactly what algs are enabled in the h/w could prevent
> > misconfiguration issues in the control descriptors.
> > 
> That's not really what it's supposed to be used for. It's supposed to be used for
> disabling algorithms the application is not ALLOWED to use e.g. because they are
> not deemed secure enough (in case you have to comply, with,  say, FIPS or so).

OK, that answer my question and this makes sense.

> > > @@ -62,9 +63,9 @@ static void safexcel_skcipher_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
> > >  				    u32 length)
> > > -	if (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CBC) {
> > > +	if (ctx->mode != CONTEXT_CONTROL_CRYPTO_MODE_ECB) {
> > 
> > I think it's better for maintenance and readability to have something
> > like:
> > 
> >   if (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CBC ||
> >       ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD)
> > 
> Not really. I *really* want to execute that for any mode other than ECB,
> ECB being the *only* mode that does not require an IV (which I know
> for a fact, being the architect and all :-).
> And I don't believe a long list of modes that *do* require an IV would 
> be  more readable or easy to maintain than this single compare ...

That's where I disagree as you need extra knowledge to be aware of this.
Being explicit removes any possible question one may ask. But that's a
small point really :)

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
