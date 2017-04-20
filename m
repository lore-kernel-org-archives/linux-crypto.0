From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/6] ima: Simplify policy_func_show.
Date: Thu, 20 Apr 2017 17:40:18 -0300
Message-ID: <2085797.x18HOhjl0i@morokweng>
References: <1492546666-16615-1-git-send-email-bauerman@linux.vnet.ibm.com> <1492546666-16615-4-git-send-email-bauerman@linux.vnet.ibm.com> <1492690403.3081.72.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Claudio Carvalho <cclaudio@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1492690403.3081.72.camel@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Donnerstag, 20. April 2017, 08:13:23 BRT schrieb Mimi Zohar:
> On Tue, 2017-04-18 at 17:17 -0300, Thiago Jung Bauermann wrote:
> > If the func_tokens array uses the same indices as enum ima_hooks,
> > policy_func_show can be a lot simpler, and the func_* enum becomes
> > unnecessary.
> 
> My main concern with separating the enumeration from the string
> definition is that they might become out of sync.  Perhaps using
> macros, similar to those used for kernel_read_file_id_str(), would be
> better?

I agree that it would be better. Is the patch below what you had in mind?

I also noticed that policy_func_show can be even simpler if we stop using the 
printf format string from the policy_tokens table. What do you think?

-- 
Thiago Jung Bauermann
IBM Linux Technology Center


>From 594628c94f5dd7c6d2624944a76b6a01f9668128 Mon Sep 17 00:00:00 2001
From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Date: Mon, 10 Apr 2017 14:59:44 -0300
Subject: [PATCH 3/6] ima: Simplify policy_func_show.

If the func_tokens array uses the same indices as enum ima_hooks,
policy_func_show can be a lot simpler, and the func_* enum becomes
unnecessary.

Also, if we use the same macro trick used by kernel_read_file_id_str we can
use one hooks list for both the enum and the string array, making sure they
are always in sync (suggested by Mimi Zohar).

Finally, by using the printf pattern for the function token directly
instead of using the pt macro we can simplify policy_func_show even further
and avoid the need of having a temporary buffer. Since the only use of
Opt_func's printf pattern in policy_tokens was in policy_func_show, we
don't need it at all anymore so remove it.

Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
---
 security/integrity/ima/ima.h        | 25 +++++++++-------
 security/integrity/ima/ima_policy.c | 60 +++++--------------------------------
 2 files changed, 22 insertions(+), 63 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index b563fbd4d122..51ef805cf7f3 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -172,17 +172,22 @@ static inline unsigned long ima_hash_key(u8 *digest)
 	return hash_long(*digest, IMA_HASH_BITS);
 }
 
+#define __ima_hooks(hook)		\
+	hook(NONE)			\
+	hook(FILE_CHECK)		\
+	hook(MMAP_CHECK)		\
+	hook(BPRM_CHECK)		\
+	hook(POST_SETATTR)		\
+	hook(MODULE_CHECK)		\
+	hook(FIRMWARE_CHECK)		\
+	hook(KEXEC_KERNEL_CHECK)	\
+	hook(KEXEC_INITRAMFS_CHECK)	\
+	hook(POLICY_CHECK)		\
+	hook(MAX_CHECK)
+#define __ima_hook_enumify(ENUM)	ENUM,
+
 enum ima_hooks {
-	FILE_CHECK = 1,
-	MMAP_CHECK,
-	BPRM_CHECK,
-	POST_SETATTR,
-	MODULE_CHECK,
-	FIRMWARE_CHECK,
-	KEXEC_KERNEL_CHECK,
-	KEXEC_INITRAMFS_CHECK,
-	POLICY_CHECK,
-	MAX_CHECK
+	__ima_hooks(__ima_hook_enumify)
 };
 
 /* LIM API function definitions */
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index cfda5d7b17ec..39d43a5beb5a 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -503,7 +503,7 @@ static match_table_t policy_tokens = {
 	{Opt_subj_user, "subj_user=%s"},
 	{Opt_subj_role, "subj_role=%s"},
 	{Opt_subj_type, "subj_type=%s"},
-	{Opt_func, "func=%s"},
+	{Opt_func, NULL},
 	{Opt_mask, "mask=%s"},
 	{Opt_fsmagic, "fsmagic=%s"},
 	{Opt_fsuuid, "fsuuid=%s"},
@@ -896,23 +896,10 @@ static const char *const mask_tokens[] = {
 	"MAY_APPEND"
 };
 
-enum {
-	func_file = 0, func_mmap, func_bprm,
-	func_module, func_firmware, func_post,
-	func_kexec_kernel, func_kexec_initramfs,
-	func_policy
-};
+#define __ima_hook_stringify(str)	#str,
 
 static const char *const func_tokens[] = {
-	"FILE_CHECK",
-	"MMAP_CHECK",
-	"BPRM_CHECK",
-	"MODULE_CHECK",
-	"FIRMWARE_CHECK",
-	"POST_SETATTR",
-	"KEXEC_KERNEL_CHECK",
-	"KEXEC_INITRAMFS_CHECK",
-	"POLICY_CHECK"
+	__ima_hooks(__ima_hook_stringify)
 };
 
 void *ima_policy_start(struct seq_file *m, loff_t *pos)
@@ -949,49 +936,16 @@ void ima_policy_stop(struct seq_file *m, void *v)
 
 #define pt(token)	policy_tokens[token + Opt_err].pattern
 #define mt(token)	mask_tokens[token]
-#define ft(token)	func_tokens[token]
 
 /*
  * policy_func_show - display the ima_hooks policy rule
  */
 static void policy_func_show(struct seq_file *m, enum ima_hooks func)
 {
-	char tbuf[64] = {0,};
-
-	switch (func) {
-	case FILE_CHECK:
-		seq_printf(m, pt(Opt_func), ft(func_file));
-		break;
-	case MMAP_CHECK:
-		seq_printf(m, pt(Opt_func), ft(func_mmap));
-		break;
-	case BPRM_CHECK:
-		seq_printf(m, pt(Opt_func), ft(func_bprm));
-		break;
-	case MODULE_CHECK:
-		seq_printf(m, pt(Opt_func), ft(func_module));
-		break;
-	case FIRMWARE_CHECK:
-		seq_printf(m, pt(Opt_func), ft(func_firmware));
-		break;
-	case POST_SETATTR:
-		seq_printf(m, pt(Opt_func), ft(func_post));
-		break;
-	case KEXEC_KERNEL_CHECK:
-		seq_printf(m, pt(Opt_func), ft(func_kexec_kernel));
-		break;
-	case KEXEC_INITRAMFS_CHECK:
-		seq_printf(m, pt(Opt_func), ft(func_kexec_initramfs));
-		break;
-	case POLICY_CHECK:
-		seq_printf(m, pt(Opt_func), ft(func_policy));
-		break;
-	default:
-		snprintf(tbuf, sizeof(tbuf), "%d", func);
-		seq_printf(m, pt(Opt_func), tbuf);
-		break;
-	}
-	seq_puts(m, " ");
+	if (func > 0 && func < MAX_CHECK)
+		seq_printf(m, "func=%s ", func_tokens[func]);
+	else
+		seq_printf(m, "func=%d ", func);
 }
 
 int ima_policy_show(struct seq_file *m, void *v)
-- 
2.7.4


