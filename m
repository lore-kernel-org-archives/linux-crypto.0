From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: xor - Fix warning when XOR_SELECT_TEMPLATE is unset
Date: Fri, 26 Aug 2016 23:19:39 +0800
Message-ID: <20160826151938.GA22619@gondor.apana.org.au>
References: <20160825113824.61ca7364@canb.auug.org.au>
 <20160825082010.5523ae6f@mschwide>
 <20160825074701.GA11175@gondor.apana.org.au>
 <20160825211411.08858397@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160825211411.08858397@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 25, 2016 at 09:14:11PM +1000, Stephen Rothwell wrote:
>
> That looks fine to me.  An alternative might be to have:
> 
> #ifndef XOR_SELECT_TEMPLATE
> #define XOR_SELECT_TEMPLATE(x)	(x)
> #endif
> 
> near the top of the file.  That gets the #ifdef out of the code flow
> and serves as some hint that such a thing can be defined by arch header
> files.

Good idea.  Thanks Stephen.

---8<---
This patch fixes an unused label warning triggered when the macro
XOR_SELECT_TEMPLATE is not set.

Fixes: 39457acda913 ("crypto: xor - skip speed test if the xor...")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Suggested-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/xor.c b/crypto/xor.c
index b8975d9..263af9f 100644
--- a/crypto/xor.c
+++ b/crypto/xor.c
@@ -24,6 +24,10 @@
 #include <linux/preempt.h>
 #include <asm/xor.h>
 
+#ifndef XOR_SELECT_TEMPLATE
+#define XOR_SELECT_TEMPLATE(x) (x)
+#endif
+
 /* The xor routines to use.  */
 static struct xor_block_template *active_template;
 
@@ -109,17 +113,14 @@ calibrate_xor_blocks(void)
 	void *b1, *b2;
 	struct xor_block_template *f, *fastest;
 
-	fastest = NULL;
+	fastest = XOR_SELECT_TEMPLATE(NULL);
 
-#ifdef XOR_SELECT_TEMPLATE
-	fastest = XOR_SELECT_TEMPLATE(fastest);
 	if (fastest) {
 		printk(KERN_INFO "xor: automatically using best "
 				 "checksumming function   %-10s\n",
 		       fastest->name);
 		goto out;
 	}
-#endif
 
 	/*
 	 * Note: Since the memory is not actually used for _anything_ but to
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
