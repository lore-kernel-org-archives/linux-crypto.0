From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 3/3] KEYS: dh - make some length variables unsigned
Date: Fri, 29 Sep 2017 12:21:06 +0300
Message-ID: <20170929092106.24276-3-tudor.ambarus@microchip.com>
References: <20170929092106.24276-1-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <keyrings@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:5212 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752011AbdI2JVN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Sep 2017 05:21:13 -0400
In-Reply-To: <20170929092106.24276-1-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Both crypto_kpp_maxsize() and crypto_dh_key_len() are returning
unsigned integers.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 security/keys/dh.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/keys/dh.c b/security/keys/dh.c
index d1ea9f3..89e9255 100644
--- a/security/keys/dh.c
+++ b/security/keys/dh.c
@@ -242,8 +242,8 @@ long __keyctl_dh_compute(struct keyctl_dh_params __user *params,
 {
 	long ret;
 	ssize_t dlen;
-	int secretlen;
-	int outlen;
+	unsigned int secretlen;
+	unsigned int outlen;
 	struct keyctl_dh_params pcopy;
 	struct dh dh_inputs;
 	struct scatterlist outsg;
-- 
2.9.4
