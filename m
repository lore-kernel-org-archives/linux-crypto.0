From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: [PATCH v2 1/6] integrity: Small code improvements
Date: Wed,  7 Jun 2017 22:49:10 -0300
Message-ID: <1496886555-10082-2-git-send-email-bauerman@linux.vnet.ibm.com>
References: <1496886555-10082-1-git-send-email-bauerman@linux.vnet.ibm.com>
Cc: linux-ima-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
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
To: linux-security-module@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58345 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751441AbdFHBuE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Jun 2017 21:50:04 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v581mpgb126803
        for <linux-crypto@vger.kernel.org>; Wed, 7 Jun 2017 21:49:58 -0400
Received: from e24smtp01.br.ibm.com (e24smtp01.br.ibm.com [32.104.18.85])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2axw2xg9pp-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Wed, 07 Jun 2017 21:49:58 -0400
Received: from localhost
        by e24smtp01.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <bauerman@linux.vnet.ibm.com>;
        Wed, 7 Jun 2017 22:49:56 -0300
In-Reply-To: <1496886555-10082-1-git-send-email-bauerman@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

These changes are too small to warrant their own patches:

The keyid and sig_size members of struct signature_v2_hdr are in BE format,
so use a type that makes this assumption explicit. Also, use beXX_to_cpu
instead of __beXX_to_cpu to read them.

Change integrity_kernel_read to take a void * buffer instead of char *
buffer, so that callers don't have to use a cast if they provide a buffer
that isn't a char *.

Add missing #endif comment in ima.h pointing out which macro it refers to.

Add missing fall through comment in ima_appraise.c.

Constify mask_tokens and func_tokens arrays.

Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
---
 security/integrity/digsig_asymmetric.c | 4 ++--
 security/integrity/iint.c              | 2 +-
 security/integrity/ima/ima.h           | 2 +-
 security/integrity/ima/ima_appraise.c  | 1 +
 security/integrity/ima/ima_policy.c    | 4 ++--
 security/integrity/integrity.h         | 7 ++++---
 6 files changed, 11 insertions(+), 9 deletions(-)

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
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index d26a30e37d13..215a93c41b51 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -284,7 +284,7 @@ static inline int ima_read_xattr(struct dentry *dentry,
 	return 0;
 }
 
-#endif
+#endif /* CONFIG_IMA_APPRAISE */
 
 /* LSM based policy rules require audit */
 #ifdef CONFIG_IMA_LSM_RULES
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 7fe0566142d8..ea36a4f134f4 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -240,6 +240,7 @@ int ima_appraise_measurement(enum ima_hooks func,
 	case IMA_XATTR_DIGEST_NG:
 		/* first byte contains algorithm id */
 		hash_start = 1;
+		/* fall through */
 	case IMA_XATTR_DIGEST:
 		if (iint->flags & IMA_DIGSIG_REQUIRED) {
 			cause = "IMA-signature-required";
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 0acd68decb17..949ad3858327 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -965,7 +965,7 @@ enum {
 	mask_exec = 0, mask_write, mask_read, mask_append
 };
 
-static char *mask_tokens[] = {
+static const char *const mask_tokens[] = {
 	"MAY_EXEC",
 	"MAY_WRITE",
 	"MAY_READ",
@@ -979,7 +979,7 @@ enum {
 	func_policy
 };
 
-static char *func_tokens[] = {
+static const char *const func_tokens[] = {
 	"FILE_CHECK",
 	"MMAP_CHECK",
 	"BPRM_CHECK",
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
