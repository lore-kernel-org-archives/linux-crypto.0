Return-Path: <SRS0=HT46=UT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B9FAC43613
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 06:02:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C6CE20B1F
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 06:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbfFTGCm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Jun 2019 02:02:42 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:38376 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbfFTGCm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Jun 2019 02:02:42 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hdq9X-0008UB-3U; Thu, 20 Jun 2019 14:02:31 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hdq9N-0006tl-Hn; Thu, 20 Jun 2019 14:02:21 +0800
Date:   Thu, 20 Jun 2019 14:02:21 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     "David S. Miller" <davem@davemloft.net>, horia.geanta@nxp.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Imre Deak <imre.deak@intel.com>
Subject: Re: [PATCH v4 1/4] lib/scatterlist: Fix mapping iterator when
 sg->offset is greater than PAGE_SIZE
Message-ID: <20190620060221.q4pbsqzsza3pxs42@gondor.apana.org.au>
References: <cover.1560805614.git.christophe.leroy@c-s.fr>
 <f28c6b0e2f9510f42ca934f19c4315084e668c21.1560805614.git.christophe.leroy@c-s.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f28c6b0e2f9510f42ca934f19c4315084e668c21.1560805614.git.christophe.leroy@c-s.fr>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 17, 2019 at 09:15:02PM +0000, Christophe Leroy wrote:
> All mapping iterator logic is based on the assumption that sg->offset
> is always lower than PAGE_SIZE.
> 
> But there are situations where sg->offset is such that the SG item
> is on the second page. In that case sg_copy_to_buffer() fails
> properly copying the data into the buffer. One of the reason is
> that the data will be outside the kmapped area used to access that
> data.
> 
> This patch fixes the issue by adjusting the mapping iterator
> offset and pgoffset fields such that offset is always lower than
> PAGE_SIZE.
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> Fixes: 4225fc8555a9 ("lib/scatterlist: use page iterator in the mapping iterator")
> Cc: stable@vger.kernel.org
> ---
>  lib/scatterlist.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)

Good catch.

> @@ -686,7 +686,12 @@ static bool sg_miter_get_next_page(struct sg_mapping_iter *miter)
>  		sg = miter->piter.sg;
>  		pgoffset = miter->piter.sg_pgoffset;
>  
> -		miter->__offset = pgoffset ? 0 : sg->offset;
> +		offset = pgoffset ? 0 : sg->offset;
> +		while (offset >= PAGE_SIZE) {
> +			miter->piter.sg_pgoffset = ++pgoffset;
> +			offset -= PAGE_SIZE;
> +		}

How about

	miter->piter.sg_pgoffset += offset >> PAGE_SHIFT;
	offset &= PAGE_SIZE - 1;

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
