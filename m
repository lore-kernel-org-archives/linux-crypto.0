Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CBBEC433F5
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Mar 2022 00:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiCCABI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Mar 2022 19:01:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiCCAAz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Mar 2022 19:00:55 -0500
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2124D626;
        Wed,  2 Mar 2022 16:00:07 -0800 (PST)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nPXwh-0006EG-NI; Thu, 03 Mar 2022 09:59:48 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 03 Mar 2022 10:59:47 +1200
Date:   Thu, 3 Mar 2022 10:59:47 +1200
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        jiabing.wan@qq.com
Subject: Re: [PATCH] hwrng: cavium: fix NULL but dereferenced coccicheck error
Message-ID: <Yh/24zjO72Inczy6@gondor.apana.org.au>
References: <20220225063901.893274-1-wanjiabing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220225063901.893274-1-wanjiabing@vivo.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 25, 2022 at 02:38:59PM +0800, Wan Jiabing wrote:
> Fix following coccicheck warning:
> ./drivers/char/hw_random/cavium-rng-vf.c:182:17-20: ERROR:
> pdev is NULL but dereferenced.
> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
>  drivers/char/hw_random/cavium-rng-vf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
