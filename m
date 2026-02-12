Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610028C1F;
	Thu, 12 Feb 2026 02:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.42.203.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770864728; cv=none; b=LDAtIfLTNbk2qSVmlSF4q+KiG2ibK2pS9xbrwqLOzdsyzGNVjpFTu9cP1V/3WxzS5nNUNnzLcbBR1mWUqHUXayRhdLEXHY4hZtGLP2nPGb8rPKPug2yZR/yw3dPAwLVwaJp+SSNR2O2h63TX6IoR+ptbI7UbRbqSxAnp+w2kxTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770864728; c=relaxed/simple;
	bh=YHUQd+YKdw1+vYcHnicqKYYJxr9dkUkexSJ5D9hmVA8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MZHct5YHh1WDLmIVN9YdziZu+74gEeBaYz8KmdxjLHg6L8Ec83f6zJsqXqi+fXayy6udBBvBcXVvfCDvI6Fp1jeEwOY0wAdjcoZklsna0I6jufv0188/H3HA4Lx7JQ5qg8fZKJd+475ZOJNHTepQRGBqeWQoZHOf0XGmJemR8Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=fITDwESq; arc=none smtp.client-ip=52.42.203.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="fITDwESq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770864727; x=1802400727;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1HEF96UIvuLZhOLdF7TvA/7nxzM5j6DQ/cqq0XHjHL8=;
  b=fITDwESqHKhObg7E9hDIo8igxiz9BUmTMRnIJykvEsWD7GUsjRAF88z4
   FsfyTjtoQImDwsopHyUZlXem3P5V7bdyQatAfQqlNC7LNX2mtgDATVQqC
   HgXNDnWAaQOK4Lc2eV+4hZBBlEng54/uO5fzno3kgbS/JYx/LiXUstcbz
   KOw1JQh6TMJe+MiDn8x9TRWUW+WBS9DHkIlnsb3tOugFmGc5SoCxD/n2S
   bZxP3HuCfX/jTbVatx3ixsOYSD0dxyDjDF0lmMm9xer0QMYNDq9afzdBF
   UzOefK0LhbWWKg9bvRAb6BQ/heA92tHFS/FXbZwb0JXJ7IECbC9tuZ/NW
   w==;
X-CSE-ConnectionGUID: 1AUlMe85RDOCETdGzNj39g==
X-CSE-MsgGUID: HABY2pL9QvSCrcWycpG9ZQ==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12913179"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 02:52:07 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:9276]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.42.95:2525] with esmtp (Farcaster)
 id c457d180-bfb4-47ce-8f37-b11207a9e75f; Thu, 12 Feb 2026 02:52:06 +0000 (UTC)
X-Farcaster-Flow-ID: c457d180-bfb4-47ce-8f37-b11207a9e75f
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:52:06 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:52:05 +0000
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
Subject: [PATCH 018/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_SHA256 crypto
Date: Thu, 12 Feb 2026 02:45:54 +0000
Message-ID: <20260212024725.11264-19-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D036UWB004.ant.amazon.com (10.13.139.170) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

From: Vegard Nossum <vegard.nossum@oracle.com>

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_SHA256-related crypto to convert them into pluggable
interface.

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
[add sha256.o into crypto-objs-y; revise commit message]
Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile | 2 +-
 crypto/sha256.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 6310c3e88e4b..45e055a8c0f4 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -80,7 +80,7 @@ obj-$(CONFIG_CRYPTO_MD4) += md4.o
 crypto-objs-$(CONFIG_CRYPTO_MD5) += md5.o
 obj-$(CONFIG_CRYPTO_RMD160) += rmd160.o
 obj-$(CONFIG_CRYPTO_SHA1) += sha1.o
-obj-$(CONFIG_CRYPTO_SHA256) += sha256.o
+crypto-objs-$(CONFIG_CRYPTO_SHA256) += sha256.o
 obj-$(CONFIG_CRYPTO_SHA512) += sha512.o
 obj-$(CONFIG_CRYPTO_SHA3) += sha3.o
 obj-$(CONFIG_CRYPTO_SM3_GENERIC) += sm3_generic.o
diff --git a/crypto/sha256.c b/crypto/sha256.c
index fb81defe084c..26ae39b4c1db 100644
--- a/crypto/sha256.c
+++ b/crypto/sha256.c
@@ -398,13 +398,13 @@ static int __init crypto_sha256_mod_init(void)
 {
 	return crypto_register_shashes(algs, ARRAY_SIZE(algs));
 }
-module_init(crypto_sha256_mod_init);
+crypto_module_init(crypto_sha256_mod_init);
 
 static void __exit crypto_sha256_mod_exit(void)
 {
 	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
 }
-module_exit(crypto_sha256_mod_exit);
+crypto_module_exit(crypto_sha256_mod_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Crypto API support for SHA-224, SHA-256, HMAC-SHA224, and HMAC-SHA256");
-- 
2.47.3

