From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH v2] crypto: add NULL check to scatterwalk_start
Date: Sat, 09 Sep 2017 00:20:50 +0200
Message-ID: <6172557.07oG34Eo4q@positron.chronox.de>
References: <4634467.01PS30tDXi@positron.chronox.de> <3142753.SSoe9WBuHN@positron.chronox.de> <20170907060108.GA21208@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
To: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34672 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757154AbdIHWUx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Sep 2017 18:20:53 -0400
In-Reply-To: <20170907060108.GA21208@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 7. September 2017, 08:01:08 CEST schrieb Herbert Xu:

Hi Herbert,

> On Thu, Sep 07, 2017 at 07:48:53AM +0200, Stephan Müller wrote:
> > There is already such check:
> > 
> > static inline int crypto_aead_decrypt(struct aead_request *req)
> > {
> > 
> >         struct crypto_aead *aead = crypto_aead_reqtfm(req);
> >         
> >         if (req->cryptlen < crypto_aead_authsize(aead))
> >         
> >                 return -EINVAL;
> > 
> > ...
> 
> That doesn't check assoclen, does it?
> 
> > > Perhaps we can simply
> > > truncate assoclen in aead_request_set_ad.
> > 
> > I am not sure that would work because at the time we set the AAD len, we
> > may not yet have cryptlen. I.e. aead_request_set_ad may be called before
> > aead_request_set_crypt.
> 
> We can add the truncation in both places.

The initially suggested fix was wrong in general: cryptlen only defines the length of the ciphertext/plaintext without the AAD. This means, cryptlen can surely be less than AAD.

The culprit is that in case authenc() is invoked from user space with AAD but with a zero plaintext. This in turn caused authenc() to invoke the CBC implementation with that zero plaintext which in turn simply starts a scatterwalk operation on the plaintext. This is in general appropriate as all code will handle zero lengths, except scatterwalk_start. This function assumes that there is always a valid SGL which is not true for for zero length input data.

Granted, we could fix authenc to simply not invoke the CBC operation in the outlined issue. However, I now stumbled over this function for a third time in a row over the last weeks in bugs triggerable via AF_ALG. I suspect that there are many more issues like this lingering in other cipher implementation. Hence, I feel it is prudent to fix an entire class of bugs with this patch.

Ciao
Stephan

---8<---

In edge conditions, scatterwalk_start is invoked with an empty SGL.
Although this is considered a wrong usage of scatterwalk_start, it can
still be invoked. Such invocation can occur if the data to be covered by
the SGL is zero. For example, if the authenc() cipher is invoked with an
empty plaintext, the CBC operation is invoked with an empty plaintext.

This patch fixes (at least) a crash that can be induced via AF_ALG from
unprivileged user space.

It can be argued whether authenc() should be changed to catch this
issue. Yet, this issue in scatterwalk_start was a culprit in other
kernel crash issues that have been fixed before invoking
scatterwalk_start. As this function is constantly being invoked via
AF_ALG from user space, harden the function to avoid a NULL pointer
deference is prudent and even a general fix for these common issues.
This fix therefore covers an entire class of bugs which are hard to
chase down in their own individual cipher implementations.

Fixes: ac02725812cb3 ("crypto: scatterwalk - Inline start/map/done")
CC: <stable@vger.kernel.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 include/crypto/scatterwalk.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 880e6be9e95e..0605d44b53bc 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -83,7 +83,10 @@ static inline void scatterwalk_start(struct scatter_walk *walk,
 				     struct scatterlist *sg)
 {
 	walk->sg = sg;
-	walk->offset = sg->offset;
+	if (sg)
+		walk->offset = sg->offset;
+	else
+		walk->offset = 0;
 }
 
 static inline void *scatterwalk_map(struct scatter_walk *walk)
-- 
2.13.5
