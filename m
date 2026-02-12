Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CAF221543;
	Thu, 12 Feb 2026 02:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.218.115.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770864872; cv=none; b=tgyVPNH/GOGM7J5504dI+ZGqPhvN5KAz/mc31a0yZA2B8WGi8LsTclCa2h2sJMZXotElncYn1klVUccnwgHL7OyIMSTyP1xH6vZXo56+FqSCvzVYtam7e4SgHV7mWa7EXl78QYYrQxsf4BXi+mlbvDfbj2aF10dlYEnJyZoxufI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770864872; c=relaxed/simple;
	bh=itKOfrbySEHZNXC1Gbomhb4Vs1SJx+EVul0rBcWbMTQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FcdIYWZUrkxykshnD5WksO0WzSc5P2KQst8ojEZN2+Pp1s17JPceKW/7hKXLcuOlLbii4jJSTE8TBjo5T364kxpjp1vwgOjD7wTnndMYOywhRomUmFs4I8u7yBzuIovdGKtIKIBEzEQp4YzBtnmbgrbM/Q483zSUKLzGrdM7VYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=QPL4rz8T; arc=none smtp.client-ip=34.218.115.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="QPL4rz8T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770864871; x=1802400871;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yiIBNcAcIxrdaW3m7D7ahOyrJ+i9keD2+i0anDLbbtM=;
  b=QPL4rz8TKYvpRHlAUup7bdXrtFr6ccj1ZSH8yZN5/P7ZQFInptlBaooj
   a1CMkKMoWHuIALqfKRJGMp2kSKG5iUxMYC5eAxYv1mMbwobWNibr2DnWf
   8S+oIIri4ZGvPaoHJqNLKMaC/WrZECC/IIT2Vaw23nFm+NRMdrIlylh8t
   P3DcPiCo7qHxmNXQHxBGjmMHPnnNx9GlOb06FtQmVi+WqPangUZxXrWyh
   oJIupERxNRx3no1GeXGr462pIzvpRExxmpdSuOCi4eFTa20xVrL6aaW6L
   kbHBGt9Av6FAE+kziUUV4H7eSvH3bFzrD8QqrwkP9qF4zpfSk2RfDorfk
   g==;
X-CSE-ConnectionGUID: fPPsmGLVSN+9b3DVkrevhw==
X-CSE-MsgGUID: h8pG9CDuSt2vegK9oKHYLQ==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12726735"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 02:54:26 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.51:5251]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.54.219:2525] with esmtp (Farcaster)
 id 3adbd6c3-6971-44b5-936d-e3f1998bdde6; Thu, 12 Feb 2026 02:54:25 +0000 (UTC)
X-Farcaster-Flow-ID: 3adbd6c3-6971-44b5-936d-e3f1998bdde6
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:54:25 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:54:25 +0000
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
Subject: [PATCH 027/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_LZO crypto
Date: Thu, 12 Feb 2026 02:46:03 +0000
Message-ID: <20260212024725.11264-28-wanjay@amazon.com>
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
CONFIG_CRYPTO_LZO-related crypto to convert them into pluggable
interface.

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile  | 2 +-
 crypto/lzo-rle.c | 4 ++--
 crypto/lzo.c     | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 3a2da61b4581..647797922678 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -157,7 +157,7 @@ obj-$(CONFIG_CRYPTO_CRC32) += crc32-cryptoapi.o
 crc32-cryptoapi-y := crc32.o
 crypto-objs-$(CONFIG_CRYPTO_AUTHENC) += authenc.o authencesn.o
 obj-$(CONFIG_CRYPTO_KRB5ENC) += krb5enc.o
-obj-$(CONFIG_CRYPTO_LZO) += lzo.o lzo-rle.o
+crypto-objs-$(CONFIG_CRYPTO_LZO) += lzo.o lzo-rle.o
 obj-$(CONFIG_CRYPTO_LZ4) += lz4.o
 obj-$(CONFIG_CRYPTO_LZ4HC) += lz4hc.o
 obj-$(CONFIG_CRYPTO_XXHASH) += xxhash_generic.o
diff --git a/crypto/lzo-rle.c b/crypto/lzo-rle.c
index 794e7ec49536..10af97e741fa 100644
--- a/crypto/lzo-rle.c
+++ b/crypto/lzo-rle.c
@@ -93,8 +93,8 @@ static void __exit lzorle_mod_fini(void)
 	crypto_unregister_scomp(&scomp);
 }
 
-module_init(lzorle_mod_init);
-module_exit(lzorle_mod_fini);
+crypto_module_init(lzorle_mod_init);
+crypto_module_exit(lzorle_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("LZO-RLE Compression Algorithm");
diff --git a/crypto/lzo.c b/crypto/lzo.c
index d43242b24b4e..e1f9bc40f89f 100644
--- a/crypto/lzo.c
+++ b/crypto/lzo.c
@@ -93,8 +93,8 @@ static void __exit lzo_mod_fini(void)
 	crypto_unregister_scomp(&scomp);
 }
 
-module_init(lzo_mod_init);
-module_exit(lzo_mod_fini);
+crypto_module_init(lzo_mod_init);
+crypto_module_exit(lzo_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("LZO Compression Algorithm");
-- 
2.47.3

