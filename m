Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9B01DDC3F;
	Thu, 12 Feb 2026 02:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.68.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770864510; cv=none; b=mB0n3btOlQvjYyF1LVaEn10GTMhdoyZEHMVACncPCU9macEKlHlnM9tFYszMOhkA0qFlyajb3lXrF27WVSmZlQzrcjlsGPsv+QmnmNzAyT4ZTlop8j/3HfveZXxWIJsWQFuNPbwYZyX3XEgcQlw40dwTgkEjc9BkmzRiP9aOpuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770864510; c=relaxed/simple;
	bh=wl/ZnelcqfQpfDxTMxyX5Qb8D9eTDNWEMqN+TanOehQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bH9xfF83NLOpzGW3WwaxyGJNJiYcjW1yTjAwkr2II7h8pkhEU8ORIAvbIKcbXjhDYzVGZ6RSUj+wZN5xiTfv/GgzQCwmKTOK4r6Cuar8yuv5aMXcxV5RUOZ4Nlt38enrDCkaRVyXReVVuC64aq9g8t0XCrMu0ZI27Gc6976FmCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=J7VDWMJe; arc=none smtp.client-ip=44.246.68.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="J7VDWMJe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770864509; x=1802400509;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VCBgKRe0M7vD2sUEFFMMA+23dBh3vsQZmLk7rxQKUWo=;
  b=J7VDWMJe8ZrF1ejv221iDAk335E4+7G+wj4VUg5joRUHlu3y52/zeunn
   eC9GZp9Zg54mG/DXht03QBC4jr1djUgVdo4fA61ABRzBlnjM+zeH5Pmr2
   Zsdq4kYV0IoXaeg4Sn1CbxkK+eRSJa2EILb1PVIXQjDf0ZS+XdKFNiYva
   4kL7DioS2nidtkeIlW/r++2u3X5NRKB1ttQsGSD0KoidB9dw1TNWklTJI
   cqmAuWpAFofU3+IkS3hGiATVx95WHYfyb7YeG7UwLse04xNG7NuTj45Ln
   8zqk79HZjnC8BKdEnlXH1nFHCSDs9Le63Z37b1OhYSsd9MnZ74Zycztsb
   w==;
X-CSE-ConnectionGUID: wYOjI1XLQASERCT4zCk1pA==
X-CSE-MsgGUID: iEXYafNuQ86gbTr0QciiTw==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12924945"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 02:48:29 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.51:24514]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.61.62:2525] with esmtp (Farcaster)
 id 9b351c8c-52ff-495f-85b4-a5639abb0c2c; Thu, 12 Feb 2026 02:48:28 +0000 (UTC)
X-Farcaster-Flow-ID: 9b351c8c-52ff-495f-85b4-a5639abb0c2c
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:48:28 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 02:48:28 +0000
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
Subject: [PATCH 004/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_GENIV crypto
Date: Thu, 12 Feb 2026 02:45:40 +0000
Message-ID: <20260212024725.11264-5-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D046UWB002.ant.amazon.com (10.13.139.181) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_GENIV-related crypto to convert them into pluggable
interface.

This patch is partially based on work by Vegard Nossum, with
modifications. Unlike the original, we do not include
DEFINE_CRYPTO_API since only one copy of the crypto symbols is
kept, either in the crypto module or in the main kernel, and we ensure
such wrapper do not have impact on crypto already chosen built as
module.

Co-developed-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile                 |  2 +-
 crypto/fips140/fips140-api.c    | 13 +++++++++++++
 include/crypto/internal/geniv.h | 14 ++++++++++----
 3 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 9aa52ddebb05..b05fdfacf170 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -16,7 +16,7 @@ crypto_algapi-y := algapi.o scatterwalk.o $(crypto_algapi-y)
 crypto-objs-$(CONFIG_CRYPTO_ALGAPI2) += crypto_algapi.o
 
 crypto-objs-$(CONFIG_CRYPTO_AEAD2) += aead.o
-obj-$(CONFIG_CRYPTO_GENIV) += geniv.o
+crypto-objs-$(CONFIG_CRYPTO_GENIV) += geniv.o
 
 crypto_skcipher-y += lskcipher.o
 crypto_skcipher-y += skcipher.o
diff --git a/crypto/fips140/fips140-api.c b/crypto/fips140/fips140-api.c
index eb02a56cb8b3..55129c62d813 100644
--- a/crypto/fips140/fips140-api.c
+++ b/crypto/fips140/fips140-api.c
@@ -129,4 +129,17 @@ DEFINE_CRYPTO_API_STUB(crypto_register_aeads);
 DEFINE_CRYPTO_API_STUB(crypto_unregister_aeads);
 DEFINE_CRYPTO_API_STUB(aead_register_instance);
 
+#endif
+
+/*
+ * crypto/geniv.c
+ */
+#if IS_BUILTIN(CONFIG_CRYPTO_GENIV)
+
+#include <crypto/internal/geniv.h>
+
+DEFINE_CRYPTO_API_STUB(aead_geniv_alloc);
+DEFINE_CRYPTO_API_STUB(aead_init_geniv);
+DEFINE_CRYPTO_API_STUB(aead_exit_geniv);
+
 #endif
\ No newline at end of file
diff --git a/include/crypto/internal/geniv.h b/include/crypto/internal/geniv.h
index 012f5fb22d43..f6dfe3292b3c 100644
--- a/include/crypto/internal/geniv.h
+++ b/include/crypto/internal/geniv.h
@@ -8,6 +8,7 @@
 #ifndef _CRYPTO_INTERNAL_GENIV_H
 #define _CRYPTO_INTERNAL_GENIV_H
 
+#include <crypto/api.h>
 #include <crypto/internal/aead.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
@@ -18,9 +19,14 @@ struct aead_geniv_ctx {
 	u8 salt[] __attribute__ ((aligned(__alignof__(u32))));
 };
 
-struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
-				       struct rtattr **tb);
-int aead_init_geniv(struct crypto_aead *tfm);
-void aead_exit_geniv(struct crypto_aead *tfm);
+DECLARE_CRYPTO_API(CONFIG_CRYPTO_GENIV, aead_geniv_alloc, struct aead_instance *,
+	(struct crypto_template *tmpl, struct rtattr **tb),
+	(tmpl, tb));
+DECLARE_CRYPTO_API(CONFIG_CRYPTO_GENIV, aead_init_geniv, int,
+	(struct crypto_aead *tfm),
+	(tfm));
+DECLARE_CRYPTO_API(CONFIG_CRYPTO_GENIV, aead_exit_geniv, void,
+	(struct crypto_aead *tfm),
+	(tfm));
 
 #endif	/* _CRYPTO_INTERNAL_GENIV_H */
-- 
2.47.3

