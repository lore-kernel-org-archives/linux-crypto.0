Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B335537CD55
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 21:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774301289; cv=none; b=Se+Izn3wYKOxGCC33MY2TFHDM7ne0Zz6sIQ1RH3WAwxvVCKnCPtDYrER9abKiNblz7LKF1aJVtlMI7c5Ea883thsm/+rOuud+Z3aji/17gz4mtiSMwiwKNovn0UiZ9vLq0EBC/C724BpXAijiA6O5QCBNfXkCo6/5U87plZNMcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774301289; c=relaxed/simple;
	bh=o4H6Hut+h0tHrw3UiVjbV/T7sznmvIec7t4P4KjX4c4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Gvuf5JJKqYL3FRAup+TPDajb0cluTNWEcRoQsJXQB9v8XAA0pX/+pOV2O9tVohAJNFbzKU3iQ/FosI6F00nAnN37XFcCdWowiepIvP7XO1iTvsiWSkUZnVsIg/vvPTbjXKBh/Yj/PvMrvawdX7e4TuayQVO7MRzZsfvve1MoMbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ilavk4T0; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ilavk4T0"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4836cd6e0d4so6043175e9.3
        for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 14:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774301286; x=1774906086; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XxYw5y0oMDbij9HIoXO4SjbrHQlZ4oAoi5+oWu+ZDXY=;
        b=Ilavk4T0tqtSguzh9kZZLMf9MGTr3xU+65YUaOUKC2sSgbmpLU5E6dy8yj0nMhq67j
         JuINuiE8TnRF5jfb9QuSepNTb5hzfm/vjCbvQG7qE+L57XbLSP6FYJ7mWTn1WJbi2kx7
         oS+2ZnFEBgMbCXKitLXPWk89rYfXEBZdExC4gD8AgI0HsUgX9AxvB261ww8rcbY9/me1
         D6G8eWq4Eo44tQ/clyIyEIzjx/YzRt2Flf6cghRpuCI5NULC826fhuO/gdEdhfiiXuin
         use+AAZE/YQAth7Dhbf6UVul5mFgWZ2BK9MjmAK+xJHfstIiafgh7EfttIjoSy8Opy1x
         pnkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774301286; x=1774906086;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XxYw5y0oMDbij9HIoXO4SjbrHQlZ4oAoi5+oWu+ZDXY=;
        b=Knsa2gUQpLO7K8D5rklZkGkqWvwEU0sCzQkjhc7XDlx8vd99Swa2AZvClABiIHkTbK
         kBpaAGI+cglOcsLIHe9NiywDHeNmGZ2qu8K7h6QXyaZKVWBiUOzqd34zYlkWA7yihZaw
         pdlRALD9Tg5rtQ4Pyf3TW17nQZYqMUROzXSCrhbryLaKqqNQpS+ParIMQUA6ovHXtVmi
         PBZ2hxj7Xe70gQcCvR8bTpp9oAnflb0bmrvPlC1veT78XEQm5+krWD53l977SJJvqNHv
         UP26+d6LQwnau+p3v/wC+Fh69yKUQm/0qJ1Eu++MPeT9AJ0aszR0XLPqTaDn3R6LY48d
         8MHw==
X-Gm-Message-State: AOJu0YypbeqpD/Ridi0sqicTdH5TK2L+nR9D3q1Q+VOsS20AMZD5tadQ
	BJaSbwyA2jxwUsj2cSCa5zANYjEgCiK31xquAHO7+ufRR7M652JmOR90
X-Gm-Gg: ATEYQzz72E2Hla1LiPdezCN5C8SMPyMoQ1ZpV8MWq30V+NEfjyS5QNdkMHvhBztswur
	8yXseO+M80R4AkNY02e+/3xVYelQoxMFQn9JXNa3o8BvPdSAv+DFg+zU54W05C4MXqfm4wRvPMz
	dQ0Tjdhd0S04fsPeSkW4+MILznzWo6emslGCErMMQSOZATkMDCZ4sWAXNCFS0HNv1gZk1BTuv8H
	TMW35DUT7Nzc3tkV2tgNvi/DmhL2SXLm9vIO9Ae7BlP4Ukk+DdS8LYAvkjW4cTtAKX71mb6WN6l
	RWKx90hZu+AjnRvaq80351yP36MHPUQFCa/4OmZQNsTrZMIi/H1roYKVmhL9QYeP0puSeRG63ix
	8pZoRxXLWlOfBlCJXmYGZE88+06v6oRhaDkrRRz/eYmjl4Qs9zf3z6Xn7dbj2CURKsWtX0MbxT6
	KX5Kkn/ixHNmeb9NslnTImxnOQjUq52pkVmAEW6NWIkMVZ4vp3yvz7qR+NTiS0zmenbG9LoM8Gd
	Q==
X-Received: by 2002:a05:6000:702:b0:439:c122:4fe3 with SMTP id ffacd0b85a97d-43b64243dd2mr12046889f8f.1.1774301285791;
        Mon, 23 Mar 2026 14:28:05 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b6470393fsm33386975f8f.17.2026.03.23.14.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 14:28:05 -0700 (PDT)
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
Subject: [PATCH 0/3] crypto: atmel-sha204a - multiple RNG fixes
Date: Mon, 23 Mar 2026 21:27:52 +0000
Message-Id: <20260323212755.687342-1-l.rubusch@gmail.com>
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

---
Lothar Rubusch (3):
  crypto: atmel-sha204a - fix memory leak at non-blocking RNG work_data
  crypto: atmel-sha204a - fix truncated 32-byte blocking read
  crypto: atmel-sha204a - fix non-blocking read logic

 drivers/crypto/atmel-sha204a.c | 61 ++++++++++++++++++++++------------
 1 file changed, 40 insertions(+), 21 deletions(-)


base-commit: 5c52607c43c397b79a9852ce33fc61de58c3645c
-- 
2.53.0

