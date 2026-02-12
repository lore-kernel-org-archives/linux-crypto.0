Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4529223705;
	Thu, 12 Feb 2026 02:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.34.181.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770865132; cv=none; b=PImC/6H0LzJ2pkzlHtxRE3Uk81xLAi57F5irTsqxAnhqp32EtWaAvxmVRMcFFFSHHKyWnrmMHxXcqOiKWxRd5DL2PP0CnQYWvf/sefKH975y0pD4Uj/CC4kndkt7NUV1N8RuDustLHTojEIakIJeRMe7hXHDREd/560AhySTaq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770865132; c=relaxed/simple;
	bh=jVBaLQVVByxCHTxwDjes+5Ey2GXWlLvKsmFDBrjATxU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P3tsAxpJV8vriJPQnLX/FwRpIF53o7Ea96eXP+xV6kFDz4ddPxNWIJMhk7TSzlbVI0wfnOLH75uml8aWaRcSN+oUOKVEWVoR+CRZZlXXkgGOSjGf4gTeta9yaqYfCk8QspvI50z7lFRPH3LtIh8r1vl+YJfu1JRyrBbEkBOXxTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=CAhNeGZ4; arc=none smtp.client-ip=52.34.181.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="CAhNeGZ4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770865130; x=1802401130;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9cf5xMhPaTzUvZY+QOd1rtkTKbEHRWxhzTBxa1aBZ9A=;
  b=CAhNeGZ4jU+2rhULGawIoXmMISigFZ2JAIqXpVz242kU/1FgsAFruSUk
   vjPCGGRR/9MxIQ2RAvQhLXs9bkVmzmmNzl5mssHeY5Y9aSoZTn0XYglT7
   pQK5nfGA+0mLvzIRc/whxx+wUaf9DggXUDR9Hp23QcHKRg1IQSVllCOgw
   RDb5STp0oRtKRefTD9Y1c0wP7Y7eida5gtkoVQq5FSU7V+vv3s34r25E6
   EbMVycYcZF8S5B24LnFLVVg3A6xmQsAMKgp0vD2Ue2dwAbxP9KotqGQw0
   mfsxgM2vceowCtgjYXvi3cfpUzLfQHxhfNs+oq4bj9HkYwpXGlQCSNc0l
   Q==;
X-CSE-ConnectionGUID: lPWNgdz6Scuwx5jfRxduKQ==
X-CSE-MsgGUID: ymlN53C4RsSElsaYwnDWQw==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12919659"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 02:58:50 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:7648]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.29.209:2525] with esmtp (Farcaster)
 id 2ba7dc71-98cf-42ac-a794-02aef3cebc62; Thu, 12 Feb 2026 02:58:50 +0000 (UTC)
X-Farcaster-Flow-ID: 2ba7dc71-98cf-42ac-a794-02aef3cebc62
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:58:49 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:58:49 +0000
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
Subject: [PATCH 044/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_RMD160 crypto
Date: Thu, 12 Feb 2026 02:46:20 +0000
Message-ID: <20260212024725.11264-45-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_RMD160-related crypto to convert them into pluggable
interface.

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile | 2 +-
 crypto/rmd160.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 32f038ff47de..45f0ae639ccd 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -78,7 +78,7 @@ crypto-objs-$(CONFIG_CRYPTO_XCBC) += xcbc.o
 crypto-objs-$(CONFIG_CRYPTO_NULL) += crypto_null.o
 crypto-objs-$(CONFIG_CRYPTO_MD4) += md4.o
 crypto-objs-$(CONFIG_CRYPTO_MD5) += md5.o
-obj-$(CONFIG_CRYPTO_RMD160) += rmd160.o
+crypto-objs-$(CONFIG_CRYPTO_RMD160) += rmd160.o
 obj-$(CONFIG_CRYPTO_SHA1) += sha1.o
 crypto-objs-$(CONFIG_CRYPTO_SHA256) += sha256.o
 crypto-objs-$(CONFIG_CRYPTO_SHA512) += sha512.o
diff --git a/crypto/rmd160.c b/crypto/rmd160.c
index 9860b60c9be4..0d68e7b763d8 100644
--- a/crypto/rmd160.c
+++ b/crypto/rmd160.c
@@ -342,8 +342,8 @@ static void __exit rmd160_mod_fini(void)
 	crypto_unregister_shash(&alg);
 }
 
-module_init(rmd160_mod_init);
-module_exit(rmd160_mod_fini);
+crypto_module_init(rmd160_mod_init);
+crypto_module_exit(rmd160_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Adrian-Ken Rueegsegger <ken@codelabs.ch>");
-- 
2.47.3

