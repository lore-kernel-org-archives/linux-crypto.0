From: Ruchika Gupta <ruchika.gupta@freescale.com>
Subject: RE: [PATCH] crypto: caam - Dynamic memory allocation for
 caam_rng_ctx object
Date: Fri, 7 Mar 2014 06:27:58 +0000
Message-ID: <148f8cf54dab417b80508553c9fa1d28@BL2PR03MB466.namprd03.prod.outlook.com>
References: <1394188568-11884-1-git-send-email-NiteshNarayanLal@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "NiteshNarayanLal@freescale.com" <NiteshNarayanLal@freescale.com>
To: "NiteshNarayanLal@freescale.com" <NiteshNarayanLal@freescale.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"yashpal.dutta@freescale.com" <yashpal.dutta@freescale.com>,
	"herbert@gondor.apana.org" <herbert@gondor.apana.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:38423
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751003AbaCGG2A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Mar 2014 01:28:00 -0500
In-Reply-To: <1394188568-11884-1-git-send-email-NiteshNarayanLal@freescale.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Acked-by: Ruchika Gupta <ruchika.gupta@freescale.com>

> -----Original Message-----
> From: Nitesh Lal [mailto:NiteshNarayanLal@freescale.com]
> Sent: Friday, March 07, 2014 4:06 PM
> To: linux-crypto@vger.kernel.org; Gupta Ruchika-R66431; Dutta Yashpal-
> B05456; herbert@gondor.apana.org
> Cc: Lal Nitesh-B44382
> Subject: [PATCH] crypto: caam - Dynamic memory allocation for caam_rng_ctx
> object
> 
> This patch allocates memory from DMAable region to the caam_rng_ctx object,
> earlier it had been statically allocated which resulted in errorneous
> behaviour on inserting the caamrng module at the runtime.
> 
> Signed-off-by: Nitesh Lal <NiteshNarayanLal@freescale.com>
> ---
>  drivers/crypto/caam/caamrng.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
> index 28486b1..403d8d5 100644
> --- a/drivers/crypto/caam/caamrng.c
> +++ b/drivers/crypto/caam/caamrng.c
> @@ -76,7 +76,7 @@ struct caam_rng_ctx {
>  	struct buf_data bufs[2];
>  };
> 
> -static struct caam_rng_ctx rng_ctx;
> +static struct caam_rng_ctx *rng_ctx;
> 
>  static inline void rng_unmap_buf(struct device *jrdev, struct buf_data *bd)
> { @@ -137,7 +137,7 @@ static inline int submit_job(struct caam_rng_ctx *ctx,
> int to_current)
> 
>  static int caam_read(struct hwrng *rng, void *data, size_t max, bool wait)
> {
> -	struct caam_rng_ctx *ctx = &rng_ctx;
> +	struct caam_rng_ctx *ctx = rng_ctx;
>  	struct buf_data *bd = &ctx->bufs[ctx->current_buf];
>  	int next_buf_idx, copied_idx;
>  	int err;
> @@ -237,12 +237,12 @@ static void caam_cleanup(struct hwrng *rng)
>  	struct buf_data *bd;
> 
>  	for (i = 0; i < 2; i++) {
> -		bd = &rng_ctx.bufs[i];
> +		bd = &rng_ctx->bufs[i];
>  		if (atomic_read(&bd->empty) == BUF_PENDING)
>  			wait_for_completion(&bd->filled);
>  	}
> 
> -	rng_unmap_ctx(&rng_ctx);
> +	rng_unmap_ctx(rng_ctx);
>  }
> 
>  static void caam_init_buf(struct caam_rng_ctx *ctx, int buf_id) @@ -273,8
> +273,9 @@ static struct hwrng caam_rng = {
> 
>  static void __exit caam_rng_exit(void)
>  {
> -	caam_jr_free(rng_ctx.jrdev);
> +	caam_jr_free(rng_ctx->jrdev);
>  	hwrng_unregister(&caam_rng);
> +	kfree(rng_ctx);
>  }
> 
>  static int __init caam_rng_init(void)
> @@ -286,7 +287,9 @@ static int __init caam_rng_init(void)
>  		pr_err("Job Ring Device allocation for transform failed\n");
>  		return PTR_ERR(dev);
>  	}
> -
> +	rng_ctx = kmalloc(sizeof(struct caam_rng_ctx), GFP_DMA);
> +	if (!rng_ctx)
> +		return -ENOMEM;
>  	caam_init_rng(&rng_ctx, dev);
> 
>  	dev_info(dev, "registering rng-caam\n");
> --
> 1.8.1.4
> 
