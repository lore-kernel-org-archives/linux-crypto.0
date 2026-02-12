Received: from pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.1.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F5223717F;
	Thu, 12 Feb 2026 03:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.1.125
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770865754; cv=none; b=Qf9EcVTWa2/xH0RyQhOY9ohqx/FFOtIyyNuoOLcMOV2bIHop+T5YWDWw6NWVDj7Ae/9dZvfJGEjmCrIN1f+bA40XiDg9nrn/Rz6XjaQdsnCP25ITD6DlCuU2kkyRsPLm2RVr+DU2ikPSpr1OAU8P011tWx+SW9/PTK6Xlu5sxlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770865754; c=relaxed/simple;
	bh=fdX1Jp3cYbVk4PRr3MDSEDdkvkc0rCwkGWRLHNXANyE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YlR2UEICETaE66j62/JZfZzgdqsxc+TRLw3mQ5l1serX1wECLlbXJFymFIuNnbHpJk3bXGPcgALJ8Odih16/lb+WbW39+17rRmHrJJUt/FbX+2+O4TqUny2Mzoo8IQqzDrpa+VLPEs7j71cw/+JBSn4SpdJnumD9wwGOY9mpXB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=dYkAgaGO; arc=none smtp.client-ip=44.246.1.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="dYkAgaGO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770865752; x=1802401752;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S2Rpzps0Oa5rg5hYsgU73AtKwAF+xz1ix5AubhMOHf8=;
  b=dYkAgaGOPBM1OUm7TxR1BfmX1mSpp7MhVI+NBzn2/gapMYL8NtMDzQeX
   GrelbWselZUk3Fc10HZadTwVABtaOLbvo5GmU2WAEvsoNNliTPuwHQH0q
   0TqoRi2VhTpQGcF0PVjoHVI5GpIC2plT/vlZj8PM+oICBlhRDFvP0e62A
   hYigzf+J9kkSSX67Z5I6Jre4Gzm5/eK4vRAk+6VkmcflyL3F3MduORpSl
   kbBUwK4zJ62PCeRTrhdqY+Y2u/RGDjPAUlwVVNhgDs1Vg9/aqqVyfe/Dw
   fWiIbqS0ON78poi/y3rmSu93NAT5Be8D5vpWkYLo2ANnOJVLh5LlMPN6F
   w==;
X-CSE-ConnectionGUID: odrC3xJ6RU61Ri2tcYCfwA==
X-CSE-MsgGUID: /zHWV04WQuulNwhDtABq4Q==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12919576"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 03:09:12 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:24085]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.3.19:2525] with esmtp (Farcaster)
 id fd432ae4-86c1-441e-b6a9-bb7247355fe2; Thu, 12 Feb 2026 03:09:12 +0000 (UTC)
X-Farcaster-Flow-ID: fd432ae4-86c1-441e-b6a9-bb7247355fe2
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:09:11 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:09:10 +0000
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
Subject: [PATCH 084/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_JITTERENTROPY_TESTINTERFACE crypto
Date: Thu, 12 Feb 2026 02:47:00 +0000
Message-ID: <20260212024725.11264-85-wanjay@amazon.com>
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

Unlike most patches, we do not add a DECLARE_CRYPTO_API() wrapper for the
exported function in crypto/jitterentropy.h. This is because this header is
used by both jitterentropy_rng.o and jitterentropy-testing.o, but the
compilation flags for jitterentropy_rng.o do not support declaration of a
static call key.

This is acceptable since the only user of this exported function is
jitterentropy_rng.o itself. The jitterentropy-testing.o code will naturally
either be included alongside jitterentropy_rng.o in the crypto kernel
module, or it will be disabled.

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 66319c92a983..d1db3a1e3b3b 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -169,7 +169,7 @@ CFLAGS_jitterentropy.o = -O0
 KASAN_SANITIZE_jitterentropy.o = n
 UBSAN_SANITIZE_jitterentropy.o = n
 jitterentropy_rng-y := jitterentropy.o jitterentropy-kcapi.o
-obj-$(CONFIG_CRYPTO_JITTERENTROPY_TESTINTERFACE) += jitterentropy-testing.o
+crypto-objs-$(CONFIG_CRYPTO_JITTERENTROPY_TESTINTERFACE) += jitterentropy-testing.o
 obj-$(CONFIG_CRYPTO_BENCHMARK) += tcrypt.o
 crypto-objs-$(CONFIG_CRYPTO_GHASH) += ghash-generic.o
 crypto-objs-$(CONFIG_CRYPTO_USER_API) += af_alg.o
-- 
2.47.3

