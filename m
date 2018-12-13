Return-Path: <SRS0=KZld=OW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47038 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726744AbeLMCLY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Dec 2018 21:11:24 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wBD23jwr025189
        for <linux-crypto@vger.kernel.org>; Wed, 12 Dec 2018 21:11:23 -0500
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2pbbktf1ru-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Wed, 12 Dec 2018 21:11:22 -0500
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <bauerman@linux.ibm.com>;
        Thu, 13 Dec 2018 02:11:22 -0000
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
        Thiago Jung Bauermann <bauerman@linux.ibm.com>
Subject: [PATCH v9 05/14] integrity: Introduce integrity_keyring_from_id()
Date: Thu, 13 Dec 2018 00:08:58 -0200
In-Reply-To: <20181213020907.13601-1-bauerman@linux.ibm.com>
References: <20181213020907.13601-1-bauerman@linux.ibm.com>
Message-Id: <20181213020907.13601-6-bauerman@linux.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

IMA will need to obtain the keyring used to verify file signatures so that
it can verify the module-style signature appended to files.

Signed-off-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
 security/integrity/digsig.c    | 28 +++++++++++++++++++++-------
 security/integrity/integrity.h |  6 ++++++
 2 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
index 71c3200521d6..bbfa3085d1b5 100644
--- a/security/integrity/digsig.c
+++ b/security/integrity/digsig.c
@@ -44,11 +44,10 @@ static const char * const keyring_name[INTEGRITY_KEYRING_MAX] = {
 #define restrict_link_to_ima restrict_link_by_builtin_trusted
 #endif
 
-int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
-			    const char *digest, int digestlen)
+struct key *integrity_keyring_from_id(const unsigned int id)
 {
-	if (id >= INTEGRITY_KEYRING_MAX || siglen < 2)
-		return -EINVAL;
+	if (id >= INTEGRITY_KEYRING_MAX)
+		return ERR_PTR(-EINVAL);
 
 	if (!keyring[id]) {
 		keyring[id] =
@@ -57,17 +56,32 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 			int err = PTR_ERR(keyring[id]);
 			pr_err("no %s keyring: %d\n", keyring_name[id], err);
 			keyring[id] = NULL;
-			return err;
+			return ERR_PTR(err);
 		}
 	}
 
+	return keyring[id];
+}
+
+int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
+			    const char *digest, int digestlen)
+{
+	struct key *keyring;
+
+	if (siglen < 2)
+		return -EINVAL;
+
+	keyring = integrity_keyring_from_id(id);
+	if (IS_ERR(keyring))
+		return PTR_ERR(keyring);
+
 	switch (sig[1]) {
 	case 1:
 		/* v1 API expect signature without xattr type */
-		return digsig_verify(keyring[id], sig + 1, siglen - 1,
+		return digsig_verify(keyring, sig + 1, siglen - 1,
 				     digest, digestlen);
 	case 2:
-		return asymmetric_verify(keyring[id], sig, siglen,
+		return asymmetric_verify(keyring, sig, siglen,
 					 digest, digestlen);
 	}
 
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 2bf0fc51752b..6f657260a964 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -155,6 +155,7 @@ extern struct dentry *integrity_dir;
 
 #ifdef CONFIG_INTEGRITY_SIGNATURE
 
+struct key *integrity_keyring_from_id(const unsigned int id);
 int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 			    const char *digest, int digestlen);
 
@@ -164,6 +165,11 @@ int __init integrity_load_cert(const unsigned int id, const char *source,
 			       const void *data, size_t len, key_perm_t perm);
 #else
 
+static inline struct key *integrity_keyring_from_id(const unsigned int id)
+{
+	return ERR_PTR(-EINVAL);
+}
+
 static inline int integrity_digsig_verify(const unsigned int id,
 					  const char *sig, int siglen,
 					  const char *digest, int digestlen)
