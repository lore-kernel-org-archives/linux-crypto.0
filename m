Return-Path: <SRS0=YET+=TA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17B1AC43219
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Apr 2019 13:55:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D974820675
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Apr 2019 13:55:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfD3Nzp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Apr 2019 09:55:45 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:51823 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfD3Nzp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Apr 2019 09:55:45 -0400
X-Originating-IP: 90.88.149.145
Received: from localhost (aaubervilliers-681-1-29-145.w90-88.abo.wanadoo.fr [90.88.149.145])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id C5FF040009;
        Tue, 30 Apr 2019 13:55:42 +0000 (UTC)
Date:   Tue, 30 Apr 2019 15:55:42 +0200
From:   "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "' David S. Miller '" <davem@davemloft.net>
Subject: Re: crypto: inside_secure - call for volunteers
Message-ID: <20190430135542.GC3508@kwain>
References: <DBBPR09MB352627DA3C425CECC763B99FD23A0@DBBPR09MB3526.eurprd09.prod.outlook.com>
 <20190430132653.GB3508@kwain>
 <DBBPR09MB352652D305657569DCA6E436D23A0@DBBPR09MB3526.eurprd09.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DBBPR09MB352652D305657569DCA6E436D23A0@DBBPR09MB3526.eurprd09.prod.outlook.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 30, 2019 at 01:41:27PM +0000, Pascal Van Leeuwen wrote:
> >
> > I do have access to Marvell boards, having the EIP197 & EIP97 engines.
> > I
> > can help testing your modifications on those boards. Do you have a
> > public branch somewhere I can access?
> >
> I do have a git tree on Github:
> https://github.com/pvanleeuwen/linux.git
> 
> The branch I've been working on is "is_driver_armada_fix".
> 
> I don't actually know if that's publicly accessible or if I need to
> do something to make it so ... first time Git user here :-) So let me
> know if you have issues accessing that.
> 
> Alternatively, I can also send a patch file against the driver that's
> currently part of the kernel mainline Git. Or a source tarball FTM.

Thanks! Your branch is accessible, I'll be able to have a look at it.

Btw, my current development branch for the EIP driver is at:
https://github.com/atenart/linux/tree/v5.1-rc1/eip-fixes

It contains improvements & fixes for the IV retrieval and HMAC tests.
AEAD still has some issues with some testmgr tests due to the recent
refactoring.

Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
