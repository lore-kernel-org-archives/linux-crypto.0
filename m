Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DBE223DEF;
	Thu, 12 Feb 2026 02:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.34.181.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770865193; cv=none; b=aJt0TN52lRcR2nWnU9ZZ+1rJltpCUNSO+eVA4Zb+PSL0vWDURIneEi9l/0/316dqxtSxx/x8zFsQICgljF6v1B20Q0JPqJLmpIuhTqV/gRMFKQR+zu+oBkz2FRR0VC7k1m8V0WpX26Zoj//VTmZAM5C2ZMLDh4VvxgVwyb+xfZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770865193; c=relaxed/simple;
	bh=5v7RmKWoJR19T3M7rzDYS5JABgbL8PzjJqj7dgJz3VU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k30Bnqx0ZpJFJLBJgSINaoMseCFOuBUGagyh9BC0zvmJ1TrlSSeaRndJi0UwueWprNKwqcLZIv6FGSOooOjhks6mVWEnkFRZjHmmSdqR+zHCMFtBcu/OZSS+jz+DQS59VpBwnPmTOEZTPkS7krOHdKyvkFj3Hf8LlWx0s9svnqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=JpUbWLCv; arc=none smtp.client-ip=52.34.181.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="JpUbWLCv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770865192; x=1802401192;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M3iy5AzhfysAv3JsLqwI5fBQHgwNeM/C4lM3EsRiivc=;
  b=JpUbWLCvkvzXH8LStA4l+X8EOWkkEJ3zV8t9NajDEu424QdwJYyjV9Hn
   Vao+tUFh9+cHAq7vG/SzrHNl++PCex5jF903Rd4wj2wv1vCOnwufOFQXC
   CdtrriV23tmdGl50ObUA8NKBBJgjD5uv3SQBNzwxfEdFX+3XvLHUmGKRe
   qoU6yY0E7yoaWXq1LVWQ+a7VBQIwwcXmHWocDiIkYLSMfG9ZP3yaq9Lqv
   D/PpWnwvRAxmLDGvgClD3EA88ocEbgYvyUHEPAKrl8Qp3NrXeH0z+2gbY
   YWrG0bhdALmOL/6eaMpAzsM2Zo+TiJS557a1ZV/o2IElkqfBBSy9Gn0on
   Q==;
X-CSE-ConnectionGUID: iVC5RUBcTT+oksJJpoQMtg==
X-CSE-MsgGUID: 93rCgShITWeSVmS3ud6SHg==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12919737"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 02:59:52 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:15930]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.29.209:2525] with esmtp (Farcaster)
 id 1897b6f3-a75f-4e53-b2ff-c0d6d7b5fbc0; Thu, 12 Feb 2026 02:59:52 +0000 (UTC)
X-Farcaster-Flow-ID: 1897b6f3-a75f-4e53-b2ff-c0d6d7b5fbc0
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:59:51 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:59:51 +0000
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
Subject: [PATCH 048/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_WP512 crypto
Date: Thu, 12 Feb 2026 02:46:24 +0000
Message-ID: <20260212024725.11264-49-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D039UWB002.ant.amazon.com (10.13.138.79) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_WP512-related crypto to convert them into pluggable
interface.

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile | 2 +-
 crypto/wp512.c  | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index c83ad9bb4324..0a0190292dd0 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -85,7 +85,7 @@ crypto-objs-$(CONFIG_CRYPTO_SHA512) += sha512.o
 crypto-objs-$(CONFIG_CRYPTO_SHA3) += sha3.o
 crypto-objs-$(CONFIG_CRYPTO_SM3_GENERIC) += sm3_generic.o
 crypto-objs-$(CONFIG_CRYPTO_STREEBOG) += streebog_generic.o
-obj-$(CONFIG_CRYPTO_WP512) += wp512.o
+crypto-objs-$(CONFIG_CRYPTO_WP512) += wp512.o
 CFLAGS_wp512.o := $(call cc-option,-fno-schedule-insns)  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79149
 obj-$(CONFIG_CRYPTO_BLAKE2B) += blake2b.o
 crypto-objs-$(CONFIG_CRYPTO_ECB) += ecb.o
diff --git a/crypto/wp512.c b/crypto/wp512.c
index 229b189a7988..2d76d4639d44 100644
--- a/crypto/wp512.c
+++ b/crypto/wp512.c
@@ -1138,8 +1138,8 @@ MODULE_ALIAS_CRYPTO("wp512");
 MODULE_ALIAS_CRYPTO("wp384");
 MODULE_ALIAS_CRYPTO("wp256");
 
-module_init(wp512_mod_init);
-module_exit(wp512_mod_fini);
+crypto_module_init(wp512_mod_init);
+crypto_module_exit(wp512_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Whirlpool Message Digest Algorithm");
-- 
2.47.3

