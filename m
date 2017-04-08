From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: XTS Crypto Not Found In /proc/crypto Even After Compiled for
 4.10.1.
Date: Sat, 8 Apr 2017 10:02:46 +0800
Message-ID: <20170408020246.GA4815@gondor.apana.org.au>
References: <20170306173511.6w3e47v4vomu7yv4@kozik-lap>
 <CALaQ_hqhFjb60rJ2AgBnYgyNCPQ7fH5BdOOCeaMiankQR0VwqQ@mail.gmail.com>
 <20170308174542.2rydwxmrb3oehyrc@kozik-lap>
 <20170308211543.euqexxlhdgpfcdjk@kozik-lap>
 <CALaQ_hrikH8Q8ug9WTgnYR3UwSCip1DZtkkjj2NCLJVqcKQdZA@mail.gmail.com>
 <20170310180640.dnacw53vqrqji2xo@kozik-lap>
 <CALaQ_hqomXaZs0z-S3YX6d-hS_giqgBqBSvumwsMm=BzrgZz7Q@mail.gmail.com>
 <20170312191322.bbux5nrkqf5klznq@kozik-lap>
 <20170313170601.ozolfzgixqu6aa4g@kozik-lap>
 <20170406095414.GA31658@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nathan Royce <nroycea+kernel@gmail.com>, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170406095414.GA31658@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Apr 06, 2017 at 05:54:14PM +0800, Herbert Xu wrote:
> On Mon, Mar 13, 2017 at 07:06:01PM +0200, Krzysztof Kozlowski wrote:
> >
> > I bisected this to commit f1c131b45410 ("crypto: xts - Convert to
> > skcipher"). The s5p-sss driver stays the same... but the xts changes and
> > as a result we have a NULL pointer dereference (actually of value
> > 00000004):
> > [   18.930195] Unable to handle kernel NULL pointer dereference at virtual address 00000004
> > ...
> > [   18.972325] [<c0313c98>] (post_crypt) from [<c031408c>] (decrypt_done+0x4c/0x54)
> > [   18.972343] [<c031408c>] (decrypt_done) from [<c056309c>] (s5p_aes_interrupt+0x1bc/0x208)
> > [   18.972360] [<c056309c>] (s5p_aes_interrupt) from [<c0164930>] (irq_thread_fn+0x1c/0x54)
> > 
> > Any hints?
> 
> I haven't found any smoking guns, but the locking between the
> tasklet and the IRQ routine looks suspect.  First of all the
> tasklet is modifying the dev structure without holding any locks.

I think I see the problem.  Could you please try this patch and
let me know if it fixes the crash?

---8<---
Subject: crypto: xts - Fix use-after-free on EINPROGRESS

When we get an EINPROGRESS completion in xts, we will end up marking
the request as done and freeing it.  This then blows up when the
request is really completed as we've already freed the memory.

Fixes: f1c131b45410 ("crypto: xts - Convert to skcipher")
Cc: <stable@vger.kernel.org>
Reported-by: Nathan Royce <nroycea+kernel@gmail.com>
Reported-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/xts.c b/crypto/xts.c
index e197e64..d86c11a 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -286,6 +286,13 @@ static void encrypt_done(struct crypto_async_request *areq, int err)
 	struct rctx *rctx;
 
 	rctx = skcipher_request_ctx(req);
+
+	if (err == -EINPROGRESS) {
+		if (rctx->left != req->cryptlen)
+			return;
+		goto out;
+	}
+
 	subreq = &rctx->subreq;
 	subreq->base.flags &= CRYPTO_TFM_REQ_MAY_BACKLOG;
 
@@ -293,6 +300,7 @@ static void encrypt_done(struct crypto_async_request *areq, int err)
 	if (rctx->left)
 		return;
 
+out:
 	skcipher_request_complete(req, err);
 }
 
@@ -330,6 +338,13 @@ static void decrypt_done(struct crypto_async_request *areq, int err)
 	struct rctx *rctx;
 
 	rctx = skcipher_request_ctx(req);
+
+	if (err == -EINPROGRESS) {
+		if (rctx->left != req->cryptlen)
+			return;
+		goto out;
+	}
+
 	subreq = &rctx->subreq;
 	subreq->base.flags &= CRYPTO_TFM_REQ_MAY_BACKLOG;
 
@@ -337,6 +352,7 @@ static void decrypt_done(struct crypto_async_request *areq, int err)
 	if (rctx->left)
 		return;
 
+out:
 	skcipher_request_complete(req, err);
 }
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
