Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9C95388
	for <linux-crypto@vger.kernel.org>; Fri, 29 Dec 2023 03:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rJ3ZV-00FGAS-3e; Fri, 29 Dec 2023 11:30:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 Dec 2023 11:30:16 +0800
Date: Fri, 29 Dec 2023 11:30:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: ovidiu.panait@windriver.com
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net, festevam@gmail.com
Subject: Re: [PATCH v2 00/14] crypto: sahara - bugfixes and small improvements
Message-ID: <ZY49SK6J3q9Aldc1@gondor.apana.org.au>
References: <20231224082144.3894863-1-ovidiu.panait@windriver.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231224082144.3894863-1-ovidiu.panait@windriver.com>

On Sun, Dec 24, 2023 at 10:21:30AM +0200, ovidiu.panait@windriver.com wrote:
> From: Ovidiu Panait <ovidiu.panait@windriver.com>
> 
> v2 updates:
> patch 14/14 - ("crypto: sahara - add support for crypto_engine"):
>   - added back missing SAHARA_VERSION_3 check in sahara_unregister_algs()
> 
> v1: https://lore.kernel.org/linux-crypto/20231223181108.3819741-1-ovidiu.panait@windriver.com/T/#t
> 
> Ovidiu Panait (14):
>   crypto: sahara - handle zero-length aes requests
>   crypto: sahara - fix ahash reqsize
>   crypto: sahara - fix wait_for_completion_timeout() error handling
>   crypto: sahara - improve error handling in sahara_sha_process()
>   crypto: sahara - fix processing hash requests with req->nbytes <
>     sg->length
>   crypto: sahara - do not resize req->src when doing hash operations
>   crypto: sahara - clean up macro indentation
>   crypto: sahara - use BIT() macro
>   crypto: sahara - use devm_clk_get_enabled()
>   crypto: sahara - use dev_err_probe()
>   crypto: sahara - remove 'active' flag from sahara_aes_reqctx struct
>   crypto: sahara - remove unnecessary NULL assignments
>   crypto: sahara - remove error message for bad aes request size
>   crypto: sahara - add support for crypto_engine
> 
>  drivers/crypto/Kconfig  |   1 +
>  drivers/crypto/sahara.c | 657 +++++++++++++++++-----------------------
>  2 files changed, 285 insertions(+), 373 deletions(-)
> 
> -- 
> 2.34.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
