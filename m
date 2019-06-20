Return-Path: <SRS0=HT46=UT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89251C43613
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 13:15:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FF31206E0
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 13:15:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731779AbfFTNPT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Jun 2019 09:15:19 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:33829 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbfFTNPT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Jun 2019 09:15:19 -0400
Received: from localhost (aaubervilliers-681-1-81-150.w90-88.abo.wanadoo.fr [90.88.23.150])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id F20C120000A;
        Thu, 20 Jun 2019 13:15:12 +0000 (UTC)
Date:   Thu, 20 Jun 2019 15:15:12 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 3/3] crypto: inside-secure - add support for using the
 EIP197 without firmware images
Message-ID: <20190620131512.GB4642@kwain>
References: <1560837384-29814-1-git-send-email-pvanleeuwen@insidesecure.com>
 <1560837384-29814-4-git-send-email-pvanleeuwen@insidesecure.com>
 <20190619122737.GB3254@kwain>
 <AM6PR09MB3523D2FEC3A543FF037812DCD2E50@AM6PR09MB3523.eurprd09.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AM6PR09MB3523D2FEC3A543FF037812DCD2E50@AM6PR09MB3523.eurprd09.prod.outlook.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

On Wed, Jun 19, 2019 at 02:37:44PM +0000, Pascal Van Leeuwen wrote:
> > From: Antoine Tenart <antoine.tenart@bootlin.com>
> > On Tue, Jun 18, 2019 at 07:56:24AM +0200, Pascal van Leeuwen wrote:
> 
> > In addition to this, the direction the kernel has taken was to *remove*
> > binary firmwares from its source code. I'm afraid adding this is a
> > no-go.
> 
> For a HW engineer, there really is no fundamental difference between
> control register contents or an instruction word. They can both have
> the exact same effects internal to the HW.
> If I had disguised this as a handful of config reg writes writing 
> some #define'd magic values, probably no one would have even noticed.

I do not fully agree. If this is comparable to configuring h/w
registers, then you could probably have defines explaining why each bit
is set and what it's doing. Which would be fine.

> By that same definition, the tokens the driver generates for
> processing could be considered "firmware" as well (as they are used by
> the hardware in a very similar way) ...

Right. The main difference here is we do have a clear definition of what
the tokens are doing. Thanks to your explanation, if this firmware is
really looking like the token we're using, the words have a defined
structure and the magic values could be generated with proper defines
and macros. And I think it's the main issue here: it's not acceptable to
have an array of magic values. If you can give a meaning to those bits,
I see no reason why it couldn't be added to the driver.

(And I'm all for what you're trying to achieve here :)).

> > The proper solution I believe would be to support loading this "MiniFW",
> > which (depending on the license) could be either distributed in the
> > rootfs and loaded (like what's done currently), or through
> > CONFIG_EXTRA_FIRMWARE.
> > 
> That seems total overkill for just a handful of words though.

Given your explanation, I agree. (If those bits can have meaning).

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
