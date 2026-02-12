Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CED33EBF31;
	Thu, 12 Feb 2026 03:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.13.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770865255; cv=none; b=VFKm2XOVXGY7lp6+NwuonfpqomnzYh6EnD/mBHXpWiyqMWYq8SY6VY162ENIjCAJ3S2E0PwY32g9q8Bngu5Rk4Dqg5TS424XV4pOFoRDcTdf2aoEoNO87uP7ZDYe7ZmUivWNJTZwxeYLQYOOxN3t+topcB3bvqXrHYk5wIKKuGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770865255; c=relaxed/simple;
	bh=uAFP+qIMd6likrX8QK3yR+oNeFWCETdnjgLMwiJLsYc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cr4qFtxwKv9VnvuuBUxOtU0qcrx7wnMmxtT+KE7OJ1COpcSS48sdFVS54FQtsF/ziXNxdmKQ8VoV7mLlKeo7WHK2Efi165vB9O+DoxQj8gXFmE2gfGCKuFv96OKE8OC7wFWO2cE9tEfJFk+icIsDmLgXxI41YaZjeVLdVj7pgkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=FAOdz/mk; arc=none smtp.client-ip=52.13.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="FAOdz/mk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770865254; x=1802401254;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5yfrK9ai1v7aCuOqEPDeHtTlKFbC6nmp0dDE5Sduaak=;
  b=FAOdz/mksqWzukjvtWrtZDt7Ef0H3flaTUfvCNYqVOOb3z23FwRWhC0R
   1zUkY1X1GIfq3zr1mFNFbxvAh+FB6YsYxcTImHfLxcZAZzxE9syKFjl2E
   pUUZcN4vBvXFRhR6udBoUcE1vcfXWM2+P3x6GFVYdJpm02N2uHGyNJ6Xs
   8y8NE3oritq7gEYgUci648qZMPaMDGOmGlTzKVN+w5yi2hb4pBfVv0oCJ
   DaHLwBfwUgyWUjju/sxTKC22sjyA8vQFWATs/+0Bnw4QrndzzUuwc+MrX
   8H31gZ3l+g9fFuplqlwjae1Bjq28S8sAsD0rMzE+ADs7tS9iwwWqNUta8
   Q==;
X-CSE-ConnectionGUID: gWH/hDnUQ46EhpeTmQfOEg==
X-CSE-MsgGUID: LMNwMjduQsOL7tS6fVWuMA==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12917995"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 03:00:54 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.51:9392]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.0.85:2525] with esmtp (Farcaster)
 id 5d98b2c6-763a-4a64-b0fb-277743aa4f95; Thu, 12 Feb 2026 03:00:54 +0000 (UTC)
X-Farcaster-Flow-ID: 5d98b2c6-763a-4a64-b0fb-277743aa4f95
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:00:53 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:00:53 +0000
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
Subject: [PATCH 052/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_LRW crypto
Date: Thu, 12 Feb 2026 02:46:28 +0000
Message-ID: <20260212024725.11264-53-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D045UWA004.ant.amazon.com (10.13.139.91) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_LRW-related crypto to convert them into pluggable
interface.

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile | 2 +-
 crypto/lrw.c    | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 9ee71f7c0af7..73c700538792 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -92,7 +92,7 @@ crypto-objs-$(CONFIG_CRYPTO_ECB) += ecb.o
 crypto-objs-$(CONFIG_CRYPTO_CBC) += cbc.o
 crypto-objs-$(CONFIG_CRYPTO_PCBC) += pcbc.o
 crypto-objs-$(CONFIG_CRYPTO_CTS) += cts.o
-obj-$(CONFIG_CRYPTO_LRW) += lrw.o
+crypto-objs-$(CONFIG_CRYPTO_LRW) += lrw.o
 obj-$(CONFIG_CRYPTO_XTS) += xts.o
 crypto-objs-$(CONFIG_CRYPTO_CTR) += ctr.o
 obj-$(CONFIG_CRYPTO_XCTR) += xctr.o
diff --git a/crypto/lrw.c b/crypto/lrw.c
index dd403b800513..776f052fa56d 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -420,8 +420,8 @@ static void __exit lrw_module_exit(void)
 	crypto_unregister_template(&lrw_tmpl);
 }
 
-module_init(lrw_module_init);
-module_exit(lrw_module_exit);
+crypto_module_init(lrw_module_init);
+crypto_module_exit(lrw_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("LRW block cipher mode");
-- 
2.47.3

