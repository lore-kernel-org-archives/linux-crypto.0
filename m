Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8712F14A4DB;
	Sun,  3 Aug 2025 19:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754248265; cv=none; b=ojpXWlB+TkXkAxbmkgNwFgEIXGuvTuG+Lh9XjBbwcWZ9TlOsKK7SYe/1jqHWsp8oboE6cOXgi0J3+ylCFQV8IsQSqXQIX/mpHrwGD/VI4JIf1vprPQKbwIDSqNseH6gUAo2jWrow+an/SiG/RXvVyLADBC72NhmA+9TUZxUCDAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754248265; c=relaxed/simple;
	bh=9mZm4KHicNT9tn8BitXSK+UbAoZ+f+Nh02nlpXVqkn8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TTUjlYBcch2XA0LqfW6RiivIz9eMLp87KyT6/6STrGWFgNZoRwmYiXnlJtViqb+om7OeXQ4uhQ1l7Te9OPF/FGiLDBR8s0bTuVxaKpxDwQVh9OzCS3nxThDAEJHyM41G70gOEu0v6V9VdG+CpEUIgrDndu1y/95GHJYapORekA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cLneQcWD; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cLneQcWD"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-451d41e1ad1so25803345e9.1;
        Sun, 03 Aug 2025 12:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754248262; x=1754853062; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DZGoofDL/+Drlf7goUQdD7nprWB1U8kykjfu61KEsJM=;
        b=cLneQcWDOXADGLh/KMpRgoRfRG3zU+Nu4LrReqxeidapZdB9bgBB6lrINAcqtkCJwu
         m+8DkVn0+lm1jS5x2FwSm5Cc68rHhXUrWd8ZQNZLK/Qb1j6FH+BfF/Gh4F+5zxH/Uidy
         +1BrDrerhPva5CCHWBsZqfdDymvtF4/LNkGPuyxiXstiqhbMr79jHoHVDHcrPlXmV0TO
         8aumXwBy1Or+Hm8JDIkdGx5y6tC07Zl7IngE7LswcM0wtmY5Bwgj4Ky57yaQEwxFHsIf
         QqjFIfqx/2Zm3JTUm0f1jgZLpwQgTEMaqW96ipkbR8qtQA6hvbnH+ndtWoxj2wM8QXe4
         uAzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754248262; x=1754853062;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DZGoofDL/+Drlf7goUQdD7nprWB1U8kykjfu61KEsJM=;
        b=Qh09qieZZPDpo14CSayTqMZduGlkpgW2bGIxUmYRVx43jeBLRczuhvUFvobRJCX6QR
         4H+3fnoC4uZLF67gHLwP+TXEB5Y5dbJJo/JUionAm0Z+3HoQ1EuxclReqVnE9+WPC/6P
         d+Mi7SLM8nRo/HnGvBGP2U7r5a2ea8Mmq2H3X3WCWhYPDGaGaSlJUeu/i11kLmdAL+BM
         +c3Ve6E7yxsKD3IwMtrWBsseRv6e+7mBl3gTdyJplixffebMDpndhp7723buxuuFLYQK
         cmstV9XkDT7v7nJXzJqLKZZYvwFlScWaj7vunyFa8Do+qiYjGmgr2TAEqJAXRcaV54Lo
         Njeg==
X-Forwarded-Encrypted: i=1; AJvYcCUX2r9zI3RN9Lild6iXwht5RTdxOonz/5CwrsJTvv/HkNZR1YZc6K0KCeHE9MeY+L9oFTZlCd2mfhd7yyew@vger.kernel.org, AJvYcCVqe2yED0ISA9Daj1B5dkBRBwyZxnnHUd/UaTlTTz0EhBzGypltXd/09nucR95P4aR5/olR3iGdttH4OwA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwH2MjbiTeImkDftbdlXoqcJ1D8bBMMLRWs/5njlcf5hEiWkAuO
	rkQ5Isirpa1vs+UJUsDMD2hEzdoLFxjd9+l5HKGgi4tR/vG8wkS+JGsK
X-Gm-Gg: ASbGncutMTj3tQ3ufGhRNQRatqwHBdn+t30WfboJl9hMMULLrEaCAHpn2+70ooXxmUp
	e3zqyCw3GmzUpDUMh2o097U78KthMHKpnwdmtwuwMOvXLWzOzd3ema22XBh5vbgB6g4BYbiKuRl
	XlBEB0ghALpoHqc42q2/+BC5I1BNKprzCnPAcIhrRDOnK755WNq3hQrttf2Kp+6uQrOC6nDlBTQ
	HO28YkIWu1SMXovQPjRzBbLbW65ir2OdglRF1kgZJz5Ot0lvSicMvSXR6qjEJMTOMuvLndaQHLo
	eVLkXbSP9/YMd/G/SDiyeN3lzsg4xv4gldK8Q+OtpNUsZ6ieqS9k1bkOINkg82DRSijDAKZe/gH
	vkx1HKLJsv5R57KyT58g3hm8MeD5Sk2clQqon8huwP0+3
X-Google-Smtp-Source: AGHT+IGgUWvSHp1oHsFPRY5vogFzYlPyb+X50JGskmXxHEZQ3UsSNv66GsiHuM+9cfxnrA490qRp1w==
X-Received: by 2002:a05:600c:4703:b0:456:1560:7c5f with SMTP id 5b1f17b1804b1-458b69dd754mr58643285e9.14.1754248261562;
        Sun, 03 Aug 2025 12:11:01 -0700 (PDT)
Received: from ws-linux01 ([2a02:2f0e:ca0d:f700:1210:b727:adc8:716])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c45346asm13099210f8f.39.2025.08.03.12.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Aug 2025 12:11:01 -0700 (PDT)
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
To: clabbe.montjoie@gmail.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Cc: wens@csie.org,
	jernej.skrabec@gmail.com,
	samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Subject: [PATCH v2 0/9] sun8i-ce: small cleanups/refactoring
Date: Sun,  3 Aug 2025 22:10:20 +0300
Message-ID: <20250803191029.3592987-1-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series includes only the refactoring commits from [1]. The batching
related changes were dropped since they are no longer relevant (batching
support in crypto_engine was retired in [2]).

This series includes various small cleanups and refactoring:
- move request-specific skcipher and hash data to request context,
  eliminating the need to allocate extra memory in the digest path
- make the hashing code more clear and modular
- reduce a bit of boilerplate/duplicated code

Changes in v2:
   - fixed [-Wunused-but-set-variable] warning reported by kernel test robot

[1] https://lore.kernel.org/linux-crypto/20250626095813.83963-1-ovidiu.panait.oss@gmail.com/
[2] c470ffa6f486 ("crypto: engine - remove request batching support")

Ovidiu Panait (9):
  crypto: sun8i-ce - remove channel timeout field
  crypto: sun8i-ce - remove boilerplate in sun8i_ce_hash_digest()
  crypto: sun8i-ce - remove unnecessary __maybe_unused annotations
  crypto: sun8i-ce - add a new function for dumping task descriptors
  crypto: sun8i-ce - move bounce_iv and backup_iv to request context
  crypto: sun8i-ce - fold sun8i_ce_cipher_run() into
    sun8i_ce_cipher_do_one()
  crypto: sun8i-ce - pass task descriptor to cipher prepare/unprepare
  crypto: sun8i-ce - save hash buffers and dma info to request context
  crytpo: sun8i-ce - factor out prepare/unprepare from
    sun8i_ce_hash_run()

 .../allwinner/sun8i-ce/sun8i-ce-cipher.c      |  85 +++++-------
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c |  35 ++---
 .../crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 124 ++++++++++--------
 .../crypto/allwinner/sun8i-ce/sun8i-ce-prng.c |   1 -
 .../crypto/allwinner/sun8i-ce/sun8i-ce-trng.c |   1 -
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  |  27 +++-
 6 files changed, 136 insertions(+), 137 deletions(-)

-- 
2.50.0

