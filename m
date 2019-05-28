Return-Path: <SRS0=c5Ty=T4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8217BC04AB6
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 12:45:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61015208CB
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 12:45:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbfE1MpE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 May 2019 08:45:04 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:55473 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727209AbfE1MpE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 May 2019 08:45:04 -0400
Received: from localhost (aaubervilliers-681-1-27-134.w90-88.abo.wanadoo.fr [90.88.147.134])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 8416D20000E;
        Tue, 28 May 2019 12:45:01 +0000 (UTC)
Date:   Tue, 28 May 2019 14:45:00 +0200
From:   "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        Riku Voipio <riku.voipio@linaro.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: crypto: inside_secure - call for volunteers
Message-ID: <20190528124500.GG8900@kwain>
References: <DBBPR09MB352627DA3C425CECC763B99FD23A0@DBBPR09MB3526.eurprd09.prod.outlook.com>
 <20190430132653.GB3508@kwain>
 <DBBPR09MB352652D305657569DCA6E436D23A0@DBBPR09MB3526.eurprd09.prod.outlook.com>
 <20190430135542.GC3508@kwain>
 <AM6PR09MB3523E393D4EA082FDDBC9251D2090@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190527150057.GD8900@kwain>
 <AM6PR09MB35237977C0E5FFB566CE3F33D21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AM6PR09MB35237977C0E5FFB566CE3F33D21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Pascal,

On Mon, May 27, 2019 at 09:06:48PM +0000, Pascal Van Leeuwen wrote:
> > From: antoine.tenart@bootlin.com [mailto:antoine.tenart@bootlin.com]
> > - You added use of PCI helpers, but this new dependency wasn't described
> >   in Kconfig (leading to have build issues).
> >
> Ah OK, to be honest, I don't know a whole lot (or much of anything, actually)
> about Kconfig, so I just hacked it a bit to be able to select the driver :-)
> But it makes sense - the PCIE subsystem is obviously always present on an
> x86 PC, so I'm getting that for free. I guess some Marvell board configs
> don't include the PCIE stuff?

PCIE support is only a configuration option, so we could have
configurations not selecting it (for whatever reason). It's not entirely
linked to the hardware having a PCIe controller or not.

> I guess the best approach would to config out the PCIE code if the
> PCIE subsystem is not configured in (instead of adding the dependency).

That would be one option.

> > - Using an EIP197 and a MacchiatoBin many of the boot tests did not
> >   pass (but I haven't look into it).
> >
> Actually, if you use driver code from before yesterday with Herbert's
> crypto2.6 git tree, then the fuzzing tests would have failed.
> I originally developed directly against Linus' 5.1 tree, which apparently
> did not contain those fuzzing tests yet.

I think basic boot tests failed as well. But I'll run this again and let
you know :)

Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
