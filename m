Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 683B5C38145
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Sep 2022 11:00:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235538AbiIBLAp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Sep 2022 07:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235529AbiIBLAm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Sep 2022 07:00:42 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA7066A55;
        Fri,  2 Sep 2022 04:00:40 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oU4PH-000LKk-Nv; Fri, 02 Sep 2022 21:00:16 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Sep 2022 19:00:15 +0800
Date:   Fri, 2 Sep 2022 19:00:15 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kshitiz Varshney <kshitiz.varshney@nxp.com>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Rahul Kumar Yadav <rahulkumar.yadav@nxp.com>,
        Vabhav Sharma <vabhav.sharma@nxp.com>,
        Sahil Malhotra <sahil.malhotra@nxp.com>,
        Matt Mackall <mpm@selenic.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Martin Kaiser <martin@kaiser.cx>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v1] Moving IRQ handler registering after
 imx_rngc_irq_mask_clear()
Message-ID: <YxHiP74MhWdQHiRY@gondor.apana.org.au>
References: <20220822111903.328957-1-kshitiz.varshney@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822111903.328957-1-kshitiz.varshney@nxp.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 22, 2022 at 01:19:03PM +0200, Kshitiz Varshney wrote:
> Issue:
> While servicing interrupt, if the IRQ happens to be because of a SEED_DONE
> due to a previous boot stage, you end up completing the completion
> prematurely, hence causing kernel to crash while booting.
> 
> Fix:
> Moving IRQ handler registering after imx_rngc_irq_mask_clear()
> 
> Fixes: 1d5449445bd0 (hwrng: mx-rngc - add a driver for Freescale RNGC)
> Signed-off-by: Kshitiz Varshney <kshitiz.varshney@nxp.com>
> ---
>  drivers/char/hw_random/imx-rngc.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
