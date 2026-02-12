Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378008C1F;
	Thu, 12 Feb 2026 02:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.26.1.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770864759; cv=none; b=us/VrLJ+7Uikot58eD52qNRhHMGsLRu2uOwPU8VZRBO7qUHs6KFNAWF/KYwQGY3Ng7X5/S4qRBzy4bvtyM7UL/hPUJJKhBynkiDSXZUMQbj/DWKicu8FshaqJ3R3u68OxsAVo+5I+Svn+eZQLBvXlU0rKStIHXcyflpMX0rsix8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770864759; c=relaxed/simple;
	bh=/PJQiGW8Okw7PTJcx/mjeV4j17MFz8U+JwMShMXI+Q4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y6NHt824Xt7M+o6ET1j8WiQpaoFg94wDzakv1HB5QfQFtr4eNc0VvYd20Q8gMfpsG/beUyeRb8du+x4Mg3Bw2Dq/bzjFHR5ZsL+pV5J2/R5avC2d7egOLr3/vMl1psmlkW0f7eYT7Ne+v1RLx5VyAQQ9+ZftleNhC0x/6ptY7dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=a+98GWvV; arc=none smtp.client-ip=52.26.1.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="a+98GWvV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770864758; x=1802400758;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MEj/8o0di6SXzRDFr2QhB2FSCNXafB52iKdFDtnLQZw=;
  b=a+98GWvVG+DFii2BP6KILCtse69SD7JRrwReYGRC39xX/pSRo0K2C1Zp
   QtZQG6TXy1sdCuAfJMsigUjH/6WQInqLPiKRyaB/ige7opM9G3jSbGahK
   H3KMTWfg/yDPMw/niYCDYif42gHmRgS3C9GrH+oyCAnoSSdWwgSQnBFdM
   umR3HxB4IyVKaYH1VuArf79w/1Xc9EZE1dBNCGsp2ChcbZsND/xyVUaNR
   cl1rSzc7SPGxSiv+CkVd9kyNFd4W0uTzCaTlQli6EdD5aVbMicPzwnk/c
   B1BOxvlW2vAa4DbFp/6CB+Eu7vSvw30/M2Fypq9TrabURfa+ONPgBxkwJ
   w==;
X-CSE-ConnectionGUID: n2pRfEDeR9yq1s+J/lHJJA==
X-CSE-MsgGUID: RDLY3WP4Q6Wdc6L8NkI8bQ==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12917961"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 02:52:37 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:22788]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.0.85:2525] with esmtp (Farcaster)
 id 16e310c7-f260-4501-81d5-536019038d8f; Thu, 12 Feb 2026 02:52:37 +0000 (UTC)
X-Farcaster-Flow-ID: 16e310c7-f260-4501-81d5-536019038d8f
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:52:37 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:52:36 +0000
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
Subject: [PATCH 020/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_SHA3 crypto
Date: Thu, 12 Feb 2026 02:45:56 +0000
Message-ID: <20260212024725.11264-21-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D044UWB004.ant.amazon.com (10.13.139.134) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_SHA3-related crypto to convert them into pluggable
interface.

This patch is partially based on work by Vegard Nossum, with
modifications. Unlike the original, we do not include
DEFINE_CRYPTO_API since only one copy of the crypto symbols is
kept, either in the crypto module or in the main kernel, and we ensure
such wrapper do not have impact on crypto already chosen built as
module.

Co-developed-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile | 2 +-
 crypto/sha3.c   | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 47ff0136c7c5..251b20fad9c2 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -82,7 +82,7 @@ obj-$(CONFIG_CRYPTO_RMD160) += rmd160.o
 obj-$(CONFIG_CRYPTO_SHA1) += sha1.o
 crypto-objs-$(CONFIG_CRYPTO_SHA256) += sha256.o
 crypto-objs-$(CONFIG_CRYPTO_SHA512) += sha512.o
-obj-$(CONFIG_CRYPTO_SHA3) += sha3.o
+crypto-objs-$(CONFIG_CRYPTO_SHA3) += sha3.o
 obj-$(CONFIG_CRYPTO_SM3_GENERIC) += sm3_generic.o
 obj-$(CONFIG_CRYPTO_STREEBOG) += streebog_generic.o
 obj-$(CONFIG_CRYPTO_WP512) += wp512.o
diff --git a/crypto/sha3.c b/crypto/sha3.c
index 8f364979ec89..1aefb256dd72 100644
--- a/crypto/sha3.c
+++ b/crypto/sha3.c
@@ -145,13 +145,13 @@ static int __init crypto_sha3_mod_init(void)
 {
 	return crypto_register_shashes(algs, ARRAY_SIZE(algs));
 }
-module_init(crypto_sha3_mod_init);
+crypto_module_init(crypto_sha3_mod_init);
 
 static void __exit crypto_sha3_mod_exit(void)
 {
 	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
 }
-module_exit(crypto_sha3_mod_exit);
+crypto_module_exit(crypto_sha3_mod_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Crypto API support for SHA-3");
-- 
2.47.3

