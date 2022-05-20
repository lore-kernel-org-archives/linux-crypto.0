Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A61ABC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 20 May 2022 06:00:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345673AbiETGAT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 May 2022 02:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345671AbiETGAT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 May 2022 02:00:19 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC5014AA74;
        Thu, 19 May 2022 23:00:18 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nrvgK-00Fi1N-Sh; Fri, 20 May 2022 16:00:14 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 May 2022 14:00:13 +0800
Date:   Fri, 20 May 2022 14:00:13 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        mpm@selenic.com, tony@atomide.com
Subject: Re: [PATCH -next] hwrng: omap3-rom - fix using wrong clk_disable()
 in omap_rom_rng_runtime_resume()
Message-ID: <YocubT64UwtLKn1W@gondor.apana.org.au>
References: <20220514084241.681812-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220514084241.681812-1-yangyingliang@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, May 14, 2022 at 04:42:41PM +0800, Yang Yingliang wrote:
> 'ddata->clk' is enabled by clk_prepare_enable(), it should be disabled
> by clk_disable_unprepare().
> 
> Fixes: 8d9d4bdc495f ("hwrng: omap3-rom - Use runtime PM instead of custom functions")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/char/hw_random/omap3-rom-rng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
