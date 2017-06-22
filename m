From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 6/7] staging: ccree: add DT bus coherency detection
Date: Thu, 22 Jun 2017 12:04:17 +0300
Message-ID: <20170622090417.ww5lgtjlhve5wd74@mwanda>
References: <1498115276-1601-1-git-send-email-gilad@benyossef.com>
 <1498115276-1601-7-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1498115276-1601-7-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

On Thu, Jun 22, 2017 at 10:07:52AM +0300, Gilad Ben-Yossef wrote:
> The ccree driver has build time configurable support
> to work on top of coherent (e.g. ACP) vs. none coherent bus
> connections. Turn it to run-time configurable option
> based on device tree.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> ---
>  drivers/staging/ccree/ssi_buffer_mgr.c | 37 ++++++++++++++++++----------------
>  drivers/staging/ccree/ssi_config.h     | 20 ------------------
>  drivers/staging/ccree/ssi_driver.c     | 14 +++++++++----
>  drivers/staging/ccree/ssi_driver.h     |  3 +++
>  4 files changed, 33 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
> index 88ebda8..75810dc 100644
> --- a/drivers/staging/ccree/ssi_buffer_mgr.c
> +++ b/drivers/staging/ccree/ssi_buffer_mgr.c
> @@ -627,6 +627,9 @@ void ssi_buffer_mgr_unmap_aead_request(
>  	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
>  	unsigned int hw_iv_size = areq_ctx->hw_iv_size;
>  	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
> +	struct ssi_drvdata *drvdata =
> +		(struct ssi_drvdata *)dev_get_drvdata(dev);

The cast is not needed.

> +

Don't put a blank in the middle of the declaration block.

>  	u32 dummy;
>  	bool chained;
>  	u32 size_to_unmap = 0;

[ snip ]

> @@ -981,20 +983,22 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
>  			 * MAC verification upon request completion
>  			 */
>  			if (direct == DRV_CRYPTO_DIRECTION_DECRYPT) {
> -#if !DX_HAS_ACP
> -				/* In ACP platform we already copying ICV
> -				 * for any INPLACE-DECRYPT operation, hence
> +				if (!drvdata->coherent) {
> +				/* In coherent platforms (e.g. ACP)
> +				 * already copying ICV for any
> +				 * INPLACE-DECRYPT operation, hence
>  				 * we must neglect this code.
>  				 */
> -				u32 size_to_skip = req->assoclen;
> -				if (areq_ctx->is_gcm4543) {
> -					size_to_skip += crypto_aead_ivsize(tfm);
> +					u32 skip = req->assoclen;
> +
> +					if (areq_ctx->is_gcm4543)
> +						skip += crypto_aead_ivsize(tfm);
> +
> +					ssi_buffer_mgr_copy_scatterlist_portion(
> +areq_ctx->backup_mac, req->src,
> +(skip + req->cryptlen - areq_ctx->req_authsize),
> +skip + req->cryptlen, SSI_SG_TO_BUF);


Indenting is messed up.

>  				}
> -				ssi_buffer_mgr_copy_scatterlist_portion(
> -					areq_ctx->backup_mac, req->src,
> -					size_to_skip+ req->cryptlen - areq_ctx->req_authsize,
> -					size_to_skip+ req->cryptlen, SSI_SG_TO_BUF);
> -#endif
>  				areq_ctx->icv_virt_addr = areq_ctx->backup_mac;
>  			} else {
>  				areq_ctx->icv_virt_addr = areq_ctx->mac_buf;

[ snip ]

> @@ -533,7 +539,7 @@ int cc_clk_on(struct ssi_drvdata *drvdata)
>  	struct clk *clk = drvdata->clk;
>  
>  	if (IS_ERR(clk))
> -	/* No all devices have a clock associated with CCREE */
> +	/* Not all devices have a clock associated with CCREE */

This is not related.  Do unrelated things in different patches.  This
typo was introduced in an earlier patch.  There are a couple ways in git
to edit previous patches.

>  		goto out;
>  
>  	rc = clk_prepare_enable(clk);

regards,
dan carpenter
