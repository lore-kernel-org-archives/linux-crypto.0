Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0DD265623;
	Thu,  4 Sep 2025 16:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001714; cv=none; b=pbht01u/d+JxZePCtUUrE4PORhavzxnjqv2OnzpARBywn29tkWXFGGrJg1PS/DmsDCE5JkjrYmI6kAIZXxBMh0LPMu5slyvurT73Dc8elUnlra0oW5kViFpFyQllQ806KMORaqFwX2uieAJ/wtE/KHmQcZkIrRnsL3tgNJgoHtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001714; c=relaxed/simple;
	bh=KIEkY65GQj4qeSa7BzoUwXsSD4bLgCUdp4qYLmR8d58=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nkjEHTabxeQlZKrg194a7LAr1CLkhxqKUbO8nkPoa0X/t9rGx1NdIbzuai2u/H4vXEzuoaOijWz8axJKCaPC7bpUotWUsncZPQjwzSXJcZt4lusu4aKJfvlzt+ITlIl62iAcSTl5ZUhEO0wT/ODOj371q4ERTkY5WyUafJI0EJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oQ9lleDE; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oQ9lleDE"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Fuk8B004100;
	Thu, 4 Sep 2025 16:01:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=v55Ze
	nKbRBliAwrKpeRxgpRcLpGr4TiTpg+76TrF9hw=; b=oQ9lleDEdq8bXg1FbmDEN
	HnIAtE1g6B45sxH6AKBRbM28l8CSYn8ODgdDQJlIC9v0YNC+TW4lY5X5Qr71xvM0
	LqyL+vAktvGhYU+UoyVoTkVdmXJKt1kubTskQnopy38eDaydDJNenisMwBVJqoW6
	GnWUnzmP849HcQovdbzT05S6bGY/zTgDVaULPkpTMdNhfLCkQTCGj4PO+i9keDjs
	WYTipTjsYOStzriMlnaydRXegoMFlXBLJSenZ4euNkED0aYgDG1ho2pNfAozlARX
	UdD+HavZboKR3zDC4nbICPpjZUxR9jLaicns0uP9sLqI+8lO74uIxYIvftvheQxL
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydun00bh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:01:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FVart040148;
	Thu, 4 Sep 2025 16:01:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtu50-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:01:38 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx8A000707;
	Thu, 4 Sep 2025 16:01:37 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-102;
	Thu, 04 Sep 2025 16:01:37 +0000
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
Subject: [PATCH RFC 101/104] crypto: fips140: add FIPS 140 module loader
Date: Thu,  4 Sep 2025 17:52:13 +0200
Message-Id: <20250904155216.460962-102-vegard.nossum@oracle.com>
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
 definitions=main-2509040157
X-Proofpoint-ORIG-GUID: KpuyrnzfE92vG_ClIz_udA3U6DEdv2Pr
X-Proofpoint-GUID: KpuyrnzfE92vG_ClIz_udA3U6DEdv2Pr
X-Authority-Analysis: v=2.4 cv=cfXSrmDM c=1 sm=1 tr=0 ts=68b9b7e2 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=Oh2cFVv5AAAA:8 a=yPCof4ZbAAAA:8 a=vmLDa1wCAAAA:8
 a=t3wnlPdPu1bxaPooNIAA:9 a=7KeoIwV6GZqOttXkcoxL:22 a=h8Bt5HTj68qkN2fS7gvA:22
 cc=ntf awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfX47Vxn2qc2FTr
 0nU89tDH/xMp4iWlghti07ESYY9hoahnHUHhgTJoWfGRr5KZVvmWYdZiFGwxICl0q+nENADzpZU
 LLkMC2NYeO160b7QeBaYiOesbIrjK9kiSoKPORLW81wkqwXpqQ7VR72AMm9kBOaGuBTdLvymIJ5
 PmPlIJ34iVj4Ha7y61XuJlFIrjm3pH5jmTjQsY+M1J9GBHUasKvdocIUGBgRln0NTDMhDSySjKY
 9WzkGdoQLR1H8+WC9/CyzjPaYlfLIxOQVyBzEu41GIb7oskvHs49E62MpY5XRA606qGNXxts3CN
 YggLjIWGTcutDwLAlcu6hoBdrhhYy6gphK/NxshymAGX0L2BI+P9L5ioMgouTMA3+1YQb228m2y
 TgyG9NblfXlb4ECiysF5nlqciuzyMA==

Add a mechanism for loading a FIPS module from a byte array compiled
into vmlinux.

fips140-module.o and fips140-digest.o are files generated during the build
of the FIPS cryptographic module; fips140-module.o provides the following
symbols:

 - _binary_fips140_ko_start
 - _binary_fips140_ko_end

while fips140-digest.o provides the following symbol:

 - _binary_fips140_hmac_start

fips140-loader.c then uses the _binary_fips140_ko_start/_end byte array
with load_module_mem() in arch_initcall_sync call to load the
precompiled FIPS 140 module.

This code is partly based on the existing crypto/fips.c code and partly on
the Android FIPS 140 module [1].

[1]: https://android.googlesource.com/kernel/common/+/1ca1130ec62d/crypto/fips140-module.c

Only arm64 and x86-64 are explicitly supported for now.

Co-developed-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 arch/arm64/kernel/vmlinux.lds.S   |  1 +
 crypto/Makefile                   | 24 ++++++++
 crypto/fips140-loader.c           | 96 +++++++++++++++++++++++++++++++
 include/asm-generic/vmlinux.lds.h | 37 +++++++++++-
 include/linux/fips.h              | 17 ++++++
 5 files changed, 174 insertions(+), 1 deletion(-)
 create mode 100644 crypto/fips140-loader.c

diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index ad6133b89e7a..58a99b2de237 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -271,6 +271,7 @@ SECTIONS
 		INIT_RAM_FS
 		*(.init.altinstructions .init.bss)	/* from the EFI stub */
 	}
+	FIPS140
 	.exit.data : {
 		EXIT_DATA
 	}
diff --git a/crypto/Makefile b/crypto/Makefile
index 6c5d59369dac..e07e93b189fe 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -7,7 +7,9 @@ obj-$(CONFIG_CRYPTO) += crypto.o
 crypto-y := api.o cipher.o
 
 obj-$(CONFIG_CRYPTO_ENGINE) += crypto_engine.o
+ifneq ($(CONFIG_CRYPTO_FIPS140_EXTMOD),y)
 obj-$(CONFIG_CRYPTO_FIPS) += fips.o
+endif
 
 crypto_algapi-$(CONFIG_PROC_FS) += proc.o
 crypto_algapi-y := algapi.o scatterwalk.o $(crypto_algapi-y)
@@ -211,3 +213,25 @@ obj-$(CONFIG_CRYPTO_SIMD) += crypto_simd.o
 obj-$(CONFIG_CRYPTO_KDF800108_CTR) += kdf_sp800108.o
 
 obj-$(CONFIG_CRYPTO_KRB5) += krb5/
+
+#
+# Loader for standalone FIPS 140 module
+#
+
+obj-$(CONFIG_CRYPTO_FIPS140_EXTMOD) += fips140-loader.o
+
+#
+# Standalone FIPS 140 module
+#
+
+quiet_cmd_ld_bin = LD      $@
+      cmd_ld_bin = (cd "$(dir $<)" && \
+                    $(LD) -r -b binary -o $(abspath $@) $(notdir $<) && \
+                    $(OBJCOPY) --rename-section .data=$(2) $(abspath $@))
+
+$(obj)/fips140-module.o: $(src)/fips140.ko FORCE
+	$(call if_changed,ld_bin,__fips140_module)
+$(obj)/fips140-digest.o: $(src)/fips140.hmac FORCE
+	$(call if_changed,ld_bin,__fips140_digest)
+
+obj-$(CONFIG_CRYPTO_FIPS140_EXTMOD) += fips140-module.o fips140-digest.o fips140-api.o
diff --git a/crypto/fips140-loader.c b/crypto/fips140-loader.c
new file mode 100644
index 000000000000..865d45d46786
--- /dev/null
+++ b/crypto/fips140-loader.c
@@ -0,0 +1,96 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * FIPS 140-3 module loader.
+ *
+ * Copyright (c) 2008 Neil Horman <nhorman@tuxdriver.com>
+ * Copyright 2021 Google LLC
+ * Copyright (c) 2025, Oracle and/or its affiliates.
+ */
+
+#include <linux/fips.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/panic.h>
+#include <linux/printk.h>
+#include <linux/string.h>
+
+#include <crypto/api.h>
+#include <crypto/hash.h>
+
+int fips_enabled;
+EXPORT_SYMBOL_GPL(fips_enabled);
+
+ATOMIC_NOTIFIER_HEAD(fips_fail_notif_chain);
+EXPORT_SYMBOL_GPL(fips_fail_notif_chain);
+
+void fips_fail_notify(void)
+{
+	if (fips_enabled)
+		atomic_notifier_call_chain(&fips_fail_notif_chain, 0, NULL);
+}
+EXPORT_SYMBOL_GPL(fips_fail_notify);
+
+/* defined in crypto/fips140-{module,digest}.o -OR- vmlinux.lds */
+EXPORT_SYMBOL_GPL(_binary_fips140_ko_start);
+EXPORT_SYMBOL_GPL(_binary_fips140_ko_end);
+EXPORT_SYMBOL_GPL(_binary_fips140_hmac_start);
+
+/* Process kernel command-line parameter at boot time. fips=0 or fips=1 */
+static int fips_enable(char *str)
+{
+	fips_enabled = !!simple_strtol(str, NULL, 0);
+	if (!fips_enabled)
+		pr_info("FIPS 140-3 module: disabled\n");
+
+	return 1;
+}
+
+__setup("fips=", fips_enable);
+
+static struct ctl_table crypto_sysctl_table[] = {
+	{
+		.procname	= "fips_enabled",
+		.data		= &fips_enabled,
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= proc_dointvec,
+	},
+};
+
+static int __init fips_loader_init(void)
+{
+	void *ko_mem;
+	int err;
+	struct ctl_table_header *crypto_sysctls;
+
+	if (!fips_enabled) {
+		/* Add crypto sysctl for nonfips mode */
+		crypto_sysctls = register_sysctl("crypto", crypto_sysctl_table);
+		if (!crypto_sysctls)
+			pr_err("fips 140: failed to register sysctl for nonfips mode");
+
+		return 0;
+	}
+
+	/*
+	 * Duplicate the memory as the kernel module loader will
+	 * modify it and mess up the integrity check.
+	 */
+	ko_mem = kvmemdup(_binary_fips140_ko_start, _binary_fips140_ko_size, GFP_KERNEL);
+	if (!ko_mem) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	err = load_module_mem(ko_mem, _binary_fips140_ko_size);
+	if (err)
+		goto out;
+
+	kvfree(ko_mem);
+
+out:
+	if (err)
+		panic("FIPS 140-3 module: loading error\n");
+	return err;
+}
+arch_initcall_sync(fips_loader_init);
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 1881d9b6b3ae..b4aee570223c 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -454,6 +454,40 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
 #endif
 #endif
 
+#ifdef CONFIG_CRYPTO_FIPS140_EXTMOD
+/*
+ * We have an external module; include it and its digest in their own
+ * named sections so they are easy to extract from the vmlinux ELF file
+ * after the kernel has been built.
+ */
+#define FIPS140 \
+	. = ALIGN(PAGE_SIZE); \
+	__fips140_module : AT(ADDR(__fips140_module) - LOAD_OFFSET) {	\
+		*(__fips140_module)					\
+	}								\
+	. = ALIGN(PAGE_SIZE);						\
+	__fips140_digest : AT(ADDR(__fips140_digest) - LOAD_OFFSET) {	\
+		*(__fips140_digest)					\
+	}
+#else
+#ifdef CONFIG_CRYPTO_FIPS140_EXTMOD
+/*
+ * We don't have an external module (yet) but the kernel has been built
+ * with the loader, so this just defines an empty byte array where the
+ * module will go eventually.
+ */
+#define FIPS140 \
+	_binary_fips140_ko_start = .; \
+	_binary_fips140_ko_end = .; \
+	_binary_fips140_hmac_start = .; \
+	_binary_fips140_hmac_end = .;
+#else
+#define FIPS140
+#endif
+#endif
+
+
+
 /*
  * Read only Data
  */
@@ -1145,7 +1179,8 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
 		INIT_CALLS						\
 		CON_INITCALL						\
 		INIT_RAM_FS						\
-	}
+	}								\
+	FIPS140
 
 #define BSS_SECTION(sbss_align, bss_align, stop_align)			\
 	. = ALIGN(sbss_align);						\
diff --git a/include/linux/fips.h b/include/linux/fips.h
index c6961e932fef..81560dfc6cef 100644
--- a/include/linux/fips.h
+++ b/include/linux/fips.h
@@ -2,12 +2,29 @@
 #ifndef _FIPS_H
 #define _FIPS_H
 
+#include <linux/init.h>
+
+#include <crypto/sha2.h> /* SHA256_DIGEST_SIZE */
+
 #ifdef CONFIG_CRYPTO_FIPS
+/*
+ * fips_enabled = FIPS mode was requested on the command line
+ * fips_operational = FIPS module has run self-tests etc. and is operational
+ */
 extern int fips_enabled;
+extern int fips_operational;
+
 extern struct atomic_notifier_head fips_fail_notif_chain;
 
 void fips_fail_notify(void);
 
+/* FIPS-certified module blob and digest */
+extern const u8 __initconst _binary_fips140_ko_start[];
+extern const u8 __initconst _binary_fips140_ko_end[];
+extern const u8 __initconst _binary_fips140_hmac_start[SHA256_DIGEST_SIZE];
+
+#define _binary_fips140_ko_size (_binary_fips140_ko_end - _binary_fips140_ko_start)
+
 #else
 #define fips_enabled 0
 
-- 
2.39.3

