Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D531A5B8B;
	Thu, 12 Feb 2026 03:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.162.73.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770865364; cv=none; b=HhUghlZwJCfzE6A2uGsNnh7QHwNzTl3iw7E5Yf7u+3Anf+fpqAcWDOeiBprtZWMWHa58ET77/SZN+m4neJEvHpkgjuXTdg9B7Z0yQgTsjDMBoHl5gGZt5/xzYKowUPtpgIURJxx1wx6kwepD+I+Wu47EERHZ8hhqu280bni76A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770865364; c=relaxed/simple;
	bh=gtI43jN6CnyNWHjAasr1EXn7iNwknCpGHSir7J6afdY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZYqRSQvcLZwH1H2KC7wbZegBxT8jk010zXPb3Q6CtShDWBTOFHz2MTWfyKp1ThAV6XehjFvuMZCGb9draGlD4PFSudAE0s/NwMBWfaVB7gHYHpFwqKn3DNnxi6het2jDoGVcfhb0ic6P8fc7TzKSiNQtgOjI9CGlPUFDSGK5hqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=O010gFeK; arc=none smtp.client-ip=35.162.73.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="O010gFeK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770865363; x=1802401363;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zZLY2RdWFAnfhdQV4nMnvlY/DhIxSQaBwFJhqH+s+gw=;
  b=O010gFeKj88yC/qsMrIXB+J+RxP/zjBUiYAwRK6q5Ll1vlng3dq54bUP
   9kYD/uZ0zrg4pQGB0d1wRb+Rx/lLBkrgGuSKXTDHlOLqAfx7eJ45hhHJf
   QmeBg58wF+/Dk9QoYjtL0dZz5C3foPN6lQjM5odXeOrnEjpJAq6HZ7JiM
   3j/CzHbGP0r6GeTChF78VGfUCoG+nJiqkGohkSFWhb9IOpCe1160umZwT
   +uYeed4o7Ri0NqzoXBOAPJgYctB4dMxXBVFCOwIss54U8BQJDrWCamZCJ
   T9U/iRSaaJvFzy/Oqjf+gG53JWxyzc9kYWoKM0D0z4soPMkknnDAcmNJk
   Q==;
X-CSE-ConnectionGUID: pqsTA/wHTXqJut1X1+SSwQ==
X-CSE-MsgGUID: CJwS5mjkSwGtxbS/dIDCVg==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12721958"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 03:02:43 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.51:8677]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.20.103:2525] with esmtp (Farcaster)
 id cdf3a59c-ab7a-4fbd-8af7-ab8a28d38c5c; Thu, 12 Feb 2026 03:02:42 +0000 (UTC)
X-Farcaster-Flow-ID: cdf3a59c-ab7a-4fbd-8af7-ab8a28d38c5c
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:02:42 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:02:42 +0000
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
Subject: [PATCH 059/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_PCRYPT crypto
Date: Thu, 12 Feb 2026 02:46:35 +0000
Message-ID: <20260212024725.11264-60-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D041UWA001.ant.amazon.com (10.13.139.124) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

From: Vegard Nossum <vegard.nossum@oracle.com>

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_PCRYPT-related crypto to convert them into pluggable
interface.

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
[add pcrypt.o into crypto-objs-y; revise commit message]
Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile | 2 +-
 crypto/pcrypt.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index cb1761303151..b371a8788d39 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -124,7 +124,7 @@ endif
 # Enable <arm_neon.h>
 CFLAGS_aegis128-neon-inner.o += -isystem $(shell $(CC) -print-file-name=include)
 
-obj-$(CONFIG_CRYPTO_PCRYPT) += pcrypt.o
+crypto-objs-$(CONFIG_CRYPTO_PCRYPT) += pcrypt.o
 obj-$(CONFIG_CRYPTO_CRYPTD) += cryptd.o
 obj-$(CONFIG_CRYPTO_DES) += des_generic.o
 obj-$(CONFIG_CRYPTO_FCRYPT) += fcrypt.o
diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index c3a9d4f2995c..b9cf7df64c4e 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -378,8 +378,8 @@ static void __exit pcrypt_exit(void)
 	kset_unregister(pcrypt_kset);
 }
 
-module_init(pcrypt_init);
-module_exit(pcrypt_exit);
+crypto_module_init(pcrypt_init);
+crypto_module_exit(pcrypt_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Steffen Klassert <steffen.klassert@secunet.com>");
-- 
2.47.3

