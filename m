From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 1/6] crypto: testmgr - avoid overlap in chunked tests
Date: Sun,  4 Dec 2016 11:54:02 +0000
Message-ID: <1480852447-25082-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1480852447-25082-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:38657 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750867AbcLDLyS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Dec 2016 06:54:18 -0500
Received: by mail-wm0-f50.google.com with SMTP id f82so53682289wmf.1
        for <linux-crypto@vger.kernel.org>; Sun, 04 Dec 2016 03:54:17 -0800 (PST)
In-Reply-To: <1480852447-25082-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The IDXn offsets are chosen such that tap values (which may go up to
255) end up overlapping in the xbuf allocation. In particular, IDX1
and IDX3 are too close together, so update IDX3 to avoid this issue.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/testmgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index ded50b67c757..670893bcf361 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -63,7 +63,7 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
  */
 #define IDX1		32
 #define IDX2		32400
-#define IDX3		1
+#define IDX3		511
 #define IDX4		8193
 #define IDX5		22222
 #define IDX6		17101
-- 
2.7.4
