Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795752266;
	b=giMAPUFN5u4I+pPleHTyxTGTV5DaVfcLWKBVKrJ929c6KN39Bj6mMxGhz0B0oIt2O21j
	 09wEWrIBQarUAAz65C+98VSSKS3rkIVNX6NfRZeILKAaYMbFaOCDQs1pJIRu6wIte2B5c
	 0rhdmo4/Y8KPorHZLO7+fpBtnOUZxdCh9vvvgZxcfVWOf9Y1J4xETcCIxpynfunpYuZcu
	 E/ABaqP+kgFN8Ii1fmJTJdXEirkyNYXoMLC30fHKseofOjuFgJTX49LE7Q/JYkVscDynV
	 lGbGZTZ012qkdehLQwbsSESCRNvoI1KE8BmV8Jd3BxkR1cdutypDWr18nT3Tkp+QW3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795752266;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=LbxMa1lkUzXe2xXXulg7AyUIjSkSmPr6yxuVYcSBcpk=;
	b=Qo4zDJWF2t27DtsY54QQBc07soJOMmIoineXC5iEoVgwzk/iCwoEVz+/lisetEyVlll2
	 nSCYv3ZU5bT/jcC5Moo7w4bjnhGap+HHySW+P5T0SxPc9NekFggtU3k3kkheIw+MRlUb3
	 rv/EiN0kNkLBqDf04OsHNGbctGAFlMGeIm548tyeI2X3Ith10t7/yxPFamJk4cYF9MxDV
	 3w37c4YdHHBUhxmiYVlYD/V2vkH6EpH1dlOTKS7lcwVOeOpYWJxmnQF8ErLmWxMd+fJwi
	 tY/df3kRVkea34ZdKcj2iytMC3HMqT9pxrHPebA8zow4rG9iasOSWgsaVqo9ndJo6HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WrtXvWtU;
	arc=none smtp.remote-ip=209.85.215.176
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2479D606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:04:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2479D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WrtXvWtU
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cdab8873d9dso3635343a12.1
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 20:04:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795752265; x=1796357065; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LbxMa1lkUzXe2xXXulg7AyUIjSkSmPr6yxuVYcSBcpk=;
        b=WrtXvWtUZSm4yKsvQ0MBko7R5mqjX7LEFBsxjVVikXzmT/8keeVg4oKgTSfw289Zt6
         cUngIPdN2JE1s3cvoomAw+5ETsPFCDONKFE7FwcRNREM8WZy8G2JCEnAG4nqysk9B1T8
         B8KIHFOHMu7C4XaUBJG6fNLxiWlh/q/3InRRGwSGWJ7uqgdU6QhPLMhaRwR0YKnYFyal
         4draYkIKqDhHItFq98p6xAUPouph+05TeJz2iAD6WnNNbLGINJSojcTfRduRokEx0Sw5
         bRlu9f2Q2XaPxwm5EqtBmOQXOYgD0CRyWMZuXOhvAt2DPFq/i2+0iOeSc/cosBEENGxX
         z3sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795752265; x=1796357065;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LbxMa1lkUzXe2xXXulg7AyUIjSkSmPr6yxuVYcSBcpk=;
        b=b+FFdXOU5Rw40MUOFNuDChIOlMW3G+1ifWDu7NsoPmc7xC5PKeS7wTcBWTmDgHXh9k
         RDN48xXn4KkbjL5O3JDvOSeMnam05VVnstkBvnG9D1VDj5b4CHmqe/3db0vhguBtLclp
         6mrucBseZpr//anZMb1m2IvERwPdtNOr5NX78Kde3IY5ZlBRemv8lmAc9gTxIuXUKU+Y
         RuAUUyhekds6IH+rAsoXBewdedopTHNT2Rwrd3L9Sc48FpvRL7crlhXEmbu8Wloch1QA
         CYSm7vsmDyCv9yI5+G0EH0I5CUz3xzB4Hp9ZvnwLgMZkx6xo4ggmDrJxP1mpL7+sIuXn
         s1EA==
X-Gm-Message-State: APuU4Z9BuWvEnETsrTLSaiNz1/+BS6sifsx4ESFUd4UptMI3T9aQVK1r
	GzqiYk0GMOhqxXYetkZOBIw/pT4QRJxGIR9oEPpkBroqsm4/RxKpOXJkihoQbA==
X-Gm-Gg: AZFdTZcLBi1Jf+8vdKN6tXI/rw5LyFNxxDxhHBrAShtmZL3kgLeYm4cu2tBN5NqdgSs
	Y0NqZfyBwOK6gga8uHKT2oXMNCLRL7lsEdDfpSjoGjN+SD7rXSTAqH7ODQMEHGydmaNoSnGcmj6
	LZDZVCFoPS5Q06L40csxP6kIVXAdFivqvVC/JD38FSBjN1tSJr87NCpjcERdMR/+lGwIxRhywZV
	X2nx6EDqGTemciWNdM9tDEKELB51yfuvWLKXLHu6Or3bWeekARzB1OR797xL8/AgeDC9CTTnJvK
	iWRcl7Adwhe37zP7vMMvGLaox8abwR2LWssENbf0YAyx/Gz0/hLh1UWjuJw/Bhna1mJSnSQKvQH
	J9zGBVsp/+PrkQCmZRSu09FJEK6AQIfmN5hjKrAJFFz+olalqe2RxDhkPi0OEZFAx9l1NqaXGMx
	lyDO+6CCblWrL3kVRrJnEKJ0DvnrkcTWcISu1jd9RS9+k/RUk155SglR0p7nc2JTpYqs2FOxDW/
	Xs1Y9MQj/YmJuWEDIEqVq0SLXA3lTfjnxNXFHIZzDZtS+AkVH2Y3hUyq6wUn1qU19+xTgzObtn8
	FsLZvegDUbwz9ErV8WtXJf8A/HPxxx/YziAXOsIJs6qGPPajf1V7eeeVNAwlwqi9ObGEVAKHXU5
	eNVMrz2ibwOHqXx8rIABfAp9xjnhZ+Du50/fJRLjIHk6W9TofscrefxFVYSpSYfxmG9mp0InMUY
	orGA==
X-Received: by 2002:a17:90b:3843:b0:3b5:29e:11b3 with SMTP id 98e67ed59e1d1-3b5029e144emr5892484a91.61.1795752265282;
        Thu, 26 Nov 2026 20:04:25 -0800 (PST)
Received: from ryzen.lan ([2601:644:8000:37f::e34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b457a58d04sm15090652a91.0.2026.11.26.20.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 20:04:24 -0800 (PST)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	James Hsiao <jhsiao@amcc.com>,
	Rosen Penev <rosenp@gmail.com>,
	Christian Lamparter <chunkeey@gmail.com>
Subject: [PATCH 0/8] crypto: amcc - fixes for the crypto4xx driver
Date: Thu, 26 Nov 2026 20:04:15 -0800
Message-ID: <20261127040423.1023233-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.56.1
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

These fix bugs in the AMCC PPC4xx crypto driver (crypto4xx), found while
working on the driver on an APM82181-based Meraki MX60.

Patch 1 fixes a typo in the scatter ring full check. With it, batched
requests could overrun the scatter ring and leave the engine parked on a
descriptor with no further interrupts.

Patch 2 adds the missing DMA barriers when building and completing packet
descriptors. It also clears the stale PE_DONE bit of a reused descriptor,
so the completion handler cannot take a half-built descriptor for a
finished one.

Patches 3 and 4 make probe allocate all algorithm wrappers and set up the
TRNG before registering any algorithm. A registered algorithm's
self-tests can start on the engine right away, so probe cannot safely
unregister it again when a later step fails.

Patch 5 stops using memcpy() on the cache-inhibited SA and state record
pools, where its dcbz takes an alignment exception. Removing those traps
also made batched requests up to 3.8 times faster on the MX60.

Patch 6 fixes the DMA mappings: the source was never unmapped, the
destination was mapped and unmapped with different directions, and
neither mapping was checked.

Patch 7 fixes the inverted AEAD error ratelimit, and patch 8 wipes the SA
key material when it is freed.

Patches 1 to 6 were tested on the MX60 with the driver backported to an
OpenWrt 6.18.64 kernel, together with the first seven patches of the
follow-up modernization series. The full crypto self-tests pass for all
six algorithms. A test module comparing the engine against the software
implementations, with random lengths, scatterlist splits and in-place
requests, ran about 4 million requests without a mismatch and exercised
the backlog and ring-full paths. With CONFIG_DMA_API_DEBUG there were no
DMA API errors and no leaked mappings. Patches 7 and 8 were only
compile-tested.

An AI coding assistant (Claude Code, Claude Opus 5.5) was used to find
the bugs, write the fixes and the test module, run the tests on the MX60,
and draft the commit messages and this cover letter.

Rosen Penev (8):
  crypto: amcc - fix scatter ring full check
  crypto: amcc - fix missing DMA memory barriers in descriptor handling
  crypto: amcc - allocate all algorithm wrappers before registering
  crypto: amcc - set up the TRNG before registering the algorithms
  crypto: amcc - don't use memcpy() on the coherent SA and state record
  crypto: amcc - fix the DMA mappings of the source and destination
  crypto: amcc - fix the inverted AEAD error ratelimit
  crypto: amcc - wipe the SA key material when freeing it

 drivers/crypto/amcc/crypto4xx_core.c | 237 +++++++++++++++++----------
 drivers/crypto/amcc/crypto4xx_core.h |  24 ++-
 2 files changed, 175 insertions(+), 86 deletions(-)


base-commit: 04cd6899aaaeeab82afb97e58eb8619fde35b47d
-- 
2.56.1

