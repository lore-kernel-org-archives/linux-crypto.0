Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B07C43217
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Oct 2022 10:50:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbiJUKug (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Oct 2022 06:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbiJUKuY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Oct 2022 06:50:24 -0400
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9248187085
        for <linux-crypto@vger.kernel.org>; Fri, 21 Oct 2022 03:50:21 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1olpav-004ctD-Ii; Fri, 21 Oct 2022 18:50:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Oct 2022 18:50:18 +0800
Date:   Fri, 21 Oct 2022 18:50:18 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Markus Stockhausen <markus.stockhausen@gmx.de>
Cc:     linux-crypto@vger.kernel.org, markus.stockhausen@gmx.de
Subject: Re: [PATCH 3/6] crypto/realtek: hash algorithms
Message-ID: <Y1J5amO8CWp23Rk7@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013184026.63826-4-markus.stockhausen@gmx.de>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Markus Stockhausen <markus.stockhausen@gmx.de> wrote:
>
> +static int rtcr_ahash_import(struct ahash_request *areq, const void *in)
> +{
> +       const void *fexp = (const void *)fallback_export_state((void *)in);
> +       struct ahash_request *freq = fallback_request_ctx(areq);
> +       struct rtcr_ahash_req *hreq = ahash_request_ctx(areq);
> +       const struct rtcr_ahash_req *hexp = in;
> +
> +       hreq->state = hexp->state;
> +       if (hreq->state & RTCR_REQ_FB_ACT)
> +               hreq->state |= RTCR_REQ_FB_RDY;
> +
> +       if (rtcr_check_fallback(areq))
> +               return crypto_ahash_import(freq, fexp);
> +
> +       memcpy(hreq, hexp, sizeof(struct rtcr_ahash_req));
> +
> +       return 0;
> +}

What happens when you import a fallback export but rtcr_check_fallback
returns false?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
