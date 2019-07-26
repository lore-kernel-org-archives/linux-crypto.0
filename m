Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98D5DC7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 13:07:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 775CE218D4
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 13:07:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbfGZNHX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 09:07:23 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:55991 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfGZNHX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 09:07:23 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id ACC922001B;
        Fri, 26 Jul 2019 13:07:20 +0000 (UTC)
Date:   Fri, 26 Jul 2019 15:07:20 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 1/3] crypto: inside-secure - add support for
 authenc(hmac(sha1),cbc(des3_ede))
Message-ID: <20190726130720.GC5031@kwain>
References: <1562309364-942-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1562309364-942-2-git-send-email-pvanleeuwen@verimatrix.com>
 <20190726121938.GC3235@kwain>
 <MN2PR20MB2973B64FD27EA16A6FADBAFBCAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MN2PR20MB2973B64FD27EA16A6FADBAFBCAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

On Fri, Jul 26, 2019 at 12:57:21PM +0000, Pascal Van Leeuwen wrote:
> > On Fri, Jul 05, 2019 at 08:49:22AM +0200, Pascal van Leeuwen wrote:
> > > Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
> > 
> > Could you provide a commit message, explaining briefly what the patch is
> > doing?
> > 
> I initially figured that to be redundant if the subject already covered it completely.
> But now that I think of it, it's possible the subject does not end up in the commit
> at all ... if that is the case, would it work if I just copy-paste the relevant part of the
> subject message? Or do I need to be more verbose?

The subject will be the commit title. I know sometimes the commit
message is trivial or redundant, but it's still a good practice to
always have one (and many maintainers will ask for one). Even if it's
only two lines :)

> > > @@ -199,6 +201,15 @@ static int safexcel_aead_aes_setkey(struct crypto_aead *ctfm, const u8 *key,
> > >  		goto badkey;
> > >
> > >  	/* Encryption key */
> > > +	if (ctx->alg == SAFEXCEL_3DES) {
> > > +		flags = crypto_aead_get_flags(ctfm);
> > > +		err = __des3_verify_key(&flags, keys.enckey);
> > > +		crypto_aead_set_flags(ctfm, flags);
> > 
> > You could use directly des3_verify_key() which does exactly this.
> > 
> Actually, I couldn't due to des3_verify_key expecting a struct crypto_skcipher as input,
> and not a struct crypto_aead, that's why I had to do it this way ...

I see. Maybe a good way would be to provide a function taking
'struct crypto_aead' as an argument so that not every single driver
reimplement the same logic. But this can come later if needed.

> > > +struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des3_ede = {
> > > +	.type = SAFEXCEL_ALG_TYPE_AEAD,
> > 
> > You either missed to fill .engines member of this struct, or this series
> > is based on another one not merged yet.
> > 
> Yes, that happened in the patchset of which v2 did not make it to the mailing list ...

:)

So in general if there's a dependency you should say so in the cover
letter.

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
