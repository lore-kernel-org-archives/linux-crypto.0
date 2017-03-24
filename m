From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: zip - add a cast for printing atomic64_t values
Date: Fri, 24 Mar 2017 22:14:27 +0800
Message-ID: <20170324141427.GH14780@gondor.apana.org.au>
References: <20170320123955.4061033-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Mahipal Challa <mahipalreddy2006@gmail.com>,
        Jan Glauber <jglauber@cavium.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170320123955.4061033-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Mar 20, 2017 at 01:39:16PM +0100, Arnd Bergmann wrote:
> kernelci.org reports a build-time regression on linux-next, with a harmless
> warning in x86 allmodconfig:
> 
> drivers/crypto/cavium/zip/zip_main.c:489:18: warning: format '%ld' expects argument of type 'long int', but argument 7 has type 'long long int' [-Wformat=]
> drivers/crypto/cavium/zip/zip_main.c:489:18: warning: format '%ld' expects argument of type 'long int', but argument 6 has type 'long long int' [-Wformat=]
> drivers/crypto/cavium/zip/zip_main.c:489:18: warning: format '%ld' expects argument of type 'long int', but argument 5 has type 'long long int' [-Wformat=]
> 
> The return type for atomic64_read() unfortunately differs between
> architectures, with some defining it as atomic_long_read() and others
> returning a 64-bit type explicitly. Fixing this in general would be nice,
> but also require changing other users of these functions, so the simpler
> workaround is to add a cast here that avoids the warnings on the default
> build.
> 
> Fixes: 09ae5d37e093 ("crypto: zip - Add Compression/Decompression statistics")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
