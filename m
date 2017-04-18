From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: [PATCH 3/6] ima: Simplify policy_func_show.
Date: Tue, 18 Apr 2017 17:17:43 -0300
Message-ID: <1492546666-16615-4-git-send-email-bauerman@linux.vnet.ibm.com>
References: <1492546666-16615-1-git-send-email-bauerman@linux.vnet.ibm.com>
Cc: linux-ima-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Claudio Carvalho <cclaudio@linux.vnet.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39949 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757889AbdDRUS1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Apr 2017 16:18:27 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3IK3kes030859
        for <linux-crypto@vger.kernel.org>; Tue, 18 Apr 2017 16:18:22 -0400
Received: from e24smtp02.br.ibm.com (e24smtp02.br.ibm.com [32.104.18.86])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29wqptw8pr-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Tue, 18 Apr 2017 16:18:21 -0400
Received: from localhost
        by e24smtp02.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <bauerman@linux.vnet.ibm.com>;
        Tue, 18 Apr 2017 17:18:19 -0300
In-Reply-To: <1492546666-16615-1-git-send-email-bauerman@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If the func_tokens array uses the same indices as enum ima_hooks,
policy_func_show can be a lot simpler, and the func_* enum becomes
unnecessary.

Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
---
 security/integrity/ima/ima_policy.c | 47 ++++++-------------------------------
 1 file changed, 7 insertions(+), 40 deletions(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index cfda5d7b17ec..158eafef64e8 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -896,20 +896,14 @@ static const char *const mask_tokens[] = {
 	"MAY_APPEND"
 };
 
-enum {
-	func_file = 0, func_mmap, func_bprm,
-	func_module, func_firmware, func_post,
-	func_kexec_kernel, func_kexec_initramfs,
-	func_policy
-};
-
 static const char *const func_tokens[] = {
+	NULL,
 	"FILE_CHECK",
 	"MMAP_CHECK",
 	"BPRM_CHECK",
+	"POST_SETATTR",
 	"MODULE_CHECK",
 	"FIRMWARE_CHECK",
-	"POST_SETATTR",
 	"KEXEC_KERNEL_CHECK",
 	"KEXEC_INITRAMFS_CHECK",
 	"POLICY_CHECK"
@@ -949,48 +943,21 @@ void ima_policy_stop(struct seq_file *m, void *v)
 
 #define pt(token)	policy_tokens[token + Opt_err].pattern
 #define mt(token)	mask_tokens[token]
-#define ft(token)	func_tokens[token]
 
 /*
  * policy_func_show - display the ima_hooks policy rule
  */
 static void policy_func_show(struct seq_file *m, enum ima_hooks func)
 {
-	char tbuf[64] = {0,};
+	if (func > 0 && func < MAX_CHECK)
+		seq_printf(m, pt(Opt_func), func_tokens[func]);
+	else {
+		char tbuf[64] = {0,};
 
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
 		snprintf(tbuf, sizeof(tbuf), "%d", func);
 		seq_printf(m, pt(Opt_func), tbuf);
-		break;
 	}
+
 	seq_puts(m, " ");
 }
 
-- 
2.7.4
