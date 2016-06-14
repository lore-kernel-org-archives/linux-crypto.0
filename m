From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4] crypto: rsa - return raw integers for the ASN.1 parser
Date: Tue, 14 Jun 2016 19:20:16 +0800
Message-ID: <20160614112016.GB20732@gondor.apana.org.au>
References: <1465827173-16916-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: smueller@chronox.de, linux-crypto@vger.kernel.org
To: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47365 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbcFNLUg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jun 2016 07:20:36 -0400
Content-Disposition: inline
In-Reply-To: <1465827173-16916-1-git-send-email-tudor-dan.ambarus@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 13, 2016 at 05:12:53PM +0300, Tudor Ambarus wrote:
> +
> +struct rsa_ctx {
> +	struct rsa_key key;

This isn't necessary and worse it may lead to bugs in future.
The raw keys will be invalid as soon as the setkey functions
return.

So just store it on the stack.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
