Return-Path: <SRS0=mqYf=V4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1882C433FF
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 12:13:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B569520659
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 12:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbfGaMND (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Jul 2019 08:13:03 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:41639 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbfGaMND (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jul 2019 08:13:03 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 1D4F6C0003;
        Wed, 31 Jul 2019 12:13:00 +0000 (UTC)
Date:   Wed, 31 Jul 2019 14:12:59 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCHv2 2/3] crypto: inside-secure - add support for PCI based
 FPGA development board
Message-ID: <20190731121259.GB3579@kwain>
References: <1564145005-26731-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1564145005-26731-3-git-send-email-pvanleeuwen@verimatrix.com>
 <20190730090811.GF3108@kwain>
 <MN2PR20MB2973B37C90FBD6E6C97B8E09CADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190730134232.GG3108@kwain>
 <MN2PR20MB2973FA07F5AB41D99A9FADD4CADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MN2PR20MB2973FA07F5AB41D99A9FADD4CADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

On Tue, Jul 30, 2019 at 04:17:54PM +0000, Pascal Van Leeuwen wrote:
> > From: Antoine Tenart <antoine.tenart@bootlin.com>
> > On Tue, Jul 30, 2019 at 10:20:43AM +0000, Pascal Van Leeuwen wrote:
> > > > On Fri, Jul 26, 2019 at 02:43:24PM +0200, Pascal van Leeuwen wrote:
> > > > > -	switch (priv->version) {
> > > > > -	case EIP197B:
> > > > > -		dir = "eip197b";
> > > > > -		break;
> > > > > -	case EIP197D:
> > > > > -		dir = "eip197d";
> > > > > -		break;
> > > > > -	default:
> > > > > +	if (priv->version == EIP97IES_MRVL)
> > > > >  		/* No firmware is required */
> > > > >  		return 0;
> > > > > -	}
> > > > > +	else if (priv->version == EIP197D_MRVL)
> > > > > +		dir = "eip197d";
> > > > > +	else
> > > > > +		/* Default to minimum EIP197 config */
> > > > > +		dir = "eip197b";
> > > >
> > > > You're moving the default choice from "no firmware" to being a specific
> > > > one.
> > > >
> > > The EIP97 being the exception as the only firmware-less engine.
> > > This makes EIP197_DEVBRD fall through to EIP197B firmware until
> > > my patches supporting other EIP197 configs eventually get merged,
> > > after which this part will change anyway.
> > 
> > We don't know when/in what shape those patches will be merged, so in
> > the meantime please make the "no firmware" the default choice.
> >
> "No firmware" is not possible with an EIP197. Trying to use it without
> loading firmware will cause it to hang, which I don't believe is what
> you would want. So the alternative would be to return an error, which
> is fine by me, so then I'll change it into that as default.

Sure. When you look at this it's just weird to have a specific firmware
tied to an 'else' without having a check for a given version. Having the
"no firmware" option as the default option or not does not change
anything at runtime in practice here. If you prefer throwing an error if
the version isn't supported, I'm OK with it as well.

> > > > > @@ -869,9 +898,6 @@ static int safexcel_register_algorithms(struct
> > safexcel_crypto_priv
> > > > *priv)
> > > > >  	for (i = 0; i < ARRAY_SIZE(safexcel_algs); i++) {
> > > > >  		safexcel_algs[i]->priv = priv;
> > > > >
> > > > > -		if (!(safexcel_algs[i]->engines & priv->version))
> > > > > -			continue;
> > > >
> > > > You should remove the 'engines' flag in a separate patch. I'm really not
> > > > sure about this. I don't think all the IS EIP engines support the same
> > > > sets of algorithms?
> > > >
> > > All algorithms provided at this moment are available from all engines
> > > currently supported. So the whole mechanism, so far, is redundant.
> > >
> > > This will change as I add support for generic (non-Marvell) engines,
> > > but the approach taken here is not scalable or maintainable. So I will
> > > end up doing it differently, eventually. I don't see the point in
> > > maintaining dead/unused/redundant code I'm about to replace anyway.
> > 
> > But it's not done yet and we might discuss how you'll handle this. You
> > can't know for sure you'll end up with a different approach.
> > 
> We can discuss all we want, but the old approach for sure won't work
> so there's no point in keeping those (effectively redundant up until
> now, so why did they even exist?) 'engines' flags. 

Yes, I mean my point is that you can't know the future for sure, but I
agree you'll surely end up with a better solution :)

> > > > > +	if (IS_ENABLED(CONFIG_PCI) && (priv->version == EIP197_DEVBRD)) {
> > > >
> > > > You have extra parenthesis here.
> > > >
> > > Our internal coding style (as well as my personal preference)
> > > actually mandates to put parenthesis around everything so expect
> > > that to happen a lot going forward as I've been doing it like that
> > > for nearly 30 years now.
> > >
> > > Does the Linux coding style actually *prohibit* the use of these
> > > "extra" parenthesis? I don't recall reading that anywhere ...
> > 
> > I don't know if this is a written rule (as many others), but you'll find
> > plenty of examples of reviews asking not to have extra parenthesis.
> >
> I can remove them, I was just wondering if there was actually any 
> rationale for not wanting to have them (considering that that at least
> seems far more error prone). I have this strange desire to want to 
> know WHY I have to do something before I do it.
> 
> Is it just to show off your intimate knowledge of C operator precedence
> and associativity  ;-) (which, incidentally, I'm not too familiar with)

Hehe :) I think this is more a coding style non-written requirement than
something backed up with a technical reason, or it's possible I'm not
aware of the reason. Anyway, this is often asked in reviews, and you
won't find many examples of this in existing code.

> > > > We had this discussion on the v1. Your point was that you wanted this
> > > > information to be in .data. One solution I proposed then was to use a
> > > > struct (with both a 'version' and a 'flag' variable inside) instead of
> > > > a single 'version' variable, so that we still can make checks on the
> > > > version itself and not on something too specific.
> > > >
> > > As a result of that discussion, I kept your original version field
> > > as intact as I could, knowing what I know and where I want to go.
> > >
> > > But to truly support generic engines, we really need all the stuff
> > > that I added. Because it simply has that many parameters that are
> > > different for each individual instance. But at the same time these
> > > parameters can all be probed from the hardware directly, so
> > > maintaining huge if statements all over the place decoding some
> > > artificial version field is not the way to go (not maintainable).
> > > Just probe all the parameters from the hardware and use them
> > > directly where needed ... which my future patch set will do.
> > 
> > OK, I do think this would be a good solution :)
> > 
> I hope so ... as you're not exactly easy to convince and I can't
> afford to keep spending this much effort on this for much longer
> without getting in trouble with my dayjob.

I could say the same (I do think it's good that you want to know the
reason behind requirements and comments). I didn't comment specifically
on the lengthy explanations you gave, but it helped me to understand
your point, how the h/w engines we'll support are designed and
integrated and the reason behind lots of your choices. I know we spent
a lot of time discussing various points and I'm pretty sure this is
because we need to both ramp up (on the diversity of engines and on
the upstream process) but I'm sure this is only temporary.

One of the examples where those discussions will be useful is if/when
we'll have more of compatibles to support in the driver, as those cannot
be removed once merged.

I could continue arguing on the 'version', but let's say we're on the
same page for now and if ever I see a reason to factorize some code
regarding this we can always discuss it later, as this it's internal to
the driver.

Thanks for taking the time :)

Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
