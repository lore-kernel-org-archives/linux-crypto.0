Return-Path: <SRS0=nKf/=NL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CC32C0044C
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Oct 2018 07:27:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4214C20838
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Oct 2018 07:27:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="TLaUmX7P"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4214C20838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbeJaQYg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Oct 2018 12:24:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725992AbeJaQYg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Oct 2018 12:24:36 -0400
Received: from tiger (61-216-91-114.HINET-IP.hinet.net [61.216.91.114])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFC82205F4;
        Wed, 31 Oct 2018 07:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1540970860;
        bh=0tZZZ5bC6WpqhVLKyxhZ2dJ72ajoUeh5b5eLscqPBbU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TLaUmX7Pjj0BheR2IOOL0Esop1SZmtFxlOGlpCu/ucLLN6DTeE/KZTK1UsiVjeb4K
         hNfHtpzo0Jnyx+c8awbwRZN6N+2G937oFoCVsm6E4B/hYjvble9Mq6/P1wjGzCMWdk
         aFP0JgPzD4ngNtYez4GEPwEsL8cT4+yAx22cObI8=
Date:   Wed, 31 Oct 2018 15:27:14 +0800
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
Subject: Re: [PATCH v4 4/4] ARM: imx_v6_v7_defconfig: Enable
 CRYPTO_DEV_MXS_DCP
Message-ID: <20181031072712.GK10386@tiger>
References: <cover.1539779579.git.leonard.crestez@nxp.com>
 <5ba9a89b881f6ce816262ce52f431e32e7fb85a7.1539779579.git.leonard.crestez@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <5ba9a89b881f6ce816262ce52f431e32e7fb85a7.1539779579.git.leonard.crestez@nxp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181031072714.mt1_todMlfb2H6qqDD7BTb1DRhn08iWbU6YKLYNRrzk@z>

On Wed, Oct 17, 2018 at 12:37:55PM +0000, Leonard Crestez wrote:
> This block is present in 6sl, 6sll and 6ull so it should be enabled in
> the default imx kernel config.
> 
> Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
> Reviewed-by: Fabio Estevam <festevam@gmail.com>

Applied, thanks.
