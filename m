Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA16E13BC12;
	Thu, 26 Dec 2024 16:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735229709; cv=none; b=un62GmLl4Mjgu1Ow7odJL89mB2TG7XF4Szvthc8nDugT03tPbP010Q7IlRkgefXeO3XMOEBV2xCby8zk/4Q94WjSJPtNxSL5UYPhpHAUvoIvZ9cCbyoF4fmmEbv/SLtiVX82k9NJHr6ezyPc2gqh1ri/rOyf20KNBWWKTtC1+Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735229709; c=relaxed/simple;
	bh=BH5VJ6xRMV8OgkbR8bPj678AN59uWPq7mfDWL9agGFY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pYq5zTbsJaLakcyDBQpeu0lb955EOaz5Q4XzzLEs1qhLGdNVQR2YgmObZm+MIZRUUEKqB4RKDPGIpJYxes3pURUpm4aRCzNlYQqOsBqe1BzcTdqZYS66KmZPZzLONEZoYV9GvyMwcEPqVKtDnlqaqc7BNw5kiWkeJkYRI5b2WKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l04oYBFE; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l04oYBFE"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-216401de828so73334025ad.3;
        Thu, 26 Dec 2024 08:15:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735229707; x=1735834507; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XW+Oa9etVbT8zCmzbvofACDuKgHXN6Rn8NRNfW3boyo=;
        b=l04oYBFEUBAtDEyAVSTAt9dSIXsfY4GEYaCX+7CJsCQg6R7DumA9X6wVN8o8SJuL5i
         J7YI93ZbbRLiQoXL9x+mCx50BddnFUdMu9dd7EjdyNCQ6dH1nThMqw64ds5SB1AmIGzg
         g4CGA+uMDKG1KblzQvZGyCSTJaEbK06xIhDEoy4sQkNZ+g7Wva0lq02fppZuJwFApKcj
         rJZMRC1EA0WQ6UqmOBVPOxy0Z1Oo8Znm4O8cKLP/JiZqGZo5NFdRHsXSSJ+j+91Jaxzj
         rVqd6RibSAAKg3npdzJr1+rK3j23BiFCfTxIvGsQbSGDA7j5yaGNxSQDxxZvATk7POlj
         LjpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735229707; x=1735834507;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XW+Oa9etVbT8zCmzbvofACDuKgHXN6Rn8NRNfW3boyo=;
        b=Gxf5rR1ikbpYONhPDSnPaA8uK78Nfg8+XaEF+51sdtqt+2cn6VqLVLZeGd2pIikUv7
         rv6htRtgYCDTJJwPohU43H6YLn6Mx1yZv54IyI9S35XSbzhJ29H91wlGek/uJjtFTq00
         Zozx9i6kBGMaYoxaDIyO/91YpwPDcGd6EbI+n+iPfGWu4WPr6D3PWrRsXls4BHUxZO7l
         xWSoTzM+z4GBtl/IUEekJmGm+c8HQlpIqUj73diSTg5nXrsPuZtSihfhalN+yec1qNOa
         31CMwn5+BuYimhdMidV95VSsM+BiDI4NdmefrjZoEtJsAAwbcOCwDJEgkGd0dixLNkcB
         icbw==
X-Forwarded-Encrypted: i=1; AJvYcCUkq4xdGMaxj1zcYHqflsm2ffKCJn+VkzxMeqmRlJSAF6lBX8KgkI85ggHf9Pfk4MLogZFSrpngH716jhMr@vger.kernel.org, AJvYcCUx578XpRpUaLGespSp6Fjxn2GYuFvyO437u7Q026QocN7mpZBIsFX6cbB/n/+8yQa24uqEg/Ki/oJSYfU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFzmjNjSGRJ9zyT81WmtHItuV730KPs8gEH4rW8yNxja5jykuy
	fWejvZAHtvjz/1T0kxl5ET9FKeA1jqhMXQkzPkyCgyy1nzrcj8RU+IwHfg==
X-Gm-Gg: ASbGncss4aIYcauCA7aI1g2Aa92V2pNVW5vl707FEJMAWumwAmDHPVnD/k/6jj40qCL
	r8eKuDrghZ+brT1bae/D4mmewptImMvrI4Wp/AthSBSWaRxuXt74isK8TXrFPKfkNrATKbbAFFk
	6WunwbnPxxYRQGQPX8k7KQr9sJc6RCRVjVklwtxS70hgt67K3OeoIdPfHI3+k756KxNR4sILUJp
	YMm3BHFxV3CW9+Y13UcQ6FCrKg2UhfQwGF9AXmMtPMkp6marAFDuk1qYxo8C4NSiRUdm88zRQ==
X-Google-Smtp-Source: AGHT+IFg3C0velaK8fDViStqrQydm2t/KMu6OTOmBZiAogFwwesGNOjJaw4rf7PB8YJlmxRF6h+QfQ==
X-Received: by 2002:a05:6a20:c705:b0:1e1:9fef:e96a with SMTP id adf61e73a8af0-1e5e044b029mr34396380637.6.1735229707033;
        Thu, 26 Dec 2024 08:15:07 -0800 (PST)
Received: from localhost.localdomain ([2401:4900:5ace:1ff:25be:40b4:c34c:ca2d])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-842b8e87deasm12024037a12.45.2024.12.26.08.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2024 08:15:06 -0800 (PST)
From: Atharva Tiwari <evepolonium@gmail.com>
To: 
Cc: evepolonium@gmail.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: vmac - Fix misalignment issue during vmac_update
Date: Thu, 26 Dec 2024 21:44:56 +0530
Message-Id: <20241226161456.191215-1-evepolonium@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The `vmac_update` function previously assumed that `p` was aligned,
which could lead to misaligned memory accesses when processing blocks.
This patch resolves the issue by, 
introducing a temporary buffer to ensure alignment.

Changes include:
- Allocating a temporary buffer (`__le64 *data`) to store aligned blocks.
- Using `get_unaligned_le64` to safely read data into the temporary buffer.
- Iteratively processing blocks with the `vhash_blocks` function.
- Properly freeing the allocated temporary buffer after processing.

Signed-off-by: Atharva Tiwari <evepolonium@gmail.com>
---
 crypto/vmac.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/crypto/vmac.c b/crypto/vmac.c
index 2ea384645ecf..513fbd5bc581 100644
--- a/crypto/vmac.c
+++ b/crypto/vmac.c
@@ -518,9 +518,19 @@ static int vmac_update(struct shash_desc *desc, const u8 *p, unsigned int len)
 
 	if (len >= VMAC_NHBYTES) {
 		n = round_down(len, VMAC_NHBYTES);
-		/* TODO: 'p' may be misaligned here */
-		vhash_blocks(tctx, dctx, (const __le64 *)p, n / VMAC_NHBYTES);
-		p += n;
+		const u8 *end = p + n;
+		const uint16_t num_blocks = VMAC_NHBYTES/sizeof(__le64);
+		__le64 *data = kmalloc(num_blocks * sizeof(__le64), GFP_KERNEL);
+
+		while (p < end) {
+			for (unsigned short i = 0; i < num_blocks; i++) {
+				data[i] = get_unaligned_le64(p + i * sizeof(__le64));
+			}
+
+			vhash_blocks(tctx, dctx, data, 1);
+			p += VMAC_NHBYTES;
+		}
+		kfree(data);
 		len -= n;
 	}
 
-- 
2.39.5

