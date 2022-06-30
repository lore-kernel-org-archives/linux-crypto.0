Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90920C43334
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Jun 2022 06:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiF3Gsj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Jun 2022 02:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbiF3Gsj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Jun 2022 02:48:39 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1131A069;
        Wed, 29 Jun 2022 23:48:36 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1o6nyJ-00CwRv-5u; Thu, 30 Jun 2022 16:48:16 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Jun 2022 14:48:15 +0800
Date:   Thu, 30 Jun 2022 14:48:15 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Li Qiong <liqiong@nfschina.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        linux-crypto@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        yuzhe@nfschina.com, renyu@nfschina.com
Subject: Re: [PATCH] crypto: stm32 - Handle failure of kmalloc_array()
Message-ID: <Yr1HL5dr/zUyx+5q@gondor.apana.org.au>
References: <20220622020208.25776-1-liqiong@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622020208.25776-1-liqiong@nfschina.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jun 22, 2022 at 10:02:08AM +0800, Li Qiong wrote:
> As the possible failure of the kmalloc_array(), therefore it
> should be better to check it and return '-ENOMEM' on error.
> 
> Signed-off-by: Li Qiong <liqiong@nfschina.com>
> ---
>  drivers/crypto/stm32/stm32-hash.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
> index d33006d43f76..fc03e32e364f 100644
> --- a/drivers/crypto/stm32/stm32-hash.c
> +++ b/drivers/crypto/stm32/stm32-hash.c
> @@ -970,6 +970,8 @@ static int stm32_hash_export(struct ahash_request *req, void *out)
>  	rctx->hw_context = kmalloc_array(3 + HASH_CSR_REGISTER_NUMBER,
>  					 sizeof(u32),
>  					 GFP_KERNEL);
> +	if (!rctx->hw_context)
> +		return -ENOMEM;

Actually the problem is bigger than that.  The driver should not be
allocating memory in the export function at all.  This memory will
be leaked as exported requests won't be finalized.

We need to fix this driver to do export properly, or if that's not
possible, we should delete this driver.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
