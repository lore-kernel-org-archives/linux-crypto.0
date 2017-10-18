From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: [PATCH v5 14/18] integrity: Introduce integrity_keyring_from_id
Date: Tue, 17 Oct 2017 22:53:27 -0200
Message-ID: <20171018005331.2688-15-bauerman@linux.vnet.ibm.com>
References: <20171018005331.2688-1-bauerman@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jessica Yu <jeyu@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "AKASHI, Takahiro" <takahiro.akashi@linaro.org>,
        Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
To: linux-integrity@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171018005331.2688-1-bauerman@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

IMA will need to obtain the keyring used to verify file signatures so that
it can verify the module-style signature appended to files.

Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
---
 security/integrity/digsig.c    | 28 +++++++++++++++++++---------
 security/integrity/integrity.h |  1 +
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
index 6f9e4ce568cd..935f1b3258e7 100644
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
@@ -61,18 +60,29 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
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
+	struct key *keyring = integrity_keyring_from_id(id);
+
+	if (IS_ERR(keyring) || siglen < 2)
+		return PTR_ERR(keyring);
+
 	switch (sig[1]) {
 	case 1:
 		/* v1 API expect signature without xattr type */
-		return digsig_verify(keyring[id], sig + 1, siglen - 1,
-				     digest, digestlen);
+		return digsig_verify(keyring, sig + 1, siglen - 1, digest,
+				     digestlen);
 	case 2:
-		return asymmetric_verify(keyring[id], sig, siglen,
-					 digest, digestlen);
+		return asymmetric_verify(keyring, sig, siglen, digest,
+					 digestlen);
 	}
 
 	return -EOPNOTSUPP;
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index dd7ac4bfc89a..657ce4558984 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -132,6 +132,7 @@ int integrity_kernel_read(struct file *file, loff_t offset,
 
 #ifdef CONFIG_INTEGRITY_SIGNATURE
 
+struct key *integrity_keyring_from_id(const unsigned int id);
 int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 			    const char *digest, int digestlen);
 
