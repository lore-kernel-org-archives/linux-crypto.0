From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH -next] crypto: mxs - Fix sparse non static symbol warning
Date: Thu, 9 Jan 2014 15:43:01 +0100
Message-ID: <201401091543.01821.marex@denx.de>
References: <CAPgLHd8_6_3CvqoSSPvynx3dVgqm_BiX=dLAt9WzNmdXNVC8Ng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, grant.likely@linaro.org,
	robh+dt@kernel.org, yongjun_wei@trendmicro.com.cn,
	linux-crypto@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:34941 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbaAIOvP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Jan 2014 09:51:15 -0500
In-Reply-To: <CAPgLHd8_6_3CvqoSSPvynx3dVgqm_BiX=dLAt9WzNmdXNVC8Ng@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday, January 08, 2014 at 02:48:56 PM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fixes the following sparse warning:
> 
> drivers/crypto/mxs-dcp.c:103:1: warning:
>  symbol 'global_mutex' was not declared. Should it be static?
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/crypto/mxs-dcp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
> index d41917c..a6db7fa 100644
> --- a/drivers/crypto/mxs-dcp.c
> +++ b/drivers/crypto/mxs-dcp.c
> @@ -100,7 +100,7 @@ struct dcp_sha_req_ctx {
>   * design of Linux Crypto API.
>   */
>  static struct dcp *global_sdcp;
> -DEFINE_MUTEX(global_mutex);
> +static DEFINE_MUTEX(global_mutex);
> 
>  /* DCP register layout. */
>  #define MXS_DCP_CTRL				0x00

Thank you.

Acked-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
