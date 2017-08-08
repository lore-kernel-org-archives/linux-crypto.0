From: Gary R Hook <gary.hook@amd.com>
Subject: Re: crypto: ccp: use dma_mapping_error to check map error
Date: Tue, 8 Aug 2017 10:26:50 -0500
Message-ID: <d51e705d-bfc9-997b-957a-416da2d3782a@amd.com>
References: <1502199767-2578-1-git-send-email-bianpan2016@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Pan Bian <bianpan2016@163.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn3nam01on0080.outbound.protection.outlook.com ([104.47.33.80]:48960
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752030AbdHHP1l (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Aug 2017 11:27:41 -0400
In-Reply-To: <1502199767-2578-1-git-send-email-bianpan2016@163.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/08/2017 08:42 AM, Pan Bian wrote:
> The return value of dma_map_single() should be checked by
> dma_mapping_error(). However, in function ccp_init_dm_workarea(), its
> return value is checked against NULL, which could result in failures.
>
> Signed-off-by: Pan Bian <bianpan2016@163.com>

Acked-by: Gary R Hook <gary.hook@amd.com>

> ---
>  drivers/crypto/ccp/ccp-ops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
> index c0dfdac..ca83d19 100644
> --- a/drivers/crypto/ccp/ccp-ops.c
> +++ b/drivers/crypto/ccp/ccp-ops.c
> @@ -168,7 +168,7 @@ static int ccp_init_dm_workarea(struct ccp_dm_workarea *wa,
>
>  		wa->dma.address = dma_map_single(wa->dev, wa->address, len,
>  						 dir);
> -		if (!wa->dma.address)
> +		if (dma_mapping_error(wa->dev, wa->dma.address))
>  			return -ENOMEM;
>
>  		wa->dma.length = len;
>
