Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B391BC46;
	Thu, 12 Feb 2026 02:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.83.148.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770864774; cv=none; b=Kgx231YTIzw/rFVMWBlDmn9bJ7eZz04vbX9sXNpbtNFR9V+FhpU4V7uVGJU9jyB20CaWVmV0P9jIqvNKCWkHgS2lH1J3JXc/dj3mbXqljHl4ZVUEsD6BBeFLJY8ofXSFw61vM9yGtTvPfzE/OSAOXvBO+wKKPjkeDF7lVAqAngM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770864774; c=relaxed/simple;
	bh=R848LpZujxvx1bexkROSbDw1NzkywBEr/wmZO/NFD+k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OhF6HbxCxVxBn2UPvLM+t0DfWE0/WcuuOe4ikkM8ZL6BMeXwHfRtwiezElF6n0vZcs0yliXDGOrmxrjq+QHiVoLp2uTA7Jb/FIwlhkNVDqEfzMW8+pGk7aNKaFacwG/rmGcsFgHZ7N7uADeOQbFka8fxBHtUFLcnFLZpwl5wVw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=s2Mi06pG; arc=none smtp.client-ip=35.83.148.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="s2Mi06pG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770864773; x=1802400773;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uykTr1wYXEvfGFPnI15K0EjeeP05XerkB61+U0BScaA=;
  b=s2Mi06pGpMb7TLm2vkFp3GHVCbRlV8HdosY2MS8flqBeshoE3t1QMiur
   DT4AmLPRgtillwpa8HlAQXLOpbww6z6Y1MYDJglQOEeIFiKb4Sz9URAsO
   jEVW4Y9LAvJyClOfbJeipo5/DkqwxzB1iPECVhWFIB95ceL81a90mU6Vq
   5Y6KAqORjKHr3r4UmotpIB4JvVEIUwPdsKZfdqZ81b+ZEDPe6QaOSOQI2
   x93xXWakdUivvumecyiqm5rDQRBmLOkuUqbkk6PvRTJ0x19NljANiLZFT
   dJ9aT86ZqNYumpYPOXoatCJHnUkmgYAmOecn/GaBcm2IIMkW2agh0phBY
   Q==;
X-CSE-ConnectionGUID: DsZ9+mXJS6OnvNA16XAN8g==
X-CSE-MsgGUID: FuUwZKMJSUCEqaf0zalyKg==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12696410"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 02:52:53 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.51:9857]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.29.209:2525] with esmtp (Farcaster)
 id 0c3538d1-91d2-4630-bce9-7843bb2e8028; Thu, 12 Feb 2026 02:52:53 +0000 (UTC)
X-Farcaster-Flow-ID: 0c3538d1-91d2-4630-bce9-7843bb2e8028
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:52:52 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:52:52 +0000
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
Subject: [PATCH 021/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_ECB crypto
Date: Thu, 12 Feb 2026 02:45:57 +0000
Message-ID: <20260212024725.11264-22-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D042UWB001.ant.amazon.com (10.13.139.160) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

From: Vegard Nossum <vegard.nossum@oracle.com>

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_ECB-related crypto to convert them into pluggable
interface.

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
[add ecb.o into crypto-objs-y; revise commit message]
Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile | 2 +-
 crypto/ecb.c    | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 251b20fad9c2..11a6714dee42 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -88,7 +88,7 @@ obj-$(CONFIG_CRYPTO_STREEBOG) += streebog_generic.o
 obj-$(CONFIG_CRYPTO_WP512) += wp512.o
 CFLAGS_wp512.o := $(call cc-option,-fno-schedule-insns)  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79149
 obj-$(CONFIG_CRYPTO_BLAKE2B) += blake2b.o
-obj-$(CONFIG_CRYPTO_ECB) += ecb.o
+crypto-objs-$(CONFIG_CRYPTO_ECB) += ecb.o
 obj-$(CONFIG_CRYPTO_CBC) += cbc.o
 obj-$(CONFIG_CRYPTO_PCBC) += pcbc.o
 obj-$(CONFIG_CRYPTO_CTS) += cts.o
diff --git a/crypto/ecb.c b/crypto/ecb.c
index cd1b20456dad..20127b20f483 100644
--- a/crypto/ecb.c
+++ b/crypto/ecb.c
@@ -219,8 +219,8 @@ static void __exit crypto_ecb_module_exit(void)
 	crypto_unregister_template(&crypto_ecb_tmpl);
 }
 
-module_init(crypto_ecb_module_init);
-module_exit(crypto_ecb_module_exit);
+crypto_module_init(crypto_ecb_module_init);
+crypto_module_exit(crypto_ecb_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("ECB block cipher mode of operation");
-- 
2.47.3

