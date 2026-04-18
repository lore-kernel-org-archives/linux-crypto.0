Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7B12BD11;
	Sat, 18 Apr 2026 00:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.155.198.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776471760; cv=none; b=N1CEmQFM0skD1c94pS1xrsAgU2edZUffpSmJ6XxurxOy5D0watESttfsZ/kojiB932LfpZkZqqTSVrJictRObdSw+rnM4l6Ftfs5VvFvlyoKPMMR5d9csQELuMlcoRJrFwa9tmSmtEUn6XNFiFyui42uqfZJbjetTrHuwF8yBHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776471760; c=relaxed/simple;
	bh=9D+NqCqyNm8ItFhKL+qsXwACOsOR1/qzYCZ4CiyuYcI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=srel9N9SWxHYV/mrtP/SosMzq8Y8UmpR/YClyzm+5+IEwT09eOBnpMYJ9GJ94qQrPKCkyZdd1NLTyXC7emauZx8kI7IHD+jOiEHkgrWIuWCMBrNngKxZUNM5I4Agx1BODpW71j+xWTOe/LcB8zGEWsw01uZltamaC2B55WZCp70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=potwq5p9; arc=none smtp.client-ip=35.155.198.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="potwq5p9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1776471758; x=1808007758;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q6ZJIXhd4zjFqjDlmwifqG5q2HSX1yh116B7+fCpOk4=;
  b=potwq5p9I86PIEJ9b9OKG/nzcjMFJ+RyVwhGL/VzavfgNM6ivIywa/vb
   Sh0RNYulSh40C5vsS6f1nIPdORQIGhiHnsKqm8zuJKAluAvA16LOyr46K
   QOUqQvnENqMTLWVv+bGpxI2aSh5yB9F3+FwbcM9UTAbnl3SQVy6YZSgpm
   R9GBSNBAIo93bPP6S5JBun0Slh5e2/vw3EAJwfzdYRYhQOvZEbNMDJ0hM
   F7E2MgDA+LXkmX5lbqTp/Xpc043eVFBfALHx2rDGXEKeH52gdJlPDQxe8
   1IENonx/AqCUt+G8Y/LRX0KCxyIkAIQMhc5QbG6n1H642TtVfiDy1Bh1v
   w==;
X-CSE-ConnectionGUID: WRko0on/TIeVMPUV0k21Kg==
X-CSE-MsgGUID: u6Kwv34+Q4m+agVV8580mw==
X-IronPort-AV: E=Sophos;i="6.23,185,1770595200"; 
   d="scan'208";a="17480678"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2026 00:22:38 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:21526]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.6.131:2525] with esmtp (Farcaster)
 id 79c28a71-ed6b-48e1-89db-70e9249363a1; Sat, 18 Apr 2026 00:22:38 +0000 (UTC)
X-Farcaster-Flow-ID: 79c28a71-ed6b-48e1-89db-70e9249363a1
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sat, 18 Apr 2026 00:22:38 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sat, 18 Apr 2026 00:22:37 +0000
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
Subject: [PATCH v2 08/19] crypto: fips140: add crypto module loader
Date: Sat, 18 Apr 2026 00:20:16 +0000
Message-ID: <20260418002032.2877-9-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
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
index 0000000000000..369ab3ceede9c
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
+static int fips_loader_init(void)
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

