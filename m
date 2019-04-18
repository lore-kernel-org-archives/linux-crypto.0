Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8B93C10F0E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 03:52:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86FE02184B
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 03:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388107AbfDRDwg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Apr 2019 23:52:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44658 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388091AbfDRDwf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Apr 2019 23:52:35 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3I3oAYM021514
        for <linux-crypto@vger.kernel.org>; Wed, 17 Apr 2019 23:52:34 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2rxgva9n2r-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Wed, 17 Apr 2019 23:52:34 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <bauerman@linux.ibm.com>;
        Thu, 18 Apr 2019 04:52:33 +0100
Received: from b03cxnp07029.gho.boulder.ibm.com (9.17.130.16)
        by e36.co.us.ibm.com (192.168.1.136) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 18 Apr 2019 04:52:26 +0100
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3I3qPF128377250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Apr 2019 03:52:25 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21EA27805F;
        Thu, 18 Apr 2019 03:52:25 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95D297805C;
        Thu, 18 Apr 2019 03:52:20 +0000 (GMT)
Received: from morokweng.localdomain.com (unknown [9.85.230.182])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 18 Apr 2019 03:52:20 +0000 (GMT)
From:   Thiago Jung Bauermann <bauerman@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
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
Subject: [PATCH v10 08/12] ima: Factor xattr_verify() out of ima_appraise_measurement()
Date:   Thu, 18 Apr 2019 00:51:16 -0300
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190418035120.2354-1-bauerman@linux.ibm.com>
References: <20190418035120.2354-1-bauerman@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19041803-0020-0000-0000-00000ED91E0F
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00010947; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000284; SDB=6.01190666; UDB=6.00623948; IPR=6.00971462;
 MB=3.00026493; MTD=3.00000008; XFM=3.00000015; UTC=2019-04-18 03:52:31
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19041803-0021-0000-0000-000065794A41
Message-Id: <20190418035120.2354-9-bauerman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-18_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904180023
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Verify xattr signature in a separate function so that the logic in
ima_appraise_measurement() remains clear when it gains the ability to also
verify an appended module signature.

The code in the switch statement is unchanged except for having to
dereference the status and cause variables (since they're now pointers),
and fixing the style of a block comment to appease checkpatch.

Suggested-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
---
 security/integrity/ima/ima_appraise.c | 141 +++++++++++++++-----------
 1 file changed, 81 insertions(+), 60 deletions(-)

diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index ea8fa29f07d3..b3837e26bb27 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -202,6 +202,83 @@ int ima_read_xattr(struct dentry *dentry,
 	return ret;
 }
 
+/*
+ * xattr_verify - verify xattr digest or signature
+ *
+ * Verify whether the hash or signature matches the file contents.
+ *
+ * Return 0 on success, error code otherwise.
+ */
+static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
+			struct evm_ima_xattr_data *xattr_value, int xattr_len,
+			enum integrity_status *status, const char **cause)
+{
+	int rc = -EINVAL, hash_start = 0;
+
+	switch (xattr_value->type) {
+	case IMA_XATTR_DIGEST_NG:
+		/* first byte contains algorithm id */
+		hash_start = 1;
+		/* fall through */
+	case IMA_XATTR_DIGEST:
+		if (iint->flags & IMA_DIGSIG_REQUIRED) {
+			*cause = "IMA-signature-required";
+			*status = INTEGRITY_FAIL;
+			break;
+		}
+		clear_bit(IMA_DIGSIG, &iint->atomic_flags);
+		if (xattr_len - sizeof(xattr_value->type) - hash_start >=
+				iint->ima_hash->length)
+			/*
+			 * xattr length may be longer. md5 hash in previous
+			 * version occupied 20 bytes in xattr, instead of 16
+			 */
+			rc = memcmp(&xattr_value->data[hash_start],
+				    iint->ima_hash->digest,
+				    iint->ima_hash->length);
+		else
+			rc = -EINVAL;
+		if (rc) {
+			*cause = "invalid-hash";
+			*status = INTEGRITY_FAIL;
+			break;
+		}
+		*status = INTEGRITY_PASS;
+		break;
+	case EVM_IMA_XATTR_DIGSIG:
+		set_bit(IMA_DIGSIG, &iint->atomic_flags);
+		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
+					     (const char *)xattr_value,
+					     xattr_len,
+					     iint->ima_hash->digest,
+					     iint->ima_hash->length);
+		if (rc == -EOPNOTSUPP) {
+			*status = INTEGRITY_UNKNOWN;
+			break;
+		}
+		if (IS_ENABLED(CONFIG_INTEGRITY_PLATFORM_KEYRING) && rc &&
+		    func == KEXEC_KERNEL_CHECK)
+			rc = integrity_digsig_verify(INTEGRITY_KEYRING_PLATFORM,
+						     (const char *)xattr_value,
+						     xattr_len,
+						     iint->ima_hash->digest,
+						     iint->ima_hash->length);
+		if (rc) {
+			*cause = "invalid-signature";
+			*status = INTEGRITY_FAIL;
+		} else {
+			*status = INTEGRITY_PASS;
+		}
+		break;
+	default:
+		*status = INTEGRITY_UNKNOWN;
+		*cause = "unknown-ima-data";
+		break;
+	}
+
+	return rc;
+}
+
 /*
  * ima_appraise_measurement - appraise file measurement
  *
@@ -221,7 +298,7 @@ int ima_appraise_measurement(enum ima_hooks func,
 	struct dentry *dentry = file_dentry(file);
 	struct inode *inode = d_backing_inode(dentry);
 	enum integrity_status status = INTEGRITY_UNKNOWN;
-	int rc = xattr_len, hash_start = 0;
+	int rc = xattr_len;
 
 	if (!(inode->i_opflags & IOP_XATTR))
 		return INTEGRITY_UNKNOWN;
@@ -259,65 +336,9 @@ int ima_appraise_measurement(enum ima_hooks func,
 		WARN_ONCE(true, "Unexpected integrity status %d\n", status);
 	}
 
-	switch (xattr_value->type) {
-	case IMA_XATTR_DIGEST_NG:
-		/* first byte contains algorithm id */
-		hash_start = 1;
-		/* fall through */
-	case IMA_XATTR_DIGEST:
-		if (iint->flags & IMA_DIGSIG_REQUIRED) {
-			cause = "IMA-signature-required";
-			status = INTEGRITY_FAIL;
-			break;
-		}
-		clear_bit(IMA_DIGSIG, &iint->atomic_flags);
-		if (xattr_len - sizeof(xattr_value->type) - hash_start >=
-				iint->ima_hash->length)
-			/* xattr length may be longer. md5 hash in previous
-			   version occupied 20 bytes in xattr, instead of 16
-			 */
-			rc = memcmp(&xattr_value->data[hash_start],
-				    iint->ima_hash->digest,
-				    iint->ima_hash->length);
-		else
-			rc = -EINVAL;
-		if (rc) {
-			cause = "invalid-hash";
-			status = INTEGRITY_FAIL;
-			break;
-		}
-		status = INTEGRITY_PASS;
-		break;
-	case EVM_IMA_XATTR_DIGSIG:
-		set_bit(IMA_DIGSIG, &iint->atomic_flags);
-		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
-					     (const char *)xattr_value,
-					     xattr_len,
-					     iint->ima_hash->digest,
-					     iint->ima_hash->length);
-		if (rc == -EOPNOTSUPP) {
-			status = INTEGRITY_UNKNOWN;
-			break;
-		}
-		if (IS_ENABLED(CONFIG_INTEGRITY_PLATFORM_KEYRING) && rc &&
-		    func == KEXEC_KERNEL_CHECK)
-			rc = integrity_digsig_verify(INTEGRITY_KEYRING_PLATFORM,
-						     (const char *)xattr_value,
-						     xattr_len,
-						     iint->ima_hash->digest,
-						     iint->ima_hash->length);
-		if (rc) {
-			cause = "invalid-signature";
-			status = INTEGRITY_FAIL;
-		} else {
-			status = INTEGRITY_PASS;
-		}
-		break;
-	default:
-		status = INTEGRITY_UNKNOWN;
-		cause = "unknown-ima-data";
-		break;
-	}
+	if (xattr_value)
+		rc = xattr_verify(func, iint, xattr_value, xattr_len, &status,
+				  &cause);
 
 out:
 	/*

