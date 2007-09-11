From: Ingo Oeser <ioe-lkml@rameria.de>
Subject: [PATCH] crypto: cleanup: Use max() in blkcipher_get_spot() to state the intention.
Date: Tue, 11 Sep 2007 21:53:24 +0200
Message-ID: <200709112153.25959.ioe-lkml@rameria.de>
References: <5562608.649291189210157514.JavaMail.root@tahiti.vyatta.com> <200709102146.47655.ioe-lkml@rameria.de> <20070911084058.GA4469@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Bob Gilligan <gilligan@vyatta.com>, linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934047AbXIKTwx@vger.kernel.org>
In-Reply-To: <20070911084058.GA4469@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[PATCH] crypto: cleanup: Use max() in blkcipher_get_spot() to state the intention.

Signed-off-by: Ingo Oeser <ioe-lkml@rameria.de>
---
Hi Herbert,

here is the requested patch against Linus' latest tree. 
It at least compiles.

Best Regards

Ingo Oeser

 crypto/blkcipher.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index d8f8ec3..1c99d92 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -65,7 +65,7 @@ static inline void blkcipher_unmap_dst(struct blkcipher_walk *walk)
 static inline u8 *blkcipher_get_spot(u8 *start, unsigned int len)
 {
 	u8 *end_page = (u8 *)(((unsigned long)(start + len - 1)) & PAGE_MASK);
-	return start > end_page ? start : end_page;
+	return max(start, end_page);
 }
 
 static inline unsigned int blkcipher_done_slow(struct crypto_blkcipher *tfm,
-- 
1.5.2.5
