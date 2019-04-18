Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AADB0C10F0E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 03:53:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7ADB0214DA
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 03:53:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388182AbfDRDw6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Apr 2019 23:52:58 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33462 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388158AbfDRDw5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Apr 2019 23:52:57 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3I3o82p081168
        for <linux-crypto@vger.kernel.org>; Wed, 17 Apr 2019 23:52:56 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2rxh5nrxjs-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Wed, 17 Apr 2019 23:52:56 -0400
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <bauerman@linux.ibm.com>;
        Thu, 18 Apr 2019 04:52:55 +0100
Received: from b03cxnp07029.gho.boulder.ibm.com (9.17.130.16)
        by e35.co.us.ibm.com (192.168.1.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 18 Apr 2019 04:52:51 +0100
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3I3qn7E30736540
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Apr 2019 03:52:50 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B26E47805E;
        Thu, 18 Apr 2019 03:52:49 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41ECF7805F;
        Thu, 18 Apr 2019 03:52:44 +0000 (GMT)
Received: from morokweng.localdomain.com (unknown [9.85.230.182])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 18 Apr 2019 03:52:43 +0000 (GMT)
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
Subject: [PATCH v10 12/12] ima: Store the measurement again when appraising a modsig
Date:   Thu, 18 Apr 2019 00:51:20 -0300
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190418035120.2354-1-bauerman@linux.ibm.com>
References: <20190418035120.2354-1-bauerman@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19041803-0012-0000-0000-000017285CCE
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00010947; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000284; SDB=6.01190666; UDB=6.00623948; IPR=6.00971462;
 MB=3.00026492; MTD=3.00000008; XFM=3.00000015; UTC=2019-04-18 03:52:55
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19041803-0013-0000-0000-000056E990D9
Message-Id: <20190418035120.2354-13-bauerman@linux.ibm.com>
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

If the IMA template contains the "modsig" or "d-modsig" field, then the
modsig should be added to the measurement list when the file is appraised.

And that is what normally happens, but if a measurement rule caused a file
containing a modsig to be measured before a different rule causes it to be
appraised, the resulting measurement entry will not contain the modsig
because it is only fetched during appraisal. When the appraisal rule
triggers, it won't store a new measurement containing the modsig because
the file was already measured.

We need to detect that situation and store an additional measurement with
the modsig. This is done by adding an IMA_MEASURE action flag if we read a
modsig and the IMA template contains a modsig field.

Suggested-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
---
 security/integrity/ima/ima.h          |  1 +
 security/integrity/ima/ima_api.c      | 19 +++++++++++++++----
 security/integrity/ima/ima_main.c     | 14 +++++++++++---
 security/integrity/ima/ima_template.c | 24 ++++++++++++++++++++++++
 4 files changed, 51 insertions(+), 7 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 4e51290b149d..4e504c011b69 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -148,6 +148,7 @@ int ima_init_crypto(void);
 void ima_putc(struct seq_file *m, void *data, int datalen);
 void ima_print_digest(struct seq_file *m, u8 *digest, u32 size);
 struct ima_template_desc *ima_template_desc_current(void);
+bool ima_template_has_modsig(void);
 int ima_restore_measurement_entry(struct ima_template_entry *entry);
 int ima_restore_measurement_list(loff_t bufsize, void *buf);
 int ima_measurements_show(struct seq_file *m, void *v);
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 3ef48d516f02..663805887fac 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -212,6 +212,14 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 		char digest[IMA_MAX_DIGEST_SIZE];
 	} hash;
 
+	/*
+	 * Always collect the modsig, because IMA might have already collected
+	 * the file digest without collecting the modsig in a previous
+	 * measurement rule.
+	 */
+	if (modsig)
+		ima_collect_modsig(modsig, buf, size);
+
 	if (iint->flags & IMA_COLLECTED)
 		goto out;
 
@@ -245,9 +253,6 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 	memcpy(iint->ima_hash, &hash, length);
 	iint->version = i_version;
 
-	if (modsig)
-		ima_collect_modsig(modsig, buf, size);
-
 	/* Possibly temporary failure due to type of read (eg. O_DIRECT) */
 	if (!result)
 		iint->flags |= IMA_COLLECTED;
@@ -296,7 +301,13 @@ void ima_store_measurement(struct integrity_iint_cache *iint,
 					     .modsig = modsig };
 	int violation = 0;
 
-	if (iint->measured_pcrs & (0x1 << pcr))
+	/*
+	 * We still need to store the measurement in the case of MODSIG because
+	 * we only have its contents to put in the list at the time of
+	 * appraisal, but a file measurement from earlier might already exist in
+	 * the measurement list.
+	 */
+	if (iint->measured_pcrs & (0x1 << pcr) && !modsig)
 		return;
 
 	result = ima_alloc_init_template(&event_data, &entry);
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 8e6475854351..f91ed4189f98 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -282,9 +282,17 @@ static int process_measurement(struct file *file, const struct cred *cred,
 		/* read 'security.ima' */
 		xattr_len = ima_read_xattr(file_dentry(file), &xattr_value);
 
-		/* Read the appended modsig if allowed by the policy. */
-		if (iint->flags & IMA_MODSIG_ALLOWED)
-			ima_read_modsig(func, buf, size, &modsig);
+		/*
+		 * Read the appended modsig, if allowed by the policy, and allow
+		 * an additional measurement list entry, if needed, based on the
+		 * template format.
+		 */
+		if (iint->flags & IMA_MODSIG_ALLOWED) {
+			rc = ima_read_modsig(func, buf, size, &modsig);
+
+			if (!rc && ima_template_has_modsig())
+				action |= IMA_MEASURE;
+		}
 	}
 
 	hash_algo = ima_get_hash_algo(xattr_value, xattr_len);
diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index b05a14821a08..db3b4257e58b 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -57,6 +57,26 @@ static int template_desc_init_fields(const char *template_fmt,
 				     const struct ima_template_field ***fields,
 				     int *num_fields);
 
+/* Whether the current template has fields referencing a file's signature. */
+static bool template_has_modsig;
+
+static bool find_modsig_in_template(void)
+{
+	int i;
+
+	for (i = 0; i < ima_template->num_fields; i++)
+		if (!strcmp(ima_template->fields[i]->field_id, "modsig") ||
+		    !strcmp(ima_template->fields[i]->field_id, "d-modsig"))
+			return true;
+
+	return false;
+}
+
+bool ima_template_has_modsig(void)
+{
+	return template_has_modsig;
+}
+
 static int __init ima_template_setup(char *str)
 {
 	struct ima_template_desc *template_desc;
@@ -89,6 +109,8 @@ static int __init ima_template_setup(char *str)
 	}
 
 	ima_template = template_desc;
+	template_has_modsig = find_modsig_in_template();
+
 	return 1;
 }
 __setup("ima_template=", ima_template_setup);
@@ -108,6 +130,7 @@ static int __init ima_template_fmt_setup(char *str)
 
 	builtin_templates[num_templates - 1].fmt = str;
 	ima_template = builtin_templates + num_templates - 1;
+	template_has_modsig = find_modsig_in_template();
 
 	return 1;
 }
@@ -230,6 +253,7 @@ struct ima_template_desc *ima_template_desc_current(void)
 		ima_init_template_list();
 		ima_template =
 		    lookup_template_desc(CONFIG_IMA_DEFAULT_TEMPLATE);
+		template_has_modsig = find_modsig_in_template();
 	}
 	return ima_template;
 }

