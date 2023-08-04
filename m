Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEE46C001DE
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Aug 2023 06:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbjHDGVz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Aug 2023 02:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232705AbjHDGVu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Aug 2023 02:21:50 -0400
Received: from out28-172.mail.aliyun.com (out28-172.mail.aliyun.com [115.124.28.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05604204;
        Thu,  3 Aug 2023 23:21:40 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1060332|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_alarm|0.0657725-0.000712165-0.933515;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047206;MF=wuyonggang001@208suo.com;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.U8E4.FK_1691130091;
Received: from localhost.localdomain(mailfrom:wuyonggang001@208suo.com fp:SMTPD_---.U8E4.FK_1691130091)
          by smtp.aliyun-inc.com;
          Fri, 04 Aug 2023 14:21:34 +0800
From:   Yonggang Wu <wuyonggang001@208suo.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yonggang Wu <wuyonggang001@208suo.com>
Subject: [PATCH] lib: crypto: Modify format error
Date:   Fri,  4 Aug 2023 14:21:07 +0800
Message-Id: <20230804062107.25913-1-wuyonggang001@208suo.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix the error(s):
space prohibited after that open square bracket '['

Signed-off-by: Yonggang Wu <wuyonggang001@208suo.com>
---
 lib/crypto/gf128mul.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/crypto/gf128mul.c b/lib/crypto/gf128mul.c
index 8f8c45e0cdcf..96ef5f312911 100644
--- a/lib/crypto/gf128mul.c
+++ b/lib/crypto/gf128mul.c
@@ -208,11 +208,11 @@ void gf128mul_lle(be128 *r, const be128 *b)
 	for (i = 0;;) {
 		u8 ch = ((u8 *)b)[15 - i];
 
-		be128_xor(r, r, &p[ 0 + !(ch & 0x80)]);
-		be128_xor(r, r, &p[ 2 + !(ch & 0x40)]);
-		be128_xor(r, r, &p[ 4 + !(ch & 0x20)]);
-		be128_xor(r, r, &p[ 6 + !(ch & 0x10)]);
-		be128_xor(r, r, &p[ 8 + !(ch & 0x08)]);
+		be128_xor(r, r, &p[0 + !(ch & 0x80)]);
+		be128_xor(r, r, &p[2 + !(ch & 0x40)]);
+		be128_xor(r, r, &p[4 + !(ch & 0x20)]);
+		be128_xor(r, r, &p[6 + !(ch & 0x10)]);
+		be128_xor(r, r, &p[8 + !(ch & 0x08)]);
 		be128_xor(r, r, &p[10 + !(ch & 0x04)]);
 		be128_xor(r, r, &p[12 + !(ch & 0x02)]);
 		be128_xor(r, r, &p[14 + !(ch & 0x01)]);
-- 
2.40.1

