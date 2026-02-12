Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE56B2417F2;
	Thu, 12 Feb 2026 03:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.35.192.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770866665; cv=none; b=imkqG47wXnyljSyvaaar+8iomo0VF2Q6JfaF84xaWhIBK3RoMWd6t+vcUbgEmkgmjQaXVWTcLl7pV2gg22d+xF/PLbfIcpJoiVMJR0i9Lvrpkr082NlbnTQIC6BJkEsFTLkjP/Tsym7IYg18SijRpPKxiQOTQ0pot9lRVrbxOMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770866665; c=relaxed/simple;
	bh=Z/7DZ7duOTa/1dduC0XbPYEIlXNXmSkVEaxzSyjlA5g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RiYHw7nPWH6weL8ywB1iFbiJgYWMELqK2wYLY7h6ZrvpHN4c2rjoKC4cDKae95UXxzUDSo5RpIy9HhJFPJfoPHsTLMEhpGSJcfBvy6FH7g2/xWpPA5bwZbK2fUs/s5XKX7u6Tp2PW3QNGGw0nptd/yUBqxYfqFtCn8tGEZHres4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=pzRHEGvx; arc=none smtp.client-ip=52.35.192.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="pzRHEGvx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770866664; x=1802402664;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eyBtxVMRU3iJexQIcMrCxSy/8F36/qAiDl0Bt+KJ7FM=;
  b=pzRHEGvxgZ9WRKndtpVwqCrQdQijFBfXZgblCysloRkxZQV1M4x8423o
   Q1Dix1i7mmaSlebvYeAVgYj0kBJ7mJ71V+L9N5E+EDmR5Mw1nzcAzi1k/
   D8J8+Pu1MB8jLb8zVJMxvA1vcmIVo5Lk1aQPwzu5Yao8tXmBo6FEM0jT/
   lFHU0r/4nTb4gU142bmjCpx6cHmX/G0RjmOstPHHenwmYSQx59Xs+A27N
   E9g8qbTnIuofCLNmDdA6r8hiyWSxXnlHLF/YBEa6AaZoET7OtsrKgEPiw
   bxAJ4+7rcLTNhJ5pUvyCUV2PQkABVpAe/3FeUKAsu8d8qSmbCrKL5ek6u
   Q==;
X-CSE-ConnectionGUID: IViQqOIMRqKNstPltMtuEw==
X-CSE-MsgGUID: nTkaTpJkQgahY2Wm+/oT2w==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12699351"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 03:24:24 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:3338]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.20.103:2525] with esmtp (Farcaster)
 id c8b3e53f-c925-4ed7-a851-f37a81c4dfb0; Thu, 12 Feb 2026 03:24:24 +0000 (UTC)
X-Farcaster-Flow-ID: c8b3e53f-c925-4ed7-a851-f37a81c4dfb0
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:24:24 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:24:23 +0000
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
Subject: [PATCH 12/12] arm64: crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_AES_ARM64_BS crypto
Date: Thu, 12 Feb 2026 03:21:12 +0000
Message-ID: <20260212032117.9166-13-wanjay@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260212032117.9166-1-wanjay@amazon.com>
References: <20260212032117.9166-1-wanjay@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D043UWA003.ant.amazon.com (10.13.139.31) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_AES_ARM64_BS-related crypto to convert them into pluggable
interface.

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 arch/arm64/crypto/Makefile          | 2 +-
 arch/arm64/crypto/aes-neonbs-glue.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
index 6053065c18cc..2c0215a09118 100644
--- a/arch/arm64/crypto/Makefile
+++ b/arch/arm64/crypto/Makefile
@@ -38,7 +38,7 @@ aes-ce-blk-y := aes-glue-ce.o aes-ce.o
 crypto-objs-$(CONFIG_CRYPTO_AES_ARM64_NEON_BLK) += aes-neon-blk.o
 aes-neon-blk-y := aes-glue-neon.o aes-neon.o
 
-obj-$(CONFIG_CRYPTO_AES_ARM64_BS) += aes-neon-bs.o
+crypto-objs-$(CONFIG_CRYPTO_AES_ARM64_BS) += aes-neon-bs.o
 aes-neon-bs-y := aes-neonbs-core.o aes-neonbs-glue.o
 
 # FIPS 140 kernel module
diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
index cb87c8fc66b3..42da18008614 100644
--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -464,5 +464,5 @@ static int __init aes_init(void)
 	return crypto_register_skciphers(aes_algs, ARRAY_SIZE(aes_algs));
 }
 
-module_init(aes_init);
-module_exit(aes_exit);
+crypto_module_init(aes_init);
+crypto_module_exit(aes_exit);
-- 
2.47.3

