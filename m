From: =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
Subject: [PATCH 1/5] Add general crypto auditing infrastructure
Date: Wed, 24 Nov 2010 18:05:51 +0100
Message-ID: <1290618355-31193-2-git-send-email-mitr@redhat.com>
References: <1290618355-31193-1-git-send-email-mitr@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-audit@redhat.com, linux-crypto@vger.kernel.org,
	=?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
To: eparis@redhat.com, herbert@gondor.hengli.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800Ab0KXRGM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Nov 2010 12:06:12 -0500
In-Reply-To: <1290618355-31193-1-git-send-email-mitr@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Collect audited crypto operations in a list, because a single _exit()
can cause several AF_ALG sockets to be closed, and each needs to be
audited.

Add the AUDIT_CRYPTO_OP field so that crypto operations are not audited
by default, but auditing can be enabled using a rule (probably
"-F crypto_op!=3D0").

Signed-off-by: Miloslav Trma=C4=8D <mitr@redhat.com>
---
 include/linux/audit.h |   22 +++++++++++
 kernel/auditfilter.c  |    2 +
 kernel/auditsc.c      |   97 +++++++++++++++++++++++++++++++++++++++++=
++++++++
 3 files changed, 121 insertions(+), 0 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index f391d45..a9516da 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -122,6 +122,8 @@
 #define AUDIT_MAC_UNLBL_STCADD	1416	/* NetLabel: add a static label */
 #define AUDIT_MAC_UNLBL_STCDEL	1417	/* NetLabel: del a static label */
=20
+#define AUDIT_CRYPTO_USERSPACE_OP   1600 /* User-space crypto operatio=
n */
+
 #define AUDIT_FIRST_KERN_ANOM_MSG   1700
 #define AUDIT_LAST_KERN_ANOM_MSG    1799
 #define AUDIT_ANOM_PROMISCUOUS      1700 /* Device changed promiscuous=
 mode */
@@ -219,6 +221,7 @@
 #define AUDIT_PERM	106
 #define AUDIT_DIR	107
 #define AUDIT_FILETYPE	108
+#define AUDIT_CRYPTO_OP	109
=20
 #define AUDIT_ARG0      200
 #define AUDIT_ARG1      (AUDIT_ARG0+1)
@@ -314,6 +317,13 @@ enum {
 #define AUDIT_PERM_READ		4
 #define AUDIT_PERM_ATTR		8
=20
+#define AUDIT_CRYPTO_OP_TFM_NEW		1
+#define AUDIT_CRYPTO_OP_TFM_KEY_IMPORT	2
+#define AUDIT_CRYPTO_OP_TFM_DEL		3
+#define AUDIT_CRYPTO_OP_CTX_NEW		4
+#define AUDIT_CRYPTO_OP_CTX_OP		5
+#define AUDIT_CRYPTO_OP_CTX_DEL		6
+
 struct audit_status {
 	__u32		mask;		/* Bit mask for valid entries */
 	__u32		enabled;	/* 1 =3D enabled, 0 =3D disabled */
@@ -478,6 +488,8 @@ extern int __audit_log_bprm_fcaps(struct linux_binp=
rm *bprm,
 				  const struct cred *new,
 				  const struct cred *old);
 extern void __audit_log_capset(pid_t pid, const struct cred *new, cons=
t struct cred *old);
+extern int __audit_log_crypto_op(int op, int tfm, int ctx, int ctx2,
+				 const char *algorithm, const char *operation);
=20
 static inline void audit_ipc_obj(struct kern_ipc_perm *ipcp)
 {
@@ -531,6 +543,15 @@ static inline void audit_log_capset(pid_t pid, con=
st struct cred *new,
 		__audit_log_capset(pid, new, old);
 }
=20
+static inline int audit_log_crypto_op(int op, int tfm, int ctx, int ct=
x2,
+				      const char *algorithm,
+				      const char *operation)
+{
+	if (unlikely(!audit_dummy_context()))
+		return __audit_log_crypto_op(op, tfm, ctx, ctx2, algorithm, operatio=
n);
+	return 0;
+}
+
 extern int audit_n_rules;
 extern int audit_signals;
 #else
@@ -564,6 +585,7 @@ extern int audit_signals;
 #define audit_mq_getsetattr(d,s) ((void)0)
 #define audit_log_bprm_fcaps(b, ncr, ocr) ({ 0; })
 #define audit_log_capset(pid, ncr, ocr) ((void)0)
+#define audit_log_crypto_op(op, tfm, ctx, ctx2, algorithm, operation) =
(0)
 #define audit_ptrace(t) ((void)0)
 #define audit_n_rules 0
 #define audit_signals 0
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index ce08041..6f35eed 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -364,6 +364,7 @@ static struct audit_entry *audit_rule_to_entry(stru=
ct audit_rule *rule)
 		case AUDIT_DEVMINOR:
 		case AUDIT_EXIT:
 		case AUDIT_SUCCESS:
+		case AUDIT_CRYPTO_OP:
 			/* bit ops are only useful on syscall args */
 			if (f->op =3D=3D Audit_bitmask || f->op =3D=3D Audit_bittest)
 				goto exit_free;
@@ -454,6 +455,7 @@ static struct audit_entry *audit_data_to_entry(stru=
ct audit_rule_data *data,
 		case AUDIT_DEVMINOR:
 		case AUDIT_EXIT:
 		case AUDIT_SUCCESS:
+		case AUDIT_CRYPTO_OP:
 		case AUDIT_ARG0:
 		case AUDIT_ARG1:
 		case AUDIT_ARG2:
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 3828ad5..e9761ad 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -158,6 +158,16 @@ struct audit_aux_data_capset {
 	struct audit_cap_data	cap;
 };
=20
+struct audit_aux_data_crypto_op {
+	struct audit_aux_data	d;
+	int			op;
+	int			tfm;
+	int			ctx;	    /* -1 means N/A */
+	int			ctx2;	    /* -1 means N/A */
+	const char		*algorithm; /* NULL means N/A */
+	const char		*operation; /* NULL means N/A */
+};
+
 struct audit_tree_refs {
 	struct audit_tree_refs *next;
 	struct audit_chunk *c[31];
@@ -633,6 +643,24 @@ static int audit_filter_rules(struct task_struct *=
tsk,
 		case AUDIT_FILETYPE:
 			result =3D audit_match_filetype(ctx, f->val);
 			break;
+		case AUDIT_CRYPTO_OP: {
+			struct audit_aux_data *aux;
+
+			if (!ctx)
+				break;
+			for (aux =3D ctx->aux; aux; aux =3D aux->next) {
+				struct audit_aux_data_crypto_op *ax;
+
+				if (aux->type !=3D AUDIT_CRYPTO_USERSPACE_OP)
+					continue;
+				ax =3D (void *)aux;
+				result =3D audit_comparator(ax->op, f->op,
+							  f->val);
+				if (result)
+					break;
+			}
+			break;
+		}
 		}
=20
 		if (!result) {
@@ -1201,6 +1229,37 @@ static void audit_log_cap(struct audit_buffer *a=
b, char *prefix, kernel_cap_t *c
 	}
 }
=20
+static void log_crypto_op(struct audit_buffer *ab,
+			  const struct audit_aux_data_crypto_op *crypto)
+{
+	static const char *const ops[] =3D {
+		[AUDIT_CRYPTO_OP_TFM_NEW] =3D "tfm_new",
+		[AUDIT_CRYPTO_OP_TFM_KEY_IMPORT] =3D "tfm_key_import",
+		[AUDIT_CRYPTO_OP_TFM_DEL] =3D "tfm_del",
+		[AUDIT_CRYPTO_OP_CTX_NEW] =3D "ctx_new",
+		[AUDIT_CRYPTO_OP_CTX_OP] =3D "ctx_op",
+		[AUDIT_CRYPTO_OP_CTX_DEL] =3D "ctx_del",
+	};
+
+	if (crypto->op < ARRAY_SIZE(ops) && ops[crypto->op] !=3D NULL)
+		audit_log_format(ab, "crypto_op=3D%s", ops[crypto->op]);
+	else
+		audit_log_format(ab, "crypto_op=3D%d", crypto->op);
+	audit_log_format(ab, " tfm=3D%d", crypto->tfm);
+	if (crypto->ctx !=3D -1)
+		audit_log_format(ab, " ctx=3D%d", crypto->ctx);
+	if (crypto->ctx2 !=3D -1)
+		audit_log_format(ab, " ctx2=3D%d", crypto->ctx2);
+	if (crypto->algorithm !=3D NULL) {
+		audit_log_format(ab, " algorithm=3D");
+		audit_log_string(ab, crypto->algorithm);
+	}
+	if (crypto->operation !=3D NULL) {
+		audit_log_format(ab, " operation=3D");
+		audit_log_string(ab, crypto->operation);
+	}
+}
+
 static void audit_log_fcaps(struct audit_buffer *ab, struct audit_name=
s *name)
 {
 	kernel_cap_t *perm =3D &name->fcap.permitted;
@@ -1404,6 +1463,11 @@ static void audit_log_exit(struct audit_context =
*context, struct task_struct *ts
 			audit_log_cap(ab, "new_pe", &axs->new_pcap.effective);
 			break; }
=20
+		case AUDIT_CRYPTO_USERSPACE_OP: {
+			struct audit_aux_data_crypto_op *axc =3D (void *)aux;
+			log_crypto_op(ab, axc);
+			break; }
+
 		}
 		audit_log_end(ab);
 	}
@@ -2464,6 +2528,39 @@ int __audit_log_bprm_fcaps(struct linux_binprm *=
bprm,
 }
=20
 /**
+ * __audit_log_crypto_op - store information about an user-space crypt=
o op
+ * @op: AUDIT_CRYPTO_OP_*
+ * @tfm: unique transform ID
+ * @ctx: unique context ID, or -1
+ * @ctx2: secondary context ID, or -1
+ * @algorithm: algorithm (crypto API transform) name, or NULL
+ * @operation: more detailed operation description, or NULL
+ */
+int __audit_log_crypto_op(int op, int tfm, int ctx, int ctx2,
+			  const char *algorithm, const char *operation)
+{
+	struct audit_aux_data_crypto_op *ax;
+	struct audit_context *context =3D current->audit_context;
+
+	ax =3D kmalloc(sizeof(*ax), GFP_KERNEL);
+	if (!ax)
+		return -ENOMEM;
+
+	ax->d.type =3D AUDIT_CRYPTO_USERSPACE_OP;
+	ax->d.next =3D context->aux;
+	context->aux =3D (void *)ax;
+
+	ax->op =3D op;
+	ax->tfm =3D tfm;
+	ax->ctx =3D ctx;
+	ax->ctx2 =3D ctx2;
+	ax->algorithm =3D algorithm;
+	ax->operation =3D operation;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__audit_log_crypto_op);
+
+/**
  * __audit_log_capset - store information about the arguments to the c=
apset syscall
  * @pid: target pid of the capset call
  * @new: the new credentials
--=20
1.7.3.2
