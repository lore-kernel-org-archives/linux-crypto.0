From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [RFC PATCH 3/4] crypto: dh - allow user to provide NULL privkey
Date: Wed, 17 May 2017 13:38:35 +0300
Message-ID: <1495017516-10048-4-git-send-email-tudor.ambarus@microchip.com>
References: <1495017516-10048-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <smueller@chronox.de>,
        <marcel@holtmann.org>, <Nicolas.Ferre@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:9943 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752974AbdEQKjB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 May 2017 06:39:01 -0400
In-Reply-To: <1495017516-10048-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If the user provides a NULL private key, the kernel will
generate it and further use it for dh.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/dh.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/crypto/dh.c b/crypto/dh.c
index 87e3542..33df165 100644
--- a/crypto/dh.c
+++ b/crypto/dh.c
@@ -83,7 +83,9 @@ static int dh_set_secret(struct crypto_kpp *tfm, const void *buf,
 			 unsigned int len)
 {
 	struct dh_ctx *ctx = dh_get_ctx(tfm);
+	u8 *rndbuf = NULL;
 	struct dh params;
+	int maxsize;
 
 	if (crypto_dh_decode_key(buf, len, &params) < 0)
 		return -EINVAL;
@@ -91,12 +93,28 @@ static int dh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	if (dh_set_params(ctx, &params) < 0)
 		return -EINVAL;
 
+	if (!params.key || !params.key_size) {
+		maxsize = crypto_kpp_maxsize(tfm);
+		if (maxsize < 0)
+			return maxsize;
+
+		rndbuf = kmalloc(maxsize, GFP_KERNEL);
+		if (!rndbuf)
+			return -ENOMEM;
+
+		get_random_bytes(rndbuf, maxsize);
+		params.key = rndbuf;
+		params.key_size = maxsize;
+	}
+
 	ctx->xa = mpi_read_raw_data(params.key, params.key_size);
 	if (!ctx->xa) {
 		dh_clear_params(ctx);
+		kzfree(rndbuf);
 		return -EINVAL;
 	}
 
+	kzfree(rndbuf);
 	return 0;
 }
 
-- 
2.7.4
