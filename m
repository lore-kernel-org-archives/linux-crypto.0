Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B07122301;
	Thu, 12 Feb 2026 03:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.12.53.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770866372; cv=none; b=fDZW1VMI+DlUKtiaelBUj5FvT0ioTIyjSpB/AvOOLLklma5VKW0bEYyzzL3Nf97h9UA1+XgW0UEguw2ziErGtHi/kX/fZi0badha21IE7R8nFOwViol6YnfSKC4bcfUoMbS/DvQ/ylSwX5lkC9rWmN2lsp6Osoc3caG1qxDh9L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770866372; c=relaxed/simple;
	bh=BC2UOEJhCi9WrB0pn09tsm9DVyZ50vxbCFlaDOVogQg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ua1NMYent9R/goL+gC8w5vpRg63ADnzF4+qBarcAnGah5R6L91ca+uV9OaBT2BFyWntXrKZtW8fsagYogRtI3hPYrGpmzgfxSjdOWmgWutaYg+ClL/JmDeFsSDuwN6SNVd6c7uUgPFN/icDEZkWbF3t7JM8PQ84rkeCsdsnBXxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=RVnVgYcQ; arc=none smtp.client-ip=52.12.53.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="RVnVgYcQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770866371; x=1802402371;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ljgJPNXzd4liVCOTMlOsyABEnpVgIngMhFyuYF5VMcc=;
  b=RVnVgYcQrCtUzpBaEPOkJw4u+tFe9AQwrm7jmEhsYhlDyyCNDe+PYHtv
   06k9cFZaR9HXE5Cl7JWpmXH6p+NlwU2PrH+zgtFVAwDpJsD43paPK76S2
   3DC3Vx63nsBnkUyxRU7aCogDcXD5EfssyDdIymiKMzR5vMazxf6gkmBVY
   c+A382OzNVGtwe2zSL/leapvajDc6xNzqlvvVI46eoYEBQGxePwdoviO9
   NkWLKmckzSohu0F0ukf565DDe/dig7VXAQU9Wp+KTyH1YyChGsBpkRv9U
   IEZocM1D1pDOl374CesmDHNLgnQ0xV6PrZFsNWB0I/sfS08PXVgYI06LM
   A==;
X-CSE-ConnectionGUID: qeEvXO+mR5Cqh7A2qeu56w==
X-CSE-MsgGUID: sc3tSwmrRzCK6nu81Sonhg==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12794451"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 03:19:30 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:5180]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.54.219:2525] with esmtp (Farcaster)
 id 0a46ae7f-cac8-4ff9-8d25-fd1506cce8e6; Thu, 12 Feb 2026 03:19:30 +0000 (UTC)
X-Farcaster-Flow-ID: 0a46ae7f-cac8-4ff9-8d25-fd1506cce8e6
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:19:30 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:19:29 +0000
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
Subject: [PATCH 16/21] x86: crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_SM3_AVX_X86_64 crypto
Date: Thu, 12 Feb 2026 03:15:14 +0000
Message-ID: <20260212031521.2124-17-wanjay@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260212031521.2124-1-wanjay@amazon.com>
References: <20260212031521.2124-1-wanjay@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D045UWC001.ant.amazon.com (10.13.139.223) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_SM3_AVX_X86_64-related crypto to convert them into pluggable
interface.

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 arch/x86/crypto/Makefile       | 2 +-
 arch/x86/crypto/sm3_avx_glue.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index b65f66577ffe..ffe37f4d4a7b 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -53,7 +53,7 @@ aesni-intel-$(CONFIG_64BIT) += aes-ctr-avx-x86_64.o \
 crypto-objs-$(CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL) += ghash-clmulni-intel.o
 ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o ghash-clmulni-intel_glue.o
 
-obj-$(CONFIG_CRYPTO_SM3_AVX_X86_64) += sm3-avx-x86_64.o
+crypto-objs-$(CONFIG_CRYPTO_SM3_AVX_X86_64) += sm3-avx-x86_64.o
 sm3-avx-x86_64-y := sm3-avx-asm_64.o sm3_avx_glue.o
 
 obj-$(CONFIG_CRYPTO_SM4_AESNI_AVX_X86_64) += sm4-aesni-avx-x86_64.o
diff --git a/arch/x86/crypto/sm3_avx_glue.c b/arch/x86/crypto/sm3_avx_glue.c
index 6e8c42b9dc8e..42a9b5d43fe1 100644
--- a/arch/x86/crypto/sm3_avx_glue.c
+++ b/arch/x86/crypto/sm3_avx_glue.c
@@ -90,8 +90,8 @@ static void __exit sm3_avx_mod_exit(void)
 	crypto_unregister_shash(&sm3_avx_alg);
 }
 
-module_init(sm3_avx_mod_init);
-module_exit(sm3_avx_mod_exit);
+crypto_module_init(sm3_avx_mod_init);
+crypto_module_exit(sm3_avx_mod_exit);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Tianjia Zhang <tianjia.zhang@linux.alibaba.com>");
-- 
2.47.3

