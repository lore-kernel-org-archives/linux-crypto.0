Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE88C282DD
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 03:53:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE8F1214DA
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 03:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388161AbfDRDwx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Apr 2019 23:52:53 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40320 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388162AbfDRDwx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Apr 2019 23:52:53 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3I3o822114651
        for <linux-crypto@vger.kernel.org>; Wed, 17 Apr 2019 23:52:51 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2rxdx57740-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Wed, 17 Apr 2019 23:52:50 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <bauerman@linux.ibm.com>;
        Thu, 18 Apr 2019 04:52:50 +0100
Received: from b03cxnp07028.gho.boulder.ibm.com (9.17.130.15)
        by e34.co.us.ibm.com (192.168.1.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 18 Apr 2019 04:52:44 +0100
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3I3qgYW22151212
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Apr 2019 03:52:42 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5BC67805C;
        Thu, 18 Apr 2019 03:52:42 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 371BF7805E;
        Thu, 18 Apr 2019 03:52:38 +0000 (GMT)
Received: from morokweng.localdomain.com (unknown [9.85.230.182])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 18 Apr 2019 03:52:37 +0000 (GMT)
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
Subject: [PATCH v10 11/12] ima: Define ima-modsig template
Date:   Thu, 18 Apr 2019 00:51:19 -0300
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190418035120.2354-1-bauerman@linux.ibm.com>
References: <20190418035120.2354-1-bauerman@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19041803-0016-0000-0000-000009A21AD5
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00010947; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000284; SDB=6.01190666; UDB=6.00623948; IPR=6.00971462;
 MB=3.00026492; MTD=3.00000008; XFM=3.00000015; UTC=2019-04-18 03:52:48
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19041803-0017-0000-0000-000042DB34C7
Message-Id: <20190418035120.2354-12-bauerman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-18_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904180023
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Define new "d-modsig" template field which holds the digest that is
expected to match the one contained in the modsig, and also new "modsig"
template field which holds the appended file signature.

Add a new "ima-modsig" defined template descriptor with the new fields as
well as the ones from the "ima-sig" descriptor.

Change ima_store_measurement() to accept a struct modsig * argument so that
it can be passed along to the templates via struct ima_event_data.

Suggested-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
---
 Documentation/security/IMA-templates.rst  |  7 ++-
 security/integrity/ima/ima.h              | 21 +++++++-
 security/integrity/ima/ima_api.c          |  6 ++-
 security/integrity/ima/ima_main.c         |  2 +-
 security/integrity/ima/ima_modsig.c       | 19 +++++++
 security/integrity/ima/ima_policy.c       | 42 +++++++++++++++-
 security/integrity/ima/ima_template.c     |  7 ++-
 security/integrity/ima/ima_template_lib.c | 60 ++++++++++++++++++++++-
 security/integrity/ima/ima_template_lib.h |  4 ++
 9 files changed, 158 insertions(+), 10 deletions(-)

diff --git a/Documentation/security/IMA-templates.rst b/Documentation/security/IMA-templates.rst
index 2cd0e273cc9a..8da20b444be0 100644
--- a/Documentation/security/IMA-templates.rst
+++ b/Documentation/security/IMA-templates.rst
@@ -68,15 +68,18 @@ descriptors by adding their identifier to the format string
  - 'd-ng': the digest of the event, calculated with an arbitrary hash
    algorithm (field format: [<hash algo>:]digest, where the digest
    prefix is shown only if the hash algorithm is not SHA1 or MD5);
+ - 'd-modsig': the digest of the event without the appended modsig;
  - 'n-ng': the name of the event, without size limitations;
- - 'sig': the file signature.
+ - 'sig': the file signature;
+ - 'modsig' the appended file signature.
 
 
 Below, there is the list of defined template descriptors:
 
  - "ima": its format is ``d|n``;
  - "ima-ng" (default): its format is ``d-ng|n-ng``;
- - "ima-sig": its format is ``d-ng|n-ng|sig``.
+ - "ima-sig": its format is ``d-ng|n-ng|sig``;
+ - "ima-modsig": its format is ``d-ng|n-ng|sig|d-modsig|modsig``.
 
 
 
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index e051477badf4..4e51290b149d 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -64,6 +64,7 @@ struct ima_event_data {
 	const unsigned char *filename;
 	struct evm_ima_xattr_data *xattr_value;
 	int xattr_len;
+	const struct modsig *modsig;
 	const char *violation;
 };
 
@@ -205,7 +206,8 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 void ima_store_measurement(struct integrity_iint_cache *iint, struct file *file,
 			   const unsigned char *filename,
 			   struct evm_ima_xattr_data *xattr_value,
-			   int xattr_len, int pcr);
+			   int xattr_len, const struct modsig *modsig,
+			   int pcr);
 void ima_audit_measurement(struct integrity_iint_cache *iint,
 			   const unsigned char *filename);
 int ima_alloc_init_template(struct ima_event_data *event_data,
@@ -303,6 +305,10 @@ bool ima_hook_supports_modsig(enum ima_hooks func);
 int ima_read_modsig(enum ima_hooks func, const void *buf, loff_t buf_len,
 		    struct modsig **modsig);
 void ima_collect_modsig(struct modsig *modsig, const void *buf, loff_t size);
+int ima_get_modsig_digest(const struct modsig *modsig, enum hash_algo *algo,
+			  const u8 **digest, u32 *digest_size);
+int ima_modsig_serialize(const struct modsig *modsig, const void **data,
+			 u32 *data_len);
 void ima_free_modsig(struct modsig *modsig);
 #else
 static inline bool ima_hook_supports_modsig(enum ima_hooks func)
@@ -321,6 +327,19 @@ static inline void ima_collect_modsig(struct modsig *modsig, const void *buf,
 {
 }
 
+static inline int ima_get_modsig_digest(const struct modsig *modsig,
+					enum hash_algo *algo,
+					const u8 **digest, u32 *digest_size)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int ima_modsig_serialize(const struct modsig *modsig,
+				       const void **data, u32 *data_len)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline void ima_free_modsig(struct modsig *modsig)
 {
 }
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 7c01b0a57a5a..3ef48d516f02 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -281,7 +281,8 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 void ima_store_measurement(struct integrity_iint_cache *iint,
 			   struct file *file, const unsigned char *filename,
 			   struct evm_ima_xattr_data *xattr_value,
-			   int xattr_len, int pcr)
+			   int xattr_len, const struct modsig *modsig,
+			   int pcr)
 {
 	static const char op[] = "add_template_measure";
 	static const char audit_cause[] = "ENOMEM";
@@ -291,7 +292,8 @@ void ima_store_measurement(struct integrity_iint_cache *iint,
 	struct ima_event_data event_data = { .iint = iint, .file = file,
 					     .filename = filename,
 					     .xattr_value = xattr_value,
-					     .xattr_len = xattr_len };
+					     .xattr_len = xattr_len,
+					     .modsig = modsig };
 	int violation = 0;
 
 	if (iint->measured_pcrs & (0x1 << pcr))
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index b5e44d03a0e3..8e6475854351 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -298,7 +298,7 @@ static int process_measurement(struct file *file, const struct cred *cred,
 
 	if (action & IMA_MEASURE)
 		ima_store_measurement(iint, file, pathname,
-				      xattr_value, xattr_len, pcr);
+				      xattr_value, xattr_len, modsig, pcr);
 	if (rc == 0 && (action & IMA_APPRAISE_SUBMASK)) {
 		inode_lock(inode);
 		rc = ima_appraise_measurement(func, iint, file, pathname,
diff --git a/security/integrity/ima/ima_modsig.c b/security/integrity/ima/ima_modsig.c
index 22a49f127437..3956a40ba60c 100644
--- a/security/integrity/ima/ima_modsig.c
+++ b/security/integrity/ima/ima_modsig.c
@@ -140,6 +140,25 @@ int ima_modsig_verify(struct key *keyring, const struct modsig *modsig)
 					VERIFYING_MODULE_SIGNATURE, NULL, NULL);
 }
 
+int ima_get_modsig_digest(const struct modsig *modsig, enum hash_algo *algo,
+			  const u8 **digest, u32 *digest_size)
+{
+	*algo = modsig->hash_algo;
+	*digest = modsig->digest;
+	*digest_size = modsig->digest_size;
+
+	return 0;
+}
+
+int ima_modsig_serialize(const struct modsig *modsig, const void **data,
+			 u32 *data_len)
+{
+	*data = &modsig->raw_pkcs7;
+	*data_len = modsig->raw_pkcs7_len;
+
+	return 0;
+}
+
 void ima_free_modsig(struct modsig *modsig)
 {
 	if (!modsig)
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index a7a20a8c15c1..65989ffc05b1 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -10,6 +10,9 @@
  *	- initialize default measure policy rules
  *
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/fs.h>
@@ -756,6 +759,40 @@ static void ima_log_string(struct audit_buffer *ab, char *key, char *value)
 	ima_log_string_op(ab, key, value, NULL);
 }
 
+/*
+ * Validating the appended signature included in the measurement list requires
+ * the file hash calculated without the appended signature (i.e., the 'd-modsig'
+ * field). Therefore, notify the user if they have the 'modsig' field but not
+ * the 'd-modsig' field in the template.
+ */
+static void check_current_template_modsig(void)
+{
+#define MSG "template with 'modsig' field also needs 'd-modsig' field\n"
+	struct ima_template_desc *template;
+	bool has_modsig, has_dmodsig;
+	static bool checked;
+	int i;
+
+	/* We only need to notify the user once. */
+	if (checked)
+		return;
+
+	has_modsig = has_dmodsig = false;
+	template = ima_template_desc_current();
+	for (i = 0; i < template->num_fields; i++) {
+		if (!strcmp(template->fields[i]->field_id, "modsig"))
+			has_modsig = true;
+		else if (!strcmp(template->fields[i]->field_id, "d-modsig"))
+			has_dmodsig = true;
+	}
+
+	if (has_modsig && !has_dmodsig)
+		pr_notice(MSG);
+
+	checked = true;
+#undef MSG
+}
+
 static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 {
 	struct audit_buffer *ab;
@@ -1039,10 +1076,11 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 			if ((strcmp(args[0].from, "imasig")) == 0)
 				entry->flags |= IMA_DIGSIG_REQUIRED;
 			else if (ima_hook_supports_modsig(entry->func) &&
-				 strcmp(args[0].from, "imasig|modsig") == 0)
+				 strcmp(args[0].from, "imasig|modsig") == 0) {
 				entry->flags |= IMA_DIGSIG_REQUIRED
 						| IMA_MODSIG_ALLOWED;
-			else
+				check_current_template_modsig();
+			} else
 				result = -EINVAL;
 			break;
 		case Opt_permit_directio:
diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index b631b8bc7624..b05a14821a08 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -26,6 +26,7 @@ static struct ima_template_desc builtin_templates[] = {
 	{.name = IMA_TEMPLATE_IMA_NAME, .fmt = IMA_TEMPLATE_IMA_FMT},
 	{.name = "ima-ng", .fmt = "d-ng|n-ng"},
 	{.name = "ima-sig", .fmt = "d-ng|n-ng|sig"},
+	{.name = "ima-modsig", .fmt = "d-ng|n-ng|sig|d-modsig|modsig"},
 	{.name = "", .fmt = ""},	/* placeholder for a custom format */
 };
 
@@ -43,8 +44,12 @@ static const struct ima_template_field supported_fields[] = {
 	 .field_show = ima_show_template_string},
 	{.field_id = "sig", .field_init = ima_eventsig_init,
 	 .field_show = ima_show_template_sig},
+	{.field_id = "d-modsig", .field_init = ima_eventdigest_modsig_init,
+	 .field_show = ima_show_template_digest_ng},
+	{.field_id = "modsig", .field_init = ima_eventmodsig_init,
+	 .field_show = ima_show_template_sig},
 };
-#define MAX_TEMPLATE_NAME_LEN 15
+#define MAX_TEMPLATE_NAME_LEN sizeof("d|n|d-ng|n-ng|sig|d-modisg|modsig")
 
 static struct ima_template_desc *ima_template;
 static struct ima_template_desc *lookup_template_desc(const char *name);
diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index 513b457ae900..f549710f58ce 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -223,7 +223,8 @@ int ima_parse_buf(void *bufstartp, void *bufendp, void **bufcurp,
 	return 0;
 }
 
-static int ima_eventdigest_init_common(u8 *digest, u32 digestsize, u8 hash_algo,
+static int ima_eventdigest_init_common(const u8 *digest, u32 digestsize,
+				       u8 hash_algo,
 				       struct ima_field_data *field_data)
 {
 	/*
@@ -326,6 +327,41 @@ int ima_eventdigest_ng_init(struct ima_event_data *event_data,
 					   hash_algo, field_data);
 }
 
+/*
+ * This function writes the digest of the file which is expected to match the
+ * digest contained in the file's embedded signature.
+ */
+int ima_eventdigest_modsig_init(struct ima_event_data *event_data,
+				struct ima_field_data *field_data)
+{
+	enum hash_algo hash_algo;
+	const u8 *cur_digest;
+	u32 cur_digestsize;
+
+	if (!event_data->modsig)
+		return 0;
+
+	if (event_data->violation) {
+		/* Recording a violation. */
+		hash_algo = HASH_ALGO_SHA1;
+		cur_digest = NULL;
+		cur_digestsize = 0;
+	} else {
+		int rc;
+
+		rc = ima_get_modsig_digest(event_data->modsig, &hash_algo,
+					   &cur_digest, &cur_digestsize);
+		if (rc)
+			return rc;
+		else if (hash_algo == HASH_ALGO__LAST || cur_digestsize == 0)
+			/* There was some error collecting the digest. */
+			return -EINVAL;
+	}
+
+	return ima_eventdigest_init_common(cur_digest, cur_digestsize,
+					   hash_algo, field_data);
+}
+
 static int ima_eventname_init_common(struct ima_event_data *event_data,
 				     struct ima_field_data *field_data,
 				     bool size_limit)
@@ -389,3 +425,25 @@ int ima_eventsig_init(struct ima_event_data *event_data,
 	return ima_write_template_field_data(xattr_value, event_data->xattr_len,
 					     DATA_FMT_HEX, field_data);
 }
+
+int ima_eventmodsig_init(struct ima_event_data *event_data,
+			 struct ima_field_data *field_data)
+{
+	const void *data;
+	u32 data_len;
+	int rc;
+
+	if (!event_data->modsig)
+		return 0;
+
+	/*
+	 * The xattr_value for IMA_MODSIG is a runtime structure containing
+	 * pointers. Get its raw data instead.
+	 */
+	rc = ima_modsig_serialize(event_data->modsig, &data, &data_len);
+	if (rc)
+		return rc;
+
+	return ima_write_template_field_data(data, data_len,
+					     DATA_FMT_HEX, field_data);
+}
diff --git a/security/integrity/ima/ima_template_lib.h b/security/integrity/ima/ima_template_lib.h
index 6a3d8b831deb..1d7c690ebae5 100644
--- a/security/integrity/ima/ima_template_lib.h
+++ b/security/integrity/ima/ima_template_lib.h
@@ -38,8 +38,12 @@ int ima_eventname_init(struct ima_event_data *event_data,
 		       struct ima_field_data *field_data);
 int ima_eventdigest_ng_init(struct ima_event_data *event_data,
 			    struct ima_field_data *field_data);
+int ima_eventdigest_modsig_init(struct ima_event_data *event_data,
+				struct ima_field_data *field_data);
 int ima_eventname_ng_init(struct ima_event_data *event_data,
 			  struct ima_field_data *field_data);
 int ima_eventsig_init(struct ima_event_data *event_data,
 		      struct ima_field_data *field_data);
+int ima_eventmodsig_init(struct ima_event_data *event_data,
+			 struct ima_field_data *field_data);
 #endif /* __LINUX_IMA_TEMPLATE_LIB_H */

