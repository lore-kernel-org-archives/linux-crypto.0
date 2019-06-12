Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87230C31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 13:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 620D620866
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 13:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560346011;
	bh=NM/4gZb0J83hRo3GjTDGogF0kEC8Qio6Tsc1tV61U7I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=XI6rBc+SlyBetWXm6xecboIrcZPCqRYrOAJINFNj3bCToKM3kc6LkpVEKUTdynx1h
	 jvnN5JSE/amQHJs1pKEjruSZN9udNXC0YD++/BPYJp0ZHWCPnUjMbejh6qbLF+UQu0
	 QAGGjDZwiu2sQpVKVjXY9zn9sQDc2YAT7oQa8n7U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729330AbfFLN0q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 09:26:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728977AbfFLN0q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 09:26:46 -0400
Received: from dragon (li1264-180.members.linode.com [45.79.165.180])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AA9920866;
        Wed, 12 Jun 2019 13:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560346004;
        bh=NM/4gZb0J83hRo3GjTDGogF0kEC8Qio6Tsc1tV61U7I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZAdGtljkJqX9KUoyGddtloo7a1KIXSmwkorvJ1FPH3hECWiB47rEz7umtF889uIAZ
         st0rPgwtAxNI94JP0sCnAgXqVXDyiC7py8EiUaaxv68/0vjtWCdC3f9Mualy5WGo+9
         R5yCVVLPx60K93T53td5GSOXDr5RpZ+qnUz/Dc8M=
Date:   Wed, 12 Jun 2019 21:26:02 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: imx7ulp: add crypto support
Message-ID: <20190612132600.GI11086@dragon>
References: <20190606080255.25504-1-horia.geanta@nxp.com>
 <20190612103926.GE11086@dragon>
 <VI1PR0402MB3485A573518D60A573BA55C298EC0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190612130602.GH11086@dragon>
 <VI1PR0402MB348596BF52CE43B5D4CD534798EC0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <VI1PR0402MB348596BF52CE43B5D4CD534798EC0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jun 12, 2019 at 01:15:46PM +0000, Horia Geanta wrote:
> On 6/12/2019 4:06 PM, Shawn Guo wrote:
> > On Wed, Jun 12, 2019 at 11:45:18AM +0000, Horia Geanta wrote:
> >> On 6/12/2019 1:40 PM, Shawn Guo wrote:
> >>> On Thu, Jun 06, 2019 at 11:02:55AM +0300, Horia Geantă wrote:
> >>>> From: Iuliana Prodan <iuliana.prodan@nxp.com>
> >>>>
> >>>> Add crypto node in device tree for CAAM support.
> >>>>
> >>>> Noteworthy is that on 7ulp the interrupt line is shared
> >>>> between the two job rings.
> >>>>
> >>>> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
> >>>> Signed-off-by: Franck LENORMAND <franck.lenormand@nxp.com>
> >>>> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
> >>>> ---
> >>>>
> >>>> I've just realized that this patch should be merged through the crypto tree,
> >>>> else bisectability could be affected due to cryptodev-2.6
> >>>> commit 385cfc84a5a8 ("crypto: caam - disable some clock checks for iMX7ULP")
> >>>> ( https://patchwork.kernel.org/patch/10970017/ )
> >>>> which should come first.
> >>>
> >>> I'm not sure I follow it.  This is a new device added to imx7ulp DT.
> >>> It's never worked before on imx7ulp.  How would it affect git bisect?
> >>>
> >> Driver corresponding to this device (drivers/crypto/caam) has to be updated
> >> before adding the node in DT.
> >> Is there any guarantee wrt. merge order of the crypto and DT trees?
> > 
> > Do not merge DT changes until driver part hits mainline.
> > 
> That would mean driver changes would be merged in v5.3 and DT node in v5.4.

It's quite normal that dependent changes land on mainline in multiple
cycles.

> 
> Would going through the crypto tree with this patch be such a big issue?

The only issue would be the potential merge conflict.

> I don't think it's the first time (relatively small) DT patches
> are merged via other trees.

Yes, it happens from time to time depending on maintainer's style. I'm
fine with the DT changes going through other subsystem tree, if the
subsystem maintainer wants to and is willing to take the risk of merge
conflict between his tree and arm-soc tree.

Shawn
