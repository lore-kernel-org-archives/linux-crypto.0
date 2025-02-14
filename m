Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC18D221D9F;
	Fri, 14 Feb 2025 08:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739521146; cv=none; b=A+w9HAigZV9Gjs2wjgzMw3fbGY5wfN9Q/Tp3Cn+Ynig8XvVGRdqKh/pac9+nl/GlbrE1KuhyuasibVMWMjBWZizenK2y1AObIWFuC3Gd6hjJZqrG0PZ3Divbuj6Z45Q84hoPl/UIjI+jPKyGBlS/LUAgNnqwFcCo5gtdhI0xOfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739521146; c=relaxed/simple;
	bh=+YRZa9GQMBvxCO42bZd2rPCKBHevSnFiZVRhYz/Twu4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qe7yiywb3HIu+r/WQ4Bzs3eCipMfT/o1WmtF2Frtk2anWAujsaUriQtFCOTmsorcpUA+zUZ467EagwiKiTwoUJYCBXB79xuNT5ka2SbbsdJIecggD0l0TPrTd95fHWaoXjY6q/UH9V9F6wUW2uICE15CNFgnMoeOSkaB+2D9JnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lVF7Gtte; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lVF7Gtte"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4396794bfdeso5241205e9.3;
        Fri, 14 Feb 2025 00:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739521140; x=1740125940; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LbVa8HDmySOLzTxdp1rm7fHbF9zRW7+16BI5omjFQBQ=;
        b=lVF7GttePDH4zpQG2F6wt4G/fcAfDK7keoGZ8sJbC4ZdQA27LLTT7gzXsHdVQ2cOKA
         E3xTwBsvkss4GZLsrYEyIrwgEptAmiquMUgM5k/w+r29BJ8JTNPWvBPmSunhtiXRRKD5
         /ElUE5e4L343sdLbPCXF3iW/rCj0Aa6WpTPQ7X+lfIpuOZ0dPvGdn7VZkMvo/PXU6FI2
         k+zto5fp4s3rOftJwbryr1XmNv/IF4STtchZwQpohMjjDb9cQYIBEB1XYZ8swQ2hLgmv
         8Zh8AHhvKoS1/0/PRJCLcWbxqLNXICmlaUtxFUCzCGoILpDnN3evYc+/Wg/W/lKLINrm
         0z1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739521140; x=1740125940;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LbVa8HDmySOLzTxdp1rm7fHbF9zRW7+16BI5omjFQBQ=;
        b=a9qQpTbkYrxk2QywB5AdKbRcTiA64Y3w1Qy4NIVPLqaKJ1zLcz4CcrHKBDjOZ32yLp
         rmNXCJgabvgWiR5n42/97LTDcYzMZIBmRemJuvj7S2NSR/wfBwbSdpT+Tt9ulVbybF8f
         idjdlArsX9oyv3P2FVTEjGDXAbgHAXlOqOfKAaRG4EjocU08nRS+rDDqox97OTvPEQBo
         USC9MvsJDE2OutnGur5Hl+C6Kl1Da7JEXIYFH32u9TfvorvcDgHQy7fMjWUCH5QnGzHu
         tLBrb3SDqChn7bZ785MXrFHu/Rh6SkOIzz6d9B2uAmU4hjsZkVqg/Qcl462ZxyN8tXTR
         fhgg==
X-Forwarded-Encrypted: i=1; AJvYcCUL54b0pDN9kfRugIzLG1Vc6WayomaJJVB1bDQXCiwKpGpK97HylJns/Ia6hka5B7oxwbt3sW0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlwFIfwsTSFwFEPlUDAxVjBSkGkeBj/P292kmhlWdGIEK61YE0
	NzDYtMD5rxZIuC2Mby+XHdBmMIdp9IF5Id4aFUAh4PdHsz10cpBu7bStW92amsqNAg==
X-Gm-Gg: ASbGncu3AG5G1d3GNJm2FMQJB/6z/B+LLcrwHuNOAZjjKdIlAzDK0G7vzLhp7fhf6bd
	CTjW8HSJ43aI5zQ7L+4Yg9nU/TOhHMJz77uZn+vL6LtFmLIesuZP7mO0yeC1MmXz1viBLnRJpxf
	9554dnEfAUw9h9zWuka/UNvLTVpeeff2nURX1hNT7nl1MO1KIK90ngYSanI/OYjxf8c6RYS82fg
	gtpS0p4MEChwa6GEYGPpQTSZaUOvNvUboqSHQ7oHt0ORCSG+EAritZ/2jQJBqdzL3xPGi/HYOD8
	/0AdqJ7EwOcYBkzA+y6m/JIjiYWw/4wMpCmaN3LsRm8Y2SgKwrtvqO9j+9cLjTFmWSHHeZ5210Q
	IVVSxrNAl5Bzs+bo=
X-Google-Smtp-Source: AGHT+IGyXZdWdSWqRimzmSMnbhS5myJ9fXPKRG3aOdX5uBZS03JahStAbbfxW7j2lDOXI7yxVWNY9w==
X-Received: by 2002:a05:600c:687:b0:439:5aa1:1ef2 with SMTP id 5b1f17b1804b1-4395aa12228mr98087905e9.27.1739521139878;
        Fri, 14 Feb 2025 00:18:59 -0800 (PST)
Received: from legolas.fritz.box (p200300d0af0cd200c9869c6f52eff023.dip0.t-ipconnect.de. [2003:d0:af0c:d200:c986:9c6f:52ef:f023])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4395a04ee48sm69409735e9.3.2025.02.14.00.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 00:18:58 -0800 (PST)
From: Markus Theil <theil.markus@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	akpm@linux-foundation.org,
	Jason@zx2c4.com,
	Markus Theil <theil.markus@gmail.com>
Subject: [PATCH 0/2] prandom: add crypto warnings and switch to new PRNG
Date: Fri, 14 Feb 2025 09:18:38 +0100
Message-ID: <20250214081840.47229-1-theil.markus@gmail.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series builds on top of the series:
	"prandom: remove next_pseudo_random32."

With the current cryptographically safe PRNG in drivers/char/random.c
fast enough for most purposes, make annoyingly clear, that no one should
use the prandom PRNG for cryptographic purposes without known about
this.

While looking at the prandom/random32 code, I informed myself about
PRNGs and saw that currently fast PRNGs with better statistical
properties than LFSR113, which is currently used, are available.

Recent alternatives to consider are in my opinion:
* PCG: https://www.pcg-random.org
* Xoshiro: https://prng.di.unimi.it

While both seem to have good statistical properties, I recommend
to chose Xoshiro256++ here, because it seems to be even faster than
RNGs from the PCG series.

Furthermore, the authors of Xoshiro provide a small RNG named SplitMix64
for generating high quality seeds for the Xoshiro RNG. By using this in
the default way, no further seed checks or state warmup are necessary.
This simplifies the PRNG code IMHO.

Markus Theil (2):
  prandom: add usage comments for cryptography
  prandom/random32: switch to Xoshiro256++

 include/linux/prandom.h |  30 +---
 lib/random32.c          | 351 ++++++++++++++++++++--------------------
 2 files changed, 180 insertions(+), 201 deletions(-)

-- 
2.47.2

