Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B9B8C31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 09:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61CC2207E0
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 09:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbfFLJkx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 05:40:53 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51759 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfFLJkx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 05:40:53 -0400
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1hazkQ-0005lO-Uu; Wed, 12 Jun 2019 11:40:50 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <sha@pengutronix.de>)
        id 1hazkQ-0007HA-55; Wed, 12 Jun 2019 11:40:50 +0200
Date:   Wed, 12 Jun 2019 11:40:50 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     Fabio Estevam <festevam@gmail.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: Re: ctr(aes) broken in CAAM driver
Message-ID: <20190612094050.6esonhumzv2ywhdh@pengutronix.de>
References: <20190515130746.cvhkxxffrmmynfq3@pengutronix.de>
 <CAOMZO5CJvcipPNY6TXnwwET2fc=zaP3Dj3HPT-zfZpzfqHkeHQ@mail.gmail.com>
 <20190515132225.oczgouglycuhqo4l@pengutronix.de>
 <VI1PR0402MB3485ED478A2A3E0087E81F7C98090@VI1PR0402MB3485.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB3485ED478A2A3E0087E81F7C98090@VI1PR0402MB3485.eurprd04.prod.outlook.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:38:15 up 25 days, 15:56, 85 users,  load average: 0.02, 0.08,
 0.08
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Horia,

On Wed, May 15, 2019 at 01:35:16PM +0000, Horia Geanta wrote:
> For talitos, the problem is the lack of IV update.
> 
> For caam, the problem is incorrect IV update (output IV is equal to last
> ciphertext block, which is correect for cbc, but not for ctr mode).
> 
> I am working at a fix, but it takes longer since I would like to program the
> accelerator to the save the IV (and not do counter increment in SW, which
> created problems for many other implementations).

Any news here? With the fix Ard provided gcm(aes) now works again, but
only as long as the crypto self tests are disabled.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
