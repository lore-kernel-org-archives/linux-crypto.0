From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: keywrap - Add missing ULL suffixes for 64-bit
 constants
Date: Wed, 29 Nov 2017 17:36:59 +1100
Message-ID: <20171129063659.GG21575@gondor.apana.org.au>
References: <1510742668-21121-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Stephan Mueller <smueller@chronox.de>,
        "David S . Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1510742668-21121-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 15, 2017 at 11:44:28AM +0100, Geert Uytterhoeven wrote:
> On 32-bit (e.g. with m68k-linux-gnu-gcc-4.1):
> 
>     crypto/keywrap.c: In function ‘crypto_kw_decrypt’:
>     crypto/keywrap.c:191: warning: integer constant is too large for ‘long’ type
>     crypto/keywrap.c: In function ‘crypto_kw_encrypt’:
>     crypto/keywrap.c:224: warning: integer constant is too large for ‘long’ type
> 
> Fixes: 9e49451d7a15365d ("crypto: keywrap - simplify code")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
