Received: from pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.1.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF887E55C;
	Thu, 12 Feb 2026 03:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.1.125
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770865814; cv=none; b=m9Oaxjs8A37ITvpkZM4vfLzUzgmH+qhlSZnaJPYGoOq8vkSwipbEAHvpFCKHRGSZRGefaffzhOtknfGH3SZoxd6WjkchG8hp3rjylmWm5hS58y9orXD1h6AXYDm83sh3xeGZTC+uBjUmc3/TCygu3L86ejHDBRLPhBBbE+bywSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770865814; c=relaxed/simple;
	bh=/9ax83p4NlGFDGgDRhiuIVSxdMnbo0XLxgjjSx5dIj4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JCZNv8DW4KhCWYULzp94IVmmijcGMS2Bal/FgsY4wc+nNip4bH68gXNeIVME+5R4K85EPvNvaRXGuj6nXN1Supm6u9rWK7Oi76myiYckh66F0dqPMGtR9bD2eovG5gtHRlGrSt8egLFgxqx40he71mo9U+dZtQfiepSUjOqzpuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=b5ifjfqm; arc=none smtp.client-ip=44.246.1.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="b5ifjfqm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770865813; x=1802401813;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GmFZJZLh+VrOYGfoIXopF4QjcZTypEUNkKPNha+2uEA=;
  b=b5ifjfqmoM7JHDc07eb+4ltg+cGlEd2B5vRzc8qTHYHZrvYQMhmIUbAJ
   ceJwKsET8q7ib5be/XZnOtSLieQIdVKauTPrgq2+tAPqX6svZXrSe8WxX
   3WhTsxSwOZAqOOVfZi0OavJcwe5dsUT4m/ibKw21CTT9G3a1cOeyPzkEm
   m5g+RoqiWRDl3nYccuxu1Lr05drCuFXthbcx7mxGprhmHyItSmw2FdilY
   ccWX5w7PycvS5REtXkAKi76/2ZWis+7hLNgV4gUBE0twt6xJ9dGKti4Wi
   vYLMU1bcBOaymGmXlHv5DUn7vZvi51y/Q1w+ySqKpp/O1tV40WUq5KuIG
   w==;
X-CSE-ConnectionGUID: uHiUjtzvSwSenqpsMZqtRw==
X-CSE-MsgGUID: wXNhRV7sSFaKj7E9MomjPA==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12919622"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 03:10:13 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:24188]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.29.209:2525] with esmtp (Farcaster)
 id 7bccf9d2-13eb-4a39-a412-5df6718e5e91; Thu, 12 Feb 2026 03:10:13 +0000 (UTC)
X-Farcaster-Flow-ID: 7bccf9d2-13eb-4a39-a412-5df6718e5e91
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:10:13 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:10:13 +0000
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
Subject: [PATCH 088/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_USER_API_AEAD crypto
Date: Thu, 12 Feb 2026 02:47:04 +0000
Message-ID: <20260212024725.11264-89-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D042UWA002.ant.amazon.com (10.13.139.17) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_USER_API_AEAD-related crypto to convert them into pluggable
interface.

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile     | 2 +-
 crypto/algif_aead.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 9d96e67cdfdf..3f4cd954ef06 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -176,7 +176,7 @@ crypto-objs-$(CONFIG_CRYPTO_USER_API) += af_alg.o
 crypto-objs-$(CONFIG_CRYPTO_USER_API_HASH) += algif_hash.o
 crypto-objs-$(CONFIG_CRYPTO_USER_API_SKCIPHER) += algif_skcipher.o
 crypto-objs-$(CONFIG_CRYPTO_USER_API_RNG) += algif_rng.o
-obj-$(CONFIG_CRYPTO_USER_API_AEAD) += algif_aead.o
+crypto-objs-$(CONFIG_CRYPTO_USER_API_AEAD) += algif_aead.o
 obj-$(CONFIG_CRYPTO_ZSTD) += zstd.o
 crypto-objs-$(CONFIG_CRYPTO_ECC) += ecc.o
 obj-$(CONFIG_CRYPTO_ESSIV) += essiv.o
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 79b016a899a1..59df4eabd2f5 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -521,8 +521,8 @@ static void __exit algif_aead_exit(void)
 	BUG_ON(err);
 }
 
-module_init(algif_aead_init);
-module_exit(algif_aead_exit);
+crypto_module_init(algif_aead_init);
+crypto_module_exit(algif_aead_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
 MODULE_DESCRIPTION("AEAD kernel crypto API user space interface");
-- 
2.47.3

