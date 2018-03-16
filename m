From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: [PATCH v6 05/12] integrity: Introduce integrity_keyring_from_id()
Date: Fri, 16 Mar 2018 17:38:30 -0300
Message-ID: <20180316203837.10174-6-bauerman@linux.vnet.ibm.com>
References: <20180316203837.10174-1-bauerman@linux.vnet.ibm.com>
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
        Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
To: linux-integrity@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180316203837.10174-1-bauerman@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

IMA will need to obtain the keyring used to verify file signatures so that
it can verify the module-style signature appended to files.

Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
---
 security/integrity/digsig.c    | 28 +++++++++++++++++++++-------
 security/integrity/integrity.h |  6 ++++++
 2 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
index 6f9e4ce568cd..e641a67b9fc7 100644
--- a/security/integrity/digsig.c
+++ b/security/integrity/digsig.c
@@ -48,11 +48,10 @@ static bool init_keyring __initdata;
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
@@ -61,17 +60,32 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
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
index 79799a0d9195..2d245f44ca26 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -150,6 +150,7 @@ int integrity_kernel_read(struct file *file, loff_t offset,
 
 #ifdef CONFIG_INTEGRITY_SIGNATURE
 
+struct key *integrity_keyring_from_id(const unsigned int id);
 int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 			    const char *digest, int digestlen);
 
@@ -157,6 +158,11 @@ int __init integrity_init_keyring(const unsigned int id);
 int __init integrity_load_x509(const unsigned int id, const char *path);
 #else
 
+static inline struct key *integrity_keyring_from_id(const unsigned int id)
+{
+	return ERR_PTR(-EINVAL);
+}
+
 static inline int integrity_digsig_verify(const unsigned int id,
 					  const char *sig, int siglen,
 					  const char *digest, int digestlen)
