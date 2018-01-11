From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH 3/7] crypto: ccree: add ablkcipher support
Date: Thu, 11 Jan 2018 11:01:37 +0100
Message-ID: <20180111100137.GA15690@Red>
References: <1515662239-1714-1-git-send-email-gilad@benyossef.com>
 <1515662239-1714-4-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:38080 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932394AbeAKKBm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jan 2018 05:01:42 -0500
Content-Disposition: inline
In-Reply-To: <1515662239-1714-4-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 11, 2018 at 09:17:10AM +0000, Gilad Ben-Yossef wrote:
> Add CryptoCell ablkcipher support
> 

Hello

I have some minor comments:

ablkcipher is deprecated, so you need to use skcipher instead.

> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> ---
>  drivers/crypto/ccree/Makefile        |    2 +-
>  drivers/crypto/ccree/cc_buffer_mgr.c |  125 ++++
>  drivers/crypto/ccree/cc_buffer_mgr.h |   10 +
>  drivers/crypto/ccree/cc_cipher.c     | 1167 ++++++++++++++++++++++++++++++++++
>  drivers/crypto/ccree/cc_cipher.h     |   74 +++
>  drivers/crypto/ccree/cc_driver.c     |   11 +
>  drivers/crypto/ccree/cc_driver.h     |    2 +
>  7 files changed, 1390 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/crypto/ccree/cc_cipher.c
>  create mode 100644 drivers/crypto/ccree/cc_cipher.h
> 
[...]
> +
> +struct tdes_keys {
> +	u8	key1[DES_KEY_SIZE];
> +	u8	key2[DES_KEY_SIZE];
> +	u8	key3[DES_KEY_SIZE];
> +};
> +
> +static const u8 zero_buff[] = {	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
> +				0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
> +				0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
> +				0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0};
> +

This constant is used nowhere.

> +/* The function verifies that tdes keys are not weak.*/
> +static int cc_verify_3des_keys(const u8 *key, unsigned int keylen)
> +{
> +	struct tdes_keys *tdes_key = (struct tdes_keys *)key;
> +
> +	/* verify key1 != key2 and key3 != key2*/
> +	if ((memcmp((u8 *)tdes_key->key1, (u8 *)tdes_key->key2,
> +		    sizeof(tdes_key->key1)) == 0) ||
> +	    (memcmp((u8 *)tdes_key->key3, (u8 *)tdes_key->key2,
> +		    sizeof(tdes_key->key3)) == 0)) {
> +		return -ENOEXEC;
> +	}
> +
> +	return 0;
> +}

All driver testing 3des key also use des_ekey()

[...]
> +static void cc_cipher_complete(struct device *dev, void *cc_req, int err)
> +{
> +	struct ablkcipher_request *areq = (struct ablkcipher_request *)cc_req;
> +	struct scatterlist *dst = areq->dst;
> +	struct scatterlist *src = areq->src;
> +	struct blkcipher_req_ctx *req_ctx = ablkcipher_request_ctx(areq);
> +	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
> +	unsigned int ivsize = crypto_ablkcipher_ivsize(tfm);
> +	struct ablkcipher_request *req = (struct ablkcipher_request *)areq;
> +
> +	cc_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
> +	kfree(req_ctx->iv);

kzfree for all stuff with IV/key

[...]
> +
> +#ifdef CRYPTO_TFM_REQ_HW_KEY
> +
> +static inline bool cc_is_hw_key(struct crypto_tfm *tfm)
> +{
> +	return (crypto_tfm_get_flags(tfm) & CRYPTO_TFM_REQ_HW_KEY);
> +}
> +
> +#else
> +
> +struct arm_hw_key_info {
> +	int hw_key1;
> +	int hw_key2;
> +};
> +
> +static inline bool cc_is_hw_key(struct crypto_tfm *tfm)
> +{
> +	return false;
> +}
> +
> +#endif /* CRYPTO_TFM_REQ_HW_KEY */

I see nowhere any use/documentation of CRYPTO_TFM_REQ_HW_KEY, so a cleaning could be done

Regards
