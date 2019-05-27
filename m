Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E34A0C04AB3
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 15:01:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C11492182B
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 15:01:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfE0PBB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 11:01:01 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:41367 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbfE0PBA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 11:01:00 -0400
Received: from localhost (aaubervilliers-681-1-27-134.w90-88.abo.wanadoo.fr [90.88.147.134])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 9472524000B;
        Mon, 27 May 2019 15:00:58 +0000 (UTC)
Date:   Mon, 27 May 2019 17:00:58 +0200
From:   "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        Riku Voipio <riku.voipio@linaro.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: crypto: inside_secure - call for volunteers
Message-ID: <20190527150057.GD8900@kwain>
References: <DBBPR09MB352627DA3C425CECC763B99FD23A0@DBBPR09MB3526.eurprd09.prod.outlook.com>
 <20190430132653.GB3508@kwain>
 <DBBPR09MB352652D305657569DCA6E436D23A0@DBBPR09MB3526.eurprd09.prod.outlook.com>
 <20190430135542.GC3508@kwain>
 <AM6PR09MB3523E393D4EA082FDDBC9251D2090@AM6PR09MB3523.eurprd09.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AM6PR09MB3523E393D4EA082FDDBC9251D2090@AM6PR09MB3523.eurprd09.prod.outlook.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

On Wed, May 15, 2019 at 09:02:42AM +0000, Pascal Van Leeuwen wrote:
> 
> It's been 2 weeks already so I'm kind of curious if either one of you
> managed to try anything with my modified Inside Secure driver yet?
> Note that if you experience any issues at all that:
> 
> a) I'd be very interested to hear about them
> b) I'm fully willing to help resolve those issues
> 
> BTW: if there are no issues and everything worked fine I'm also
> interested to hear about that :-)

Sorry about the looong delay. I did make a quick test of your series and
had some issues:
- You added use of PCI helpers, but this new dependency wasn't described
  in Kconfig (leading to have build issues).
- Using an EIP197 and a MacchiatoBin many of the boot tests did not
  pass (but I haven't look into it).

I'll perform the test again to at least give you a trace :)

Btw, I'm available on IRC (atenart on Freenode), that might be easier to
have a discussion when debugging things.

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
