Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DF623ABB3;
	Mon, 30 Jun 2025 08:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751273857; cv=none; b=Su1ZIQ1uAGGx7yCLpzo5dRdVHyzITed18BMVVKisDXW7zwCPqpKF5ign3XgNzLlCM9JLbgbhz5je7DTBkeIeO9PZ2qKor1/DXqOZ4mGxMVAiGx4FyXRp0t4P4IiG6wJGEwchhRJYZF5zVZ6Gj948D1sjEjT6DfUVe9iYov71Sho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751273857; c=relaxed/simple;
	bh=APQjnfC0ho26CdR02Kmbiu4E9JMnLLbwfYZ7NNh8DYs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SZSJl8NaMene9URlR35XHuxw8oKwmcwO9BRhgwt8fcNrfUpez8WQzuu2XVIPx1R35sFAcGA/dD6bXB88NvvYr+YDX8Un9nDNLxljMUyfwkyaLLUAOPf7CyMwOBPDljiE+e0ihVSMgfVWPF9cxUAPQAKU6RCNpluRS3tndgur2kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dv/vKlEW; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dv/vKlEW"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3a4f64cdc2dso683307f8f.1;
        Mon, 30 Jun 2025 01:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751273854; x=1751878654; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=POF/lfjlBstPPmJqK/rxTYHM0xgWsKYRn8MW4p37XQs=;
        b=Dv/vKlEWT9/oquHFb5ZheJlDCP0WqB9NbF/sGP2Wz9ITsB0GcPGoW8W/OdyGBSDioa
         hYfnFggD3FmlzH9KUxaEfnWmuzWvwd8wAetYGZhhTmnmqlc1KAvR+HYXxO9BtAwzF02C
         3SnT+mVHlT7Qlr8zDKC8tQ4H7MQw2rWLmutY6sQ59ofaTjvps6acVqN0sZAA1V0vEXvQ
         1q+nef7KDJOUdPhx1kQM9WuhN1YcGu8nD0yQszWdDKerSscVwFVbmg2zWjbMPBsPJIR5
         bFxTLLQPxTOE1WcvKDS07uOc89Gp7HqNyJUKGYr2YJayahcnYXnfObbn+N8jAiplUqLM
         OYCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751273854; x=1751878654;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=POF/lfjlBstPPmJqK/rxTYHM0xgWsKYRn8MW4p37XQs=;
        b=byq87HAazaMhUVZIm7P6b8uCMFG2KhHFrsrTRD1Qpqj4G5g+4AAho7/QgLmDSZE5Eg
         WVOM6+I3VrCBkuAm1XoLIvKNTX3SBagrWlY750aJjKZzI9kMmghZuW7msTwFPZ+0XkWi
         v+SkkHr20inxm3K3dlpdt72OYIgAm85eF2bfPu47kkDn/hIyBwO/NoT/XNFsB8YlUAnr
         qrsz8jKWSgxVUZdZGlGbFJTAx3H9NPi4N41W5DG1Ze8zHduc4mh9x58OXT9KGrrzAb8r
         k9PY4A6FNK69SUFN47hV8iGrzZgH9qgEM3kcDlIOjP2Uu5QZVSW+5cH/cJiCytT8VLPW
         Ct0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVT3mrNeqbCPDQ0N1zVHN13k8FyOJMn0VPrBrRcLiU51h2IuDiCcnxKVgEitCy+H6XF5tgAnx+7ZZzJE0in@vger.kernel.org, AJvYcCXXD2Il9keOW5Bw6lMYLFybST1lR7jUqqxQ50L3jNL3bxZioaz2ySAS7deuhDqeXaLR887D35IAgswnvqU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRJFjYHItd0+Yp1iCkgvNXSC+bWZk6kgVBLAslSW7bM59OEsoN
	qP9hPhFv2Ntk+B5nvjkiaiwpCZM8VIpAItv7R0gzCNMI7VbNPXYyryfu
X-Gm-Gg: ASbGncvofkm3qs3ONfFKUQH5IN/qXvXAuWUzNgTfEep0VhnoqtFBxGnkQNyHvcEb7ss
	qBjHz46iKXCrUvDls4YXG5hkfOoM+qE8CB95MIlc7XOYZ/RSBQ8koAJB86KMbz4iM2ZQCFICR+i
	XmhDQcj0u/JZZiIY82NRQc33lTA/oyHKhAo9xgo4+1OIPJYDhwvtqBEn2z0+mqotK5ospbUc+YV
	TQ1owQYhCgCa6YmhxGDqKXpAWm5HX5btiAMTf2QoatSJbtzztX4Upcjp2vpHO3m/bnj4wl+cCZD
	y0JyXK1mq5Lu+f9aWRzHQo9l4XeLAEsyqsRWO4oNWGtad/w/AaNbaAwQRLoUm9yBuDKaeOAtnzS
	UbgjJeIT9jsaV0co=
X-Google-Smtp-Source: AGHT+IGlknY67astPqQ6Ts4eyHBJeWoLGAdmYYOyXUPQ5uMHairQGPegGqQwCezY1A48qiQrcuUVNw==
X-Received: by 2002:a05:6000:402b:b0:3a4:f912:86af with SMTP id ffacd0b85a97d-3aaf2e9231cmr2195341f8f.2.1751273853675;
        Mon, 30 Jun 2025 01:57:33 -0700 (PDT)
Received: from thomas-precision3591.imag.fr ([2001:660:5301:24:234c:3c9a:efe4:2b60])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4538a3fe587sm130162475e9.19.2025.06.30.01.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 01:57:33 -0700 (PDT)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
	Declan Murphy <declan.murphy@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Mark Gross <mgross@linux.intel.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: keembay: Fix dma_unmap_sg() nents value
Date: Mon, 30 Jun 2025 10:57:06 +0200
Message-ID: <20250630085707.62981-2-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The dma_unmap_sg() functions should be called with the same nents as the
dma_map_sg(), not the value the map function returned.

Fixes: 472b04444cd3 ("crypto: keembay - Add Keem Bay OCS HCU driver")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
index 95dc8979918d..8f9e21ced0fe 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
@@ -68,6 +68,7 @@ struct ocs_hcu_ctx {
  * @sg_data_total:  Total data in the SG list at any time.
  * @sg_data_offset: Offset into the data of the current individual SG node.
  * @sg_dma_nents:   Number of sg entries mapped in dma_list.
+ * @nents:          Number of entries in the scatterlist.
  */
 struct ocs_hcu_rctx {
 	struct ocs_hcu_dev	*hcu_dev;
@@ -91,6 +92,7 @@ struct ocs_hcu_rctx {
 	unsigned int		sg_data_total;
 	unsigned int		sg_data_offset;
 	unsigned int		sg_dma_nents;
+	unsigned int		nents;
 };
 
 /**
@@ -199,7 +201,7 @@ static void kmb_ocs_hcu_dma_cleanup(struct ahash_request *req,
 
 	/* Unmap req->src (if mapped). */
 	if (rctx->sg_dma_nents) {
-		dma_unmap_sg(dev, req->src, rctx->sg_dma_nents, DMA_TO_DEVICE);
+		dma_unmap_sg(dev, req->src, rctx->nents, DMA_TO_DEVICE);
 		rctx->sg_dma_nents = 0;
 	}
 
@@ -260,6 +262,10 @@ static int kmb_ocs_dma_prepare(struct ahash_request *req)
 			rc = -ENOMEM;
 			goto cleanup;
 		}
+
+		/* Save the value of nents to pass to dma_unmap_sg. */
+		rctx->nents = nents;
+
 		/*
 		 * The value returned by dma_map_sg() can be < nents; so update
 		 * nents accordingly.
-- 
2.43.0

