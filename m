From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Update for 4.1
Date: Thu, 16 Apr 2015 11:07:13 +0800
Message-ID: <20150416030713.GA11668@gondor.apana.org.au>
References: <20140804130339.GA1178@gondor.apana.org.au>
 <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150415033951.GA1406@gondor.apana.org.au>
 <CA+55aFyynQ75NfQy7Lp6t9Tp8+bp=LKG9Xw9q8KQqNoS+gGLmA@mail.gmail.com>
 <CA+55aFz8pr-J7K-EY5gjCV7ajJZC2tkFwjNG1xLXvQk0qAm2HA@mail.gmail.com>
 <CA+55aFwG1y6KSu-ZUMHXFnw69nRttS3LZW_pScvB6LCZjS02tA@mail.gmail.com>
 <20150416024252.GA11558@gondor.apana.org.au>
 <CA+55aFx+gm+=Xqr-wFN0Akg7=XJOtv3PDbHgVbo38p=DMv=3OQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56579 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbbDPDH0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Apr 2015 23:07:26 -0400
Content-Disposition: inline
In-Reply-To: <CA+55aFx+gm+=Xqr-wFN0Akg7=XJOtv3PDbHgVbo38p=DMv=3OQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 15, 2015 at 07:49:01PM -0700, Linus Torvalds wrote:
> On Wed, Apr 15, 2015 at 7:42 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > Is CONFIG_CRYPTO_MANAGER_DISABLE_TESTS set or unset in you .config?
> 
> # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
> 
> I'll send you the full .config in private (no need to spam the mailing
> list) in case you have any other questions about my setup.

Thanks! It actually appears to be a very simple bug that I somehow
missed during reviewing.

---8<---
The commit 9c521a200bc3c12bd724e48a75c57d5358f672be ("crypto:
api - remove instance when test failed") tried to grab a module
reference count before the module was even set.  Worse, it then
goes on to free the module reference count after it is set so
you quickly end up with a negative module reference count which
prevents people from using any instances belonging to that module.

This patch moves the module initialisation before the reference
count.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 2d0a1c6..d2627a3 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -525,12 +525,12 @@ int crypto_register_instance(struct crypto_template *tmpl,
 	if (err)
 		return err;
 
-	if (unlikely(!crypto_mod_get(&inst->alg)))
-		return -EAGAIN;
-
 	inst->alg.cra_module = tmpl->module;
 	inst->alg.cra_flags |= CRYPTO_ALG_INSTANCE;
 
+	if (unlikely(!crypto_mod_get(&inst->alg)))
+		return -EAGAIN;
+
 	down_write(&crypto_alg_sem);
 
 	larval = __crypto_register_alg(&inst->alg);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
