Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C943C872F
	for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 08:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774945281; cv=none; b=BINTNgcrJGx4wKNDGR//H3k4yqBi+dsTI9dB1CA1RUplc5hgIYYqbzBO7OVXGvkf4UcS+s1oAQNgCJV2mOzRRWIWCDS9u2RTI6Zje3WWL4rgLKLI2TDvLptK7uAIJ/uEumC/YgPit8GO4c30eUb7bH2mEQt/zs7/8fRjJaBuAtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774945281; c=relaxed/simple;
	bh=rASOBVFE3DzESvbGeqECsrlRzkoHgAZdUxmPO0hhxic=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZAPjvEGNoEZcYvkMxzsL3pDG8FFe4fgdREveQlBo3zit/O29y7mQk8pLB7SlTAHdUkY+bB4QVvp6VDLJSL4RV/au3cgvZICoRnKxyn9132RxG4DLCTi7ljC7LcwgyWSkKMBUiDjRuDTiIpLVJ0REgMWlzWu4cOxGgT6kxbTDUKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fnfrYlt8; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fnfrYlt8"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-43b8822fc05so489781f8f.1
        for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 01:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774945277; x=1775550077; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kgfma63aNvj8LoqZ/8WsKQp6E4V/1m+2J06vQ5c8LKw=;
        b=fnfrYlt86IEnCrtXzLk8kKzQv9W64/l4DkNZTj87IBhZpDgCdDxktYIBtVV/aQbnDp
         azbgudHoeIWRy3JrE7mSgxw0+99y4tPUKjf3sI/hxbxxHN8Pta8rmoZbQvJblU8wiew9
         8nGxkxVjGzQHcSqovZtz+CNw/iVlm/fwFq+NbsifI+TpP1MPzWwHIIKskkxyANz5l9se
         ZTgcMKyYsl4laAJh1uO8wYUEqVa5HMNDWzMM8kNPD8VbYvBRK+1dGmqHMNFXWFa7EIav
         QYkZxe7MAzPZ5Ok84TZ6WHe2TuVzflP27M+0wC/u8flpxQc6EyfnMbACYb8WYVJWGRgw
         ho/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774945277; x=1775550077;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kgfma63aNvj8LoqZ/8WsKQp6E4V/1m+2J06vQ5c8LKw=;
        b=aeRNk7oShQyfyCVBXERfkscbky9qZgV8yKTl2KGSuz/J2orFldvOY1ofi25TI13UfL
         sJck+RYlzk/334NW2cNPla5b3D/Iw25OU5UVSHgA9w0hj+KbQfMvKcBdb25QLkoCpXer
         EdaORXMfeuRqHQWL246L1FcpzeC991wzwe1HMd7FWXQgpkgY4zPgJbmOb5ZhuXWWaQUN
         Z2L24quqf3LOu9iDErNWnmEX0Zimq1giOaCHmRfkQ9ronp+2K/kV2jYPtEYg8XvUnDfw
         J9k+N2A7sw8Cyjl4mfeWn5midBQ250sOKTC0CojiC8NQWlr0tFpqfxgPq4ime7JxVvgm
         C2Hw==
X-Gm-Message-State: AOJu0Yw66CFgTA2FrIYKabLcrp1/yXRDJL+92U/3hBB7o7dwhRd+Ggwf
	1Uc//nOqVSNo7N6yiQYj4e4WDhOsOVptbOyZF8UQSLPTm4nbOUXzPY5+
X-Gm-Gg: ATEYQzzEVv2yZb4oCYO0U582QH9FalkRaJ1wp8z/RyK1B0BqIJA1cQYiaBhjmu15LU+
	ryy4SWKOqClEQ7H7XRyBOgnf3rsDiXJEZX+InU8yc58TjR9lKaEZ/95Nk4Ao+8/5mxTN0waZZ/Y
	4RXnrHBAhuTw3QUVQdd06a5JyWlqeEh2ZvwOvyVhiEJIgSPwFio/uaBMJ9kMgFYFyspFX27yN0C
	uc0PWt21EFNxmy48ye2CHnXqicYENrKZodpGaZ2RVZzxD4ipr4bkfjJsx/xuO3sVaajTFuCWWGW
	FbQYNKuhTC2OLzNEv9DvOvMUxrxIsxX14aX+hZk693PVy85mVJTtdR6G3M8cxxNkiLGxyH2Il73
	bZsYHsxOUA4SerGGNBsUkL1eYUbgGfMBvFW3yqZVpRrh6n5P38ttd3R3v5xcVHMpDMUF71DupMz
	L0PGLBkehK3bOIR1hiz3GWfqV4cnBMVoNzti2LaPrnk0emzaX5csYflbzQc06tE04=
X-Received: by 2002:a05:600c:5251:b0:487:22de:25 with SMTP id 5b1f17b1804b1-487283d4939mr133907515e9.7.1774945276289;
        Tue, 31 Mar 2026 01:21:16 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4887ad8d28bsm14542485e9.10.2026.03.31.01.21.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 01:21:15 -0700 (PDT)
From: Lothar Rubusch <l.rubusch@gmail.com>
To: herbert@gondor.apana.org.au,
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
Subject: [PATCH v2 0/3] crypto: atmel-sha204a - multiple RNG fixes
Date: Tue, 31 Mar 2026 08:21:02 +0000
Message-Id: <20260331082105.697468-1-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When testing the RNG functionality on the Atmel SHA204a hardware, I
found the following issues: rngtest reported failures and hexdump
reveiled only the first 8 bytes out of 32 provided actually entropy.

Having a closer look into it, I found a (small) memory leak, missing
to free work_data, miss-reading of the count field into the entropy
fields and parts of the 32 random bytes staying 0 due to reading the
slow i2c device.

The series proposes fixes and how fixed functionality can be/was
verified. Executing rngtest afterward showed a decent result, due
to the i2c bus a bit slow.

All setups require selecting the Atmel-sha204a as active RNG.
$ cat /sys/class/misc/hw_random/rng_available
    3f104000.rng 1-0064 none

$ echo 1-0064 > /sys/class/misc/hw_random/rng_current

$ cat /sys/class/misc/hw_random/rng_current
    1-0064

Testing RNG properties currently shows problematic results:
$ rngtest < /dev/hwrng
    rngtest 2.6
    Copyright (c) 2004 by Henrique de Moraes Holschuh
    This is free software; see the source for copying conditions.  There is NO
    warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    rngtest: starting FIPS tests...
    rngtest: bits received from input: 1040032
    rngtest: FIPS 140-2 successes: 0
    rngtest: FIPS 140-2 failures: 52
    rngtest: FIPS 140-2(2001-10-10) Monobit: 52
    rngtest: FIPS 140-2(2001-10-10) Poker: 52
    rngtest: FIPS 140-2(2001-10-10) Runs: 52
    rngtest: FIPS 140-2(2001-10-10) Long run: 52
    rngtest: FIPS 140-2(2001-10-10) Continuous run: 52
    rngtest: input channel speed: (min=7.631; avg=7.804; max=7.827)Kibits/s
    rngtest: FIPS tests speed: (min=32.273; avg=32.701; max=33.056)Mibits/s
    rngtest: Program run time: 130177956 microseconds

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
v1 -> v2: Removal of C++ style comment (I saw it too late, sry for that)
---
Lothar Rubusch (3):
  crypto: atmel-sha204a - fix memory leak at non-blocking RNG work_data
  crypto: atmel-sha204a - fix truncated 32-byte blocking read
  crypto: atmel-sha204a - fix non-blocking read logic

 drivers/crypto/atmel-sha204a.c | 61 ++++++++++++++++++++++------------
 1 file changed, 40 insertions(+), 21 deletions(-)


base-commit: 5c52607c43c397b79a9852ce33fc61de58c3645c
-- 
2.39.5

