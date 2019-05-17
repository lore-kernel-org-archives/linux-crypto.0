Return-Path: <SRS0=1tzS=TR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59B4BC04AB4
	for <linux-crypto@archiver.kernel.org>; Fri, 17 May 2019 07:33:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3502A206A3
	for <linux-crypto@archiver.kernel.org>; Fri, 17 May 2019 07:33:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfEQHdt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 May 2019 03:33:49 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:46881 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727528AbfEQHdt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 May 2019 03:33:49 -0400
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <sha@pengutronix.de>)
        id 1hRXNC-00016p-Oo; Fri, 17 May 2019 09:33:46 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <sha@pengutronix.de>)
        id 1hRXNC-0001as-98; Fri, 17 May 2019 09:33:46 +0200
Date:   Fri, 17 May 2019 09:33:46 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     Fabio Estevam <festevam@gmail.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: Re: ctr(aes) broken in CAAM driver
Message-ID: <20190517073346.2rdy5pz73hwonw5b@pengutronix.de>
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
X-Uptime: 09:32:51 up 59 days, 18:43, 86 users,  load average: 1.09, 1.12,
 1.12
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 15, 2019 at 01:35:16PM +0000, Horia Geanta wrote:
> On 5/15/2019 4:22 PM, Sascha Hauer wrote:
> > Hi Fabio,
> > 
> > On Wed, May 15, 2019 at 10:17:19AM -0300, Fabio Estevam wrote:
> >> Hi Sascha,
> >>
> >> On Wed, May 15, 2019 at 10:09 AM Sascha Hauer <s.hauer@pengutronix.de> wrote:
> >>>
> >>> Hi,
> >>>
> >>> ctr(aes) is broken in current kernel (v5.1+). It may have been broken
> >>> for longer, but the crypto tests now check for a correct output IV. The
> >>> testmgr answers with:
> >>>
> >>> alg: skcipher: ctr-aes-caam encryption test failed (wrong output IV) on test vector 0, cfg="in-place"
> >>>
> >>> output IV is this, which is the last 16 bytes of the encrypted message:
> >>> 00000000: 1e 03 1d da 2f be 03 d1 79 21 70 a0 f3 00 9c ee
> >>>
> >>> It should look like this instead, which is input IV + 4:
> >>> 00000000: f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 fa fb fc fd ff 03
> >>>
> >>> I have no idea how to fix this as I don't know how to get the output IV
> >>> back from the CAAM. Any ideas?
> >>
> >> Is this problem similar to this one?
> >> https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg37512.html
> > 
> > Different algo, different hardware, but yes, it seems to be the same
> > type of failure.
> > 
> For talitos, the problem is the lack of IV update.
> 
> For caam, the problem is incorrect IV update (output IV is equal to last
> ciphertext block, which is correect for cbc, but not for ctr mode).
> 
> I am working at a fix, but it takes longer since I would like to program the
> accelerator to the save the IV (and not do counter increment in SW, which
> created problems for many other implementations).

Thanks for working on it. I'd be glad to test it once you have
something.

Thanks
 Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
