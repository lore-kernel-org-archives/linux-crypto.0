From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 6/8] crypto: qat - Convert to new AEAD interface
Date: Fri, 31 Jul 2015 13:39:59 -0700
Message-ID: <55BBDD1F.4020208@intel.com>
References: <20150730094138.GA15941@gondor.apana.org.au> <E1ZKkWe-0004C6-SN@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28754 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112AbbGaUkt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 31 Jul 2015 16:40:49 -0400
In-Reply-To: <E1ZKkWe-0004C6-SN@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07/30/2015 02:53 AM, Herbert Xu wrote:
> -}, {
> +	.init = qat_alg_aead_sha512_init,
> +	.exit = qat_alg_aead_exit,
> +	.setkey = qat_alg_aead_setkey,
> +	.decrypt = qat_alg_aead_dec,
> +	.encrypt = qat_alg_aead_enc,
> +	.ivsize = AES_BLOCK_SIZE,
> +	.maxauthsize = SHA512_DIGEST_SIZE,

Hi Herbert,
crypto_aead_encrypt() and crypto_aead_decrypt() work fine, but crypto_aead_givencrypt(),
which is still supported on the API causes a crash. Should we also disable all the
crypto_aead_giv* calls? I use it in my internal tests.

Other that that looks ok:
Tested-by: Tadeusz Struk <tadeusz.struk@intel.com>
