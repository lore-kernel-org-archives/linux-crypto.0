Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537EA225762;
	Thu, 12 Feb 2026 02:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.12.53.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770865069; cv=none; b=DnlOSZrHt/cr1L2tfNjT1Ux339DEKCVR0McR5NmVqZh7T5L7gbDm7ZGDOenda3fdiUPnaJlhb9H7+tdtYbZWOAp5As+A8U6c7SFSrzHjb9yGM3IWtQbhKGP5U/yokitXqytDih2KJdosSlXjuQftDAwMumgUYRioxOsOuDKGMyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770865069; c=relaxed/simple;
	bh=P9zNZx+lxosupmpJ5I19xMpWskEaN+pZxkS9j94loWg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jk0+Tgl6ItomgNJigwbfN7iIp0BvvTSZgvrqWe/LDv4mhPvsO3GbZa0VoPMrRhdbwQQ24d3n3Tb4Ccsnnc+ncg6Y6eAPOX0jXiiJVtuEuOjRL+kdpCKc6mlxgC/VFPFmROMbs1ZXfXWHTgGkh5A5iIXfZTWvponoSUlSaRYg+4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=CUYtAaDx; arc=none smtp.client-ip=52.12.53.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="CUYtAaDx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770865068; x=1802401068;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ahqPEftUZPy1sWkLpdMipWuCTyir/u4afuslj+49uZM=;
  b=CUYtAaDxymwmQrfNvCLA59FIaFk/Uc6Oa0hMF7pcPN5cQ9/9CuXnJIbX
   L+mmyxWLesJIoZImWvHx2e42Ka39rgJLDCHuMNIkFH8DG4FFPAD40XjbY
   C+/I+Abm558Qcxag9xasNAPb9tpdCPQ8hLMVSU1jtJTezJIcuosB2GR/K
   ujTR69n1A/Ib28ASbEKLLA72EbrxKxNIe6NbR6gLe+9UhrBCr5q1vwRa9
   q2Auq+EByrEs69b8daT/XZV9EitzFTjtt8nv87qipiRS3Kxfxor53Usz7
   IPUlUKdbLB/+36+zE7kjVZ0Nt3jI4omr7SYZK2JJyaPqmg4rJO6hWQD1D
   w==;
X-CSE-ConnectionGUID: MwE9kN7tSfKJbv5lFUaJAA==
X-CSE-MsgGUID: sDu7WpUqRFuYGK/P4HWslQ==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12793663"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 02:57:48 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.51:8513]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.3.19:2525] with esmtp (Farcaster)
 id cf5f4de5-253c-46d0-9430-74fc5093d890; Thu, 12 Feb 2026 02:57:47 +0000 (UTC)
X-Farcaster-Flow-ID: cf5f4de5-253c-46d0-9430-74fc5093d890
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:57:47 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:57:47 +0000
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
Subject: [PATCH 040/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_USER crypto
Date: Thu, 12 Feb 2026 02:46:16 +0000
Message-ID: <20260212024725.11264-41-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D036UWB001.ant.amazon.com (10.13.139.133) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_USER-related crypto to convert them into pluggable
interface.

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile      | 2 +-
 crypto/crypto_user.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 2e3704e67e14..390d38d17e4b 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -71,7 +71,7 @@ crypto-objs-$(CONFIG_CRYPTO_ACOMP2) += crypto_acompress.o
 cryptomgr-y := algboss.o testmgr.o
 
 crypto-objs-$(CONFIG_CRYPTO_MANAGER2) += cryptomgr.o
-obj-$(CONFIG_CRYPTO_USER) += crypto_user.o
+crypto-objs-$(CONFIG_CRYPTO_USER) += crypto_user.o
 crypto-objs-$(CONFIG_CRYPTO_CMAC) += cmac.o
 crypto-objs-$(CONFIG_CRYPTO_HMAC) += hmac.o
 obj-$(CONFIG_CRYPTO_XCBC) += xcbc.o
diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 3187e0d276f9..8d03a2ff24de 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -498,8 +498,8 @@ static void __exit crypto_user_exit(void)
 	unregister_pernet_subsys(&crypto_netlink_net_ops);
 }
 
-module_init(crypto_user_init);
-module_exit(crypto_user_exit);
+crypto_module_init(crypto_user_init);
+crypto_module_exit(crypto_user_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Steffen Klassert <steffen.klassert@secunet.com>");
 MODULE_DESCRIPTION("Crypto userspace configuration API");
-- 
2.47.3

