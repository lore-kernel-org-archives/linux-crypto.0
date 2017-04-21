From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: acomp - add support for deflate rfc1950
 (zlib)
Date: Fri, 21 Apr 2017 19:42:04 +0800
Message-ID: <20170421114204.GC14100@gondor.apana.org.au>
References: <20170419141142.3678-1-giovanni.cabiddu@intel.com>
 <20170419141142.3678-2-giovanni.cabiddu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, weigang.li@intel.com,
        giovanni.cabiddu@gmail.com
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [198.176.57.175] ([198.176.57.175]:42834 "EHLO
        deadmen.hmeau.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1038795AbdDULm3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Apr 2017 07:42:29 -0400
Content-Disposition: inline
In-Reply-To: <20170419141142.3678-2-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 19, 2017 at 03:11:42PM +0100, Giovanni Cabiddu wrote:
>
> +}, {
> +	.alloc_ctx		= zlib_deflate_alloc_ctx,
> +	.free_ctx		= deflate_free_ctx,
> +	.compress		= deflate_scompress,
> +	.decompress		= deflate_sdecompress,
> +	.base			= {
> +		.cra_name	= "zlib(deflate)",

Please avoid using parentheses as they are used for templates.
Perhaps zlib-deflate or deflate-rfc1950.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
