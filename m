From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH] crypto: tcrypt: don't disable irqs and wait
Date: Tue, 25 Apr 2017 11:25:40 +0300
Message-ID: <1493108740-1642-1-git-send-email-gilad@benyossef.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        gilad.benyossef@arm.com, Ofir Drang <ofir.drang@arm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:37598 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1176026AbdDYIZt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Apr 2017 04:25:49 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The tcrypt AEAD cycles speed tests disables irqs during the test, which is
broken at the very least since commit
'1425d2d17f7309c6 ("crypto: tcrypt - Fix AEAD speed tests")'
adds a wait for completion as part of the test and probably since
switching to the new AEAD API.

While the result of taking a cycle count diff may not mean much on SMP
systems if the task migrates, it's good enough for tcrypt being the quick
& dirty dev tool it is. It's also what all the other (i.e. hash) cycle
speed tests do.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Reported-by: Ofir Drang <ofir.drang@arm.com>
---
 crypto/tcrypt.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 9a11f3c..0dd6a43 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -138,8 +138,6 @@ static int test_aead_cycles(struct aead_request *req, int enc, int blen)
 	int ret = 0;
 	int i;
 
-	local_irq_disable();
-
 	/* Warm-up run. */
 	for (i = 0; i < 4; i++) {
 		if (enc)
@@ -169,8 +167,6 @@ static int test_aead_cycles(struct aead_request *req, int enc, int blen)
 	}
 
 out:
-	local_irq_enable();
-
 	if (ret == 0)
 		printk("1 operation in %lu cycles (%d bytes)\n",
 		       (cycles + 4) / 8, blen);
-- 
2.1.4
