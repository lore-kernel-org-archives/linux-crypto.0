Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE291E511;
	Thu, 12 Feb 2026 02:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.77.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770865149; cv=none; b=mHNJ/nk0H2NNA/EJZFucrA4LKF3uNVf8jKRSYnZdFNibJ3Q15XDVTPUx+AJzmgoB6Zq4dXbI6NQKsali6SSO3zZ6PiFqh9w9jVKejQFCHzNZeunnzPg3b6Rv0fQnZzwF0pJoHFBygxsFayK+PxQ+9JK/t1B4YqC0dXG4BT32ue4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770865149; c=relaxed/simple;
	bh=pa+GYTc/XZONgt6UkujLPtpTRU3+4xheqljvavqLr/U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LIIp2gqmL4iLmuoVluyJ0Ix5YeBbX8p+xbn5ZAtfHRRJlqWpexukbot7lhoCBN0bZSfw3LPKV/hLsTDH5L+WEA0Ocmwo/MZJUvLAEVqyEe01rsC2ju2D4cQ/Kc69r5Sd2dQRoVqFqAejQOdq/2ppWwud/Cn86YzqA6WPo8zvP9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=R6gaRns7; arc=none smtp.client-ip=44.246.77.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="R6gaRns7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770865148; x=1802401148;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PooI7hlgZLR+IQB4TgRDtdyU3XZA0Ua3ZFUPe1/xEyA=;
  b=R6gaRns7xwf0sEY8jIZ367+M1mT2jX4FgxEmXHkTgTA5VH33LetkepuB
   Iob1VzrwYeQtPVtq7AWb2t2MKTMKNfYEyYoRg/cJo+q7UfJlw/GkeN1tJ
   XUEd0IM826YVxl0HgcJjmOtrQW/WytkKOfk5dNlglvf5dP1iPWutQVKLq
   //wO0pLu0LZXDYXmjj1Ip4PGvf74yDh8MzVgDrTkjstI9lLqRnqot4kLG
   CDiw2RW/EkH9HvC3wZr7dZVTslKjXsTlCO64ZHoU1LhqAWa8snsMqncNJ
   d6Wbn82Irg168AF11vbV9ze+FMq7K07dakfgi7eQL9USR7y7HDqL6WF45
   A==;
X-CSE-ConnectionGUID: 8oP4MU7SRRqwQazyVfd8XA==
X-CSE-MsgGUID: 4T/CMZOpSuOs+H7WgXGqOw==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12914600"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 02:59:08 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:19076]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.61.62:2525] with esmtp (Farcaster)
 id a87abc65-028d-4053-aaaa-8c6744364d89; Thu, 12 Feb 2026 02:59:08 +0000 (UTC)
X-Farcaster-Flow-ID: a87abc65-028d-4053-aaaa-8c6744364d89
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:59:05 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:59:04 +0000
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
Subject: [PATCH 045/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_SHA1 crypto
Date: Thu, 12 Feb 2026 02:46:21 +0000
Message-ID: <20260212024725.11264-46-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D044UWA002.ant.amazon.com (10.13.139.11) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_SHA1-related crypto to convert them into pluggable
interface.

Co-developed-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile | 2 +-
 crypto/sha1.c   | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 45f0ae639ccd..ba7bc1e3a65a 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -79,7 +79,7 @@ crypto-objs-$(CONFIG_CRYPTO_NULL) += crypto_null.o
 crypto-objs-$(CONFIG_CRYPTO_MD4) += md4.o
 crypto-objs-$(CONFIG_CRYPTO_MD5) += md5.o
 crypto-objs-$(CONFIG_CRYPTO_RMD160) += rmd160.o
-obj-$(CONFIG_CRYPTO_SHA1) += sha1.o
+crypto-objs-$(CONFIG_CRYPTO_SHA1) += sha1.o
 crypto-objs-$(CONFIG_CRYPTO_SHA256) += sha256.o
 crypto-objs-$(CONFIG_CRYPTO_SHA512) += sha512.o
 crypto-objs-$(CONFIG_CRYPTO_SHA3) += sha3.o
diff --git a/crypto/sha1.c b/crypto/sha1.c
index 4fbf61cf0370..fe7028d018a8 100644
--- a/crypto/sha1.c
+++ b/crypto/sha1.c
@@ -223,13 +223,13 @@ static int __init crypto_sha1_mod_init(void)
 {
 	return crypto_register_shashes(algs, ARRAY_SIZE(algs));
 }
-module_init(crypto_sha1_mod_init);
+crypto_module_init(crypto_sha1_mod_init);
 
 static void __exit crypto_sha1_mod_exit(void)
 {
 	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
 }
-module_exit(crypto_sha1_mod_exit);
+crypto_module_exit(crypto_sha1_mod_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Crypto API support for SHA-1 and HMAC-SHA1");
-- 
2.47.3

