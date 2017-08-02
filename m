From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 1/7] integrity: Introduce struct evm_hmac_xattr
Date: Wed, 02 Aug 2017 14:17:05 -0300
Message-ID: <87h8xpyjn2.fsf@linux.vnet.ibm.com>
References: <20170706221753.17380-1-bauerman@linux.vnet.ibm.com> <20170706221753.17380-2-bauerman@linux.vnet.ibm.com> <1501245566.10288.35.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jessica Yu <jeyu@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "AKASHI\, Takahiro" <takahiro.akashi@linaro.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54578 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751172AbdHBRRY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Aug 2017 13:17:24 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v72HE8A4127312
        for <linux-crypto@vger.kernel.org>; Wed, 2 Aug 2017 13:17:23 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2c3ety5r78-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Wed, 02 Aug 2017 13:17:23 -0400
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <bauerman@linux.vnet.ibm.com>;
        Wed, 2 Aug 2017 13:17:23 -0400
In-reply-to: <1501245566.10288.35.camel@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Hello Mimi,

Thanks for your review!

The patch at the end of the email implements your suggestions, what do
you think?

Mimi Zohar <zohar@linux.vnet.ibm.com> writes:
> On Thu, 2017-07-06 at 19:17 -0300, Thiago Jung Bauermann wrote:
>> A separate struct evm_hmac_xattr is introduced, with the original
>> definition of evm_ima_xattr_data to be used in the places that actually
>> expect that definition.
>
> The new structure name implies that the xattr can only be an HMAC. By
> moving the new structure to evm.h we also loose the connection that it
> has to theevm_ima_xattr_type enumeration.

Ok, I renamed it to struct evm_xattr.

> Instead, how about defining the new struct in terms of the modified
> evm_ima_xattr_data struct?

IMHO IMA and EVM's practice of mixing and matching structs to compose
its data structures makes the code somewhat confusing and harder to see
where the actual storage used by a given field is actually allocated.

But I don't feel strongly about it, so the patch at the end of this
emails defines it as:

struct evm_xattr {
	struct evm_ima_xattr_data data;
	u8 digest[SHA1_DIGEST_SIZE];
} __packed;

Another disadvantage of the above is that you have two fields pointing
to the same place: evm_xattr.data.data and evm_xattr.digest.

> Please leave the new structure in integrity.h.

I think that moving the structure in evm.h is helpful. It immediately
conveys that nothing outside of security/integrity/evm/ interprets the
xattr data in the way defined by struct evm_xattr.

But I also don't feel strongly about it, so I moved it to integrity.h.

-- 
Thiago Jung Bauermann
IBM Linux Technology Center


>From df2e29f29c99f5c986d8005d8af8409b3c4d115c Mon Sep 17 00:00:00 2001
From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Date: Tue, 16 May 2017 17:14:49 -0300
Subject: [PATCH v4 1/7] integrity: Introduce struct evm_xattr

Even though struct evm_ima_xattr_data includes a fixed-size array to hold a
SHA1 digest, most of the code ignores the array and uses the struct to mean
"type indicator followed by data of unspecified size" and tracks the real
size of what the struct represents in a separate length variable.

The only exception to that is the EVM code, which correctly uses the
definition of struct evm_ima_xattr_data.

This patch makes this explicit in the code by removing the length
specification from the array in struct evm_ima_xattr_data. It also changes
the name of the element from digest to data, since in most places the array
doesn't hold a digest.

A separate struct evm_xattr is introduced, with the original definition of
evm_ima_xattr_data to be used in the places that actually expect that
definition.

Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
---
 security/integrity/evm/evm_crypto.c   |  4 ++--
 security/integrity/evm/evm_main.c     | 10 +++++-----
 security/integrity/ima/ima_appraise.c |  7 ++++---
 security/integrity/integrity.h        |  5 +++++
 4 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index d7f282d75cc1..d902a18ef66f 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -252,13 +252,13 @@ int evm_update_evmxattr(struct dentry *dentry, const char *xattr_name,
 			const char *xattr_value, size_t xattr_value_len)
 {
 	struct inode *inode = d_backing_inode(dentry);
-	struct evm_ima_xattr_data xattr_data;
+	struct evm_xattr xattr_data;
 	int rc = 0;
 
 	rc = evm_calc_hmac(dentry, xattr_name, xattr_value,
 			   xattr_value_len, xattr_data.digest);
 	if (rc == 0) {
-		xattr_data.type = EVM_XATTR_HMAC;
+		xattr_data.data.type = EVM_XATTR_HMAC;
 		rc = __vfs_setxattr_noperm(dentry, XATTR_NAME_EVM,
 					   &xattr_data,
 					   sizeof(xattr_data), 0);
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 063d38aef64e..536694499515 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -116,7 +116,7 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 					     struct integrity_iint_cache *iint)
 {
 	struct evm_ima_xattr_data *xattr_data = NULL;
-	struct evm_ima_xattr_data calc;
+	struct evm_xattr calc;
 	enum integrity_status evm_status = INTEGRITY_PASS;
 	int rc, xattr_len;
 
@@ -147,7 +147,7 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 	/* check value type */
 	switch (xattr_data->type) {
 	case EVM_XATTR_HMAC:
-		if (xattr_len != sizeof(struct evm_ima_xattr_data)) {
+		if (xattr_len != sizeof(struct evm_xattr)) {
 			evm_status = INTEGRITY_FAIL;
 			goto out;
 		}
@@ -155,7 +155,7 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 				   xattr_value_len, calc.digest);
 		if (rc)
 			break;
-		rc = crypto_memneq(xattr_data->digest, calc.digest,
+		rc = crypto_memneq(xattr_data->data, calc.digest,
 			    sizeof(calc.digest));
 		if (rc)
 			rc = -EINVAL;
@@ -467,7 +467,7 @@ int evm_inode_init_security(struct inode *inode,
 				 const struct xattr *lsm_xattr,
 				 struct xattr *evm_xattr)
 {
-	struct evm_ima_xattr_data *xattr_data;
+	struct evm_xattr *xattr_data;
 	int rc;
 
 	if (!evm_initialized || !evm_protected_xattr(lsm_xattr->name))
@@ -477,7 +477,7 @@ int evm_inode_init_security(struct inode *inode,
 	if (!xattr_data)
 		return -ENOMEM;
 
-	xattr_data->type = EVM_XATTR_HMAC;
+	xattr_data->data.type = EVM_XATTR_HMAC;
 	rc = evm_init_hmac(inode, lsm_xattr, xattr_data->digest);
 	if (rc < 0)
 		goto out;
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 809ba70fbbbf..87d2b601cf8e 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -156,7 +156,8 @@ enum hash_algo ima_get_hash_algo(struct evm_ima_xattr_data *xattr_value,
 		return sig->hash_algo;
 		break;
 	case IMA_XATTR_DIGEST_NG:
-		ret = xattr_value->digest[0];
+		/* first byte contains algorithm id */
+		ret = xattr_value->data[0];
 		if (ret < HASH_ALGO__LAST)
 			return ret;
 		break;
@@ -164,7 +165,7 @@ enum hash_algo ima_get_hash_algo(struct evm_ima_xattr_data *xattr_value,
 		/* this is for backward compatibility */
 		if (xattr_len == 21) {
 			unsigned int zero = 0;
-			if (!memcmp(&xattr_value->digest[16], &zero, 4))
+			if (!memcmp(&xattr_value->data[16], &zero, 4))
 				return HASH_ALGO_MD5;
 			else
 				return HASH_ALGO_SHA1;
@@ -253,7 +254,7 @@ int ima_appraise_measurement(enum ima_hooks func,
 			/* xattr length may be longer. md5 hash in previous
 			   version occupied 20 bytes in xattr, instead of 16
 			 */
-			rc = memcmp(&xattr_value->digest[hash_start],
+			rc = memcmp(&xattr_value->data[hash_start],
 				    iint->ima_hash->digest,
 				    iint->ima_hash->length);
 		else
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index a53e7e4ab06c..9b1762076f38 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -63,6 +63,11 @@ enum evm_ima_xattr_type {
 
 struct evm_ima_xattr_data {
 	u8 type;
+	u8 data[];
+} __packed;
+
+struct evm_xattr {
+	struct evm_ima_xattr_data data;
 	u8 digest[SHA1_DIGEST_SIZE];
 } __packed;
 
-- 
2.13.0
