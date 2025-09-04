Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937D5283C9C;
	Thu,  4 Sep 2025 15:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001392; cv=none; b=QMBe85KwXIyKBO0kx+p1rWYKm8hjAilauUWnEY2Q6u7oGBJ2L2nvHowOHweTQD5+5HCWXBk9rLRA0g0UB331zXcTBwSKxxJ1ZOQi2AUlVjk2NJivRYvDaxvUyHhb741JJGIxDJFPovPpaq0hAYnz1E/V8yRfCb/zimwqmIB7TN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001392; c=relaxed/simple;
	bh=If/Ktn/fyjCx3TTaMq+zxZ7n5HRzvmz1drhgs8Q1CcQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SVrWcTfG0r1cyjI7dKewZXGyG+yqVaU+ieCpUn//6qAYEfXqRhSFCM3Q3e8Ub8UDgxP2ac9+cha8kxUQXzqKrqs7Ll/pkCHlTArDBPZiKzCA84pUlpLj28+kjlI2GTagNwCTS7QjsxBuG0iF46ake/WuLYJG8JOoqZjvc8PBJ7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YHCZ+eYN; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YHCZ+eYN"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Ftraf010582;
	Thu, 4 Sep 2025 15:56:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=hKuvR
	esbxtkHaAsLnL9mxpsn6drufyF6NQ5VtwGtPwI=; b=YHCZ+eYN2M4E/esCweDvU
	Ra+A/yF+aJlsBLucJgJirMXWit69h81MIEVS/NN6n2evgGCKiEhzoRtl/tq01bnG
	OX+dBUojJT4pYMm6IGtDXOdQh7ZRn8CKqlBKiSbNCOS+O+sPZAwzD+F4eNKPWcBc
	OInnhuzvsM1fFZgKeyNDfOxkZlI/3ZhwvDiABouvSM0gl03lAgowgb7zgx7xNYES
	lL7nGuuRvtEv8I8shm5N58+X0DA/WzoUxt3ZoN7d9PBYwFT9zQWSOLhC1P6I5WCn
	YrLTeuXPV01qOOdIXyqqhZ7CuIpkOdGxOHI+UqiCuaxbjsFvZUuHe2FCsqrrF5yo
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydacr2np-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584F0DRT040089;
	Thu, 4 Sep 2025 15:56:17 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtmuj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:17 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx5S000707;
	Thu, 4 Sep 2025 15:56:16 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-21;
	Thu, 04 Sep 2025 15:56:16 +0000
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
        Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH RFC 020/104] module: add a mechanism for pluggable crypto APIs
Date: Thu,  4 Sep 2025 17:50:52 +0200
Message-Id: <20250904155216.460962-21-vegard.nossum@oracle.com>
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
X-Proofpoint-GUID: blcpdRT0oNlQuVLIoqDHdeizGcJpR1__
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MCBTYWx0ZWRfX3hpAmHzSP0Eu
 bhMjoU6zTYEAf+r5+ks8LUjbt0Hd+INCamtt+VhXObOt7qHgmdRXjIpY0QtJLzAyA9+mf/hKMhJ
 TKLFZirPsJDkuKCf50/j5lcTfd+4Yzp1Golf3hGw7edyzMVUZfaoZHv/tIehGriUKNdkfGAK9gq
 bThfRwQByoppphQTC3jaQqcsDOYXg8tHVaPPY9xSxWwILyfxBghSiq8Fur5IbvcSaf/Jl4UD8sU
 wcNphPVFrplY8jTqBxBvJ7IQJxROFuUm3KAX2MfbS7SdCAGAo14gifiuz4nL8e6ML5mheNuZCp+
 HUcUrvpz/x2fFHrX3MBSotD7XHJPDQ9RPGM/DSbJqfPzaQ60eHIdu0LX8dtZW4C1pKnCWtMStWe
 feMtdaTIarvcD+HcqRvjwkYFjuklzQ==
X-Proofpoint-ORIG-GUID: blcpdRT0oNlQuVLIoqDHdeizGcJpR1__
X-Authority-Analysis: v=2.4 cv=TuTmhCXh c=1 sm=1 tr=0 ts=68b9b6a3 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=M_qoDd663mMjffw2gU8A:9 cc=ntf
 awl=host:12068

For FIPS certification of a standalone FIPS module we need to be able
to switch out the entire kernel crypto API during boot (if booting with
fips=1 on the kernel command line).

This is not easy, as it requires all users/callers of the crypto API
to be updated.

We've settled on using the "static call" functionality for this.
Benefits include no speculative attack gadgets and no performance impact
from indirect calls.

The way it works is that all exported crypto API functions need to be
annotated with DECLARE_CRYPTO_API() in headers and DEFINE_CRYPTO_API()
in the implementations. This will essentially allocate a static call key
for the given function and a static inline wrapper with the actual
static call itself -- any references to the crypto API functions will be
dynamically patched when the FIPS module is enabled.

The static calls are recorded in a new ELF section, __crypto_api_keys,
and are automatically updated when a module providing their targets is
loaded.

The macro FIPS_MODULE is not yet defined anywhere, but will be defined
in a future patch for any code compiled as part of the FIPS module.

Also define wrappers for things like module_init() so that we can record
these in .fips_initcall and link what would usually be a bunch of
modules together without running into errors because the resulting
module has more than one init function.

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/Kconfig                    |  16 ++++
 include/asm-generic/vmlinux.lds.h |   1 +
 include/crypto/api.h              | 154 ++++++++++++++++++++++++++++++
 kernel/module/main.c              |  26 ++++-
 4 files changed, 195 insertions(+), 2 deletions(-)
 create mode 100644 include/crypto/api.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 23bd98981ae8..a2696ea30bde 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -54,6 +54,22 @@ config CRYPTO_FIPS_VERSION
 	  This option provides the ability to override the FIPS Module Version.
 	  By default the KERNELRELEASE value is used.
 
+config CRYPTO_FIPS140_EXTMOD
+	bool "FIPS 140-3 external module"
+	depends on CRYPTO_FIPS
+	help
+	  Support loading a prebuilt FIPS 140-3 cryptographic module.
+
+config CRYPTO_FIPS140_HMAC_KEY
+	string "FIPS 140-3 external module HMAC key"
+	depends on CRYPTO_FIPS140_EXTMOD
+	default "Sphinx of black quartz, judge my vow"
+	help
+	  This is the HMAC key used to build and verify the integrity of
+	  the FIPS module.
+
+	  Must be at least 14 characters.
+
 config CRYPTO_ALGAPI
 	tristate
 	select CRYPTO_ALGAPI2
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index ae2d2359b79e..1881d9b6b3ae 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -707,6 +707,7 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
 	KERNEL_CTORS()							\
 	MCOUNT_REC()							\
 	*(.init.rodata .init.rodata.*)					\
+	BOUNDED_SECTION(__crypto_api_keys)				\
 	FTRACE_EVENTS()							\
 	TRACE_SYSCALLS()						\
 	KPROBE_BLACKLIST()						\
diff --git a/include/crypto/api.h b/include/crypto/api.h
new file mode 100644
index 000000000000..cda29e71ebef
--- /dev/null
+++ b/include/crypto/api.h
@@ -0,0 +1,154 @@
+#ifndef _CRYPTO_API_H
+#define _CRYPTO_API_H
+
+#include <linux/static_call.h>
+
+#if !defined(CONFIG_CRYPTO_FIPS140_EXTMOD)
+
+#define CRYPTO_API(name) name
+
+/*
+ * These are the definitions that get used when no standalone FIPS module
+ * is used: we simply forward everything to normal functions and function
+ * calls.
+ */
+
+#define DECLARE_CRYPTO_API(name, ret_type, args_decl, args_call) \
+	ret_type name args_decl;
+
+#define DEFINE_CRYPTO_API(name) \
+	EXPORT_SYMBOL_GPL(name)
+
+#define crypto_module_init(fn) module_init(fn)
+#define crypto_module_exit(fn) module_exit(fn)
+
+#define crypto_arch_initcall(fn)	arch_initcall(fn)
+#define crypto_subsys_initcall(fn)	subsys_initcall(fn)
+#define crypto_late_initcall(fn)	late_initcall(fn)
+
+#define CRYPTO_MODULE_DEVICE_TABLE(type, name) MODULE_DEVICE_TABLE(type, name)
+
+#define crypto_module_cpu_feature_match(x, __initfunc) \
+	module_cpu_feature_match(x, __initfunc)
+
+#else
+
+struct crypto_api_key {
+	struct static_call_key *key;
+	void *tramp;
+	void *func;
+};
+
+#ifndef FIPS_MODULE
+
+/*
+ * These are the definitions that get used for vmlinux and in-tree
+ * kernel modules.
+ *
+ * In this case, all references to the kernel crypto API functions will
+ * be replaced by wrappers that perform a call using the kernel's static_call
+ * functionality.
+ */
+
+#define CRYPTO_API(name) nonfips_##name
+
+/* Consolidated version of different DECLARE_CRYPTO_API versions */
+#define DECLARE_CRYPTO_API(name, ret_type, args_decl, args_call)	\
+	ret_type nonfips_##name args_decl;				\
+	DECLARE_STATIC_CALL(crypto_##name##_key, nonfips_##name);	\
+	static inline ret_type name args_decl				\
+	{								\
+		return static_call(crypto_##name##_key) args_call;	\
+	}
+
+#define DEFINE_CRYPTO_API(name) \
+	DEFINE_STATIC_CALL(crypto_##name##_key, nonfips_##name); \
+	EXPORT_STATIC_CALL(crypto_##name##_key)
+
+#define DEFINE_CRYPTO_API_STUB(name) \
+	DEFINE_STATIC_CALL_NULL(crypto_##name##_key, name); \
+	EXPORT_STATIC_CALL(crypto_##name##_key)
+
+#define crypto_module_init(fn) module_init(fn)
+#define crypto_module_exit(fn) module_exit(fn)
+
+#define crypto_arch_initcall(fn)	arch_initcall(fn)
+#define crypto_subsys_initcall(fn)	subsys_initcall(fn)
+#define crypto_late_initcall(fn)	late_initcall(fn)
+
+#define CRYPTO_MODULE_DEVICE_TABLE(type, name) MODULE_DEVICE_TABLE(type, name)
+
+#define crypto_module_cpu_feature_match(x, __initfunc) \
+	module_cpu_feature_match(x, __initfunc)
+
+#else /* defined(FIPS_MODULE) */
+
+/*
+ * These are the definitions that get used for the FIPS module and
+ * its kernel modules.
+ *
+ * In this case, all crypto API functions resolve directly to their
+ * implementations, since they are all part of the FIPS module.
+ *
+ * We still need to declare the static call keys so we can update
+ * them when the FIPS modules have all been loaded.
+ */
+
+#define CRYPTO_API(name) fips_##name
+
+/* Consolidated version of different DECLARE_CRYPTO_API versions */
+#define DECLARE_CRYPTO_API(name, ret_type, args_decl, args_call)	\
+	ret_type fips_##name args_decl;					\
+	DECLARE_STATIC_CALL(crypto_##name##_key, fips_##name);		\
+	static inline ret_type name args_decl				\
+	{								\
+		return fips_##name args_call;				\
+	}
+
+/*
+ * Create an entry for the static call key so we can initialize it
+ * in the FIPS module.
+ */
+// TODO: make this const initdata, probably
+#define DEFINE_CRYPTO_API(name) \
+	EXPORT_SYMBOL_GPL(fips_##name); \
+	static struct crypto_api_key __##name##_key \
+		__used \
+		__section("__crypto_api_keys") \
+		__aligned(__alignof__(struct crypto_api_key)) = \
+	{ \
+		.key = &STATIC_CALL_KEY(crypto_##name##_key), \
+		.tramp = STATIC_CALL_TRAMP_ADDR(crypto_##name##_key), \
+		.func = &fips_##name, \
+	};
+
+#define crypto_module_init(fn) \
+	static unsigned long __used __section(".fips_initcall") \
+		__fips_##fn = (unsigned long) &fn;
+#define crypto_module_exit(fn) \
+	static unsigned long __used __section(".fips_exitcall") \
+		__fips_##fn = (unsigned long) &fn;
+
+#define crypto_arch_initcall(fn)	crypto_module_init(fn)
+#define crypto_subsys_initcall(fn)	crypto_module_init(fn)
+#define crypto_late_initcall(fn)	crypto_module_init(fn)
+
+/*
+ * We don't need to emit device tables or module aliases for the FIPS module,
+ * since it will all be loaded at once anyway.
+ */
+#define CRYPTO_MODULE_DEVICE_TABLE(type, name)
+
+#define crypto_module_cpu_feature_match(x, __initfunc) \
+static int __init cpu_feature_match_ ## x ## _init(void)	\
+{								\
+	if (!cpu_have_feature(cpu_feature(x)))			\
+		return -ENODEV;					\
+	return __initfunc();					\
+}								\
+crypto_module_init(cpu_feature_match_ ## x ## _init)
+
+#endif /* defined(FIPS_MODULE) */
+#endif /* defined(CONFIG_CRYPTO_FIPS140_EXTMOD) */
+
+#endif /* !_CRYPTO_API_H */
diff --git a/kernel/module/main.c b/kernel/module/main.c
index 12ce4bad29ca..19a03c8659e2 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -7,6 +7,7 @@
 
 #define INCLUDE_VERMAGIC
 
+#include <crypto/api.h>
 #include <linux/export.h>
 #include <linux/extable.h>
 #include <linux/moduleloader.h>
@@ -2956,6 +2957,24 @@ static int post_relocation(struct module *mod, const struct load_info *info)
 	return module_finalize(info->hdr, info->sechdrs, mod);
 }
 
+static void do_crypto_api(struct load_info *info)
+{
+#ifdef CONFIG_CRYPTO_FIPS140_EXTMOD
+	struct crypto_api_key *crypto_api_keys;
+	unsigned int num_crypto_api_keys;
+
+	unsigned int i;
+
+	crypto_api_keys = section_objs(info, "__crypto_api_keys",
+		sizeof(*crypto_api_keys), &num_crypto_api_keys);
+
+	for (i = 0; i < num_crypto_api_keys; ++i) {
+		struct crypto_api_key *key = &crypto_api_keys[i];
+		__static_call_update(key->key, key->tramp, key->func);
+	}
+#endif
+}
+
 /* Call module constructors. */
 static void do_mod_ctors(struct module *mod)
 {
@@ -3010,7 +3029,7 @@ module_param(async_probe, bool, 0644);
  * Keep it uninlined to provide a reliable breakpoint target, e.g. for the gdb
  * helper command 'lx-symbols'.
  */
-static noinline int do_init_module(struct module *mod, int flags)
+static noinline int do_init_module(struct load_info *info, struct module *mod, int flags)
 {
 	int ret = 0;
 	struct mod_initfree *freeinit;
@@ -3036,6 +3055,9 @@ static noinline int do_init_module(struct module *mod, int flags)
 	freeinit->init_data = mod->mem[MOD_INIT_DATA].base;
 	freeinit->init_rodata = mod->mem[MOD_INIT_RODATA].base;
 
+	if (flags & MODULE_INIT_MEM)
+		do_crypto_api(info);
+
 	do_mod_ctors(mod);
 	/* Start the module */
 	if (mod->init != NULL)
@@ -3498,7 +3520,7 @@ static int _load_module(struct load_info *info, const char __user *uargs,
 	/* Done! */
 	trace_module_load(mod);
 
-	return do_init_module(mod, flags);
+	return do_init_module(info, mod, flags);
 
  sysfs_cleanup:
 	mod_sysfs_teardown(mod);
-- 
2.39.3

