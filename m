From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH v2 08/11] crypto: testmgr - check err on akcipher maxsize
Date: Wed, 17 May 2017 18:00:35 +0300
Message-ID: <1495033238-26016-9-git-send-email-tudor.ambarus@microchip.com>
References: <1495033238-26016-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <keyrings@vger.kernel.org>,
        <Nicolas.Ferre@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:8521 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753158AbdEQPBQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 May 2017 11:01:16 -0400
In-Reply-To: <1495033238-26016-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto_akcipher_maxsize() returns minimum length for output buffer
or error code if key hasn't been set.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/testmgr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 6f5f3ed..87a4abd 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2150,6 +2150,11 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
 
 	err = -ENOMEM;
 	out_len_max = crypto_akcipher_maxsize(tfm);
+	if (out_len_max < 0) {
+		err = out_len_max;
+		goto free_req;
+	}
+
 	outbuf_enc = kzalloc(out_len_max, GFP_KERNEL);
 	if (!outbuf_enc)
 		goto free_req;
-- 
2.7.4
