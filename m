From: Artem Savkov <artem.savkov@gmail.com>
Subject: [PATCH 1/2] sun4i_ss_prng: fix return value of sun4i_ss_prng_generate
Date: Tue,  6 Feb 2018 22:20:21 +0100
Message-ID: <20180206212022.1309-2-artem.savkov@gmail.com>
References: <20180206212022.1309-1-artem.savkov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, Artem Savkov <artem.savkov@gmail.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-arm-kernel@lists.infradead.org,
 linux-crypto@vger.kernel.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180206212022.1309-1-artem.savkov@gmail.com>
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

According to crypto/rng.h generate function should return 0 on success
and < 0 on error.

Fixes: b8ae5c7387ad ("crypto: sun4i-ss - support the Security System PRNG")
Signed-off-by: Artem Savkov <artem.savkov@gmail.com>
---
 drivers/crypto/sunxi-ss/sun4i-ss-prng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-prng.c b/drivers/crypto/sunxi-ss/sun4i-ss-prng.c
index 0d01d1624252..5754e0b92fb0 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-prng.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-prng.c
@@ -52,5 +52,5 @@ int sun4i_ss_prng_generate(struct crypto_rng *tfm, const u8 *src,
 
 	writel(0, ss->base + SS_CTL);
 	spin_unlock(&ss->slock);
-	return dlen;
+	return 0;
 }
-- 
2.15.1
