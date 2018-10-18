Return-Path: <SRS0=XFsj=M6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-oi1-f194.google.com ([209.85.167.194]:41447 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728295AbeJSC1r (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Oct 2018 22:27:47 -0400
Date: Thu, 18 Oct 2018 13:25:32 -0500
From: Rob Herring <robh@kernel.org>
To: Leonard Crestez <leonard.crestez@nxp.com>
Cc: Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S . Miller " <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/4] dt-bindings: crypto: Mention clocks for mxs-dcp
Message-ID: <20181018182532.GA28722@bogus>
References: <cover.1539779579.git.leonard.crestez@nxp.com>
 <4536b5b5b101ab6a4197fb4891f775ddeb519847.1539779579.git.leonard.crestez@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4536b5b5b101ab6a4197fb4891f775ddeb519847.1539779579.git.leonard.crestez@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 17 Oct 2018 12:37:51 +0000, Leonard Crestez wrote:
> Explicit clock enabling is required on 6sll and 6ull so mention that
> standard clock bindings are used.
> 
> Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
> Reviewed-by: Fabio Estevam <festevam@gmail.com>
> ---
>  Documentation/devicetree/bindings/crypto/fsl-dcp.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
