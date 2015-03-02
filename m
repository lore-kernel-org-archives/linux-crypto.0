From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH 1/4] crypto: caam: fix some compile warnings
Date: Mon, 2 Mar 2015 13:08:51 +0200
Message-ID: <54F444C3.6020505@freescale.com>
References: <1425103234-31129-1-git-send-email-yanjiang.jin@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: <kim.phillips@freescale.com>, <ruchika.gupta@freescale.com>,
	<cristian.stoica@freescale.com>, <NiteshNarayanLal@freescale.com>,
	<jinyanjiang@gmail.com>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>
To: <yanjiang.jin@windriver.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425103234-31129-1-git-send-email-yanjiang.jin@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 2/28/2015 8:00 AM, yanjiang.jin@windriver.com wrote:
> From: Yanjiang Jin <yanjiang.jin@windriver.com>
> 
> This commit is to avoid the below warnings:
> 
> drivers/crypto/caam/sg_sw_sec4.h:88:12: warning:
> 'dma_map_sg_chained' defined but not used [-Wunused-function]
>  static int dma_map_sg_chained(struct device *dev, struct scatterlist *sg,
>             ^
> drivers/crypto/caam/sg_sw_sec4.h:104:12: warning:
> 'dma_unmap_sg_chained' defined but not used [-Wunused-function]
>  static int dma_unmap_sg_chained(struct device *dev,
>             ^
> 
> Signed-off-by: Yanjiang Jin <yanjiang.jin@windriver.com>

Reviewed-by: Horia Geanta <horia.geanta@freescale.com>

> ---
>  drivers/crypto/caam/sg_sw_sec4.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/caam/sg_sw_sec4.h b/drivers/crypto/caam/sg_sw_sec4.h
> index 3b91821..a6276eb 100644
> --- a/drivers/crypto/caam/sg_sw_sec4.h
> +++ b/drivers/crypto/caam/sg_sw_sec4.h
> @@ -85,7 +85,7 @@ static inline int sg_count(struct scatterlist *sg_list, int nbytes,
>  	return sg_nents;
>  }
>  
> -static int dma_map_sg_chained(struct device *dev, struct scatterlist *sg,
> +static inline int dma_map_sg_chained(struct device *dev, struct scatterlist *sg,
>  			      unsigned int nents, enum dma_data_direction dir,
>  			      bool chained)
>  {
> @@ -101,9 +101,9 @@ static int dma_map_sg_chained(struct device *dev, struct scatterlist *sg,
>  	return nents;
>  }
>  
> -static int dma_unmap_sg_chained(struct device *dev, struct scatterlist *sg,
> -				unsigned int nents, enum dma_data_direction dir,
> -				bool chained)
> +static inline int dma_unmap_sg_chained(struct device *dev,
> +				struct scatterlist *sg, unsigned int nents,
> +				enum dma_data_direction dir, bool chained)
>  {
>  	if (unlikely(chained)) {
>  		int i;
> 
