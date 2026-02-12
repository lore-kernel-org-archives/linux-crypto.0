Received: from pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.1.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60024414;
	Thu, 12 Feb 2026 03:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.1.125
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770865318; cv=none; b=RTnlrPff2fQ+eqFqjAvltuNmaWm6fqhNh9c4wUh3fxPnHbd+NnL17aNcpv/n8YVeRrspLS9qzzcIthnF80e8P4xTwiXtttkv4N7NZHjkXrkzr2hX39ZaOGRdmA+1D9sorSNpACxe3nKdqSFWg5Q3SSLm7b9PGwAxy+HJs6SMG/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770865318; c=relaxed/simple;
	bh=CosO0OzhDMOO44DIRN8M7ombLhiThvkBK7pPNeG+xBc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o12fAu0Aldb9SQ1N/qhzIN3Vm4S9RxTVm8KVBSbt4pxJrdpji2zwa9DHeURyAUXfs30pQ848idLhldMZ5QJ8uYRXod7coGuejB6yrZrK+JS5WtZDRqHwl17+AABpMdkZSxi/3Ge8PuzrRGR9miC+L7Xi8yvOIFFGHgFxToWVVdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=RznnQmEL; arc=none smtp.client-ip=44.246.1.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="RznnQmEL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770865316; x=1802401316;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ba7TrYsKy0CKElBFKgJ/9lEirsZWbrJxW7zQwbgNkaQ=;
  b=RznnQmEL1QKTo5nuTDOxj+CpTL78Ubl5/pRmUcndGfEJaTvEw2WhU4Dr
   6Rw2mxrjwb39dz1X33N4pg0FzUIUATyvYwZWHAhYv/tuYPiV/R8UI+MrI
   PiF9E6toAb+qDcSqABKPhfb/xMBv6ZUAGS6GMLrtX72cOLleSGc4vx0N6
   BvosYpz124ZENU3UYTGtVi9wKOhMyCEAYOg8c4SJvtXFtQtNqmAVpTul+
   X+q4xCyOWfGN9k1eU7VfahMbjfYHIcS7xr2eakowXkTGvM98m42wPycrW
   bb+QART/BwaNg+cbua62OdpxiYfw9miJ/NJgsmkV3BnH368trxAfLh2kg
   w==;
X-CSE-ConnectionGUID: b4JrgIIcQmeYhxreuNA/0w==
X-CSE-MsgGUID: GjaxeTDCT6SB/mRkkSmEbg==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12919243"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 03:01:56 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:15805]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.61.62:2525] with esmtp (Farcaster)
 id fd62e522-8ff0-4998-a61d-eb7e543abb9d; Thu, 12 Feb 2026 03:01:56 +0000 (UTC)
X-Farcaster-Flow-ID: fd62e522-8ff0-4998-a61d-eb7e543abb9d
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:01:56 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:01:55 +0000
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
Subject: [PATCH 056/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_CHACHA20 crypto
Date: Thu, 12 Feb 2026 02:46:32 +0000
Message-ID: <20260212024725.11264-57-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D032UWA003.ant.amazon.com (10.13.139.37) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_CHACHA20-related crypto to convert them into pluggable
interface.

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile | 2 +-
 crypto/chacha.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 34e278185d16..cb509e854784 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -147,7 +147,7 @@ obj-$(CONFIG_CRYPTO_KHAZAD) += khazad.o
 obj-$(CONFIG_CRYPTO_ANUBIS) += anubis.o
 obj-$(CONFIG_CRYPTO_SEED) += seed.o
 obj-$(CONFIG_CRYPTO_ARIA) += aria_generic.o
-obj-$(CONFIG_CRYPTO_CHACHA20) += chacha.o
+crypto-objs-$(CONFIG_CRYPTO_CHACHA20) += chacha.o
 CFLAGS_chacha.o += -DARCH=$(ARCH)
 obj-$(CONFIG_CRYPTO_DEFLATE) += deflate.o
 obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
diff --git a/crypto/chacha.c b/crypto/chacha.c
index ec16d5a33f3c..13335c7e4941 100644
--- a/crypto/chacha.c
+++ b/crypto/chacha.c
@@ -161,8 +161,8 @@ static void __exit crypto_chacha_mod_fini(void)
 	crypto_unregister_skciphers(algs, ARRAY_SIZE(algs));
 }
 
-module_init(crypto_chacha_mod_init);
-module_exit(crypto_chacha_mod_fini);
+crypto_module_init(crypto_chacha_mod_init);
+crypto_module_exit(crypto_chacha_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Martin Willi <martin@strongswan.org>");
-- 
2.47.3

