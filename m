From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/4] crypto: testmgr - avoid overlap in chunked tests
Date: Thu, 24 Nov 2016 15:43:18 +0000
Message-ID: <1480002201-1427-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1480002201-1427-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: steve.capper@linaro.org, dingtianhong@huawei.com,
        yangshengkai@huawei.com, yuehaibing@huawei.com,
        hanjun.guo@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        will.deacon@arm.com, linux@arm.linux.org.uk
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36703 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966610AbcKXPo3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Nov 2016 10:44:29 -0500
Received: by mail-wm0-f48.google.com with SMTP id g23so118685553wme.1
        for <linux-crypto@vger.kernel.org>; Thu, 24 Nov 2016 07:44:29 -0800 (PST)
In-Reply-To: <1480002201-1427-1-git-send-email-ard.biesheuvel@linaro.org>
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
index 62dffa0028ac..15650597dcc9 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -62,7 +62,7 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
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
