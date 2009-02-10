From: Pekka J Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] Export symbol ksize()
Date: Tue, 10 Feb 2009 16:06:53 +0200 (EET)
Message-ID: <Pine.LNX.4.64.0902101605070.20991@melkki.cs.Helsinki.FI>
References: <1234272104-10211-1-git-send-email-kirill@shutemov.name>
 <84144f020902100535i4d626a9fj8cbb305120cf332a@mail.gmail.com>
 <20090210134651.GA5115@epbyminw8406h.minsk.epam.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Christoph Lameter <cl@linux-foundation.org>,
  Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
  linux-mm@kvack.org, linux-crypto@vger.kernel.org,
  Herbert Xu <herbert@gondor.apana.org.au>,
  Geert.Uytterhoeven@sonycom.com
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20090210134651.GA5115@epbyminw8406h.minsk.epam.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Feb 10, 2009 at 03:35:03PM +0200, Pekka Enberg wrote:
> > We unexported ksize() because it's a problematic interface and you
> > almost certainly want to use the alternatives (e.g. krealloc). I think
> > I need bit more convincing to apply this patch...
 
On Tue, 10 Feb 2009, Kirill A. Shutemov wrote:
> It just a quick fix. If anybody knows better solution, I have no
> objections.

Herbert, what do you think of this (untested) patch? Alternatively, we 
could do something like kfree_secure() but it seems overkill for this one 
call-site.

			Pekka

>From 7dddc378c19a6d203f147e503d5254df34eda6ae Mon Sep 17 00:00:00 2001
From: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Tue, 10 Feb 2009 16:01:27 +0200
Subject: [PATCH] crypto: api - don't use ksize()

The ksize() function is not exported to modules because it has non-standard
behavour across different slab allocators. While it is technically ok for this
particular call-site, we do not want the use of the API to spread so fix it up
by adding a ->size member to struct crypto_tfm and use that instead.

Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 crypto/api.c           |    6 +++---
 include/linux/crypto.h |    2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index efe77df..3526cc0 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -374,6 +374,7 @@ struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 		goto out_err;
 
 	tfm->__crt_alg = alg;
+	tfm->size = tfm_size;
 
 	err = crypto_init_ops(tfm, type, mask);
 	if (err)
@@ -471,6 +472,7 @@ struct crypto_tfm *crypto_create_tfm(struct crypto_alg *alg,
 
 	tfm = (struct crypto_tfm *)(mem + tfmsize);
 	tfm->__crt_alg = alg;
+	tfm->size = total;
 
 	err = frontend->init_tfm(tfm, frontend);
 	if (err)
@@ -569,19 +571,17 @@ EXPORT_SYMBOL_GPL(crypto_alloc_tfm);
 void crypto_destroy_tfm(void *mem, struct crypto_tfm *tfm)
 {
 	struct crypto_alg *alg;
-	int size;
 
 	if (unlikely(!mem))
 		return;
 
 	alg = tfm->__crt_alg;
-	size = ksize(mem);
 
 	if (!tfm->exit && alg->cra_exit)
 		alg->cra_exit(tfm);
 	crypto_exit_ops(tfm);
 	crypto_mod_put(alg);
-	memset(mem, 0, size);
+	memset(mem, 0, tfm->size);
 	kfree(mem);
 }
 EXPORT_SYMBOL_GPL(crypto_destroy_tfm);
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 1f2e902..4fd363a 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -487,6 +487,8 @@ struct crypto_tfm {
 	
 	struct crypto_alg *__crt_alg;
 
+	size_t size;
+
 	void *__crt_ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
-- 
1.5.4.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
