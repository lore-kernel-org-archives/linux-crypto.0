Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD5625A645
	for <linux-crypto@vger.kernel.org>; Fri, 31 Jul 2026 21:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785532845; cv=none; b=FIhhgMjtfogEf8+HsEbKWPrTZe86YsHu8PHrGNA9WBiYE139sJMYnFRH/Goyg2BSh9ra4C0ULsPCZMa7s2u55Xohw9782pQRkfnM6Xn5QVq6rdobvPOIqYkD76waduGvRwBqpzszvby6Ew+AV4LDdAhnDZBVfclS6GHh6eN/Fuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785532845; c=relaxed/simple;
	bh=9FQDOlU1gledsJqoFg9ZYijhrVegoEUbjHlCF9abtqk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U0bF6tFgn68YiZ6dfx2cl7N25CKgetia85DENyQCw2eMEYXiAtZ3JAwewE0az5Knos8xbnkWTLzKPBjZZnvrO/d+oyfb8th+T6fTcQwKj4HX11YTApnhcLOEuLOJdlrt4xuyz1TNz+SAwxkPh1P+iGE8PayQ50j+qFDDra5GNdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TvKNUd32; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TvKNUd32"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7ee125ec926so1009127a34.2
        for <linux-crypto@vger.kernel.org>; Fri, 31 Jul 2026 14:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785532843; x=1786137643; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=n4JOK41iwaTAdDnA7te0VNHLVG0HdhI8vu6z3ZFBIoE=;
        b=TvKNUd32SD8F/dh5xsvaQ0udJM+1cHSo/qtZnVPywOOtVejbG0jz1chqdQvt8doQua
         V2+UZTme2ed7L0nLq9PyTMKUZOxvJ1WUsu0CcBcui0rq9UskHgUCVh+uGdycl/QrELhC
         6tZIDkIxXxt3KVeR9aCdWF54XpIcUjB5mSYIkXG8gqQ4uczYUsc0uj3wuhVN/fJ0fV2u
         X1nJ+5uI0VFN0xCKs0gGImwb2htbUXMEXB5XzLwb8GUsiKUbEgMM6kVlaUa2mjcCy9u/
         mjwU+nksyWEmZWScGvVo0lMuf/FRutP0/QILGacth0T4fTk10nTW0gcc+GWAI4RQARNL
         luhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785532843; x=1786137643;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n4JOK41iwaTAdDnA7te0VNHLVG0HdhI8vu6z3ZFBIoE=;
        b=BaaeOeTSDy+F45Wbp/RA18K539/pqZT8lnaD8sKFL9m+054+pIhCABSNjE6NDXa42v
         USIIlSttEclMBuegywU88uIohkyWdD72SOQ9Bnoxwfho17dpLOqhO5IIVuK5qaK08lRQ
         MOuoc25EjAQ/zyGuheGLYBSxrMuXQPXzaZqheggDAo8C+t5XXudhURxM8N/UIM1VBrYX
         Nhj+eWfOJ2VX9hfeXuICHJ84d/xV06Er1YNCxcgTLLmoXdj1L1CUOvUiWNMto6bvWMIm
         ZmLu0YScvv5RIf8z+9OkfgREvMPYdalva8pi7NTLwAa5np6uSC9DcAejkm5e2uo8UFZp
         oGpw==
X-Gm-Message-State: AOJu0YzxNMbNMpXfVYJgj0nj3BNgrlkGU+rxJgti4dQ15zSyAU4tOXu0
	e6pkjsIhqqDMBHkxSR15ieCR76xc0lq1yKFk5rMJZTiLRP7X6P1SB7GJHdosOA==
X-Gm-Gg: AR+sD12qknr7o8QjUMEIAfBhWTPbfD2lCyLMj2cyGQfMOPe7R/p0ofzr4fzzr1LyETB
	3hfQtf5vmC+jCCdS+5qLTdkAVwehj4/hQugMIyd28f/kADFYHTeFLFzdL6BYdqq40H2vVDE3uqy
	S0R6ZyiySg7dmhyooDm4b3eUMzfhF0xYx73MM36WuiXibkTpmvdH8yqf9XEbbEHKp+y3g7z02Fk
	UCD3Ie4zBxn9tnOTRT39EvElnC1P0RMs84mrmeheoMMhzYqdRmGnh3qiyMVxLZJxT5goqcrjWfU
	b80B8ZK/d1pCSwPRwP5TURT8/+OJRU3pZ6JhlzfMroQPKKj8WiX4kW3NJSimkmFGZh820pR4HzJ
	BbUheo62JH9y8RhrJAyq/jjnIhNWMZVqrn6LH4AqwwBmk1H+jo1/AFsYKq+J3Oyl0+oXM5BXGHO
	tsiT3lK8KHDvWS9LM5riJofDkACcto8vV1przAA1GKgvRzC0zEI9mmRVLQWgi0KyPN6EGdlicbU
	jcwVk/442f+lxtki04vvvjxx6IkfA3S4iPfsonKXLg7smbomvOO4ZbO97qIn/5WikwpOzBevUww
	om5oxkjYPThpaWZ07fw0wRsYIusU8niq2h+EwFcYcpjm2r1S
X-Received: by 2002:a05:6820:5047:b0:6a1:8125:ffd with SMTP id 006d021491bc7-6ae43372e90mr2647420eaf.30.1785532842916;
        Fri, 31 Jul 2026 14:20:42 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e34])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-458f66c1d89sm2055758fac.13.2026.07.31.14.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 14:20:42 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: amcc - fix missing DMA memory barriers in descriptor handling
Date: Fri, 31 Jul 2026 14:20:40 -0700
Message-ID: <20260731212040.22764-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix two memory ordering bugs in the AMCC crypto driver:

1. In crypto4xx_bh_tasklet_cb(), add a dma_rmb() between reading the
   PD_CTL_PE_DONE bit (with READ_ONCE) and reading the descriptor and DMA
   buffer data in crypto4xx_pd_done().  Without it, the CPU on a
   weakly-ordered architecture could read stale descriptor data before the
   hardware's writes are globally visible.

2. In crypto4xx_build_pd(), add a dma_wmb() before writing
   PD_CTL_HOST_READY to ensure all descriptor and SA data is visible to
   the device before the ownership handover bit.  Also fix the descriptor
   field ordering: pd_ctl_len.w must be written before pd_ctl.w (which
   contains HOST_READY), not after, to prevent the hardware from fetching
   uninitialized length data.

Fixes: f6c48b76daa6 (crypto: amcc - Add crypto4xx-aead cryptographic
  AEAD accelerator driver)
Cc: stable@vger.kernel.org
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 0271b5e4d923..851bf075d769 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -876,11 +876,13 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 		}
 	}
 
+	pd->pd_ctl_len.w = 0x00400000 | (assoclen + datalen);
+	pd_uinfo->state = PD_ENTRY_INUSE | (is_busy ? PD_ENTRY_BUSY : 0);
+
+	dma_wmb();
 	pd->pd_ctl.w = PD_CTL_HOST_READY |
 		((crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
 			PD_CTL_HASH_FINAL : 0);
-	pd->pd_ctl_len.w = 0x00400000 | (assoclen + datalen);
-	pd_uinfo->state = PD_ENTRY_INUSE | (is_busy ? PD_ENTRY_BUSY : 0);
 
 	wmb();
 	/* write any value to push engine to read a pd */
@@ -1031,6 +1033,7 @@ static void crypto4xx_bh_tasklet_cb(unsigned long data)
 		     ((READ_ONCE(pd->pd_ctl.w) &
 		       (PD_CTL_PE_DONE | PD_CTL_HOST_READY)) ==
 		       PD_CTL_PE_DONE)) {
+			dma_rmb();
 			crypto4xx_pd_done(core_dev->dev, tail);
 			tail = crypto4xx_put_pd_to_pdr(core_dev->dev, tail);
 		} else {
-- 
2.55.0

