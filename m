Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AA32BD11;
	Sat, 18 Apr 2026 00:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.42.203.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776471792; cv=none; b=NqtQ9VWl8rcHw/NnLjMH4vtim+fxa3nztDmZOoiVixrntO+SRpJq2hofamuoD2EMWHVJK1j0RwA9VuLWRXa+vmPfEYPK6jU801ZPfHeTFYXLglyKffCrKQVgGdIDrD9G7if/+tofBXgTaYjUFpFEK4urdCQy5f7tUVdQvbBlkTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776471792; c=relaxed/simple;
	bh=OYsbLdinqcuorDz64jjPKezaAkyieOBUvTikki/fqCk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aF0I9D+5cUr3icRKJB4w8Wh92fQYi5+1cKSXSbEpjlhfOftfInaxAlVNt9shJ6bBUR3lhe6oCrONvD68elDo+lPvnwFeKfTO22YpJHr3fd9MJoiMSIjK2vIB1mwuNcQPfz2Av/0xa/d6qjQFgtBjwEwKNTwOmi6xMq0y3rJhiYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=IwJ3jxa0; arc=none smtp.client-ip=52.42.203.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="IwJ3jxa0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1776471790; x=1808007790;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ji+fZcApZbwV30sxJjgqiMMSZkP+FHnBrLUTS/vdrl8=;
  b=IwJ3jxa0wWMkwBUIXp1ikDBJxOGXPP+gZuyBvMnOv8V7aWyhvOvFTYYS
   qd9VSqZlPL/7MecwLrsdezcDiirJJSSabKbOZ1enKTKM2x2Xr1BWG6owT
   OWKQpK7F4nergd+Tns8H50m3Lp9uGnoAZd5ooM4vfpmM9oYk9RBUk99C4
   B8HsjAbdW5FRY2W3L39x14O9YMDJgzBCMugI0b+pzbaj1RBRotHvwIB6k
   aCkkcGGD4K14j6RhEXC2Ej5uSA0Q4tXEMa8VC109Wn/tiU0TwVOewV1dU
   Bu7ok+g+3nygfAVSvubHJpb7mrwo1hh1jN7iOL2zi3bheuzGOczwI6UfH
   g==;
X-CSE-ConnectionGUID: VNOMiFDbRem8NFxOqKt1zA==
X-CSE-MsgGUID: pwiLiAizSteMZHEAhgMsXA==
X-IronPort-AV: E=Sophos;i="6.23,185,1770595200"; 
   d="scan'208";a="17609398"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2026 00:23:10 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.51:25735]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.1.88:2525] with esmtp (Farcaster)
 id 3cca9a26-2992-45ba-a8b0-7ecdaa6684cc; Sat, 18 Apr 2026 00:23:10 +0000 (UTC)
X-Farcaster-Flow-ID: 3cca9a26-2992-45ba-a8b0-7ecdaa6684cc
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sat, 18 Apr 2026 00:23:09 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sat, 18 Apr 2026 00:23:08 +0000
From: Jay Wang <wanjay@amazon.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
	<davem@davemloft.net>, <linux-crypto@vger.kernel.org>, Masahiro Yamada
	<masahiroy@kernel.org>, <linux-kbuild@vger.kernel.org>
CC: Jay Wang <jay.wang.upstream@gmail.com>, Vegard Nossum
	<vegard.nossum@oracle.com>, Nicolai Stange <nstange@suse.de>, Ilia Okomin
	<ilya.okomin@oracle.com>, Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>,
	Bjoern Doebel <doebel@amazon.de>, Martin Pohlack <mpohlack@amazon.de>,
	Benjamin Herrenschmidt <benh@amazon.com>, Nathan Chancellor
	<nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, Catalin Marinas
	<catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Thomas Gleixner
	<tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H . Peter Anvin"
	<hpa@zytor.com>, Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu
	<petr.pavlu@suse.com>, Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen
	<samitolvanen@google.com>, David Howells <dhowells@redhat.com>, "David
 Woodhouse" <dwmw2@infradead.org>, Jarkko Sakkinen <jarkko@kernel.org>, "Ignat
 Korchagin" <ignat@linux.win>, Lukas Wunner <lukas@wunner.de>, "Alexei
 Starovoitov" <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
	"Andrii Nakryiko" <andrii@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <x86@kernel.org>,
	<linux-modules@vger.kernel.org>
Subject: [PATCH v2 10/19] module: skip modversion checks for crypto modules
Date: Sat, 18 Apr 2026 00:20:18 +0000
Message-ID: <20260418002032.2877-11-wanjay@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260418002032.2877-1-wanjay@amazon.com>
References: <20260418002032.2877-1-wanjay@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D033UWC001.ant.amazon.com (10.13.139.218) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

The standalone crypto module feature allows loading pre-built crypto
modules from an external build to preserve FIPS certification across
kernel updates. Since these externally built modules have different
modversion CRCs than the running kernel, the module_layout and per-symbol
version checks will fail.

Add a flags field to struct load_info and bypass check_version() and
check_modstruct_version() for crypto modules. For fips140.ko loaded
from embedded kernel memory, the MODULE_INIT_CRYPTO_FROM_MEM flag is set
by the loader. For individual crypto algorithm modules (e.g., authenc.ko,
ccm.ko) built with the crypto-objs-m rule, a .fips140_crypto_marker ELF
section is detected during early_mod_check() and the
MODULE_INIT_CRYPTO_OBJS_M flag is set accordingly.

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 include/uapi/linux/module.h |  1 +
 kernel/module/internal.h    |  1 +
 kernel/module/main.c        | 17 +++++++++++++++++
 kernel/module/version.c     |  9 +++++++++
 4 files changed, 28 insertions(+)

diff --git a/include/uapi/linux/module.h b/include/uapi/linux/module.h
index 6941497350893..7c6b3ae55c8d7 100644
--- a/include/uapi/linux/module.h
+++ b/include/uapi/linux/module.h
@@ -10,6 +10,7 @@
 #ifdef __KERNEL__
 /* Internal flags */
 #define MODULE_INIT_CRYPTO_FROM_MEM		(1 << 8)
+#define MODULE_INIT_CRYPTO_OBJS_M		(1 << 9)
 #endif
 
 #endif /* _UAPI_LINUX_MODULE_H */
diff --git a/kernel/module/internal.h b/kernel/module/internal.h
index 061161cc79d90..b75b19e0b5dcf 100644
--- a/kernel/module/internal.h
+++ b/kernel/module/internal.h
@@ -69,6 +69,7 @@ struct load_info {
 	char *secstrings, *strtab;
 	unsigned long symoffs, stroffs, init_typeoffs, core_typeoffs;
 	bool sig_ok;
+	int flags;
 #ifdef CONFIG_KALLSYMS
 	unsigned long mod_kallsyms_init_off;
 #endif
diff --git a/kernel/module/main.c b/kernel/module/main.c
index 6152b9b39e6b1..69949069dc5f5 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -3446,6 +3446,22 @@ static int early_mod_check(struct load_info *info, int flags)
 	if (err)
 		return err;
 
+#ifdef CONFIG_CRYPTO_FIPS140_EXTMOD
+	/* Detect crypto-objs-m modules by .fips140_crypto_marker section */
+	if (!(info->flags & MODULE_INIT_CRYPTO_FROM_MEM)) {
+		unsigned int i;
+
+		for (i = 1; i < info->hdr->e_shnum; i++) {
+			const char *sname = info->secstrings + info->sechdrs[i].sh_name;
+
+			if (strcmp(sname, ".fips140_crypto_marker") == 0) {
+				info->flags |= MODULE_INIT_CRYPTO_OBJS_M;
+				break;
+			}
+		}
+	}
+#endif
+
 	/* Check module struct version now, before we try to use module. */
 	if (!check_modstruct_version(info, info->mod))
 		return -ENOEXEC;
@@ -3678,6 +3694,7 @@ int load_crypto_module_mem(const char *mem, size_t size)
 	}
 
 	info.sig_ok = true;
+	info.flags = MODULE_INIT_CRYPTO_FROM_MEM;
 	info.hdr = (Elf_Ehdr *) mem;
 	info.len = size;
 
diff --git a/kernel/module/version.c b/kernel/module/version.c
index 2beefeba82d94..3c5b5fceb73a9 100644
--- a/kernel/module/version.c
+++ b/kernel/module/version.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/printk.h>
+#include <uapi/linux/module.h>
 #include "internal.h"
 
 int check_version(const struct load_info *info,
@@ -21,6 +22,10 @@ int check_version(const struct load_info *info,
 	struct modversion_info *versions;
 	struct modversion_info_ext version_ext;
 
+	/* Skip version checks for FIPS crypto modules */
+	if (info->flags & (MODULE_INIT_CRYPTO_FROM_MEM | MODULE_INIT_CRYPTO_OBJS_M))
+		return 1;
+
 	/* Exporting module didn't supply crcs?  OK, we're already tainted. */
 	if (!crc)
 		return 1;
@@ -81,6 +86,10 @@ int check_modstruct_version(const struct load_info *info,
 	};
 	bool have_symbol;
 
+	/* Skip module_layout version check for FIPS crypto modules */
+	if (info->flags & (MODULE_INIT_CRYPTO_FROM_MEM | MODULE_INIT_CRYPTO_OBJS_M))
+		return 1;
+
 	/*
 	 * Since this should be found in kernel (which can't be removed), no
 	 * locking is necessary. Regardless use a RCU read section to keep
-- 
2.47.3

