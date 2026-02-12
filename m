Received: from pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com [50.112.246.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FBE22301;
	Thu, 12 Feb 2026 03:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=50.112.246.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770866325; cv=none; b=OlNJh/iZ90aQbGn2+FM7Oye82CU0q8p89QPVf05QTkXoq95OFrMw5NF47qHYtO7QD1r54EhQXH8jd8Z5+C0Y6lU21VKX06zL86PrhZk7Yxmn9ToyEJ1Ot7gLiHss52htenpT+i2gRy/BPfmJBhNFX7UzVnsZMqgO23qa6JlTRc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770866325; c=relaxed/simple;
	bh=kbR2iXU3EbDA6DHWKG5avhmsDkq2S1lsdq0ItM6rq1A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z5yyv4S/5QVoVB/eSbpT8WNMZCjwbkbgtaAHKa7BrH90X8KIvzmupUSiteRYu5ZdxNyFCUHiVcUZGYgcnaYl3+w8iCG7a4Q/wlUL45+asg3TLsuzdmBcbS6ZoHnOTM98jrKrxKDC4RQn4tl2uYYsUw/+I/+rVAVbdLyPkWXdCvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=s5Zn7p+X; arc=none smtp.client-ip=50.112.246.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="s5Zn7p+X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770866324; x=1802402324;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=319tCJAPzApml1aFj+kf+ZB/EmPdDNhoGau5ahSPZ1c=;
  b=s5Zn7p+XFbcWqRLZ1KeHxpwyV5qVTbTsD8MWtNOKSqUr3M5XCSxXm0vx
   +dpsnmkdAYN0qzHMY0uAUsy8g/6WjI+tujreb37Bx//Tg500YUqld17TF
   HnXfQeZhLBHZ27xX/+9XEqYgcQZI4CYMarWLZsRf9DzUnrq5DkyLHE7re
   FM3GQieogfnEdek/oVy048O1P6jHA9FwAMskZc+I7DWel5+ao3gRXcT1n
   1whkOe7N8gi5tZuNqfiUcjyEThRG+EjxFRbMHpqw/Fp5ndbiKoRK5/ix3
   P6/TAgiiRpFHpr5RR69xXIcNeexiOB12wqUHYf0pqCxgO+qRbIjHjJgxh
   Q==;
X-CSE-ConnectionGUID: 6MSooECPSYesyqd49qi6Ng==
X-CSE-MsgGUID: l8WSV7JKTa+nDEUCMcGpCA==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12744907"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 03:18:44 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.51:11484]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.3.19:2525] with esmtp (Farcaster)
 id b6835c7f-22ed-4649-b1c7-9322ccfd9e37; Thu, 12 Feb 2026 03:18:44 +0000 (UTC)
X-Farcaster-Flow-ID: b6835c7f-22ed-4649-b1c7-9322ccfd9e37
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:18:43 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:18:43 +0000
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
Subject: [PATCH 13/21] x86: crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_BLOWFISH_X86_64 crypto
Date: Thu, 12 Feb 2026 03:15:11 +0000
Message-ID: <20260212031521.2124-14-wanjay@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260212031521.2124-1-wanjay@amazon.com>
References: <20260212031521.2124-1-wanjay@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D046UWB004.ant.amazon.com (10.13.139.164) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_BLOWFISH_X86_64-related crypto to convert them into pluggable
interface.

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 arch/x86/crypto/Makefile        | 2 +-
 arch/x86/crypto/blowfish_glue.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 7e68f6bcfa29..cfef8fbfba8f 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -30,7 +30,7 @@ camellia-aesni-avx-x86_64-y := camellia-aesni-avx-asm_64.o camellia_aesni_avx_gl
 crypto-objs-$(CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64) += camellia-aesni-avx2.o
 camellia-aesni-avx2-y := camellia-aesni-avx2-asm_64.o camellia_aesni_avx2_glue.o
 
-obj-$(CONFIG_CRYPTO_BLOWFISH_X86_64) += blowfish-x86_64.o
+crypto-objs-$(CONFIG_CRYPTO_BLOWFISH_X86_64) += blowfish-x86_64.o
 blowfish-x86_64-y := blowfish-x86_64-asm_64.o blowfish_glue.o
 
 crypto-objs-$(CONFIG_CRYPTO_CAST5_AVX_X86_64) += cast5-avx-x86_64.o
diff --git a/arch/x86/crypto/blowfish_glue.c b/arch/x86/crypto/blowfish_glue.c
index 26c5f2ee5d10..48b20bc3bd54 100644
--- a/arch/x86/crypto/blowfish_glue.c
+++ b/arch/x86/crypto/blowfish_glue.c
@@ -187,8 +187,8 @@ static void __exit blowfish_fini(void)
 				    ARRAY_SIZE(bf_skcipher_algs));
 }
 
-module_init(blowfish_init);
-module_exit(blowfish_fini);
+crypto_module_init(blowfish_init);
+crypto_module_exit(blowfish_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Blowfish Cipher Algorithm, asm optimized");
-- 
2.47.3

