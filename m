Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA41C433FF
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 09:54:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B272217D9
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 09:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbfHEJy2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 05:54:28 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:40553 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727328AbfHEJy1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 05:54:27 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 26B0660015;
        Mon,  5 Aug 2019 09:54:25 +0000 (UTC)
Date:   Mon, 5 Aug 2019 11:54:24 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCHv3 4/4] crypto: inside-secure - add support for using the
 EIP197 without vendor firmware
Message-ID: <20190805095424.GJ14470@kwain>
References: <1564586959-9963-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1564586959-9963-5-git-send-email-pvanleeuwen@verimatrix.com>
 <20190805090725.GH14470@kwain>
 <MN2PR20MB29730648846013A67753624ECADA0@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MN2PR20MB29730648846013A67753624ECADA0@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 05, 2019 at 09:48:13AM +0000, Pascal Van Leeuwen wrote:
> > On Wed, Jul 31, 2019 at 05:29:19PM +0200, Pascal van Leeuwen wrote:
> > >
> > > -	/* Release engine from reset */
> > > -	val = readl(EIP197_PE(priv) + ctrl);
> > > -	val &= ~EIP197_PE_ICE_x_CTRL_SW_RESET;
> > > -	writel(val, EIP197_PE(priv) + ctrl);
> > > +	for (pe = 0; pe < priv->config.pes; pe++) {
> > > +		base = EIP197_PE_ICE_SCRATCH_RAM(pe);
> > > +		pollcnt = EIP197_FW_START_POLLCNT;
> > > +		while (pollcnt &&
> > > +		       (readl_relaxed(EIP197_PE(priv) + base +
> > > +			      pollofs) != 1)) {
> > > +			pollcnt--;
> > 
> > You might want to use readl_relaxed_poll_timeout() here, instead of a
> > busy polling.
> >
> Didn't know such a thing existed, but I also wonder how appropriate it
> is in this case, condering it measures in whole microseconds, while the 
> response time I'm expecting here is in the order of a few dozen nano-
> seconds internally ... i.e. 1 microsecond is already a *huge* overkill.
> 
> The current implementation runs that loop for only 16 iterations which
> should be both more than sufficient (it probably could be reduced 
> further, I picked 16 rather arbitrarily) and at the same time take so
> few cycles on the CPU that I doubt it is worthwhile to reschedule/
> preempt/whatever?

Your choice, I was just making a suggestion :)

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
