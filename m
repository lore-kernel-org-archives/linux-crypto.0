Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50D3367F25
	for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 21:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776892191; cv=none; b=F78geMU9rHV1I31MIF1vH9KDNIitslnar3r3YYC15OMiVA8l9yGojJrw1AurVJ7ft7R1DKx2tPjZOOO4TZOf/EKk9e56ml+AbP6GdoZeE6YfsMSGcSyfm6WEq8EB3cUqdiXPg2WqrCEbl0g+bnPQpz5+L+WcdUm3e3IDJFUDB7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776892191; c=relaxed/simple;
	bh=bWo2VKJC8PsmYJf6LNNWZvJjK2v2xZt5YRWpcTzDXos=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fyAbWHv2rIi/+QwUe9HNV58WAwxbqggoiLOjmcXBaiIEKaBWbK3JA7ql3WuL5k6Wjd2J6lXv5/fnVD7hs4KgBauxbIZ0gKt/o1OghdCSeVrMTUg1VjFvsPZ4xdQteYvMVLYhdSKxJCJdv9bj/aaFJS/aiUEQ6lKb3Q7qsYYgm+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QPNli/8E; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QPNli/8E"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48962cd0864so4669115e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 14:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776892188; x=1777496988; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4mWfyrQddMklpmzPYtTXoknwThtWFygtQ93s82K5k+4=;
        b=QPNli/8EHevDu3PyaSZPZT7JWMND+EF0SUslzovHBRZYZTDgfxU1fT7xu+EMl/9Jtl
         UIh/Sk5UcPQD9/fTI+zRSwPvSOtqRmtqIq/DsXwWjYbIHBW0a38v/gH1fw/T0axpmbsJ
         uCJGH3NGrnh8UadPWHArk5xS4HDlV704IFv8Felzh4Cyo9r7XyRkWb4OznWdAYO79Onw
         4k9RcYKRxMlX8R0kNN5Cdw8IHsJD0yyUP/Z9T34VXh2kh9TeyXXtAgwjFqjqal1SPUr5
         AER2R9eN8VNKlOd+GH1JUw2ywWmKg2ADMJ8MqhPAC4gjY6sBCGJYDXWA2mPZY3xvB3I6
         NcCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776892188; x=1777496988;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4mWfyrQddMklpmzPYtTXoknwThtWFygtQ93s82K5k+4=;
        b=G+xI6Q8+nPPsYd6kGlWoWxd6LOBWUJGwC8FWoA+3m95OT0ViqSRJkg51C7E6UKFH4z
         LsCztnciXttuGldTGMapFY+UuJEdHy2NGnUTjk607kzcifkUbnkdfP3fednAahA9+GL4
         9RzZ6AHRWxRUUXvHg6deR94lWGInUCYo1/v2oJ6XT8Ov4y66Dauw6HRpTzBIozyHpXRe
         QSoDa0Y7CyaWKolcqdPdJaDF2ZhncVtwDJVmbiehOg9VrLdds5jKaJLhnJnw8sTKu4pV
         lEd/BWoSc91UpTwcX6NA1amV7Oa63L7uF2Sg0gHTmtGU/fsLyC2NQcf3cszGXxTuqdgZ
         KKhw==
X-Gm-Message-State: AOJu0Yy0X3cIYzU1rK2XFmJAEuEcuyXI5OQYeU0k2J8otBfQQ55EeXkb
	SHQp9OoUaq21fFRNzvz3Z71u3djEhtCgQfjpMyfY9dHmpEvVY5PtUs6z
X-Gm-Gg: AeBDiesbTj7N04sNiYSzqAZVgONLYMz1I74o2ZH8aBVKlZCBz3UqFjCOZcc5AFX3aeb
	6+bDUmhNay24u5Qyj8SfkJ8r0VsMbITsVlBmpmRWEJ4NM/+Rh0e9t264ADRMJ/csM0tfhij+yRP
	JAZD2lIjEKNjKVWSz7a4/w8EYeOBARZpo+r8dKThHg58wJfvrpZT9KVAwTJzfYs67xyTo9bFH3h
	aVJTL0uc0IPFUVMpDUwrsKoQptWaYgBsaZqKa3Q0P+nQlj0n+zEzyFlAtdQ+tzoErZQssJWJY3I
	9y9o8cgAsmm+xdBfU+YDKZpYW29Xzw5Iq4PXWPrUjuPlNHAWJn0qdR9FttncyYhNaCfInOg5CoU
	+dH6RdUZgiyOuIaYLj9mGAQHXb3yla7nvJfPXUWYtRNXeZnvdpe8O4VgYl5s/880FsnjJEiFz0i
	IO54/q66mHRpc1xQX61x/k91Hcanxt0VyIYqAdecDz73Vfhn3Kgw4HDp4ctd72qoXV2wxWr1WyV
	Q==
X-Received: by 2002:a05:600c:4746:b0:488:a2ac:a338 with SMTP id 5b1f17b1804b1-488fb7685f8mr168719945e9.5.1776892188108;
        Wed, 22 Apr 2026 14:09:48 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a4b329542sm352469085e9.3.2026.04.22.14.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 14:09:47 -0700 (PDT)
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
Subject: [PATCH v3 0/3] crypto: atmel-sha204a - multiple RNG fixes
Date: Wed, 22 Apr 2026 21:09:33 +0000
Message-Id: <20260422210936.20095-1-l.rubusch@gmail.com>
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
v2 -> v3: Removal blank line, rebased
v1 -> v2: Removal of C++ style comment (I saw it too late, sry for that)
---
Lothar Rubusch (3):
  crypto: atmel-sha204a - fix memory leak at non-blocking RNG work_data
  crypto: atmel-sha204a - fix truncated 32-byte blocking read
  crypto: atmel-sha204a - fix non-blocking read logic

 drivers/crypto/atmel-sha204a.c | 60 ++++++++++++++++++++++------------
 1 file changed, 39 insertions(+), 21 deletions(-)


base-commit: 3bfbf5f0a99c991769ec562721285df7ab69240b
-- 
2.53.0

