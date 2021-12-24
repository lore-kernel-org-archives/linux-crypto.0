Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1BE6C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Dec 2021 03:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236834AbhLXD0e (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Dec 2021 22:26:34 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:58466 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245536AbhLXD0S (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Dec 2021 22:26:18 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1n0bDj-0006MU-Nr; Fri, 24 Dec 2021 14:26:17 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 24 Dec 2021 14:26:15 +1100
Date:   Fri, 24 Dec 2021 14:26:15 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: omap-aes: Fix broken pm_runtime_and_get() usage
Message-ID: <YcU91+J9I9WJHEnA@gondor.apana.org.au>
References: <ed1ac2f8-5259-684d-42c8-effdf2920e78@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed1ac2f8-5259-684d-42c8-effdf2920e78@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 17, 2021 at 10:03:30AM +0100, Heiner Kallweit wrote:
> This fix is basically the same as 3d6b661330a7 ("crypto: stm32 -
> Revert broken pm_runtime_resume_and_get changes"), just for the omap
> driver. If the return value isn't used, then pm_runtime_get_sync()
> has to be used for ensuring that the usage count is balanced.
> 
> Fixes: 1f34cc4a8da3 ("crypto: omap-aes - Fix PM reference leak on omap-aes.c")
> Cc: stable@vger.kernel.org
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/crypto/omap-aes.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
