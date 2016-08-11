From: Gary R Hook <ghook@amd.com>
Subject: D'oh! (Re: robot build error)
Date: Thu, 11 Aug 2016 09:21:16 -0500
Message-ID: <c2f4e9c3-bd45-f70f-f9a9-6840fa14e3af@amd.com>
References: <4d2cb6f0-7e9a-89b7-d5c6-327aade39314@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0064.outbound.protection.outlook.com ([104.47.37.64]:44394
	"EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750708AbcHKOVY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Aug 2016 10:21:24 -0400
In-Reply-To: <4d2cb6f0-7e9a-89b7-d5c6-327aade39314@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Please ignore this patch.

> [PATCH] crypto: CCP - build error: label 'e_hwrng' undefined
>
> Gary R Hook Wed, 10 Aug 2016 12:27:28 -0700
>
> Fix goto target for when registration fails
>
> Reported-by: kbuild test robot <fengguang...@intel.com>
> Signed-off-by: Gary R Hook <gary.h...@amd.com>
> ---
>  drivers/crypto/ccp/ccp-dev-v5.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
>
> diff --git a/drivers/crypto/ccp/ccp-dev-v5.c
> b/drivers/crypto/ccp/ccp-dev-v5.c
> index 4086714..114675e 100644
> --- a/drivers/crypto/ccp/ccp-dev-v5.c
> +++ b/drivers/crypto/ccp/ccp-dev-v5.c
> @@ -835,7 +835,7 @@ static int ccp5_init(struct ccp_device *ccp)
>         /* Register the DMA engine support */
>         ret = ccp_dmaengine_register(ccp);
>         if (ret)
> -               goto e_hwrng;
> +               goto e_kthread;
>
>         return 0;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majord...@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
