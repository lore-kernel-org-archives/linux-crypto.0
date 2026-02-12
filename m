Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E937E21C9E5;
	Thu, 12 Feb 2026 03:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.77.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770865303; cv=none; b=PO/jhnQDLbF+M6MnIg6L4i5S99FEKlqA7Org/ebgKNJOXSSvZfrODe6M5ludRvNgT/ulOfR60IIQfmZ0wHCc6LgjpF3pv0+JEi9vaTTuOQTXcdVYr0+KpaEE6c99e5YbCZ4oBJ3mkj/b6McEkbaz7hYhUfZ3pK3+FlG4beESEJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770865303; c=relaxed/simple;
	bh=dTeYlyHQMw0sMwJgh+RCeVrae0fopeuE4ZJ3cH5AP3c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lB3OBebcpIG8MCCc1F0oOeUncQJNf/k2CIS4/ZXom3z372FjILPiQx1T7xF4/4TKEGUj9keGCsRq+cvcR56iIo8f2ptaBUuFgvQ0smc66c3jlkCKAmAD11IRzgWtYOW+wiUfO3qMuVEwk9jg3W3RMD1Q7ixBUaWAZlzukbquKbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=Fy+k5GVw; arc=none smtp.client-ip=44.246.77.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="Fy+k5GVw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770865301; x=1802401301;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kIWUbDso2hbWtxwVUz/a9mSSptFv4Cfh4e5OO2ZoCG8=;
  b=Fy+k5GVwhbal5xD7wTtc+s2bhgDud8iuw0dry4eRW2gI845zCU/yXHpU
   1YRdwrSepotT4/G3v2c5qp7TFQF1MZmyQG0KkTtW2tEWir2WEC6dh1gTX
   8WMZmYUwVV1DRC/0uw3lPbN+LLbR+zCLazK9FjpeugGJrWTME5rLCN4st
   KZFK6DHnKwIJRuZ6M41BjVKj7qeW/pNtqBLnmx8XR2eEoabcIFs28alD0
   MQrb4amuXV4FcuN/mb0On2ROSpzXDODUkgCAC3Uzw+kTf33ffiKLRsM1a
   gpYIy44qEuaMeXZfBNwYRr8nDCspeAhymBXjwlsOB04IOAK9UObRTXRP0
   g==;
X-CSE-ConnectionGUID: RUexeF1TQV+8qLNAbbKUIw==
X-CSE-MsgGUID: P+8h7CXQQYS/FOsYp8e/pw==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12914777"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 03:01:41 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:10872]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.31.238:2525] with esmtp (Farcaster)
 id ee6691ae-a42f-4eb4-9442-ac02083b3a74; Thu, 12 Feb 2026 03:01:41 +0000 (UTC)
X-Farcaster-Flow-ID: ee6691ae-a42f-4eb4-9442-ac02083b3a74
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:01:40 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:01:40 +0000
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
Subject: [PATCH 055/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_ADIANTUM crypto
Date: Thu, 12 Feb 2026 02:46:31 +0000
Message-ID: <20260212024725.11264-56-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D043UWC003.ant.amazon.com (10.13.139.240) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_ADIANTUM-related crypto to convert them into pluggable
interface.

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile   | 2 +-
 crypto/adiantum.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index c3b0de034a47..34e278185d16 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -97,7 +97,7 @@ crypto-objs-$(CONFIG_CRYPTO_XTS) += xts.o
 crypto-objs-$(CONFIG_CRYPTO_CTR) += ctr.o
 crypto-objs-$(CONFIG_CRYPTO_XCTR) += xctr.o
 crypto-objs-$(CONFIG_CRYPTO_HCTR2) += hctr2.o
-obj-$(CONFIG_CRYPTO_ADIANTUM) += adiantum.o
+crypto-objs-$(CONFIG_CRYPTO_ADIANTUM) += adiantum.o
 crypto-objs-$(CONFIG_CRYPTO_GCM) += gcm.o
 crypto-objs-$(CONFIG_CRYPTO_CCM) += ccm.o
 obj-$(CONFIG_CRYPTO_CHACHA20POLY1305) += chacha20poly1305.o
diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index 5ddf585abb66..8e8e8654432c 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -683,8 +683,8 @@ static void __exit adiantum_module_exit(void)
 	crypto_unregister_template(&adiantum_tmpl);
 }
 
-module_init(adiantum_module_init);
-module_exit(adiantum_module_exit);
+crypto_module_init(adiantum_module_init);
+crypto_module_exit(adiantum_module_exit);
 
 MODULE_DESCRIPTION("Adiantum length-preserving encryption mode");
 MODULE_LICENSE("GPL v2");
-- 
2.47.3

