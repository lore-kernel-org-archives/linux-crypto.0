Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B217D219313;
	Thu, 12 Feb 2026 02:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.12.53.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770864274; cv=none; b=aqb8c6SHiA+mP5C+VEgWG/F6jgjsYIdVijhnB0M/2ztVFvULTW3aP0iWh/GgXAHTBNXStoQuVDz0v4ofo7bmP0Q5depNYnj8OxqFi9kctFiIT1H9lMsZOby6PutdfbJDMLbqB/rNk+2S/E6Q6cQbnwQkIUvLETFzyU2KXeON2ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770864274; c=relaxed/simple;
	bh=MIOpeG4YG62bLY3AAO0GjeDzlSSTA5byh73z/zz81m4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f9saCgXVfLpIIcm5Qe1I/F0nKV0wvL+7XrOPaUJIP5F7tNjYc/Y5FAWYsJ2L4O9nLZXDwpse3dmCY+gerFwY0l8giAml1ZdQXX4Kh55Slu1KBnNLr1s7lIZDi56ruU/YWW0CLOzgkjvpVu1mOyzGd6XSzrKNgrQ/dYV23hrsSoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=Mi5xW2Az; arc=none smtp.client-ip=52.12.53.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="Mi5xW2Az"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770864273; x=1802400273;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q0LDyS3HsmiIc56xAbBsiBrN3PJGoh408OgggkZDYFY=;
  b=Mi5xW2AzSZKzLfVUY12FRG62+PVndCqdet+6Bn6010Sbs4NAXZH5QILT
   Cp3Nl1NOeqfGiB7ZumPD0bQymQRFOq+vKBmK76LfPAgaEkYS+vjTlUCQZ
   YZyMA08+eUuw4kpIjzOTBfO/E+svqau6HzwqhKDohPL46cLZ0ZoIMQXpj
   fGoILC4JWg2Mgfl52iubr9hE+4TxqNmaId2ToT9tINH0jVV4PqGtErbKD
   w9HHMtdjWPyDK23FR4Nyal9mkY4s3BQIv2Cfl/TA+w2+GX2p9HWj1Hh76
   KTdIiyTLRkWyq62RW7LMgZWtWLsHBzYkeKHhIviBQDEdiGgER6MSpNmfu
   A==;
X-CSE-ConnectionGUID: Yk2lhj7LSjqSgQB6z3TLUA==
X-CSE-MsgGUID: KYnSfKiATHW/BkYbkNTBMQ==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12793186"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 02:44:33 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:24471]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.61.62:2525] with esmtp (Farcaster)
 id d3cb053d-dca5-4f56-a6b0-48f909762513; Thu, 12 Feb 2026 02:44:33 +0000 (UTC)
X-Farcaster-Flow-ID: d3cb053d-dca5-4f56-a6b0-48f909762513
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:44:33 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:44:32 +0000
From: Jay Wang <wanjay@amazon.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
	<davem@davemloft.net>, <linux-crypto@vger.kernel.org>
CC: Jay Wang <jay.wang.upstream@gmail.com>, Vegard Nossum
	<vegard.nossum@oracle.com>, Nicolai Stange <nstange@suse.de>, Ilia Okomin
	<ilya.okomin@oracle.com>, Catalin Marinas <catalin.marinas@arm.com>, "Will
 Deacon" <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Luis Chamberlain
	<mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, Nathan Chancellor
	<nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <x86@kernel.org>,
	<linux-kbuild@vger.kernel.org>, <linux-modules@vger.kernel.org>
Subject: [PATCH 08/17] crypto: fips140: add crypto module loader
Date: Thu, 12 Feb 2026 02:42:12 +0000
Message-ID: <20260212024228.6267-9-wanjay@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260212024228.6267-1-wanjay@amazon.com>
References: <20260212024228.6267-1-wanjay@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D046UWA003.ant.amazon.com (10.13.139.18) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Add a crypto module loader mechanism that loads a precompiled crypto
kernel module that is embedded in vmlinux image directly from memory
(whose address stored in _binary_fips140_ko_start/end) during early boot.

This is built based on Vegard Nossum <vegard.nossum@oracle.com> and
Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>, the
fips_loader_init is picked up. But different from them, such loader is
not executed as arch_initcall_sync(), but rather as a thread along main
kernel init to ensure proper initialization sequencing (Details are in
later patch).

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/fips140/fips140-loader.c | 55 +++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)
 create mode 100644 crypto/fips140/fips140-loader.c

diff --git a/crypto/fips140/fips140-loader.c b/crypto/fips140/fips140-loader.c
new file mode 100644
index 000000000000..cbf5ff59eb2e
--- /dev/null
+++ b/crypto/fips140/fips140-loader.c
@@ -0,0 +1,55 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * FIPS 140 Early Loader
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/printk.h>
+#include <linux/vmalloc.h>
+#include <linux/string.h>
+#include <linux/elf.h>
+#include <linux/kthread.h>
+#include <linux/wait.h>
+
+extern const u8 _binary_fips140_ko_start[];
+extern const u8 _binary_fips140_ko_end[];
+const u8 *_binary_crypto_ko_start;
+EXPORT_SYMBOL_GPL(_binary_crypto_ko_start);
+const u8 *_binary_crypto_ko_end;
+EXPORT_SYMBOL_GPL(_binary_crypto_ko_end);
+
+/* Function to load crypto module from memory */
+extern int load_crypto_module_mem(const char *mem, size_t size);
+
+static void load_prepare(void)
+{
+	_binary_crypto_ko_start = _binary_fips140_ko_start;
+	_binary_crypto_ko_end = _binary_fips140_ko_end;
+}
+
+static int __init fips_loader_init(void)
+{
+	load_prepare();
+	
+	const void *ko_mem = _binary_crypto_ko_start;
+	size_t ko_size = _binary_crypto_ko_end - _binary_crypto_ko_start;
+	void *vmalloc_mem;
+	int ret;
+	
+	// Copy to vmalloc'd memory since load_module expects to free it
+	vmalloc_mem = vmalloc(ko_size);
+	if (!vmalloc_mem) {
+		pr_err("FIPS140 loader: failed to allocate memory\n");
+		return -ENOMEM;
+	}
+	
+	memcpy(vmalloc_mem, ko_mem, ko_size);
+	
+	ret = load_crypto_module_mem(vmalloc_mem, ko_size); // Skip signature check
+	if (ret)
+		panic("FIPS140 loader: module loading error\n");
+
+	vfree(vmalloc_mem); // Free after successful module loading
+	return ret;
+}
-- 
2.47.3

