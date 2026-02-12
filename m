Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6860122E3E7;
	Thu, 12 Feb 2026 03:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.218.115.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770865768; cv=none; b=ZWzyE6gY3NRK1YsnxtkvJB6OPaDjsyYt0KOUGCekl6Euju1cBBOPM/gBSSm2Hb8MX7iNTJqMTET/QYcHnpm1w3lzyU+QP4HNaVW2uq/c5Kh1BDEJOPlnrDSK5jGFMzQ4KF2CEHj6UDqBCRt+n4J91f1kpgStixKari2KRamGyyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770865768; c=relaxed/simple;
	bh=Epus6VJUgfCmqYxecreN4xPl3vIF9DDvTcQtYb8t+io=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ivlQIYZciZz3gfWnt992G1RkZTM+pxhH0gqDAdJGdnNRlBuy5CriIcud73VTLNkUSh5haw5loBF0/iXh6JETFVnluFpeYXWu9Gas9jAcHoUhd1vj5r4yO2JoG+0TOojr/V2Xv757ih+BHTzhccT5yq5TMx20FgeSHB1/LmIMQqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=a+WI1tgj; arc=none smtp.client-ip=34.218.115.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="a+WI1tgj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770865767; x=1802401767;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TrLtHs3Gar8lgcr4eK93mcSTRyJrUxd7swl42zHzYFU=;
  b=a+WI1tgjRR1Nla0LN4MXlpTyEVCQ8PU9eZpVnkwiekiR6etMmd9fXS0E
   G5cRFD2WAQaL/ScEYX8qIoJ6kUc3BvPcn4xxfG7Z8XPw5GZGY+OoVKGvj
   ORxGEr53HGCXMzlaUeC7GFkipDI2i0hQkqQ/yqbTqjuteMVN3mpiU/hll
   QtZ2m9QBcdzPSVO/USpSWD2bSV5xAJ+sFnG+KwBvbiMg5nZJXB7CV1GXa
   5L6onyV6wCQ6X4XuWn5IvfcZT5xoWl1B1I3CWQ/JdcA2oMXdT/8PkIN6Z
   4DG5VSbKkjkDP8p9HmeKDbk7mpxMgPpKSRdFY3rXjqdOlSyr7JrMSM/Kg
   Q==;
X-CSE-ConnectionGUID: 3n4HXWlTR524CX6NFJVECg==
X-CSE-MsgGUID: pn2b5jHoSXCouOoUO0q6rw==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12727551"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 03:09:27 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:31509]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.54.219:2525] with esmtp (Farcaster)
 id ae28385a-d363-4298-bbe2-55f4098db7ac; Thu, 12 Feb 2026 03:09:26 +0000 (UTC)
X-Farcaster-Flow-ID: ae28385a-d363-4298-bbe2-55f4098db7ac
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:09:26 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:09:26 +0000
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
Subject: [PATCH 085/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_BENCHMARK crypto
Date: Thu, 12 Feb 2026 02:47:01 +0000
Message-ID: <20260212024725.11264-86-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D040UWB003.ant.amazon.com (10.13.138.8) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_BENCHMARK-related crypto to convert them into pluggable
interface.

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile | 2 +-
 crypto/tcrypt.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index d1db3a1e3b3b..39b42843d321 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -170,7 +170,7 @@ KASAN_SANITIZE_jitterentropy.o = n
 UBSAN_SANITIZE_jitterentropy.o = n
 jitterentropy_rng-y := jitterentropy.o jitterentropy-kcapi.o
 crypto-objs-$(CONFIG_CRYPTO_JITTERENTROPY_TESTINTERFACE) += jitterentropy-testing.o
-obj-$(CONFIG_CRYPTO_BENCHMARK) += tcrypt.o
+crypto-objs-$(CONFIG_CRYPTO_BENCHMARK) += tcrypt.o
 crypto-objs-$(CONFIG_CRYPTO_GHASH) += ghash-generic.o
 crypto-objs-$(CONFIG_CRYPTO_USER_API) += af_alg.o
 obj-$(CONFIG_CRYPTO_USER_API_HASH) += algif_hash.o
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 62fef100e599..1f3b6c1922cb 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -2840,8 +2840,8 @@ static int __init tcrypt_mod_init(void)
  */
 static void __exit tcrypt_mod_fini(void) { }
 
-late_initcall(tcrypt_mod_init);
-module_exit(tcrypt_mod_fini);
+crypto_late_initcall(tcrypt_mod_init);
+crypto_module_exit(tcrypt_mod_fini);
 
 module_param(alg, charp, 0);
 module_param(type, uint, 0);
-- 
2.47.3

