Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285FE2FC879
	for <linux-crypto@vger.kernel.org>; Wed,  8 Oct 2025 15:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759938430; cv=none; b=qn42r9gOFhm/K/qb02wl4n6MEzczSNTCgAm9Q48hO2sH+WUQMqCaQIQs0sSNFM4W+1Q/MoegIqjdM03UY34qao0tEjeEjQWo7Yujm8MEQb+h9mjDSxS1W52GAbfnSVobekXFS6noXByBGj8JeEQZn0kwNW66f8zEOVucsijq5xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759938430; c=relaxed/simple;
	bh=T2a3v4NeDZkwfqj85MbBcAieCeChFKaNVae0DBFB4FA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XIMlBN7rOEy+Yus0KvcfG/n9l/xVXL92JzXvInDT47tm8ExqKuhTTzTGPTzTGoC+OgPTsGf96iNPrPfpCwYy1X4jt/jLq6GdrZc1VymFTrqSak0bgefhuV6JtXTsxXkwD4aZIcKJrBQOQYw8XPOP2vGsfU8DxJpNgeTq1JP/qpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BySEllG6; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BySEllG6"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46e2c11b94cso43144445e9.3
        for <linux-crypto@vger.kernel.org>; Wed, 08 Oct 2025 08:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759938426; x=1760543226; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XyDqe41TOpzGrced2VguyWuuhzoYjsOPlRjpRYq84qU=;
        b=BySEllG6wojB+KZsMULQMHRXoFN4DXyJU68ZCAFMYCafvtg2Wj6W89tuOfZep6bDhT
         9HwCRChfqn/SCZRqPRbQ3q9/trngZw6xtk2NVRtPnhfCKUHrQvJTf8gWmF1mRD+yKW75
         GrQUaZiCremDtp3ZyKD+ZDTtM66w8JumHL6strMkxp7TlhgDY4DjG5QeI4l1b0ufY5fn
         f1A0kl7t9wbu2zUoyt1BoXZNAlZ6WS0pHOUZP8u93cccxACo3uQHcre17YTqmDoOuCpY
         JiJN1ShCk021hRcBGQl2+w08vPjxeRyZrORUvkQyLdqlQT0JOeEAwQouYs8vKKOZO0NX
         zjWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759938426; x=1760543226;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XyDqe41TOpzGrced2VguyWuuhzoYjsOPlRjpRYq84qU=;
        b=wqb4qbdx96PtsN8dSNxbeHuenIRw2eoe3F5s9UpFkS8xHcqKVpcMMAcQJLyRCS8uDZ
         mr1S5RV24gE09Nc6tVKJxS3iK1ku+Wab0FfHNrQSboijttQgazyYc1ydxfLhD03wz4vu
         7RjucDiKAmx+GEOOYGTH6K3LyIzk7+jMS3VBggU3YeMTzAXKRMSz5aDk5f9/wGq7LsI1
         78KRn/mr1R2AMFiq25H4tvCJCmASRe8bRHnx3+02huzIGqrSwrxrWqt9nwa69GbHhf8H
         mD1gT+vlclhw5qRInUkmOkm6Vimcd1hWM2atI5xBr9vjchxzlIMq7LMTI713TcOqrELR
         TPqg==
X-Forwarded-Encrypted: i=1; AJvYcCX1LrvP46my8bMQ8a4z5dI0xvioSOwi+6wvBkiWBmu4H4LE9RroDcwScZPbaAq9Al4ofVxiYYGJG9rDqL8=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywxa1xJguYbH27vR5TyhkbGEAChQ3s54igGvsj1TM+NT7eHAKoQ
	OudibVDpsBmsPyDy90Vy4VgeNoESuNE9oo1q8aU4gbVd07e+Ttjdf3zlaIMpXmIHTGYnBbB/2g=
	=
X-Google-Smtp-Source: AGHT+IGd+xyyENe4mDMwHsq1XM4LCrOZp0Y90ZGldhJ1LzDJeD7pXJXrRWavBZZTJfyTw+krJ8EAav3c
X-Received: from wmjs21.prod.google.com ([2002:a7b:c395:0:b0:46f:aafc:e6d4])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c4a8:b0:46e:4921:9443
 with SMTP id 5b1f17b1804b1-46fa9b1b277mr26777065e9.37.1759938426503; Wed, 08
 Oct 2025 08:47:06 -0700 (PDT)
Date: Wed,  8 Oct 2025 17:45:53 +0200
In-Reply-To: <20251008154533.3089255-23-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251008154533.3089255-23-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1762; i=ardb@kernel.org;
 h=from:subject; bh=LscVi7axqbts3F3wdJxDdLq4C5QXUNo3h535UnzCneo=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeNZe/By5YdKnzyPLFhZtfvlkqQJPIGL7q0zd1kx5X1Om
 6tMZcC8jlIWBjEuBlkxRRaB2X/f7Tw9UarWeZYszBxWJpAhDFycAjCRGUEM/0Mi6397J6ztaDx5
 4LfWJuaoVCufzUVPp960Sz/e4/wj6h4jw8XefzPlvzT+lC6UnnrnMc+9e7+mPeQ7s8nt6e9pZ/O Zr/MAAA==
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251008154533.3089255-42-ardb+git@google.com>
Subject: [PATCH v3 19/21] net/mlx5: Switch to more abstract scoped ksimd guard
 API on arm64
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, ebiggers@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Instead of calling kernel_neon_begin/end directly, switch to the scoped
guard API which encapsulates those calls. This is needed because the
prototypes of those APIs are going to be modified and will require a
kernel mode FP/SIMD buffer to be provided, which the scoped guard API
will do transparently.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/wc.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wc.c b/drivers/net/ethernet/mellanox/mlx5/core/wc.c
index c281153bd411..815a7c97d6b0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/wc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/wc.c
@@ -9,6 +9,7 @@
 
 #if IS_ENABLED(CONFIG_KERNEL_MODE_NEON) && IS_ENABLED(CONFIG_ARM64)
 #include <asm/neon.h>
+#include <asm/simd.h>
 #endif
 
 #define TEST_WC_NUM_WQES 255
@@ -264,15 +265,15 @@ static void mlx5_iowrite64_copy(struct mlx5_wc_sq *sq, __be32 mmio_wqe[16],
 {
 #if IS_ENABLED(CONFIG_KERNEL_MODE_NEON) && IS_ENABLED(CONFIG_ARM64)
 	if (cpu_has_neon()) {
-		kernel_neon_begin();
-		asm volatile
-		(".arch_extension simd;\n\t"
-		"ld1 {v0.16b, v1.16b, v2.16b, v3.16b}, [%0]\n\t"
-		"st1 {v0.16b, v1.16b, v2.16b, v3.16b}, [%1]"
-		:
-		: "r"(mmio_wqe), "r"(sq->bfreg.map + offset)
-		: "memory", "v0", "v1", "v2", "v3");
-		kernel_neon_end();
+		scoped_ksimd() {
+			asm volatile(
+				".arch_extension simd\n\t"
+				"ld1 {v0.16b, v1.16b, v2.16b, v3.16b}, [%0]\n\t"
+				"st1 {v0.16b, v1.16b, v2.16b, v3.16b}, [%1]"
+				:
+				: "r"(mmio_wqe), "r"(sq->bfreg.map + offset)
+				: "memory", "v0", "v1", "v2", "v3");
+		}
 		return;
 	}
 #endif
-- 
2.51.0.710.ga91ca5db03-goog

