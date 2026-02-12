Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A4D8C1F;
	Thu, 12 Feb 2026 02:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.245.243.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770864929; cv=none; b=qxglD2wF9l6wQlamFJwiO+NVJm6iBdaHno2lKmcTiE5L14w/BddqpTWeE/LQcTkhbnNbMeoUaCC/QDFF9QlWJdJ/WJaj/1/tpB5glMYEn2OjkX09nx02JxMzmchb6/ULyNisGCUwEfPNkLnCVbCxpYhkaOjZasC7WDHEF2Vm3E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770864929; c=relaxed/simple;
	bh=xvgHLt/f48wEhR88uXqk8+TizFysvr3UBnH+SxZFurw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R+yRCpukzIfe5HGFslKMQn4ZAKTwMow3WdLcmWyF3TbM5M/vFZF4x6sf4FTYgkjojnQu66U19ozBAbHQhHKIpvMDV+Ol5sl7rCc0WQoW1ZT7lx7NsDP6A99bkv+p084vLX/TsZbRj68CqBFn2aHBt8mzvoYqyKfy+fpNrKuJPTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=RpueujUg; arc=none smtp.client-ip=44.245.243.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="RpueujUg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770864928; x=1802400928;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8RAu+ngRu7VaJdEnVHpRjXf3jf5khVFBS8T9OL30w4g=;
  b=RpueujUgESH2S0Eby6kf+O5tFR/2rYwwdKA+4542bshO0RX1lLQJAj0A
   J0yRzOa5zum3nbdgEkpnHQRy86F3VbfaprO4vf25TC0v8bh7lHJ7jDWWI
   Yz7Z3VamGk0QUoVhHVx/zHx+bVzRy1cmVRTgC7C5xh5YettllXxQg1lVQ
   TrCrPj0KswT8o1H9U5R0ruEwtkzwwPsV7uOwseu+4FYVmBkqxxoKVupLy
   SOC1ce0d+hUljxUwF3Q+fxvO93oRAi4tWk2s88UdrczIu3V8n+WaE6Uhp
   tsG/K+vARRU2O8jfKlRp0Mocgpku5IhscpKXzj/5DNl5O32xbFb/unWcm
   g==;
X-CSE-ConnectionGUID: gpHKtz4YTLG1rHyqtyz9CQ==
X-CSE-MsgGUID: AtxtWYvsQEKWGC83ast3Hw==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12455045"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 02:55:28 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:26346]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.40.228:2525] with esmtp (Farcaster)
 id 53fd7e8e-f714-48b8-b5b3-72121ae549e1; Thu, 12 Feb 2026 02:55:28 +0000 (UTC)
X-Farcaster-Flow-ID: 53fd7e8e-f714-48b8-b5b3-72121ae549e1
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:55:27 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:55:27 +0000
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
Subject: [PATCH 031/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_GHASH crypto
Date: Thu, 12 Feb 2026 02:46:07 +0000
Message-ID: <20260212024725.11264-32-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D043UWA004.ant.amazon.com (10.13.139.41) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

From: Vegard Nossum <vegard.nossum@oracle.com>

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_GHASH-related crypto to convert them into pluggable
interface.

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
[add ghash-generic.o into crypto-objs-y; revise commit message]
Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile        | 2 +-
 crypto/ghash-generic.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 1d5ee8dc24d9..d58b5e2b5b43 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -171,7 +171,7 @@ UBSAN_SANITIZE_jitterentropy.o = n
 jitterentropy_rng-y := jitterentropy.o jitterentropy-kcapi.o
 obj-$(CONFIG_CRYPTO_JITTERENTROPY_TESTINTERFACE) += jitterentropy-testing.o
 obj-$(CONFIG_CRYPTO_BENCHMARK) += tcrypt.o
-obj-$(CONFIG_CRYPTO_GHASH) += ghash-generic.o
+crypto-objs-$(CONFIG_CRYPTO_GHASH) += ghash-generic.o
 obj-$(CONFIG_CRYPTO_USER_API) += af_alg.o
 obj-$(CONFIG_CRYPTO_USER_API_HASH) += algif_hash.o
 obj-$(CONFIG_CRYPTO_USER_API_SKCIPHER) += algif_skcipher.o
diff --git a/crypto/ghash-generic.c b/crypto/ghash-generic.c
index e5803c249c12..37e98aa546c7 100644
--- a/crypto/ghash-generic.c
+++ b/crypto/ghash-generic.c
@@ -153,8 +153,8 @@ static void __exit ghash_mod_exit(void)
 	crypto_unregister_shash(&ghash_alg);
 }
 
-module_init(ghash_mod_init);
-module_exit(ghash_mod_exit);
+crypto_module_init(ghash_mod_init);
+crypto_module_exit(ghash_mod_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("GHASH hash function");
-- 
2.47.3

