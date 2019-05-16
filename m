Return-Path: <SRS0=FyHQ=TQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71010C04AAF
	for <linux-crypto@archiver.kernel.org>; Thu, 16 May 2019 14:25:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42DB020833
	for <linux-crypto@archiver.kernel.org>; Thu, 16 May 2019 14:25:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfEPOZC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 May 2019 10:25:02 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:40529 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727121AbfEPOZC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 May 2019 10:25:02 -0400
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <sha@pengutronix.de>)
        id 1hRHJd-0003iC-BS; Thu, 16 May 2019 16:25:01 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <sha@pengutronix.de>)
        id 1hRHJd-00082y-2g; Thu, 16 May 2019 16:25:01 +0200
Date:   Thu, 16 May 2019 16:25:01 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH] crypto: caam: print debugging hex dumps after unmapping
Message-ID: <20190516142501.tysjwqmiznwfowet@pengutronix.de>
References: <20190515131324.22793-1-s.hauer@pengutronix.de>
 <VI1PR0402MB348501BDC254E48078D746AC98090@VI1PR0402MB3485.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB348501BDC254E48078D746AC98090@VI1PR0402MB3485.eurprd04.prod.outlook.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:24:46 up 59 days,  1:35, 89 users,  load average: 1.00, 1.05,
 1.08
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 15, 2019 at 04:27:51PM +0000, Horia Geanta wrote:
> On 5/15/2019 4:13 PM, Sascha Hauer wrote:
> > The debugging hex dumps in skcipher_encrypt_done() and
> > skcipher_decrypt_done() are printed while the request is still DMA
> > mapped. This results in bogus hex dumps with things like mixtures
> > between plain text and cipher text. Unmap first before printing.
> > 
> The description is not accurate.
> req->iv is no longer DMA mapped since commit 115957bb3e59 ("crypto: caam - fix
> IV DMA mapping and updating"), so this is not related to IV DMA unmapping vs.
> print order.
> 
> Currently:
> -for encryption, printed req->iv contains the input IV; copy of output IV into
> req->iv is done further below
> -for decryption, printed req->iv should be correct, since output IV is copied
> into req->iv in skcipher_decrypt(), before accelerator runs
> 
> Could you please resubmit with updated message?

Just did that.

Thanks
 Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
