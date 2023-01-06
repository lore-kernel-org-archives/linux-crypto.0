Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A20BC3DA7A
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Jan 2023 09:01:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbjAFJBz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Jan 2023 04:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjAFJBx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Jan 2023 04:01:53 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577AE625F1
        for <linux-crypto@vger.kernel.org>; Fri,  6 Jan 2023 01:01:52 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pDibl-00EVUN-1M; Fri, 06 Jan 2023 17:01:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Jan 2023 17:01:49 +0800
Date:   Fri, 6 Jan 2023 17:01:49 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Markus Stockhausen <markus.stockhausen@gmx.de>
Cc:     linux-crypto@vger.kernel.org, markus.stockhausen@gmx.de
Subject: Re: [PATCH v3 3/6] crypto/realtek: hash algorithms
Message-ID: <Y7fjfYCQdbP+2MU8@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221231162525.416709-4-markus.stockhausen@gmx.de>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Markus Stockhausen <markus.stockhausen@gmx.de> wrote:
>
> +       while (datalen) {
> +               len = min(sg_dma_len(sg), datalen);
> +
> +               idx = rtcr_inc_src_idx(idx, 1);
> +               rtcr_add_src_to_ring(cdev, idx, sg_virt(sg), len, reqlen);

You cannot use sg_virt because the SG might not even be mapped
into kernel address space.  Since the code then simply converts
it to physical you should simply pass along the DMA address you
obtained from the DMA API.

> +
> +               datalen -= len;
> +               if (datalen)
> +                       sg = sg_next(sg);
> +       }
> +
> +       if (padlen) {
> +               idx = rtcr_inc_src_idx(idx, 1);
> +               rtcr_add_src_to_ring(cdev, idx, ppad, padlen, reqlen);
> +       }
> +
> +       rtcr_add_src_pad_to_ring(cdev, idx, reqlen);
> +       rtcr_add_src_ahash_to_ring(cdev, srcidx, hctx->opmode, reqlen);
> +
> +       /* Off we go */
> +       rtcr_kick_engine(cdev);
> +       if (rtcr_wait_for_request(cdev, dstidx))
> +               return -EINVAL;

You cannot sleep in this function because it may be called from
softirq context.  Instead you should use asynchronous completion.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
