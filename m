From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] crypto: fix missing unlock on error in sun4i_hash()
Date: Thu, 18 Aug 2016 22:42:10 +0000
Message-ID: <1471560130-5265-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <weiyj.lk@gmail.com>, linux-crypto@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Maxime Ripard <maxime.ripard@free-electrons.com>,
 Chen-Yu Tsai <wens@csie.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Add the missing unlock before return from function sun4i_hash()
in the error handling case.

Fixes: 477d9b2e591b ("crypto: sun4i-ss - unify update/final function")
Signed-off-by: Wei Yongjun <weiyj.lk@gmail.com>
---
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
index 2ee3b59..de66f47 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
@@ -245,6 +245,7 @@ int sun4i_hash(struct ahash_request *areq)
 		if (end > areq->nbytes || areq->nbytes - end > 63) {
 			dev_err(ss->dev, "ERROR: Bound error %u %u\n",
 				end, areq->nbytes);
+			spin_unlock(&ss->slock);
 			return -EINVAL;
 		}
 	} else {
