From: Robert Baronescu <robert.baronescu@nxp.com>
Subject: [PATCH 1/2] crypto: tcrypt - fix S/G table for test_aead_speed()
Date: Tue, 10 Oct 2017 13:21:59 +0300
Message-ID: <1507630920-9014-1-git-send-email-robert.baronescu@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <davem@davemloft.net>,
        Robert Baronescu <robert.baronescu@nxp.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0055.outbound.protection.outlook.com ([104.47.32.55]:39461
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751420AbdJJKWH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Oct 2017 06:22:07 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In case buffer length is a multiple of PAGE_SIZE,
the S/G table is incorrectly generated.
Fix this by handling buflen = k * PAGE_SIZE separately.

Signed-off-by: Robert Baronescu <robert.baronescu@nxp.com>
---
 crypto/tcrypt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 0022a18..bd9b66c 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -221,11 +221,13 @@ static void sg_init_aead(struct scatterlist *sg, char *xbuf[XBUFSIZE],
 	}
 
 	sg_init_table(sg, np + 1);
-	np--;
+	if (rem)
+		np--;
 	for (k = 0; k < np; k++)
 		sg_set_buf(&sg[k + 1], xbuf[k], PAGE_SIZE);
 
-	sg_set_buf(&sg[k + 1], xbuf[k], rem);
+	if (rem)
+		sg_set_buf(&sg[k + 1], xbuf[k], rem);
 }
 
 static void test_aead_speed(const char *algo, int enc, unsigned int secs,
-- 
1.9.3
