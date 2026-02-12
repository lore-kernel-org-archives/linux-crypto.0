Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC094184540;
	Thu, 12 Feb 2026 03:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.218.115.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770865581; cv=none; b=Jd1w4kirXphsD3WMlVtlF+nCc4uafJuj6R/jpgl6+CJMMpFGBdsMZsMZwNnE/otR2dlGsw895XEmyXcI5ZqScivuAJ3EVns8yzukJL0TC47nYoVjO151kX0Nclu06ubk9rknXlDmtNlJMNzu1PEU73oHjN3xk16FrGQBC3/kc9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770865581; c=relaxed/simple;
	bh=+9Nx/gmj+wwyRrH9JiLczgPnbait0NYIO3tJc8lWzqk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OSpaU4mD2kkW47Zm8c4pfm8wdqhhly2+epDfouGu3LU9T1Fw8JOQoA6LRdn+HuWyBsmAFPZ//SGMlxkPaZH3x7enMz9bqWhAO4YHZHvWISBicD/fF9Nlwt3IxcHLv4KzD4fHRYX51G6mvRVpzchX9KxFBF1ADP7s5WC31mQenWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=AfLpI2sT; arc=none smtp.client-ip=34.218.115.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="AfLpI2sT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770865580; x=1802401580;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TJ3l2M/fzjx1FqdTJssKdzndERlDZ427WzLpN7WpKfQ=;
  b=AfLpI2sT1FYA1H680Zs5Jsneb1iogcD65Tr3+SAIhqZrcCXSiIiFrew/
   MSDpu98h5ib4aq2OwEqtIkIp9gnCYzL+f17cRYnhLJxsNq6vxyf+SMsdw
   C7FJA7GDGKP8zwo3Bc3mH1m5/QMnY6wYsheea7QnZUfGqM9gW9/bHreXW
   K4ZhkpLIcmwF7Ilyacx1ytOMQixkdASNNfhcQxGfjBetAe9MD5vc1bM81
   zcCGo/AunJvdgWlsyf7bJAtKJnF8uv+9tGVIXLS2RwIB+CaHmL5AAZUVf
   uaXbzGyGGRrZklzliSAJ8YMURLlSX2QHHc8TTNTkzildQn57+iMKQdWhH
   Q==;
X-CSE-ConnectionGUID: sQZzK9AYTwKU6apmLguoxg==
X-CSE-MsgGUID: 6HiXqQWASHeMpXyvBdQs6w==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12727405"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 03:06:20 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:20041]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.3.19:2525] with esmtp (Farcaster)
 id 8bd414ab-a63f-483a-a1e1-6baba4a06927; Thu, 12 Feb 2026 03:06:20 +0000 (UTC)
X-Farcaster-Flow-ID: 8bd414ab-a63f-483a-a1e1-6baba4a06927
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:06:20 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:06:19 +0000
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
Subject: [PATCH 073/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_KHAZAD crypto
Date: Thu, 12 Feb 2026 02:46:49 +0000
Message-ID: <20260212024725.11264-74-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D046UWA002.ant.amazon.com (10.13.139.39) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_KHAZAD-related crypto to convert them into pluggable
interface.

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile | 2 +-
 crypto/khazad.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 1854a70babc0..87f1b0e315f2 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -143,7 +143,7 @@ crypto-objs-$(CONFIG_CRYPTO_CAST5) += cast5_generic.o
 crypto-objs-$(CONFIG_CRYPTO_CAST6) += cast6_generic.o
 crypto-objs-$(CONFIG_CRYPTO_ARC4) += arc4.o
 crypto-objs-$(CONFIG_CRYPTO_TEA) += tea.o
-obj-$(CONFIG_CRYPTO_KHAZAD) += khazad.o
+crypto-objs-$(CONFIG_CRYPTO_KHAZAD) += khazad.o
 obj-$(CONFIG_CRYPTO_ANUBIS) += anubis.o
 obj-$(CONFIG_CRYPTO_SEED) += seed.o
 obj-$(CONFIG_CRYPTO_ARIA) += aria_generic.o
diff --git a/crypto/khazad.c b/crypto/khazad.c
index dee54ad5f0e4..d54214a9bc3f 100644
--- a/crypto/khazad.c
+++ b/crypto/khazad.c
@@ -868,8 +868,8 @@ static void __exit khazad_mod_fini(void)
 }
 
 
-module_init(khazad_mod_init);
-module_exit(khazad_mod_fini);
+crypto_module_init(khazad_mod_init);
+crypto_module_exit(khazad_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Khazad Cryptographic Algorithm");
-- 
2.47.3

