Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795780918;
	b=hFo4z/4xdCm09pKgTIYeupUay8FI2dzFumEup68D0XtgM7FkAa8XMOhRqUJfjQrS7URG
	 2fET+I1OcQT4nAL/xxQ0fmyiwVV/5oNt5blj4iei70K0Iz1LMVZez2jscC3TsCucgg5Ca
	 s7KjNgcTI5LEiciSdr/1SrRcbDWEoeK9DnS6SGrt0Dk/3seTMLQkJ6hB0STc2AR4pDG3r
	 zHqCfO+xO+KzDiDgiy7uh+4+nnlbRQogOlMRGm2nK6DfG+xHahY9WUUma8woIW+/mwdZh
	 flDsynQpztT6+QlvuL+YHSgxFbgH5voa0+FHiLj51gYogLhX5k2s9gBAdpe2wNPlbtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795780918;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=cyu2YD+0JiTqu9p5NWdi6X2hohcRvSGgQozAHaYtXMQ=;
	b=PCbCatbgDlf84rTbLn1Hw8Q6QF+MSomWIL57A5vFVQgl5nQelitLsSHniw8eUaktTqnF
	 VrWYq9Q7MirUBRnIFGxkOMEUNpoNEI6PMZiAEhvmqpOzi6FtbkdQMrtj5Muw9mgz1QK2B
	 lsdYPgZSKcxNam048eROoePxcasz6WA83WaymqkGD+kFUIt1BiL80lrRCz2IpcyoUA6as
	 JQ+jpHXPEkQ1PwGi5+ONd2IGsBSlekfzArCW4inRWaGFZQOx1tgOlpGv/hpecDh4Ehxnh
	 EaQ6rZvY2VdwgQb5IIA7W46eGpwo2J517nx7cBTxgD7H8/mHQYxog1DSXWrtqXAUXaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AL1VGL0h;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C09606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 12:01:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8C09606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AL1VGL0h
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4bba60271d7so24930165e9.2
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795780916; x=1796385716; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cyu2YD+0JiTqu9p5NWdi6X2hohcRvSGgQozAHaYtXMQ=;
        b=AL1VGL0hkPX75OCRXg0YznDdFMteUJOh/tMaD9S/64LQWYS2a+CpWhanRLTSpmft3l
         y6TaTfqMPYKe9XZOnZi3Mlq6DFqOfHDRvFXNJd9Ki9DmXbr/tqnUmEeUbomO+gh8fQXy
         TjOv8xBZSGb1Lzn40oRgWXFEMJUYCjEI4JxCsWnVWjUkqGf0WKB5Bio5++/gygZpBAvP
         MwWFHkc5ODtyrjNCMbSjUfbXv37gxDjCAVxYj1Xvm1kvJHPga5ktCi0aTw8uzkEc9UPC
         Cc+Y3pOctpK5xpjvcLO2DZ1npPGy5nGvfIo/emnZB4qhWcqI0BPR1C8UPAw0DyTlKpFy
         OBEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795780916; x=1796385716;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cyu2YD+0JiTqu9p5NWdi6X2hohcRvSGgQozAHaYtXMQ=;
        b=PePEtpWTXdDY4FjogXPcy4U+ZmQoC9Iwzo8woeyIol965FUVtqhvkCQKaY5sJ5ILVN
         riA7vkXgjmnqrc/FPuUZb+0d3bjHydO8MwqWgLcGJEHS0o+0KFAEWRLj5gS7DoFdMmwM
         8f5f/8jeVjFlp3AL5nWZ1RuHXj+mw5D2s2nCxXKY4SmuuS8UILr8cimVKiSLNDl/xLPC
         Ed7Du8kDVX0zt7IXEWuOhRlisWxYEtTUJn434vPRLgxFvxecVRmARRxkmDpEKyGiMyEp
         F/HGmPap01Fj8u1QdXerIA6PyllLoTo4nnqOHErQLOPlN+xpr8zMEfQBJuI4TQaP2UNg
         P6tw==
X-Gm-Message-State: APuU4Z+WYlt3GtRa3Uw+vrGyECDBEuw5VNuyzYqru9tKQ/468IHyC3Ad
	fXFZMVae925B1ED/7VMMiZfrBx64X06l8BlJsl7eS7J8/H1194eTOAqT
X-Gm-Gg: AZFdTZeUYJwMWtkZpPuSBYzD3U3k64+wQvB+t5MzKHI4GS2nkysKc3pvsReBg9KIIsM
	8L9pgdAKo8xqzd1sbbGGOncR9+pzuvB2/GLUzz7WAIuJxhmqrQXfYPePUL6aycE9JYjcchUKTuf
	ywhK3qtbN/lXgUTLLQQLP+VwciFGKqP4HxHsc/SWDvbV2Hdkug3Phox2Qu2uF4FdbweR0CJGkSa
	yfGhxwUnVVacRf4HrVKibZFuN4Ky9k06kApxRmZlscI6mPE0lY8gN7De2bg14FzDjh6xNZ6cRQP
	nRGsZjmRfFPP28zDbif+LeIHPfnVRXYjtO4WqpUUtWGoRZiOMi1fjy+tdeELuavgkpvVmlNBylc
	92JyZrzaatb4/w4HYQ1NpmRbtr3+tOmwvkKfBkXKC8ZH7Nh1KvIui0wrb5djPYrWL7moqkQl8I/
	iu2E8qLROKE1xhTKC+FX03WFQc5veRJ1Hq2pETcFiX3eAKAGTTKO9PI4+y9GezWgVIVtVRPJKoF
	cX89IsQUu0xgpt634QVhV4UonBnNml3V2+pUZUfzKekQ9xPYtV20TWzNgkVUP2MFyfw6k2HC/1L
	i7mLXYLS8jcFG0kGItWnV+Dgjt5k7E7KZCbdDEXFiW+8fpQ=
X-Received: by 2002:a05:600c:848d:b0:4bb:6687:5386 with SMTP id 5b1f17b1804b1-4bb8880c7f1mr517059715e9.19.1795780916248;
        Fri, 27 Nov 2026 04:01:56 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906640a2sm393684565e9.0.2026.11.27.04.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 04:01:55 -0800 (PST)
From: Jose Nieto <jnieto.alaber@gmail.com>
To: Corentin Labbe <clabbe@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	devicetree@vger.kernel.org,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jose Nieto <jnieto.alaber@gmail.com>
Subject: [PATCH v14 20/30] crypto: amlogic: drop unused field and stale includes
Date: Fri, 27 Nov 2026 13:00:53 +0100
Message-ID: <20261127120103.1532882-21-jnieto.alaber@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261127120103.1532882-1-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-1-jnieto.alaber@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the unused meson_flow.keylen field, drop unused includes in the
cipher and core files, and fix stale kernel-doc field names.

Signed-off-by: Jose Nieto <jnieto.alaber@gmail.com>
---
 drivers/crypto/amlogic/amlogic-gxl-cipher.c |  3 ---
 drivers/crypto/amlogic/amlogic-gxl-core.c   |  2 --
 drivers/crypto/amlogic/amlogic-gxl.h        | 10 +++-------
 3 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index 72892fdcd55d..c11ccbaf920d 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -9,9 +9,6 @@
  */
 
 #include <linux/crypto.h>
-#include <linux/delay.h>
-#include <linux/io.h>
-#include <crypto/scatterwalk.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
 #include <crypto/internal/skcipher.h>
diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 38b9645386ae..8ce3f6640753 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -19,9 +19,7 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
-#include <crypto/internal/skcipher.h>
 #include <crypto/internal/hash.h>
-#include <linux/dma-mapping.h>
 
 #include "amlogic-gxl.h"
 
diff --git a/drivers/crypto/amlogic/amlogic-gxl.h b/drivers/crypto/amlogic/amlogic-gxl.h
index 3f1ce6c05558..9c3df0d162b9 100644
--- a/drivers/crypto/amlogic/amlogic-gxl.h
+++ b/drivers/crypto/amlogic/amlogic-gxl.h
@@ -69,18 +69,16 @@ struct meson_desc {
 /*
  * struct meson_flow - Information used by each flow
  * @engine:	ptr to the crypto_engine for this flow
- * @keylen:	keylen for this flow operation
  * @complete:	completion for the current task on this flow
  * @irq:	IRQ number for amlogic-crypto
  * @t_phy:	Physical address of task
- * @tl:		pointer to the current ce_task for this flow
+ * @tl:		pointer to the current descriptor for this flow
  * @stat_req:	number of request done by this flow
  */
 struct meson_flow {
 	struct crypto_engine *engine;
 	struct completion complete;
 	int irq;
-	unsigned int keylen;
 	dma_addr_t t_phy;
 	struct meson_desc *tl;
 #ifdef CONFIG_CRYPTO_DEV_AMLOGIC_GXL_DEBUG
@@ -90,8 +88,8 @@ struct meson_flow {
 
 /*
  * struct meson_pdata - SoC series dependent data.
- * @reg_descs:	offset to descriptors register
- * @reg_status:	offset to status register
+ * @descs_reg:	offset to descriptors register
+ * @status_reg:	offset to status register
  * @setup_desc_cnt:	number of setup descriptor to configure.
  * @hasher_supported:	indecates whether hasher is supported.
  * @support_192bit_key:	indicates whether platform support AES 192-bit key
@@ -112,7 +110,6 @@ struct meson_pdata {
  * @flow:	flow to use in next request
  * @flow_cnt:	flow count for amlogic-crypto
  * @dbgfs_dir:	Debugfs dentry for statistic directory
- * @dbgfs_stats: Debugfs dentry for statistic counters
  */
 struct meson_dev {
 	void __iomem *base;
@@ -181,7 +178,6 @@ struct meson_hasher_req_ctx {
 
 /*
  * struct meson_hasher_tfm_ctx - context for a hasher TFM
- * @enginectx:		crypto_engine used by this TFM
  * @mc:			pointer to the private data of driver handling this TFM
  */
 struct meson_hasher_tfm_ctx {
-- 
2.47.3

