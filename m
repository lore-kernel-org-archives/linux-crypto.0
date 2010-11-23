From: =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
Subject: [PATCH 1/5] Add general crypto auditing infrastructure
Date: Tue, 23 Nov 2010 13:50:31 +0100
Message-ID: <1290516635-26601-1-git-send-email-mitr@redhat.com>
References: <344091777.216361290516431362.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-audit@redhat.com, linux-crypto@vger.kernel.org,
	=?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
To: sgrubb@redhat.com, herbert@gondor.hengli.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab0KWMuw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Nov 2010 07:50:52 -0500
In-Reply-To: <344091777.216361290516431362.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
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
 kernel/auditsc.c      |  100 +++++++++++++++++++++++++++++++++++++++++=
++++++++
 3 files changed, 124 insertions(+), 0 deletions(-)

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
index 3828ad5..3894713 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -158,6 +158,16 @@ struct audit_aux_data_capset {
 	struct audit_cap_data	cap;
 };
=20
+struct audit_crypto_op {
+	struct list_head	list;
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
@@ -182,6 +192,7 @@ struct audit_context {
 	struct audit_context *previous; /* For nested syscalls */
 	struct audit_aux_data *aux;
 	struct audit_aux_data *aux_pids;
+	struct list_head crypto;
 	struct sockaddr_storage *sockaddr;
 	size_t sockaddr_len;
 				/* Save things to print about task_struct */
@@ -633,6 +644,19 @@ static int audit_filter_rules(struct task_struct *=
tsk,
 		case AUDIT_FILETYPE:
 			result =3D audit_match_filetype(ctx, f->val);
 			break;
+		case AUDIT_CRYPTO_OP: {
+			struct audit_crypto_op *ax;
+
+			if (!ctx)
+				break;
+			list_for_each_entry(ax, &ctx->crypto, list) {
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
@@ -828,6 +852,7 @@ static inline void audit_free_names(struct audit_co=
ntext *context)
 static inline void audit_free_aux(struct audit_context *context)
 {
 	struct audit_aux_data *aux;
+	struct audit_crypto_op *crypto, *tmp;
=20
 	while ((aux =3D context->aux)) {
 		context->aux =3D aux->next;
@@ -837,6 +862,10 @@ static inline void audit_free_aux(struct audit_con=
text *context)
 		context->aux_pids =3D aux->next;
 		kfree(aux);
 	}
+	list_for_each_entry_safe(crypto, tmp, &context->crypto, list) {
+		list_del(&crypto->list);
+		kfree(crypto);
+	}
 }
=20
 static inline void audit_zero_context(struct audit_context *context,
@@ -854,6 +883,7 @@ static inline struct audit_context *audit_alloc_con=
text(enum audit_state state)
 	if (!(context =3D kmalloc(sizeof(*context), GFP_KERNEL)))
 		return NULL;
 	audit_zero_context(context, state);
+	INIT_LIST_HEAD(&context->crypto);
 	INIT_LIST_HEAD(&context->killed_trees);
 	return context;
 }
@@ -1311,12 +1341,50 @@ static void show_special(struct audit_context *=
context, int *call_panic)
 	audit_log_end(ab);
 }
=20
+static void log_crypto_op(struct audit_context *context,
+			  const struct audit_crypto_op *crypto)
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
+	struct audit_buffer *ab;
+
+	ab =3D audit_log_start(context, GFP_KERNEL, AUDIT_CRYPTO_USERSPACE_OP=
);
+	if (!ab)
+		return;
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
+	audit_log_end(ab);
+}
+
 static void audit_log_exit(struct audit_context *context, struct task_=
struct *tsk)
 {
 	const struct cred *cred;
 	int i, call_panic =3D 0;
 	struct audit_buffer *ab;
 	struct audit_aux_data *aux;
+	struct audit_crypto_op *crypto;
 	const char *tty;
=20
 	/* tsk =3D=3D current */
@@ -1443,6 +1511,9 @@ static void audit_log_exit(struct audit_context *=
context, struct task_struct *ts
 				call_panic =3D 1;
 	}
=20
+	list_for_each_entry(crypto, &context->crypto, list)
+		log_crypto_op(context, crypto);
+
 	if (context->target_pid &&
 	    audit_log_pid_context(context, context->target_pid,
 				  context->target_auid, context->target_uid,
@@ -2484,6 +2555,35 @@ void __audit_log_capset(pid_t pid,
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
+	struct audit_crypto_op *ax;
+
+	ax =3D kmalloc(sizeof(*ax), GFP_KERNEL);
+	if (!ax)
+		return -ENOMEM;
+
+	ax->op =3D op;
+	ax->tfm =3D tfm;
+	ax->ctx =3D ctx;
+	ax->ctx2 =3D ctx2;
+	ax->algorithm =3D algorithm;
+	ax->operation =3D operation;
+	list_add_tail(&ax->list, &current->audit_context->crypto);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__audit_log_crypto_op);
+
+/**
  * audit_core_dumps - record information about processes that end abno=
rmally
  * @signr: signal value
  *
--=20
1.7.3.2
