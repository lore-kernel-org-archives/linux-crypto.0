Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9541C36;
	Mon, 28 Jul 2025 06:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753682877; cv=none; b=aRVdvf/N7rBBygSjegj+5RqG18MrHRd8ycs2Ungiou6QxsTaXK8XkHUj2zzRfYnZM3berh3j4O/3NeGOqmdYzFLq1F69YsqbLH+QsYZfCPOlNGBwFMSfgP33AsKpSZhfQ7YSvTqdcLxyThA6scaH3s2en81jqFmaagxB0F1f9WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753682877; c=relaxed/simple;
	bh=Ps2TqZoQRyQLblkSoFX3ufLH04yJchIw5x3kr15RME0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jIi+/BigPrXV4hoVshkVC8+ToYIfBr6k3LCD+nXBmy/wvhkOM1v4W7eCP4uiOnJk5BJnT5aRxRCIfFOCnciPgZSt5peKQj3MC/zr+g/z1IVnvPYWV25AwGfNxl3hxxRkgWpO/tiXr/R9k9hM4GEoKV9zkEbrhjtHuGeM15AwK08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eDcwia7B; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eDcwia7B"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-455ecacfc32so16874905e9.3;
        Sun, 27 Jul 2025 23:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753682874; x=1754287674; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lQRkEBKSX0KDbt2DjDVCCEOOHuJVKF3PYKVmG7o05vY=;
        b=eDcwia7Bx16gxUrgb6Pvzu/2jyV4Z984XdM0w0BcwDcpcGEvSNEKjX3UwW8JlTX9Aw
         QJ2/ikc5WaXdgrwbmuBZc4w7HPIybUnqoMZuHOd0mI64B/q20QYei1fzLT5HSmvJcXo9
         cBYQTrAp8SzJnCM4JIMysPYIVPQ68RftedWF2hVYkXfpv/qj42Fw0vXJBl7pcmhAEXVf
         556zEO8inDc2ndEGDtmiH5OvVNeLWuaMnuwg8BAM8B1EjH0PllsvBAO7YaMXNJTJhUyk
         ryLVQ6FP5pbsl0yZKoa9mTJuVA+eNR5ydFlXYJ8zqrUI92ckEwBFHbv/AVKT5HeqZ/NG
         8HSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753682874; x=1754287674;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lQRkEBKSX0KDbt2DjDVCCEOOHuJVKF3PYKVmG7o05vY=;
        b=dimhv7np0B0xAQ5ycwMLKFoxq9o7fuW0hPFDoKzKvEL9wvJLLjJuHSPvhlQDUjLrbO
         bYsX5Y2YyO8XlAPCZ4VPLCPsd0bbCTVr9axyOyTn2I8gjiRJ8rGkqGKkkSZdbbQ6I3qH
         z4h2rRTpPXVDgtC6/o/4+KOrJyN+Irg0KQHnz4Gphe8WWvYIgUBT74CwYj0WQUc+lpbB
         OOz7oL7EVeZBwNO+ayGz26SFX0Ohheri89rCs5Mc0EoefIdzWLgIVdAMkkMntQkALdb+
         WckiMZYLbohY4xldmyxV9kLcYjEIbeSt4D6TGnHjF3leLb7mNlGi+PZFyIBFhxS0/nx9
         4WRg==
X-Forwarded-Encrypted: i=1; AJvYcCWvSjoAbM23a/LoaJoo9VP3jp1/qfUpnb8EmnelFxk1ARCj/4f4x/3qYik39yDXJtoiE9IQ3Y6gkaIluXg=@vger.kernel.org, AJvYcCX9Up0+AxdqHnZVTujU39KN49Er/IqBBW+IFzIGUno2gIBVfKZpaxgHXSu1OKxdhTLlFVEbw3NyiPUEcRkf@vger.kernel.org
X-Gm-Message-State: AOJu0YyKamNKgzy90x2KBVP1ivfEP8aNN47EjXLc5tduQSJxL9p0r1Ob
	oM7oupwJiNV2w9BMIXBCHQgeUhxWaGoo55pcFWfdsjx/P1so7/vBH+dm
X-Gm-Gg: ASbGncscRfU8FxWMgBMnJciDHEgatFOevFjUq4lVf7qdBvgT70ENNC8yAy73/Ca8ALl
	3N+vzSxd/UF7kN5CIopPg6p33plFZGJJmzCU1D6aT/A1Si/WvZce59E4fzjKh43L3H94NH4+n+s
	D1pvPDXDL2ju2tTQnmhAdpOEH6son348q0NHfwOAfixD71r+R7Oy+xnlGY9ASFV09JXBoBWEeY1
	f1V68lrRnASUhf4tsGOlKH1LvlgevN15r74rem28TpciNArWa55les/JfX/DQOQVXGjZC9Yr2uQ
	hORnAHbPqWid/Vqtvar1Z7cuffHmgB0gQceIPx7y55WIhzGtnTCfQd+jWjTAMlfYPxFzdSD8vHi
	KH6O/fx+wwK/26wW8tUodnEBydYnW7lXGnA==
X-Google-Smtp-Source: AGHT+IF3AC+lhboN+bDd3GTIQsZ/ijxMvRWFI70HfU8zkixbqEtidrdFYobTIDcSbPLWc1dA/skPGg==
X-Received: by 2002:a05:600c:1e2a:b0:456:2832:f98d with SMTP id 5b1f17b1804b1-45876556361mr80069655e9.27.1753682873906;
        Sun, 27 Jul 2025 23:07:53 -0700 (PDT)
Received: from ws-linux01 ([2a02:2f0e:ca0d:f700:1210:b727:adc8:716])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587abe6ba0sm86195215e9.9.2025.07.27.23.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jul 2025 23:07:53 -0700 (PDT)
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
Subject: [PATCH 0/9] sun8i-ce: small cleanups/refactoring
Date: Mon, 28 Jul 2025 09:06:52 +0300
Message-ID: <20250728060701.1787607-1-ovidiu.panait.oss@gmail.com>
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
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c |  37 ++----
 .../crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 124 ++++++++++--------
 .../crypto/allwinner/sun8i-ce/sun8i-ce-prng.c |   1 -
 .../crypto/allwinner/sun8i-ce/sun8i-ce-trng.c |   1 -
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  |  27 +++-
 6 files changed, 137 insertions(+), 138 deletions(-)

-- 
2.50.0

