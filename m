Return-Path: <SRS0=YET+=TA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD627C43219
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Apr 2019 13:26:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A514D2075E
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Apr 2019 13:26:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbfD3N05 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Apr 2019 09:26:57 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:35177 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727180AbfD3N05 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Apr 2019 09:26:57 -0400
X-Originating-IP: 90.88.149.145
Received: from localhost (aaubervilliers-681-1-29-145.w90-88.abo.wanadoo.fr [90.88.149.145])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id AC2271C0009;
        Tue, 30 Apr 2019 13:26:53 +0000 (UTC)
Date:   Tue, 30 Apr 2019 15:26:53 +0200
From:   "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "' David S. Miller '" <davem@davemloft.net>
Subject: Re: crypto: inside_secure - call for volunteers
Message-ID: <20190430132653.GB3508@kwain>
References: <DBBPR09MB352627DA3C425CECC763B99FD23A0@DBBPR09MB3526.eurprd09.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DBBPR09MB352627DA3C425CECC763B99FD23A0@DBBPR09MB3526.eurprd09.prod.outlook.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

On Tue, Apr 30, 2019 at 01:08:27PM +0000, Pascal Van Leeuwen wrote:
> 
> Over the past weeks I have been working on the crypto driver for
> Inside Secure (EIP97/EIP197) hardware. This started out as a personal
> side project to be able to do some architectural exploration using
> real application software, but as I started fixing issues I realised
> these fixes may be generally useful. So I guess I might want to try
> upstreaming those.

That's great!

> My problem, however, is that I do not have access to any of the
> original Marvell hardware that this driver was developed for, I can
> only test things on my PCI-E based FPGA development board with much
> newer, differently configured hardware in an x86 PC. So I'm looking
> for volunteers that actually do have this Marvell HW at their disposal
> - Marvell Armada 7K or 8K e.g. Macchiatobin (Riku? You wanted a driver
> that did not need to load firmware, this your chance to help out! :-),
> Marvell Armada  3700 e.g. Espressobin and Marvell Armada 39x to be
> exact - and are willing to help me out with some testing.

I do have access to Marvell boards, having the EIP197 & EIP97 engines. I
can help testing your modifications on those boards. Do you have a
public branch somewhere I can access?

> Things that I worked on so far:
> - all registered ciphersuites now pass the testmgr compliance tests
> - fixed stability issues
> - removed dependency on external firmware images
> - added support for non-Marvell configurations of the EIP97 & EIP197
> - added support for the latest HW & FW revisions (3.1) and features
> - added support for the Xilinx FPGA development board we're using for our
>   internal development and for which we also provide images to our customers

I'm happy to see some activity on this driver :) I too was working on
making the boot test suite pass (some tests were not working since the
testmgr rework and improvement), and on performance improvement.

> Once I manage to get this upstreamed, I plan on working on improving
> performance and adding support for additional algorithms our hardware
> supports.
> 
> Anyone out there willing to contribute?

If there is a branch publicly available, I'll be happy to give it a
try.

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
