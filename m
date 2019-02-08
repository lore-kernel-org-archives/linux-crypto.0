Return-Path: <SRS0=4jM/=QP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B2F8C282CC
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 07:16:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4618A21919
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 07:16:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbfBHHQo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Feb 2019 02:16:44 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:34044 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbfBHHQo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Feb 2019 02:16:44 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gs0Or-0000QE-Kn; Fri, 08 Feb 2019 15:16:37 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gs0Op-0008Co-QL; Fri, 08 Feb 2019 15:16:35 +0800
Date:   Fri, 8 Feb 2019 15:16:35 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] crypto: caam - Do not overwrite IV
Message-ID: <20190208071635.5dkhabduambzzsu3@gondor.apana.org.au>
References: <20190131061225.15541-1-s.hauer@pengutronix.de>
 <VI1PR0402MB3485ED41FE4B512C83271E0B986D0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB3485ED41FE4B512C83271E0B986D0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 04, 2019 at 12:26:26PM +0000, Horia Geanta wrote:
>
> The root cause of the issue is cache line sharing.
> 
> struct crypto_gcm_req_priv_ctx {
>         u8 iv[16];
>         u8 auth_tag[16];
> 	[...]
> };
> 
> Since caam does not support ghash on i.MX6, only ctr skcipher part of the gcm is
> offloaded.
> The skcipher request received by caam has req->src pointing to auth_tag[16] (1st
> S/G entry) and req->iv pointing to iv[16].
> caam driver:
> 1-DMA maps req->src
> 2-copies original req->iv to internal buffer
> 3-updates req->iv (scatterwalk_map_and_copy from last block in req->src)
> 4-sends job to crypto engine
> 
> Problem is that operation 3 above is writing iv[16], which is on the same cache
> line as auth_tag[16] that was previously DMA mapped.
> 
> I've checked that forcing auth_tag and iv to be on separate cache lines
> -       u8 auth_tag[16];
> +       u8 auth_tag[16] ____cacheline_aligned;
> solves the issue.
> 
> OTOH, maybe the fix should be done in caam driver, by avoiding any writes
> (touching any data, even seemingly unrelated req->iv) after DMA mapping
> req->src, req->dst etc.
> Having req->iv and req->src sharing the same cache line is unfortunate.
> 
> Herbert, what do you think?

Well just like the other cases if your input is a kernel pointer you
must not perform DMA on it.  Only SG lists can be used for DMA.

So the IV needs to be copied on completion.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
