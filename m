Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA2A2222C0;
	Thu, 12 Feb 2026 02:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.68.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770865163; cv=none; b=YRC2mtdl8FK8I07pS2EeoFTkmgXgj0e+3yoe7kv4lYcV1v3+uZjJ9IXvxz8uBgIM2xEaZj60cGYSe/e3hJuRZBj7dgCxweo9wAkD/1sB3pNoj/NyiaON7YkNLhaBdrxlDl6iAMg46/NEzzsxcVBxeZ/CrQWvuUu+Syb6kYkS4s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770865163; c=relaxed/simple;
	bh=wBFt+P9eWLhY+LRfwXMtfDg/UIazs+RQDy9bWg4LBak=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BkbXANP+MIekCQmWp5XCCs/HlPmWtj0N6KN9AAR3xEgUk0LmxXx6pk8EGaj1WDDjUJgOsrhtrwXW42X9RzWqG1CDOCv5ct4Sw2CncJwaZvLNtmu6PC1R9sZCXVwpVCfERM7mDfslWsht9OCaiVuOy+R/Rv/QpUdHITfXXsxQO90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=VOXNh2pj; arc=none smtp.client-ip=44.246.68.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="VOXNh2pj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770865162; x=1802401162;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5Ma40zTK4Iu8ycpk1knJ90/X13MwjPJfWtOKk8FMwjM=;
  b=VOXNh2pjLYu0gSTmtmg5B6wdFRdFlonkFCAeTeRecJHRelWbzRi1Y5dv
   hrlYs1U6lblaGuW0NYJ9SJVayStsHjhld1+4SzrQJU5ptJcCOLgWwnLai
   VmMsjyyqTgVDJTfGG9uNRve440qUrBaL1n8ijG3vxB3Bgo9N2AQETgn5q
   EUO5wuBWUqH6a5C2Fl+dHyYlS/egynxkHJM3s0/4wYiHM7YOVLdTXdaRl
   wreoFcaHqdxGXOUUcoIWKKMG24wIN9fuoJxcoZQ5q5ixUWy5BAsa4/FXc
   stsXL41wB7NC4F3C2kY5QfHvtkS6cz2JgQtYn5jGFWNFX7SPKuVhhSWJf
   A==;
X-CSE-ConnectionGUID: VPkrv8WFTBeFbWwHPxMWCg==
X-CSE-MsgGUID: v9JnPqkaSAaa/ki+L5bbxQ==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12925385"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 02:59:22 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:2077]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.3.19:2525] with esmtp (Farcaster)
 id 11fe78e0-ccb2-4b75-a9c5-f2e8876294cb; Thu, 12 Feb 2026 02:59:21 +0000 (UTC)
X-Farcaster-Flow-ID: 11fe78e0-ccb2-4b75-a9c5-f2e8876294cb
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:59:20 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:59:20 +0000
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
Subject: [PATCH 046/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_SM3_GENERIC crypto
Date: Thu, 12 Feb 2026 02:46:22 +0000
Message-ID: <20260212024725.11264-47-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D041UWB004.ant.amazon.com (10.13.139.143) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_SM3_GENERIC-related crypto to convert them into pluggable
interface.

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile      | 2 +-
 crypto/sm3_generic.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index ba7bc1e3a65a..64df3408cca0 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -83,7 +83,7 @@ crypto-objs-$(CONFIG_CRYPTO_SHA1) += sha1.o
 crypto-objs-$(CONFIG_CRYPTO_SHA256) += sha256.o
 crypto-objs-$(CONFIG_CRYPTO_SHA512) += sha512.o
 crypto-objs-$(CONFIG_CRYPTO_SHA3) += sha3.o
-obj-$(CONFIG_CRYPTO_SM3_GENERIC) += sm3_generic.o
+crypto-objs-$(CONFIG_CRYPTO_SM3_GENERIC) += sm3_generic.o
 obj-$(CONFIG_CRYPTO_STREEBOG) += streebog_generic.o
 obj-$(CONFIG_CRYPTO_WP512) += wp512.o
 CFLAGS_wp512.o := $(call cc-option,-fno-schedule-insns)  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79149
diff --git a/crypto/sm3_generic.c b/crypto/sm3_generic.c
index 7529139fcc96..90e75d3576d2 100644
--- a/crypto/sm3_generic.c
+++ b/crypto/sm3_generic.c
@@ -62,8 +62,8 @@ static void __exit sm3_generic_mod_fini(void)
 	crypto_unregister_shash(&sm3_alg);
 }
 
-module_init(sm3_generic_mod_init);
-module_exit(sm3_generic_mod_fini);
+crypto_module_init(sm3_generic_mod_init);
+crypto_module_exit(sm3_generic_mod_fini);
 
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("SM3 Secure Hash Algorithm");
-- 
2.47.3

