Return-Path: <SRS0=nKf/=NL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1CA8C0044C
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Oct 2018 07:27:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69AC120838
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Oct 2018 07:27:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="tpMJ8J1q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69AC120838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbeJaQYE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Oct 2018 12:24:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725992AbeJaQYE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Oct 2018 12:24:04 -0400
Received: from tiger (61-216-91-114.HINET-IP.hinet.net [61.216.91.114])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 342DA205F4;
        Wed, 31 Oct 2018 07:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1540970828;
        bh=AFPIwubJbUYo6sDFilTlnrEq6pQIrVx6OpKTAwRdHEE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tpMJ8J1qaQACckEEqnxlfQDpzTrPDc9bwg+Fw90GDMa4jQXlN4JWtUq4qAM4lKPHj
         ZiLsEUBqROp2rzzUw6OKKGatOiEW1JDrxPadHhGIhpbsDUVg/jFQfDTjqzVLFSB4PN
         +3Ji1O41P7Iy8kQ18ZthgPfytfvCgvIQea0QsOGk=
Date:   Wed, 31 Oct 2018 15:26:39 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Leonard Crestez <leonard.crestez@nxp.com>
Cc:     Fabio Estevam <fabio.estevam@nxp.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "David S . Miller " <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v4 3/4] ARM: dts: imx6ull: Add dcp node
Message-ID: <20181031072637.GJ10386@tiger>
References: <cover.1539779579.git.leonard.crestez@nxp.com>
 <f503eea6c702aeff091f4c03d4059b67ec17b2b4.1539779579.git.leonard.crestez@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <f503eea6c702aeff091f4c03d4059b67ec17b2b4.1539779579.git.leonard.crestez@nxp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181031072639.r7lX-tTPRL3lnuNKsm-TjsPW2FPbxD4X3kWck6bEOXY@z>

On Wed, Oct 17, 2018 at 12:37:54PM +0000, Leonard Crestez wrote:
> The DCP block on 6ull has no major differences other than requiring
> explicit clock enabling.
> 
> Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
> Reviewed-by: Fabio Estevam <festevam@gmail.com>

Applied, thanks.
