From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH] crypto: x86/glue_helper make bool
Date: Thu, 21 Jul 2016 19:01:11 -0400
Message-ID: <20160721230111.GI21225@windriver.com>
References: <1469139180-26863-1-git-send-email-mcgrof@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>, <lkp@01.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:37507 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbcGUXBV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Jul 2016 19:01:21 -0400
Content-Disposition: inline
In-Reply-To: <1469139180-26863-1-git-send-email-mcgrof@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[[PATCH] crypto: x86/glue_helper make bool] On 21/07/2016 (Thu 15:13) Luis R. Rodriguez wrote:

> Paul's changes to remove MODULE_LICENSE() out of the x86 glue_helper
> causes a kernel with CONFIG_CRYPTO_GLUE_HELPER_X86=m to taint since
> it now detects the license is missing if you try to build the driver
> as a module, log below.

Reported and fixed two days ago ; the fix went out in yesterday's
linux-next via the tip tree.

https://lkml.kernel.org/r/20160719144243.GK21225@windriver.com

I fixed it by restoring the license, since making it bool might break
existing use cases, and my intent of this audit was to get rid of stuff
without altering runtime at all.

Thanks,
Paul.
--

> 
> Fix this by removing the module option for it via Kconfig as it
> cannot be a module.
> 
> glue_helper: module license 'unspecified' taints kernel.
> glue_helper: module license 'unspecified' taints kernel.
> Disabling lock debugging due to kernel taint
> glue_helper: Unknown symbol blkcipher_walk_done (err 0)
> glue_helper: Unknown symbol blkcipher_walk_virt (err 0)
> glue_helper: Unknown symbol kernel_fpu_end (err 0)
> glue_helper: Unknown symbol kernel_fpu_begin (err 0)
> glue_helper: Unknown symbol blkcipher_walk_virt_block (err 0)
> glue_helper: Unknown symbol blkcipher_walk_done (err 0)
> glue_helper: Unknown symbol blkcipher_walk_virt (err 0)
> glue_helper: Unknown symbol kernel_fpu_end (err 0)
> glue_helper: Unknown symbol kernel_fpu_begin (err 0)
> glue_helper: Unknown symbol blkcipher_walk_virt_block (err 0)
> glue_helper: Unknown symbol blkcipher_walk_done (err 0)
> glue_helper: Unknown symbol blkcipher_walk_virt (err 0)
> glue_helper: Unknown symbol kernel_fpu_end (err 0)
> glue_helper: Unknown symbol kernel_fpu_begin (err 0)
> glue_helper: Unknown symbol blkcipher_walk_virt_block (err 0)
> glue_helper: Unknown symbol blkcipher_walk_done (err 0)
> glue_helper: Unknown symbol blkcipher_walk_virt (err 0)
> glue_helper: Unknown symbol kernel_fpu_end (err 0)
> glue_helper: Unknown symbol kernel_fpu_begin (err 0)
> glue_helper: Unknown symbol blkcipher_walk_virt_block (err 0)
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> ---
>  crypto/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index a9377bef25e3..ed6abf4bbf3b 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -237,7 +237,7 @@ config CRYPTO_ABLK_HELPER
>  	select CRYPTO_CRYPTD
>  
>  config CRYPTO_GLUE_HELPER_X86
> -	tristate
> +	bool
>  	depends on X86
>  	select CRYPTO_ALGAPI
>  
> -- 
> 2.8.4
> 
