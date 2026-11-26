Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795721615;
	b=dPAqrpjoq1F+5jSvdXDs2Uatm75Mo9epV9dd2tM2Z8zP4gXDFqZt+PL2JiH48e95FSG6
	 v4fMs5Ce9bFZ2+vmB3WEBrsSv2pJxx0Ve6TEPwHfyEgQ1vBeIpoB/VTd8UMUcB/IA720E
	 B9+rgJ8qnSNe9A9OA1YtXSbGA6u3QjUmH0mSLoFQ/T0ODL5m0g4mlWcGlxNXqrMdYVb2N
	 CM2ZjHSDiVPO+ceTvXEvTJhD7uYCyvOGRr7uyDh2RGiBLEIm7Q0SkP5+NUO4hXDCVwt68
	 bPMwUo8Xu5XbZwqFwzdNJRV9y4wD/e5apA+6kaEIFzVTGxT0RnDGc0MHFdPeeQcYUng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795721615;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=IrCPEDuRLj9X86b6iS7crxRsYz+wud1Y8dJ9yChy4/Q=;
	b=0a56qOwz2XInawk+vweLzOhghUGH4h3anX5+xTvsdm/fWI1+xLEo5LYHjqXCORPmTicH
	 U4Zdufa0qcHXhHZUeO6pzRnr4DJ6GYz99v5LTCoRzQy69Zo4Uji2pzWl4mzkqpMQbwY9C
	 gQwDsVE7ScP1UgiXULFTJtsUOI+Jh5KXowAhYH0iCSwfl0+NHZDdMq7JVbt3oW1K6wuMV
	 ch2d5+FMPQ1cwC631PNWWcIQUPUFK5WLGshb5+wjaczbJFcc5Za8R3+PN4KHciMS7qaxQ
	 psap8D3lIIaNNYyWgP/kjE4W3FuqPit/6k7M0infHVbDj/5uYYnJyk2iTuVUyRKeUgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vJ1FmaFp;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4AE0606A326
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 19:33:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4AE0606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vJ1FmaFp
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a35a60499eso57794815e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 11:33:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795721613; x=1796326413; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IrCPEDuRLj9X86b6iS7crxRsYz+wud1Y8dJ9yChy4/Q=;
        b=vJ1FmaFpnk118PCeq96TN+1PXccFqapM5JM4d5ZsDDKMoVoTC7cSr6ILqP3LoD795o
         w727Mu7VRyVjnihbwMM7xdYkoNDicyLqz5ELci3GerL5LeT7WQbxQL8bH+0BXT3oVTup
         INB3r6otoR9HN7dEupRQ657nIZGuAGCxaJmrdhJ00/EoZMBHAtSmVM+f1K87Ao8jPXTX
         rshd/VULn0zJCv3vLCef6u0B/EBKKFP/7z75EDPlh5TXcmYUZFf1VFud1QY+AglBXKho
         kxLu+RKZ681XnSPOtQs6hF6V7iyUENarjZLdCHCAJh4+bTkumEo9+ajccFl1l8Mtt/MX
         WRDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795721613; x=1796326413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IrCPEDuRLj9X86b6iS7crxRsYz+wud1Y8dJ9yChy4/Q=;
        b=zYdsKeR6+DFqk96lUxUfGQTbSLFn4dhnfwOukLmW+D4L/k5bAtWiiOMx8z6A9nCBUT
         +zCiSl0etDrHr4Ai08TX06G0DDtvm3UfLFrzMwCIJlAQulxRhlSDFKxslFtb7Vb2Sboa
         mxuKJVq8uuaOU1NRiLfuTlezGURwpZG6I1+Gej0qJUcvAfvj2rUeZTRQBMgcwdexy/zp
         bnxxzkyqBYUCHPBs6uJ1frv+1PtjeDLbGMCbdJXwkLjIJEBTWyYyTFSnluN681KH3YtU
         Fi/BkSNoWSWP0+uYks7mUFdvCGvOnpVZRCGSj4M3J2HA2mZg5AtAZMdnVBy1d+t2Cr02
         +vvQ==
X-Gm-Message-State: APuU4Z/8bT7Y/5GPGlF7EQ0N56sQ0Dq/Xk4yeId0JvsVDIF4dPaW/zgZ
	oi18UPGMH9IbObndVOzWQlWQwuU+f5g4QK10f2ucQPUMDVs5pyJcuUPj
X-Gm-Gg: AZFdTZcXTIRB2vjjJiPMZcUROgGFEXXJxFnxIJjT2Ocu726PFfXkj49v7YxDzIYXHCC
	H0iS0CQ3E1C3vOkdJreK/YuVAsBZwfESWtY4al6oV5iyeLg0KP7rwdugAix/SiCJWq2I2xKUezC
	N06L8d1t3QeGuKDVOx0nvvPFgU9HjbW7DrLhxuAJNIcms77APQnicY1OJpmpqJ6MIGkF8WHsFFt
	HbjIdVknm4Rz/yCacse4SgAyqvsLBykae1pxYpoT3yCm7hQfOXT3CTbu0fZrKw/uzKbBPrMahwg
	BNB0c+rSwsRzQiw5wf0ZHfnGVROXxNBnOtaD0RV4xR/LrVJ8bG8NMbntfkjCs/b8iOFsZTNB7Dd
	bt44fm/A4j+AQquXf60b8PF/OwonswSQTwoy6kh8u1RetY6fwCo0T3JAe5WFiOs6MeyssZ54PMn
	y5CiJAHb9Zpnlgb/LNhUidghMKU41fzGwp2R9vvpqUl4wmS25QeK2jTrKHdG0eaZIxrUovNHvu8
	hSepUBeQhyORb5oHN/RaYbOFNMLYFShicEGBkHGsfpFrWTz1FogLrxAWj0qh55yGoLmu02MkQJN
	2t13gX23CuRysLP46KTZU9GuCF90Ki2mUFsjCJBjoZms6SiT/CvI1RDyr4azGSg2Osk=
X-Received: by 2002:a05:600c:4f4c:b0:4bb:8503:69f4 with SMTP id 5b1f17b1804b1-4bb888097a2mr548704265e9.5.1795721612906;
        Thu, 26 Nov 2026 11:33:32 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm368287675e9.2.2026.11.26.11.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 11:33:32 -0800 (PST)
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
Subject: [PATCH v13 20/25] crypto: amlogic: drop unused field and stale includes
Date: Thu, 26 Nov 2026 20:32:36 +0100
Message-ID: <20261126193241.1471372-21-jnieto.alaber@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
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
index e79175368d8c..90c817e412ad 100644
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

