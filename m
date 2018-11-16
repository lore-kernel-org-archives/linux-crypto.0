Return-Path: <SRS0=1iZj=N3=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37638 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727502AbeKPQa1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Nov 2018 11:30:27 -0500
Date: Fri, 16 Nov 2018 14:19:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Leonard Crestez <leonard.crestez@nxp.com>
Cc: "David S . Miller " <davem@davemloft.net>,
        Marek Vasut <marek.vasut@gmail.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND 0/2] Port mxs-dcp to imx6ull and imx6sll
Message-ID: <20181116061915.3tigrkkucg65xeai@gondor.apana.org.au>
References: <cover.1541604742.git.leonard.crestez@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1541604742.git.leonard.crestez@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 07, 2018 at 03:33:30PM +0000, Leonard Crestez wrote:
> The DCP block is present on 6sll and 6ull but not enabled. The hardware is
> mostly compatible with 6sl, the only important difference is that explicit
> clock enabling is required.
> 
> All patches already have review tags from a few weeks ago. No changes
> relative to v4: https://lore.kernel.org/patchwork/cover/1001134/
> 
> Patches 3/4 were already accepted by Shawn Guo for the imx tree, this
> resend is just for the crypto parts now that the merge window is over.
> 
> Leonard Crestez (2):
>   dt-bindings: crypto: Mention clocks for mxs-dcp
>   crypto: mxs-dcp - Add support for dcp clk
> 
>  .../devicetree/bindings/crypto/fsl-dcp.txt    |  2 ++
>  drivers/crypto/mxs-dcp.c                      | 28 +++++++++++++++++--
>  2 files changed, 27 insertions(+), 3 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
