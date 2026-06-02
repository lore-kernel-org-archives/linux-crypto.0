Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23667175A68
	for <linux-crypto@vger.kernel.org>; Tue,  2 Jun 2026 14:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780411112; cv=none; b=V76hQihMD085h4mC4f960LX+j5ayiJntSNwjTot6mRNKrj7u5bHpEnYal4xoWCHKba1eHZ5nYBHkb5A4X6mm9MY7gHns47Aa4vBqCv2mD5krz3IYSMqoggcmgR5sedDA9rXaZc1F0uSu1AdBYhZcd1pQ0N7EFCBHIX6Kilr2VvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780411112; c=relaxed/simple;
	bh=Pk5fy8zg13whwcDDwbJXy4ygunq8wiS8xbakxnMMKpM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=YN2RNyEEMeapDlfrg3V+KHnWZpuFrqbDFlmE0X9oGpYKYomwmY6TIksxEsHzkZt9DJKfmUyh0VnDZiH48xeBS7Kw86HE1F6ZKSLeG+BkEx2qF4MqlhVehm0JDxOrpCCdde6uRyq1APLE9xVbAmFB0IhwGxYIZ1OfTsefG5H5/Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e8IHYfHQ; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e8IHYfHQ"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8422524cb38so1027394b3a.0
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jun 2026 07:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780411110; x=1781015910; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AFtemtx42l19J6hbp8jwbFvW03jk6GkDQyGlQozvDD8=;
        b=e8IHYfHQTfXmwgu3L5NkAxUfRFlBQNV2cfhDeyh1/H6qF6eFHzTf1h4sYDrn2rknL3
         dPk9A6GYnebcsAB6vSE3C44ZvoO+tVLZq1t6K3r8YG1Og/k+gMELkaU2xeWHbJQUE304
         h9J+Qg7dv+rjLO7xxYmihMP8lut+IN6csLvdChVjTsS+JTQ/gI9G08quI+BPd27qT1KI
         xUnM4mXcFIZsKApWlhIiu5Lh6YcspeJ6Zj25BGqfMpsnXZcXUlm+mePW7KnDOCo+MvLn
         Ud7LLGyD0tsurpRL+fGmfJjmLUdc2KvPrI5+Usg2IA57xlSTmiB4y6cKD9a1UxaEdOPZ
         zB/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780411110; x=1781015910;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AFtemtx42l19J6hbp8jwbFvW03jk6GkDQyGlQozvDD8=;
        b=Zh5RwWtiSUhJgLN2P5gD1K4X2LavHfwgNalts/NDaTilJ6+DYpJiyRB17VcYE+7ri4
         rqtVblboKfudD7rbbN4gIvK2Sr7oRyxhQQeDS2XFazurX/H+Va0/ePecKDstB4ngaVRH
         kV7lCKTJV4dQaHabrV5aGFZibVWHT/u7rZNev2SOqoJ33Z7sXvONU8Vep6BzmoNk4lYU
         zreLIqR0HfFOjZAx2bTJEQj4Fan+3hZ0RepHG18LoCV7qrF58Kp3J98HKi3jvm1ldmA9
         St61hNnxiPzVHBxKtXG+JYSvb+xT0KTb0C4Mdo2xihCdBql2lAgxDnGyD3oHzUQ/ohMk
         3kyg==
X-Gm-Message-State: AOJu0YzO9DtMrknj/4kxpxWr47k0jF78XQ2s/oecnbt758K5A0aeojjK
	j9RngOboqYGkp63vi3JkSJvJlFXn1GAzh3QpTfDnu5NTZ9agirqn04Va+rr78EKo
X-Gm-Gg: Acq92OElADDLFhz/oxvl664qJES90hloMfppmd8V7SxAMtBWOTjotHUp2TfB+YKIOvC
	y7qgT6WLFhCOYg3u+2Fo52ez1qlP3SUVtyhI6p81BOw5zboerp/5cSHaK0kjYIUwGbGQCXjqzRf
	whPpC/YcvAmXrW08fNeWP6DkgpnxwZR+DY5HhdvAVoFtGnbc4gCBaG5hWPlAZ73KIbz4vrFU4i/
	I8xgtBSOZbSrIqYN4ZHnMz1hDXzvdWGV/lvRtXmiO2LMuIYg2yLfyEXnDqIdyOfo/TQxsu1X2WF
	P9PN9VRzuIoM1+4M/FpcF7c1ygXG4IADRi5rM1FSEiRx8UDrYko9306gORl0q8e9huIBnwJcMfR
	bNe6+ES3/vwPvLUBlkN0swlzS2Q9gq4zmEcPPuRRwzhjMgsFYzA5iIgqnVgRnPSDzFZThrISIFH
	fhhpQ2xeokp5OZUiyJjed84bKcxfp+ItGaiVCxXCWvFJ3BEnOMPvr1p2OgUsLTxejKlPu768sXs
	s416OX8VAOOTXgQm4SKIAzx9KDk
X-Received: by 2002:a05:6a00:22d3:b0:842:422b:259f with SMTP id d2e1a72fcca58-842422b2f8fmr11078226b3a.10.1780411110252;
        Tue, 02 Jun 2026 07:38:30 -0700 (PDT)
Received: from junjungu-PC.localdomain ([223.166.246.30])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84282221470sm49206b3a.6.2026.06.02.07.38.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 07:38:29 -0700 (PDT)
From: Felix Gu <ustc.gu@gmail.com>
Date: Tue, 02 Jun 2026 22:38:26 +0800
Subject: [PATCH] crypto: marvell/octeontx - fix DMA cleanup using wrong
 loop index
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260602-otx-v1-1-e0c9ec50cb04@gmail.com>
X-B4-Tracking: v=1; b=H4sIAOHqHmoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDMwMj3fySCl3zpOREE1NTcyMD0zQloMqCotS0zAqwKdGxEH5xaVJWanI
 JSKtSbS0AlpzxYGcAAAA=
X-Change-ID: 20260602-otx-7bca4557205f
To: Srujana Challa <schalla@marvell.com>, 
 Bharat Bhushan <bbhushan2@marvell.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Lukasz Bartosik <lbartosik@marvell.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Felix Gu <ustc.gu@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1780411109; l=1214;
 i=ustc.gu@gmail.com; h=from:subject:message-id;
 bh=Pk5fy8zg13whwcDDwbJXy4ygunq8wiS8xbakxnMMKpM=;
 b=Q+JT9WVcZ+raSeOtUoUMacF3csK26T5O+ffkXPjBQScVRYJ/zNuqgXA5l/j60H/4Bz0jX4TYL
 9zsrvgUjlt1COyamohjX0yBXkFYL9j1Qo20g293Eg1Mh5LgdrtVaPYc
X-Developer-Key: i=ustc.gu@gmail.com; a=ed25519;
 pk=fjUXwmjchVN7Ja6KGP55IXOzFeCl9edaHoQIEUA+/hw=

The sg_cleanup path used list[i] instead of list[j] when unmapping DMA
buffers, leaking successfully mapped entries and repeatedly unmapping
the failed one.

Fixes: 10b4f09491bf ("crypto: marvell - add the Virtual Function driver for CPT")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
---
 drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c b/drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c
index c80baf1ad90b..89030e2711ce 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c
@@ -157,8 +157,8 @@ static inline int setup_sgio_components(struct pci_dev *pdev,
 sg_cleanup:
 	for (j = 0; j < i; j++) {
 		if (list[j].dma_addr) {
-			dma_unmap_single(&pdev->dev, list[i].dma_addr,
-					 list[i].size, DMA_BIDIRECTIONAL);
+			dma_unmap_single(&pdev->dev, list[j].dma_addr,
+					 list[j].size, DMA_BIDIRECTIONAL);
 		}
 
 		list[j].dma_addr = 0;

---
base-commit: 08484c504b55a98bd100527fbe10a3caf55ff3ff
change-id: 20260602-otx-7bca4557205f

Best regards,
--  
Felix Gu <ustc.gu@gmail.com>

