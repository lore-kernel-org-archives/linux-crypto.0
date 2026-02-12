Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29E021C16A;
	Thu, 12 Feb 2026 03:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.155.198.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770865550; cv=none; b=ltxMkNv48USdUT7mrRYkGAe0dzkN/VIg7SmkVxQ31a/1CUvUfm4hoK0tRKmeiBk6QkHxq+fhWrT5eB0Tur5p/cih27cPYIAL91aiDahGom9pmT0l1zc5RduqMPuzndsfrUFfo3BkvTUrD6fkWMGaH1sHdgD9R1iJFUDwRyk6luo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770865550; c=relaxed/simple;
	bh=K1LNDSYxWVngwRtHsnti7WMMt/hosi814eRC+PzrmWw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ilI1bqfoEYuV9bzBf+FIpQGtPBpgp2amnuLGNTWg0y4EbpUrn+5DFaHSx7Olw0ahago9eexSovQSD5KSfK3uCjHvYPN6pfMu0jTSzvUyf7fj62oCNuyeseoL5d/hXC9EGs2mNQY123UML3pmqBsW6oKbEQHxHbvM8XNV7Kb4Kcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=LoxAAReN; arc=none smtp.client-ip=35.155.198.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="LoxAAReN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770865549; x=1802401549;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q6R+WJeNWz557jM/PqZlqQw/Mxz686fCKn/ZBf5ChNQ=;
  b=LoxAAReNpmgl4BahdRa2eaN1BCPuXoGJrzn/Z9nnGJpCIk8TEj2gP5qH
   owHBox035v1qVOrPgojgaaokOoacQwu23icApxirFAtfqUKl1SlUHNkDz
   NscZb/5UDlEWvLXvzpM1KBJMyviBQxKp2WWNir7eCLryf6sY2fKDXmGPb
   Se6Bz1BClY7WrYSGe/2ZrerhuaNsLLxxe3yRrMaPK6w1tDbEwMTg6U9eB
   /6QkL0jHfNohHsazBrQI0W8l/YPJccUhgIrNHmrihUBZQGc08hhKvAuns
   TUlYsF2NMLznSfimkJ1vxZ0pJdM0pdxqlrg6KmP7UZ4KnJ3i1VJuqv9Dk
   Q==;
X-CSE-ConnectionGUID: ZQRwMihiR36JSztvng71aA==
X-CSE-MsgGUID: Tcoi77cLSnysFiAIV0ucVA==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12803769"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 03:05:49 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.51:5863]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.29.209:2525] with esmtp (Farcaster)
 id 53d11213-d454-4e6a-8e18-b2a18c4142ac; Thu, 12 Feb 2026 03:05:49 +0000 (UTC)
X-Farcaster-Flow-ID: 53d11213-d454-4e6a-8e18-b2a18c4142ac
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:05:49 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:05:48 +0000
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
Subject: [PATCH 071/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_USER_API_SKCIPHER crypto
Date: Thu, 12 Feb 2026 02:46:47 +0000
Message-ID: <20260212024725.11264-72-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D042UWB002.ant.amazon.com (10.13.139.175) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_USER_API_SKCIPHER-related crypto to convert them into
pluggable interface.

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile         | 2 +-
 crypto/algif_skcipher.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 5c363d865b45..a7ad0f5dd1d9 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -174,7 +174,7 @@ obj-$(CONFIG_CRYPTO_BENCHMARK) += tcrypt.o
 crypto-objs-$(CONFIG_CRYPTO_GHASH) += ghash-generic.o
 crypto-objs-$(CONFIG_CRYPTO_USER_API) += af_alg.o
 obj-$(CONFIG_CRYPTO_USER_API_HASH) += algif_hash.o
-obj-$(CONFIG_CRYPTO_USER_API_SKCIPHER) += algif_skcipher.o
+crypto-objs-$(CONFIG_CRYPTO_USER_API_SKCIPHER) += algif_skcipher.o
 obj-$(CONFIG_CRYPTO_USER_API_RNG) += algif_rng.o
 obj-$(CONFIG_CRYPTO_USER_API_AEAD) += algif_aead.o
 obj-$(CONFIG_CRYPTO_ZSTD) += zstd.o
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 125d395c5e00..8fbfb6c7ba14 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -435,7 +435,7 @@ static void __exit algif_skcipher_exit(void)
 	BUG_ON(err);
 }
 
-module_init(algif_skcipher_init);
-module_exit(algif_skcipher_exit);
+crypto_module_init(algif_skcipher_init);
+crypto_module_exit(algif_skcipher_exit);
 MODULE_DESCRIPTION("Userspace interface for skcipher algorithms");
 MODULE_LICENSE("GPL");
-- 
2.47.3

