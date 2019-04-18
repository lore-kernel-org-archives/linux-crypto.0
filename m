Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26CE7C10F0E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 03:52:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF64C2184B
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 03:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388090AbfDRDwa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Apr 2019 23:52:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59010 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388061AbfDRDw2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Apr 2019 23:52:28 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3I3oAF2116915
        for <linux-crypto@vger.kernel.org>; Wed, 17 Apr 2019 23:52:27 -0400
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2rxhdb8hh8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Wed, 17 Apr 2019 23:52:27 -0400
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <bauerman@linux.ibm.com>;
        Thu, 18 Apr 2019 04:52:26 +0100
Received: from b03cxnp07029.gho.boulder.ibm.com (9.17.130.16)
        by e33.co.us.ibm.com (192.168.1.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 18 Apr 2019 04:52:20 +0100
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3I3qJD220643894
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Apr 2019 03:52:19 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3573178066;
        Thu, 18 Apr 2019 03:52:19 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F09E87805C;
        Thu, 18 Apr 2019 03:52:14 +0000 (GMT)
Received: from morokweng.localdomain.com (unknown [9.85.230.182])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 18 Apr 2019 03:52:14 +0000 (GMT)
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
Subject: [PATCH v10 07/12] ima: Add modsig appraise_type option for module-style appended signatures
Date:   Thu, 18 Apr 2019 00:51:15 -0300
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190418035120.2354-1-bauerman@linux.ibm.com>
References: <20190418035120.2354-1-bauerman@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19041803-0036-0000-0000-00000AAA1A1D
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00010947; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000284; SDB=6.01190666; UDB=6.00623948; IPR=6.00971462;
 MB=3.00026492; MTD=3.00000008; XFM=3.00000015; UTC=2019-04-18 03:52:24
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19041803-0037-0000-0000-00004B6E4471
Message-Id: <20190418035120.2354-8-bauerman@linux.ibm.com>
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

Introduce the modsig keyword to the IMA policy syntax to specify that
a given hook should expect the file to have the IMA signature appended
to it. Here is how it can be used in a rule:

appraise func=KEXEC_KERNEL_CHECK appraise_type=imasig|modsig

With this rule, IMA will accept either a signature stored in the extended
attribute or an appended signature.

For now, the rule above will behave exactly the same as if
appraise_type=imasig was specified. The actual modsig implementation
will be introduced separately.

Suggested-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
---
 Documentation/ABI/testing/ima_policy |  6 +++++-
 security/integrity/ima/Kconfig       | 10 +++++++++
 security/integrity/ima/Makefile      |  1 +
 security/integrity/ima/ima.h         |  9 ++++++++
 security/integrity/ima/ima_modsig.c  | 31 ++++++++++++++++++++++++++++
 security/integrity/ima/ima_policy.c  | 12 +++++++++--
 security/integrity/integrity.h       |  1 +
 7 files changed, 67 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
index 74c6702de74e..9d1dfd0a8891 100644
--- a/Documentation/ABI/testing/ima_policy
+++ b/Documentation/ABI/testing/ima_policy
@@ -37,7 +37,7 @@ Description:
 			euid:= decimal value
 			fowner:= decimal value
 		lsm:  	are LSM specific
-		option:	appraise_type:= [imasig]
+		option:	appraise_type:= [imasig] [imasig|modsig]
 			pcr:= decimal value
 
 		default policy:
@@ -103,3 +103,7 @@ Description:
 
 			measure func=KEXEC_KERNEL_CHECK pcr=4
 			measure func=KEXEC_INITRAMFS_CHECK pcr=5
+
+		Example of appraise rule allowing modsig appended signatures:
+
+			appraise func=KEXEC_KERNEL_CHECK appraise_type=imasig|modsig
diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index a18f8c6d13b5..bba19f9ea184 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -231,6 +231,16 @@ config IMA_APPRAISE_BOOTPARAM
 	  This option enables the different "ima_appraise=" modes
 	  (eg. fix, log) from the boot command line.
 
+config IMA_APPRAISE_MODSIG
+	bool "Support module-style signatures for appraisal"
+	depends on IMA_APPRAISE
+	default n
+	help
+	   Adds support for signatures appended to files. The format of the
+	   appended signature is the same used for signed kernel modules.
+	   The modsig keyword can be used in the IMA policy to allow a hook
+	   to accept such signatures.
+
 config IMA_TRUSTED_KEYRING
 	bool "Require all keys on the .ima keyring be signed (deprecated)"
 	depends on IMA_APPRAISE && SYSTEM_TRUSTED_KEYRING
diff --git a/security/integrity/ima/Makefile b/security/integrity/ima/Makefile
index d921dc4f9eb0..31d57cdf2421 100644
--- a/security/integrity/ima/Makefile
+++ b/security/integrity/ima/Makefile
@@ -9,5 +9,6 @@ obj-$(CONFIG_IMA) += ima.o
 ima-y := ima_fs.o ima_queue.o ima_init.o ima_main.o ima_crypto.o ima_api.o \
 	 ima_policy.o ima_template.o ima_template_lib.o
 ima-$(CONFIG_IMA_APPRAISE) += ima_appraise.o
+ima-$(CONFIG_IMA_APPRAISE_MODSIG) += ima_modsig.o
 ima-$(CONFIG_HAVE_IMA_KEXEC) += ima_kexec.o
 obj-$(CONFIG_IMA_BLACKLIST_KEYRING) += ima_mok.o
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index d213e835c498..0c3e5a59270f 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -293,6 +293,15 @@ static inline int ima_read_xattr(struct dentry *dentry,
 
 #endif /* CONFIG_IMA_APPRAISE */
 
+#ifdef CONFIG_IMA_APPRAISE_MODSIG
+bool ima_hook_supports_modsig(enum ima_hooks func);
+#else
+static inline bool ima_hook_supports_modsig(enum ima_hooks func)
+{
+	return false;
+}
+#endif /* CONFIG_IMA_APPRAISE_MODSIG */
+
 /* LSM based policy rules require audit */
 #ifdef CONFIG_IMA_LSM_RULES
 
diff --git a/security/integrity/ima/ima_modsig.c b/security/integrity/ima/ima_modsig.c
new file mode 100644
index 000000000000..87503bfe8c8b
--- /dev/null
+++ b/security/integrity/ima/ima_modsig.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * IMA support for appraising module-style appended signatures.
+ *
+ * Copyright (C) 2019  IBM Corporation
+ *
+ * Author:
+ * Thiago Jung Bauermann <bauerman@linux.ibm.com>
+ */
+
+#include "ima.h"
+
+/**
+ * ima_hook_supports_modsig - can the policy allow modsig for this hook?
+ *
+ * modsig is only supported by hooks using ima_post_read_file(), because only
+ * they preload the contents of the file in a buffer. FILE_CHECK does that in
+ * some cases, but not when reached from vfs_open(). POLICY_CHECK can support
+ * it, but it's not useful in practice because it's a text file so deny.
+ */
+bool ima_hook_supports_modsig(enum ima_hooks func)
+{
+	switch (func) {
+	case KEXEC_KERNEL_CHECK:
+	case KEXEC_INITRAMFS_CHECK:
+	case MODULE_CHECK:
+		return true;
+	default:
+		return false;
+	}
+}
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index e0cc323f948f..fca7a3f23321 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -1038,6 +1038,10 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 			ima_log_string(ab, "appraise_type", args[0].from);
 			if ((strcmp(args[0].from, "imasig")) == 0)
 				entry->flags |= IMA_DIGSIG_REQUIRED;
+			else if (ima_hook_supports_modsig(entry->func) &&
+				 strcmp(args[0].from, "imasig|modsig") == 0)
+				entry->flags |= IMA_DIGSIG_REQUIRED
+						| IMA_MODSIG_ALLOWED;
 			else
 				result = -EINVAL;
 			break;
@@ -1330,8 +1334,12 @@ int ima_policy_show(struct seq_file *m, void *v)
 			}
 		}
 	}
-	if (entry->flags & IMA_DIGSIG_REQUIRED)
-		seq_puts(m, "appraise_type=imasig ");
+	if (entry->flags & IMA_DIGSIG_REQUIRED) {
+		if (entry->flags & IMA_MODSIG_ALLOWED)
+			seq_puts(m, "appraise_type=imasig|modsig ");
+		else
+			seq_puts(m, "appraise_type=imasig ");
+	}
 	if (entry->flags & IMA_PERMIT_DIRECTIO)
 		seq_puts(m, "permit_directio ");
 	rcu_read_unlock();
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 88a29f72a74f..0e7330a36a9d 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -36,6 +36,7 @@
 #define IMA_NEW_FILE		0x04000000
 #define EVM_IMMUTABLE_DIGSIG	0x08000000
 #define IMA_FAIL_UNVERIFIABLE_SIGS	0x10000000
+#define IMA_MODSIG_ALLOWED	0x20000000
 
 #define IMA_DO_MASK		(IMA_MEASURE | IMA_APPRAISE | IMA_AUDIT | \
 				 IMA_HASH | IMA_APPRAISE_SUBMASK)

