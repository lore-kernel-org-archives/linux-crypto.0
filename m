From: Gary R Hook <ghook@amd.com>
Subject: Re: [PATCH 1/2] crypto: ccp - Reduce stack frame size with KASAN
Date: Tue, 28 Mar 2017 09:15:45 -0500
Message-ID: <f04b2ede-f291-2ffa-d4a8-124d4af06199@amd.com>
References: <20170328095814.3734615-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0040.outbound.protection.outlook.com ([104.47.38.40]:54969
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754159AbdC1OQd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Mar 2017 10:16:33 -0400
In-Reply-To: <20170328095814.3734615-1-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 03/28/2017 04:58 AM, Arnd Bergmann wrote:> The newly added AES GCM 
implementation uses one of the largest stack frames
> in the kernel, around 1KB on normal 64-bit kernels, and 1.6KB when
> CONFIG_KASAN
> is enabled:
>
> drivers/crypto/ccp/ccp-ops.c: In function 'ccp_run_aes_gcm_cmd':
> drivers/crypto/ccp/ccp-ops.c:851:1: error: the frame size of 1632 bytes
> is larger than 1536 bytes [-Werror=frame-larger-than=]
>
> This is problematic for multiple reasons:
>
>  - The crypto functions are often used in deep call chains, e.g. behind
>    mm, fs and dm layers, making it more likely to run into an actual stack
>    overflow
>
>  - Using this much stack space is an indicator that the code is not
>    written to be as efficient as it could be.

I'm not sure I agree that A -> B, but I will certainly look into this.

>  - While this goes unnoticed at the moment in mainline with the frame size
>    warning being disabled when KASAN is in use, I would like to enable
>    the warning again, and the current code is slightly above my arbitrary
>    pick for a limit of 1536 bytes (I already did patches for every other
>    driver exceeding this).

I've got my stack frame size (also) set to 1536, and would have paid 
more attention
had a warning occurred due to my code.

> A more drastic refactoring of the driver might be needed to reduce the
> stack usage more substantially, but this patch is fairly simple and
> at least addresses the third one of the problems I mentioned, reducing the
> stack size by about 150 bytes and bringing it below the warning limit
> I picked.

Again, I'll devote some time to this.

> diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
> index 3a45c2af2fbd..c5ea0796a891 100644
> --- a/drivers/crypto/ccp/ccp-dev.h
> +++ b/drivers/crypto/ccp/ccp-dev.h
> @@ -432,24 +432,24 @@ struct ccp_dma_info {
>          unsigned int offset;
>          unsigned int length;
>          enum dma_data_direction dir;
> -};
> +} __packed __aligned(4);

My gcc 4.8 doesn't understand __aligned(). Shouldn't we use
#pragma(4) here?


>  struct ccp_dm_workarea {
>          struct device *dev;
>          struct dma_pool *dma_pool;
> -       unsigned int length;
>
>          u8 *address;
>          struct ccp_dma_info dma;
> +       unsigned int length;
>  };
>
>  struct ccp_sg_workarea {
>          struct scatterlist *sg;
>          int nents;
> +       unsigned int dma_count;
>
>          struct scatterlist *dma_sg;
>          struct device *dma_dev;
> -       unsigned int dma_count;
>          enum dma_data_direction dma_dir;
>
>          unsigned int sg_used;

I'm okay with rearranging, but I'm going to submit an alternative patch.
