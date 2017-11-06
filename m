From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH v2 3/5] crypto: dh - Don't permit 'key' or 'g' size longer than 'p'
Date: Sun,  5 Nov 2017 18:30:46 -0800
Message-ID: <20171106023048.8067-4-ebiggers3@gmail.com>
References: <20171106023048.8067-1-ebiggers3@gmail.com>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Salvatore Benedetto <salvatore.benedetto@intel.com>,
        Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Stephan Mueller <smueller@chronox.de>, qat-linux@intel.com,
        keyrings@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        stable@vger.kernel.org
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171106023048.8067-1-ebiggers3@gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The "qat-dh" DH implementation assumes that 'key' and 'g' can be copied
into a buffer with size 'p_size'.  However it was never checked that
that was actually the case, which most likely allowed users to cause a
buffer underflow via KEYCTL_DH_COMPUTE.

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
2.15.0
