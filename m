Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BAD246BBA
	for <linux-crypto@vger.kernel.org>; Sun, 26 Apr 2026 15:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777218588; cv=none; b=aK8RmW9IHYIafBreL33mdBswp8x8xA4KA0Y8Mv3jY8JvpkuWf89nKKOsWO5jOHpR9TKO2R0d84HIl8gOWdpT9GfLyYQkxKhIKoPRwDELRT9I99Thq/ZVhk0mPgL524xVfI1jUPLtQDt70u+mBD4LWjLh2QlfCTyIAjv3Is10w7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777218588; c=relaxed/simple;
	bh=tQWiDMlEdDffd4Yj1xwFeeG/EO8+yxtlQz0kJDN+Hgc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Q6EjWlW/InGW0FJOL6u5PeE4fSZsm3ojiduDcqa8UonK7tY3D46YC35ndhX62oadTt5pCM3nncxO+GtHxqmzNc7mfIPemZrROl2GmTMlYZ5ft+iZEAqB02UYefl5lboiqVeBJ/7Ie2p7MxPHRb3TxH9f7u7E+qDbcY5P921r9LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qkLOHmkX; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qkLOHmkX"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-48962cd0864so10459795e9.1
        for <linux-crypto@vger.kernel.org>; Sun, 26 Apr 2026 08:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777218586; x=1777823386; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IQNSYuEKSp5nerKY7s4NoQ7aeozw2OgexDJkLVaxoww=;
        b=qkLOHmkXvckNvb37hZH6xi+zB+bWMC5WeC2sZM2D9PVLCfhSe0QLmltNa6WPfHTn8r
         abDy4brauGrEpbj0EdM55/XwUBkK9DALj0GyAz/gR9llYrB+0cCdoaYYgX9favF4MYfA
         HM7RHRze7uwqb5lE0+uWndFWkHkO70nZCskEDyGyuPFIvPaT8RT77zr9QQliEk3uiDR3
         Sby18XQnrlfMQsoX9j7oodhFojysTnZ5ErDB2pp1cWuo+wlw8Oc+Nm6HqivdkKzihv8D
         hALNxy5dnroJWz/2avjT1RXV1DclvK3OtFfiUPGZvfMYHTO6ndDc1VvsCDWsQWtdtlxP
         BOaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777218586; x=1777823386;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IQNSYuEKSp5nerKY7s4NoQ7aeozw2OgexDJkLVaxoww=;
        b=KK1+N1PaZ9lBC1imqEGo6VB/yUthYwqVzekjnWpWhYi44dJZyBOHiuomrt9gX9VpX7
         Qil1nU/NvUIpFP9ML8Ik7xTmNPqSN+SI58rh/Th+Y7z7O15uwWMbjfV33NDpgT7VjtGl
         mDA06Kd416aDxNuzGcJUKftXbjsHhQ+BNcoUSQWzEhhFwcPmA+e4m4TbK1PjO3oXrSfX
         P07OyGRFJtUOxpSqK3DjkneWDmkKt8+HJOiQAL5KGDOuIrTC6vI/9AHDuyGKrhmSn3El
         kc4w/RL78YUeDjGGC7+NEsx++Dxh48cC4FqV2WPc6gBsoNHMibVpmamxVt/HplEzuE05
         kkaA==
X-Gm-Message-State: AOJu0YwIad6qvqWiRVDceI4l/0ZG/N1tezAVxZeVtC1lTxSvE9DaqKZL
	BnAFTS4+R5TBdL8Y297y7Y4yqHjri9HPZFxFv005ftG3F4dBLQ8BcwvG
X-Gm-Gg: AeBDiesjPaVOC66l03iLogHrpIhCRyV4PplJMJIUJctBnSU5HCxOtrr4HNu0gXgrCNf
	Uzj7jA4+DOB7hVtxLFP4xrHlszjO4ATOaMj5iRiIG2Qznt0F7ji7Ov9xw0mTc6p8/p8HsZovo5/
	trVWYas2uLpJNtEWUtBu7FIPslbMGMAnb5zja2/fgLdczhefqJBUu1uXWGI4qFROV7RNqtlAZHL
	sgNS6lZP+tKe8moxK4gJzyXdoRes1InLp8/gjkxX5OwXR5lddBgnH5rMaBkgdJhMaELnOJmGb7B
	itvZ2A46yg9C7voHkvbsKIODPz1KRsvwt+aA2E3h2NkmlE4n6iW7jGeYuDRY7R55fDN80m46s0e
	nZbZWxAPJ+qhUx3xxW0aeGN40EBOdip6CQJ460dmLoYB/HsjY2b5AtZVrxQH337EETfH69fUneZ
	JK32pHbP8lzVDfhq9wMUu9/vMMA5vgFUdXTf74c5QvZbU4QiRT1rvFE76X85NfuGxLOuSpIT6qF
	omIGUACLKSh
X-Received: by 2002:a05:600c:4746:b0:488:a2ac:a338 with SMTP id 5b1f17b1804b1-488fb7685f8mr288589875e9.5.1777218585703;
        Sun, 26 Apr 2026 08:49:45 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e3a341sm79799339f8f.24.2026.04.26.08.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 08:49:45 -0700 (PDT)
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
Subject: [PATCH v4 0/1] crypto: atmel-sha204a - multiple RNG fixes
Date: Sun, 26 Apr 2026 15:49:39 +0000
Message-Id: <20260426154940.24375-1-l.rubusch@gmail.com>
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
v3 -> v4: Reduce seet and set focus on RNG fix, blocking and nonblocking
v2 -> v3: Removal blank line, rebased
v1 -> v2: Removal of C++ style comment
---
Lothar Rubusch (1):
  crypto: atmel-sha204a - fix non-blocking read logic

 drivers/crypto/atmel-sha204a.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


base-commit: 5db6ef9847717329f12c5ea8aba7e9f588a980c0
-- 
2.39.5

