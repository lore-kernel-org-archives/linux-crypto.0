Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A842C2DECCC
	for <linux-crypto@vger.kernel.org>; Thu, 18 Dec 2025 10:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766052886; cv=none; b=aNTwgNmE33ewhPnmLZQDy51zFnWXChFafXAi9FhqqBr7tpIBTKavWJ3xvSEznAWKlVvFhfuzRUbKzmj+DlgBYpDEGrpxw70MMC816YQ0yDcwaV4LbxP38KOtQgIuKKCXc5xCbzidQirk+F2XMTbjF/UEoYzZsRGzwq/W7hDrFW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766052886; c=relaxed/simple;
	bh=/LQwIN5wlDT3DeC5MfHp3EzOwAe5nS+RTb7aby2JQAA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bT6j+gu7S0PcPGNlHVu1vsmT/KV5od9HphN7UO83mMTLCySgmTFOlQS9B7qKSB7hi3njBJf2AnI3qWQK1bjajUaMqQ4bv8niLCA5VhikXgKpmobDzrxCOfDOPEVKoYlDLGQ1RxxUXXExSzU1THtz1PP8KbyMsCnNfKRJZtyQtLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MgVp4Jwl; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MgVp4Jwl"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-42fb8aa0c3eso57407f8f.3
        for <linux-crypto@vger.kernel.org>; Thu, 18 Dec 2025 02:14:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766052883; x=1766657683; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=u+BV8l6bI5r75JWl7N88tV1hGPdzJiaxJxIZtgFdDj0=;
        b=MgVp4JwlFL6Ap48pi4nIVkjPRNw2kWUFmWvDsxZGoh0iMLv2MMnaawT1iLe6E9R940
         LguuTlTwy+bLOtCbu0CA16teAob+ycOH5AWXT8B/0M67O31LvcEJ82yriTLQLyomIlZi
         8kl1lP0+nxOEwT+8y0adYdTTxWTxmsUcA74VL7psVL17SZV/Cz4hxUMRPby6FlJdqTXR
         DAAL0JVvPBTkY7gSn2PqqjYAUQU8wi64qIY9QJg3+P3x8okH0c8KMZt5XFixbIF9Xd+o
         guOATW1jKHQN2KWSWtGebFw9X7Q8XTXKJiRNk8FbpdOsVhKkPSlTWdXTsEuhewQ8Rs7J
         7xEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766052883; x=1766657683;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u+BV8l6bI5r75JWl7N88tV1hGPdzJiaxJxIZtgFdDj0=;
        b=Kc+aR3Lq+UH2rNEiSkWH+jlt8Yeu3PDHAVzFoxXNVYt6u5hrqUY4ORKCdVA4xN4imT
         iW+sarmqbagydH+DiDCsSTohTCItbeUE8SnpdCJyUHC0VyvMJiC+7fQISwppaKH2uwNa
         M5oBzSwJOGuAz0Jjlc8+ht6fTrkBwXFOYceleuz7OxaWeKijZct1Ew/hnZ0SRajHLzWO
         LwzYLTNQMq9GL5/d7E7o+OXbZEcfoORM7UR9ateQXS/BSPgK4Gc2jHjARMgXj2UQtvDz
         IHpL35OUXA9tSyftCtkhjxeM8Z1FIKp0DIJJHgjdkb7PM+mO7OeaZppwd3f9RUGU531m
         3skA==
X-Forwarded-Encrypted: i=1; AJvYcCVPHa9ueHC2cPUqKcMWO3XnH/ULi8QZeZQyZ7Yp+2kYaOGjXTw53M1k1MF3gKl749qeSY6zTn5om6BRhkw=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywf/w2fQlD1RD90eBMl+WXTQ1LL3qO5yFZMD1s3lUorGkPeLygn
	Wi63McnmvN7bXXUlsK+8dzku9cMUElWJ8yaM35Ozc4mqsf2i6PS8gWqg
X-Gm-Gg: AY/fxX5o+AnTKUvJSFRx34S8GRaTHxpEoNyV2QPchQEHmvglqj0z9+7d1P2c/y41tua
	HsJOQnkMuJevi5OD+XyhG7ObkkQFnUPR40X6JnrxgBtC4DDY6iamMEpQWnL/fTHI67t0LMrbrbx
	Uj45TyZZ3ZZF/M1yNuq7a5/I/HwZuESYFbt6MsgrHJa2gqz4oACCzYATBCTZwxMzGUuidvPm8Vo
	JLIhWAZPROULxKH6gvdWN0s9OaoOzlpHnISWwkKBUfwakslAcz0S3yHRGqW70YDtpqMKp+WwDMN
	sxQvmxsIuY34qQIBbfgM0EZytuXiiL3cY7gktYWWzMnuXF2gEgQgha5gKE3vkW2TGK7bDOwWB3n
	2NdQqAO6eIYmWtcalfWtxzWwM5gmskOZkQdjYRr5VbTUcVpf/06aDze+8OYqsgDB1aaW1RQjmUa
	s9d0QTMK2Nnp9PzfPEwb73PusgjlpOq/4lxho2BwVeIhn4fppzu41J0KlNKv0gTQWDMvvriY86Q
	nenOA==
X-Google-Smtp-Source: AGHT+IEKMCe5QBZ+35evyA/8GhIHDGFGP5Us3fk7XArqpUIxN3OzD4eo78lOUdTRsUAazuLA1fpTHA==
X-Received: by 2002:a05:600c:c491:b0:477:5b01:7d49 with SMTP id 5b1f17b1804b1-47ce8777481mr4442265e9.4.1766052882893;
        Thu, 18 Dec 2025 02:14:42 -0800 (PST)
Received: from thomas-precision3591.. (cust-east-par-46-193-67-14.cust.wifirst.net. [46.193.67.14])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-47be274e407sm35914865e9.8.2025.12.18.02.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 02:14:42 -0800 (PST)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Lukasz Bartosik <lbartosik@marvell.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: marvell: fix dma_free_coherent() size
Date: Thu, 18 Dec 2025 11:12:57 +0100
Message-ID: <20251218101259.47931-2-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The size of the buffer in alloc_command_queues() is
curr->size + OTX_CPT_NEXT_CHUNK_PTR_SIZE, so used that length for
dma_free_coherent().

Fixes: 10b4f09491bf ("crypto: marvell - add the Virtual Function driver for CPT")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 drivers/crypto/marvell/octeontx/otx_cptvf_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_main.c b/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
index 88a41d1ca5f6..6c0bfb3ea1c9 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
@@ -168,7 +168,8 @@ static void free_command_queues(struct otx_cptvf *cptvf,
 			chunk = list_first_entry(&cqinfo->queue[i].chead,
 					struct otx_cpt_cmd_chunk, nextchunk);
 
-			dma_free_coherent(&pdev->dev, chunk->size,
+			dma_free_coherent(&pdev->dev,
+					  chunk->size + OTX_CPT_NEXT_CHUNK_PTR_SIZE,
 					  chunk->head,
 					  chunk->dma_addr);
 			chunk->head = NULL;
-- 
2.43.0

