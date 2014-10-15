From: Tudor Ambarus <tudor.ambarus@freescale.com>
Subject: Re: [PATCH v2 2/2] crypto: caam - add support for rfc4106(gcm(aes))
Date: Wed, 15 Oct 2014 16:01:03 +0300
Message-ID: <543E700F.2090107@freescale.com>
References: <20141010094343.24d567d9bc110549fdd981cf@freescale.com>
 <1413278237-18945-1-git-send-email-tudor.ambarus@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"Phillips Kim-R1AAHA" <Kim.Phillips@freescale.com>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0101.outbound.protection.outlook.com ([207.46.100.101]:45645
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751106AbaJONBR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Oct 2014 09:01:17 -0400
In-Reply-To: <1413278237-18945-1-git-send-email-tudor.ambarus@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 10/14/2014 12:17 PM, Tudor Ambarus wrote:

> +static int rfc4106_setkey(struct crypto_aead *aead,
> +			  const u8 *key, unsigned int keylen)
> +{
> +	struct caam_ctx *ctx = crypto_aead_ctx(aead);
> +	struct device *jrdev = ctx->jrdev;
> +	int ret = 0;
> +
> +	/*
> +	 * The last four bytes of the key material are used as the salt value
> +	 * in the nonce. Update the AES key length.
> +	 */
> +	if (keylen < 4)
> +		return -EINVAL;
> +	keylen -= 4;

The salt will not be copied in the ctx->key, so the descriptors will use 
as a salt whatever resides in memory after (updated) keylen bytes.

I will submit a new patch set in which I will update the AES key length 
after copying the key material in ctx->key.

tcrypt tests passed because they use salt values of zero.
Back-to-back tests passed because I used caam with rfc4106 accelerated 
on both boards.

> +
> +#ifdef DEBUG
> +	print_hex_dump(KERN_ERR, "key in @"__stringify(__LINE__)": ",
> +		       DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
> +#endif
> +
> +	memcpy(ctx->key, key, keylen);
