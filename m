From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 6/8] KEYS: Allow the public_key struct to hold a private
 key [ver 3]
Date: Wed, 11 May 2016 15:22:38 +0100
Message-ID: <20160511142238.4743.42177.stgit@warthog.procyon.org.uk>
References: <20160511142152.4743.14414.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com,
	linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, dwmw2@infradead.org
To: mathew.j.martineau@linux.intel.com, tadeusz.struk@intel.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160511142152.4743.14414.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Put a flag in the public_key struct to indicate if the structure is holding
a private key.  The private key must be held ASN.1 encoded in the format
specified in RFC 3447 A.1.2.  This is the form required by crypto/rsa.c.

The software encryption subtype's verification and query functions then
need to select the appropriate crypto function to set the key.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/public_key.c |   14 ++++++++++++--
 include/crypto/public_key.h         |    1 +
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index e9967e5a2c25..92997d4e8173 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -113,7 +113,12 @@ static int software_key_query(const struct kernel_pkey_params *params,
 	if (IS_ERR(tfm))
 		return PTR_ERR(tfm);
 
-	ret = crypto_akcipher_set_pub_key(tfm, pkey->key, pkey->keylen);
+	if (pkey->key_is_private)
+		ret = crypto_akcipher_set_priv_key(tfm,
+						   pkey->key, pkey->keylen);
+	else
+		ret = crypto_akcipher_set_pub_key(tfm,
+						  pkey->key, pkey->keylen);
 	if (ret < 0)
 		goto error_free_tfm;
 
@@ -184,7 +189,12 @@ int public_key_verify_signature(const struct public_key *pkey,
 	if (!req)
 		goto error_free_tfm;
 
-	ret = crypto_akcipher_set_pub_key(tfm, pkey->key, pkey->keylen);
+	if (pkey->key_is_private)
+		ret = crypto_akcipher_set_priv_key(tfm,
+						   pkey->key, pkey->keylen);
+	else
+		ret = crypto_akcipher_set_pub_key(tfm,
+						  pkey->key, pkey->keylen);
 	if (ret)
 		goto error_free_req;
 
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index 1db6f1933dbd..a5096e72de5c 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -25,6 +25,7 @@
 struct public_key {
 	void *key;
 	u32 keylen;
+	bool key_is_private;
 	const char *id_type;
 	const char *pkey_algo;
 };
