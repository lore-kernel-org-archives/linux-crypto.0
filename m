From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: sha3 - Add missing ULL suffixes for 64-bit
 constants
Date: Tue, 9 Aug 2016 00:06:28 +0800
Message-ID: <20160808160628.GA32116@gondor.apana.org.au>
References: <1470245823-21090-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Jeff Garzik <jeff@garzik.org>,
	Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1470245823-21090-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Aug 03, 2016 at 07:37:03PM +0200, Geert Uytterhoeven wrote:
> On 32-bit (e.g. with m68k-linux-gnu-gcc-4.1):
> 
>     crypto/sha3_generic.c:27: warning: integer constant is too large for ‘long’ type
>     crypto/sha3_generic.c:28: warning: integer constant is too large for ‘long’ type
>     crypto/sha3_generic.c:29: warning: integer constant is too large for ‘long’ type
>     crypto/sha3_generic.c:29: warning: integer constant is too large for ‘long’ type
>     crypto/sha3_generic.c:31: warning: integer constant is too large for ‘long’ type
>     crypto/sha3_generic.c:31: warning: integer constant is too large for ‘long’ type
>     crypto/sha3_generic.c:32: warning: integer constant is too large for ‘long’ type
>     crypto/sha3_generic.c:32: warning: integer constant is too large for ‘long’ type
>     crypto/sha3_generic.c:32: warning: integer constant is too large for ‘long’ type
>     crypto/sha3_generic.c:33: warning: integer constant is too large for ‘long’ type
>     crypto/sha3_generic.c:33: warning: integer constant is too large for ‘long’ type
>     crypto/sha3_generic.c:34: warning: integer constant is too large for ‘long’ type
>     crypto/sha3_generic.c:34: warning: integer constant is too large for ‘long’ type
> 
> Fixes: 53964b9ee63b7075 ("crypto: sha3 - Add SHA-3 hash algorithm")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
