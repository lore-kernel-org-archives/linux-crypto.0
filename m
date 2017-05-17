From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH v2 10/11] crypto: KEYS: check err on akcipher maxsize
Date: Wed, 17 May 2017 18:00:37 +0300
Message-ID: <1495033238-26016-11-git-send-email-tudor.ambarus@microchip.com>
References: <1495033238-26016-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <keyrings@vger.kernel.org>,
        <Nicolas.Ferre@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:47493 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752633AbdEQPBX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 May 2017 11:01:23 -0400
In-Reply-To: <1495033238-26016-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto_akcipher_maxsize() returns minimum length for output buffer
or error code if key hasn't been set.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/asymmetric_keys/public_key.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index d3a989e..2b2f8bf 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -123,6 +123,11 @@ int public_key_verify_signature(const struct public_key *pkey,
 
 	ret = -ENOMEM;
 	outlen = crypto_akcipher_maxsize(tfm);
+	if (outlen < 0) {
+		ret = outlen;
+		goto error_free_req;
+	}
+
 	output = kmalloc(outlen, GFP_KERNEL);
 	if (!output)
 		goto error_free_req;
-- 
2.7.4
