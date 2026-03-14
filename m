Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2555B1F8AC5
	for <linux-crypto@vger.kernel.org>; Sat, 14 Mar 2026 20:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773519385; cv=none; b=ByscV9rq50fALV/jxAP9rKpzYd14SO6gbtM6pw/NPEkw9ntWrrCqwie54Zi5x8zLmZzPvOInUqiqYCRhtUStXjUgUbefNFoesjULiLaI7bzGGU6IFTSLLofjElSBf8NIsg8Kr5V2rioCHh7XbV5FIETRgS0q1jbYwD4F4fK3oCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773519385; c=relaxed/simple;
	bh=nwd9TGE0ArumQDMwtlbSIeCeLPeEL2dHq0lKDmi8GKk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R5qwB310X/Qc+8qeF4y8D6nLotMtLiGaGZbH/+1W40sY8/cnPC6z8WVr8rP1SiGH0xO+srOSEpElkT4QDbq0GIRzuh4R8nm0fLpIRk/JTBhsnElmXPeyp/3JRlGpch9up2+a1DkSXHlVto9do2J3x8/OcKgesAHFHMcrREv8eHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hXnwPXFr; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hXnwPXFr"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4852a9c6309so26351155e9.0
        for <linux-crypto@vger.kernel.org>; Sat, 14 Mar 2026 13:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773519382; x=1774124182; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GypZEyYWo72t7EHxUAotFf93/MQFLWWHVdEAGChBSyM=;
        b=hXnwPXFrwHFsooSWlU3QjvwQLm4Z+XOHEcV5BKVX8kfXILsUu1Ia7HMemHD9mSzyRI
         c26m4QmwN+U4dwVoBUCyjm2DlWJ8NMFcSPm46tZNe63DGXqH1M3d1jrPe8CVi5fOn1kh
         F9CtcLdTNH+JDXici+GAjgzHj4KAy90Ot5b9XEaEzyahkBDxjoD2sagdvohsJwgMbb22
         rVLVB0t81hgUw5wyL2D0WrEPXgTpDvk4S4083TOgVDrukM9xG3eSPSY88Y3nkARbbdKS
         36xTSORJlTd4noshPEeWm8zxa7QSZO1koSJqPAMUnDFPt5eSmo8XktN/SK9T685/GZL3
         vCDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773519382; x=1774124182;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GypZEyYWo72t7EHxUAotFf93/MQFLWWHVdEAGChBSyM=;
        b=RySpdtFulP4qhPQaejOIS0BCbIRPZW9aKDa5LaHLgZwnocX0oL6phgSx0eQqXb27Ds
         3UcyFNwrhwUqsLKACUOimgoVkgvDZ68g77Hi1tl+haRCCa1U2nrZ1PKTEdNFCaHlImGl
         jtKZliMm7xQvufzK+iyAbFe9ft4vSwySLhAdbVclpaUvVRlcKL48pYnDU91nKCeiILuZ
         oNPUNkmqApceGmwnEB5tViK7QdDSialGF+5G6pbCFL44/ItNhNFXQ0JagOsySg12HqGe
         IFwvapsih8SQ8W/hdK45HOJCB+GjOp5Iuu4qGVZpj4u4ZlG9R4tFPIyfMi6KxiMXEB/o
         7duw==
X-Gm-Message-State: AOJu0Yx0JapQJ14QPThQd/JxsCpmHlDN+32w74h7/m1PBh83ulEdCydP
	ayPEjSNtDiEFQTO47YFLm6PnDK2u0FdMKe7CtVsS7gD6TnVDjsqdHYBDfL8E0c4TtH8=
X-Gm-Gg: ATEYQzyWgVIoCj/ABLtrrgl8/VXm+5myV6UGOvBvhXB5w9XcOxKZ74LlKCY+bJEbEeF
	9GWIVfB7zEodnXLypCw0X1+UzVHjYDKKZRtSkf++O0zlsvt2j7OITKydD/NDqPNEGySNCjxHQ4Y
	S4EO7+gvjafzbvAdIqx80tD+5WZ9VIL86q+c69rVuJ3y7Udg+32FfdOQYQSDF4XELD4cbpu28GL
	um9nkDvQ7JRwB2dEEZ3++wriFsnvmjTgOGhg/px4/u21s1a2nSwbD3u63kDX06heJIDipXJ4Qll
	/NwbqRCFrAdDwmMiqhEuy1ok/xjY4xUcFXPhuRkZTB9TqDyPhZEx31EaiyQt6ow80DfzJNDFzjy
	jdv5LYqSUbc00r+8ep2mBvIDXfO7F07sYTAaWw9tGymtpTIiBIjRo0EplRR/NbJ3kVNbqgwI9lK
	XtDGQlBMetOxqOVP6W
X-Received: by 2002:a05:600c:8b6f:b0:485:3dfc:57c with SMTP id 5b1f17b1804b1-48556700bcemr125344845e9.21.1773519382333;
        Sat, 14 Mar 2026 13:16:22 -0700 (PDT)
Received: from kali ([196.65.190.215])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4854b5e912fsm803219945e9.2.2026.03.14.13.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 13:16:21 -0700 (PDT)
From: Abdellah Ouhbi <abdououhbi1@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	Abdellah Ouhbi <abdououhbi1@gmail.com>
Subject: [PATCH] crypto:scompress: fix kernel-doc warning and spelling error
Date: Sat, 14 Mar 2026 20:16:08 +0000
Message-ID: <20260314201610.212712-1-abdououhbi1@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix htmldocs build warning:
./include/crypto/internal/scompress.h:39 struct member
'COMP_ALG_COMMON' not described in 'scomp_alg'

The struct scomp_alg contains an anonymous union member defined by
macro COMP_ALG_COMMON that was not documented. Add documentation
following the pattern used in other crypto headers for similar
anonymous members.

Also fix spelling error in existing comment: "Cmonn" to "Common".

Signed-off-by: Abdellah Ouhbi <abdououhbi1@gmail.com>
---
 include/crypto/internal/scompress.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/crypto/internal/scompress.h b/include/crypto/internal/scompress.h
index 6a2c5f2e90f9..f91a2c3487ef 100644
--- a/include/crypto/internal/scompress.h
+++ b/include/crypto/internal/scompress.h
@@ -21,7 +21,8 @@ struct crypto_scomp {
  * @compress:	Function performs a compress operation
  * @decompress:	Function performs a de-compress operation
  * @streams:	Per-cpu memory for algorithm
- * @calg:	Cmonn algorithm data structure shared with acomp
+ * @calg:	Common algorithm data structure shared with acomp
+ * @COMP_ALG_COMMON: see struct comp_alg_common in crypto/acompress.h
  */
 struct scomp_alg {
 	int (*compress)(struct crypto_scomp *tfm, const u8 *src,
-- 
2.51.0

