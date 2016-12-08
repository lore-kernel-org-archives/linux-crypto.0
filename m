From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: testmgr - fix overlap in chunked tests again
Date: Thu,  8 Dec 2016 08:23:52 +0000
Message-ID: <1481185432-24761-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: ebiggers@google.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:35452 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750729AbcLHIYB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Dec 2016 03:24:01 -0500
Received: by mail-wm0-f51.google.com with SMTP id a197so205463107wmd.0
        for <linux-crypto@vger.kernel.org>; Thu, 08 Dec 2016 00:24:00 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Commit 7e4c7f17cde2 ("crypto: testmgr - avoid overlap in chunked tests")
attempted to address a problem in the crypto testmgr code where chunked
test cases are copied to memory in a way that results in overlap.

However, the fix recreated the exact same issue for other chunked tests,
by putting IDX3 within 492 bytes of IDX1, which causes overlap if the
first chunk exceeds 492 bytes, which is the case for at least one of
the xts(aes) test cases.

So increase IDX3 by another 1000 bytes.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/testmgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 670893bcf361..157a415097f2 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -63,7 +63,7 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
  */
 #define IDX1		32
 #define IDX2		32400
-#define IDX3		511
+#define IDX3		1511
 #define IDX4		8193
 #define IDX5		22222
 #define IDX6		17101
-- 
2.7.4
