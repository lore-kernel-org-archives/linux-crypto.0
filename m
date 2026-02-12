Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5029B8C1F;
	Thu, 12 Feb 2026 02:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.83.148.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770864791; cv=none; b=Y5NnrBjsNPy817VnJVpGW+qTi1bnnHGlya/qzG2jG22J+zdUfkWqFY1FZ2Mm7z4XUme+yJCubjnRHiQr9Tc6KuSjWyPHzj48+zC+wwWBT/e7lRsQEA8T9tkVVzIOtJn5b2/C1Oe02wC+H+l8lF1iMIFn4JYvlZryzZmytzSXtMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770864791; c=relaxed/simple;
	bh=oy9Lst+pLYKNqwQ8sVfrNA4kGKQMrvI+s7G8IPWB0fQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eCQkyUGvTWJU62ZEkTUnpOY0snbXAuksgYczVS19DZQVSO3eVXd1JAh0VuSMXAdxfQ90IOOHQy1zo2wQ+m35wEjTd56xH+ACwaI//MZtx7kNacHxgetx62V+XxgeKrVwrO7OFG0dH/CTEJiXypboaRL+VWtDoZIxZosxp0/cBIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=DAzAefgL; arc=none smtp.client-ip=35.83.148.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="DAzAefgL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770864790; x=1802400790;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v30rZp4i+5voMyaGtVYP7bAFYIxv6GrOaq3WTbl/qhw=;
  b=DAzAefgLVchKBiRnWu/McEP43MDW/9xnaz5xCttos8+GyMMrl4IeXwOT
   +F5+tycePwC+bd6o9UhecDN1FeyniNPEK2dS2H1h809hbPn16cWFXUN0E
   o3Tjjyo3huRZXxNXcONN2zska/ZTznkNkgL381fvThjDfVWXkoxQJlqxk
   9mtGpcf6n+YjLj4N+sXdSwg5JsQAqCvCZ+wFSHX1Y0x3VgaqWkvzC0bFX
   sWOH3VpQHyN04cL/lFU1v6G7Y+RUKcX+wZJd5Z1cIiMnEJh1yfEVxU/Gh
   w5GA6qiC1oE67ukXjwyODmonm+SwiNPeXn+6S04TWalAMOcSHMARXvz8W
   Q==;
X-CSE-ConnectionGUID: amvACGz8Qq+fiuzZS9zCEg==
X-CSE-MsgGUID: 6ddnNv3kQo2hJM3GoIBlHg==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12696481"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 02:53:09 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.51:17579]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.3.19:2525] with esmtp (Farcaster)
 id 10896a61-78a7-42bf-abff-cbcd0e54b5fb; Thu, 12 Feb 2026 02:53:09 +0000 (UTC)
X-Farcaster-Flow-ID: 10896a61-78a7-42bf-abff-cbcd0e54b5fb
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:53:08 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:53:07 +0000
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
Subject: [PATCH 022/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_CBC crypto
Date: Thu, 12 Feb 2026 02:45:58 +0000
Message-ID: <20260212024725.11264-23-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D046UWA003.ant.amazon.com (10.13.139.18) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

From: Vegard Nossum <vegard.nossum@oracle.com>

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_CBC-related crypto to convert them into pluggable
interface.

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
[add cbc.o into crypto-objs-y; revise commit message]
Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile | 2 +-
 crypto/cbc.c    | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 11a6714dee42..354ce7a46a0a 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -89,7 +89,7 @@ obj-$(CONFIG_CRYPTO_WP512) += wp512.o
 CFLAGS_wp512.o := $(call cc-option,-fno-schedule-insns)  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79149
 obj-$(CONFIG_CRYPTO_BLAKE2B) += blake2b.o
 crypto-objs-$(CONFIG_CRYPTO_ECB) += ecb.o
-obj-$(CONFIG_CRYPTO_CBC) += cbc.o
+crypto-objs-$(CONFIG_CRYPTO_CBC) += cbc.o
 obj-$(CONFIG_CRYPTO_PCBC) += pcbc.o
 obj-$(CONFIG_CRYPTO_CTS) += cts.o
 obj-$(CONFIG_CRYPTO_LRW) += lrw.o
diff --git a/crypto/cbc.c b/crypto/cbc.c
index ed3df6246765..03ee7008ab12 100644
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -179,8 +179,8 @@ static void __exit crypto_cbc_module_exit(void)
 	crypto_unregister_template(&crypto_cbc_tmpl);
 }
 
-module_init(crypto_cbc_module_init);
-module_exit(crypto_cbc_module_exit);
+crypto_module_init(crypto_cbc_module_init);
+crypto_module_exit(crypto_cbc_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("CBC block cipher mode of operation");
-- 
2.47.3

