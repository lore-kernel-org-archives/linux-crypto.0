Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F478C1F;
	Thu, 12 Feb 2026 02:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.35.192.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770864805; cv=none; b=Et5lt78sUg3FgNp7iBD4UhK0xjBtsL+YpyiZEtl2MKkagorlSmOKoMRAknxPcKMGlJppXgCVZ4I0b1sR5rG1Qor3eSPpLT8nU1uSUvsZnih/E8yxpdIdUvcs/iJ/84GbPS1U+yWRcrPsw2BrQCdSjixcqkV8HVBmqhp7T7eCknY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770864805; c=relaxed/simple;
	bh=tDHOTzSTUQeWvon3Gb/3KXHDftNYZ1GnxEaLnvI57C8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VI/Gfa+nnnXeQdQ6a8v8xt2d4HYKyE5s4JbKfK8iapoJD+23WHUEGsjnHfY1ik/5P2mlxM49Bjow6fQl8EstVBDUJUhFEHbOoMrO1QGmeMEyptwVaAS8CXZXGSM3LZEhKxLMkw7oG2EUwt0lgs+W9bYKucwDfxOgfvxkQwq+4Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=WHSZ27au; arc=none smtp.client-ip=52.35.192.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="WHSZ27au"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770864804; x=1802400804;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YW1K1m1noTEFnR6AigfvRmRESeJHEYVi1ganWY7Eff0=;
  b=WHSZ27auWxTMl4GAgmiRIECT4uZx4ldIfUu/9gM/qpCL3KWOIJIWOgex
   58A+i7rGtPhLdl/T5VEpe674ODjobR6BejpjGY4d7J99N+iUQr+JtsOkv
   wFQgZ35BDJtY19QDUV7MzBdZthOxr3DK+5gTRtJP1UAQo00pERpnzetg3
   VjGnCYuNTGbEmEWv517ZDxaLyeHGU/MWulnHjfg4YczSo0AuzfJZUVkO9
   WnFbO85UESYIUDgs7sz51/cH+W/moaLXU6rwj9/eqtgo5kqa07ta/JZnq
   szqY0A6mGWiK83misMlhc7MYuduYC6RwC3oaYBQN5al9HY4N0TtYk8/Ks
   A==;
X-CSE-ConnectionGUID: 3jHzTPGeSg6F/+oxPKuHDg==
X-CSE-MsgGUID: E/Yd3v5NTrCqfxU7gDd91Q==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12698219"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 02:53:24 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:24592]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.54.219:2525] with esmtp (Farcaster)
 id 0e0e4bcd-0240-4239-bf18-441f07d70fc5; Thu, 12 Feb 2026 02:53:24 +0000 (UTC)
X-Farcaster-Flow-ID: 0e0e4bcd-0240-4239-bf18-441f07d70fc5
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:53:23 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:53:23 +0000
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
Subject: [PATCH 023/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_CTR crypto
Date: Thu, 12 Feb 2026 02:45:59 +0000
Message-ID: <20260212024725.11264-24-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D031UWA002.ant.amazon.com (10.13.139.96) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

From: Vegard Nossum <vegard.nossum@oracle.com>

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_CTR-related crypto to convert them into pluggable
interface.

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
[add ctr.o into crypto-objs-y; revise commit message]
Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile | 2 +-
 crypto/ctr.c    | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 354ce7a46a0a..d5b5ca797dc6 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -94,7 +94,7 @@ obj-$(CONFIG_CRYPTO_PCBC) += pcbc.o
 obj-$(CONFIG_CRYPTO_CTS) += cts.o
 obj-$(CONFIG_CRYPTO_LRW) += lrw.o
 obj-$(CONFIG_CRYPTO_XTS) += xts.o
-obj-$(CONFIG_CRYPTO_CTR) += ctr.o
+crypto-objs-$(CONFIG_CRYPTO_CTR) += ctr.o
 obj-$(CONFIG_CRYPTO_XCTR) += xctr.o
 obj-$(CONFIG_CRYPTO_HCTR2) += hctr2.o
 obj-$(CONFIG_CRYPTO_ADIANTUM) += adiantum.o
diff --git a/crypto/ctr.c b/crypto/ctr.c
index a388f0ceb3a0..fa67cf6de4b1 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -350,8 +350,8 @@ static void __exit crypto_ctr_module_exit(void)
 				    ARRAY_SIZE(crypto_ctr_tmpls));
 }
 
-module_init(crypto_ctr_module_init);
-module_exit(crypto_ctr_module_exit);
+crypto_module_init(crypto_ctr_module_init);
+crypto_module_exit(crypto_ctr_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("CTR block cipher mode of operation");
-- 
2.47.3

