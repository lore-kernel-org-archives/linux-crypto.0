From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: [PATCH v5 03/18] evm, ima: Remove superfluous parentheses
Date: Tue, 17 Oct 2017 22:53:16 -0200
Message-ID: <20171018005331.2688-4-bauerman@linux.vnet.ibm.com>
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

This patch removes unnecessary parentheses from all EVM and IMA files
touched by this patch series.

The difference from the previous patch is that it cleans up the files as a
whole, not just the lines that were already going to be modified by other
patches. It is separate from the previous one so that it can be easily
dropped if the churn and conflict potential is deemed not worth it.

Confirmed that the patch is correct by comparing the object files from
before and after the patch. They are identical.

Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
---
 security/integrity/evm/evm_crypto.c       |  2 +-
 security/integrity/evm/evm_main.c         | 13 +++++-----
 security/integrity/ima/ima_api.c          |  2 +-
 security/integrity/ima/ima_appraise.c     |  2 +-
 security/integrity/ima/ima_main.c         | 11 +++++----
 security/integrity/ima/ima_policy.c       | 41 ++++++++++++++++---------------
 security/integrity/ima/ima_template.c     | 25 +++++++++----------
 security/integrity/ima/ima_template_lib.c |  6 ++---
 8 files changed, 51 insertions(+), 51 deletions(-)

diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index bcd64baf8788..9c2d88c80b9d 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -199,7 +199,7 @@ static int evm_calc_hmac_or_hash(struct dentry *dentry,
 
 	error = -ENODATA;
 	for (xattrname = evm_config_xattrnames; *xattrname != NULL; xattrname++) {
-		if ((req_xattr_name && req_xattr_value)
+		if (req_xattr_name && req_xattr_value
 		    && !strcmp(*xattrname, req_xattr_name)) {
 			error = 0;
 			crypto_shash_update(desc, (const u8 *)req_xattr_value,
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 9826c02e2db8..37f062d38d5f 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -188,7 +188,7 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 	}
 
 	if (rc)
-		evm_status = (rc == -ENODATA) ?
+		evm_status = rc == -ENODATA ?
 				INTEGRITY_NOXATTRS : INTEGRITY_FAIL;
 out:
 	if (iint)
@@ -205,8 +205,8 @@ static int evm_protected_xattr(const char *req_xattr_name)
 
 	namelen = strlen(req_xattr_name);
 	for (xattrname = evm_config_xattrnames; *xattrname != NULL; xattrname++) {
-		if ((strlen(*xattrname) == namelen)
-		    && (strncmp(req_xattr_name, *xattrname, namelen) == 0)) {
+		if (strlen(*xattrname) == namelen
+		    && strncmp(req_xattr_name, *xattrname, namelen) == 0) {
 			found = 1;
 			break;
 		}
@@ -294,8 +294,8 @@ static int evm_protect_xattr(struct dentry *dentry, const char *xattr_name,
 		if (!posix_xattr_acl(xattr_name))
 			return 0;
 		evm_status = evm_verify_current_integrity(dentry);
-		if ((evm_status == INTEGRITY_PASS) ||
-		    (evm_status == INTEGRITY_NOXATTRS))
+		if (evm_status == INTEGRITY_PASS ||
+		    evm_status == INTEGRITY_NOXATTRS)
 			return 0;
 		goto out;
 	}
@@ -434,8 +434,7 @@ int evm_inode_setattr(struct dentry *dentry, struct iattr *attr)
 	if (!(ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID)))
 		return 0;
 	evm_status = evm_verify_current_integrity(dentry);
-	if ((evm_status == INTEGRITY_PASS) ||
-	    (evm_status == INTEGRITY_NOXATTRS))
+	if (evm_status == INTEGRITY_PASS || evm_status == INTEGRITY_NOXATTRS)
 		return 0;
 	integrity_audit_msg(AUDIT_INTEGRITY_METADATA, d_backing_inode(dentry),
 			    dentry->d_name.name, "appraise_metadata",
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index c7e8db0ea4c0..c6d346e9f708 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -54,7 +54,7 @@ int ima_alloc_init_template(struct ima_event_data *event_data,
 		u32 len;
 
 		result = field->field_init(event_data,
-					   &((*entry)->template_data[i]));
+					   &(*entry)->template_data[i]);
 		if (result != 0)
 			goto out;
 
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index bce0b36778bd..58c6a60c7e83 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -401,7 +401,7 @@ int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
 	result = ima_protect_xattr(dentry, xattr_name, xattr_value,
 				   xattr_value_len);
 	if (result == 1) {
-		if (!xattr_value_len || (xvalue->type >= IMA_XATTR_LAST))
+		if (!xattr_value_len || xvalue->type >= IMA_XATTR_LAST)
 			return -EINVAL;
 		ima_reset_appraise_flags(d_backing_inode(dentry),
 			xvalue->type == EVM_IMA_XATTR_DIGSIG);
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index e4ab8ef8016e..747a4fd9e2de 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -96,7 +96,7 @@ static void ima_rdwr_violation_check(struct file *file,
 				send_tomtou = true;
 		}
 	} else {
-		if ((atomic_read(&inode->i_writecount) > 0) && must_measure)
+		if (atomic_read(&inode->i_writecount) > 0 && must_measure)
 			send_writers = true;
 	}
 
@@ -123,7 +123,7 @@ static void ima_check_last_writer(struct integrity_iint_cache *iint,
 
 	inode_lock(inode);
 	if (atomic_read(&inode->i_writecount) == 1) {
-		if ((iint->version != inode->i_version) ||
+		if (iint->version != inode->i_version ||
 		    (iint->flags & IMA_NEW_FILE)) {
 			iint->flags &= ~(IMA_DONE_MASK | IMA_NEW_FILE);
 			iint->measured_pcrs = 0;
@@ -179,8 +179,9 @@ static int process_measurement(struct file *file, char *buf, loff_t size,
 	 * Included is the appraise submask.
 	 */
 	action = ima_get_action(inode, mask, func, &pcr);
-	violation_check = ((func == FILE_CHECK || func == MMAP_CHECK) &&
-			   (ima_policy_flag & IMA_MEASURE));
+
+	violation_check = (func == FILE_CHECK || func == MMAP_CHECK) &&
+			  (ima_policy_flag & IMA_MEASURE);
 	if (!action && !violation_check)
 		return 0;
 
@@ -260,7 +261,7 @@ static int process_measurement(struct file *file, char *buf, loff_t size,
 		__putname(pathbuf);
 out:
 	inode_unlock(inode);
-	if ((rc && must_appraise) && (ima_appraise & IMA_APPRAISE_ENFORCE))
+	if (rc && must_appraise && (ima_appraise & IMA_APPRAISE_ENFORCE))
 		return -EACCES;
 	return 0;
 }
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 95209a5f8595..efd8e1c60c10 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -41,8 +41,8 @@
 #define DONT_APPRAISE	0x0008
 #define AUDIT		0x0040
 
-#define INVALID_PCR(a) (((a) < 0) || \
-	(a) >= (FIELD_SIZEOF(struct integrity_iint_cache, measured_pcrs) * 8))
+#define INVALID_PCR(a) ((a) < 0 || \
+	(a) >= FIELD_SIZEOF(struct integrity_iint_cache, measured_pcrs) * 8)
 
 int ima_policy_flag;
 static int temp_ima_appraise;
@@ -193,7 +193,7 @@ static int __init policy_setup(char *str)
 	while ((p = strsep(&str, " |\n")) != NULL) {
 		if (*p == ' ')
 			continue;
-		if ((strcmp(p, "tcb") == 0) && !ima_policy)
+		if (strcmp(p, "tcb") == 0 && !ima_policy)
 			ima_policy = DEFAULT_TCB;
 		else if (strcmp(p, "appraise_tcb") == 0)
 			ima_use_appraise_tcb = 1;
@@ -254,13 +254,13 @@ static bool ima_match_rules(struct ima_rule_entry *rule, struct inode *inode,
 	int i;
 
 	if ((rule->flags & IMA_FUNC) &&
-	    (rule->func != func && func != POST_SETATTR))
+	    rule->func != func && func != POST_SETATTR)
 		return false;
 	if ((rule->flags & IMA_MASK) &&
-	    (rule->mask != mask && func != POST_SETATTR))
+	    rule->mask != mask && func != POST_SETATTR)
 		return false;
 	if ((rule->flags & IMA_INMASK) &&
-	    (!(rule->mask & mask) && func != POST_SETATTR))
+	    !(rule->mask & mask) && func != POST_SETATTR)
 		return false;
 	if ((rule->flags & IMA_FSMAGIC)
 	    && rule->fsmagic != inode->i_sb->s_magic)
@@ -314,7 +314,7 @@ static bool ima_match_rules(struct ima_rule_entry *rule, struct inode *inode,
 		default:
 			break;
 		}
-		if ((rc < 0) && (!retried)) {
+		if (rc < 0 && !retried) {
 			retried = 1;
 			ima_lsm_update_rules();
 			goto retry;
@@ -388,7 +388,7 @@ int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask,
 		else
 			actmask &= ~(entry->action | entry->action >> 1);
 
-		if ((pcr) && (entry->flags & IMA_PCR))
+		if (pcr && (entry->flags & IMA_PCR))
 			*pcr = entry->pcr;
 
 		if (!actmask)
@@ -627,7 +627,7 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 
 		if (result < 0)
 			break;
-		if ((*p == '\0') || (*p == ' ') || (*p == '\t'))
+		if (*p == '\0' || *p == ' ' || *p == '\t')
 			continue;
 		token = match_token(p, policy_tokens, args);
 		switch (token) {
@@ -686,8 +686,8 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 				entry->func = MODULE_CHECK;
 			else if (strcmp(args[0].from, "FIRMWARE_CHECK") == 0)
 				entry->func = FIRMWARE_CHECK;
-			else if ((strcmp(args[0].from, "FILE_MMAP") == 0)
-				|| (strcmp(args[0].from, "MMAP_CHECK") == 0))
+			else if (strcmp(args[0].from, "FILE_MMAP") == 0
+				|| strcmp(args[0].from, "MMAP_CHECK") == 0)
 				entry->func = MMAP_CHECK;
 			else if (strcmp(args[0].from, "BPRM_CHECK") == 0)
 				entry->func = BPRM_CHECK;
@@ -714,7 +714,7 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 			if (*from == '^')
 				from++;
 
-			if ((strcmp(from, "MAY_EXEC")) == 0)
+			if (strcmp(from, "MAY_EXEC") == 0)
 				entry->mask = MAY_EXEC;
 			else if (strcmp(from, "MAY_WRITE") == 0)
 				entry->mask = MAY_WRITE;
@@ -757,13 +757,13 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 			entry->uid_op = &uid_gt;
 		case Opt_uid_lt:
 		case Opt_euid_lt:
-			if ((token == Opt_uid_lt) || (token == Opt_euid_lt))
+			if (token == Opt_uid_lt || token == Opt_euid_lt)
 				entry->uid_op = &uid_lt;
 		case Opt_uid_eq:
 		case Opt_euid_eq:
-			uid_token = (token == Opt_uid_eq) ||
-				    (token == Opt_uid_gt) ||
-				    (token == Opt_uid_lt);
+			uid_token = token == Opt_uid_eq ||
+				    token == Opt_uid_gt ||
+				    token == Opt_uid_lt;
 
 			ima_log_string_op(ab, uid_token ? "uid" : "euid",
 					  args[0].from, entry->uid_op);
@@ -802,7 +802,8 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 			result = kstrtoul(args[0].from, 10, &lnum);
 			if (!result) {
 				entry->fowner = make_kuid(current_user_ns(), (uid_t)lnum);
-				if (!uid_valid(entry->fowner) || (((uid_t)lnum) != lnum))
+				if (!uid_valid(entry->fowner) ||
+				    (uid_t) lnum != lnum)
 					result = -EINVAL;
 				else
 					entry->flags |= IMA_FOWNER;
@@ -851,7 +852,7 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 			}
 
 			ima_log_string(ab, "appraise_type", args[0].from);
-			if ((strcmp(args[0].from, "imasig")) == 0)
+			if (strcmp(args[0].from, "imasig") == 0)
 				entry->flags |= IMA_DIGSIG_REQUIRED;
 			else
 				result = -EINVAL;
@@ -879,7 +880,7 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 			break;
 		}
 	}
-	if (!result && (entry->action == UNKNOWN))
+	if (!result && entry->action == UNKNOWN)
 		result = -EINVAL;
 	else if (entry->func == MODULE_CHECK)
 		temp_ima_appraise |= IMA_APPRAISE_MODULES;
@@ -1001,7 +1002,7 @@ void *ima_policy_next(struct seq_file *m, void *v, loff_t *pos)
 	rcu_read_unlock();
 	(*pos)++;
 
-	return (&entry->list == ima_rules) ? NULL : entry;
+	return &entry->list == ima_rules ? NULL : entry;
 }
 
 void ima_policy_stop(struct seq_file *m, void *v)
diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index 7412d0291ab9..3cc1d2763fd2 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -115,8 +115,8 @@ static struct ima_template_desc *lookup_template_desc(const char *name)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(template_desc, &defined_templates, list) {
-		if ((strcmp(template_desc->name, name) == 0) ||
-		    (strcmp(template_desc->fmt, name) == 0)) {
+		if (strcmp(template_desc->name, name) == 0 ||
+		    strcmp(template_desc->fmt, name) == 0) {
 			found = 1;
 			break;
 		}
@@ -233,13 +233,12 @@ int __init ima_init_template(void)
 	struct ima_template_desc *template = ima_template_desc_current();
 	int result;
 
-	result = template_desc_init_fields(template->fmt,
-					   &(template->fields),
-					   &(template->num_fields));
+	result = template_desc_init_fields(template->fmt, &template->fields,
+					   &template->num_fields);
 	if (result < 0)
 		pr_err("template %s init failed, result: %d\n",
-		       (strlen(template->name) ?
-		       template->name : template->fmt), result);
+		       strlen(template->name) ? template->name : template->fmt,
+		       result);
 
 	return result;
 }
@@ -367,10 +366,10 @@ int ima_restore_measurement_list(loff_t size, void *buf)
 	 *	      template-data-size, template-data
 	 */
 	bufendp = buf + khdr->buffer_size;
-	while ((bufp < bufendp) && (count++ < khdr->count)) {
+	while (bufp < bufendp && count++ < khdr->count) {
 		int enforce_mask = ENFORCE_FIELDS;
 
-		enforce_mask |= (count == khdr->count) ? ENFORCE_BUFEND : 0;
+		enforce_mask |= count == khdr->count ? ENFORCE_BUFEND : 0;
 		ret = ima_parse_buf(bufp, bufendp, &bufp, HDR__LAST, hdr, NULL,
 				    hdr_mask, enforce_mask, "entry header");
 		if (ret < 0)
@@ -407,8 +406,8 @@ int ima_restore_measurement_list(loff_t size, void *buf)
 		 * on boot.  As needed, initialize the other template formats.
 		 */
 		ret = template_desc_init_fields(template_desc->fmt,
-						&(template_desc->fields),
-						&(template_desc->num_fields));
+						&template_desc->fields,
+						&template_desc->num_fields);
 		if (ret < 0) {
 			pr_err("attempting to restore the template fmt \"%s\" \
 				failed\n", template_desc->fmt);
@@ -425,8 +424,8 @@ int ima_restore_measurement_list(loff_t size, void *buf)
 
 		memcpy(entry->digest, hdr[HDR_DIGEST].data,
 		       hdr[HDR_DIGEST].len);
-		entry->pcr = !ima_canonical_fmt ? *(hdr[HDR_PCR].data) :
-			     le32_to_cpu(*(hdr[HDR_PCR].data));
+		entry->pcr = !ima_canonical_fmt ? *hdr[HDR_PCR].data :
+			     le32_to_cpu(*hdr[HDR_PCR].data);
 		ret = ima_restore_measurement_entry(entry);
 		if (ret < 0)
 			break;
diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index 8bebcbb61162..d941260e979f 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -100,7 +100,7 @@ static void ima_show_template_data_binary(struct seq_file *m,
 					  enum data_formats datafmt,
 					  struct ima_field_data *field_data)
 {
-	u32 len = (show == IMA_SHOW_BINARY_OLD_STRING_FMT) ?
+	u32 len = show == IMA_SHOW_BINARY_OLD_STRING_FMT ?
 	    strlen(field_data->data) : field_data->len;
 
 	if (show != IMA_SHOW_BINARY_NO_FIELD_LEN) {
@@ -182,7 +182,7 @@ int ima_parse_buf(void *bufstartp, void *bufendp, void **bufcurp,
 
 	for (i = 0; i < maxfields; i++) {
 		if (len_mask == NULL || !test_bit(i, len_mask)) {
-			if (bufp > (bufendp - sizeof(u32)))
+			if (bufp > bufendp - sizeof(u32))
 				break;
 
 			fields[i].len = *(u32 *)bufp;
@@ -192,7 +192,7 @@ int ima_parse_buf(void *bufstartp, void *bufendp, void **bufcurp,
 			bufp += sizeof(u32);
 		}
 
-		if (bufp > (bufendp - fields[i].len))
+		if (bufp > bufendp - fields[i].len)
 			break;
 
 		fields[i].data = bufp;
