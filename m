From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH  v3 4/4] crypto: rsa - limit supported key lengths
Date: Wed, 15 Jul 2015 15:28:43 -0700
Message-ID: <20150715222843.22719.41875.stgit@tstruk-mobl1>
References: <20150715222821.22719.34149.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	pingchao.yang@intel.com, davem@davemloft.net,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:64908 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbbGOWbL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2015 18:31:11 -0400
In-Reply-To: <20150715222821.22719.34149.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Introduce constrains for RSA keys lengths.
Only key lengths of 512, 1024, 1536, 2048, 3072, and 4096 bits
will be supported.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/rsa.c |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/crypto/rsa.c b/crypto/rsa.c
index 752af06..466003e 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -267,12 +267,36 @@ err_free_m:
 	return ret;
 }
 
+static int rsa_check_key_length(unsigned int len)
+{
+	switch (len) {
+	case 512:
+	case 1024:
+	case 1536:
+	case 2048:
+	case 3072:
+	case 4096:
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
 static int rsa_setkey(struct crypto_akcipher *tfm, const void *key,
 		      unsigned int keylen)
 {
 	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
+	int ret;
 
-	return rsa_parse_key(pkey, key, keylen);
+	ret = rsa_parse_key(pkey, key, keylen);
+	if (ret)
+		return ret;
+
+	if (rsa_check_key_length(mpi_get_size(pkey->n) << 3)) {
+		rsa_free_key(pkey);
+		ret = -EINVAL;
+	}
+	return ret;
 }
 
 static void rsa_exit_tfm(struct crypto_akcipher *tfm)
