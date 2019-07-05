Return-Path: <SRS0=kkEj=VC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDE97C46499
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 15:57:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACBE7216E3
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 15:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfGEP5U (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jul 2019 11:57:20 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:40517 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbfGEP5U (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jul 2019 11:57:20 -0400
Received: from localhost (lfbn-1-2078-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 655C124000F;
        Fri,  5 Jul 2019 15:57:07 +0000 (UTC)
Date:   Fri, 5 Jul 2019 17:57:06 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: inside-secure - remove unused struct entry
Message-ID: <20190705155706.GJ3926@kwain>
References: <1562314645-22949-1-git-send-email-pvanleeuwen@verimatrix.com>
 <20190705141800.GE3926@kwain>
 <MN2PR20MB297394029C591248FA258760CAF50@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190705143940.GG3926@kwain>
 <MN2PR20MB2973273C7446FC1CF6CA9903CAF50@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MN2PR20MB2973273C7446FC1CF6CA9903CAF50@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

On Fri, Jul 05, 2019 at 02:54:25PM +0000, Pascal Van Leeuwen wrote:
> > From: Antoine Tenart <antoine.tenart@bootlin.com>
> > On Fri, Jul 05, 2019 at 02:32:46PM +0000, Pascal Van Leeuwen wrote:
> > > > From: Antoine Tenart <antoine.tenart@bootlin.com>
> > > >
> > > > You should wait for either those patches to be merged (or directly
> > > > integrate this change in a newer version of those patches), or send this
> > > > patch in the same series. Otherwise it's problematic as you do not know
> > > > which patches will be applied first.
> > >
> > > This patch indeed depends on earlier patches. I was just assuming
> > > people to be smart enough to apply the patches in the correct order :-)
> > 
> > It's actually very difficult for a maintainer to remember this,
> > especially when he has to deal with plenty of patches from many
> > contributors. And some series can take time to be merged while others
> > can be accepted easily, so it's hard to keep track of dependencies :)
> > 
> That's an interesting point though, as dependencies between more 
> complex/larger patches are rather unavoidable ...
> 
> So how should you handle that? Do you need to wait for the previous
> patches to be accepted before submitting the next ones? Thats seems
> rather inefficient as I could already be getting some (low-hanging fruit)
> feedback on the next patchset that I can already work on while waiting 
> for the previous patchset(s) to go through the process.
> 
> I'm a hardware guy. We pipeline stuff by default :-)

Hehe :)

I'd say you usually try not to send too many patches / series in
parallel. If that is not possible, or if you have series with
dependencies you can explain the dependency in the cover letter (just
try not to have 10's of series with dependencies in parallel).

Also if you have series not aimed to be merged right now but you want
comments, you can use [RFC] instead of [PATCH] in the object of the
mail.

This is usually working quite OK :)

Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
