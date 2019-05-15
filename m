Return-Path: <SRS0=YWhG=TP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5101BC04E53
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 13:22:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2067C20843
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 13:22:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfEONW2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 May 2019 09:22:28 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:38385 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726407AbfEONW2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 May 2019 09:22:28 -0400
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <sha@pengutronix.de>)
        id 1hQtrW-0004wH-9k; Wed, 15 May 2019 15:22:26 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <sha@pengutronix.de>)
        id 1hQtrV-0004h7-Ne; Wed, 15 May 2019 15:22:25 +0200
Date:   Wed, 15 May 2019 15:22:25 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: Re: ctr(aes) broken in CAAM driver
Message-ID: <20190515132225.oczgouglycuhqo4l@pengutronix.de>
References: <20190515130746.cvhkxxffrmmynfq3@pengutronix.de>
 <CAOMZO5CJvcipPNY6TXnwwET2fc=zaP3Dj3HPT-zfZpzfqHkeHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5CJvcipPNY6TXnwwET2fc=zaP3Dj3HPT-zfZpzfqHkeHQ@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:20:01 up 58 days, 30 min, 103 users,  load average: 1.08, 1.14,
 1.17
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Fabio,

On Wed, May 15, 2019 at 10:17:19AM -0300, Fabio Estevam wrote:
> Hi Sascha,
> 
> On Wed, May 15, 2019 at 10:09 AM Sascha Hauer <s.hauer@pengutronix.de> wrote:
> >
> > Hi,
> >
> > ctr(aes) is broken in current kernel (v5.1+). It may have been broken
> > for longer, but the crypto tests now check for a correct output IV. The
> > testmgr answers with:
> >
> > alg: skcipher: ctr-aes-caam encryption test failed (wrong output IV) on test vector 0, cfg="in-place"
> >
> > output IV is this, which is the last 16 bytes of the encrypted message:
> > 00000000: 1e 03 1d da 2f be 03 d1 79 21 70 a0 f3 00 9c ee
> >
> > It should look like this instead, which is input IV + 4:
> > 00000000: f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 fa fb fc fd ff 03
> >
> > I have no idea how to fix this as I don't know how to get the output IV
> > back from the CAAM. Any ideas?
> 
> Is this problem similar to this one?
> https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg37512.html

Different algo, different hardware, but yes, it seems to be the same
type of failure.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
