Received: from pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com [50.112.246.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDFA1BC46;
	Thu, 12 Feb 2026 02:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=50.112.246.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770864821; cv=none; b=qoCS4zqsCKCFa9ER9D9LWL84I1irZzih5E9rHe1bST6Z5cArCRXiuruWmfuX4UWc3CmHauSzpiH8ocASIvpaZI4E7SHH05tEjDVVYrGES6CMQjBmjqxnlPDrPF+jGbKiaRvGfMHAu7huy8z3WsCyv02Ri8uRpo+EaRHHx1J+jFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770864821; c=relaxed/simple;
	bh=GdtSYwsh4KwiE/6v/L8nJBBhbYQeHe21MPK7MgblcAU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L7wc0cYpEp6Ok+lX7mhE2hqebnZFNP1AhPXvxBLF/goqE7t+xFwl74BlYGGHHZeCGVfTznF0LawYGxtVaHACoz6Hel6mlQkZJV9OVviKUInTmkG/NQSEB7ww4r4fAdgDsF5NGuCIEKqIRV/5wHmMk86QLBG/vsw8zxznPsWLTls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=N16NfpLR; arc=none smtp.client-ip=50.112.246.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="N16NfpLR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770864820; x=1802400820;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oGbo5qhTe577pqrQ9ND6f63OdqvG3EyYMTypktWkDO0=;
  b=N16NfpLRP1O+2jiFXYk06KonhWwt/Mdc8EBYpQ3s0OwvhNowc6zK5Hi5
   XKYA/YJixVG5DHthdd4BG/4P+cFb70I3NsUHFg7ibPdE0fbfV0exmwokw
   hjPZIKsYwj61dYd3H7oWxP7YFMuaDJALufUQQ8B6t+mapq9mocI4bFbHI
   rmNZN8tZy3lNmdjUFAZWLotasZHuZJe3RjRx+QmsthpKfIZ6cUuehfo97
   p0iYbBZHRF+AuUnPIeK1dpNCzQ6LUbWexn0EUrXRgZo7FN8ZIoqevfqWV
   OPIBSQxfGg/kf1ExNvMh6SFSbRIAVSgAnVddRSAXq6IyG84ymURixvGoL
   g==;
X-CSE-ConnectionGUID: YAXV6n4wTaGaiKPN9kO0yQ==
X-CSE-MsgGUID: QiFvn59mS3K/Sdr2w5LeoQ==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12744145"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 02:53:39 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:7889]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.20.103:2525] with esmtp (Farcaster)
 id ff7a62e9-741a-405d-924b-013e88bc1bb4; Thu, 12 Feb 2026 02:53:39 +0000 (UTC)
X-Farcaster-Flow-ID: ff7a62e9-741a-405d-924b-013e88bc1bb4
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:53:39 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:53:39 +0000
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
Subject: [PATCH 024/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_GCM crypto
Date: Thu, 12 Feb 2026 02:46:00 +0000
Message-ID: <20260212024725.11264-25-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D040UWA001.ant.amazon.com (10.13.139.22) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

From: Vegard Nossum <vegard.nossum@oracle.com>

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_GCM-related crypto to convert them into pluggable
interface.

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
[add gcm.o into crypto-objs-y; revise commit message]
Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile | 2 +-
 crypto/gcm.c    | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index d5b5ca797dc6..11bb65cf0094 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -98,7 +98,7 @@ crypto-objs-$(CONFIG_CRYPTO_CTR) += ctr.o
 obj-$(CONFIG_CRYPTO_XCTR) += xctr.o
 obj-$(CONFIG_CRYPTO_HCTR2) += hctr2.o
 obj-$(CONFIG_CRYPTO_ADIANTUM) += adiantum.o
-obj-$(CONFIG_CRYPTO_GCM) += gcm.o
+crypto-objs-$(CONFIG_CRYPTO_GCM) += gcm.o
 obj-$(CONFIG_CRYPTO_CCM) += ccm.o
 obj-$(CONFIG_CRYPTO_CHACHA20POLY1305) += chacha20poly1305.o
 obj-$(CONFIG_CRYPTO_AEGIS128) += aegis128.o
diff --git a/crypto/gcm.c b/crypto/gcm.c
index 97716482bed0..54a376e782d1 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -1119,8 +1119,8 @@ static void __exit crypto_gcm_module_exit(void)
 				    ARRAY_SIZE(crypto_gcm_tmpls));
 }
 
-module_init(crypto_gcm_module_init);
-module_exit(crypto_gcm_module_exit);
+crypto_module_init(crypto_gcm_module_init);
+crypto_module_exit(crypto_gcm_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Galois/Counter Mode");
-- 
2.47.3

