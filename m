Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBBE184540;
	Thu, 12 Feb 2026 03:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.83.148.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770865520; cv=none; b=ToUrMrDJ3lj41shVQLYQqWNFzpI1uSgK1+rDwvbfqXm0+JLOJJiDrbFyK4LHmOC0ee0k40XdTut+GD8ISfhuJyXHRyM1yKM0F4TWjoBct3G2ZY9qpnlQMH9W3qGwNxpR8gaheSWW1YnPpc6ofq5V7s6IHAq8sDgYVMePmqN/Fe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770865520; c=relaxed/simple;
	bh=UGCJoqIVYsq5Uz2k0OYCi9C/OBr7AWwYzCQ95iGTzsQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oCjrniuWHMkK09rob4LH31IKhjXUZ97TS2K2lHDqdlibpEggyzV3zZMy64/8ulKYl3TEBq90CKGsFoo0oAR4RVDvfvqixzJX5IvD82oLx7KoSOXLvyA+WAknNQFG/Sozv6NODRj9htz2s4xPZ95oznECb15x48g5Lksl44Dr1J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=DzvBiCAV; arc=none smtp.client-ip=35.83.148.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="DzvBiCAV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770865519; x=1802401519;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k4ip65HcC4K5Rtzes+OqLMjVU82bAcTf+v3gpaBM6fQ=;
  b=DzvBiCAVtBeK615AkzXIDbF5QNBVX7EDvrTsd8NDWE1bQHf5m1FrK+/T
   p4EKeF/XODauB49vCt8/usLFDtaHB83fepZjindRWw+VEwdzy5IzsPKH8
   6CKhNApZhQA8rrML4MQUoquA6ObVikY4NEQkItt2YsbZSycvACkeicg+j
   emqgB9Hp78b/rrGNxf5InC0MO6F4dU04Pyz5YGcE+yvE9pCVU1XHRKhdy
   tPlUHVR4Luwc2yJ0YsSZfIvF3mKHuQuOO50JO+Bk/fQgzMRzUgNK/j7nU
   UL1ur0HyhSjs0lo4k3JEmmXDy+4M7ASwigLaocyk7EcGq3oHVgsTSoHnn
   g==;
X-CSE-ConnectionGUID: SHcBt/WGTuuRn+YIjefTMg==
X-CSE-MsgGUID: bPy54Q/WQQWrT7gyChNnUQ==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12697039"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 03:05:19 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:3269]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.31.238:2525] with esmtp (Farcaster)
 id e4a55836-53d3-4332-b1a5-7f5de677f26a; Thu, 12 Feb 2026 03:05:18 +0000 (UTC)
X-Farcaster-Flow-ID: e4a55836-53d3-4332-b1a5-7f5de677f26a
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:05:18 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:05:17 +0000
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
Subject: [PATCH 069/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_ARC4 crypto
Date: Thu, 12 Feb 2026 02:46:45 +0000
Message-ID: <20260212024725.11264-70-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D037UWC002.ant.amazon.com (10.13.139.250) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_ARC4-related crypto to convert them into pluggable
interface.

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile | 2 +-
 crypto/arc4.c   | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 7635fd4b698c..623651445612 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -141,7 +141,7 @@ crypto-objs-$(CONFIG_CRYPTO_CAMELLIA) += camellia_generic.o
 crypto-objs-$(CONFIG_CRYPTO_CAST_COMMON) += cast_common.o
 crypto-objs-$(CONFIG_CRYPTO_CAST5) += cast5_generic.o
 crypto-objs-$(CONFIG_CRYPTO_CAST6) += cast6_generic.o
-obj-$(CONFIG_CRYPTO_ARC4) += arc4.o
+crypto-objs-$(CONFIG_CRYPTO_ARC4) += arc4.o
 obj-$(CONFIG_CRYPTO_TEA) += tea.o
 obj-$(CONFIG_CRYPTO_KHAZAD) += khazad.o
 obj-$(CONFIG_CRYPTO_ANUBIS) += anubis.o
diff --git a/crypto/arc4.c b/crypto/arc4.c
index 1608018111d0..f2bad33acb74 100644
--- a/crypto/arc4.c
+++ b/crypto/arc4.c
@@ -73,8 +73,8 @@ static void __exit arc4_exit(void)
 	crypto_unregister_lskcipher(&arc4_alg);
 }
 
-module_init(arc4_init);
-module_exit(arc4_exit);
+crypto_module_init(arc4_init);
+crypto_module_exit(arc4_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("ARC4 Cipher Algorithm");
-- 
2.47.3

