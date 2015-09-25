From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v3 1/9] crypto: introduce decompression API that can be
 called via sharable tfm object
Date: Fri, 25 Sep 2015 14:25:31 +0900
Message-ID: <20150925052531.GA7158@js1304-P5Q-DELUXE>
References: <1442553564-3476-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1442553564-3476-2-git-send-email-iamjoonsoo.kim@lge.com>
 <20150922124346.GA11658@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150922124346.GA11658@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 22, 2015 at 08:43:46PM +0800, Herbert Xu wrote:
> On Fri, Sep 18, 2015 at 02:19:16PM +0900, Joonsoo Kim wrote:
> > Until now, tfm object embeds (de)compression context in it and
> > (de)compression in crypto API requires tfm object to use
> > this context. But, there are some algorithms that doesn't need
> > such context to operate. Therefore, this patch introduce new crypto
> > decompression API that calls decompression function via sharable tfm
> > object. Concurrent calls to decompress_noctx function through sharable
> > tfm object will be okay because caller don't need any context in tfm and
> > tfm is only used for fetching function pointer to decompress_noctx
> > function. This can reduce overhead of maintaining multiple tfm
> > if decompression doesn't require any context to operate.
> > 
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> Have you looked into include/crypto/compress.h?

Okay. Now, I have looked it.

> 
> The compress type itself is obsolete and should be replaced with
> the pcomp interface.
> 
> However, we made some mistakes with the pcomp interface.  First
> of all it doesn't have a non-partial interface like the digest
> function for crypto_shash.
> 
> But the biggest problem is that it should be completely stateless
> but is not.  IOW we should not store anything in the tfm that
> is per-request.  That should all go into the request structure.

I'm not a expert on this area but I have different opinion.
IIUC, what partial compression aims at is to support partial data
compression. It isn't for stateless compression and they are
different. Current implementation would work well for it's own
purpose.

And, making it stateless looks not good to me. If we make it
stateless, we should include algorithm's state in request object.
It enforces much memory to request object and, unlike crypto_shash
which can be allocated in stack, user needs to manage life time of
request objects and it requires additional complexity to
compression user.

Moreover, to use sharable tfm concurrently from my original intend,
many request objects would be needed and if it cannot be allocated
in the stack, it requires much memory. It's not suitable
for my purpose.

If compression is obsolete, what I think the best is leaving pcomp
as is and implementing sharable tfm in pcomp, And then, make lzo
and others support pcomp interface and sharable tfm.

Maybe, I'm wrong so please correct me.

Thanks.

> Fortunately it seems that pcomp doesn't actually have any users
> so we can just rip it out and start from scratch and redo it
> properly.
> 
> So to recap, please abandon any efforts on the crypto_compress
> interface as it is old and obsolete.  Instead reshape crypto_pcomp
> into a proper stateless interface which should then give you what
> you want.
> 
> When you do so, just keep in mind that we need to find a way to
> support IPComp.  That means the ability to allocate requests in
> thread context and then use them to compress/decompress in IRQ
> context.
> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
