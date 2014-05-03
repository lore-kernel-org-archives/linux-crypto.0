From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] crypto: caam - Fix key inlining in AEAD shared
 descriptors
Date: Fri, 2 May 2014 19:10:08 -0500
Message-ID: <20140502191008.db1408c0735f14ed1a0bdb8b@freescale.com>
References: <1398612374-1746-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
	<horia.geanta@freescale.com>, <ruchika.gupta@freescale.com>,
	<alexandru.porosanu@freescale.com>
To: Vakul Garg <vakul@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:24509
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751901AbaECAPj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 2 May 2014 20:15:39 -0400
In-Reply-To: <1398612374-1746-1-git-send-email-vakul@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 27 Apr 2014 11:26:14 -0400
Vakul Garg <vakul@freescale.com> wrote:

> The variable 'keys_fit_inline' is initialised correctly to avoid using
> its stale value while creating shared descriptor for decryption and
> given-iv-encryption.

you mean givencrypt?  That's "generate an IV and encrypt".

> @@ -220,6 +220,8 @@ static int aead_null_set_sh_desc(struct crypto_aead *aead)
>  	if (DESC_AEAD_NULL_ENC_LEN + DESC_JOB_IO_LEN +
>  	    ctx->split_key_pad_len <= CAAM_DESC_BYTES_MAX)
>  		keys_fit_inline = true;
> +	else
> +		keys_fit_inline = false;

Can we do the easier to read:

	keys_fit_inline = false;
	if (DESC_AEAD_NULL_ENC_LEN + DESC_JOB_IO_LEN +
	    ctx->split_key_pad_len <= CAAM_DESC_BYTES_MAX)
		keys_fit_inline = true;

?

Thanks.

Kim
