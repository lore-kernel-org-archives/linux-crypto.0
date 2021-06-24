Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45FFFC49EA6
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jun 2021 06:56:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E25461374
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jun 2021 06:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbhFXG7J (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jun 2021 02:59:09 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50838 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231132AbhFXG7I (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jun 2021 02:59:08 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1lwJI9-0005XX-4v; Thu, 24 Jun 2021 14:56:49 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lwJI4-0002aO-DS; Thu, 24 Jun 2021 14:56:44 +0800
Date:   Thu, 24 Jun 2021 14:56:44 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-arm-kernel@lists.infradead.org, Marek Vasut <marex@denx.de>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Subject: Re: [PATCH 2/2] crypto: mxs_dcp: Use sg_mapping_iter to copy data
Message-ID: <20210624065644.GA7826@gondor.apana.org.au>
References: <20210618211411.1167726-1-sean.anderson@seco.com>
 <20210618211411.1167726-2-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210618211411.1167726-2-sean.anderson@seco.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 18, 2021 at 05:14:11PM -0400, Sean Anderson wrote:
> This uses the sg_miter_*() functions to copy data, instead of doing it
> ourselves. Using sg_copy_buffer() would be better, but this way we don't
> have to keep traversing the beginning of the scatterlist every time we
> do another copy.
> 
> In addition to reducing code size, this fixes the following oops
> resulting from failing to kmap the page:

Thanks for the patch.  Just a minor nit:

> @@ -365,25 +364,13 @@ static int mxs_dcp_aes_block_crypt(struct crypto_async_request *arq)
>  
>  				out_tmp = out_buf;
>  				last_out_len = actx->fill;
> -				while (dst && actx->fill) {
> -					if (!split) {
> -						dst_buf = sg_virt(dst);
> -						dst_off = 0;
> -					}
> -					rem = min(sg_dma_len(dst) - dst_off,
> -						  actx->fill);
> -
> -					memcpy(dst_buf + dst_off, out_tmp, rem);
> +
> +				while (sg_miter_next(&dst_iter) && actx->fill) {
> +					rem = min(dst_iter.length, actx->fill);

This comparison generates a sparse warning due to conflicting types,
please fix this and resubmit.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
