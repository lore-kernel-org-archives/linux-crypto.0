From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Subject: [RFC v1.1 4/5] ksign: provides keyring to search in for the key
Date: Thu, 11 Aug 2011 20:20:07 +0300
Message-ID: <4c951bf4dee72c54f2718ee0e1b15900106946da.1313082284.git.dmitry.kasatkin@intel.com>
References: <cover.1313082284.git.dmitry.kasatkin@intel.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	zohar@linux.vnet.ibm.com
To: linux-security-module@vger.kernel.org
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <cover.1313082284.git.dmitry.kasatkin@intel.com>
In-Reply-To: <cover.1313082284.git.dmitry.kasatkin@intel.com>
References: <cover.1313082284.git.dmitry.kasatkin@intel.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>

Allows to specify keyring to search in for the key. Later patches
will use special keyrings to store EVM and IMA public keys.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Acked-by: Mimi Zohar <zohar@us.ibm.com>
---
 crypto/ksign.c               |   17 ++++++++++++++---
 include/linux/crypto/ksign.h |    4 ++--
 security/integrity/evm/evm.h |    2 +-
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/crypto/ksign.c b/crypto/ksign.c
index 60ccfc9..ed355b7 100644
--- a/crypto/ksign.c
+++ b/crypto/ksign.c
@@ -183,7 +183,7 @@ err1:
 /*
  * Signature verification with public key
  */
-int ksign_verify(const char *sig, int siglen,
+int ksign_verify(struct key *keyring, const char *sig, int siglen,
 		       const char *digest, int digestlen)
 {
 	int err = -ENOMEM;
@@ -201,10 +201,21 @@ int ksign_verify(const char *sig, int siglen,
 
 	sprintf(name, "%llX", __be64_to_cpup((uint64_t *)sh->keyid));
 
-	key = request_key(&key_type_user, name, NULL);
+	if (keyring) {
+		/* search in specific keyring */
+		key_ref_t kref;
+		kref = keyring_search(make_key_ref(keyring, 1UL),
+						&key_type_user, name);
+		if (IS_ERR(kref))
+			key = ERR_PTR(PTR_ERR(kref));
+		else
+			key = key_ref_to_ptr(kref);
+	} else {
+		key = request_key(&key_type_user, name, NULL);
+	}
 	if (IS_ERR(key)) {
 		pr_err("key not found, id: %s\n", name);
-		return -ENOENT;
+		return PTR_ERR(key);
 	}
 
 	desc = kzalloc(sizeof(*desc) + crypto_shash_descsize(shash),
diff --git a/include/linux/crypto/ksign.h b/include/linux/crypto/ksign.h
index f1e47cb..ba23b2a 100644
--- a/include/linux/crypto/ksign.h
+++ b/include/linux/crypto/ksign.h
@@ -32,12 +32,12 @@ struct signature_hdr {
 
 #ifdef CONFIG_CRYPTO_KSIGN
 
-int ksign_verify(const char *sig, int siglen,
+int ksign_verify(struct key *keyring, const char *sig, int siglen,
 		 const char *digest, int digestlen);
 
 #else
 
-static inline int ksign_verify(const char *sig, int siglen,
+static inline int ksign_verify(struct key *keyring, const char *sig, int siglen,
 		 const char *digest, int digestlen)
 {
 	return -EOPNOTSUPP;
diff --git a/security/integrity/evm/evm.h b/security/integrity/evm/evm.h
index 6d297a1..9e1bcba 100644
--- a/security/integrity/evm/evm.h
+++ b/security/integrity/evm/evm.h
@@ -53,7 +53,7 @@ extern void evm_cleanup_secfs(void);
 static inline int evm_sign_verify(const char *sig, int siglen,
 		       const char *digest, int digestlen)
 {
-	return ksign_verify(sig, siglen, digest, digestlen);
+	return ksign_verify(NULL, sig, siglen, digest, digestlen);
 }
 
 #else
-- 
1.7.4.1

