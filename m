Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D676B280CFB;
	Thu,  4 Sep 2025 15:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001387; cv=none; b=hX5ZPQX6/gkdYLEFgpqrH8YGdlq6ySXt+LNzbZQdRsdz9VByVxNggh9oCfmm6VSYHHVZ5i012b3w3CZskXHDFc12GzyH8RosUo6hx8eBxd1hXL+SWRDNQkVPod4avvQjMZD7MefLGqO4AXy52JIHSMuQPxKeQCrMSrxALI0QemI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001387; c=relaxed/simple;
	bh=JH7QRoUIKTw5WJa31Oior7c8W9brUxgnAHD5Jkuy/vo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GQJ8YUKpAnGreFhCFtr51lzK705SW3kjvVNlOMgq818vri/PGtP023kAIGyGCyCdLFW4i/b4memT+Og/siQhJZx/GgNTdXJ6gAS8EFN9fho0WeYQ3tRcEgqTaCjebHYr6VRhHIYnKFV1ifn5tyTortonO4xVMLGeq9+AfmV4ofU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sCHJWnNm; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sCHJWnNm"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FthmP026658;
	Thu, 4 Sep 2025 15:56:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=0Nwdf
	vXf+Yw/18Fx1Fr1S6MRVHogy/JyYzlk1LKb69o=; b=sCHJWnNme2nPj/T55UEt4
	ZloDlglve7bvrgTP8Bvp0bNk540dN4VD2eyNogdejbgNxk1kKt1fnXXXAao98YP7
	RQVpQoL2GdXkr+xCJobjsqqsIiVYsAm3JjWhAqWYxFQ7XVDRwBQS7IV4ElYP0oyW
	bHz0h4sE3OW+80duA66erYO2xpOZrdklYmEFWJfG1H1h7UUSGwDukrAuHHSzKiK+
	Z+C4+d87yZcvrQLTgpTSM+j1QV17BSLqmEJs/aHw7B7pV+ghxRCcQxMuAjRaOZYq
	RLjbHkrGap5JfU56WlGVYOiMls2pSP7PahKd0L3BJE11A14p8xWdiwxTQLQK4mQ5
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48yd1004uq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FV71Z040033;
	Thu, 4 Sep 2025 15:56:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtmrm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:14 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx5Q000707;
	Thu, 4 Sep 2025 15:56:13 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-20;
	Thu, 04 Sep 2025 15:56:13 +0000
From: Vegard Nossum <vegard.nossum@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
        Daniel Gomez <da.gomez@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Wang, Jay" <wanjay@amazon.com>, Nicolai Stange <nstange@suse.com>,
        Vladis Dronov <vdronov@redhat.com>,
        Stephan Mueller <smueller@chronox.de>,
        Sami Tolvanen <samitolvanen@google.com>, linux-modules@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Subject: [PATCH RFC 019/104] module: add load_module_mem() helper
Date: Thu,  4 Sep 2025 17:50:51 +0200
Message-Id: <20250904155216.460962-20-vegard.nossum@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250904155216.460962-1-vegard.nossum@oracle.com>
References: <20250904155216.460962-1-vegard.nossum@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509040156
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE0OCBTYWx0ZWRfXwvxjZ5l6S4n9
 vdG49F/Ld4jnLjTFqq196B3EkdRhjmYByN2cdG7CeEvP0cG67Q0lAXpCOzUfivjjZo2RdjRWaR2
 cwVPFQIl9wnSxPs93hzGd5vwF66APSTaUCN1gBYQROwL5fMyWG/awf5wDQ5DyG+4qyOLT6WsF+N
 MsLYxVk42WJ9HNkBjP+CBB8U5gQStAmqQivV94DCpOwkmclwojzdPG51fQnrjFYibihb24ysIYB
 x5FxwROlD0NXZsCSz5+cQdKz3pgGOGhNN8FTlZiLaZ2PdzeD+Brvmwj2ewXfEnnHmYYhfcIHeNK
 D78zSZxNfKw4mPzOvpR/9ctZVoyiKfGjsPK4zWz7dlB+EN58VA9/o3+TvUDwxUuE9gIaeMo7N3R
 0UiRW0oBtki1+TBnzUkmu/E71W/t0g==
X-Authority-Analysis: v=2.4 cv=CbkI5Krl c=1 sm=1 tr=0 ts=68b9b69e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=W6LH72ydn0wR1v8s0j8A:9 cc=ntf
 awl=host:12068
X-Proofpoint-ORIG-GUID: 426m5ym5C43mbckbaazOCLiet9cIpjfO
X-Proofpoint-GUID: 426m5ym5C43mbckbaazOCLiet9cIpjfO

Add a new helper function, load_module_mem(), which can load a kernel
module from a byte array in memory.

Also add a new module loader flag, MODULE_INIT_MEM, signalling that a
module was loaded in this way.

When a module is loaded with load_module_mem(), we do a few things
differently:

- don't do signature verification
- ignore vermagic
- don't taint the kernel
- keep the initial reference to the module until the caller wants to
  drop it

These changes are necessary for having a bundled (but separately
compiled) FIPS module.

We may want to let distros carry patches to disable tainting separately
so this information is not lost in case somebody builds a non-distro
kernel using a FIPS module compiled for an incompatible version.

Co-developed-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 include/linux/module.h      |  2 +
 include/uapi/linux/module.h |  5 ++
 kernel/module/main.c        | 99 ++++++++++++++++++++++++++-----------
 3 files changed, 77 insertions(+), 29 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 3319a5269d28..00d85602fb6a 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -586,6 +586,8 @@ struct module {
 
 #ifdef CONFIG_MODULES
 
+extern int load_module_mem(const char *mem, size_t size);
+
 /* Get/put a kernel symbol (calls must be symmetric) */
 void *__symbol_get(const char *symbol);
 void *__symbol_get_gpl(const char *symbol);
diff --git a/include/uapi/linux/module.h b/include/uapi/linux/module.h
index 03a33ffffcba..5dcd24018be7 100644
--- a/include/uapi/linux/module.h
+++ b/include/uapi/linux/module.h
@@ -7,4 +7,9 @@
 #define MODULE_INIT_IGNORE_VERMAGIC	2
 #define MODULE_INIT_COMPRESSED_FILE	4
 
+#ifdef __KERNEL__
+/* Internal flags */
+#define MODULE_INIT_MEM			30
+#endif
+
 #endif /* _UAPI_LINUX_MODULE_H */
diff --git a/kernel/module/main.c b/kernel/module/main.c
index c66b26184936..12ce4bad29ca 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -2572,11 +2572,14 @@ static void module_augment_kernel_taints(struct module *mod, struct load_info *i
 
 static int check_modinfo(struct module *mod, struct load_info *info, int flags)
 {
-	const char *modmagic = get_modinfo(info, "vermagic");
+	const char *modmagic = NULL;
 	int err;
 
-	if (flags & MODULE_INIT_IGNORE_VERMAGIC)
-		modmagic = NULL;
+	if (flags & MODULE_INIT_MEM)
+		return 0;
+
+	if (!(flags & MODULE_INIT_IGNORE_VERMAGIC))
+		modmagic = get_modinfo(info, "vermagic");
 
 	/* This is allowed: modprobe --force will invalidate it. */
 	if (!modmagic) {
@@ -3007,7 +3010,7 @@ module_param(async_probe, bool, 0644);
  * Keep it uninlined to provide a reliable breakpoint target, e.g. for the gdb
  * helper command 'lx-symbols'.
  */
-static noinline int do_init_module(struct module *mod)
+static noinline int do_init_module(struct module *mod, int flags)
 {
 	int ret = 0;
 	struct mod_initfree *freeinit;
@@ -3071,7 +3074,8 @@ static noinline int do_init_module(struct module *mod)
 			mod->mem[MOD_INIT_TEXT].base + mod->mem[MOD_INIT_TEXT].size);
 	mutex_lock(&module_mutex);
 	/* Drop initial reference. */
-	module_put(mod);
+	if (!(flags & MODULE_INIT_MEM))
+		module_put(mod);
 	trim_init_extable(mod);
 #ifdef CONFIG_KALLSYMS
 	/* Switch to core kallsyms now init is done: kallsyms may be walking! */
@@ -3347,31 +3351,17 @@ static int early_mod_check(struct load_info *info, int flags)
 /*
  * Allocate and load the module: note that size of section 0 is always
  * zero, and we rely on this for optional sections.
+ *
+ * NOTE: module signature verification must have been done already.
  */
-static int load_module(struct load_info *info, const char __user *uargs,
-		       int flags)
+static int _load_module(struct load_info *info, const char __user *uargs,
+			int flags)
 {
 	struct module *mod;
 	bool module_allocated = false;
 	long err = 0;
 	char *after_dashes;
 
-	/*
-	 * Do the signature check (if any) first. All that
-	 * the signature check needs is info->len, it does
-	 * not need any of the section info. That can be
-	 * set up later. This will minimize the chances
-	 * of a corrupt module causing problems before
-	 * we even get to the signature check.
-	 *
-	 * The check will also adjust info->len by stripping
-	 * off the sig length at the end of the module, making
-	 * checks against info->len more correct.
-	 */
-	err = module_sig_check(info, flags);
-	if (err)
-		goto free_copy;
-
 	/*
 	 * Do basic sanity checks against the ELF header and
 	 * sections. Cache useful sections and set the
@@ -3405,7 +3395,8 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	 * We are tainting your kernel if your module gets into
 	 * the modules linked list somehow.
 	 */
-	module_augment_kernel_taints(mod, info);
+	if (!(flags & MODULE_INIT_MEM))
+		module_augment_kernel_taints(mod, info);
 
 	/* To avoid stressing percpu allocator, do this once we're unique. */
 	err = percpu_modalloc(mod, info);
@@ -3452,7 +3443,11 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	flush_module_icache(mod);
 
 	/* Now copy in args */
-	mod->args = strndup_user(uargs, ~0UL >> 1);
+	if ((flags & MODULE_INIT_MEM))
+		mod->args = kstrdup("", GFP_KERNEL);
+	else
+		mod->args = strndup_user(uargs, ~0UL >> 1);
+
 	if (IS_ERR(mod->args)) {
 		err = PTR_ERR(mod->args);
 		goto free_arch_cleanup;
@@ -3500,13 +3495,10 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	if (codetag_load_module(mod))
 		goto sysfs_cleanup;
 
-	/* Get rid of temporary copy. */
-	free_copy(info, flags);
-
 	/* Done! */
 	trace_module_load(mod);
 
-	return do_init_module(mod);
+	return do_init_module(mod, flags);
 
  sysfs_cleanup:
 	mod_sysfs_teardown(mod);
@@ -3562,7 +3554,52 @@ static int load_module(struct load_info *info, const char __user *uargs,
 		audit_log_kern_module(info->name ? info->name : "?");
 		mod_stat_bump_becoming(info, flags);
 	}
+	return err;
+}
+
+/*
+ * Load module from kernel memory without signature check.
+ */
+int load_module_mem(const char *mem, size_t size)
+{
+	int err;
+	struct load_info info = { };
+
+	info.sig_ok = true;
+	info.hdr = (Elf64_Ehdr *) mem;
+	info.len = size;
+
+	err = _load_module(&info, NULL, MODULE_INIT_MEM);
+	if (0)
+		free_copy(&info, 0);
+
+	return err;
+}
+
+static int load_module(struct load_info *info, const char __user *uargs,
+		       int flags)
+{
+	int err;
+
+	/*
+	 * Do the signature check (if any) first. All that
+	 * the signature check needs is info->len, it does
+	 * not need any of the section info. That can be
+	 * set up later. This will minimize the chances
+	 * of a corrupt module causing problems before
+	 * we even get to the signature check.
+	 *
+	 * The check will also adjust info->len by stripping
+	 * off the sig length at the end of the module, making
+	 * checks against info->len more correct.
+	 */
+	err = module_sig_check(info, flags);
+	if (!err)
+		err = _load_module(info, uargs, flags);
+
+	/* Get rid of temporary copy. */
 	free_copy(info, flags);
+
 	return err;
 }
 
@@ -3728,6 +3765,10 @@ SYSCALL_DEFINE3(finit_module, int, fd, const char __user *, uargs, int, flags)
 
 	pr_debug("finit_module: fd=%d, uargs=%p, flags=%i\n", fd, uargs, flags);
 
+	/*
+	 * Deliberately omitting MODULE_INIT_MEM as it is for internal use
+	 * only.
+	 */
 	if (flags & ~(MODULE_INIT_IGNORE_MODVERSIONS
 		      |MODULE_INIT_IGNORE_VERMAGIC
 		      |MODULE_INIT_COMPRESSED_FILE))
-- 
2.39.3

