Return-Path: <SRS0=HT46=UT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE43BC43613
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 15:43:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DC3F2083B
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 15:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbfFTPnH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Jun 2019 11:43:07 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:32943 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfFTPnH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Jun 2019 11:43:07 -0400
X-Originating-IP: 90.88.23.150
Received: from localhost (aaubervilliers-681-1-81-150.w90-88.abo.wanadoo.fr [90.88.23.150])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id DBFBEE0004;
        Thu, 20 Jun 2019 15:42:59 +0000 (UTC)
Date:   Thu, 20 Jun 2019 17:42:59 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 3/3] crypto: inside-secure - add support for using the
 EIP197 without firmware images
Message-ID: <20190620154259.GE4642@kwain>
References: <1560837384-29814-1-git-send-email-pvanleeuwen@insidesecure.com>
 <1560837384-29814-4-git-send-email-pvanleeuwen@insidesecure.com>
 <20190619122737.GB3254@kwain>
 <AM6PR09MB3523D2FEC3A543FF037812DCD2E50@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190620131512.GB4642@kwain>
 <AM6PR09MB35236CA6971A1B6D03AB9BD4D2E40@AM6PR09MB3523.eurprd09.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AM6PR09MB35236CA6971A1B6D03AB9BD4D2E40@AM6PR09MB3523.eurprd09.prod.outlook.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

On Thu, Jun 20, 2019 at 02:59:20PM +0000, Pascal Van Leeuwen wrote:
> > From: Antoine Tenart <antoine.tenart@bootlin.com>
> > On Wed, Jun 19, 2019 at 02:37:44PM +0000, Pascal Van Leeuwen wrote:
> > > > From: Antoine Tenart <antoine.tenart@bootlin.com>
> > > > On Tue, Jun 18, 2019 at 07:56:24AM +0200, Pascal van Leeuwen wrote:
> > >
> > > > In addition to this, the direction the kernel has taken was to *remove*
> > > > binary firmwares from its source code. I'm afraid adding this is a
> > > > no-go.
> > >
> > > For a HW engineer, there really is no fundamental difference between
> > > control register contents or an instruction word. They can both have
> > > the exact same effects internal to the HW.
> > > If I had disguised this as a handful of config reg writes writing
> > > some #define'd magic values, probably no one would have even noticed.
> > 
> > I do not fully agree. If this is comparable to configuring h/w
> > registers, then you could probably have defines explaining why each bit
> > is set and what it's doing. Which would be fine.
> > 
> Strictly speaking, we (and probably most other HW vendors as well) don't do 
> that for every register bit either, not even in the official Programmer Manual. 
> Some bits are just "you don't need to know, just write this" :-)

That's right... :-(

> > > By that same definition, the tokens the driver generates for
> > > processing could be considered "firmware" as well (as they are used by
> > > the hardware in a very similar way) ...
> > 
> > Right. The main difference here is we do have a clear definition of what
> > the tokens are doing. Thanks to your explanation, if this firmware is
> > really looking like the token we're using, the words have a defined
> > structure and the magic values could be generated with proper defines
> > and macros. And I think it's the main issue here: it's not acceptable to
> > have an array of magic values. If you can give a meaning to those bits,
> > I see no reason why it couldn't be added to the driver.
> > 
> > (And I'm all for what you're trying to achieve here :)).
> > 
> Now we're reaching a tricky subject. Because I think if some people here
> find out those token bits are explicitly documented in the driver, they
> will not be so happy ... (don't worry, I won't wake any sleeping dogs :-)
> We provide this information to our customers under NDA, but it's 
> obviously quite sensitive information as it reveals a lot about the
> inner workings of our HW design.
> 
> The encoding of the microengine control words is considered even
> more sensitive, so we don't even provide that under NDA.
> Adding that to the driver will probably get me in trouble.

I fully understand this. This is not perfect, but at least it's the way
it is right now.

> So maybe putting these images in /lib/firmware is unavoidable, but
> I'd really like to hear some more opinions on that subject.

Yes, you either have to choice to put it in /lib/firmware (and in the
linux-firmwares project!) or to convince people to allow releasing this.

We can wait for others to hop in on the discussion, of course.

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
