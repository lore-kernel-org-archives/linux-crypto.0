Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFD12C433F5
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Mar 2022 01:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238343AbiCSB4w (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Mar 2022 21:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234358AbiCSB4v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Mar 2022 21:56:51 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92862DE7BA;
        Fri, 18 Mar 2022 18:55:30 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nVOJA-0002Jb-9d; Sat, 19 Mar 2022 12:55:09 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 19 Mar 2022 13:55:07 +1200
Date:   Sat, 19 Mar 2022 13:55:07 +1200
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Haowen Bai <baihaowen@meizu.com>
Cc:     mpm@selenic.com, sgoutham@marvell.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: cavium: fix possible NULL pointer dereference
Message-ID: <YjU3++JNa+XMt/0c@gondor.apana.org.au>
References: <1647573872-19278-1-git-send-email-baihaowen@meizu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1647573872-19278-1-git-send-email-baihaowen@meizu.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 18, 2022 at 11:24:32AM +0800, Haowen Bai wrote:
> pdev is NULL but dereference to pdev->dev
> 
> Signed-off-by: Haowen Bai <baihaowen@meizu.com>
> ---
>  drivers/char/hw_random/cavium-rng-vf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/hw_random/cavium-rng-vf.c b/drivers/char/hw_random/cavium-rng-vf.c
> index 6f66919..bffcb01 100644
> --- a/drivers/char/hw_random/cavium-rng-vf.c
> +++ b/drivers/char/hw_random/cavium-rng-vf.c
> @@ -179,7 +179,7 @@ static int cavium_map_pf_regs(struct cavium_rng *rng)
>  	pdev = pci_get_device(PCI_VENDOR_ID_CAVIUM,
>  			      PCI_DEVID_CAVIUM_RNG_PF, NULL);
>  	if (!pdev) {
> -		dev_err(&pdev->dev, "Cannot find RNG PF device\n");
> +		printk(KERN_ERR "Cannot find RNG PF device\n");

Please use pr_err.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
