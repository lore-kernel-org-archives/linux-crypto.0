From: Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH 02/28] crypto: omap-sham: Don't idle/start SHA device
 between Encrypt operations
Date: Wed, 1 Jun 2016 12:53:21 +0300
Message-ID: <574EB091.6040001@ti.com>
References: <1464771389-10640-1-git-send-email-t-kristo@ti.com>
 <1464771389-10640-3-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-arm-kernel@lists.infradead.org>, <lokeshvutla@ti.com>
To: Tero Kristo <t-kristo@ti.com>, <linux-omap@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <tony@atomide.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:52359 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbcFAJyL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 1 Jun 2016 05:54:11 -0400
In-Reply-To: <1464771389-10640-3-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/01/2016 11:56 AM, Tero Kristo wrote:
> From: Lokesh Vutla <lokeshvutla@ti.com>
>
> Calling runtime PM API for every block causes serious perf hit to
> crypto operations that are done on a long buffer.
> As crypto is performed on a page boundary, encrypting large buffers can
> cause a series of crypto operations divided by page. The runtime PM API
> is also called those many times.
>
> We call runtime_pm_get_sync only at beginning on the session (cra_init)
> and runtime_pm_put at the end. This result in upto a 50% speedup.
> This doesn't make the driver to keep the system awake as runtime get/put
> is only called during a crypto session which completes usually quickly.
>
> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
> Signed-off-by: Tero Kristo <t-kristo@ti.com>
> ---
>   drivers/crypto/omap-sham.c | 27 +++++++++++++++++----------
>   1 file changed, 17 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
> index 6eefaa2..bd0258f 100644
> --- a/drivers/crypto/omap-sham.c
> +++ b/drivers/crypto/omap-sham.c
> @@ -360,14 +360,6 @@ static void omap_sham_copy_ready_hash(struct ahash_request *req)
>
>   static int omap_sham_hw_init(struct omap_sham_dev *dd)
>   {
> -	int err;
> -
> -	err = pm_runtime_get_sync(dd->dev);
> -	if (err < 0) {
> -		dev_err(dd->dev, "failed to get sync: %d\n", err);
> -		return err;
> -	}
> -
>   	if (!test_bit(FLAGS_INIT, &dd->flags)) {
>   		set_bit(FLAGS_INIT, &dd->flags);
>   		dd->err = 0;
> @@ -999,8 +991,6 @@ static void omap_sham_finish_req(struct ahash_request *req, int err)
>   	dd->flags &= ~(BIT(FLAGS_BUSY) | BIT(FLAGS_FINAL) | BIT(FLAGS_CPU) |
>   			BIT(FLAGS_DMA_READY) | BIT(FLAGS_OUTPUT_READY));
>
> -	pm_runtime_put(dd->dev);
> -
>   	if (req->base.complete)
>   		req->base.complete(&req->base, err);
>
> @@ -1239,6 +1229,7 @@ static int omap_sham_cra_init_alg(struct crypto_tfm *tfm, const char *alg_base)
>   {
>   	struct omap_sham_ctx *tctx = crypto_tfm_ctx(tfm);
>   	const char *alg_name = crypto_tfm_alg_name(tfm);
> +	struct omap_sham_dev *dd;
>
>   	/* Allocate a fallback and abort if it failed. */
>   	tctx->fallback = crypto_alloc_shash(alg_name, 0,
> @@ -1266,6 +1257,13 @@ static int omap_sham_cra_init_alg(struct crypto_tfm *tfm, const char *alg_base)
>
>   	}
>
> +	spin_lock_bh(&sham.lock);
> +	list_for_each_entry(dd, &sham.dev_list, list) {
> +		break;
> +	}
> +	spin_unlock_bh(&sham.lock);
> +
> +	pm_runtime_get_sync(dd->dev);
>   	return 0;
>   }
>
> @@ -1307,6 +1305,7 @@ static int omap_sham_cra_sha512_init(struct crypto_tfm *tfm)
>   static void omap_sham_cra_exit(struct crypto_tfm *tfm)
>   {
>   	struct omap_sham_ctx *tctx = crypto_tfm_ctx(tfm);
> +	struct omap_sham_dev *dd;
>
>   	crypto_free_shash(tctx->fallback);
>   	tctx->fallback = NULL;
> @@ -1315,6 +1314,14 @@ static void omap_sham_cra_exit(struct crypto_tfm *tfm)
>   		struct omap_sham_hmac_ctx *bctx = tctx->base;
>   		crypto_free_shash(bctx->shash);
>   	}
> +
> +	spin_lock_bh(&sham.lock);
> +	list_for_each_entry(dd, &sham.dev_list, list) {
> +		break;
> +	}
> +	spin_unlock_bh(&sham.lock);
> +
> +	pm_runtime_get_sync(dd->dev);

May be put_?

>   }
>
>   static struct ahash_alg algs_sha1_md5[] = {
>


-- 
regards,
-grygorii
