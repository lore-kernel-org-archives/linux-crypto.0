Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 519AFC07E95
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Jul 2021 07:28:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28BC4613E9
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Jul 2021 07:28:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbhGPHbL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Jul 2021 03:31:11 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:51396 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235808AbhGPHbL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jul 2021 03:31:11 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1m4IGO-0004rw-KJ; Fri, 16 Jul 2021 15:28:00 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1m4IGF-0001z9-SW; Fri, 16 Jul 2021 15:27:51 +0800
Date:   Fri, 16 Jul 2021 15:27:51 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jason Wang <wangborong@cdjrlc.com>
Cc:     clabbe.montjoie@gmail.com, davem@davemloft.net, mripard@kernel.org,
        wens@csie.org, jernej.skrabec@gmail.com, colin.king@canonical.com,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: sun8i-ss - Use kfree_sensitive
Message-ID: <20210716072751.GA7595@gondor.apana.org.au>
References: <20210701132200.31583-1-wangborong@cdjrlc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210701132200.31583-1-wangborong@cdjrlc.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 01, 2021 at 09:22:00PM +0800, Jason Wang wrote:
> The kfree_sensitive is a kernel API to clear sensitive information
> that should not be leaked to other future users of the same memory
> objects and free the memory. Its function is the same as the
> combination of memzero_explicit and kfree. Thus, we can replace the
> combination APIs with the single kfree_sensitive API.
> 
> Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
> ---
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)

I don't know what happened but this patch didn't make it into
patchwork.  Could you please check and resubmit?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
