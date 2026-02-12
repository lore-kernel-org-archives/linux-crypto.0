Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DC919CC0C;
	Thu, 12 Feb 2026 03:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.155.198.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770865410; cv=none; b=EpKW2JbTljrTxUMygrCMpkMCIiRAvmpHwYmHHFL1jf/AJ4+3XmO312eiAqrzgaA+Azm/dV8iLP+wtEGxDgNShb8//B7DveqCI1vyH5BSWiOkIndLj60GJ2L1nQeq4SbzBtdLDxbnvaykRJdjmNialhdPwygWeKWkzq+TFOfIBLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770865410; c=relaxed/simple;
	bh=e6DwX3P1NmmuSXTs7e8H3fYroLVzaeB5tlvX1jl/Cqo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jiVEVsO6+MtJUizKZW04nQOdGRCx66fqf0LLRgIxsLecOVRys5qh5sE0VNQfAEkw8S8/CoXjYfOQbNbwol/zFxueSha3Wf6OVrxZIlAaflZ8Lx8g1vefh+CimuE0H5jSyKaAAGazErxinIG5hjELm0Eo+TH9/m95knf7kDDdqOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=cn57p3Rw; arc=none smtp.client-ip=35.155.198.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="cn57p3Rw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770865410; x=1802401410;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zOXH1N267G9hujtPzTm5MQjsS7J53g1yuw7bcNztYkk=;
  b=cn57p3RwlTtaIUYUHCHa8Sy1Hb90Zq/WbOdn9kiN7ojK2BN1RI3yFSm5
   ejf+77Fb0hsDG6bq3GkRr+34ugBIvw9GAMZgdfV41+DYfZvib2FIi4Syy
   Rz1vXlfsTr2hHy1GgSArFf0DTYAYqKKMGOFL3ZxbJbtb31og/zDWjYoZX
   Qoe9uxbup5jTtmNk3JV+AhS+dSi9aDdJ3EnO2u7QsyMtnQtE3E+v9hlZR
   xTvL4L6YNxz0bAgQixsLOfjw4jxL+SYKV7goY0QhX4A91kJZXlvdZD0z/
   CbBw1df1CRvKLrA4gQgP/jOI2qtErfu4FHsaatP9HHD3euijUJnrqwyw9
   A==;
X-CSE-ConnectionGUID: JTIezI2fSB2LWCEUqfoOug==
X-CSE-MsgGUID: IYaTOyDxQKet5jqjaeY8rg==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12803675"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 03:03:29 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:2423]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.40.228:2525] with esmtp (Farcaster)
 id 26a7f20d-170f-462e-9658-434f6a797ab7; Thu, 12 Feb 2026 03:03:29 +0000 (UTC)
X-Farcaster-Flow-ID: 26a7f20d-170f-462e-9658-434f6a797ab7
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:03:29 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:03:28 +0000
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
Subject: [PATCH 062/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_FCRYPT crypto
Date: Thu, 12 Feb 2026 02:46:38 +0000
Message-ID: <20260212024725.11264-63-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D045UWC002.ant.amazon.com (10.13.139.230) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_FCRYPT-related crypto to convert them into pluggable
interface.

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile | 2 +-
 crypto/fcrypt.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 05fdb0e2f1be..84dff7084f71 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -127,7 +127,7 @@ CFLAGS_aegis128-neon-inner.o += -isystem $(shell $(CC) -print-file-name=include)
 crypto-objs-$(CONFIG_CRYPTO_PCRYPT) += pcrypt.o
 crypto-objs-$(CONFIG_CRYPTO_CRYPTD) += cryptd.o
 crypto-objs-$(CONFIG_CRYPTO_DES) += des_generic.o
-obj-$(CONFIG_CRYPTO_FCRYPT) += fcrypt.o
+crypto-objs-$(CONFIG_CRYPTO_FCRYPT) += fcrypt.o
 obj-$(CONFIG_CRYPTO_BLOWFISH) += blowfish_generic.o
 obj-$(CONFIG_CRYPTO_BLOWFISH_COMMON) += blowfish_common.o
 obj-$(CONFIG_CRYPTO_TWOFISH) += twofish_generic.o
diff --git a/crypto/fcrypt.c b/crypto/fcrypt.c
index 80036835cec5..f1c9ae91d4b5 100644
--- a/crypto/fcrypt.c
+++ b/crypto/fcrypt.c
@@ -411,8 +411,8 @@ static void __exit fcrypt_mod_fini(void)
 	crypto_unregister_alg(&fcrypt_alg);
 }
 
-module_init(fcrypt_mod_init);
-module_exit(fcrypt_mod_fini);
+crypto_module_init(fcrypt_mod_init);
+crypto_module_exit(fcrypt_mod_fini);
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("FCrypt Cipher Algorithm");
-- 
2.47.3

