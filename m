From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 1/3] crypto: scompress - don't sleep with preemption disabled
Date: Fri, 21 Jul 2017 16:42:36 +0100
Message-ID: <20170721154238.21697-2-ard.biesheuvel@linaro.org>
References: <20170721154238.21697-1-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        giovanni.cabiddu@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:35653 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751760AbdGUPm7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2017 11:42:59 -0400
Received: by mail-wm0-f41.google.com with SMTP id w126so15912767wme.0
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jul 2017 08:42:58 -0700 (PDT)
In-Reply-To: <20170721154238.21697-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Due to the use of per-CPU buffers, scomp_acomp_comp_decomp() executes
with preemption disabled, and so whether the CRYPTO_TFM_REQ_MAY_SLEEP
flag is set is irrelevant, since we cannot sleep anyway. So disregard
the flag, and use GFP_ATOMIC unconditionally.

Cc: <stable@vger.kernel.org> # v4.10+
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/scompress.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/crypto/scompress.c b/crypto/scompress.c
index ae1d3cf209e4..0b40d991d65f 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -211,9 +211,7 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 					      scratch_dst, &req->dlen, *ctx);
 	if (!ret) {
 		if (!req->dst) {
-			req->dst = crypto_scomp_sg_alloc(req->dlen,
-				   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
-				   GFP_KERNEL : GFP_ATOMIC);
+			req->dst = crypto_scomp_sg_alloc(req->dlen, GFP_ATOMIC);
 			if (!req->dst)
 				goto out;
 		}
-- 
2.11.0
