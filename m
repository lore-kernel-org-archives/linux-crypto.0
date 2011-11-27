From: Cong Wang <amwang@redhat.com>
Subject: [PATCH 12/62] crypto: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:26:52 +0800
Message-ID: <1322371662-26166-13-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 drivers/crypto/hifn_795x.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index fe765f4..76368f9 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -1731,9 +1731,9 @@ static int ablkcipher_get(void *saddr, unsigned int *srestp, unsigned int offset
 	while (size) {
 		copy = min3(srest, dst->length, size);
 
-		daddr = kmap_atomic(sg_page(dst), KM_IRQ0);
+		daddr = kmap_atomic(sg_page(dst));
 		memcpy(daddr + dst->offset + offset, saddr, copy);
-		kunmap_atomic(daddr, KM_IRQ0);
+		kunmap_atomic(daddr);
 
 		nbytes -= copy;
 		size -= copy;
@@ -1793,17 +1793,17 @@ static void hifn_process_ready(struct ablkcipher_request *req, int error)
 				continue;
 			}
 
-			saddr = kmap_atomic(sg_page(t), KM_SOFTIRQ0);
+			saddr = kmap_atomic(sg_page(t));
 
 			err = ablkcipher_get(saddr, &t->length, t->offset,
 					dst, nbytes, &nbytes);
 			if (err < 0) {
-				kunmap_atomic(saddr, KM_SOFTIRQ0);
+				kunmap_atomic(saddr);
 				break;
 			}
 
 			idx += err;
-			kunmap_atomic(saddr, KM_SOFTIRQ0);
+			kunmap_atomic(saddr);
 		}
 
 		hifn_cipher_walk_exit(&rctx->walk);
-- 
1.7.4.4
