Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3934414;
	Thu, 12 Feb 2026 03:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.83.148.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770865348; cv=none; b=cKY/71d2O5KlFdE7iefUE1YRf/yZLo5TFhcGS6ERxAKfat7Xm3X5xVLVnp9nXB5U5Nd9fYMDhQWxxLWrKME7Xk9oWp/JnkoSK4bZvNff5oh0nVT2DIY48hlW4CDMLU5V6DFguBdibBcmaCzzPbYl48+oVemX323MYf9qDGx96vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770865348; c=relaxed/simple;
	bh=Qa0chQe0JusL+RbTnMJkASsPQvjOqsYd/aIEOAS7NEU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WyfPpFqWxp3dMkm4l6ooM4zhTa/3oMJZrw4YZDFmkjYpnpWcMepPhLQ+UspfFVwbtF9N9M0OwwfUmkocjLNTdxMa5d6pgEe9ZVo7EMwx6yl/QbUBRCC/CPgIJ/IlXMISmwttRnfDf6LAGfX40TU0lAmXoL+CPBc2BSYl0O3glpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=N2HS+Han; arc=none smtp.client-ip=35.83.148.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="N2HS+Han"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770865347; x=1802401347;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CBQH0kwP6EeA21IhBKg8rBmdki1aKnWiFhYi1a/9mKE=;
  b=N2HS+Hannd530Btd6lwguqLXn1J2UN/ahln/UGgI2RGb/lQflLUxXQg6
   ekVfrvBQE1X4evi+hortEw0b7DWtqQQnbbCDgI6g/PFjuLgBhl6QEQaah
   fj0MOxKVEdgWHps7Rup2u5aeD6qH5f6gL+RYcETQcucgCoplXVMswQJXP
   +DwS8M1i3eOx28HVW338bjySg9Cc6Gp5frz+TuiPCLJYnOkfKlA0gAfPP
   mApy3FXl6zMDSYkLIK1ac+DoEAiXMs4gTiItypvz7dHxmDpNlwTrUD6la
   7bsQXgyrFbxG7Gm5l08ABSGbUYdAdx88t+OKcsQwZg4RemT4tUB6lXgPr
   g==;
X-CSE-ConnectionGUID: 8+D2cNraSU6eQsOEpJufYA==
X-CSE-MsgGUID: wI/ugeuqSAeyGsqdh9L/SQ==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12696904"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 03:02:27 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.51:12879]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.0.85:2525] with esmtp (Farcaster)
 id 485832dd-5970-45db-a3a1-3dc69dcf592b; Thu, 12 Feb 2026 03:02:27 +0000 (UTC)
X-Farcaster-Flow-ID: 485832dd-5970-45db-a3a1-3dc69dcf592b
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:02:27 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:02:26 +0000
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
Subject: [PATCH 058/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_AEGIS128 crypto
Date: Thu, 12 Feb 2026 02:46:34 +0000
Message-ID: <20260212024725.11264-59-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D032UWB001.ant.amazon.com (10.13.139.152) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_AEGIS128-related crypto to convert them into pluggable
interface.

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile        | 2 +-
 crypto/aegis128-core.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index f71f2359ce08..cb1761303151 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -101,7 +101,7 @@ crypto-objs-$(CONFIG_CRYPTO_ADIANTUM) += adiantum.o
 crypto-objs-$(CONFIG_CRYPTO_GCM) += gcm.o
 crypto-objs-$(CONFIG_CRYPTO_CCM) += ccm.o
 crypto-objs-$(CONFIG_CRYPTO_CHACHA20POLY1305) += chacha20poly1305.o
-obj-$(CONFIG_CRYPTO_AEGIS128) += aegis128.o
+crypto-objs-$(CONFIG_CRYPTO_AEGIS128) += aegis128.o
 aegis128-y := aegis128-core.o
 
 ifeq ($(ARCH),arm)
diff --git a/crypto/aegis128-core.c b/crypto/aegis128-core.c
index ca80d861345d..2c8dfafcfdc8 100644
--- a/crypto/aegis128-core.c
+++ b/crypto/aegis128-core.c
@@ -566,8 +566,8 @@ static void __exit crypto_aegis128_module_exit(void)
 	crypto_unregister_aead(&crypto_aegis128_alg_generic);
 }
 
-module_init(crypto_aegis128_module_init);
-module_exit(crypto_aegis128_module_exit);
+crypto_module_init(crypto_aegis128_module_init);
+crypto_module_exit(crypto_aegis128_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Ondrej Mosnacek <omosnacek@gmail.com>");
-- 
2.47.3

