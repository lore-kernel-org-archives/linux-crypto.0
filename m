Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81CE4414;
	Thu, 12 Feb 2026 03:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.218.115.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770865333; cv=none; b=UWaShVNtKDSUQRC5GgjBVwgABqW4uLA2dGa0eWMce+cqnFBW3zOQ/tej6kyrvkC5fLpt3oQV4w2TmdHcxcaWn+hzfy/FeaO7NQYdKyiTAABByMJG4riLHjGRZo8cuEFRK1eLbx90yosWVc6SyoAwqVf7Cb/ZCB5RXneWVOjrpB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770865333; c=relaxed/simple;
	bh=yRv6fMisK2bS3LkqvPMfYPg8JvtIQ5rR/O87h6l72bw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SSwfwI6qH3QXPq8SmNoqp03qHjh1R1vNjPoADp2VK9AezqEaiEjHxykSfLHCMhzeph2MVAFup2jYzX11sUOtzbU77UiZqbkb2ZULi3+BEb398556kW6s8PzsT+5dRWzkkA19UufKNZVTbwBBLdNdqXiJM87PEo0ivl7m36c3K+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=pPPPtEI7; arc=none smtp.client-ip=34.218.115.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="pPPPtEI7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770865332; x=1802401332;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=meq20JxPvYu72DYL2ukVcDQS4L0A8vO/QF+UwvLYC18=;
  b=pPPPtEI7mOCcLsEfxSgGp0A1bqtJGXazXLJ9ERKu9jaXTGZ88GKOHHEo
   JvAIdOrUy3vLRZovbLNYzBR2cTg0md0CQM9jOT1JAPMl1AOlMZOz3aFJ9
   8k25CpTHJCJomr0DeaLC4Jn4AOSq4YLIYlOGuG2bOom7EaYBxC+39nsFU
   F9ArShdN/UHj8K9XpvT0uRmC5TesVfr0ZaXhYIS+3p7adeA+QUpdTtnIr
   SxO9TUXWhRYnTShwcNzMPOYJ2fyIuAiDvVb4dRv7EkDDbFU6yz0XXe9gl
   soKKAkrwv2vWnICMyHN1emcmEEWKJDyg+7qlzTV6K0pms/EgaIjbEo0eG
   Q==;
X-CSE-ConnectionGUID: qENHa4DaQxKTUcn5lJU+Hg==
X-CSE-MsgGUID: Q9mfhPizQ6G17zHWi0NyDQ==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12727201"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 03:02:12 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:5753]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.0.85:2525] with esmtp (Farcaster)
 id de0fc0ed-2e59-495a-94c2-65077bf0ceb7; Thu, 12 Feb 2026 03:02:12 +0000 (UTC)
X-Farcaster-Flow-ID: de0fc0ed-2e59-495a-94c2-65077bf0ceb7
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:02:11 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:02:11 +0000
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
Subject: [PATCH 057/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_CHACHA20POLY1305 crypto
Date: Thu, 12 Feb 2026 02:46:33 +0000
Message-ID: <20260212024725.11264-58-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D032UWB001.ant.amazon.com (10.13.139.152) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_CHACHA20POLY1305-related crypto to convert them into
pluggable interface.

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile           | 2 +-
 crypto/chacha20poly1305.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index cb509e854784..f71f2359ce08 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -100,7 +100,7 @@ crypto-objs-$(CONFIG_CRYPTO_HCTR2) += hctr2.o
 crypto-objs-$(CONFIG_CRYPTO_ADIANTUM) += adiantum.o
 crypto-objs-$(CONFIG_CRYPTO_GCM) += gcm.o
 crypto-objs-$(CONFIG_CRYPTO_CCM) += ccm.o
-obj-$(CONFIG_CRYPTO_CHACHA20POLY1305) += chacha20poly1305.o
+crypto-objs-$(CONFIG_CRYPTO_CHACHA20POLY1305) += chacha20poly1305.o
 obj-$(CONFIG_CRYPTO_AEGIS128) += aegis128.o
 aegis128-y := aegis128-core.o
 
diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index b4b5a7198d84..2e5fe0b060af 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -476,8 +476,8 @@ static void __exit chacha20poly1305_module_exit(void)
 				    ARRAY_SIZE(rfc7539_tmpls));
 }
 
-module_init(chacha20poly1305_module_init);
-module_exit(chacha20poly1305_module_exit);
+crypto_module_init(chacha20poly1305_module_init);
+crypto_module_exit(chacha20poly1305_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Martin Willi <martin@strongswan.org>");
-- 
2.47.3

