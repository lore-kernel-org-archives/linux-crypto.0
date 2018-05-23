From: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Subject: [PATCH v7 06/14] integrity: Introduce asymmetric_sig_has_known_key()
Date: Tue, 22 May 2018 21:12:45 -0300
Message-ID: <20180523001253.15247-7-bauerman@linux.ibm.com>
References: <20180523001253.15247-1-bauerman@linux.ibm.com>
Cc: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "AKASHI, Takahiro" <takahiro.akashi@linaro.org>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>
To: linux-integrity@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180523001253.15247-1-bauerman@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

IMA will only look for a modsig if the xattr sig references a key which is
not in the expected kernel keyring. To that end, introduce
asymmetric_sig_has_known_key().

The logic of extracting the key used in the xattr sig is factored out from
asymmetric_verify() so that it can be used by the new function.

Signed-off-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/digsig_asymmetric.c | 44 +++++++++++++++++++++++++---------
 security/integrity/integrity.h         |  8 +++++++
 2 files changed, 41 insertions(+), 11 deletions(-)

diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
index ab6a029062a1..241647970c19 100644
--- a/security/integrity/digsig_asymmetric.c
+++ b/security/integrity/digsig_asymmetric.c
@@ -79,26 +79,48 @@ static struct key *request_asymmetric_key(struct key *keyring, uint32_t keyid)
 	return key;
 }
 
-int asymmetric_verify(struct key *keyring, const char *sig,
-		      int siglen, const char *data, int datalen)
+static struct key *asymmetric_key_from_sig(struct key *keyring, const char *sig,
+					   int siglen)
 {
-	struct public_key_signature pks;
-	struct signature_v2_hdr *hdr = (struct signature_v2_hdr *)sig;
-	struct key *key;
-	int ret = -ENOMEM;
+	const struct signature_v2_hdr *hdr = (struct signature_v2_hdr *) sig;
 
 	if (siglen <= sizeof(*hdr))
-		return -EBADMSG;
+		return ERR_PTR(-EBADMSG);
 
 	siglen -= sizeof(*hdr);
 
 	if (siglen != be16_to_cpu(hdr->sig_size))
-		return -EBADMSG;
+		return ERR_PTR(-EBADMSG);
 
 	if (hdr->hash_algo >= HASH_ALGO__LAST)
-		return -ENOPKG;
+		return ERR_PTR(-ENOPKG);
+
+	return request_asymmetric_key(keyring, be32_to_cpu(hdr->keyid));
+}
+
+bool asymmetric_sig_has_known_key(struct key *keyring, const char *sig,
+				  int siglen)
+{
+	struct key *key;
+
+	key = asymmetric_key_from_sig(keyring, sig, siglen);
+	if (IS_ERR_OR_NULL(key))
+		return false;
+
+	key_put(key);
+
+	return true;
+}
+
+int asymmetric_verify(struct key *keyring, const char *sig,
+		      int siglen, const char *data, int datalen)
+{
+	struct public_key_signature pks;
+	struct signature_v2_hdr *hdr = (struct signature_v2_hdr *)sig;
+	struct key *key;
+	int ret = -ENOMEM;
 
-	key = request_asymmetric_key(keyring, be32_to_cpu(hdr->keyid));
+	key = asymmetric_key_from_sig(keyring, sig, siglen);
 	if (IS_ERR(key))
 		return PTR_ERR(key);
 
@@ -109,7 +131,7 @@ int asymmetric_verify(struct key *keyring, const char *sig,
 	pks.digest = (u8 *)data;
 	pks.digest_size = datalen;
 	pks.s = hdr->sig;
-	pks.s_size = siglen;
+	pks.s_size = siglen - sizeof(*hdr);
 	ret = verify_signature(key, &pks);
 	key_put(key);
 	pr_debug("%s() = %d\n", __func__, ret);
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index d4f676906442..7f80c3e44d51 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -181,12 +181,20 @@ static inline int integrity_init_keyring(const unsigned int id)
 #ifdef CONFIG_INTEGRITY_ASYMMETRIC_KEYS
 int asymmetric_verify(struct key *keyring, const char *sig,
 		      int siglen, const char *data, int datalen);
+bool asymmetric_sig_has_known_key(struct key *keyring, const char *sig,
+				  int siglen);
 #else
 static inline int asymmetric_verify(struct key *keyring, const char *sig,
 				    int siglen, const char *data, int datalen)
 {
 	return -EOPNOTSUPP;
 }
+
+static inline bool asymmetric_sig_has_known_key(struct key *keyring,
+						const char *sig, int siglen)
+{
+	return false;
+}
 #endif
 
 #ifdef CONFIG_IMA_LOAD_X509
