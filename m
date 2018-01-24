From: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Subject: [RESEND PATCH 6/6] crypto: caam: detect RNG init when TrustZone is active
Date: Wed, 24 Jan 2018 14:50:35 +0000
Message-ID: <1516805435-15034-7-git-send-email-pure.logic@nexus-software.ie>
References: <1516805435-15034-1-git-send-email-pure.logic@nexus-software.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: fabio.estevam@nxp.com, peng.fan@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        lukas.auer@aisec.fraunhofer.de, rui.silva@linaro.org,
        ryan.harkin@linaro.org,
        Bryan O'Donoghue <pure.logic@nexus-software.ie>
To: horia.geanta@nxp.com, aymen.sghaier@nxp.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1516805435-15034-1-git-send-email-pure.logic@nexus-software.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

When TrustZone is enabled on sec4 compatible silicon the first page of the
CAAM is reserved for TrustZone only, this means that access to the deco
registers is restricted and will return zero when read.

The solution to this problem is to initialize the RNG prior to TrustZone
being enabled or to initialize the RNG from a TrustZone context and
simultaneously to ensure that the job-ring registers have been assigned to
the correct non-TrustZone context.

Assigning of the job-ring registers is a task for u-boot or OPTEE/TrustZone
as is the initialization of the RNG. This patch adds logic to detect RNG
initialization if and only if TrustZone has been detected as active on the
CAAM block.

If TrustZone is initialized and the RNG looks to be setup - we mark the RNG
as good to go and continue to load, else we mark the RNG as bad and bail
out.

More detail on the original problem and the split fix between u-boot and
Linux is available in these two threads

Link: https://github.com/OP-TEE/optee_os/issues/1408
Link: https://tinyurl.com/yam5gv9a
Link: https://patchwork.ozlabs.org/cover/865042

Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Cc: "Horia Geantă" <horia.geanta@nxp.com>
Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
Cc: Fabio Estevam <fabio.estevam@nxp.com>
Cc: Peng Fan <peng.fan@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Lukas Auer <lukas.auer@aisec.fraunhofer.de>
---
 drivers/crypto/caam/ctrl.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 7fd3bfc..66a7c7e 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -711,6 +711,24 @@ static int caam_probe(struct platform_device *pdev)
 			int inst_handles =
 				rd_reg32(&ctrl->r4tst[0].rdsta) &
 								RDSTA_IFMASK;
+
+			/*
+			 * If TrustZone is active then u-boot or the TrustZone
+			 * firmware must have initialized the RNG for us else we
+			 * cannot do so from Linux.
+			 *
+			 * We've previously detected TrustZone so now let's
+			 * detect if the RNG has been initialized.
+			 */
+			if (ctrlpriv->trust_zone) {
+				ret = -ENODEV;
+				if (ctrlpriv->rng4_sh_init || inst_handles)
+					ret = 0;
+				dev_info(dev, "TrustZone active RNG looks %s\n",
+					 ret ? "uninitialized" : "initialized");
+				break;
+			}
+
 			/*
 			 * If either SH were instantiated by somebody else
 			 * (e.g. u-boot) then it is assumed that the entropy
-- 
2.7.4
