From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 2/3] crypto: kpp - Add DH software implementation
Date: Tue, 31 May 2016 14:52:56 +0800
Message-ID: <20160531065256.GB13948@gondor.apana.org.au>
References: <1462830041-7582-1-git-send-email-salvatore.benedetto@intel.com>
 <1462830041-7582-3-git-send-email-salvatore.benedetto@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48073 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbcEaGxD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 02:53:03 -0400
Content-Disposition: inline
In-Reply-To: <1462830041-7582-3-git-send-email-salvatore.benedetto@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 09, 2016 at 10:40:40PM +0100, Salvatore Benedetto wrote:
>
> +static int dh_set_params(struct crypto_kpp *tfm, void *buffer,
> +			 unsigned int len)
> +{
> +	struct dh_ctx *ctx = dh_get_ctx(tfm);
> +	struct dh_params *params = (struct dh_params *)buffer;
> +
> +	if (unlikely(!buffer || !len))
> +		return -EINVAL;

What's the point of len? It's never checked anywhere apart from
this non-zero check which is pointless.  Just get rid of it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
