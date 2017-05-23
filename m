From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH v3 07/11] crypto: testmgr - check err on kpp maxsize
Date: Tue, 23 May 2017 16:19:01 +0300
Message-ID: <1495545545-16872-8-git-send-email-tudor.ambarus@microchip.com>
References: <1495545545-16872-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <keyrings@vger.kernel.org>,
        <Nicolas.Ferre@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:33438 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937115AbdEWNTz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 May 2017 09:19:55 -0400
In-Reply-To: <1495545545-16872-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto_kpp_maxsize() returns minimum length for output buffer
or error code if key hasn't been set. Check for error before
allocating memory.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/testmgr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 6f5f3ed..4f8029c 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2013,6 +2013,11 @@ static int do_test_kpp(struct crypto_kpp *tfm, const struct kpp_testvec *vec,
 		goto free_req;
 
 	out_len_max = crypto_kpp_maxsize(tfm);
+	if (out_len_max < 0) {
+		err = out_len_max;
+		goto free_req;
+	}
+
 	output_buf = kzalloc(out_len_max, GFP_KERNEL);
 	if (!output_buf) {
 		err = -ENOMEM;
-- 
2.7.4
