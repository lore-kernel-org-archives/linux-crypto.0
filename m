Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E30621B9D2;
	Thu, 12 Feb 2026 03:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.26.1.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770865675; cv=none; b=WpVfN32hkl8mj+zPnTA1DHJNmSUP/zcA9EiR+YbiJR0PT4RQBLTzXn331jQXCTDIfIG2dznVTpfIKYc44mZ4/QFyVUj9xGWAfW1yCy2Njz7tB77W7elRBvElfgDPlq3USTwD3IXH6HG1KyzD6Rh5w/h8cocLYnI4tto3Y2vYFho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770865675; c=relaxed/simple;
	bh=/OmqEAjn0N25X1PREAM3iluCtmNFI8RPImOxlkGYZeg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Htg4WNT9boeiNx2+LuDWZRbfg5xAKIzM7NTbS+MvLEXqQkXOjFc4aQWJxCnfYDQQKD5MjYvJLZGg3/JaXnpqf4F43NOs+TirlqZkvF159Qiz5UGOMwjXqVwZiHhyuw7RfUj6tR5OM+KwNCKhw+P2kMig0QJfikX27tuSlgTxvus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=K9cdyGj6; arc=none smtp.client-ip=52.26.1.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="K9cdyGj6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770865674; x=1802401674;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/MM9/lfGKGixCO0cCT/QXCgbIKvyINBAPlL8hgocq9c=;
  b=K9cdyGj6JdYu+h8lfkOOZw7LYgANutpR5b6/m16I+iPMLZfSuf7QzXnF
   rJFIt1+eESQZAgOqsMN7itV5sjUWbf0K2Ukbzirdv7XOMZgeGwabZofV6
   xrSflCS7kDsKYha99PxTo2Alo26pqCdPxvWaRaBPl9no1iZdxx1WIJMX5
   8vgYKq0JSuSGhxXsjNEhDGGYrIn94DkRJGWwpaJOtD6VFzIJS9Hzj68CU
   iSVXzLjwp7EtUHNwOpWjdLpGcZte6d6ZpziUcocihPuvG/xHYOLNBBo+Y
   /n74BXkJ+wlZDaro1FeUeKUo7ycmPaJpnpIRbdCdAfwMqZF80HFeupIdz
   Q==;
X-CSE-ConnectionGUID: 0AsAnmPhTFugsicu9P0TFQ==
X-CSE-MsgGUID: EpnN48T3SZ2OeSx83d7vCw==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12918720"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 03:07:54 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:14435]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.40.228:2525] with esmtp (Farcaster)
 id 47f0067c-1ad6-4a5e-91e9-a8be92f30050; Thu, 12 Feb 2026 03:07:53 +0000 (UTC)
X-Farcaster-Flow-ID: 47f0067c-1ad6-4a5e-91e9-a8be92f30050
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:07:53 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:07:53 +0000
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
Subject: [PATCH 079/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_CRC32C and CONFIG_CRYPTO_CRC32 crypto
Date: Thu, 12 Feb 2026 02:46:55 +0000
Message-ID: <20260212024725.11264-80-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D043UWA003.ant.amazon.com (10.13.139.31) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_CRC32C- and CONFIG_CRYPTO_CRC32-related crypto to convert
them into pluggable interface.

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile | 4 ++--
 crypto/crc32.c  | 4 ++--
 crypto/crc32c.c | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index f8cd388ca03c..6d332c55fd4e 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -151,9 +151,9 @@ crypto-objs-$(CONFIG_CRYPTO_CHACHA20) += chacha.o
 CFLAGS_chacha.o += -DARCH=$(ARCH)
 crypto-objs-$(CONFIG_CRYPTO_DEFLATE) += deflate.o
 crypto-objs-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
-obj-$(CONFIG_CRYPTO_CRC32C) += crc32c-cryptoapi.o
+crypto-objs-$(CONFIG_CRYPTO_CRC32C) += crc32c-cryptoapi.o
 crc32c-cryptoapi-y := crc32c.o
-obj-$(CONFIG_CRYPTO_CRC32) += crc32-cryptoapi.o
+crypto-objs-$(CONFIG_CRYPTO_CRC32) += crc32-cryptoapi.o
 crc32-cryptoapi-y := crc32.o
 crypto-objs-$(CONFIG_CRYPTO_AUTHENC) += authenc.o authencesn.o
 obj-$(CONFIG_CRYPTO_KRB5ENC) += krb5enc.o
diff --git a/crypto/crc32.c b/crypto/crc32.c
index 489cbed9422e..cfbf86ed9926 100644
--- a/crypto/crc32.c
+++ b/crypto/crc32.c
@@ -120,8 +120,8 @@ static void __exit crc32_mod_fini(void)
 	crypto_unregister_shash(&alg);
 }
 
-module_init(crc32_mod_init);
-module_exit(crc32_mod_fini);
+crypto_module_init(crc32_mod_init);
+crypto_module_exit(crc32_mod_fini);
 
 MODULE_AUTHOR("Alexander Boyko <alexander_boyko@xyratex.com>");
 MODULE_DESCRIPTION("CRC32 calculations wrapper for lib/crc32");
diff --git a/crypto/crc32c.c b/crypto/crc32c.c
index 1eff54dde2f7..d8122c4aa26e 100644
--- a/crypto/crc32c.c
+++ b/crypto/crc32c.c
@@ -157,8 +157,8 @@ static void __exit crc32c_mod_fini(void)
 	crypto_unregister_shash(&alg);
 }
 
-module_init(crc32c_mod_init);
-module_exit(crc32c_mod_fini);
+crypto_module_init(crc32c_mod_init);
+crypto_module_exit(crc32c_mod_fini);
 
 MODULE_AUTHOR("Clay Haapala <chaapala@cisco.com>");
 MODULE_DESCRIPTION("CRC32c (Castagnoli) calculations wrapper for lib/crc32c");
-- 
2.47.3

