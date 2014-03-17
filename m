From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH cryptodev 3/4] crypto: testmgr - add aead null encryption test vectors
Date: Mon, 17 Mar 2014 19:27:31 +0100
Message-ID: <201403171927.31955.marex@denx.de>
References: <1394812012-13714-1-git-send-email-horia.geanta@freescale.com> <1394812012-13714-3-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Horia Geanta <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:43335 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbaCQSoC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Mar 2014 14:44:02 -0400
In-Reply-To: <1394812012-13714-3-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Friday, March 14, 2014 at 04:46:51 PM, Horia Geanta wrote:
> Add test vectors for aead with null encryption and md5,
> respectively sha1 authentication.
> Input data is taken from test vectors listed in RFC2410.
> 
> Signed-off-by: Horia Geanta <horia.geanta@freescale.com>

[...]

> --- a/crypto/testmgr.h
> +++ b/crypto/testmgr.h
> @@ -12821,6 +12821,10 @@ static struct cipher_testvec
> cast6_xts_dec_tv_template[] = { #define AES_DEC_TEST_VECTORS 4
>  #define AES_CBC_ENC_TEST_VECTORS 5
>  #define AES_CBC_DEC_TEST_VECTORS 5
> +#define HMAC_MD5_ECB_CIPHER_NULL_ENC_TEST_VECTORS 2
> +#define HMAC_MD5_ECB_CIPHER_NULL_DEC_TEST_VECTORS 2
> +#define HMAC_SHA1_ECB_CIPHER_NULL_ENC_TEST_VECTORS 2
> +#define HMAC_SHA1_ECB_CIPHER_NULL_DEC_TEST_VECTORS 2
>  #define HMAC_SHA1_AES_CBC_ENC_TEST_VECTORS 7
>  #define HMAC_SHA256_AES_CBC_ENC_TEST_VECTORS 7
>  #define HMAC_SHA512_AES_CBC_ENC_TEST_VECTORS 7
> @@ -13627,6 +13631,90 @@ static struct cipher_testvec
> aes_cbc_dec_tv_template[] = { },
>  };
> 
> +static struct aead_testvec hmac_md5_ecb_cipher_null_enc_tv_template[] = {
> +	{ /* Input data from RFC 2410 Case 1 */
> +#ifdef __LITTLE_ENDIAN
> +		.key    = "\x08\x00"		/* rta length */
> +			  "\x01\x00"		/* rta type */
> +#else
> +		.key    = "\x00\x08"		/* rta length */
> +			  "\x00\x01"		/* rta type */
> +#endif

This endianness thing looks a bit unhealthy. Is this really needed or is this a 
hack for some driver casting this field to u32 and then accessing it as such ?

> +			  "\x00\x00\x00\x00"	/* enc key length */
> +			  "\x00\x00\x00\x00\x00\x00\x00\x00"
> +			  "\x00\x00\x00\x00\x00\x00\x00\x00",
> +		.klen   = 8 + 16 + 0,
> +		.iv     = "",
> +		.input  = "\x01\x23\x45\x67\x89\xab\xcd\xef",
> +		.ilen   = 8,
> +		.result = "\x01\x23\x45\x67\x89\xab\xcd\xef"
> +			  "\xaa\x42\xfe\x43\x8d\xea\xa3\x5a"
> +			  "\xb9\x3d\x9f\xb1\xa3\x8e\x9b\xae",
> +		.rlen   = 8 + 16,

[...]

Best regards,
Marek Vasut
