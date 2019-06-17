Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49681C31E57
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 10:08:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 259052084D
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 10:08:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbfFQKIp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 06:08:45 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:32813 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfFQKIp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 06:08:45 -0400
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1hcoZ9-0005Kn-HA; Mon, 17 Jun 2019 12:08:43 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <sha@pengutronix.de>)
        id 1hcoZ8-0005Qj-Gh; Mon, 17 Jun 2019 12:08:42 +0200
Date:   Mon, 17 Jun 2019 12:08:42 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     Fabio Estevam <festevam@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: ctr(aes) broken in CAAM driver
Message-ID: <20190617100842.wqoqan5o7hxpmgdq@pengutronix.de>
References: <20190515130746.cvhkxxffrmmynfq3@pengutronix.de>
 <CAOMZO5CJvcipPNY6TXnwwET2fc=zaP3Dj3HPT-zfZpzfqHkeHQ@mail.gmail.com>
 <20190515132225.oczgouglycuhqo4l@pengutronix.de>
 <VI1PR0402MB3485ED478A2A3E0087E81F7C98090@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190612094050.6esonhumzv2ywhdh@pengutronix.de>
 <VI1PR0402MB3485F22CE6052F7CC24AAC3E98EC0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190612113536.eixnu5sqphynyjfr@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612113536.eixnu5sqphynyjfr@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:07:27 up 30 days, 16:25, 85 users,  load average: 0.29, 0.27,
 0.25
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jun 12, 2019 at 01:35:36PM +0200, Sascha Hauer wrote:
> On Wed, Jun 12, 2019 at 10:33:56AM +0000, Horia Geanta wrote:
> > On 6/12/2019 12:40 PM, Sascha Hauer wrote:
> > > Hi Horia,
> > > 
> > > On Wed, May 15, 2019 at 01:35:16PM +0000, Horia Geanta wrote:
> > >> For talitos, the problem is the lack of IV update.
> > >>
> > >> For caam, the problem is incorrect IV update (output IV is equal to last
> > >> ciphertext block, which is correect for cbc, but not for ctr mode).
> > >>
> > >> I am working at a fix, but it takes longer since I would like to program the
> > >> accelerator to the save the IV (and not do counter increment in SW, which
> > >> created problems for many other implementations).
> > > 
> > > Any news here? With the fix Ard provided gcm(aes) now works again, but
> > > only as long as the crypto self tests are disabled.
> > > 
> > I've recently submitted support for IV update done in HW (caam engine),
> > which fixes this issue:
> > https://patchwork.kernel.org/cover/10984927/
> 
> Thanks, I haven't seen this. I'll give it a try.

This works here, thanks

I don't have the original patch mails, so I'm adding it here:

Tested-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
