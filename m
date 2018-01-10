From: Fabien DESSENNE <fabien.dessenne@st.com>
Subject: Re: [PATCH 6/6] crypto: stm32-cryp: convert to the new crypto engine
 API
Date: Wed, 10 Jan 2018 14:25:56 +0000
Message-ID: <ccffd847-3df7-d690-4102-5a10f6439f87@st.com>
References: <20180103201109.16077-1-clabbe.montjoie@gmail.com>
 <20180103201109.16077-7-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Benjamin GAIGNARD <benjamin.gaignard@st.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
To: Corentin Labbe <clabbe.montjoie@gmail.com>, Alexandre TORGUE
 <alexandre.torgue@st.com>, "arei.gonglei@huawei.com"
 <arei.gonglei@huawei.com>, "corbet@lwn.net" <corbet@lwn.net>,
 "davem@davemloft.net" <davem@davemloft.net>, "herbert@gondor.apana.org.au"
 <herbert@gondor.apana.org.au>, "jasowang@redhat.com" <jasowang@redhat.com>,
 "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>, "mst@redhat.com"
 <mst@redhat.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180103201109.16077-7-clabbe.montjoie@gmail.com>
Content-Language: en-US
Content-ID: <336B26E15A6D0B4A8A13F1D44097D5F2@st.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org



On 03/01/18 21:11, Corentin Labbe wrote:
> This patch convert the stm32-cryp driver to the new crypto engine API.
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> ---
>   drivers/crypto/stm32/stm32-cryp.c | 21 ++++++++++++++++-----
>   1 file changed, 16 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
> index cf1dddbeaa2c..99e0473ef247 100644
> --- a/drivers/crypto/stm32/stm32-cryp.c
> +++ b/drivers/crypto/stm32/stm32-cryp.c
> @@ -91,6 +91,7 @@
>   #define _walked_out             (cryp->out_walk.offset - cryp->out_sg->offset)
>   
>   struct stm32_cryp_ctx {
> +	struct crypto_engine_reqctx enginectx;
>   	struct stm32_cryp       *cryp;
>   	int                     keylen;
>   	u32                     key[AES_KEYSIZE_256 / sizeof(u32)];
> @@ -494,10 +495,20 @@ static int stm32_cryp_cpu_start(struct stm32_cryp *cryp)
>   	return 0;
>   }
>   
> +static int stm32_cryp_cipher_one_req(struct crypto_engine *engine,
> +				     void *areq);

Merge these 2 lines in a single one

> +static int stm32_cryp_prepare_cipher_req(struct crypto_engine *engine,
> +					 void *areq);
> +
>   static int stm32_cryp_cra_init(struct crypto_tfm *tfm)
>   {
> +	struct stm32_cryp_ctx *ctx = crypto_tfm_ctx(tfm);
> +
>   	tfm->crt_ablkcipher.reqsize = sizeof(struct stm32_cryp_reqctx);
>   
> +	ctx->enginectx.op.do_one_request = stm32_cryp_cipher_one_req;
> +	ctx->enginectx.op.prepare_request = stm32_cryp_prepare_cipher_req;
> +	ctx->enginectx.op.unprepare_request = NULL;
>   	return 0;
>   }
>   
> @@ -695,14 +706,17 @@ static int stm32_cryp_prepare_req(struct crypto_engine *engine,
>   }
>   
>   static int stm32_cryp_prepare_cipher_req(struct crypto_engine *engine,
> -					 struct ablkcipher_request *req)
> +					 void *areq)
>   {
> +	struct ablkcipher_request *req = container_of(areq, struct ablkcipher_request, base);

 > 80 characters (CHECKPATCH)

> +
>   	return stm32_cryp_prepare_req(engine, req);
>   }
>   
>   static int stm32_cryp_cipher_one_req(struct crypto_engine *engine,
> -				     struct ablkcipher_request *req)
> +				     void *areq)

Merge these 2 lines in a single one

>   {
> +	struct ablkcipher_request *req = container_of(areq, struct ablkcipher_request, base);

 > 80 characters (CHECKPATCH)

>   	struct stm32_cryp_ctx *ctx = crypto_ablkcipher_ctx(
>   			crypto_ablkcipher_reqtfm(req));
>   	struct stm32_cryp *cryp = ctx->cryp;
> @@ -1104,9 +1118,6 @@ static int stm32_cryp_probe(struct platform_device *pdev)
>   		goto err_engine1;
>   	}
>   
> -	cryp->engine->prepare_cipher_request = stm32_cryp_prepare_cipher_req;
> -	cryp->engine->cipher_one_request = stm32_cryp_cipher_one_req;
> -
>   	ret = crypto_engine_start(cryp->engine);
>   	if (ret) {
>   		dev_err(dev, "Could not start crypto engine\n");
