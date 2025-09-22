Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D532E22BA
	for <linux-crypto@vger.kernel.org>; Mon, 22 Sep 2025 15:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758556428; cv=none; b=rYxzXFHNzaIdONKXIif7HlBhrD25J07J2ad/BGvtykWqxsDvPBWV8YJp/ZNUFiFklQTvW5/MqxRiUz9DlNK4K6S4BMMoigAj8ySX8DdCWN5g5ML2fZa1NzaCGxgXF2+je7kF9rxDm2wHGbuhIyTvugdmjbsvVxet+AdM1a+LKLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758556428; c=relaxed/simple;
	bh=xmpykvsefbZg4Z3d0+EhES58b/1383121uJSOrYR/s8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dy4lv32tlhVDZLgJl+7GZNwv/Hs18fseu8poZnmUwl63nNk9WY5LMhke2FIizfwj21y34PpcRfadfeZ2k1imW3+zDArdJagTYMV5ltbQ1vyc3gn1QXxAPsZB0h+gSOquJkC9aSKg3MnTp9W4DO+IsrOSAPxbwCJnL2bR5pw1rkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iL+zgoWg; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iL+zgoWg"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-26e68904f0eso24596105ad.0
        for <linux-crypto@vger.kernel.org>; Mon, 22 Sep 2025 08:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758556426; x=1759161226; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Q61xyED0iZHvT227a823myA5nC6Bd8yB77AGxFVjBQs=;
        b=iL+zgoWgN6zTX8jArXdOFpzYAiiPU2CQfKhPcEMUtVmH+8xWKGs+ftHIwq+TdcKHmm
         SCDeaBxoGfR6RIcEH5uHXTCS/Z6awE65ZDx/3LFgkKma0FNLQxT2SttGujckCvEwO/3c
         BsxGaqNdl0d6MTzEd10JHCfNbGgoJCZOh5a6ySYjfmMmH8KxNJYyZK1BepWjIEkeypZx
         kHczk+rfU5kmvgdOPu6IbuSdC+hunG+nuQ5RIn5TCzKZH1Qo9PHzM9zCyzngtT+MuVvs
         Fq1inofVb42mIPmqPKW2FEEcRKSl56ee8xUYoBfjNx0YJzJzZsSma9f2HkhpXdUx9/RP
         KciA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758556426; x=1759161226;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q61xyED0iZHvT227a823myA5nC6Bd8yB77AGxFVjBQs=;
        b=QudVBYhllvpdsBacstLPpO+2pV51Pu8ABehFaqXnFRODmL7dDSVExTnXW1J2EbSqFC
         hPisgFX3ZuT6+rKBWdHdFmH8SiSHhxJNDrV/Ftp8pi3goqtVtZum6GPDk9Gj/qiPXzLM
         vDCHtJzvCkdZ9EZB/XnTe/sQ+UVDwwza9XKSiWAwsvOfNDPWCn0lqVpvJyD9nrXnJPLo
         sT+eX+9G1mu+H0Jnvv/XWNKk6AWUBQ990bFznOThGgEgCCLco1ZA0NiBNc7kj+BAFtM9
         lfrBWIXLzKbCC4yja2YmNzeHbCg4NDauXE5Oh1ClbR7PMzgpAsyAQ0yXssyu/Ml9WuvE
         3bjA==
X-Forwarded-Encrypted: i=1; AJvYcCU6xRNTWLLDM8Q0Zl9lUCGLeI950U6fwLi9qXFkAbO8dez4Zpm2iKr/UHaJIz1ahq8V2PVQ3XIlY1BNxGw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTLLSH3ndys01ZAMhgRUjh17kWYcPAFmxP7i4edT5RRLchF7sz
	qHU9DNzsp8mIQQwXKlc22J4qE4NfFLT47mcw6Su+9xVU6jmZzvBfa3zp
X-Gm-Gg: ASbGnctchez/77C0nhQjoajV0YfQaJowvggI489xvZSmlcpzxmHgvluqv2ITCC8y9Ha
	59BFMiv6AxXxrbBbY+eSQoPCBBKK/cqeE94JMmO/9VWpE3Loy7WScL4MW0wbCZ5+eetyP9LfsFH
	wrFIyohEXRumZOZR+vDSSakf4uKuugTOFXtUKipooaXcwcJJVBIjLqcO8w9Qr+vevO54BIAobVf
	GctMm9xsjDtTuUaXX6VAFyZirADiKVvt9YEzXhCLgXjaqin399YoCipgPfYHuG+mQ7US17Wxkim
	cARghwa0rddjwqXvGVyA/pkLXQnuzf+lYHdtnHicoU3bi0jHpbZUWrcjywQX6fvzKDL5Ses9Uew
	WT7oSM2bsB7lXiE4FhRjI3Wrl
X-Google-Smtp-Source: AGHT+IGEGQomxsa7WNV0T03rhAK/xcvrrheXR+pMEm9N4EM2OSbc4zcfLSj+YjG8nGLLs8dfNA9reg==
X-Received: by 2002:a17:902:cec4:b0:275:2328:5d3e with SMTP id d9443c01a7336-275232861e2mr82210535ad.18.1758556426155;
        Mon, 22 Sep 2025 08:53:46 -0700 (PDT)
Received: from lgs.. ([2408:8418:1100:9530:3d9f:679e:4ddb:a104])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2698016bf96sm133924265ad.38.2025.09.22.08.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 08:53:45 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Victoria Milhoan (b42089)" <vicki.milhoan@freescale.com>,
	Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>,
	Dan Douglass <dan.douglass@nxp.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] crypto: caam: Add check for kcalloc() in test_len()
Date: Mon, 22 Sep 2025 23:53:22 +0800
Message-ID: <20250922155322.1825714-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As kcalloc() may fail, check its return value to avoid a NULL pointer
dereference when passing the buffer to rng->read().

Fixes: 2be0d806e25e ("crypto: caam - add a test for the RNG")
Cc: stable@vger.kernel.org
---
changelog:
v2:
- Return -ENOMEM directly on allocation failure.

Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/crypto/caam/caamrng.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index b3d14a7f4dd1..357860ee532c 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -182,6 +182,9 @@ static inline void test_len(struct hwrng *rng, size_t len, bool wait)
 
 	buf = kcalloc(CAAM_RNG_MAX_FIFO_STORE_SIZE, sizeof(u8), GFP_KERNEL);
 
+	if (!buf) {
+		return -ENOMEM;
+	}
 	while (len > 0) {
 		read_len = rng->read(rng, buf, len, wait);
 
-- 
2.43.0

