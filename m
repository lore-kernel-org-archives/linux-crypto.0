From: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Subject: [RESEND PATCH 2/6] crypto: caam: Fix endless loop when RNG is already initialized
Date: Wed, 24 Jan 2018 14:50:31 +0000
Message-ID: <1516805435-15034-3-git-send-email-pure.logic@nexus-software.ie>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:43387 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934072AbeAXOup (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Jan 2018 09:50:45 -0500
Received: by mail-wm0-f65.google.com with SMTP id g1so8951375wmg.2
        for <linux-crypto@vger.kernel.org>; Wed, 24 Jan 2018 06:50:45 -0800 (PST)
In-Reply-To: <1516805435-15034-1-git-send-email-pure.logic@nexus-software.ie>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

commit 1005bccd7a4a ("crypto: caam - enable instantiation of all RNG4 state
handles") introduces a control when incrementing ent_delay which contains
the following comment above it:

/*
 * If either SH were instantiated by somebody else
 * (e.g. u-boot) then it is assumed that the entropy
 * parameters are properly set and thus the function
 * setting these (kick_trng(...)) is skipped.
 * Also, if a handle was instantiated, do not change
 * the TRNG parameters.
 */

The problem is if u-boot has already instantiated the RNG and TEE/OPTEE is
running then instantiate_rng() will always return -EAGAIN and ent_delay
will never increment causing the loop to never break.

This patch fixes commit 1005bccd7a4a ("crypto: caam - enable instantiation
of all RNG4 state handles") by always incrementing ent_delay if and only if
both rng4_sh_init and inst_handles are non-zero for a given loop.

This should allow the current behavior to continue while allowing the loop
to break should (rng4_sh_init=1 && inst_handles 1) be true and
instantiate_rng() return -EAGAIN forever.

Fixes: 1005bccd7a4a ("crypto: caam - enable instantiation of all RNG4 state
handles")

Reported-by: Ryan Harkin <ryan.harkin@linaro.org>
Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Cc: "Horia Geantă" <horia.geanta@nxp.com>
Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
Cc: Fabio Estevam <fabio.estevam@nxp.com>
Cc: Peng Fan <peng.fan@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Lukas Auer <lukas.auer@aisec.fraunhofer.de>
---
 drivers/crypto/caam/ctrl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 98986d3..0a1e96b 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -704,7 +704,10 @@ static int caam_probe(struct platform_device *pdev)
 					 ent_delay);
 				kick_trng(pdev, ent_delay);
 				ent_delay += 400;
+			} else if (ctrlpriv->rng4_sh_init && inst_handles) {
+				ent_delay += 400;
 			}
+
 			/*
 			 * if instantiate_rng(...) fails, the loop will rerun
 			 * and the kick_trng(...) function will modfiy the
-- 
2.7.4
