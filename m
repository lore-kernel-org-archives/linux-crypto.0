Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DDA23ED5E;
	Thu, 19 Jun 2025 12:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750335854; cv=none; b=CxESuq8ganRhYwUsJoSSmR2OW7rCTjcLOPtf9Gxw454wyedoB77bTpWIylh6+ty/KQm4Z58Ti9YoP6vpXvk5NUAPhnzVW3YLDh74ntuwCfgz2kWdEgtBo12KQno158Xqu9NtUD73aHUJ6AwMzhRDEonfLbsY1saKNDJLsTmGCqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750335854; c=relaxed/simple;
	bh=kF4mqyMuFNETsSBSsiMuZaX3ir9TKuI7/fc7yO4ctGs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IAfmFLLrWu+6k7lbN6BrmBjmP1IfuZ3oskE/VYWF31DzWqFPvGyciP2BNnggwEGji87NaDWijVStLyO24mRbIzlUIB2ZpUont1DnvRdQxcsI1xhhiL5HqCwPHh0FHGy38kUcYbt8jv8j02kGWD/HUNL20Zz6gB0HOK0Kw1Casfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T0kwcjSD; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T0kwcjSD"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-607c2b96b29so1239183a12.1;
        Thu, 19 Jun 2025 05:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750335851; x=1750940651; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CCfcfq8X1qJYhuZKNPdQznstE+FhOnktsIaudCrihyE=;
        b=T0kwcjSD+juQ2WZLBu3RIlOAVEQicLfcSd026l2+SpUokRtw0NdmQzJxWX1xwFnvli
         /QRX4+5xAPF8UlqOcP7qSvDkkV1/zClCicrEbIGm0x4oMgrEMmRv/HS08FXe/JJv/T59
         mbIIOOJgUHi1BHxNO/hz0wP5S+UYsT0Oht13uKxKbNWngMY8MSF1eLCP5OwOuNYNyGOe
         3/WOGygXSwEUr0ftk0rG/90MG3WOG4GVX7wzH670mqAa7f77HvrXuwaaXb/x8Jd+jbpC
         FInRNWgiAq1tAWx+RsfgfXwXAZkyJEtLHJ2qV+RUrM95FKj/3k/YPj1iHT4EICgASaX+
         xibQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750335851; x=1750940651;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CCfcfq8X1qJYhuZKNPdQznstE+FhOnktsIaudCrihyE=;
        b=jJ1XokyyDDJPAUO+Qzt9grb9LQlDh6DmVSdZQkwmi3IxQAYhofkQ4pHN87ySCa8wSB
         RomzYR5p3ikrTxAeUiLr2KXDWQOw+CDTECJcvrtceFP3sgtH5TncOUuydbU4ZJ2bE2q4
         oYSQz7qdWwHFkEsgnlw1xVgM2pqlbaDEz1tF1IOjMbPUZClg6ErXjWjqWNbpiWg+3w6R
         tPnS4jEuNd/Lc3n/GtPylhE0e0QgpjwmBbrb04KoHBaIcbuXyXdswaL68M18BUrrRJQr
         JaDxoYo5KmbRXyTs7YYeR7BqtZ/EIj6v4Nt0vxkJDFq4roHLTHdxM1wZU+Ulkihhiwl7
         zKAQ==
X-Forwarded-Encrypted: i=1; AJvYcCUv+sQx7Hi3xR57GiE0tjM5+o2rlrrAQVq6MYJ9PiVMJwTiJyrAIKrcfJG9KD3/kiIScwbE/Pmzbs2Y6zSR@vger.kernel.org, AJvYcCWucPlwl7BGhjYYY/W6X9z851FFPs3nMZuIPw9YvitEJJxcj6aTi0UpL0EnUO4TP+ZTSOP7zU7noEo3dK4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCAMNzHh7YPB0Du3EHetKNlfU3VPvE+1LNZB/aEUT/pbhzKFZc
	YRj/l+HzXJo3+KBlKwctA3VHVN6B94LVLQnPJUhR858k/EtXv07MUL1utad5mw==
X-Gm-Gg: ASbGncu4Z8DzOuQCLjrF4gmIyyODaecRnHK7+404gvFtSnWsZ4RgT4oZMNxKKh/YOfP
	gEOMeWB8aoGtviuzMYAeUnNWcJxk9vn2aygGSa1JhS41YC3RAKfgDw0zvoC4anvhf9Tqo1hOm26
	NLBSO8e1GKhtHwMPhE2sceAafLimdnfHxKboj5Irp/q6Ut7OY3vVXrDwN9JIJvo/5/nNYfhHZuI
	cKTT5IVlwQBqLWWsAvmKrrY5qCqEAaFQjvJxmJgelqfhEtWh17/9dyfS2Tkwv5JAW5hwKK06+n+
	63lWLoB05npJTMF0HVbv/fjAjWzSvFGN2bKQlsXvacVu5m2SBLiy51ZyDlGVuk5S2kq+rGYAcry
	+KJdbYqby2leF4Q==
X-Google-Smtp-Source: AGHT+IHUuqtHwS6ePSREPoIXcxb7Gs3mBMp2owjvf/lJwUZbFDI75gzoaIsc4V4vaYVxfg5C/ZKVLg==
X-Received: by 2002:a17:907:3dac:b0:ade:198c:4b6f with SMTP id a640c23a62f3a-adfad364957mr2158168666b.1.1750335850583;
        Thu, 19 Jun 2025 05:24:10 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c51b:8900:a03f:12cb:72f7:9069])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae000b02bd3sm504688066b.3.2025.06.19.05.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 05:24:10 -0700 (PDT)
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
Subject: [PATCH 00/10] crypto: sun8i-ce - implement request batching
Date: Thu, 19 Jun 2025 15:23:06 +0300
Message-ID: <20250619122316.2587236-1-ovidiu.panait.oss@gmail.com>
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

