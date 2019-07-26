Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A5ABC7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:02:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D4EF229F3
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:02:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbfGZMCK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 08:02:10 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:56329 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbfGZMCK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 08:02:10 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 2DC5DFF807;
        Fri, 26 Jul 2019 12:02:07 +0000 (UTC)
Date:   Fri, 26 Jul 2019 14:02:06 +0200
From:   "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCHv2 0/3] crypto: inside-secure - broaden driver scope
Message-ID: <20190726120206.GB3235@kwain>
References: <1561469816-7871-1-git-send-email-pleeuwen@localhost.localdomain>
 <MN2PR20MB2973DAAEF813270C88BB941CCAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MN2PR20MB2973DAAEF813270C88BB941CCAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

On Fri, Jul 26, 2019 at 11:33:07AM +0000, Pascal Van Leeuwen wrote:
> 
> Just a gentle ping to remind people that this patch set - which incorporates the feedback I 
> got on an earlier version thereof - has been pending for over a month now without 
> receiving any feedback on it whatsoever ...

I do not recall seeing this series and somehow I cannot find it in any
of my mailboxes or in patchwork. Would you care to send it again ?

I'm not sure if the issue with this series is on my side or if there was
an issue while sending it.

Thanks!
Antoine

> > From: Pascal van Leeuwen <pvanleeuwen@insidesecure.com>
> > 
> > This is a first baby step towards making the inside-secure crypto driver
> > more broadly useful. The current driver only works for Marvell Armada HW
> > and requires proprietary firmware, only available under NDA from Marvell,
> > to be installed. This patch set allows the driver to be used with other
> > hardware and removes the dependence on that proprietary firmware.
> > 
> > changes since v1:
> > - changed dev_info's into dev_dbg to reduce normal verbosity
> > - terminate all message strings with \n
> > - use priv->version field strictly to enumerate device context
> > - fixed some code & comment style issues
> > - removed EIP97/197 references from messages
> > - use #if(IS_ENABLED(CONFIG_PCI)) to remove all PCI related code
> > - use #if(IS_ENABLED(CONFIG_OF)) to remove all device tree related code
> > - do not inline the minifw but read it from /lib/firmware instead
> > 
> > Pascal van Leeuwen (3):
> >   crypto: inside-secure - make driver selectable for non-Marvell
> >     hardware
> >   crypto: inside-secure - add support for PCI based FPGA development
> >     board
> >   crypto: inside-secure - add support for using the EIP197 without
> >     vendor firmware
> > 
> >  drivers/crypto/Kconfig                         |  12 +-
> >  drivers/crypto/inside-secure/safexcel.c        | 748 +++++++++++++++++--------
> >  drivers/crypto/inside-secure/safexcel.h        |  36 +-
> >  drivers/crypto/inside-secure/safexcel_cipher.c |  11 -
> >  drivers/crypto/inside-secure/safexcel_hash.c   |  12 -
> >  drivers/crypto/inside-secure/safexcel_ring.c   |   3 +-
> >  6 files changed, 569 insertions(+), 253 deletions(-)
> > 
> > --
> > 1.8.3.1

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
