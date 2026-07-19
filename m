Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D61F352C2C
	for <linux-crypto@vger.kernel.org>; Sun, 19 Jul 2026 10:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784455681; cv=none; b=Vthh1A7u/WwatsdO2gSUs5njJzd4v3493HtIlJdx1xuEId/VoBghP1RhSq3V5ZhCPxM/YrauwwKS9BiUXSDSpjEzH1495tdVVI3WpWeuNIFf8e3SMSddeMWkF0XbdF1XTfAm2sxggXxAqg0MSWj2TIYa3DmHZtxkQixn3U93Ofo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784455681; c=relaxed/simple;
	bh=yjRcmnZfb2kLZm9aP0lOoXt1lRhIlp9aP+QqXrfSuKc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XUnCxhFE0gcWXfBxjJR05mPLU6HOp0qUeAGpatlx6VErUJYOcBF1/Ou/XrP/doebQ05Eq1+WiE5LkPKZtgcW0YnNlbafKR1DOC0SkMTFEFCK6qGM/24zRFy4piQ1cbDbi41hckaOSthfavGLsIVRQDJwBQgDcdFqgzzWFG5t9Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fUgAJF63; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fUgAJF63"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-385ea3ce80dso9223558a91.2
        for <linux-crypto@vger.kernel.org>; Sun, 19 Jul 2026 03:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784455680; x=1785060480; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9k0atJ8sZ7gOgp05cpC7VBRSHrbDcTYbS+DZ/M/wVxc=;
        b=fUgAJF63R+C3fyaEJrDjUO5JF6kVL8JS7kcKPreSkuoH/6au8mQkpGpvntQ0VFjCSc
         TgqcUCITJc0xHLBLEY+1eT0KFJzT6emYFLoW0dGJNcvvRcFsv0vxFALnjOc1InPAtwpW
         vCigfOQTfXNQAcVIC781Kson+jb1UPQ715TDvSx7NKFwxP7Dih1DPS/K1m30SpMjRF1M
         HADwN9xAY7tvBvKq+uqE2Fykub/WXr4OEP5+Kjyuq+PK9PhiWXimJM9KZRYzg1QVnn3M
         RK+xSbebkv/RLqEsETSvzxHLwd11dofjxOj9ouO2WUf6bs7hPls2Yxy6HqO9/9Jd2tIb
         9RzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784455680; x=1785060480;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9k0atJ8sZ7gOgp05cpC7VBRSHrbDcTYbS+DZ/M/wVxc=;
        b=smbMbw9l2SwIXMrOH1kUzkPo4+/rubhUMFNVKB4XPMzmWhynucHpvNklVxSJYxNI6t
         3XfWCz4TkPQ5nV2rbZO+LomQoF4+/jl4yXXmGif8JENdrT8miDgzz9PU2ipHQKJhQ5wV
         bFNL2PvduqUc6nncGUXOapSdyS2e13++R/ELYJhftmRNysBkid8oG0kL0Z5doIUY1SUW
         AiD0M724sEb0k0NP5Zos2XnlQfhuQKHfBnEoYG0QiETz1jueiA3aa+ue548Gadn4kwG7
         k+TNeEUCksf+2gYmla05KxOL/+nbQWxt1CvuKg5totkpaqQ3cQQc6vo7RSQXdIMOCA4D
         QXGg==
X-Gm-Message-State: AOJu0YyhAuQ846Rxd6etgJFBaSYu3ZyVOOqJ6bKoL51Dejsu/OA9LKn9
	KBpygb/96/U15qCyTKK4IZ/iI3y23tx9LQWkLU2AORfYTa55NpAu5xYxSMwPZbKd
X-Gm-Gg: AfdE7ckyn7A1AbpTQpq9Y9vmD3qUiwZHNo3NqZIfj0R/xNoP0b7UEWwduillrr3dP01
	87EKDEJIIpwQl5awi4AyC0KXQocLzDdLbArF/UIkb4/x/qfdrYDGmKiM3gBmn+yyX8oHL+oXKBS
	XMdxZJ/dPnuxmEXvfCAYtZtsyMhG8cVEZNRTvsAVluDg9wEZPp2iA2yGicVeU84Hg6zOFKLGp7P
	SoHtdnb6XGN2ggGGfIB+oV2mnOyhyz8q+w7FZqJdE3cXuYAM6JowyRQumMUHzv+8Og/sAr0CSKd
	LgYuDBmCR8GIFckdVtTceLwTENB1IYcAYgHN0wFkHFcHKcOs2nQ9jO9NZmWxcUxEQA6eO0F064c
	k3F2VD84HM87Actxy3AUoNxxfEP0tZkujIOEzKvM1tMgKL1g6bA9t0yBIl1uE2wILv3d/BMVDjz
	aqRnUKoxNk/KKqi/DfDrxjuSsWHimD
X-Received: by 2002:a17:90b:52c4:b0:381:85c0:1d88 with SMTP id 98e67ed59e1d1-38e4b417454mr10805096a91.9.1784455679538;
        Sun, 19 Jul 2026 03:07:59 -0700 (PDT)
Received: from debian.localdomain ([103.190.41.50])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13ce2cd6e6esm20902590c88.13.2026.07.19.03.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 03:07:58 -0700 (PDT)
From: unassigned <unassigned.56@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	unassigned <unassigned.56@gmail.com>
Subject: [PATCH 1/2] crypto: Update cleanup path to use kfree_sensitive()
Date: Sun, 19 Jul 2026 11:07:50 +0100
Message-ID: <20260719100750.13867-1-unassigned.56@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

---
 drivers/crypto/xilinx/zynqmp-aes-gcm.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
index d54c268dfe34..551726aac806 100644
--- a/drivers/crypto/xilinx/zynqmp-aes-gcm.c
+++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
@@ -230,10 +230,8 @@ static int zynqmp_aes_aead_cipher(struct aead_request *req)
 	}
 
 freemem:
-	memzero_explicit(kbuf, dma_size);
-	kfree(kbuf);
-	memzero_explicit(dmabuf, sizeof(struct zynqmp_aead_hw_req) + GCM_AES_IV_SIZE);
-	kfree(dmabuf);
+	kfree_sensitive(kbuf);
+	kfree_sensitive(dmabuf);
 
 	return ret;
 }
@@ -364,11 +362,9 @@ static int versal_aes_aead_cipher(struct aead_request *req)
 	if (unlikely(dma_addr_hw_req))
 		dma_unmap_single(dev, dma_addr_hw_req, dmabuf_size, DMA_BIDIRECTIONAL);
 buf2_free:
-	memzero_explicit(dmabuf, dmabuf_size);
-	kfree(dmabuf);
+	kfree_sensitive(dmabuf);
 buf1_free:
-	memzero_explicit(kbuf, kbuf_size);
-	kfree(kbuf);
+	kfree_sensitive(kbuf);
 err:
 	return ret;
 }
-- 
2.47.3

