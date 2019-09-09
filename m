Return-Path: <SRS0=QtXc=XE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25E4BC4740C
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 13:59:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC69721924
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 13:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568037557;
	bh=1LOeIrNaojbFutO/35pibYdicy6zk1C9NEftmHLgaYE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=135MYOESdbwaTYGCYgXZcCHDzh6YrwyFmzzKejA5jUy26+Q1yKIM/tkLNgL2RFfCd
	 vm0guAXPqEr33n3Fs8VCkcyne0A7moeldigjmEZAWlHl8PiNcHK1Z65eJILUykejJ6
	 2NW/FVsFnalFPLRhWzBNwAKeTqgJQqXkeTOx6w/I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405101AbfIIN7Q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Sep 2019 09:59:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405085AbfIIN7Q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Sep 2019 09:59:16 -0400
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7759E2086D;
        Mon,  9 Sep 2019 13:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568037554;
        bh=1LOeIrNaojbFutO/35pibYdicy6zk1C9NEftmHLgaYE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UieH1zXYFmI9ZQoBmDFp/Caccsfb8zgAwWbjMjeDAAsY7nOdDGw25MsSl3XEWM/eK
         aCMGsGuAWbMv29jYF4cNJLtde8dflId6l4spy1NhpVNiZk1DIBghKpAI9y5BFNAJ5s
         Vr1SD9rR+VQpQwiMsnxecPLCM1nyBKQ6YwApwNbI=
Date:   Mon, 9 Sep 2019 15:59:10 +0200
From:   Maxime Ripard <mripard@kernel.org>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux@armlinux.org.uk, mark.rutland@arm.com, robh+dt@kernel.org,
        wens@csie.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 2/9] crypto: Add Allwinner sun8i-ce Crypto Engine
Message-ID: <20190909135908.vkvcuykrplhxxwtd@flea>
References: <20190906184551.17858-1-clabbe.montjoie@gmail.com>
 <20190906184551.17858-3-clabbe.montjoie@gmail.com>
 <20190907081951.v2huvhm44jfprfop@flea>
 <20190907190408.GE2628@Red>
 <20190909113837.vrnqdfgzhsiymfpm@flea>
 <20190909131906.GA12882@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190909131906.GA12882@Red>
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 09, 2019 at 03:19:06PM +0200, Corentin Labbe wrote:
> On Mon, Sep 09, 2019 at 01:38:37PM +0200, Maxime Ripard wrote:
> > On Sat, Sep 07, 2019 at 09:04:08PM +0200, Corentin Labbe wrote:
> > > > Also, I'm not sure what is the point of having the clocks names be
> > > > parameters there as well. It's constant across all the compatibles,
> > > > the only thing that isn't is the number of clocks and the module clock
> > > > rate. It's what you should have in there.
> > >
> > > Since the datasheet give some max frequency, I think I will add a
> > > max_freq and add a check to verify if the clock is in the right
> > > range
> >
> > It's a bit pointless. What are you going to do if it's not correct?
> > What are you trying to fix / report with this?
>
> I thinked to print a warning.  If someone want to play with
> overclocking for example, the driver should said that probably some
> result could be invalid.

If someone wants to play with overclocking, the crypto engine is going
to be the least of their concern.

> > > > > +int sun8i_ce_get_engine_number(struct sun8i_ce_dev *ce)
> > > > > +{
> > > > > +	return atomic_inc_return(&ce->flow) % ce->variant->maxflow;
> > > > > +}
> > > >
> > > > I'm not sure what this is supposed to be doing, but that mod there
> > > > seems pretty dangerous.
> > > >
> > > > ...
> > >
> > > This mod do a round robin on each channel.
> > > I dont see why it is dangerous.
> >
> > Well, you're using the atomic API here which is most commonly used for
> > refcounting, while you're using a mod.
> >
> > Plus, while the increment is atomic, the modulo isn't, so you can end
> > up in a case where you would be preempted between the
> > atomic_inc_return and the mod, which is dangerous.
> >
> > Again, I'm not sure what this function is doing (which is also a
> > problem in itself). I guess you should just make it clearer what it
> > does, and then we can discuss it properly.
>
> Each request need to be assigned to a channel.
> Each channel are identified by a number from 1 to 4.
>
> So this function return the channel to use, 1 then 2 then 3 then 4 then 1...
>
> Note that this is uncritical. If, due to anything, two request are
> assigned to the same channel, nothing will break.

I'm not sure why you're using the atomic API then?

Also, I guess a bitfield and find_first_bit (and a different function
name) would be more obvious to the reader.

Thanks!
Maxime
