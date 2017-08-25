From: Christian Lamparter <chunkeey@googlemail.com>
Subject: [PATCH 05/12] crypto: crypto4xx: remove double assignment of pd_uinfo->state
Date: Fri, 25 Aug 2017 15:47:18 +0200
Message-ID: <c623cda688571bc483f0c9a9fb4c17cda0514cdd.1503668705.git.chunkeey@googlemail.com>
References: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:32979 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932435AbdHYNrb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Aug 2017 09:47:31 -0400
Received: by mail-wm0-f66.google.com with SMTP id e67so2671462wmd.0
        for <linux-crypto@vger.kernel.org>; Fri, 25 Aug 2017 06:47:30 -0700 (PDT)
In-Reply-To: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com>
In-Reply-To: <44b9527904d134982932cb807a3fa6f36093acbf.1503668705.git.chunkeey@googlemail.com>
References: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com> <85532949069735593f777489c6efcb6d1b08cdec.1503668705.git.chunkeey@googlemail.com> <7f51944084eef13bebe5f052557533bf6ade4ebc.1503668705.git.chunkeey@googlemail.com> <44b9527904d134982932cb807a3fa6f36093acbf.1503668705.git.chunkeey@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto4xx_put_pd_to_pdr() already clears the flag.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 249d35ff3806..9e96af725b31 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1079,7 +1079,6 @@ static void crypto4xx_bh_tasklet_cb(unsigned long data)
 			pd->pd_ctl.bf.pe_done = 0;
 			crypto4xx_pd_done(core_dev->dev, tail);
 			crypto4xx_put_pd_to_pdr(core_dev->dev, tail);
-			pd_uinfo->state = PD_ENTRY_FREE;
 		} else {
 			/* if tail not done, break */
 			break;
-- 
2.14.1
