From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH 3/4] crypto: caamhash: add two missed dma_mapping_error
Date: Mon, 2 Mar 2015 13:53:48 +0200
Message-ID: <54F44F4C.8050604@freescale.com>
References: <1425103234-31129-1-git-send-email-yanjiang.jin@windriver.com>
 <1425103234-31129-3-git-send-email-yanjiang.jin@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: <kim.phillips@freescale.com>, <ruchika.gupta@freescale.com>,
	<cristian.stoica@freescale.com>, <NiteshNarayanLal@freescale.com>,
	<jinyanjiang@gmail.com>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>
To: <yanjiang.jin@windriver.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0115.outbound.protection.outlook.com ([65.55.169.115]:14800
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751610AbbCBLyA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Mar 2015 06:54:00 -0500
In-Reply-To: <1425103234-31129-3-git-send-email-yanjiang.jin@windriver.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2/28/2015 8:00 AM, yanjiang.jin@windriver.com wrote:
> From: Yanjiang Jin <yanjiang.jin@windriver.com>
> 
> Add two missed dma_mapping_error() after dma_map_single().
> 
> Signed-off-by: Yanjiang Jin <yanjiang.jin@windriver.com>
> ---
>  drivers/crypto/caam/caamhash.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
> index f347ab7..f6ad322 100644
> --- a/drivers/crypto/caam/caamhash.c
> +++ b/drivers/crypto/caam/caamhash.c
> @@ -160,6 +160,10 @@ static inline dma_addr_t map_seq_out_ptr_result(u32 *desc, struct device *jrdev,
>  	dma_addr_t dst_dma;
>  
>  	dst_dma = dma_map_single(jrdev, result, digestsize, DMA_FROM_DEVICE);
> +	if (dma_mapping_error(jrdev, dst_dma)) {
> +		dev_err(jrdev, "unable to map dst dma\n");
> +		return -ENOMEM;
> +	}
>  	append_seq_out_ptr(desc, dst_dma, digestsize, 0);
>  
>  	return dst_dma;

Value returned by map_seq_out_ptr_result() - dst_dma - is always fed to
dma_mapping_error().
Note that using an invalid dst_dma in append_seq_out_ptr() doesn't break
anything, so it's ok to check dst_dma later.

> @@ -173,6 +177,10 @@ static inline dma_addr_t buf_map_to_sec4_sg(struct device *jrdev,
>  	dma_addr_t buf_dma;
>  
>  	buf_dma = dma_map_single(jrdev, buf, buflen, DMA_TO_DEVICE);
> +	if (dma_mapping_error(jrdev, buf_dma)) {
> +		dev_err(jrdev, "unable to map buf dma\n");
> +		return 0;
> +	}
>  	dma_to_sec4_sg_one(sec4_sg, buf_dma, buflen, 0);
>  
>  	return buf_dma;
> 

These functions are expected to return dma_addr_t, not an error code.
If dma_mapping_error() is needed within their scope, the return type
will have to change. And return value will need to be checked by their
callers.
