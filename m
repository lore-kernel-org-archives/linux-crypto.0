From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -next] crypto: api: Do not access module name directly
 from module structure
Date: Sat, 25 Apr 2015 06:38:03 +0800
Message-ID: <20150424223803.GB3690@gondor.apana.org.au>
References: <1429891083-525-1-git-send-email-linux@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Rusty Russell <rusty@rustcorp.com.au>
To: Guenter Roeck <linux@roeck-us.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1429891083-525-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Apr 24, 2015 at 08:58:03AM -0700, Guenter Roeck wrote:
> 'struct module' is only fully declared if CONFIG_MODULES is configured.
> If not, the build fails with
> 
> crypto/algapi.c: In function 'crypto_check_module_sig':
> crypto/algapi.c:49:12: error: dereferencing pointer to incomplete type
> 
> Fixes: 59afdc7b3214 ("crypto: api - Move module sig ifdef into accessor
> 	function")
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> Seen in next-20150424.

Thanks but a similar patch has already been queued.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
