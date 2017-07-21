From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 2/3] crypto: scompress - free partially allocated scratch buffers on failure
Date: Fri, 21 Jul 2017 16:42:37 +0100
Message-ID: <20170721154238.21697-3-ard.biesheuvel@linaro.org>
References: <20170721154238.21697-1-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        giovanni.cabiddu@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:38683 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750802AbdGUPnB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2017 11:43:01 -0400
Received: by mail-wm0-f48.google.com with SMTP id w191so17403597wmw.1
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jul 2017 08:43:00 -0700 (PDT)
In-Reply-To: <20170721154238.21697-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When allocating the per-CPU scratch buffers, we allocate the source
and destination buffers separately, but bail immediately if the second
allocation fails, without freeing the first one. Fix that.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/scompress.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/crypto/scompress.c b/crypto/scompress.c
index 0b40d991d65f..2c07648305ad 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -125,8 +125,11 @@ static int crypto_scomp_alloc_all_scratches(void)
 		if (!scomp_src_scratches)
 			return -ENOMEM;
 		scomp_dst_scratches = crypto_scomp_alloc_scratches();
-		if (!scomp_dst_scratches)
+		if (!scomp_dst_scratches) {
+			crypto_scomp_free_scratches(scomp_src_scratches);
+			scomp_src_scratches = NULL;
 			return -ENOMEM;
+		}
 	}
 	return 0;
 }
-- 
2.11.0
