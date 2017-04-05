From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH] crypto: caam - fix RNG deinstantiation error checking
Date: Wed, 5 Apr 2017 11:41:03 +0300
Message-ID: <20170405084103.19053-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Alexandru Porosanu <alexandru.porosanu@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0062.outbound.protection.outlook.com ([104.47.38.62]:57103
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753993AbdDEIl2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Apr 2017 04:41:28 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

RNG instantiation was previously fixed by
commit 62743a4145bb9 ("crypto: caam - fix RNG init descriptor ret. code checking")
while deinstantiation was not addressed.

Since the descriptors used are similar, in the sense that they both end
with a JUMP HALT command, checking for errors should be similar too,
i.e. status code 7000_0000h should be considered successful.

Cc: <stable@vger.kernel.org> # 3.13+
Fixes: 1005bccd7a4a6 ("crypto: caam - enable instantiation of all RNG4 state handles")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/ctrl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index b3a94d5eff26..b7a36af5008d 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -285,7 +285,8 @@ static int deinstantiate_rng(struct device *ctrldev, int state_handle_mask)
 			/* Try to run it through DECO0 */
 			ret = run_descriptor_deco0(ctrldev, desc, &status);
 
-			if (ret || status) {
+			if (ret ||
+			    (status && status != JRSTA_SSRC_JUMP_HALT_CC)) {
 				dev_err(ctrldev,
 					"Failed to deinstantiate RNG4 SH%d\n",
 					sh_idx);
-- 
2.12.0.264.gd6db3f216544
