From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 1/2] crypto: caam - add support for gcm(aes)
Date: Thu, 9 Oct 2014 19:43:17 -0500
Message-ID: <20141009194317.3e0f2a73a15c540cc901c9f5@freescale.com>
References: <1412866450-22587-1-git-send-email-tudor.ambarus@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>
To: Tudor Ambarus <tudor.ambarus@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0133.outbound.protection.outlook.com ([157.56.111.133]:16464
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750918AbaJJAsc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Oct 2014 20:48:32 -0400
In-Reply-To: <1412866450-22587-1-git-send-email-tudor.ambarus@freescale.com>
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

we need to reset the encrypt descriptor's keys_fit_inline setting to
false before re-evaluating for decrypt.

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

Thanks,

Kim
