From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto : async implementation for sha1-mb
Date: Mon, 13 Jun 2016 16:22:02 +0800
Message-ID: <20160613082202.GA7148@gondor.apana.org.au>
References: <1465323282-2235-1-git-send-email-megha.dey@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	fenghua.yu@intel.com, Megha Dey <megha.dey@linux.intel.com>
To: Megha Dey <megha.dey@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38185 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964898AbcFMIWM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jun 2016 04:22:12 -0400
Content-Disposition: inline
In-Reply-To: <1465323282-2235-1-git-send-email-megha.dey@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 07, 2016 at 11:14:42AM -0700, Megha Dey wrote:
>
> -	desc->tfm = child;
> -	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
> +	ahash_request_set_tfm(desc, child);
> +	ahash_request_set_callback(desc, CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);

Why are the callbacks set to NULL/NULL? The child is async so you
should have a valid callback function here.

Instead of continuing to do the broken callback handling outside
of the API (i.e., rctx->complete) please use the API mechanism that
is provided for this purpose.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
