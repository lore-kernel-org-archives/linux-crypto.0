Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C346DD4E
	for <linux-crypto@vger.kernel.org>; Thu, 23 Nov 2023 21:24:11 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r6Ofc-0031H5-Mv; Fri, 24 Nov 2023 13:24:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 24 Nov 2023 13:24:13 +0800
Date: Fri, 24 Nov 2023 13:24:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Cc: linux-crypto@vger.kernel.org, manjunath.hadli@vayavyalabs.com,
	shwetar <shwetar@vayavyalabs.com>,
	Ruud Derwig <Ruud.Derwig@synopsys.com>
Subject: Re: [PATCH 1/4] Add SPACC driver to Linux kernel
Message-ID: <ZWAzfaS6Rg8Tsf5A@gondor.apana.org.au>
References: <20231114050525.471854-1-pavitrakumarm@vayavyalabs.com>
 <20231114050525.471854-2-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231114050525.471854-2-pavitrakumarm@vayavyalabs.com>

On Tue, Nov 14, 2023 at 10:35:22AM +0530, Pavitrakumar M wrote:
>
> +	/* Below algorithms are not supported in crypto test manager */
> +	{ MODE_TAB_HASH("mac(kasumi)", MAC_KASUMI_F9, 4, 64), .sw_fb = false },

Please do not add algorithms where there are no generic implementations.

> +static int spacc_hash_import(struct ahash_request *req, const void *in)
> +{
> +	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
> +
> +	memcpy(ctx, in, sizeof(*ctx));
> +
> +	return 0;
> +}

The import/export functions are meant to serialise the hash state
so that they can be continued later.  Did you run the self-tests
with extra fuzz tests enabled?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
