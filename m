Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FBC239567;
	Thu, 12 Feb 2026 03:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.68.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770866064; cv=none; b=ug2rg1/3XordKvN9QN6qdjONTtYa+XHiKIq0Vh4Yl+ZYCTHqbhSFoVb+YHxA/tNNWHwlHU1IWXEn+sjrOcwvbisVuLIyZ/4CMo5CNLATKKWFU/p+fVEUf+NRcRvzjgtHYeQsHAfUJlLadAtwsNl645H9vR2Oo5a372S8xvZ60HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770866064; c=relaxed/simple;
	bh=wtDHHbTraFgbo4BeuAQNwnsZxGvcA1Dm84w0M2asKOQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Uc6OaUvpGJawqTQ5JP92J3u6Hm1C6hVOfu40ZBUVz81LL5CdlUzdRME3F9Ui//AMCFIgq0cR/RhB02ZmRwMTd4OGTu5J6kc7w7Cap2P+b/aGhQ1y+HBoZEhBQ6h25xEhYgn/nfSaVKPLfPCXMqHWmzedu0ceqFtrG05rrJzMHv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=Cb9bCHQA; arc=none smtp.client-ip=44.246.68.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="Cb9bCHQA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770866063; x=1802402063;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W6R44s4v9WVLvSIfHCSXPI7VL9RaLX8DW5Ij3cTn/Eo=;
  b=Cb9bCHQA/BMCpTsaaV+934yhJbTkka4/NwFyZca/SzdTno5jYafWtnGC
   7eSLYRDdIdOPrnPWTbQwITEcgfc0kiiq7sPfSPl4HMjaf2CPpl8YOn7Ln
   0dQCBY8GQNJoIhh0S0FU1WplBmj8Y/h86379rTKHFIMdIYw17a1kBZ0Ae
   QSg/4aqJYO2ecVJCsimRTSAw4p96MKKW6XhSbgqJYKwiima35Nuv2nVeR
   YURNXaBs7EoG8KhfNxRgX/hQ72uIDBJZ0B18X34tHfN1eHJsTXREpM1+I
   QXF3JKI5U517uy2AhlH6MyVCdugAT4JBLTMBqvZTGGdn0CNSkWnIJuiHY
   g==;
X-CSE-ConnectionGUID: Vud3MRZcRDSTzz/yAOFHnw==
X-CSE-MsgGUID: V6L8O722RviEhSTMo6bCjg==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12926118"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 03:14:23 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:30299]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.54.219:2525] with esmtp (Farcaster)
 id 15d95859-e0c4-49db-ad14-cd74426d3494; Thu, 12 Feb 2026 03:14:23 +0000 (UTC)
X-Farcaster-Flow-ID: 15d95859-e0c4-49db-ad14-cd74426d3494
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:14:21 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:14:21 +0000
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
Subject: [PATCH 104/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_SIGNED_PE_FILE_VERIFICATION crypto
Date: Thu, 12 Feb 2026 02:47:20 +0000
Message-ID: <20260212024725.11264-105-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D040UWB002.ant.amazon.com (10.13.138.89) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_SIGNED_PE_FILE_VERIFICATION-related crypto to convert them into
pluggable interface.

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/asymmetric_keys/Makefile        |  2 +-
 crypto/asymmetric_keys/verify_pefile.c |  1 +
 crypto/fips140/fips140-api.c           | 10 ++++++++++
 include/linux/verification.h           |  8 +++++---
 4 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index 6a17f563c359..bccf6952e0e5 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -70,7 +70,7 @@ pkcs7_test_key-y := \
 #
 # Signed PE binary-wrapped key handling
 #
-obj-$(CONFIG_SIGNED_PE_FILE_VERIFICATION) += verify_signed_pefile.o
+crypto-objs-$(CONFIG_SIGNED_PE_FILE_VERIFICATION) += verify_signed_pefile.o
 
 verify_signed_pefile-y := \
 	verify_pefile.o \
diff --git a/crypto/asymmetric_keys/verify_pefile.c b/crypto/asymmetric_keys/verify_pefile.c
index 1f3b227ba7f2..15e4e51f9f35 100644
--- a/crypto/asymmetric_keys/verify_pefile.c
+++ b/crypto/asymmetric_keys/verify_pefile.c
@@ -454,3 +454,4 @@ int verify_pefile_signature(const void *pebuf, unsigned pelen,
 	kfree_sensitive(ctx.digest);
 	return ret;
 }
+EXPORT_SYMBOL(verify_pefile_signature);
\ No newline at end of file
diff --git a/crypto/fips140/fips140-api.c b/crypto/fips140/fips140-api.c
index 3e4203dd2aeb..74eae8815067 100644
--- a/crypto/fips140/fips140-api.c
+++ b/crypto/fips140/fips140-api.c
@@ -903,4 +903,14 @@ DEFINE_CRYPTO_API_STUB(crypto_ecdh_key_len);
 DEFINE_CRYPTO_API_STUB(crypto_ecdh_encode_key);
 DEFINE_CRYPTO_API_STUB(crypto_ecdh_decode_key);
 
+#endif
+/*
+ * crypto/asymmetric_keys/verify_pefile.c
+ */
+#if IS_BUILTIN(CONFIG_SIGNED_PE_FILE_VERIFICATION)
+
+#include <linux/verification.h>
+
+DEFINE_CRYPTO_API_STUB(verify_pefile_signature);
+
 #endif
\ No newline at end of file
diff --git a/include/linux/verification.h b/include/linux/verification.h
index dec7f2beabfd..b050da314117 100644
--- a/include/linux/verification.h
+++ b/include/linux/verification.h
@@ -8,6 +8,8 @@
 #ifndef _LINUX_VERIFICATION_H
 #define _LINUX_VERIFICATION_H
 
+#include <crypto/api.h>
+
 #include <linux/errno.h>
 #include <linux/types.h>
 
@@ -63,9 +65,9 @@ extern int verify_pkcs7_message_sig(const void *data, size_t len,
 				    void *ctx);
 
 #ifdef CONFIG_SIGNED_PE_FILE_VERIFICATION
-extern int verify_pefile_signature(const void *pebuf, unsigned pelen,
-				   struct key *trusted_keys,
-				   enum key_being_used_for usage);
+DECLARE_CRYPTO_API(CONFIG_SIGNED_PE_FILE_VERIFICATION, verify_pefile_signature, int,
+	(const void *pebuf, unsigned pelen, struct key *trusted_keys, enum key_being_used_for usage),
+	(pebuf, pelen, trusted_keys, usage));
 #endif
 
 #endif /* CONFIG_SYSTEM_DATA_VERIFICATION */
-- 
2.47.3

