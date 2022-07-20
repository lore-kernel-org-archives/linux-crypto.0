Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B4ACC433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jul 2022 09:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbiGTJlZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jul 2022 05:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236348AbiGTJlY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jul 2022 05:41:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519DE5A2D8
        for <linux-crypto@vger.kernel.org>; Wed, 20 Jul 2022 02:41:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4B4361B56
        for <linux-crypto@vger.kernel.org>; Wed, 20 Jul 2022 09:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C183AC3411E;
        Wed, 20 Jul 2022 09:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658310082;
        bh=0Uh7HU+pZdlkv+nXlUEIbOCQe7d9i8cnyad1o6EdCak=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=REyJ8w41hzygC6bjYFOTuXSBcmkl3h85awz7i5ifAyKH422K/3kkUE6nmDG7d9pxY
         /FITzayhhmkiQf0rGMVdT0e+OJ4BOgCIkdJhqP7yCbqbNoP3iZ7/uD/mytl0yULWBs
         JE2h51gok/4AbR8MKJW2msOyR+l4oNKLPvy2mpBd1I5Pgh62t3MfuxRBbGjigfz2PE
         dcImcQzGe6T6bxFp9boDVFxHTK4kpXKwheR5nIW0ACkZVYQNztDcDYMsGMlU+9D9Th
         +gaMaXSsDK4jMzORkvzHFusfBJloi9e6KesxXhRZhTChjgHNd58s9gj+dBah8rnh1f
         AiJxM7wu4LfdQ==
Date:   Wed, 20 Jul 2022 10:41:16 +0100
From:   Will Deacon <will@kernel.org>
To:     GUO Zihua <guozihua@huawei.com>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        catalin.marinas@arm.com, ebiggers@kernel.org
Subject: Re: [PATCH v2] arm64/crypto: poly1305 fix a read out-of-bound
Message-ID: <20220720094116.GC15752@willie-the-truck>
References: <20220712075031.29061-1-guozihua@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712075031.29061-1-guozihua@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 12, 2022 at 03:50:31PM +0800, GUO Zihua wrote:
> A kasan error was reported during fuzzing:

[...]

> This patch fixes the issue by calling poly1305_init_arm64() instead of
> poly1305_init_arch(). This is also the implementation for the same
> algorithm on arm platform.
> 
> Fixes: f569ca164751 ("crypto: arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation")
> Cc: stable@vger.kernel.org
> Signed-off-by: GUO Zihua <guozihua@huawei.com>
> ---
>  arch/arm64/crypto/poly1305-glue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

I'm not a crypto guy by any stretch of the imagination, but Ard is out
at the moment and this looks like an important fix so I had a crack at
reviewing it.

> diff --git a/arch/arm64/crypto/poly1305-glue.c b/arch/arm64/crypto/poly1305-glue.c
> index 9c3d86e397bf..1fae18ba11ed 100644
> --- a/arch/arm64/crypto/poly1305-glue.c
> +++ b/arch/arm64/crypto/poly1305-glue.c
> @@ -52,7 +52,7 @@ static void neon_poly1305_blocks(struct poly1305_desc_ctx *dctx, const u8 *src,
>  {
>  	if (unlikely(!dctx->sset)) {
>  		if (!dctx->rset) {
> -			poly1305_init_arch(dctx, src);
> +			poly1305_init_arm64(&dctx->h, src);
>  			src += POLY1305_BLOCK_SIZE;
>  			len -= POLY1305_BLOCK_SIZE;
>  			dctx->rset = 1;

With this change, we no longer initialise dctx->buflen to 0 as part of the
initialisation. Looking at neon_poly1305_do_update(), I'm a bit worried
that we could land in the 'if (likely(len >= POLY1305_BLOCK_SIZE))' block,
end up with len == 0 and fail to set dctx->buflen. Is this a problem, or is
my ignorance showing?

Will
