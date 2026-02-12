Received: from pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.1.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FE82472BA;
	Thu, 12 Feb 2026 03:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.1.125
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770866634; cv=none; b=RMkupn6rUHVvqeAMXeZFYHO9PHXJouKj5AMmAAt5XJveMrfAyYFW9vfvRjmrtFZF5jaRvMAkRig+tcyhbMU1Rdjw2b1GnG2UbKBPYDKP0vYgYWTRfqHIQYmJciMJZEksAuVI0ct/Zgzsk4fjo7k0W7I3Fmwb2VaGypRkqGSAGh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770866634; c=relaxed/simple;
	bh=bTXOOuMHrPwdcZi56sFA46ELqvzYvqLZCfvdM0nRu64=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UMbQAVoI0uxeed9TsQYitK+KDyzrIGl/2pRhqq5eOdzer1zzey9MWGRaC27yEuvItpuqbJiGP5nd6ML5tK9bMW1+H1wfMzmX4m/pGCNdGbyCZOGBcLBRFsJMtSSg+DsItLY00Gs/iI9MUuxFR5osu6fCP9ZyKEpSMge0RWwFsyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=j6lL2oF0; arc=none smtp.client-ip=44.246.1.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="j6lL2oF0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770866633; x=1802402633;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=utw11iX6Z+INEVXEgqscnNKBqePfmcmLIE3TQqAigy8=;
  b=j6lL2oF0mQ3txLlhiahbk8/vgj2AnmZl5s0pipdD8sZ9QRv8oJSf4wq9
   +pKPWPZjqrFSofzWKHUdMpbMzEGxc0HK3aByGgzufpAXrfzEtIU35Xv4l
   /gStkmMCk7JGhnJnnXwHZx1QS0HSbBqAMahFN4Yst2m/2IiSE0YuU5xF1
   Rt7z8ioS37AA6/XcsPo/E+KHucnGGqpgaWnMj2x2BoaJQ8ZgMHThZoxCs
   3n83RabJ9nLxtJMJIUfWaRgPWSHNDiekvLrqelCDGfX/8oj82GJDlXL9F
   9cPODoY6SpaxR6uiB1jSDkz59/mPIiApgFAYS+8pn+Dprk8LK/Agixe7W
   w==;
X-CSE-ConnectionGUID: MhiVjRofQOimhbO9qsirxw==
X-CSE-MsgGUID: ANiJn+dlTYyF8l9MMpmn/Q==
X-IronPort-AV: E=Sophos;i="6.21,286,1763424000"; 
   d="scan'208";a="12920275"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 03:23:53 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:9189]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.61.62:2525] with esmtp (Farcaster)
 id 813c9955-df14-4e64-858a-cf83e3da1637; Thu, 12 Feb 2026 03:23:53 +0000 (UTC)
X-Farcaster-Flow-ID: 813c9955-df14-4e64-858a-cf83e3da1637
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:23:53 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:23:52 +0000
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
Subject: [PATCH 10/12] arm64: crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_AES_ARM64_CE_BLK crypto
Date: Thu, 12 Feb 2026 03:21:10 +0000
Message-ID: <20260212032117.9166-11-wanjay@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260212032117.9166-1-wanjay@amazon.com>
References: <20260212032117.9166-1-wanjay@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D041UWB001.ant.amazon.com (10.13.139.132) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_AES_ARM64_CE_BLK-related crypto to convert them into pluggable
interface.

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 arch/arm64/crypto/Makefile   | 2 +-
 arch/arm64/crypto/aes-glue.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
index 710887575f2d..a98342e64eb1 100644
--- a/arch/arm64/crypto/Makefile
+++ b/arch/arm64/crypto/Makefile
@@ -32,7 +32,7 @@ ghash-ce-y := ghash-ce-glue.o ghash-ce-core.o
 crypto-objs-$(CONFIG_CRYPTO_AES_ARM64_CE_CCM) += aes-ce-ccm.o
 aes-ce-ccm-y := aes-ce-ccm-glue.o aes-ce-ccm-core.o
 
-obj-$(CONFIG_CRYPTO_AES_ARM64_CE_BLK) += aes-ce-blk.o
+crypto-objs-$(CONFIG_CRYPTO_AES_ARM64_CE_BLK) += aes-ce-blk.o
 aes-ce-blk-y := aes-glue-ce.o aes-ce.o
 
 obj-$(CONFIG_CRYPTO_AES_ARM64_NEON_BLK) += aes-neon-blk.o
diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 92f43e1cd097..cba1db7afd26 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -970,14 +970,14 @@ static int __init aes_init(void)
 }
 
 #ifdef USE_V8_CRYPTO_EXTENSIONS
-module_cpu_feature_match(AES, aes_init);
+crypto_module_cpu_feature_match(AES, aes_init);
 EXPORT_SYMBOL_NS(ce_aes_mac_update, "CRYPTO_INTERNAL");
 #else
-module_init(aes_init);
+crypto_module_init(aes_init);
 EXPORT_SYMBOL(neon_aes_ecb_encrypt);
 EXPORT_SYMBOL(neon_aes_cbc_encrypt);
 EXPORT_SYMBOL(neon_aes_ctr_encrypt);
 EXPORT_SYMBOL(neon_aes_xts_encrypt);
 EXPORT_SYMBOL(neon_aes_xts_decrypt);
 #endif
-module_exit(aes_exit);
+crypto_module_exit(aes_exit);
-- 
2.47.3

