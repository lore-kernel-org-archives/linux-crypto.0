Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30506248176;
	Thu, 12 Feb 2026 03:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.42.203.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770866495; cv=none; b=eGTPa4Yf7+LpC/nihlYR1MUJnp4bmFmnt9U0rfd4sEeCHtMhVx2p5rGQ7tP/4D5xZ05ZOmByPrsOulZOhMvV7CRFO0NqQovOnDl9PYhsx2yl9MASZyunctEWu0Ux0pch0Z5ie6zNEerPjuGMiHOGAcg0c5XxlCT881kHZ3MzR4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770866495; c=relaxed/simple;
	bh=0teDd6IpqGv17q8N30/cw/7rOJdQsBqY9siDwu93iOQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SUu3ClXv7oChn578ACCMAhwCKMTWi4q1f3xdyt6Xg5qzi6icxuge6zNZtx3xMbbBkbM3BSTmZmhSptbkRetJIsYnBU43ZjzyjIpQm2x7u5PwMREDEr5+tA/U3hfBg/sFhtkOGHg8S+QYsT2dEjaDDsEIpnYaL4dBA4JaDIrxSC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=g4Bqsz93; arc=none smtp.client-ip=52.42.203.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="g4Bqsz93"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770866494; x=1802402494;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2U4r6CnCmOGklDeQL0VSJ/YoQSeZj8SWz4ge6xbTqqY=;
  b=g4Bqsz93SEGe8y5R0tk5MnYxULrSifAuXlpdgWxQBt/hdCanC/I3wSzD
   Msxx7kmy+FEjn5leUZp/A6gupq+31gHFYxOAZLk/LlupxL3neTNIJRBMp
   lvwLLTI56elHjMSN1a/li18bhwwDnOem2O05MYHS+lZSxXqYV+Gp3r0hd
   2obbKmi6gWcrSxaxtqzvft2WmXt8KeCWPqSDhXLK/9+Bm7K0ygZsfI6BP
   OfSeiZDzpt1crR6s91wnHY0lbc9SwiJn86XfB8PZiU6oZB39wwf+KoyPf
   8MFOoRxlU2KtuVB/xn1vOX8GQ4gExa1ox09Pjwjn0xTq3oxsdiaCPvKZH
   Q==;
X-CSE-ConnectionGUID: 8kDFm9ogQF6n6C0xe9Y24w==
X-CSE-MsgGUID: cIskVJMhQ/ChfrSyljuIxA==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12914408"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 03:21:33 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.51:10522]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.29.209:2525] with esmtp (Farcaster)
 id 7ec5cc9f-4e1a-4edd-bed2-5bec3bd12a0b; Thu, 12 Feb 2026 03:21:33 +0000 (UTC)
X-Farcaster-Flow-ID: 7ec5cc9f-4e1a-4edd-bed2-5bec3bd12a0b
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:21:33 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:21:33 +0000
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
Subject: [PATCH 01/12] arm64: crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_SM3_NEON crypto
Date: Thu, 12 Feb 2026 03:21:01 +0000
Message-ID: <20260212032117.9166-2-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D040UWA001.ant.amazon.com (10.13.139.22) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_SM3_NEON-related crypto to convert them into pluggable
interface.

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 arch/arm64/crypto/Makefile        | 2 +-
 arch/arm64/crypto/sm3-neon-glue.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
index 9f7106424d66..3dcde982c0cc 100644
--- a/arch/arm64/crypto/Makefile
+++ b/arch/arm64/crypto/Makefile
@@ -5,7 +5,7 @@
 # Copyright (C) 2014 Linaro Ltd <ard.biesheuvel@linaro.org>
 #
 
-obj-$(CONFIG_CRYPTO_SM3_NEON) += sm3-neon.o
+crypto-objs-$(CONFIG_CRYPTO_SM3_NEON) += sm3-neon.o
 sm3-neon-y := sm3-neon-glue.o sm3-neon-core.o
 
 obj-$(CONFIG_CRYPTO_SM3_ARM64_CE) += sm3-ce.o
diff --git a/arch/arm64/crypto/sm3-neon-glue.c b/arch/arm64/crypto/sm3-neon-glue.c
index 15f30cc24f32..d388e3adfad4 100644
--- a/arch/arm64/crypto/sm3-neon-glue.c
+++ b/arch/arm64/crypto/sm3-neon-glue.c
@@ -58,8 +58,8 @@ static void __exit sm3_neon_fini(void)
 	crypto_unregister_shash(&sm3_alg);
 }
 
-module_init(sm3_neon_init);
-module_exit(sm3_neon_fini);
+crypto_module_init(sm3_neon_init);
+crypto_module_exit(sm3_neon_fini);
 
 MODULE_DESCRIPTION("SM3 secure hash using NEON instructions");
 MODULE_AUTHOR("Jussi Kivilinna <jussi.kivilinna@iki.fi>");
-- 
2.47.3

