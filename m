Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2136C2153EA;
	Thu, 26 Jun 2025 09:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750931960; cv=none; b=EPviskdDIU6etU9zP6xyOx9uZlBH4eJzt0DKdKnQmWHN2vhtpHU5bxbezeWan6cucS7IIDvuVHe980AkB4rkgzSkEGmTKdRv0WOvyUFwlML6lBGKAFZalckIhKW/8bRsKO0bpJBzpANi8aHbvIN1DESYeAAQpo1Z5318xIsJG4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750931960; c=relaxed/simple;
	bh=46hpWcPcGG9Wv6bjJq58rxcOTw0GpeHkRsTdMhSB6ek=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a4ieMOO9PVLEDkAjAqF5cqte4OjS5PowEJShIeAO/AtNY0bfrGhEjnLoEnF9gp8nU62OWHOw6HdgH3nakscRoVNCwHKMNficXO37jIim0LiamViFKsZdF4tENngQIL7MPuH/9w/WUr3UyMUYMYbVPf4D2KpTsG3D640nsHlu8Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iYysOHwU; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iYysOHwU"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-60700a745e5so1357377a12.3;
        Thu, 26 Jun 2025 02:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750931957; x=1751536757; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CjO/ptLW3b4rtGhdm7irBfUpl4TyUoEIOLpVLAH9NO4=;
        b=iYysOHwUj2ZqTI6qtRcBLpxb8z3f/E1ibdETNozST6K16SRS5MWmeWVDs7Jn2CqlQu
         xyCYTBEEHlQSZh8jIGNnhDTuNgzdZvQRrLnOGxauH7PWI1/OZZvhLh/Z9CjU1oKXX2LH
         O8rrOka8IEa/NS3p0E/dJrvf6vSmkLw5EYchJIQEfyBgUCn8tl7G4q+3RiZihBBrLvj5
         6e1yLcIZGbfZgGk68yMotn6V3QXDewhR8tI0x337cihV5pQQUne49GSJp4arJe/M3MHU
         pCT2RJ7WS6D9cG4czaTHXjGJO8SH+7ad6z9YIVq9nhyojJ49vB5HsX6NpHICubZOC9uC
         pF1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750931957; x=1751536757;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CjO/ptLW3b4rtGhdm7irBfUpl4TyUoEIOLpVLAH9NO4=;
        b=nG06hdFSfueJcXRwGIsBGCb18vN8B+7tR1EiGVxEt/z4NJD0J4Cp8fcDnBT+UAD1bY
         2h6i3UD/ZzQXPzFTWh6G8zAzFUOWnqv6l26941UCbvRaDnGDXd7Stn9xDPnmBtHlR3tR
         AAKLx2cDu1j1hU9pB3LM4R3MQ+Q4hAr4haGg6Q1H4dyoqLHzMkpBgRWWiNx38oW1AcE4
         MeTbiI4TOTW1mmZ8lE3d6jRbzZyZd1q7RyQSdKNq1muD4s8HjsFaY5z15SokKVAc08Tf
         u2GCwG8WnyX3qvM+WDqK1bmznBUheAS64vKQ+ZixI7lnLIAgaIFoUzE5VLHaG7DA9rr5
         7TSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVdFw7SdGG4ukBRE9i+6ylTp85pUrMv0jJmn/gN/pp9GvTZxPqmFpahpqZ5F7v+32r/JhjW8RVgoaasXJ0=@vger.kernel.org, AJvYcCW1Eh6AlUTZv6O3dwxLg7WotI7fPhoWTXW9EQBKHK+XlVX/c/zPZ9tcZI9ne9g9tpYIncffmuy+MF6PSUwW@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/IEdZz1sMi+1y9sEKoGHFjFo1cKIlsxoF3/PpbYXZBK86Lpj+
	y9dJTPJvZ1j7VZKVIiaFtrPRPUQ0+9lmFNUXXzpi2nWhWEiq0wwXFYT1
X-Gm-Gg: ASbGncsFHrySLbx/U6HHDrJIltyuFUo0unitNPUna0QV25qQ1m+V9GIls0z3y0Et1nk
	jx0MO8NmoXhGM5hmFgEV0rY4cZJTwF6Un5YqeJS3+K44wzekhC60KcpqmXd2JT8g7JaA0lUDxlz
	k4GijA8fS4nVsq6hR5un2ariIxNmD4gxAc3KtnlCM+okMqh1WPZNOvrvKvfhP9i3gxnMESr1cVN
	B22O0cZRbixy0btTRfyUnQDC8QjTtlKMuHANvLZ5SbpnJixAKLkG8HuLpq671xWz8yR/YMFr/hl
	cFfbDgT9OMEPVmDVLMizwug85cEl4Tv82fFn7VEEQpnlmDHH/g5eV5HhjLfRCprt+C3I5N9TKhP
	W1fGLikG8CqoKsR/NjtEtadi2
X-Google-Smtp-Source: AGHT+IFulE9JLwWYfiP6+EbStasn8y1TExIFDY+mxNKb98YrHL6j30fB+s7fixY8YLajpv4J85GFbg==
X-Received: by 2002:a17:906:cada:b0:ae0:54b9:dc17 with SMTP id a640c23a62f3a-ae0bea9382amr639642666b.11.1750931957054;
        Thu, 26 Jun 2025 02:59:17 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c51b:8900:a03f:12cb:72f7:9069])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae06aa5ff34sm1014106166b.40.2025.06.26.02.59.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jun 2025 02:59:16 -0700 (PDT)
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
Subject: [PATCH v2 00/10] crypto: sun8i-ce - implement request batching
Date: Thu, 26 Jun 2025 12:58:03 +0300
Message-ID: <20250626095813.83963-1-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Allwinner crypto engine can process multiple requests at a time,
if they are chained together using the task descriptor's 'next' field.
Having multiple requests processed in one go can reduce the number
of interrupts generated and also improve throughput.

When compared to the existing non-batching implementation, the tcrypt
multibuffer benchmark shows an increase in throughput of ~85% for 16 byte
AES blocks (when testing with 8 data streams on the OrangePi Zero2 board).

Patches 1-9 perform refactoring work on the existing do_one_request()
callbacks, to make them more modular and easier to integrate with the
request batching workflow.

Patch 10 implements the actual request batching.

Changes in v2:
   - fixed [-Wformat-truncation=] warning reported by kernel test robot


Ovidiu Panait (10):
  crypto: sun8i-ce - remove channel timeout field
  crypto: sun8i-ce - remove boilerplate in sun8i_ce_hash_digest()
  crypto: sun8i-ce - move bounce_iv and backup_iv to request context
  crypto: sun8i-ce - save hash buffers and dma info to request context
  crytpo: sun8i-ce - factor out prepare/unprepare code from ahash
    do_one_request
  crypto: sun8i-ce - fold sun8i_ce_cipher_run() into
    sun8i_ce_cipher_do_one()
  crypto: sun8i-ce - pass task descriptor to cipher prepare/unprepare
  crypto: sun8i-ce - factor out public versions of finalize request
  crypto: sun8i-ce - add a new function for dumping task descriptors
  crypto: sun8i-ce - implement request batching

 .../allwinner/sun8i-ce/sun8i-ce-cipher.c      |  90 +++++------
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 152 ++++++++++++++----
 .../crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 140 +++++++++-------
 .../crypto/allwinner/sun8i-ce/sun8i-ce-prng.c |   1 -
 .../crypto/allwinner/sun8i-ce/sun8i-ce-trng.c |   1 -
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  |  84 +++++++++-
 6 files changed, 327 insertions(+), 141 deletions(-)

-- 
2.49.0

