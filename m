From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: [PATCH 1/6] integrity: Small code improvements
Date: Tue, 18 Apr 2017 17:17:41 -0300
Message-ID: <1492546666-16615-2-git-send-email-bauerman@linux.vnet.ibm.com>
References: <1492546666-16615-1-git-send-email-bauerman@linux.vnet.ibm.com>
Cc: linux-ima-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Claudio Carvalho <cclaudio@linux.vnet.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1492546666-16615-1-git-send-email-bauerman@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The keyid and sig_size members of struct signature_v2_hdr are in BE format,
so use a type that makes this assumption explicit. Also, use beXX_to_cpu
instead of __beXX_to_cpu to read them.

Change integrity_kernel_read to take a void * buffer instead of char *
buffer, so that callers don't have to use a cast if they provide a buffer
that isn't a char *.

Also, add missing fall through comment in ima_appraise.c.

Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
---
 security/integrity/digsig_asymmetric.c | 4 ++--
 security/integrity/iint.c              | 2 +-
 security/integrity/ima/ima_appraise.c  | 1 +
 security/integrity/integrity.h         | 7 ++++---
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
index 80052ed8d467..ab6a029062a1 100644
--- a/security/integrity/digsig_asymmetric.c
+++ b/security/integrity/digsig_asymmetric.c
@@ -92,13 +92,13 @@ int asymmetric_verify(struct key *keyring, const char *sig,
 
 	siglen -= sizeof(*hdr);
 
-	if (siglen != __be16_to_cpu(hdr->sig_size))
+	if (siglen != be16_to_cpu(hdr->sig_size))
 		return -EBADMSG;
 
 	if (hdr->hash_algo >= HASH_ALGO__LAST)
 		return -ENOPKG;
 
-	key = request_asymmetric_key(keyring, __be32_to_cpu(hdr->keyid));
+	key = request_asymmetric_key(keyring, be32_to_cpu(hdr->keyid));
 	if (IS_ERR(key))
 		return PTR_ERR(key);
 
diff --git a/security/integrity/iint.c b/security/integrity/iint.c
index c710d22042f9..6fc888ca468e 100644
--- a/security/integrity/iint.c
+++ b/security/integrity/iint.c
@@ -182,7 +182,7 @@ security_initcall(integrity_iintcache_init);
  *
  */
 int integrity_kernel_read(struct file *file, loff_t offset,
-			  char *addr, unsigned long count)
+			  void *addr, unsigned long count)
 {
 	mm_segment_t old_fs;
 	char __user *buf = (char __user *)addr;
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 1fd9539a969d..427a896bc806 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -227,6 +227,7 @@ int ima_appraise_measurement(enum ima_hooks func,
 	case IMA_XATTR_DIGEST_NG:
 		/* first byte contains algorithm id */
 		hash_start = 1;
+		/* fall through */
 	case IMA_XATTR_DIGEST:
 		if (iint->flags & IMA_DIGSIG_REQUIRED) {
 			cause = "IMA-signature-required";
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 24520b4ef3b0..a53e7e4ab06c 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -92,8 +92,8 @@ struct signature_v2_hdr {
 	uint8_t type;		/* xattr type */
 	uint8_t version;	/* signature format version */
 	uint8_t	hash_algo;	/* Digest algorithm [enum hash_algo] */
-	uint32_t keyid;		/* IMA key identifier - not X509/PGP specific */
-	uint16_t sig_size;	/* signature size */
+	__be32 keyid;		/* IMA key identifier - not X509/PGP specific */
+	__be16 sig_size;	/* signature size */
 	uint8_t sig[0];		/* signature payload */
 } __packed;
 
@@ -118,7 +118,8 @@ struct integrity_iint_cache {
 struct integrity_iint_cache *integrity_iint_find(struct inode *inode);
 
 int integrity_kernel_read(struct file *file, loff_t offset,
-			  char *addr, unsigned long count);
+			  void *addr, unsigned long count);
+
 int __init integrity_read_file(const char *path, char **data);
 
 #define INTEGRITY_KEYRING_EVM		0
-- 
2.7.4

