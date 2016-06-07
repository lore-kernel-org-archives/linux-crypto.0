From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH V2 2/2] crypto : async implementation for sha1-mb
Date: Tue, 7 Jun 2016 18:35:15 +0800
Message-ID: <20160607103515.GB325@gondor.apana.org.au>
References: <1464922430-26976-1-git-send-email-megha.dey@intel.com>
 <1464922430-26976-3-git-send-email-megha.dey@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	fenghua.yu@intel.com, Megha Dey <megha.dey@linux.intel.com>
To: Megha Dey <megha.dey@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34646 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967AbcFGKfa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jun 2016 06:35:30 -0400
Content-Disposition: inline
In-Reply-To: <1464922430-26976-3-git-send-email-megha.dey@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 02, 2016 at 07:53:50PM -0700, Megha Dey wrote:
>
> +	struct ahash_alg *shash = crypto_ahash_alg(tfm);
>  
>  	/* alignment is to be done by multi-buffer crypto algorithm if needed */
>  
> -	return shash->finup(desc, NULL, 0, req->result);
> +	return shash->finup(desc);

You're still poking in the guts of the API.  Now that it's a real
ahash you don't need to do that.

Just do crypto_ahash_finup.  That way you don't need to export
crypto_ahsh_alg either.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
