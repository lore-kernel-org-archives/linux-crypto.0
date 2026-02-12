Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66286184540;
	Thu, 12 Feb 2026 03:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.42.203.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770865566; cv=none; b=Ad+9fLeEe9uyucApGgpQxBeWtClAKL0Nm72XyyRPe5N4LDyKmNUwdGtP36eZfVP4pHsHpmE2gWNJWrtquB+4Z0/ZzLWO2apxeCjAvtcHM0atz19GuwPEtNLabTsnIIYAZYZwuI3xAf//43hB2TYdti+/snjeasf015Ajq+Icjg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770865566; c=relaxed/simple;
	bh=xJ1SezgZh/Eq4Lq60A5q3Uc6Hk1K5c/6EqOK8+7NX60=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dD6sgI9ymxNcG7ribskLY5smmpKbqmAoXIxT9kNAWspqGOhL0zj8jWG0IiGejeiUdAN2VLgQ459dFeV7HSot7uTw4SJl8uVkt2C7l8wKg501zOwc6QN2NnKZoWg/0F3kQW0iw0qv8bv7Ay5QcdZq6dC2hXE74fl+0UcLTZCucys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=YqVAG+DB; arc=none smtp.client-ip=52.42.203.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="YqVAG+DB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770865565; x=1802401565;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PvXGTOpDYZMhm8nWs0+pZhDTllw8aVVm9oItzH2rbeE=;
  b=YqVAG+DBIlYU58KLebRpr5E16r/a5tEbXejCncYbjMzlqnHUVGDTQ8sp
   sYcCBP9w4ZdXwHmcnNjXMi1T44SFjA99n9e/v7D3zL2Tq2d87kwC4aMGV
   E/Ak0UFRJbQeg1Wt1jznVVWcwhGCWJPFRVjJ2KCQwdyOqzHPf70IFOpMf
   uotC5T4S4JeXM25d1uWQAgvqeLipdBqtcQ6TrvoUZ41AKwOqZULtrObws
   9KD9TjFU8+SWIVPwW6q8sFBMXwI1AYPzBzJgYWUnBblt+UJK+RX5pYf01
   gJdmpL3VqamweqOrn2Z7utZRMcX3yzKf6XlmbSOieaBN8fCuXilefpUCj
   A==;
X-CSE-ConnectionGUID: DLVdO/vBQZyRJwr/cemZ4Q==
X-CSE-MsgGUID: 2PyzPwMXT7WLHR6SkQJJEg==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12913917"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 03:06:05 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:22596]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.61.62:2525] with esmtp (Farcaster)
 id 4d1f3c1f-c8a0-4086-82ad-e19036193cd0; Thu, 12 Feb 2026 03:06:04 +0000 (UTC)
X-Farcaster-Flow-ID: 4d1f3c1f-c8a0-4086-82ad-e19036193cd0
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:06:04 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:06:04 +0000
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
Subject: [PATCH 072/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_TEA crypto
Date: Thu, 12 Feb 2026 02:46:48 +0000
Message-ID: <20260212024725.11264-73-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D045UWA001.ant.amazon.com (10.13.139.83) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_TEA-related crypto to convert them into pluggable
interface.

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile | 2 +-
 crypto/tea.c    | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index a7ad0f5dd1d9..1854a70babc0 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -142,7 +142,7 @@ crypto-objs-$(CONFIG_CRYPTO_CAST_COMMON) += cast_common.o
 crypto-objs-$(CONFIG_CRYPTO_CAST5) += cast5_generic.o
 crypto-objs-$(CONFIG_CRYPTO_CAST6) += cast6_generic.o
 crypto-objs-$(CONFIG_CRYPTO_ARC4) += arc4.o
-obj-$(CONFIG_CRYPTO_TEA) += tea.o
+crypto-objs-$(CONFIG_CRYPTO_TEA) += tea.o
 obj-$(CONFIG_CRYPTO_KHAZAD) += khazad.o
 obj-$(CONFIG_CRYPTO_ANUBIS) += anubis.o
 obj-$(CONFIG_CRYPTO_SEED) += seed.o
diff --git a/crypto/tea.c b/crypto/tea.c
index cb05140e3470..9f42e296377f 100644
--- a/crypto/tea.c
+++ b/crypto/tea.c
@@ -255,8 +255,8 @@ MODULE_ALIAS_CRYPTO("tea");
 MODULE_ALIAS_CRYPTO("xtea");
 MODULE_ALIAS_CRYPTO("xeta");
 
-module_init(tea_mod_init);
-module_exit(tea_mod_fini);
+crypto_module_init(tea_mod_init);
+crypto_module_exit(tea_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("TEA, XTEA & XETA Cryptographic Algorithms");
-- 
2.47.3

