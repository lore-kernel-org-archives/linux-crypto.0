Return-Path: <SRS0=nKf/=NL=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725992AbeJaQYg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Oct 2018 12:24:36 -0400
Date: Wed, 31 Oct 2018 15:27:14 +0800
From: Shawn Guo <shawnguo@kernel.org>
To: Leonard Crestez <leonard.crestez@nxp.com>
Cc: Fabio Estevam <fabio.estevam@nxp.com>,
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ba9a89b881f6ce816262ce52f431e32e7fb85a7.1539779579.git.leonard.crestez@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 17, 2018 at 12:37:55PM +0000, Leonard Crestez wrote:
> This block is present in 6sl, 6sll and 6ull so it should be enabled in
> the default imx kernel config.
> 
> Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
> Reviewed-by: Fabio Estevam <festevam@gmail.com>

Applied, thanks.
