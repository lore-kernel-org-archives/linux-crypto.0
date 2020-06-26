Return-Path: <SRS0=PFiu=AH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D40CC433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 04:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63E9C2075D
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 04:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgFZEcT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jun 2020 00:32:19 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:51738 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726607AbgFZEcT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jun 2020 00:32:19 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jog1s-0003Vg-39; Fri, 26 Jun 2020 14:31:57 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Jun 2020 14:31:56 +1000
Date:   Fri, 26 Jun 2020 14:31:56 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tero Kristo <t-kristo@ti.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, j-keerthy@ti.com
Subject: Re: [PATCHv4 3/7] crypto: sa2ul: add sha1/sha256/sha512 support
Message-ID: <20200626043155.GA2683@gondor.apana.org.au>
References: <20200615071452.25141-1-t-kristo@ti.com>
 <20200615071452.25141-4-t-kristo@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200615071452.25141-4-t-kristo@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 15, 2020 at 10:14:48AM +0300, Tero Kristo wrote:
>
> +static int sa_sha_update(struct ahash_request *req)
> +{
> +	struct sa_sha_req_ctx *rctx = ahash_request_ctx(req);
> +	struct scatterlist *sg;
> +	void *buf;
> +	int pages;
> +	struct page *pg;
> +
> +	if (!req->nbytes)
> +		return 0;
> +
> +	if (rctx->buf_free >= req->nbytes) {
> +		pg = sg_page(rctx->sg_next);
> +		buf = kmap_atomic(pg);
> +		scatterwalk_map_and_copy(buf + rctx->offset, req->src, 0,
> +					 req->nbytes, 0);
> +		kunmap_atomic(buf);
> +		rctx->buf_free -= req->nbytes;
> +		rctx->sg_next->length += req->nbytes;
> +		rctx->offset += req->nbytes;
> +	} else {
> +		pages = get_order(req->nbytes);
> +		buf = (void *)__get_free_pages(GFP_ATOMIC, pages);
> +		if (!buf)
> +			return -ENOMEM;
> +
> +		sg = kzalloc(sizeof(*sg) * 2, GFP_KERNEL);
> +		if (!sg)
> +			return -ENOMEM;
> +
> +		sg_init_table(sg, 1);
> +		sg_set_buf(sg, buf, req->nbytes);
> +		scatterwalk_map_and_copy(buf, req->src, 0, req->nbytes, 0);
> +
> +		rctx->buf_free = (PAGE_SIZE << pages) - req->nbytes;
> +
> +		if (rctx->sg_next) {
> +			sg_unmark_end(rctx->sg_next);
> +			sg_chain(rctx->sg_next, 2, sg);
> +		} else {
> +			rctx->src = sg;
> +		}
> +
> +		rctx->sg_next = sg;
> +		rctx->src_nents++;
> +
> +		rctx->offset = req->nbytes;
> +	}
> +
> +	rctx->len += req->nbytes;
> +
> +	return 0;
> +}

This is not how it's supposed to work.  To support the partial
hashing interface, you must actually hash the data and not just
save it in your context.  Otherwise your export is completely
meaningless.

If your hardware cannot export partially hashed state, then you
should use a software fallback for everything but digest.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
