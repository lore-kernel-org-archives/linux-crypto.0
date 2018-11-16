Return-Path: <SRS0=1iZj=N3=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46362 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729486AbeKQGWi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Nov 2018 01:22:38 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wAGK4DmN102563
        for <linux-crypto@vger.kernel.org>; Fri, 16 Nov 2018 15:08:49 -0500
Received: from e12.ny.us.ibm.com (e12.ny.us.ibm.com [129.33.205.202])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2nt4970xr9-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Fri, 16 Nov 2018 15:08:49 -0500
Received: from localhost
        by e12.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <bauerman@linux.ibm.com>;
        Fri, 16 Nov 2018 20:08:48 -0000
From: Thiago Jung Bauermann <bauerman@linux.ibm.com>
To: linux-integrity@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        "AKASHI, Takahiro" <takahiro.akashi@linaro.org>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH v8 06/14] integrity: Introduce asymmetric_sig_has_known_key()
Date: Fri, 16 Nov 2018 18:07:04 -0200
In-Reply-To: <20181116200712.14154-1-bauerman@linux.ibm.com>
References: <20181116200712.14154-1-bauerman@linux.ibm.com>
Message-Id: <20181116200712.14154-7-bauerman@linux.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

IMA will only look for a modsig if the xattr sig references a key which is
not in the expected kernel keyring. To that end, introduce
asymmetric_sig_has_known_key().

The logic of extracting the key used in the xattr sig is factored out from
asymmetric_verify() so that it can be used by the new function.

Signed-off-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/digsig_asymmetric.c | 44 +++++++++++++++++++-------
 security/integrity/integrity.h         |  8 +++++
 2 files changed, 41 insertions(+), 11 deletions(-)

diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
index d775e03fbbcc..4c3c49f919f5 100644
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
 
@@ -110,7 +132,7 @@ int asymmetric_verify(struct key *keyring, const char *sig,
 	pks.digest = (u8 *)data;
 	pks.digest_size = datalen;
 	pks.s = hdr->sig;
-	pks.s_size = siglen;
+	pks.s_size = siglen - sizeof(*hdr);
 	ret = verify_signature(key, &pks);
 	key_put(key);
 	pr_debug("%s() = %d\n", __func__, ret);
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 91c41351e18a..ae3c79c63674 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -182,12 +182,20 @@ static inline int integrity_init_keyring(const unsigned int id)
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
