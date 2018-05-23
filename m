From: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Subject: [PATCH v7 14/14] ima: Store the measurement again when appraising a modsig
Date: Tue, 22 May 2018 21:12:53 -0300
Message-ID: <20180523001253.15247-15-bauerman@linux.ibm.com>
References: <20180523001253.15247-1-bauerman@linux.ibm.com>
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
        Thiago Jung Bauermann <bauerman@linux.ibm.com>
To: linux-integrity@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180523001253.15247-1-bauerman@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

If the IMA template contains the 'sig' field, then the modsig should be
added to the measurement list when the file is appraised, and that is what
normally happens.

But If a measurement rule caused a file containing a modsig to be measured
before a different rule causes it to be appraised, the resulting
measurement entry will not contain the modsig because it is only fetched
during appraisal. When the appraisal rule triggers, it won't store a new
measurement containing the modsig because the file was already measured.

We need to detect that situation and store an additional measurement with
the modsig. This is done by defining the appraise subaction flag
IMA_READ_MEASURE and testing for it in process_measurement().

Suggested-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
---
 security/integrity/ima/ima.h          |  1 +
 security/integrity/ima/ima_api.c      |  8 ++++-
 security/integrity/ima/ima_main.c     | 16 +++++++++-
 security/integrity/ima/ima_policy.c   | 59 ++++++++++++++++++++++++++++++++---
 security/integrity/ima/ima_template.c | 27 ++++++++++++++++
 security/integrity/integrity.h        |  9 ++++--
 6 files changed, 110 insertions(+), 10 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 33120c10a173..081e2b87cf9d 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -147,6 +147,7 @@ int ima_init_crypto(void);
 void ima_putc(struct seq_file *m, void *data, int datalen);
 void ima_print_digest(struct seq_file *m, u8 *digest, u32 size);
 struct ima_template_desc *ima_template_desc_current(void);
+bool ima_current_template_has_sig(void);
 int ima_restore_measurement_entry(struct ima_template_entry *entry);
 int ima_restore_measurement_list(loff_t bufsize, void *buf);
 int ima_measurements_show(struct seq_file *m, void *v);
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index bf88236b7a0b..73f6d4df66a7 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -288,7 +288,13 @@ void ima_store_measurement(struct integrity_iint_cache *iint,
 					    xattr_len, NULL};
 	int violation = 0;
 
-	if (iint->measured_pcrs & (0x1 << pcr))
+	/*
+	 * We still need to store the measurement in the case of MODSIG because
+	 * we only have its contents to put in the list at the time of
+	 * appraisal. See comment in store_measurement_again() for more details.
+	 */
+	if (iint->measured_pcrs & (0x1 << pcr) &&
+	    (!xattr_value || xattr_value->type != IMA_MODSIG))
 		return;
 
 	result = ima_alloc_init_template(&event_data, &entry);
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 9d32ce6c3df3..90e336a2b5c4 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -169,6 +169,20 @@ void ima_file_free(struct file *file)
 	ima_check_last_writer(iint, inode, file);
 }
 
+/*
+ * A file measurement might already exist in the measurement list. Based on
+ * policy, include an additional file measurement containing the appended
+ * signature and file hash, without the appended signature (i.e., the 'd-sig'
+ * field).
+ */
+static bool store_measurement_again(struct integrity_iint_cache *iint,
+				    struct evm_ima_xattr_data *xattr_value)
+{
+	return iint->flags & IMA_READ_MEASURE && xattr_value &&
+		xattr_value->type == IMA_MODSIG &&
+		ima_current_template_has_sig();
+}
+
 static int process_measurement(struct file *file, const struct cred *cred,
 			       u32 secid, char *buf, loff_t size, int mask,
 			       enum ima_hooks func, int opened)
@@ -302,7 +316,7 @@ static int process_measurement(struct file *file, const struct cred *cred,
 	if (!pathbuf)	/* ima_rdwr_violation possibly pre-fetched */
 		pathname = ima_d_path(&file->f_path, &pathbuf, filename);
 
-	if (action & IMA_MEASURE)
+	if (action & IMA_MEASURE || store_measurement_again(iint, xattr_value))
 		ima_store_measurement(iint, file, pathname,
 				      xattr_value, xattr_len, pcr);
 	if (rc == 0 && (action & IMA_APPRAISE_SUBMASK)) {
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 66d0d3bcf1b2..5ad5ced3b352 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -10,6 +10,9 @@
  *	- initialize default measure policy rules
  *
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/list.h>
 #include <linux/fs.h>
@@ -341,7 +344,8 @@ static bool ima_match_rules(struct ima_rule_entry *rule, struct inode *inode,
  * In addition to knowing that we need to appraise the file in general,
  * we need to differentiate between calling hooks, for hook specific rules.
  */
-static int get_subaction(struct ima_rule_entry *rule, enum ima_hooks func)
+static int get_appraise_subaction(struct ima_rule_entry *rule,
+				  enum ima_hooks func)
 {
 	if (!(rule->flags & IMA_FUNC))
 		return IMA_FILE_APPRAISE;
@@ -362,6 +366,15 @@ static int get_subaction(struct ima_rule_entry *rule, enum ima_hooks func)
 	}
 }
 
+static int get_measure_subaction(struct ima_rule_entry *rule,
+				 enum ima_hooks func)
+{
+	if (rule->flags & IMA_FUNC && ima_hook_supports_modsig(func))
+		return IMA_READ_MEASURE;
+	else
+		return 0;
+}
+
 /**
  * ima_match_policy - decision based on LSM and other conditions
  * @inode: pointer to an inode for which the policy decision is being made
@@ -398,11 +411,12 @@ int ima_match_policy(struct inode *inode, const struct cred *cred, u32 secid,
 
 		action |= entry->action & IMA_DO_MASK;
 		if (entry->action & IMA_APPRAISE) {
-			action |= get_subaction(entry, func);
+			action |= get_appraise_subaction(entry, func);
 			action &= ~IMA_HASH;
 			if (ima_fail_unverifiable_sigs)
 				action |= IMA_FAIL_UNVERIFIABLE_SIGS;
-		}
+		} else if (entry->action & IMA_MEASURE)
+			action |= get_measure_subaction(entry, func);
 
 		if (entry->action & IMA_DO_MASK)
 			actmask &= ~(entry->action | entry->action << 1);
@@ -642,6 +656,40 @@ static void ima_log_string(struct audit_buffer *ab, char *key, char *value)
 	ima_log_string_op(ab, key, value, NULL);
 }
 
+/*
+ * To validate the appended signature included in the measurement list requires
+ * the file hash, without the appended signature (i.e., the 'd-sig' field).
+ * Therefore, notify the user if they have the 'sig' field but not the 'd-sig'
+ * field in the template.
+ */
+static void check_current_template_modsig(void)
+{
+#define MSG "template with 'sig' field also needs 'd-sig' field when modsig is allowed\n"
+	struct ima_template_desc *template;
+	bool has_sig, has_dsig;
+	static bool checked;
+	int i;
+
+	/* We only need to notify the user once. */
+	if (checked)
+		return;
+
+	has_sig = has_dsig = false;
+	template = ima_template_desc_current();
+	for (i = 0; i < template->num_fields; i++) {
+		if (!strcmp(template->fields[i]->field_id, "sig"))
+			has_sig = true;
+		else if (!strcmp(template->fields[i]->field_id, "d-sig"))
+			has_dsig = true;
+	}
+
+	if (has_sig && !has_dsig)
+		pr_notice(MSG);
+
+	checked = true;
+#undef MSG
+}
+
 static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 {
 	struct audit_buffer *ab;
@@ -920,10 +968,11 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
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
index 36fc32f538b5..967c287dcdfb 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -230,6 +230,33 @@ struct ima_template_desc *ima_template_desc_current(void)
 	return ima_template;
 }
 
+/*
+ * Tells whether the current template has fields which reference a file's
+ * signature.
+ */
+bool ima_current_template_has_sig(void)
+{
+	static int ima_template_has_sig = -1;
+
+	if (ima_template_has_sig < 0) {
+		struct ima_template_desc *template;
+		int i;
+
+		template = ima_template_desc_current();
+		for (i = 0; i < template->num_fields; i++)
+			if (!strcmp(template->fields[i]->field_id, "sig") ||
+			    !strcmp(template->fields[i]->field_id, "d-sig")) {
+				ima_template_has_sig = 1;
+				break;
+			}
+
+		if (ima_template_has_sig < 0)
+			ima_template_has_sig = 0;
+	}
+
+	return ima_template_has_sig;
+}
+
 int __init ima_init_template(void)
 {
 	struct ima_template_desc *template = ima_template_desc_current();
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index b38339c02541..a85b83519fc8 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -38,12 +38,13 @@
 #define IMA_MODSIG_ALLOWED	0x20000000
 
 #define IMA_DO_MASK		(IMA_MEASURE | IMA_APPRAISE | IMA_AUDIT | \
-				 IMA_HASH | IMA_APPRAISE_SUBMASK)
+				 IMA_HASH | IMA_APPRAISE_SUBMASK | \
+				 IMA_READ_MEASURE)
 #define IMA_DONE_MASK		(IMA_MEASURED | IMA_APPRAISED | IMA_AUDITED | \
 				 IMA_HASHED | IMA_COLLECTED | \
-				 IMA_APPRAISED_SUBMASK)
+				 IMA_APPRAISED_SUBMASK | IMA_READ_MEASURED)
 
-/* iint subaction appraise cache flags */
+/* iint subaction appraise and measure cache flags */
 #define IMA_FILE_APPRAISE	0x00001000
 #define IMA_FILE_APPRAISED	0x00002000
 #define IMA_MMAP_APPRAISE	0x00004000
@@ -54,6 +55,8 @@
 #define IMA_READ_APPRAISED	0x00080000
 #define IMA_CREDS_APPRAISE	0x00100000
 #define IMA_CREDS_APPRAISED	0x00200000
+#define IMA_READ_MEASURE	0x00400000
+#define IMA_READ_MEASURED	0x00800000
 #define IMA_APPRAISE_SUBMASK	(IMA_FILE_APPRAISE | IMA_MMAP_APPRAISE | \
 				 IMA_BPRM_APPRAISE | IMA_READ_APPRAISE | \
 				 IMA_CREDS_APPRAISE)
