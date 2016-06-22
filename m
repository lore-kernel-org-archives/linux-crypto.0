From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCHv2 06/27] crypto: ahash: increase the maximum allowed statesize
Date: Wed, 22 Jun 2016 16:23:39 +0300
Message-ID: <1466601840-18486-7-git-send-email-t-kristo@ti.com>
References: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-arm-kernel@lists.infradead.org
To: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
 <tony@atomide.com>, <herbert@gondor.apana.org.au>,
 <davem@davemloft.net>, <lokeshvutla@ti.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
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

The statesize is used to determine the maximum size for saved ahash
context. In some cases, this can be much larger than what is currently
allocated for it, for example omap-sham driver uses a buffer size of
PAGE_SIZE. Increase the statesize to accommodate this.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 crypto/ahash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 3887a98..375bbd7 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -536,7 +536,7 @@ static int ahash_prepare_alg(struct ahash_alg *alg)
 	struct crypto_alg *base = &alg->halg.base;
 
 	if (alg->halg.digestsize > PAGE_SIZE / 8 ||
-	    alg->halg.statesize > PAGE_SIZE / 8 ||
+	    alg->halg.statesize > PAGE_SIZE * 2 ||
 	    alg->halg.statesize == 0)
 		return -EINVAL;
 
-- 
1.9.1
