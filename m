Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A936C28D8FD
	for <linux-crypto@vger.kernel.org>; Tue, 16 Sep 2025 09:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758013294; cv=none; b=b2pjifv6QX4I6bQ/1KZQ2wyVqCYIuohCp3bLvGSnrZJxphrCAjY6Ye0myXzBwu2QNkaFeflo8dvJ10FSGG6HNooQhUA9OVGqeNfeXfnqRomSO9MYSBGrtJFti85c0Qr0k2Hs6cu+hQy/pA/25jFyKwpoWRHJo84/nq7LzKsB84w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758013294; c=relaxed/simple;
	bh=6CI5ECYgOzpE43PbCnYe1/+C0o9IMjem75bN/KqMWZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3/1GCglSRMAEMxm6vaEDUruiw1Rp+gNMc50fmJd7eqUhyRnpchDZn1lc4/nm+hzjYm7zh2blC5GD3si7aib6rpxFh/aXtxp8wh0Y9Px73981m1A2sszCwZS6aIQlHfm8qaR7rEzWQOGlH0iV5Qhdrb/GNTfZpJEIHb0JISEKCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DCOI4cbo; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DCOI4cbo"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45dcff2f313so31922695e9.0
        for <linux-crypto@vger.kernel.org>; Tue, 16 Sep 2025 02:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758013291; x=1758618091; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dn/O6EVQArdDsuUvojtCYkGjh1nRaP/fdtC5qzIrIQ0=;
        b=DCOI4cbo/4dqlsBIGjesWJZY9p5aqtD4gz7dlrnFKUlmt1u94XWYNzin65Akh6UTgk
         OxDaH+noI3H3IrIS9W0Ju5qG+ZUPYQtHvWJ7ADq9ikuOuven6K4bWwkNeWRdIeIWENsP
         uJhzvmKFLx0R3hNyd7Fh7lbOss24ki6IvKt8sleaIdxnpV0X1VqLtbKMwKK4t3T/8q1k
         HXFAMiQzkRBIiesslCyGmYIfRMcXH+H4PtqIgkEvLi7tfg6oIK90zs8AMIDnT2MiBniI
         3BqqAAbsSEb6syCjhs7PdA5o0fgOufW6bdhTyFE3sPtCEPXJPsRojysUuzA+dEPsRDss
         EqPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758013291; x=1758618091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dn/O6EVQArdDsuUvojtCYkGjh1nRaP/fdtC5qzIrIQ0=;
        b=gJHjb9Gcl9O1eGxT6Wp6FQs1ZbHEQIkGeo/nNk+Ahg3qC+2UUlisURo2SxRS9Ui0tj
         b2zuw/M+wqj/LIG2OSnCqD5edDAOp7NLXa9Vg3lF7HanFydGCzpBFRxNdo3aC7hM1OJb
         fS0yhqPC0ABHIqQt0WhtR4WuOgts0NFTPFvUWKY3AaLFwq+csDHlf4nuGW3ItRcdaaNr
         RXiw+fghuF5cfvgxuct91HcHERHDMqM3Nar5Slho1vQTGTVCMwSazxNb0Zje+Ox6zMSC
         hBLDq1vdRj7uk1yxphyIfcWaBCYuMaRuOcFbHFqBBuJ5ms5dSf0LjxVSqIjAdlQhPXyt
         j44w==
X-Forwarded-Encrypted: i=1; AJvYcCWKBBrewnZNMDIBqa1aen8WwKUyUYp5yIzViAPz2f7KdqSi7GGoiZ9KLIxpNnYHekrwbSFSBQm+UNZC7sk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxP/pdTps1ft2XuTHG2xV9+V6fjioUW4JxsDG74cx3kMC3IxyLm
	Pn1ZAtYV2vOywbqTleKJNDt9JX+zy9r3IQtJK9i6VIFd3RtsbnopqINM
X-Gm-Gg: ASbGncsgPcWaB1edWF+2+BpB5ymlPgLY/Xaidt3UaIePZVMHcqtjxXSevv1P7de2gW5
	l6ZC/QIOumAw/YXy4KygzCKU/Jv9Av95+Ek+lKvUU51U5XSWt8g0OwuaURUP/RW8jprc85Jqzhn
	RfLAJ+H66c9lXAEkcpzTEL8WWe6xXDBKxCHO+J7R+1b0SFa1Z6fJC0BUNnjw4klSmGA1inD4PKb
	Kl6r95QdkI5P7auPfQ2hTekL/VsoB9GW/q3r4K9ZUI8xVe9sPCob2etMiFf2B/weXww48g/4SAQ
	WcBbM9ahAdWhxdNSH5pWPfE44RYShIJ2nYcmq2ED0+GdU80MipFfRwPaGrCfBcZBBLQiYym9wyr
	E7ly+0FlewtgJ0/e+fUjoHm/imIlwjgk9mmq0FLcCWsCb1qGdNsedBFBkNOEgwQSh/oL+5ZVYhv
	Xgll1hu0/JnOZ+
X-Google-Smtp-Source: AGHT+IHITqnIEWy8SR8VOuG/NaO5QPHcpXy3zWJ0Y1P3XtsNJD2TrXAHW1mpeJ/+27n2bIwqaq7a+A==
X-Received: by 2002:a05:600c:a0b:b0:45b:74fc:d6ec with SMTP id 5b1f17b1804b1-45f211ca9dbmr161791435e9.8.1758013290736;
        Tue, 16 Sep 2025 02:01:30 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (42.16.79.34.bc.googleusercontent.com. [34.79.16.42])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e037186e5sm212975035e9.5.2025.09.16.02.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 02:01:29 -0700 (PDT)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethangraham@google.com,
	glider@google.com
Cc: andreyknvl@gmail.com,
	andy@kernel.org,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	elver@google.com,
	herbert@gondor.apana.org.au,
	ignat@cloudflare.com,
	jack@suse.cz,
	jannh@google.com,
	johannes@sipsolutions.net,
	kasan-dev@googlegroups.com,
	kees@kernel.org,
	kunit-dev@googlegroups.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lukas@wunner.de,
	rmoar@google.com,
	shuah@kernel.org,
	tarasmadan@google.com
Subject: [PATCH v1 10/10] MAINTAINERS: add maintainer information for KFuzzTest
Date: Tue, 16 Sep 2025 09:01:09 +0000
Message-ID: <20250916090109.91132-11-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
In-Reply-To: <20250916090109.91132-1-ethan.w.s.graham@gmail.com>
References: <20250916090109.91132-1-ethan.w.s.graham@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ethan Graham <ethangraham@google.com>

Add myself as maintainer and Alexander Potapenko as reviewer for
KFuzzTest.
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6dcfbd11efef..14972e3e9d6a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13641,6 +13641,14 @@ F:	include/linux/kfifo.h
 F:	lib/kfifo.c
 F:	samples/kfifo/
 
+KFUZZTEST
+M:  Ethan Graham <ethan.w.s.graham@gmail.com>
+R:  Alexander Potapenko <glider@google.com>
+F:  include/linux/kfuzztest.h
+F:  lib/kfuzztest/
+F:  Documentation/dev-tools/kfuzztest.rst
+F:  tools/kfuzztest-bridge/
+
 KGDB / KDB /debug_core
 M:	Jason Wessel <jason.wessel@windriver.com>
 M:	Daniel Thompson <danielt@kernel.org>
-- 
2.51.0.384.g4c02a37b29-goog

