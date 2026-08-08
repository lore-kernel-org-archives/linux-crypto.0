Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB87A205E02
	for <linux-crypto@vger.kernel.org>; Sat,  8 Aug 2026 09:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786181933; cv=none; b=c22xtVziumldyFy7zDHE3WALvxyXzxFB9QynWnI/Vj618inL+CwmS5AJrFyBawL28N7s5nb9peRr6iNr9yy0eRT8oBOYiqZSaZM0g8RLxsGmmpRJze2h5mrmk2ZCpqEv5DiNB9QOC81LcMl/cfyfSmaSifyMGuoCPQ9cIVwEil8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786181933; c=relaxed/simple;
	bh=hD/EvuRY764RrsJx1wuEKYerRIdAetHJ9oH/4f0ywDs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KMXpxmUD/h9bi9EbpdotLc/8sI4iNAQ2uGywHju3CdhJzLec8tEmyZRP2WfjNfa1199GkR71UOasUVSfpka2KxJ1dxbiqGlG3P5GLwjsFNNA6VKoGvH/UqPdmwrROgGXa3xo1OagiRuCXmhgYRcQNChI72SpisYrjqT827WmuoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QGbb+jKv; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QGbb+jKv"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-38dd55ad76cso263635a91.1
        for <linux-crypto@vger.kernel.org>; Sat, 08 Aug 2026 02:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786181931; x=1786786731; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RX1DphTMSs3B4MvCbqjOAvkckybgUBneK6EG7I97Aec=;
        b=QGbb+jKvMrc5EKkDBAwrR42oszFlRKcQMVpk1QTwWO0s4mhNBsIW06gS4d61J9nPj3
         1h/K0Bn1soW0xe9KImLgPsaCyY3fJhuFwDyFDAaLXp6dSC1KKXwFY93xINVrvwifxULp
         Z+5+9A0uGORET+U5pfujkfjXJRv8EWAeZ2V2u31WYzJt6lhfAuU1dEKzT3CVkzRJpR/h
         Eor6bYOxaO/NJo/SSQZOgazGBHZGqtuxym5eCh69Mld/2Z+V/ZZodn2+c2pidvdXnnYO
         54JKGW70snT2n8lMr9TOO55o/sJLvgVE/qYUqfB56XkvcF1Ow3u0edoz9fSM7hIgwudd
         hJPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786181931; x=1786786731;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RX1DphTMSs3B4MvCbqjOAvkckybgUBneK6EG7I97Aec=;
        b=tDUmg6NmMGQ4sRBgY/eXep0jeruhyox0/rmPD1Sbc5suXdm1SitrIBK6f4I0MDd73H
         eaJGSrVc3CpSsomrufbIEfzi1JF4Y0mTcu5oIyk+dcUxMefJPhfUR6f4W/IAB0RKTqXY
         2w9+xgx+Nv4Gk0cimt0mWgBKRtBstWya9IpM1Taj1H5AL9ZTr0aR1hqUyDoRAlGIZS6p
         9X+NHISfEte9xxUF79ETV4k4heabk/G1wUtmebhNypSy77dBOlykeR7ZJrUP3Fwsu4x1
         JekQoVfiQ2dsS6ambidDeM+BKLgQp+U2vOJltaf6AObP6TmJlZczHZ525jKegtXS6k92
         th8g==
X-Forwarded-Encrypted: i=1; AHgh+RoOvJK/uQqLYnOkC94DDpVtZEIZkqx/gdK+FuSPaSkB0BcOgRUZ+7UBB7AX7mJ9iC6JHLlihC5Pwte8QWE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFu0zQ/HF5DJ51LLCmfPRzT6pHS830v/qfSzZtLq7eYfApMj2R
	QAAjiXaeyrgZOTZFVeqdHe1eXy+aeXN/AZ5NcfdiyletxkzNC6yUpY7z
X-Gm-Gg: AR+sD11HxV323jzVNej+U8/fhbWJMwe7yWvdDPiMeNuN/CnLaMFXOYSJDA3FnNbBKAO
	i2A1m/fS+84uN80xjJFlO30qiDwolgT6iaX+yx7uEWYvV4fM8H4DlS8thOG/r59OmJwv4zykA9Y
	NNN1bfxwergtiobpK/1hbf9EPfZyXqWZVT6sBPqPRoVCMPqgRr3iW00tIPHiPg6yc+6P3FF0jSK
	WeQAfZ91iT+2/92OcDYEZaF9ruoftqO9RgtL/v72pmtxzcgT5AGWY7jrR1hJMxyEdkLgvtgrMfT
	C1C1O7SeGgoOfTBBG24GWBGCdVFqc4oSuxujeSC3iLHFxcw855esadvkluuktjC2Yvih33qunGW
	yfUSDG/iDqrtuF7CZTKe44p8FkpovJBSphPTW9zP4mnL1enkveadWc5T4DyjjNcO8DbG+OaAEKW
	XcUjQ7j38IFvyRJNDveu7AKRBHvkSOSF0EA6gOeehasykXQVU4fRLoQA==
X-Received: by 2002:a17:90a:ec86:b0:390:b3c5:e2c9 with SMTP id 98e67ed59e1d1-392846fd57fmr1926782a91.17.1786181931093;
        Sat, 08 Aug 2026 02:38:51 -0700 (PDT)
Received: from lgs.. ([2001:250:5800:1000::f280])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3925fc6dab4sm5615231a91.3.2026.08.08.02.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 02:38:50 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Kees Cook <kees@kernel.org>,
	=?UTF-8?q?Maxime=20M=C3=A9r=C3=A9?= <maxime.mere@foss.st.com>,
	Colin Ian King <colin.i.king@gmail.com>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	"lionel.debieve@st.com" <lionel.debieve@st.com>,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH] crypto: stm32/cryp: fix autosuspend cleanup during teardown
Date: Sat,  8 Aug 2026 17:36:23 +0800
Message-ID: <20260808093623.2744314-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

stm32_cryp_probe() calls pm_runtime_use_autosuspend(), but neither the
probe failure path nor stm32_cryp_remove() calls the matching
pm_runtime_dont_use_autosuspend() before disabling runtime PM.

If the autosuspend delay is set to a negative value while autosuspend
is enabled, the runtime PM core increments usage_count to prevent
runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
during teardown, this reference is not dropped and usage_count remains
unbalanced.

Add the missing pm_runtime_dont_use_autosuspend() calls to both the
probe failure and remove paths before disabling runtime PM.

This issue was found by manual code inspection.

Fixes: 65f9aa36ee47 ("crypto: stm32/cryp - Add power management support")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/crypto/stm32/stm32-cryp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index b79877099942..74f6e329b1fa 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -2691,6 +2691,7 @@ static int stm32_cryp_probe(struct platform_device *pdev)
 		dma_release_channel(cryp->dma_lch_out);
 err_dma:
 err_rst:
+	pm_runtime_dont_use_autosuspend(dev);
 	pm_runtime_disable(dev);
 	pm_runtime_put_noidle(dev);
 
@@ -2722,6 +2723,7 @@ static void stm32_cryp_remove(struct platform_device *pdev)
 	if (cryp->dma_lch_out)
 		dma_release_channel(cryp->dma_lch_out);
 
+	pm_runtime_dont_use_autosuspend(cryp->dev);
 	pm_runtime_disable(cryp->dev);
 	pm_runtime_put_noidle(cryp->dev);
 
-- 
2.43.0

