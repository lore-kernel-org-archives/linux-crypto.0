Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35361E511;
	Thu, 12 Feb 2026 02:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.77.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770865178; cv=none; b=DjTR9TIQFbIpFViId+4FlorJQ8hf8P7oeVUzjQMZ0KhUpcPo0BssjXHZCNivTZfBKl0lcyaIDAfrKThrq3gJJtocqBytUE5rUTpo9E4LaRhyqg/oVKeN0qMPsXA+ontlINC+XrtvVeqLSb/F5ZSga8gEXkSad7XcKVrj9KgECR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770865178; c=relaxed/simple;
	bh=GtJWu0jaRuwXGewPGPx/ZEd2jpiibr/n/7DtTHSbQ8U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X+pKY9ITewfZLk/rcAOJbPraCK2xYkhyv/Bzy6UlK9/Ovw33H67PSA+lFLEX2toEfMKiXhG0Ep4Sm6AWteWBIBw1Lihngk4UAhv9Namo+qvAqULDDyvd9kq8AmzkjoE0LU60dHj7vlhN3dsYFONyEmaK+Vo2hK/hyDcEDf4EeHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=W9y89bho; arc=none smtp.client-ip=44.246.77.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="W9y89bho"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770865176; x=1802401176;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hH2tH6xkr3A879ixKLGX+Ri2Yt7DrS4xVYJlhMwU1fk=;
  b=W9y89bhozNMdVDsE7zSbvH14d3RABUkK7KIJRZ9IINjVlpz7xNjR5tzj
   /IKuzMVrh045aTr2m+bOPyoqrNvh7fMsg5bllhU84sP64Qok/qU/UeWJv
   T/hrT2aX4D5tLpPY0DiTUyVvM5F5knEJkk+s5LUQokYWvvMZUj+lF70xh
   04r8aYLbhhUxrY3DQXUWli6ZSFUsMMdzEeGKYFupBw5/hWE7T7DazLg3y
   P6Qu0jSetLfI22yuOCZf+kYd64e7IcBH67xBAQeptmiJsUr39r6Snruv9
   o8/mgePkgxOfeNf5h+vTvF1Xfsl61kxsrbXewEoTq+AnFtlTldGufp63K
   g==;
X-CSE-ConnectionGUID: YFMtRFFXSSyEPQ1e/9EbRw==
X-CSE-MsgGUID: gjLO+XAOQYijfet4sFquCA==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12914618"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 02:59:36 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:7592]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.3.19:2525] with esmtp (Farcaster)
 id d6c2b9b7-c67a-4478-b42a-1310688a15d5; Thu, 12 Feb 2026 02:59:36 +0000 (UTC)
X-Farcaster-Flow-ID: d6c2b9b7-c67a-4478-b42a-1310688a15d5
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:59:36 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:59:36 +0000
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
Subject: [PATCH 047/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_STREEBOG crypto
Date: Thu, 12 Feb 2026 02:46:23 +0000
Message-ID: <20260212024725.11264-48-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D044UWA003.ant.amazon.com (10.13.139.43) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_STREEBOG-related crypto to convert them into pluggable
interface.

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile           | 2 +-
 crypto/streebog_generic.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 64df3408cca0..c83ad9bb4324 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -84,7 +84,7 @@ crypto-objs-$(CONFIG_CRYPTO_SHA256) += sha256.o
 crypto-objs-$(CONFIG_CRYPTO_SHA512) += sha512.o
 crypto-objs-$(CONFIG_CRYPTO_SHA3) += sha3.o
 crypto-objs-$(CONFIG_CRYPTO_SM3_GENERIC) += sm3_generic.o
-obj-$(CONFIG_CRYPTO_STREEBOG) += streebog_generic.o
+crypto-objs-$(CONFIG_CRYPTO_STREEBOG) += streebog_generic.o
 obj-$(CONFIG_CRYPTO_WP512) += wp512.o
 CFLAGS_wp512.o := $(call cc-option,-fno-schedule-insns)  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79149
 obj-$(CONFIG_CRYPTO_BLAKE2B) += blake2b.o
diff --git a/crypto/streebog_generic.c b/crypto/streebog_generic.c
index 57bbf70f4c22..1ed42a26bec9 100644
--- a/crypto/streebog_generic.c
+++ b/crypto/streebog_generic.c
@@ -1061,8 +1061,8 @@ static void __exit streebog_mod_fini(void)
 	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
 }
 
-module_init(streebog_mod_init);
-module_exit(streebog_mod_fini);
+crypto_module_init(streebog_mod_init);
+crypto_module_exit(streebog_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Vitaly Chikunov <vt@altlinux.org>");
-- 
2.47.3

