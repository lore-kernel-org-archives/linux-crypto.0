Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF1C3C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 21:23:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B04C64FAA
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 21:23:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbhBDVXe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 16:23:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:47016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229511AbhBDVXe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 16:23:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7190264F3B;
        Thu,  4 Feb 2021 21:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612473773;
        bh=KfXtxzu5+PX7C4HoPKINDoo5M2h6bqEKLPdFWUm7IjI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A6fzy+8XKT9+wGGHXkFfw1aY9SBfBpux13spSS6li2ELxYZ8KjoPlmZhd9pldaiX2
         Vs6m17vPPJM8Q/tMKEiSJYkEFbVFJjhV8NeQkLqPuDX8h6SqmXb8EGbhx1WHAV++de
         pnDfyncGYzXWa3ydIWb7CzGz/fsMbp8eq/nK06k/dmYJJn6qixcf6YqE96hSne5pMp
         RZ+344vzvRbz+rElBxpapt2Nj9vq+V1s6oxs2c/X3pL52DANXnvi28gUCmmQoGkkkE
         vTHmdDnUk2ovxDxBYHHgv64UBRrynh4WQwBHPQybqluGxL60VsjyNGQdTGUWD8YDaT
         S5MTQg4mp+NAg==
Date:   Thu, 4 Feb 2021 14:22:50 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Suheil Chandran <schandran@marvell.com>,
        Lukasz Bartosik <lbartosik@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 1/2] crypto: octeontx2 - fix -Wpointer-bool-conversion
 warning
Message-ID: <20210204212250.GA385551@localhost>
References: <20210204154230.1702563-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204154230.1702563-1-arnd@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 04, 2021 at 04:42:15PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> When CONFIG_CPUMASK_OFFSTACK is disabled, clang reports a warning
> about a bogus condition:
> 
> drivers/crypto/marvell/octeontx2/otx2_cptlf.c:334:21: error: address of array 'lfs->lf[slot].affinity_mask' will always evaluate to 'true' [-Werror,-Wpointer-bool-conversion]
>                 if (lfs->lf[slot].affinity_mask)
>                 ~~  ~~~~~~~~~~~~~~^~~~~~~~~~~~~
> 
> In this configuration, the free_cpumask_var() function does nothing,
> so the condition could be skipped.
> 
> When the option is enabled, there is no warning, but the check
> is also redundant because free_cpumask_var() falls back to kfree(),
> which is documented as ignoring NULL pointers.
> 
> Remove the check to avoid the warning.
> 
> Fixes: 64506017030d ("crypto: octeontx2 - add LF framework")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
>  drivers/crypto/marvell/octeontx2/otx2_cptlf.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptlf.c b/drivers/crypto/marvell/octeontx2/otx2_cptlf.c
> index e27ea8909368..823a4571fd67 100644
> --- a/drivers/crypto/marvell/octeontx2/otx2_cptlf.c
> +++ b/drivers/crypto/marvell/octeontx2/otx2_cptlf.c
> @@ -331,8 +331,7 @@ void otx2_cptlf_free_irqs_affinity(struct otx2_cptlfs_info *lfs)
>  			irq_set_affinity_hint(pci_irq_vector(lfs->pdev,
>  					      lfs->lf[slot].msix_offset +
>  					      offs), NULL);
> -		if (lfs->lf[slot].affinity_mask)
> -			free_cpumask_var(lfs->lf[slot].affinity_mask);
> +		free_cpumask_var(lfs->lf[slot].affinity_mask);
>  	}
>  }
>  
> -- 
> 2.29.2
> 
