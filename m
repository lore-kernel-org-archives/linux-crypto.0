Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88289C433EF
	for <linux-crypto@archiver.kernel.org>; Sat, 13 Nov 2021 06:01:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C4B260FBF
	for <linux-crypto@archiver.kernel.org>; Sat, 13 Nov 2021 06:01:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbhKMGEY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 13 Nov 2021 01:04:24 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:56688 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229487AbhKMGEY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 13 Nov 2021 01:04:24 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mlm6V-0000DN-1f; Sat, 13 Nov 2021 14:01:31 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mlm6J-0005Tm-Km; Sat, 13 Nov 2021 14:01:19 +0800
Date:   Sat, 13 Nov 2021 14:01:19 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kai Ye <yekai13@huawei.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangzhou1@hisilicon.com, liulongfang@huawei.com
Subject: Re: [PATCH v3 2/6] crypto: hisilicon/sec - add ahash alg features
 for Kunpeng920
Message-ID: <20211113060119.GA21020@gondor.apana.org.au>
References: <20211022091055.15369-1-yekai13@huawei.com>
 <20211022091055.15369-3-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211022091055.15369-3-yekai13@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 22, 2021 at 05:10:51PM +0800, Kai Ye wrote:
>
> +static int sec_ahash_export(struct ahash_request *req, void *out)
> +{
> +	/*
> +	 * This function dumps the
> +	 * entire state of the ongoing transformation into a provided block of
> +	 * data so it can be @import'ed back later on.
> +	 */
> +	struct sec_req *sreq = ahash_request_ctx(req);
> +	struct sec_auth_ctx *a_ctx = &sreq->ctx->a_ctx;
> +	u8 mac_len = a_ctx->mac_len;
> +
> +	memcpy(out, &sreq->hash_req, sizeof(struct sec_ahash_req));

So this structure seems to contain a bunch of metadata but not
the actual hash state.

> +	/* Export the partial hash data */
> +	memcpy(out + sizeof(struct sec_ahash_req), a_ctx->metamac, mac_len);

This looks like it could be the hash state, but mac_len is clamped
at digest size so it's way too small to contain the entire hash
state.

How is this supposed to work?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
