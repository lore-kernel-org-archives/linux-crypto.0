Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BBB2F6910
	for <linux-crypto@vger.kernel.org>; Sun, 26 Apr 2026 21:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777238996; cv=none; b=bxnDn5XXC20V41E0JvKXae/TU9TdMWQcxTB8vlW3G59jjBDZLmU3/G7q5YGe+A1ZA+NiTt1A0F6qOS4vnIXHYibupFzHYHgZ8FYl0udGnwn1RbPBslcrNMQPCgts97rXS68KT/matEf2SgCHD8KTuou7cNt3RUJ6pyGZLSTizH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777238996; c=relaxed/simple;
	bh=hMH9Y5+7JEV/doJGstTV66vJHfBoZUGnxHQvQaa/UpM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Tnw8XvlyYohusxSJZvu1jKlYC3S2vF48931EuwTwlHtFkfCQzV51DtmasbODrWOfYPEf0ClRDxlaIoEF2Pi1xrFjANXuPMtlYYuuTe9MaM0WTL8AeEC3zRX5VXA/HPn4YtHElC0gKsHOvTyz1ifMyXFt8jxNvHrmpHQWc1AQL+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bj8oC1ja; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bj8oC1ja"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-48a525dd2b5so8263645e9.2
        for <linux-crypto@vger.kernel.org>; Sun, 26 Apr 2026 14:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777238994; x=1777843794; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iLR/opeNBhDfGIgJhq5deg39/VYXY2JhgaAs8rpPWvc=;
        b=Bj8oC1jaAjC86LmCh9RcyStiEp2TpovhLXXtEXrrTsc6Q19ADzYjzeZhhzQ1IBqM/N
         uAeCwVXZUCEK/RGf81NCqLHdpm7STL575qaQh9Gw/HVwF+3K+n74nQGAlKsSPy/d3+yf
         zb7CdCA3sMfPCaO3un9NYbEW52yHA904YMxCQP+ZeZhCXAKW1/1k+ywNcCewyLybTiuu
         byj9OVYNHQ4mduLb5T0Dl9VGsmbqG/0R1WaEweQV0y6uEcnBndL3R/2j55ZB1opifMGF
         cjT2DNjfLcYg4/U57Eqf7SEXHzma8K0bVmwi2ZBVuzm/ZKSeIQ7f7wt13Eo8ulb7NKTA
         w2NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777238994; x=1777843794;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iLR/opeNBhDfGIgJhq5deg39/VYXY2JhgaAs8rpPWvc=;
        b=ejFCiJ5o8LqtYnXgDte2OJHIpGNIRmRKOfwuklUe4zBNB+VTabqLb9QYoUHePWuq4l
         1IV9XN771HNHqQ11uixX512GaGjVi/6Uo9JcDE/ZGulr7jX6b5pt2g4NPmrlTlCpDYJr
         pc8MyD33eeXi1sR9O/9fxwpkchRH66FAlVOp29QcL2YsoQ8iNkEvmTKGqWRkqQh8J+Q7
         U/BF9WG1QbHArxo6sxSpwKERSdQpaL4ls7UzDjW4mH94IcSjv5AdQ3PfPJ92cr1PfL/l
         aD47cMQfAmKLal0ZVH8hX924K0KS7Xmbh84WMRL+q76o5SE5x2jeokTl4GV5KKARHMxg
         mjXw==
X-Gm-Message-State: AOJu0YyGTNr1H6xxMsbHFdSE74oNFRldEqutix39KrZrKJMrgb7KrrNn
	GAnIcxKqWNXvO8CikPorzpgPUBK92q4dzg4lEPExb5RPi++TkXvFzeYl
X-Gm-Gg: AeBDiesJ3l0eTwwzKJNchsKCs1x/dCE9jbwQEnukJZiI69ZzAdO+zY8SeYNPRHz5rSK
	mXRgkdb/6vjAV8yqfrNDhT1zr8UpkNzpxVkLIz65r9QC+Sa5pLSKwoWbRyHXFvAT2IZy/L01Kly
	k/gF79XIfV2eClH7JElxC/zvYNoRr8dPBRoS2juN/Y4feP1+SyIHILLjmlOb2IwZBDJvsdGoEqz
	6ECLwRa+Mg0Mg9m6hecPtXzUUJOKhOg2In1+GO/ylEZTSjH89H42P1Y+6cnPIVCvAl8bLap7HET
	v+5g7M3ET4QBkE3Ux1hBUAjP9pAnOYEsPt6XFgHKtQNRwNE+YDTXctcGBHt1OFOz1ahcljT986X
	GUCa51LZZjOXl2BLv2FFgQrVzuUwWP/p3ufYwQa6fRE/uSAt1kbsRUgZy74Re8cquBKiqf5GjW7
	3l34h1bdjJWtrKQFsWSfaZhI+R4yGEWzIpCQLKL8bMOImDgUpwVWl691H7BSMwWk3AhmNfyUnnY
	Q==
X-Received: by 2002:a05:6000:2d0c:b0:43c:fdfe:bdda with SMTP id ffacd0b85a97d-43fe3e26512mr16823929f8f.6.1777238993569;
        Sun, 26 Apr 2026 14:29:53 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e3a79esm79047320f8f.17.2026.04.26.14.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 14:29:53 -0700 (PDT)
From: Lothar Rubusch <l.rubusch@gmail.com>
To: herbert@gondor.apana.org.au,
	thorsten.blum@linux.dev,
	davem@davemloft.net,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	ardb@kernel.org,
	linusw@kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	l.rubusch@gmail.com
Subject: [PATCH v5 0/1] crypto: atmel-sha204a - multiple RNG fixes
Date: Sun, 26 Apr 2026 21:29:46 +0000
Message-Id: <20260426212947.24757-1-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When testing the RNG functionality on the Atmel SHA204a hardware, rngtest
reported failures. Fix start of reading and size of fetched data.

I verified and applied Ard's solution (tagged it with sugtgested-by, pls
tell me if I used the wrong tag).

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
v3 -> v4: rephrase commit title; fix typos in commit message;
          replace index literal by `RSP_DATA_IDX`
v3 -> v4: Reduce seet and set focus on RNG fix, blocking and nonblocking
v2 -> v3: Removal blank line, rebased
v1 -> v2: Removal of C++ style comment
---
Lothar Rubusch (1):
  crypto: atmel-sha204a - fix blocking and non-blocking rng logic

 drivers/crypto/atmel-sha204a.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


base-commit: 5db6ef9847717329f12c5ea8aba7e9f588a980c0
-- 
2.53.0

