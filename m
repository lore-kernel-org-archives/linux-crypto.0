Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B115DC0650F
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 13:42:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81B75206B8
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 13:42:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbfG3Nmg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 09:42:36 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:59741 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfG3Nmg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 09:42:36 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 674A9E000B;
        Tue, 30 Jul 2019 13:42:33 +0000 (UTC)
Date:   Tue, 30 Jul 2019 15:42:32 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCHv2 2/3] crypto: inside-secure - add support for PCI based
 FPGA development board
Message-ID: <20190730134232.GG3108@kwain>
References: <1564145005-26731-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1564145005-26731-3-git-send-email-pvanleeuwen@verimatrix.com>
 <20190730090811.GF3108@kwain>
 <MN2PR20MB2973B37C90FBD6E6C97B8E09CADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MN2PR20MB2973B37C90FBD6E6C97B8E09CADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

On Tue, Jul 30, 2019 at 10:20:43AM +0000, Pascal Van Leeuwen wrote:
> > On Fri, Jul 26, 2019 at 02:43:24PM +0200, Pascal van Leeuwen wrote:
> 
> > Is there a reason to have this one linked to Marvell? Aren't there other
> > EIP197 (or EIP97) engines not on Marvell SoCs? (I'm pretty sure I know
> > at least one).
> > 
> Yes, there is a very good reason. These flags control features that are
> very specific to those three Marvell socs and have nothing to do with 
> 'generic' EIP97IES's, EIP197B's or EIP197D's (these are just high-level
> marketing/sales denominators and do not cover all the intricate config
> details of the actual delivery that the driver needs to know about, so
> this naive approach would not be maintainable scaling to other devices) 
> Therefore, I wanted to make that abundantly clear, hence the prefix.
> (Renaming them to the specific Marvell SoC names was another option,
> if only I knew which engine ended up in which SoC ...)
> 
> While there are many SoC's out there with EIP97 and EIP197 engines,
> the driver in its current form will NOT work (properly) on them, for
> that there is still much work to be done beyond the patches I already
> submitted. I already have the implementation for that (you tested that
> already!), but chopping it into bits and submitting it all will take 
> a lot more time. But you have to understand that, without that, it's 
> totally useless to either me or Verimatrix.
> 
> TL;DR: These flags are really just for controlling anything specific
> to those particular Marvell instances and nothing else.

I had this driver running on another non-Marvell SoC with very minor
modifications, so there's then at least one hardware which is similar
enough. In this case I don't see why this should be named "Marvell".

What are the features specific to those Marvell SoC that won't be used
in other integrations? I'm pretty sure there are common features between
all those EIP97 engines on different SoCs.

> > > -	switch (priv->version) {
> > > -	case EIP197B:
> > > -		dir = "eip197b";
> > > -		break;
> > > -	case EIP197D:
> > > -		dir = "eip197d";
> > > -		break;
> > > -	default:
> > > +	if (priv->version == EIP97IES_MRVL)
> > >  		/* No firmware is required */
> > >  		return 0;
> > > -	}
> > > +	else if (priv->version == EIP197D_MRVL)
> > > +		dir = "eip197d";
> > > +	else
> > > +		/* Default to minimum EIP197 config */
> > > +		dir = "eip197b";
> > 
> > You're moving the default choice from "no firmware" to being a specific
> > one.
> > 
> The EIP97 being the exception as the only firmware-less engine.
> This makes EIP197_DEVBRD fall through to EIP197B firmware until
> my patches supporting other EIP197 configs eventually get merged,
> after which this part will change anyway.

We don't know when/in what shape those patches will be merged, so in
the meantime please make the "no firmware" the default choice.

> > > -			/* Fallback to the old firmware location for the
> > > +			/*
> > > +			 * Fallback to the old firmware location for the
> > 
> > This is actually the expected comment style in net/ and crypto/. (There
> > are other examples).
> > 
> Not according to the Linux coding style (which only makes an exception
> for /net) and not in most other crypto code I've seen. So maybe both
> styles are allowed(?) and they are certainly both used, but this style
> seems to be prevalent ...

I agree having non-written rules is not good (I don't make them), but
not everything is described in the documentation or in the coding style.
I don't really care about the comment style when adding new ones, but
those are valid (& recommended) in crypto/ and it just make the patch
bigger.

> > >  	/* For EIP197 set maximum number of TX commands to 2^5 = 32 */
> > > -	if (priv->version == EIP197B || priv->version == EIP197D)
> > > +	if (priv->version != EIP97IES_MRVL)
> > 
> > I would really prefer having explicit checks here. More engines will be
> > supported in the future and doing will help. (There are others).
> > 
> Same situation as with the crypto mode: I know for a fact the EIP97
> is the *only* configuration that *doesn't* need this code. So why
> would I have a long list of configurations there (that will keep
> growing indefinitely) that *do* need that code? That will for sure
> not improve maintainability ...

OK, I won't debate this for hours. At least add a comment, for when
*others* will add support for new hardware (because that really is the
point, *others* might update and modify the driver).

> > > @@ -869,9 +898,6 @@ static int safexcel_register_algorithms(struct safexcel_crypto_priv
> > *priv)
> > >  	for (i = 0; i < ARRAY_SIZE(safexcel_algs); i++) {
> > >  		safexcel_algs[i]->priv = priv;
> > >
> > > -		if (!(safexcel_algs[i]->engines & priv->version))
> > > -			continue;
> > 
> > You should remove the 'engines' flag in a separate patch. I'm really not
> > sure about this. I don't think all the IS EIP engines support the same
> > sets of algorithms?
> > 
> All algorithms provided at this moment are available from all engines
> currently supported. So the whole mechanism, so far, is redundant.
> 
> This will change as I add support for generic (non-Marvell) engines,
> but the approach taken here is not scalable or maintainable. So I will
> end up doing it differently, eventually. I don't see the point in
> maintaining dead/unused/redundant code I'm about to replace anyway.

But it's not done yet and we might discuss how you'll handle this. You
can't know for sure you'll end up with a different approach.

At least remove this in a separate patch.

> > > +	if (IS_ENABLED(CONFIG_PCI) && (priv->version == EIP197_DEVBRD)) {
> > 
> > You have extra parenthesis here.
> > 
> Our internal coding style (as well as my personal preference) 
> actually mandates to put parenthesis around everything so expect
> that to happen a lot going forward as I've been doing it like that
> for nearly 30 years now.
> 
> Does the Linux coding style actually *prohibit* the use of these
> "extra" parenthesis? I don't recall reading that anywhere ...

I don't know if this is a written rule (as many others), but you'll find
plenty of examples of reviews asking not to have extra parenthesis.

> > > +	if (priv->version == EIP197_DEVBRD) {
> > 
> > It seems to me this is mixing an engine version information and a board
> > were the engine is integrated. Are there differences in the engine
> > itself, or only in the way it's wired?
> > 
> Actually, no. The way I see it, priv->version does not convey any engine
> information, just integration context (i.e. a specific Marvell SoC or, in 
> this case, our FPGA dev board), see also my explanation at the beginning.

So that's really the point here :) This variable was introduced to
convey the engine information, not the way it is integrated. There are
EIP97 engines not on Marvell SoC which will just work out of the box (or
with let's say a one liner adding support for using a clock). And the
version could be in both cases something like 'EIP97'.

> Conveying engine information through a simple set of flags or some
> integer or whatever is just not going to fly. No two of our engines
> are ever the same, so that would quickly blow up in your face.

Well, you have more info about this than I do, I can only trust you on
this (it's just weird based on the experience I described just before,
it seems to me the differences are not that big, but again, you know the
h/w better).

I just don't want to end up with:

  if (version == EIP97_MRVL || version == EIP97_XXX || ...)

> > We had this discussion on the v1. Your point was that you wanted this
> > information to be in .data. One solution I proposed then was to use a
> > struct (with both a 'version' and a 'flag' variable inside) instead of
> > a single 'version' variable, so that we still can make checks on the
> > version itself and not on something too specific.
> > 
> As a result of that discussion, I kept your original version field
> as intact as I could, knowing what I know and where I want to go.
> 
> But to truly support generic engines, we really need all the stuff
> that I added. Because it simply has that many parameters that are
> different for each individual instance. But at the same time these
> parameters can all be probed from the hardware directly, so
> maintaining huge if statements all over the place decoding some 
> artificial version field is not the way to go (not maintainable).
> Just probe all the parameters from the hardware and use them 
> directly where needed ... which my future patch set will do.

OK, I do think this would be a good solution :)

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
