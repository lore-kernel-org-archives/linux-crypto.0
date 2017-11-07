From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 7/8] staging: ccree: remove compare to none zero
Date: Tue, 7 Nov 2017 13:52:39 +0300
Message-ID: <20171107105239.ifmkzkf5c2xjacx4@mwanda>
References: <1510047606-5589-1-git-send-email-gilad@benyossef.com>
 <1510047606-5589-8-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1510047606-5589-8-git-send-email-gilad@benyossef.com>
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

On Tue, Nov 07, 2017 at 09:40:03AM +0000, Gilad Ben-Yossef wrote:
> diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
> index f1a3976..e9d03ee 100644
> --- a/drivers/staging/ccree/ssi_aead.c
> +++ b/drivers/staging/ccree/ssi_aead.c
> @@ -240,7 +240,7 @@ static void ssi_aead_complete(struct device *dev, void *ssi_req, void __iomem *c
>  
>  	if (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) {
>  		if (memcmp(areq_ctx->mac_buf, areq_ctx->icv_virt_addr,
> -			   ctx->authsize) != 0) {
> +			   ctx->authsize)) {

Keep the != for *cmp functions.  It makes it way more readable.  The
idiom is:

	if (memcmp(a, b, size) != 0)  <-- this means a != b
	if (memcmp(a, b, size) < 0)   <-- this means a < b
	if (memcmp(a, b, size) == 0)  <-- this means a == b

>  			dev_dbg(dev, "Payload authentication failure, (auth-size=%d, cipher=%d)\n",
>  				ctx->authsize, ctx->cipher_mode);
>  			/* In case of payload authentication failure, MUST NOT
> @@ -458,7 +458,7 @@ ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key, unsigned int keyl
>  		hashmode = DRV_HASH_HW_SHA256;
>  	}
>  
> -	if (likely(keylen != 0)) {
> +	if (likely(keylen)) {

You can keep the zero here as well if you want.  keylen is a number and
zero is a number.  If you want to remove it that's fine too.

>  		key_dma_addr = dma_map_single(dev, (void *)key, keylen, DMA_TO_DEVICE);
>  		if (unlikely(dma_mapping_error(dev, key_dma_addr))) {
>  			dev_err(dev, "Mapping key va=0x%p len=%u for DMA failed\n",
> @@ -517,7 +517,7 @@ ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key, unsigned int keyl
>  				      keylen, NS_BIT, 0);
>  			idx++;
>  
> -			if ((blocksize - keylen) != 0) {
> +			if (blocksize - keylen) {

Same.  Numbers can be compared to zero and it's fine.

>  				hw_desc_init(&desc[idx]);
>  				set_din_const(&desc[idx], 0,
>  					      (blocksize - keylen));
> @@ -539,10 +539,10 @@ ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key, unsigned int keyl
>  	}
>  
>  	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 0);
> -	if (unlikely(rc != 0))
> +	if (unlikely(rc))

Where-as for these ones "rc" is not a number we can use for math so the
!= 0 is just a double negative and slightly confusing, so removing it
is the right thing.

regards,
dan carpenter
