Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793679262;
	b=R4fgJv/LLmUL/1cBXsR0C1sM19yGPZs+D3c0sGJ9wwuNuT5nKRyrdIwAaGSBfu0BZJNL
	 LexrJmDLTX9lqOgbwL07aa9S8OwsG9dvmC54El7nfKwV9N326eG1y8opoWTFlYV5IhnyH
	 AOXVlJxS5l1Sgdl/vr/VNHvU7N+tBs0rDL08qiSI6vzAPc//iQmz23aN6TgM7Lyamt7QY
	 d82TstvGN4wXc100aXT94cRJoDksuCgBIMFfMZ3z20C2zE3mr7WdhYqber00waf+PoVSU
	 ygGOehRuogEiJvWd2UVNmgGK2gVfAXoEfBGDKEoCrV9hE9A9EH6QZMawAjcfvrTll9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793679262;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=Nj3McratJJ6pEFP0XBRtJ0WdPjrftXOJFNhSnJCxiPU=;
	b=rQgTDQAK3wqdpR+IhvFwVvC2tsrzHj9oqnLhuyBowpc7slfV05UgenY6+ZLrAGD6h7wN
	 R/vvSpcHwBuPxNFwcaqFRndRFJvjy+CfMgjr2OHM7OnG+l3mp9ukrCs6suNT9J/QG1ECo
	 YX+AOqweV19CuNGeRVa25Y6cuvWnSlRX4H3+2TTdQ0VSaHJZNByEGkaWseaLKmcl4lBJu
	 VGzALnyhd9Rl0pQQg7R21SI2CmiHdyWWL/0Aq/7qDwzJkGE0YM9C2i+zybYzaEkNYp72D
	 YWhletjXlwkk+EiRr/QL/v3vXMxl9IjtHk8wEyDpgtwHYEX6vxkZvUmpkQPAty0Utog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bZ7P+a3D;
	arc=none smtp.remote-ip=209.85.216.51
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53060606A335
	for <linux-crypto@vger.kernel.org>; Tue,  3 Nov 2026 04:14:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 53060606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bZ7P+a3D
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3ac451e128cso2327546a91.1
        for <linux-crypto@vger.kernel.org>; Mon, 02 Nov 2026 20:14:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793679262; x=1794284062; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Nj3McratJJ6pEFP0XBRtJ0WdPjrftXOJFNhSnJCxiPU=;
        b=bZ7P+a3DvUJiqy8nxjwt2b63ar5U7DIrlY+60Bo8e+2Lt0UzQ++1cgZoZT0ViU2koy
         FHJzdh8J03Lq/HhHfcmqqKtHGbdzID90L57Ov6xBspr1/t3F4a3EC17m8i4kWwjS5242
         7XcKyewoB5pfq+roI9pQqZMELNPx7AWQvopLgHegGPRJTo9xxNbfAk5jHFqKSgNq45Ov
         au+wgqOlVTGRHLuTCVXOMxZMcll3A1lkYPlhT/L89cMwTD79glZDWvtLsdSbJS9bukHS
         xq4pRd5OUHXRCwJIBsXmgfidfXifYMJWSfNDKtj/BodqoPvTt0hOuSRz6UE4c+nKL/aY
         yiNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793679262; x=1794284062;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nj3McratJJ6pEFP0XBRtJ0WdPjrftXOJFNhSnJCxiPU=;
        b=h9Qcd/Tf02dxmSuMXAX4rfYFHoAC2UmMujgszPjkNxGB+0pwx9M7CV4HPiigaAXsFC
         ZO5V9ewe1Qh6KDcmAF6HTz7nzhaYZzPWyiZfD2ncuufeiBQEvJe7McfnAMSE7frNjBSO
         1mFu0/665vcqPSxjYvg1Zg81YRTLSicy3mWFmg1pZ2NRzsMTM5o1PoXANppQjGPnLbUY
         WK4h4B4C3BGbHEZDRu4fL6NGCuRQLuHNGcnAm5H8BYjiVNBpJM6zTKAnANMICoMtVsPA
         7EwzYr2UlY3suhNANOOv/bShB0a92cd2lQs1lFpBFZ/31JTKO1zrve73QxtqpHaRSiAu
         aiUw==
X-Gm-Message-State: APuU4Z8KpcmhJ8js/U3IzyQF163pyIMnN/FY3M65ASQAPx56a+oSDUAl
	blhQAA7DIBc26DdASRAad5+W17ghOYmkBdtUm8M8pG3B0zN55dlRuHmtNNoBEw==
X-Gm-Gg: AYBFou00oR+RxczpTQA2YJqg4oIwuxSSSMEQjGZ0kOxz2B/7sZW53QpuFJ3ZUcUJrz+
	vLkpeAOboXtnWEQkvTwYSDC7/SCTYxFOqNBS3+uN8h1bDAFD9bRyZAKVYFLeBNZ/LNVe7osTVAE
	F5xwTw097ocTlcuVYR3exnu36Lgut4Iwz8nlQ6nuxS2dWF/q5jHArl6GmyPYu59CnM6Zlzo9AAr
	sc+aKZmo7ZEqq0sY58b5ZFcUMcsCymCKbu7ooJN359NcWwG4lLp+HB71KzS6lAABjSbvfPFNvha
	21r07j2CQMWWqiNDbe9y6WIErdfcKJplXln2RLD4HLujzbIEtx0WVNnZBfJfTxcR1rkFcM7zCc0
	ksv9bO8SKPf5V1UZei8ncABqJ7lDX8DGVkU/cCRxbv3Ptmkl+UMa/4eqtrFWAAd+vscfcEoLyzf
	PJ3zpri2UgHD/C7y5N3I+BfSFn+s+xsAOqZ82kB/7Vu1RNflVCTWXLw9d1Q/4hXowrHjf4/DhJi
	nnkcIbuiBu7XoWyiP6VS6ambhZYJ84JhezU/3L/QKHjRK+OSN83bWyTD9cLc4pY4EwEo1UP7J51
	rBMtdUbLXK19TcJhAWjr3884unX6rT9tA3yaz9cnbMHS7kV9mZgM
X-Received: by 2002:a17:90b:4e8f:b0:3ac:4e18:238c with SMTP id 98e67ed59e1d1-3ae89806287mr9145855a91.49.1793679261420;
        Mon, 02 Nov 2026 20:14:21 -0800 (PST)
Received: from d.home.yangfl.dn42 ([2a09:bac1:7680:28::4:396])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b07c6740a1sm1989659a91.10.2026.11.02.20.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 20:14:21 -0800 (PST)
From: David Yang <mmyangfl@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: David Yang <mmyangfl@gmail.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Danilo Krummrich <dakr@kernel.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] hwrng: histb: fix the FIFO batch timeout
Date: Tue,  3 Nov 2026 12:13:58 +0800
Message-ID: <20261103041403.4071708-1-mmyangfl@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The poll timeout in histb_rng_wait() was derived for a single word, while
the device feeds the FIFO in batches. Fix the timeout, and print with
dev_*() so that the messages name the device.

David Yang (2):
  hwrng: histb: wait for a batch of words
  hwrng: histb: use device messages

 drivers/char/hw_random/histb-rng.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

-- 
2.53.0

