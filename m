Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC564502F;
	Mon, 30 Jun 2025 09:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751275019; cv=none; b=t56p7SG+LIy1o17l9nxwZOsQlggnM9ws/ge2JbIZ4LMwrIROJnj2Dx9O+ACC0CEU8afXIeJzr01062SkTNpf6PRzreOc+dvAPGDUn73fC62cEqZo/6rILGQEewTPmC+/E8kAGzxoYWUwvuNnf+UqFCEx7LRe9sU2S/3AK+b9zr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751275019; c=relaxed/simple;
	bh=A1Scqaa0uqTalGcIVATionMFXUymgwrg8gg8u2Q2vQA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gTxSale5C1h1ixr2xn5u8d1fgdUT8h8sIW0vSBRT/iWfXamzy+ObNT2fYEQiMDXbr1Q2AxORvkQZcuG5uNWSkc2Nji9pCjHOED/QbNdoKvKbLNtkw5QkU/Z29qZFBQybA+IdvPRNff5AskqQaWeWKyuYEEotyYm8BrodrVLIpwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lRidN1N7; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lRidN1N7"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-453442d3a15so1516895e9.0;
        Mon, 30 Jun 2025 02:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751275016; x=1751879816; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=N6vAb/f1F0q1vHht05P9FW+B6191AVHmzVFqLR0tn6M=;
        b=lRidN1N7zI2Ktm36OeHx22MGOEXf0qaexOhoHNwJ5bakpq1JhB1iWEsMn0q5BBvtMJ
         CZcu06Psdjm7a86tz5CpN3bu1g+AeZ9pnZ2DZukiol16Au6TJAn6SzXwfn442+11+5BV
         7vbLOL0IXOwtWDNwlOAw9+nM0JmMJxSX+lqEbck/JuY9Vz6vGFQ4gToi8Oewk93thhMW
         O8cJ5+a8HOP5nwhX+iqMi+KpwxEC0HhSUI6CqRBCd4KBYHOqBHyDL+EZ025bVq8WrLZc
         jO4y586t2HK2Z5SLd8nUKbPtevZAhsODn4QBsyQHvJQu5FPe398tHLStFanikQ4TRwFf
         OVqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751275016; x=1751879816;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N6vAb/f1F0q1vHht05P9FW+B6191AVHmzVFqLR0tn6M=;
        b=MVM/rkqSxQeumFeP5HPKkbyEU1l5y/wdElBvTShrm81+RZoiqj6yPf8o4yHlahGiBX
         lYOWQgNsRb5d8xg22vVWUSdzu3YSdhXm/RhaNgQSa1v64Y7Ectvgo3XaHQO7KhNQR9PT
         f2f+RiUd3SLdIwZScH85YgyfJTNSzmLcDqPe/7ks9lEMX4Cm8GQmTlEpRjEZRj+Eo6cf
         Z0AVt/v8T3U/3bSuQifnAiaTUMuXqQobY53xFNkOgAhvuEbQMNRYXoM+RqQDwFC9pFVP
         LdliYbjV/N1S+wj41bcMuU/oesjaPV5Ca/IqpecidD4Fpmcgc+iDt03PvYVT4Xz5Y85Q
         wdig==
X-Forwarded-Encrypted: i=1; AJvYcCU/vJCvhXOLR6hGBUmJju/mK4GR8EMeHUqXBU0CYTfrttXD6JzvWIa7sO4m8mgVubTsky05APlRpdxSTDs=@vger.kernel.org, AJvYcCVflP5r3ek7PjZafY7emnIMLRRKGK4f6Pq3eRbNcaaRteLYUBsd3YQTzW8pgCQEyQgvDoCZV7a9hPCS1dho@vger.kernel.org
X-Gm-Message-State: AOJu0Yxmskl1TqsR3L8ZL1M/WKBA7U9+BjDkt6gwfg2bRLWlWC6ZaDlQ
	zBU7dKpQ62OrYdzGnfqS4tOaP45nEz1/vCMakI3C5rCSHmSbG8gCNCC4
X-Gm-Gg: ASbGncsrOcXVbPHhtAuS+ssfYlUlKThFbDpjMHckgsw3InXBRI+xnbobHxDlM3BTfIZ
	9udZFVNO0kCXNjejhjUyDxuR5A7bsa+E+9s4sAmFrgxnwshyuE2HtYxEJzlrP/TLN/aAdBZzt5m
	5fkwk2HV3o2fI+hme8nCgqvUEOe2djithZmPQo8ZlMJrgJfAypu/2swwK3qa8teOelqj186djN3
	0uy5EeIlxXGIeMIMid9MspLWWg7f0NH6vPh4TAHK8aer3LiMgtVBK9VbXaOM0eRfSss7hSQIcGv
	wSRV37Q7ZlSz+90iSJjrPV+9SPjEYfHCUuLv4Iite2AuuQ21PW5I9s3U9CYiFe6nt/eYawq0pys
	rkEqLW8OD+9XpgJo=
X-Google-Smtp-Source: AGHT+IFq4O3vhNy373r9ubChGNUtHkqR+jLEsQTSQzOBZ4rPPGQkjAeJ1lH5EqhQTh72Iug6oZPQug==
X-Received: by 2002:a05:600c:8b84:b0:453:7be3:3956 with SMTP id 5b1f17b1804b1-45395830b0bmr27637495e9.6.1751275016204;
        Mon, 30 Jun 2025 02:16:56 -0700 (PDT)
Received: from thomas-precision3591.imag.fr ([2001:660:5301:24:234c:3c9a:efe4:2b60])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-453823b6e9esm161857435e9.28.2025.06.30.02.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 02:16:55 -0700 (PDT)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Bresticker <abrestic@chromium.org>,
	James Hartley <james.hartley@imgtec.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: img-hash: Fix dma_unmap_sg() nents value
Date: Mon, 30 Jun 2025 11:16:22 +0200
Message-ID: <20250630091623.75655-2-fourier.thomas@gmail.com>
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

Fixes: d358f1abbf71 ("crypto: img-hash - Add Imagination Technologies hw hash accelerator")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 drivers/crypto/img-hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index e050f5ff5efb..c527cd75b6fe 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -436,7 +436,7 @@ static int img_hash_write_via_dma_stop(struct img_hash_dev *hdev)
 	struct img_hash_request_ctx *ctx = ahash_request_ctx(hdev->req);
 
 	if (ctx->flags & DRIVER_FLAGS_SG)
-		dma_unmap_sg(hdev->dev, ctx->sg, ctx->dma_ct, DMA_TO_DEVICE);
+		dma_unmap_sg(hdev->dev, ctx->sg, 1, DMA_TO_DEVICE);
 
 	return 0;
 }
-- 
2.43.0

