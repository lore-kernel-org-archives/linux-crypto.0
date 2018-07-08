From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/2] crypto: Fix -Wstringop-truncation warnings
Date: Mon, 9 Jul 2018 00:43:44 +0800
Message-ID: <20180708164344.3lpe6q7m2yjeqcdl@gondor.apana.org.au>
References: <20180625124538.21051-1-shorne@gmail.com>
 <20180625124538.21051-2-shorne@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, arnd@arndb.de,
        Eric Biggers <ebiggers3@gmail.com>,
        linux-crypto@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>,
        Nick Desaulniers <nick.desaulniers@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
To: Stafford Horne <shorne@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180625124538.21051-2-shorne@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jun 25, 2018 at 09:45:37PM +0900, Stafford Horne wrote:
> As of GCC 9.0.0 the build is reporting warnings like:
> 
>     crypto/ablkcipher.c: In function ‘crypto_ablkcipher_report’:
>     crypto/ablkcipher.c:374:2: warning: ‘strncpy’ specified bound 64 equals destination size [-Wstringop-truncation]
>       strncpy(rblkcipher.geniv, alg->cra_ablkcipher.geniv ?: "<default>",
>       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>        sizeof(rblkcipher.geniv));
>        ~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> This means the strnycpy might create a non null terminated string.  Fix this by
> explicitly performing '\0' termination.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Max Filippov <jcmvbkbc@gmail.com>
> Cc: Eric Biggers <ebiggers3@gmail.com>
> Cc: Nick Desaulniers <nick.desaulniers@gmail.com>
> Signed-off-by: Stafford Horne <shorne@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
