From: Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH] crypto: arm/aes-ce: assign err return conditionally
Date: Wed,  8 Feb 2017 14:36:19 +0100
Message-ID: <1486560979-25240-1-git-send-email-der.herr@hofr.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 Nicholas Mc Guire <der.herr@hofr.at>, linux-crypto@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>
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

As the err value is not used unless there was an error it can be assigned
conditionally here. 

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---

Not sure if this is really relevant and worth changing, effectively it
is practically no change as gcc would move the err = PTR_ERR(simd); 
below unregister_simds: anyway (based on inspection of .lst/.s files)
- so it is more of an adjust C-level to object level for readability.

Patch was compile-tested with multi_v7_defconfig 
(implies CONFIG_CRYPTO_AES_ARM_CE=m) 

Patch is against 4.10-rc7 (localversion-next is next-20170208)

 arch/arm/crypto/aes-ce-glue.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
index 883b84d..8f65030 100644
--- a/arch/arm/crypto/aes-ce-glue.c
+++ b/arch/arm/crypto/aes-ce-glue.c
@@ -437,9 +437,10 @@ static int __init aes_init(void)
 		drvname = aes_algs[i].base.cra_driver_name + 2;
 		basename = aes_algs[i].base.cra_driver_name;
 		simd = simd_skcipher_create_compat(algname, drvname, basename);
-		err = PTR_ERR(simd);
-		if (IS_ERR(simd))
+		if (IS_ERR(simd)) {
+			err = PTR_ERR(simd);
 			goto unregister_simds;
+		}
 
 		aes_simd_algs[i] = simd;
 	}
-- 
2.1.4
