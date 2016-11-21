From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: vmalloced stacks and scatterwalk_map_and_copy()
Date: Mon, 21 Nov 2016 16:26:19 +0800
Message-ID: <20161121082619.GA6462@gondor.apana.org.au>
References: <20161103181624.GA63852@google.com>
 <CALCETrUPuunBT1Zo25wyOwqaWJ=rm9R-WMZGN-7u4-dsdokAnQ@mail.gmail.com>
 <CALCETrXg5ytkLHBpKMJG7fBea+xy2wz6kSm2XK5c8K7_Hr9UuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers@google.com>, regressions@leemhuis.info,
        linux-crypto@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lutomirski <luto@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43599 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752682AbcKUI0l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Nov 2016 03:26:41 -0500
Content-Disposition: inline
In-Reply-To: <CALCETrXg5ytkLHBpKMJG7fBea+xy2wz6kSm2XK5c8K7_Hr9UuA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Nov 20, 2016 at 06:19:48PM -0800, Andy Lutomirski wrote:
>
> > Herbert, can you clarify this?  The check seems rather bizarre --
> > you're doing an incomplete check for aliasing and skipping the whole
> > copy if the beginning aliases.  In any event the stack *can't*
> > reasonably alias the scatterlist because a scatterlist can't safely
> > point to the stack.  Is there any code that actually relies on the
> > aliasing-detecting behavior?

Well at the time the IPsec stack would pass an IV that pointed
into the actual request, which is what prompted that patch.  The
IPsec code has since been changed to provide a separate IV so this
check is no longer necessary.

I will remove it with this patch.

---8<---
crypto: scatterwalk - Remove unnecessary aliasing check in map_and_copy

The aliasing check in map_and_copy is no longer necessary because
the IPsec ESP code no longer provides an IV that points into the
actual request data.  As this check is now triggering BUG checks
due to the vmalloced stack code, I'm removing it.

Reported-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 52ce17a..c16c94f8 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -68,10 +68,6 @@ void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
 
 	sg = scatterwalk_ffwd(tmp, sg, start);
 
-	if (sg_page(sg) == virt_to_page(buf) &&
-	    sg->offset == offset_in_page(buf))
-		return;
-
 	scatterwalk_start(&walk, sg);
 	scatterwalk_copychunks(buf, &walk, nbytes, out);
 	scatterwalk_done(&walk, out, 0);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
