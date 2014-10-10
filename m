From: "tudor.ambarus@freescale.com" <tudor.ambarus@freescale.com>
Subject: RE: [PATCH 1/2] crypto: caam - add support for gcm(aes)
Date: Fri, 10 Oct 2014 08:47:18 +0000
Message-ID: <95347feb4cb6441ea07456ce0b7610be@CY1PR0301MB0713.namprd03.prod.outlook.com>
References: <1412866450-22587-1-git-send-email-tudor.ambarus@freescale.com>
 <20141009194317.3e0f2a73a15c540cc901c9f5@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
To: Kim Phillips <Kim.Phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0117.outbound.protection.outlook.com ([157.56.110.117]:36380
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752269AbaJJIrW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Oct 2014 04:47:22 -0400
In-Reply-To: <20141009194317.3e0f2a73a15c540cc901c9f5@freescale.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On Thu, 9 Oct 2014 17:54:09 +0300
Tudor Ambarus <tudor.ambarus@freescale.com> wrote:

> +	/*
> +	 * Job Descriptor and Shared Descriptors
> +	 * must all fit into the 64-word Descriptor h/w Buffer
> +	 */
> +	if (DESC_GCM_DEC_LEN + DESC_JOB_IO_LEN +
> +	    ctx->enckeylen <= CAAM_DESC_BYTES_MAX)
> +		keys_fit_inline = true;

we need to reset the encrypt descriptor's keys_fit_inline setting to false before re-evaluating for decrypt.
[TA] Agreed. 

> +	/* Galois Counter Mode */
> +	{
> +		.name = "gcm(aes)",
> +		.driver_name = "gcm-aes-caam",
> +		.blocksize = 1,
> +		.type = CRYPTO_ALG_TYPE_AEAD,
> +		.template_aead = {
> +			.setkey = gcm_setkey,
> +			.setauthsize = gcm_setauthsize,
> +			.encrypt = aead_encrypt,
> +			.decrypt = aead_decrypt,
> +			.givencrypt = NULL,
> +			.geniv = "<built-in>",
> +			.ivsize = 12,
> +			.maxauthsize = 16,

AES_BLOCK_SIZE
[TA] I think we shall not change the blocksize value to AES_BLOCK_SIZE.
GCM uses a block cipher as a stream cipher. It generates encryption blocks, which are then XORed with the plaintext blocks to get the ciphertext. Just as with other stream ciphers, flipping a bit in the ciphertext produces a flipped bit in the plaintext at the same location.


Thanks,

Kim
