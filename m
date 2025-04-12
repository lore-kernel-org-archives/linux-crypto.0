Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6451C862C
	for <linux-crypto@vger.kernel.org>; Sat, 12 Apr 2025 10:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744455448; cv=none; b=LWCUSsWFwvIJzkPY6MFLP3AJnme7ug9xNjI3bgxu1tXlyPIk3/lZrq015wANEFcX09HV10HoT1d8shS3XKR9FBtLOmqlF4I9fZZqggGznankO90cpJ43IQzA6YcYSY54eQ2OM3xNUE/bOVciBJc12uMK6AuqF9VDtpTVA4uUfew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744455448; c=relaxed/simple;
	bh=eHVR8F0UTp3IPsqMzmr6mPV4bKAyskN46rLoTYI4TQo=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=EPU8tYcgWfe16STH+WqEGvjIOspGgkr9Fs5gKwRJ24WJATl1N/c0WcEn68b6/Vb61IpbOqlQ7f9qXM+xQkuhjKIX2bWpUiJ91vHcA4+uBl8Ass4yXGPMXcxXuUaXjcmjRb9eyHyWvEDrUho996viyGmIL8FVn+kD0M3UyU5b9pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Xy1yRggj; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Xy1yRggj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QQdViSvau3rnLMLkCUpEy2sGsdFMOTAKWHzpwAn5F8I=; b=Xy1yRggjvhYGEVX1eASesBXGuI
	TQIVd+HHCTpRcD9sbbjT9tXoqWCUWacwilfl3xhQZ8I4tmrhijjOiCU8kWVJRZjBguYCeh1hbaIWl
	XKdy1xukUSarRPjDUw5TfLs77BIo7NdPBa2+IeYeVe2E04Urc8Sv6jYPGMnMPEYm8a5rq+a3w91tM
	n0iMJ963C7hyNs/WBg/PLQYt2zjPH5qaOmsQXzeCppXAQITUTV8Bv0MXMOsTJ6C4U/RX3Q3PDeN2z
	AeTidxFBVoL4oQzhdrIwvbL9NpJOxJdZe/Tm1oEqf0T2gU0/plDxQ7sB3IKE9kNZEjwDLA8KkIGGH
	aChbOq5Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u3YY6-00F5Jg-0r;
	Sat, 12 Apr 2025 18:57:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 12 Apr 2025 18:57:22 +0800
Date: Sat, 12 Apr 2025 18:57:22 +0800
Message-Id: <4bba3cb4211287d472aeed04a5e0139081562a0c.1744455146.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744455146.git.herbert@gondor.apana.org.au>
References: <cover.1744455146.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/8] crypto: zynqmp-sha - Add locking
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The hardwrae is only capable of one hash at a time, so add a lock
to make sure that it isn't used concurrently.

Fixes: 7ecc3e34474b ("crypto: xilinx - Add Xilinx SHA3 driver")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/xilinx/zynqmp-sha.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/xilinx/zynqmp-sha.c b/drivers/crypto/xilinx/zynqmp-sha.c
index f66e0a4c1169..4db8c717906f 100644
--- a/drivers/crypto/xilinx/zynqmp-sha.c
+++ b/drivers/crypto/xilinx/zynqmp-sha.c
@@ -3,18 +3,19 @@
  * Xilinx ZynqMP SHA Driver.
  * Copyright (c) 2022 Xilinx Inc.
  */
-#include <linux/cacheflush.h>
 #include <crypto/hash.h>
 #include <crypto/internal/hash.h>
 #include <crypto/sha3.h>
-#include <linux/crypto.h>
+#include <linux/cacheflush.h>
+#include <linux/cleanup.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
+#include <linux/err.h>
 #include <linux/firmware/xlnx-zynqmp.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/spinlock.h>
 #include <linux/platform_device.h>
 
 #define ZYNQMP_DMA_BIT_MASK		32U
@@ -43,6 +44,8 @@ struct zynqmp_sha_desc_ctx {
 static dma_addr_t update_dma_addr, final_dma_addr;
 static char *ubuf, *fbuf;
 
+static DEFINE_SPINLOCK(zynqmp_sha_lock);
+
 static int zynqmp_sha_init_tfm(struct crypto_shash *hash)
 {
 	const char *fallback_driver_name = crypto_shash_alg_name(hash);
@@ -130,7 +133,8 @@ static int zynqmp_sha_export(struct shash_desc *desc, void *out)
 	return crypto_shash_export(&dctx->fbk_req, out);
 }
 
-static int zynqmp_sha_digest(struct shash_desc *desc, const u8 *data, unsigned int len, u8 *out)
+static int __zynqmp_sha_digest(struct shash_desc *desc, const u8 *data,
+			       unsigned int len, u8 *out)
 {
 	unsigned int remaining_len = len;
 	int update_size;
@@ -165,6 +169,12 @@ static int zynqmp_sha_digest(struct shash_desc *desc, const u8 *data, unsigned i
 	return ret;
 }
 
+static int zynqmp_sha_digest(struct shash_desc *desc, const u8 *data, unsigned int len, u8 *out)
+{
+	scoped_guard(spinlock_bh, &zynqmp_sha_lock)
+		return __zynqmp_sha_digest(desc, data, len, out);
+}
+
 static struct zynqmp_sha_drv_ctx sha3_drv_ctx = {
 	.sha3_384 = {
 		.init = zynqmp_sha_init,
-- 
2.39.5

