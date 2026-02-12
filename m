Received: from pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com [50.112.246.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D601BC46;
	Thu, 12 Feb 2026 02:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=50.112.246.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770864681; cv=none; b=ZsXAPE8RKTPRkUNEeBWtpgmEL4h9akFRYxUHWCSuyUu8BZ0wcdkQ0/Y+A7gQiqOb2BZitSzs5quzNn8hL1WIe7ddb7GIvhxNqW9FCOAuL9UMOx9RRw/k7xTePMWKinlbxP7HWxShC4UfjSCUDuJ7h4I+0oH0hSKrHZi/8K5pAjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770864681; c=relaxed/simple;
	bh=hFrl4xIEcuZcd1aTRZ1xddKhvJ3/+6fKHmG4NsANTOI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VS7pTrY63L8vb2FWezUfdivRb1wgwOb/duW8x4ebUWJQaUVNCWGFDxnxVyGR4px20DXAEuk9gHaflBYfveAhbISg1rUPenD0lusYrH/KEJFDnmCNvSLw0Hv7pGfA09toyT8yYBhPwUHlL5PsNNlukKn1mEd5RwhQqRlli77TnH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=asaEPu1t; arc=none smtp.client-ip=50.112.246.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="asaEPu1t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770864680; x=1802400680;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tLw8pvJCeEKexVam/fXhH6hjVZBQdHXzY2sxA70/vaE=;
  b=asaEPu1tFI2sKbzCux3wrwsvA09Nyf4a31/OTmLD+Pia7xgSatzCFxn7
   ZT7iqLUVQqAOOLDaOY4YNBvXhyjwGuGboIlhBEnPUcJdnUyk5y3/xfsb0
   Ty8vz793cIsfLnu0rEsm1BX+lwxlcC4fsNfLNO39LIAsta2DDNcFzcmk1
   W+Q4Qvqtp+1phdLF+LZajHar7dbQf/7rKMaLotWbMcVT0PYbQRj58iy5N
   FAPfi9FBylK7Nc0myysREmjoUQdHKiIvYNBlKnCvpiMT5Mrijfb6d/0tX
   STIpHWaV00NGXDZZ3bSUvC3gE+gdQnFXCC+gE52IKG5TQ3ayKS8QL9gnH
   A==;
X-CSE-ConnectionGUID: +2i2aKScQCqiIjAkIi/UrQ==
X-CSE-MsgGUID: o+qYXXLgRwSPY3h/Zb5g6Q==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12743969"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 02:51:20 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.51:26506]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.42.95:2525] with esmtp (Farcaster)
 id 0ea68f8f-399c-48e3-9bbb-7d2a6325c696; Thu, 12 Feb 2026 02:51:20 +0000 (UTC)
X-Farcaster-Flow-ID: 0ea68f8f-399c-48e3-9bbb-7d2a6325c696
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:51:19 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:51:19 +0000
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
Subject: [PATCH 015/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_CMAC crypto
Date: Thu, 12 Feb 2026 02:45:51 +0000
Message-ID: <20260212024725.11264-16-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D036UWC003.ant.amazon.com (10.13.139.214) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

From: Vegard Nossum <vegard.nossum@oracle.com>

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_CMAC-related crypto to convert them into pluggable
interface.

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
[add cmac.o into crypto-objs-y; revise commit message]
Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile | 2 +-
 crypto/cmac.c   | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 10cf1c6991fa..d37e00783f84 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -72,7 +72,7 @@ cryptomgr-y := algboss.o testmgr.o
 
 crypto-objs-$(CONFIG_CRYPTO_MANAGER2) += cryptomgr.o
 obj-$(CONFIG_CRYPTO_USER) += crypto_user.o
-obj-$(CONFIG_CRYPTO_CMAC) += cmac.o
+crypto-objs-$(CONFIG_CRYPTO_CMAC) += cmac.o
 obj-$(CONFIG_CRYPTO_HMAC) += hmac.o
 obj-$(CONFIG_CRYPTO_XCBC) += xcbc.o
 obj-$(CONFIG_CRYPTO_NULL) += crypto_null.o
diff --git a/crypto/cmac.c b/crypto/cmac.c
index 1b03964abe00..f898c4612312 100644
--- a/crypto/cmac.c
+++ b/crypto/cmac.c
@@ -251,8 +251,8 @@ static void __exit crypto_cmac_module_exit(void)
 	crypto_unregister_template(&crypto_cmac_tmpl);
 }
 
-module_init(crypto_cmac_module_init);
-module_exit(crypto_cmac_module_exit);
+crypto_module_init(crypto_cmac_module_init);
+crypto_module_exit(crypto_cmac_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("CMAC keyed hash algorithm");
-- 
2.47.3

