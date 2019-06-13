Return-Path: <SRS0=nMY8=UM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA711C31E4A
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Jun 2019 16:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C149D2084D
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Jun 2019 16:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560445123;
	bh=4lclOnf/sfAPyFXVi/HGPDJVKp6DvLHCXDKLDcqvQaU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=jgE0FXAMvRSAGqYpNGG/aYaOzXm+OvpqBgp6gbFf8KTfJQR23CUnzHePISiNu749W
	 2i+AavA9dKf/YCOIjpsndWZLk3tSe1fJCn81XZjAmlmmWylT45kr7/3hCWeOCPSBfT
	 35DRD2sTaRTVKbsks3eM3AiGTkPn1hzUI5VxmzXg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729854AbfFMQ6b (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Jun 2019 12:58:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:53208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729886AbfFMArs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 20:47:48 -0400
Received: from dragon (li1322-146.members.linode.com [45.79.223.146])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0644215EA;
        Thu, 13 Jun 2019 00:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560386868;
        bh=4lclOnf/sfAPyFXVi/HGPDJVKp6DvLHCXDKLDcqvQaU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Apd1/9RvRe5RRMZS7XQ5mBXWsp+u6fbo99Qa+k24pfkJ/rDYjokzMyqi2R02tYu1U
         mgmuZuNYIIQgcl/+J3WTW0OGIJYhv4veu1KwtcdtxW3zcTFlr1GggxJDg5cBz95zlI
         xTfzNH3Q9tNXDAlBIzzqKKbubumC1q/twZiOPTBc=
Date:   Thu, 13 Jun 2019 08:47:10 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
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
Message-ID: <20190613004709.GB20747@dragon>
References: <20190606080255.25504-1-horia.geanta@nxp.com>
 <20190612103926.GE11086@dragon>
 <VI1PR0402MB3485A573518D60A573BA55C298EC0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190612130602.GH11086@dragon>
 <VI1PR0402MB348596BF52CE43B5D4CD534798EC0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190612132600.GI11086@dragon>
 <20190612135952.ds6zzh7ppahiuodd@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612135952.ds6zzh7ppahiuodd@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jun 12, 2019 at 09:59:52PM +0800, Herbert Xu wrote:
> On Wed, Jun 12, 2019 at 09:26:02PM +0800, Shawn Guo wrote:
> >
> > Yes, it happens from time to time depending on maintainer's style. I'm
> > fine with the DT changes going through other subsystem tree, if the
> > subsystem maintainer wants to and is willing to take the risk of merge
> > conflict between his tree and arm-soc tree.
> 
> I have no problems with potential merge conflicts.

Then feel free to take it:

Acked-by: Shawn Guo <shawnguo@kernel.org>
