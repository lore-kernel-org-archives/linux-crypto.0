From: kbuild test robot <fengguang.wu@intel.com>
Subject: [RFC PATCH] crypto: dpaa2_caam_iova_to_virt() can be static
Date: Tue, 11 Sep 2018 13:20:07 +0800
Message-ID: <20180911052007.GA10279@ivb42>
References: <20180910171550.5659-8-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Roy Pledge <roy.pledge@nxp.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180910171550.5659-8-horia.geanta@nxp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Fixes: 10c08052347f ("crypto: caam/qi2 - add DPAA2-CAAM driver")
Signed-off-by: kbuild test robot <fengguang.wu@intel.com>
---
 caamalg_qi2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index e883386..af8d890 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -80,8 +80,8 @@ struct caam_ctx {
 	unsigned int authsize;
 };
 
-void *dpaa2_caam_iova_to_virt(struct dpaa2_caam_priv *priv,
-			      dma_addr_t iova_addr)
+static void *dpaa2_caam_iova_to_virt(struct dpaa2_caam_priv *priv,
+				     dma_addr_t iova_addr)
 {
 	phys_addr_t phys_addr;
 
