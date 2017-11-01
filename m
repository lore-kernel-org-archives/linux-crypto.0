From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 4/4] crypto: dh - don't permit 'key' or 'g' size longer than 'p'
Date: Wed,  1 Nov 2017 15:25:17 -0700
Message-ID: <20171101222517.41602-5-ebiggers3@gmail.com>
References: <20171101222517.41602-1-ebiggers3@gmail.com>
Cc: keyrings@vger.kernel.org,
        Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Salvatore Benedetto <salvatore.benedetto@intel.com>,
        Stephan Mueller <smueller@chronox.de>,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:43901 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933496AbdKAW2b (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Nov 2017 18:28:31 -0400
In-Reply-To: <20171101222517.41602-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

The "qat-dh" DH implementation assumes that 'key' and 'g' can be copied
into a buffer with size 'p_size'.  However it was never checked that
that was actually the case, which allowed users to cause a buffer
underflow via KEYCTL_DH_COMPUTE.

Fix this by updating crypto_dh_decode_key() to verify this precondition
for all DH implementations.

Fixes: c9839143ebbf ("crypto: qat - Add DH support")
Cc: <stable@vger.kernel.org> # v4.8+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/dh_helper.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/crypto/dh_helper.c b/crypto/dh_helper.c
index 708ae20d2d3c..7f00c771fe8d 100644
--- a/crypto/dh_helper.c
+++ b/crypto/dh_helper.c
@@ -83,6 +83,14 @@ int crypto_dh_decode_key(const char *buf, unsigned int len, struct dh *params)
 	if (secret.len != crypto_dh_key_len(params))
 		return -EINVAL;
 
+	/*
+	 * Don't permit the buffer for 'key' or 'g' to be larger than 'p', since
+	 * some drivers assume otherwise.
+	 */
+	if (params->key_size > params->p_size ||
+	    params->g_size > params->p_size)
+		return -EINVAL;
+
 	/* Don't allocate memory. Set pointers to data within
 	 * the given buffer
 	 */
-- 
2.15.0.403.gc27cc4dac6-goog
