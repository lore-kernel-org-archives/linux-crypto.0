Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E292AE8D;
	Thu, 12 Feb 2026 03:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.218.115.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770865802; cv=none; b=TE5jstfieBF7H6ffUsIr3MDKfRKIsdAjDkqRZ3Uq8M1FLAzh8MpaXEOwR3c4DOEKy97Cl2K5cTSkxKw54pdElEM4/iFw5jM5z7gYP+V9cGJP5l8sv6FIuKsN4rVDAhGNMZLrWjU9ljPigoaWZevU4BaFSvsxDlHvqEyVsPn1r6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770865802; c=relaxed/simple;
	bh=kYdTiVaCicdKt+ZUemrgZE84lyliq3QyawXitrfGqiw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QLEKbE/ulfWzrbOE331XrPCSTc2623tGbkyI3RgJMWnuLP7Jd5P3kzkirJpZTNRbmiXPrrEIrOZ7nRLSxKhtHynWdxpNzXZZa2Vte3yjb+kPdzkOI6rDaRYp3tXmwG+RXH6SuF/GTJxwWJUc6nCvypAFqGpmHAT39dA9areULnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=mFJVo9G8; arc=none smtp.client-ip=34.218.115.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="mFJVo9G8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770865801; x=1802401801;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DkJvXXIDKm7o6lblg8CrOwWM/CEj39eFZHF/RazxHyQ=;
  b=mFJVo9G8kcetG2D82KuN9pbPrCqrLurl5dArOSyRouV/LRqrqBlq56Kq
   qYpDi3wzDr5mwX6Hf5dMXCbxWjjC/7KXbKeVZZ0+aHzMhe7Fy1lCbEaxr
   CmvNtXt5QLSegfvPVtJK1o64qt0a/D8j9trXHPTVflKgFQZgUWhBLmhr2
   DdXFViAjqyou5F8calZT2J6yeMJ8Gf8HAEadBdjVZbPZhasiKzMXmBaE0
   2nZcuZA8d1d0Oo2GIQz4TAnu4bFlf075BfszcKYAerLPvPSUq3h6XhTMC
   D3f0MiLpIO1RbWJu3yskX8NYUXE7E5tbK7YzmUxKHdwjp3n90DEeMRSWn
   Q==;
X-CSE-ConnectionGUID: 1WXS6G2BSZSVYgZD+ZCSpQ==
X-CSE-MsgGUID: 3wtRhC/JQO2Oful13B9EaA==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12727574"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 03:10:01 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:30846]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.54.219:2525] with esmtp (Farcaster)
 id 90327bb5-1600-43f4-8e95-262f633d390c; Thu, 12 Feb 2026 03:10:01 +0000 (UTC)
X-Farcaster-Flow-ID: 90327bb5-1600-43f4-8e95-262f633d390c
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:09:57 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:09:57 +0000
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
Subject: [PATCH 087/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_USER_API_RNG crypto
Date: Thu, 12 Feb 2026 02:47:03 +0000
Message-ID: <20260212024725.11264-88-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D033UWC001.ant.amazon.com (10.13.139.218) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_USER_API_RNG-related crypto to convert them into pluggable
interface.

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile    | 2 +-
 crypto/algif_rng.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 13d0ee856885..9d96e67cdfdf 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -175,7 +175,7 @@ crypto-objs-$(CONFIG_CRYPTO_GHASH) += ghash-generic.o
 crypto-objs-$(CONFIG_CRYPTO_USER_API) += af_alg.o
 crypto-objs-$(CONFIG_CRYPTO_USER_API_HASH) += algif_hash.o
 crypto-objs-$(CONFIG_CRYPTO_USER_API_SKCIPHER) += algif_skcipher.o
-obj-$(CONFIG_CRYPTO_USER_API_RNG) += algif_rng.o
+crypto-objs-$(CONFIG_CRYPTO_USER_API_RNG) += algif_rng.o
 obj-$(CONFIG_CRYPTO_USER_API_AEAD) += algif_aead.o
 obj-$(CONFIG_CRYPTO_ZSTD) += zstd.o
 crypto-objs-$(CONFIG_CRYPTO_ECC) += ecc.o
diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
index 1a86e40c8372..1604b164d973 100644
--- a/crypto/algif_rng.c
+++ b/crypto/algif_rng.c
@@ -335,5 +335,5 @@ static void __exit rng_exit(void)
 	BUG_ON(err);
 }
 
-module_init(rng_init);
-module_exit(rng_exit);
+crypto_module_init(rng_init);
+crypto_module_exit(rng_exit);
-- 
2.47.3

