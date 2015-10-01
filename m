From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH  v3 2/2] crypto: akcipher - Changes to asymmetric key API
Date: Thu, 1 Oct 2015 21:45:36 +0800
Message-ID: <20151001134536.GA27555@gondor.apana.org.au>
References: <20150922163352.18101.85685.stgit@tstruk-mobl1>
 <20150922163403.18101.92452.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49707 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933013AbbJANpl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 Oct 2015 09:45:41 -0400
Content-Disposition: inline
In-Reply-To: <20150922163403.18101.92452.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 22, 2015 at 09:34:03AM -0700, Tadeusz Struk wrote:
>
>  struct akcipher_request {
>  	struct crypto_async_request base;
> -	void *src;
> -	void *dst;
> -	unsigned int src_len;
> -	unsigned int dst_len;
> +	struct scatterlist *src;
> +	struct scatterlist *dst;
> +	unsigned int out_len;

I think src_len/dst_len should be kept as the SG list may contain
more entries than the ones that you need to process.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
