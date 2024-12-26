Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07C735280;
	Thu, 26 Dec 2024 17:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735232460; cv=none; b=DIrtc9NAskMN5BcuBP0Jh9QnyXFYzffv0emYvLmYTxazR0kviZsYXk3WixDXhTi3VwmFF57CJkLs3IwHltNx9LXDOaBLrexFZcON9kl0iFEQA1g8Hhz7zatGOaSSxnjNC5AhsYZV7R4/U173OQFOo9/Lv23+W2NTan+KE5R7RMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735232460; c=relaxed/simple;
	bh=BH5VJ6xRMV8OgkbR8bPj678AN59uWPq7mfDWL9agGFY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sY+wWHwUhjgEAmmykbwfsTtIMKMEVVz5w6PyPT29RKxkOzIzkWkLBLbgWZXOAThUDEey0olLzJ61OHQsbXIgJmzibk7PwX3gyB4kbZJ+OBX3Y85x1RZckExi3F0UsLOcqdYBww4+dzgmGRwegGzK2wnkgVtswoi3HCIvwiQ6uUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I1Jz8efh; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I1Jz8efh"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2ee86a1a92dso6134391a91.1;
        Thu, 26 Dec 2024 09:00:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735232458; x=1735837258; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XW+Oa9etVbT8zCmzbvofACDuKgHXN6Rn8NRNfW3boyo=;
        b=I1Jz8efhN0d+vbILpyUYPNRhDSdeIpx5C/YRKCcIqQbiBumGr2uZnFaFDFtNvBCHTL
         +++/POkgQo9BrQHvbphVVUBo/B3Wu90bnThkBihsFUSbZGuu9IP4mkkWZvV9lT/QTG3V
         6yUUgui16sABXAgcImwc4ChSfix6edE/YZ6Z68RGKtIic2wAxXxnUGeEb7WyKz3Chjr4
         C6D0g4wQRxtcwupIt3kdzyBiyLXLJIckCh/bH36/rI8+wZbw3dIAiUxb3XNWScLcAaB7
         hrZ0eLjwWtg8/iZOWbCue+mf59VoHIIgvWby2LhMNBPxGXi4ikE5xGytUyjaS3xQTGrC
         /X0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735232458; x=1735837258;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XW+Oa9etVbT8zCmzbvofACDuKgHXN6Rn8NRNfW3boyo=;
        b=Y2Vq7Rmv4FoCbCql2WPswCvr8LHVkic1OTzZce8mkG5TrRGFoTcO3e5iG3FrgEtyO7
         rIkqrbd+8Xg/YUyKwi0+Nkzd29MSBcQwORmR+f83A9CbtV9Ak/reWTZiF0xzwQzrJpxV
         mDYVDJIeAfSWW7gjc/9pb8UB82ObLfr7gMljE1bJ42gfKLMyH6B78bstvnRTpq+YIjKs
         C7WQc8mo8P4daE/rk1aAJ8nzLhOyVpwcgrPRaXzoNWJ3cFOQWMQMFpgmjy25TCT8hAOu
         y0G8jlURMe+zLKivfjaabjcFehxbD2CPy8H02JIupky8ZOJsV7cydLO+eC1613XXAbMY
         lNKg==
X-Forwarded-Encrypted: i=1; AJvYcCVU9uCKIXn/i+H+sVyM0jd7L4MzzRI/tIz0RVT6jTA+/YThcW+dQtngUBM4FUIYAVPQN+eact4KtxstLihY@vger.kernel.org, AJvYcCWSjrx/7cphKVWWeDokd1U0vKJe0aVF3MrEOgtyqH+5O9zPBrlmb9DW289vqQ/wwbA2YcfS5YI6rwKLaro=@vger.kernel.org
X-Gm-Message-State: AOJu0YxN4EPP0Sg9KImGuxGVaEk+n5Jy94l2oB3rXcXqIea3YN/T8rbv
	XUkN6FA46Kkd732mhLXnZk7kMKIbkEw6BHLAiye0asLTyyGWnCw5
X-Gm-Gg: ASbGncuuCwJldpMwL0A8GdnjImgoNONjmfFVpRjvr3+erhbpNBGcnc6yDHrm99G4bd5
	/8bajAl81jiruPSAQb8glPn8wDi+yaPLiyXlxEYw1iAyQA9e9WiC2sFS7yHHyCwUhWORRVXcLu5
	7NtsqQGag0LA2uPzydFJK2+Qk2nVXwPqxnGwXDWrZodthlN7OycZAU2LYZAAWmQZQYVCQmBfaxQ
	m9wFJR1n/aOBF2Kd1ZdPyys5bhJWVCzMQiuxQL89W5JzhVNHXLGINGil+9bc9+I9V8Fgq8qjQ==
X-Google-Smtp-Source: AGHT+IGrGbn4aTAy6mETUPZgaXogAfRkV1eWwMfDRgW545Ifay4Yq/WsOzBOVu/KQvzB9jK97xQ3Eg==
X-Received: by 2002:a17:90b:2c84:b0:2ee:e113:815d with SMTP id 98e67ed59e1d1-2f452dfce88mr39619877a91.8.1735232457962;
        Thu, 26 Dec 2024 09:00:57 -0800 (PST)
Received: from localhost.localdomain ([2401:4900:5ace:1ff:47af:c962:c802:7568])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc96eac6sm122393175ad.80.2024.12.26.09.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2024 09:00:57 -0800 (PST)
From: Atharva Tiwari <evepolonium@gmail.com>
To: 
Cc: evepolonium@gmail.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: vmac - Handle unaligned input in vmac_update
Date: Thu, 26 Dec 2024 22:30:49 +0530
Message-Id: <20241226170049.1526-1-evepolonium@gmail.com>
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

