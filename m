Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B6FE55C;
	Thu, 12 Feb 2026 03:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.13.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770865659; cv=none; b=n2iUzptaX3W5qFcOr6UpHJMBBauAhQERCiDN0hT+JcpThJ1XNZB/lasiB+4ZmoJ01avwHwpRmc8y3hwWZaQcFQQHF8miq73aIr0/wwvM3Eg13S7PyaxjLfmUbX3pZlLVNGqsKBPAKB2HCUk8EiLvsvsZIOW8qLJSQ3B7DGNUYHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770865659; c=relaxed/simple;
	bh=QMs/rPIi6pdfugsxR0d5+CedFdehxVvPja8IxUEJ8+A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gABT+CMSOeECeDbtIWARdk1t9+a4AG15BZLqlp7PY4SRBwS9TqE9U6ZougcyXMj4Vnq9GfDJnM/wGFOgeqCpSCrKv9XCsqzMeUqApRZ0GblRssseBe5SCZ+qY9d7o5ZD0zmlD8S6yooGy0zOp3nHWVrUwaYPdbLa+9cGeifBL0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=BI7RZwNU; arc=none smtp.client-ip=52.13.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="BI7RZwNU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770865658; x=1802401658;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8HT5pUFfRtNdmaHcR0SSBqhBpNZ+brjSlqbDtML0bJo=;
  b=BI7RZwNUQh7ILWkILxjeR1teY6q+I1HPS2COOFIcRLGMvi+aIcneS7H/
   Rsex14xWHIIGuRQxYxcO/vp1P37qdGlqCNTh4QsHBnT37/xeL7UbSVmDl
   PAgAK2uMY8yhyrknvtf5uF1urMaQB13SKbBSO5urbXIshEQQmxfn4GDb+
   INeq2OiysrLITrWWHyp+Yogx0UMc3CgO+88kujp0kRYpmmoApV5xCqZX5
   SCXJsC9DTlv2dK96VYtfRaBhw3oGbtbt+UMNMa4fLo/Nm1njDGBaHsLYc
   q3qaiXkEQriLypNOfmSHZwVgTmtCoxzyI0m3UJn2TwTtf+fKxhOp29nZC
   Q==;
X-CSE-ConnectionGUID: dpbJkPemSLy+0QziAT83jA==
X-CSE-MsgGUID: 3GXbqp4ZSZCLMRl1nDIoxA==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12918308"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 03:07:38 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:15419]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.20.103:2525] with esmtp (Farcaster)
 id 5c64bbef-ea54-4804-bff1-9c18259562d1; Thu, 12 Feb 2026 03:07:38 +0000 (UTC)
X-Farcaster-Flow-ID: 5c64bbef-ea54-4804-bff1-9c18259562d1
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:07:38 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:07:37 +0000
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
Subject: [PATCH 078/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_MICHAEL_MIC crypto
Date: Thu, 12 Feb 2026 02:46:54 +0000
Message-ID: <20260212024725.11264-79-wanjay@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260212024725.11264-1-wanjay@amazon.com>
References: <20260212024725.11264-1-wanjay@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D040UWB003.ant.amazon.com (10.13.138.8) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_MICHAEL_MIC-related crypto to convert them into pluggable
interface.

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile      | 2 +-
 crypto/michael_mic.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index a989d103c191..f8cd388ca03c 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -150,7 +150,7 @@ crypto-objs-$(CONFIG_CRYPTO_ARIA) += aria_generic.o
 crypto-objs-$(CONFIG_CRYPTO_CHACHA20) += chacha.o
 CFLAGS_chacha.o += -DARCH=$(ARCH)
 crypto-objs-$(CONFIG_CRYPTO_DEFLATE) += deflate.o
-obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
+crypto-objs-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
 obj-$(CONFIG_CRYPTO_CRC32C) += crc32c-cryptoapi.o
 crc32c-cryptoapi-y := crc32c.o
 obj-$(CONFIG_CRYPTO_CRC32) += crc32-cryptoapi.o
diff --git a/crypto/michael_mic.c b/crypto/michael_mic.c
index 69ad35f524d7..8acdf39a7004 100644
--- a/crypto/michael_mic.c
+++ b/crypto/michael_mic.c
@@ -167,8 +167,8 @@ static void __exit michael_mic_exit(void)
 }
 
 
-module_init(michael_mic_init);
-module_exit(michael_mic_exit);
+crypto_module_init(michael_mic_init);
+crypto_module_exit(michael_mic_exit);
 
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Michael MIC");
-- 
2.47.3

