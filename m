Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B002749CB
	for <linux-crypto@vger.kernel.org>; Thu, 18 Dec 2025 10:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766052069; cv=none; b=YfbjxCHT8f3WanJkOcm1AvzBL/ZN/n46P8/J7zHwmOZrFeSi/mVTxSUemCLpErOR5airAdtBnG6K0KGKTJWO88ZEl/Wo8u55ySnLLLYQJWdoa/TCvoPNZ4tqDLXRSYyKZ+VQgn7NIEfF5q/kKthqVbscp3VmKOaLQttisKE5Qss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766052069; c=relaxed/simple;
	bh=rV8tz1xEO+OL+dWcYOVwQ13qgwbEK1Y/uc6HUrd0jAw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DBquc3E0aBUKrctWO3wZeQ9DfBOgeOECUxte2Qhdov6qFoiMChHBEzXVC9v91ioQl6D41RcIozWYfxep4p/iSYr1eV1Pt3MVQYmRjPyJyZMNa0Rh27HUCX/NjsRpbWkKC1533AYDSIititWEOegN2xu2xpiNVIdmPoMl1KmRTBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZstoOiwe; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZstoOiwe"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-42fb8aa0c3eso55155f8f.3
        for <linux-crypto@vger.kernel.org>; Thu, 18 Dec 2025 02:01:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766052066; x=1766656866; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hyH9mCD6aBkhmQ77FdDtNB7q53LN9kNu+qw1jW9m6CA=;
        b=ZstoOiwe0CccgebBMueeefr7J6tu3cXAKuGWkYpj9Aq0f692ShtXMbbzBLJ2gqZyUI
         kBNwWriTOwuEXJv1pxTA32cVXUuR2Vp0VgCfKwktLEqpusvwr1bzbW/xS55VEM0litCI
         ZZed4H1FgJaau/NPsTMmbdlaUsXp8qyIOE7aaaQ/Dw0hVsfcMOImW7zzX9fT7Jan5r+8
         u4Ej6eYSNTI8g4gjqu29d7hKkrXTr+wHO1RBLZgS3SuJC3/2r/0iSEX9Q3QEhHgKFLYT
         c7CrvYKwpEJMQXsocn/G++UJN5MuSSWGKkfptj8aoRUJ/0MAAtLhcyfffO11rob5VV1m
         +moA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766052066; x=1766656866;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hyH9mCD6aBkhmQ77FdDtNB7q53LN9kNu+qw1jW9m6CA=;
        b=DpCYF47sU3B5YL2WbRDQXJKQnmSS+ATJ7w07CGYu70330nCRzX0PLwTIT++Sm46CCT
         75KsnXfrRUbKVw01hc93MQ66izNJcwKdkEa/OQOuuEYjc1CR6kdijXIp8Os3N+4b0EOO
         GQtwVDcFC5q56hEV6Uy0vwePBOy3AfZKdemswAQxVtVA8N9qSYuBJkEz1azjbm67wcYN
         2BlE83iOPQOtnbro54gxAV9RXsJZZDeKu4/miziFvCfQkI2exgoQ9rnpPU2vkFDsqt1i
         o7QziWlGtZRAu0FK6Q4s0hyrQjOPkGNkZiFD5BRggGoLq0pq8rL0fRXM2QOdIYxdow9t
         O1WA==
X-Forwarded-Encrypted: i=1; AJvYcCVOrfYsBYdtDL6076wt3njkg1SjJV6igvd33O/vvRSFXE6BC39ec7oS1uL4Ovr9RzLREhIQ+Y2lMPurI7s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2ZICeIfTIE8t7i43Cq75CwZ+a8MPFjIJjZxdhPB2pL58tfHQr
	jS0989LDumst6KFu0fHCqVqy6mnvfWTt0H+mnSzdE+UqPNZ1SXvvuqtQ
X-Gm-Gg: AY/fxX7IbZc7t+aV5Wt5qj6e6wShH2JFfw7bly9jDyCYm3pygBRZpGoP73n2udR5HVj
	yNzV5yNwhDP1Gl1gAIhCBMQXLP+8YZVpX2X14P37FQrOX8B87BVDLdWdDXtPW1Vsl4c5v4h2jWI
	Js8GEC0xcJVVw0HwIE1+ULUVPv6GqKtJR2KJBH1c7MWy/2TT+Nl5w5YtLy9BDBEU0/K/cHwl9mA
	RpgufYrqQZn7VHmTow79EsZUWCYlH1Zj8iS1D5ACzdr9hZaqlH3HFdH6nvKEpivhkwi8FIS0jmP
	uxl33h07o8dNZq/kuW5Iqs7bTPztiCN+mBYDifyyU4JyWBgB2UDd+pFRttMiJATPYl8Sx+E4D3p
	/wWF/Ipa8wj+LIK20G4wi7DpQUtBlB1NRZ+1O3ILTkFYqkPc9p3RMN1ilDyqpzi9xM6WVR9oozd
	nfTqGbp3J9+BVP4YXmEL7i3Pjo9tRizz4clBUXkbbbhFGOiDfmrMzCdZnNYmzCXiGe4Y+vIM594
	rdzuw==
X-Google-Smtp-Source: AGHT+IH2kKiYVsC8VRgBFg/O6dYGfFsrX+sxtbv8Pi0OZYXzYmUTA43kfU9pFEM/m3xMKliT2y9c0Q==
X-Received: by 2002:a5d:5d85:0:b0:42b:3e20:f1b1 with SMTP id ffacd0b85a97d-4324667044bmr1118271f8f.2.1766052066121;
        Thu, 18 Dec 2025 02:01:06 -0800 (PST)
Received: from thomas-precision3591.. (cust-east-par-46-193-67-14.cust.wifirst.net. [46.193.67.14])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-43244999336sm4025225f8f.36.2025.12.18.02.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 02:01:05 -0800 (PST)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	George Cherian <gcherian@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	David Daney <david.daney@cavium.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: cavium: fix dma_free_coherent() size
Date: Thu, 18 Dec 2025 10:56:45 +0100
Message-ID: <20251218095647.45214-2-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The size of the buffer in alloc_command_queues() is
curr->size + CPT_NEXT_CHUNK_PTR_SIZE, so used that length for
dma_free_coherent().

Fixes: c694b233295b ("crypto: cavium - Add the Virtual Function driver for CPT")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 drivers/crypto/cavium/cpt/cptvf_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/cavium/cpt/cptvf_main.c b/drivers/crypto/cavium/cpt/cptvf_main.c
index c246920e6f54..bccd680c7f7e 100644
--- a/drivers/crypto/cavium/cpt/cptvf_main.c
+++ b/drivers/crypto/cavium/cpt/cptvf_main.c
@@ -180,7 +180,8 @@ static void free_command_queues(struct cpt_vf *cptvf,
 
 		hlist_for_each_entry_safe(chunk, node, &cqinfo->queue[i].chead,
 					  nextchunk) {
-			dma_free_coherent(&pdev->dev, chunk->size,
+			dma_free_coherent(&pdev->dev,
+					  chunk->size + CPT_NEXT_CHUNK_PTR_SIZE,
 					  chunk->head,
 					  chunk->dma_addr);
 			chunk->head = NULL;
-- 
2.43.0

