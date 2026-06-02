Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60800175A68
	for <linux-crypto@vger.kernel.org>; Tue,  2 Jun 2026 14:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780412141; cv=none; b=FC4cBl1UeY7d9s/4VIBCdb+YPr2f8H+s6JAL28kx1kujCf3FXVry/5QiyJ0soTJ9/E9UrPExmLpGyUAqrMwQVA2uTDw/20mq35Jv0dEu4IP2m70bGEX5KeJwSDKtmvHoU/YVAYk7HMDUR59PIcVpq7hL/lR8FhJgIB6JH5GAqe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780412141; c=relaxed/simple;
	bh=huZPDyaaxaWqbuzsZLbbJYPVbXLJQN21p/3G+fkDcvI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=f5KBeHGeu3sqW70OSNsnI/J78/NkRaxeK0mGVZ4vxGiRqSVJOoG1ETaa3DrA7ZVGLrvEcTIsau9WYd9JFLLYFXF4jHOw8A9OJ3tXLdxvAkHkG1wEH51mMzGxlVBziXJhDelD2NTqwmnLY2l7DWhHhKXSmylAs0+/Dy1Dm1GF2I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ixDwqJfw; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ixDwqJfw"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2c132ac5ec2so4922885ad.1
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jun 2026 07:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780412139; x=1781016939; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gyMAbMxrhbJniIgaWCKhzTUQRO2Rtdp9wpj0gvULeMk=;
        b=ixDwqJfwqnCtrOtsS5f+YxRtjuafzbjx6Xy0h4kJ5YEgJcQ1euU2jN1bYhsGqIuFea
         Op4kLcQCMA6+hUERfS1Ek+6W6qUA4CK4Laq5O0lLUNijdv0gHhkC8U0OA3Ae3ryafcgz
         3TLpX+aPyC+10jhG8jK2bb9MSah60X/aBjBpZLzvWUpm/K03xjjL5p1HwjdJoWgtDTqq
         K9gqWydhZecBQXseZQRwDxyYMNftuH4vw3/HhMuCajMHeS86I6vDz1nOD+UY4TLEIscG
         JM0vbjTPRpnZW14sTUZoBUa8xR4eM2jzmcGP/5XD5qeWtBKqX5SDWnypxxaKk6xsibyZ
         OqgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780412139; x=1781016939;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gyMAbMxrhbJniIgaWCKhzTUQRO2Rtdp9wpj0gvULeMk=;
        b=fXkgqWH6E5ByILyjfXxXUJZk9sYZd1WXjuhsxikfREgZWiySeMIQKWASKjIm3r5bAN
         Z1Xo6wTV4eyS4ZGaoKYlC99+vMn/+ndQTOKNnKFQsdK4axhslZYogjAJIAHxahsMw0y/
         i9M2DxyWuBzlAx2DfuczfaYVCWYqXCX2SvdQlGQppKABM9oX0KMZdcheZFp4twKhdFgs
         iM3Leqwr66OCYHFtJbHVbWRhu5ajhzHpLmOCvIIN6R4H1Q/leKrP13Rlpcud+EYXduKU
         ur4PavCFqmDCgAbd08LoxmJjEPVTAqwT5JkIYvza9smGRTz4JTuLM7PAo24LqRYtLH0c
         U9uQ==
X-Forwarded-Encrypted: i=1; AFNElJ+ze6FvIdMPhvgFnyUdDfzX6bw972vq773/mbtWgDHxxKHCWBGVCRk96zgxCD2s4jGTEJQkdw9WvuB0ItM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJAV2eTgFR98QZdMgEMOa5yNm5X0pr/WEInt8zn8Jy0iSiZ9K2
	js59qGnD0u+TD8zKtwJlGUEC2amXdyX88xqiyHEynTRe9RNnFPh9xHd2RR98E9PzL+g=
X-Gm-Gg: Acq92OHT0ouKp0ZuevwppLZN2wpkpAzfLO8Jj8Hm9WLxrtyh7KmRYxuOUwfG43Yvix+
	lgeTRVLz16d7HCkfxW2iQ7YLqx29tBUnQra8gx+aDRv+pq3KF7UGhw16TmxQPZfHCRX+Gazglu+
	B5931VMkugyAp5TUbn7sUKCSLhG6P8EBb1b8jOA0qymHhYtnnZQM8h54O4OoKpbF7ixJMeu2uLf
	4dBp4dfQGiFyXdtYLSnQPEy5la5iMaAzyq86ie3T2JIiS0gnAmuSCp8srv3EDcvwMAp2+846U4R
	rg2n5TZoZvQrZlX3LNcenJOBg2mwIL5QbR7WrNXeWs+aWLwMANz1QWeVhrnxrJBqtJegqor95Uo
	WV9sVhD3v9RYrtbxaRw99rWc8rIkXbTs7jHqrIJg6faU09sTiK2hgPz9D0OiLLvMrpGO74ddWSZ
	m6ytOS0+nHPL/KejCLCNbhJHnX2rtbnGZUaEUhYGROcafaY/S5SPNquTVC6DtNBrl9SaDdgbMmq
	dKnLyIIXf40mfdt7rv0dRP6dcQ7
X-Received: by 2002:a17:903:41ce:b0:2c0:bcff:e198 with SMTP id d9443c01a7336-2c0bcffe31cmr146642155ad.41.1780412139430;
        Tue, 02 Jun 2026 07:55:39 -0700 (PDT)
Received: from junjungu-PC.localdomain ([223.166.246.30])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf23c0d727sm135113615ad.59.2026.06.02.07.55.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 07:55:38 -0700 (PDT)
From: Felix Gu <ustc.gu@gmail.com>
Date: Tue, 02 Jun 2026 22:55:35 +0800
Subject: [PATCH] crypto: cavium/cpt - fix DMA cleanup using wrong loop
 index
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260602-cptvf-v1-1-d68e58e59173@gmail.com>
X-B4-Tracking: v=1; b=H4sIAObuHmoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDMwMj3eSCkrI0XfOUFKMUQ2NjUwOLNCWg2oKi1LTMCrA50bEQfnFpUlZ
 qcglIs1JtLQBgHh0RaQAAAA==
X-Change-ID: 20260602-cptvf-7dd2d133508f
To: George Cherian <gcherian@marvell.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 David Daney <david.daney@cavium.com>
Cc: George Cherian <george.cherian@cavium.com>, 
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Felix Gu <ustc.gu@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1780412138; l=1206;
 i=ustc.gu@gmail.com; h=from:subject:message-id;
 bh=huZPDyaaxaWqbuzsZLbbJYPVbXLJQN21p/3G+fkDcvI=;
 b=pLsI3tYyTEAVB+K2l+REd321CBO/zXiCGGZrM/yLiIy1p9/8mIJUuhiChVxIjsbPgpNZGFFlg
 yP9ugGss/ZiC1fCie94JfUk+6bamSzd4iBriHeN8Bcc53dZW6J0v93D
X-Developer-Key: i=ustc.gu@gmail.com; a=ed25519;
 pk=fjUXwmjchVN7Ja6KGP55IXOzFeCl9edaHoQIEUA+/hw=

The sg_cleanup error path used list[i] instead of list[j] when unmapping
DMA buffers, leaking successfully mapped entries and repeatedly unmapping
the failed one.

Fixes: c694b233295b ("crypto: cavium - Add the Virtual Function driver for CPT")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
---
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/cavium/cpt/cptvf_reqmanager.c b/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
index e183b60277ff..de305cbeccbe 100644
--- a/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
+++ b/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
@@ -108,8 +108,8 @@ static int setup_sgio_components(struct cpt_vf *cptvf, struct buf_ptr *list,
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
change-id: 20260602-cptvf-7dd2d133508f

Best regards,
--  
Felix Gu <ustc.gu@gmail.com>

