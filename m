From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 1/9] crypto: introduce decompression API that can be
 called via sharable tfm object
Date: Tue, 22 Sep 2015 20:43:46 +0800
Message-ID: <20150922124346.GA11658@gondor.apana.org.au>
References: <1442553564-3476-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1442553564-3476-2-git-send-email-iamjoonsoo.kim@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Joonsoo Kim <js1304@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1442553564-3476-2-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Sep 18, 2015 at 02:19:16PM +0900, Joonsoo Kim wrote:
> Until now, tfm object embeds (de)compression context in it and
> (de)compression in crypto API requires tfm object to use
> this context. But, there are some algorithms that doesn't need
> such context to operate. Therefore, this patch introduce new crypto
> decompression API that calls decompression function via sharable tfm
> object. Concurrent calls to decompress_noctx function through sharable
> tfm object will be okay because caller don't need any context in tfm and
> tfm is only used for fetching function pointer to decompress_noctx
> function. This can reduce overhead of maintaining multiple tfm
> if decompression doesn't require any context to operate.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Have you looked into include/crypto/compress.h?

The compress type itself is obsolete and should be replaced with
the pcomp interface.

However, we made some mistakes with the pcomp interface.  First
of all it doesn't have a non-partial interface like the digest
function for crypto_shash.

But the biggest problem is that it should be completely stateless
but is not.  IOW we should not store anything in the tfm that
is per-request.  That should all go into the request structure.

Fortunately it seems that pcomp doesn't actually have any users
so we can just rip it out and start from scratch and redo it
properly.

So to recap, please abandon any efforts on the crypto_compress
interface as it is old and obsolete.  Instead reshape crypto_pcomp
into a proper stateless interface which should then give you what
you want.

When you do so, just keep in mind that we need to find a way to
support IPComp.  That means the ability to allocate requests in
thread context and then use them to compress/decompress in IRQ
context.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
