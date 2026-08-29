Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5694B3624DB
	for <linux-crypto@vger.kernel.org>; Sat, 29 Aug 2026 09:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787995220; cv=none; b=G5q+rfKn2pQPh+CoHu5Q6fQ/GW02LfCdSaV4uM8sgJz5ox3waRKxH1MIV62N1i8anuUFx7f3Ak3Ts2huwE0MZfYedCnololJ8a6/EcMfyNN3a07O3TyZ7tcW6SWxn/4jcXY/GS5UKbTe2sJ6mpgl4WDpf0uhY9ohmjCMymIJtQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787995220; c=relaxed/simple;
	bh=A7A7tfVdIw0fqksy6K/RAQDXSydaakdf38nA9yk7vdI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gwJ1tylfrmaQ16JoA1QOjShz+y4tQe9tpK3DZ0Z7T5FrnStX5hrvXWmzpDJ86kjFxEA/RW/9eYVAYydkIWaChPbHQbwLcHEUZ12dUSN91v8K/zPSHysY2AelKAZzfrjrXkah2HL0Wb4Rr5A2k/YJSWtEom3NFu6cBfEyg4sBeLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fIvEm8gw; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fIvEm8gw"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so19673015e9.1
        for <linux-crypto@vger.kernel.org>; Sat, 29 Aug 2026 02:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787995217; x=1788600017; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=juu7PZIMdibr8mHtJHcDYqhZT86zpDmrpz+TH3//V10=;
        b=fIvEm8gwg1N/7eCEGHNZWLSZ5BOvuMACO60OnZhxw/lwLHPzSuTDs312g95SNbRlUp
         MsCfMl+ZrAqcSimTj2ZXxXceaJddDt0i2vR3yRSLbROBbczgeE2KbfODAK9DsHbLiqkA
         hOoe0ea9Lf5V7hNq2J51qlPxHCeCCLPeoRJhXUN58gwkqQHetr2cq2iAL29K0/XsBX0F
         3B338ECR3tqVOMX18lEdkYmV9M3/Xg5myvdmL5DKI6nAEQ5Yo/BAYQUEIPboSU3iK67z
         yX1HgJlzZEkRvOhjOLtdOFOvG9FLnrwJKLiPkBZY6gKFcovrWn4Dm3wqcDwq7Yf33NnM
         xIrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787995217; x=1788600017;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=juu7PZIMdibr8mHtJHcDYqhZT86zpDmrpz+TH3//V10=;
        b=kFjo8kDxKbuzm3EkCNFwSHVKD0PyL5WdbIaCwanvYq+JldTsMLLTd94VYjioBo/0F1
         31z2tKYDNYPXt/O3q1iFNOrzYRmvlf/+6zl9RNhMvnXA9fdO+AdIr7M/bEb1QOH4t/pv
         N+ANqkKCktfgJ9j0MsLs0dOE72bnb455Bntg2j3DFACNAXvhvVJ39vW3OduGEtkQCfa/
         w5OI+AlXn2dSlIUw+BMpfNvQ4TBzAViTR4PWji/PTR3OlTNriPxN+bIU77EwKVrOi1tf
         uIXNi2ht8U/bkUTZy16l4aJsdH5P/az3fQ0PIvBID/VDRZiLraoUQcOb7j6ARh/Nv/In
         jdqw==
X-Forwarded-Encrypted: i=1; AHgh+Rr+onqW5qfUqRhd1K0zaWGVBn08oMgl7H2yc7BK5koAZc7sOadOEg4tR/ZKOxd2zKJM1uDc833SgUlckH8=@vger.kernel.org
X-Gm-Message-State: AFuF++kBvwdvrYHka1543qPJ8x50pPuyK75L2DRWNK5x6PtoIFhVNlfG
	z8e1n2mE9xkvJ+QSEj4Uv1JletNNjc1Pu0WnBhffmgMB60oSOaZC25aoUYhcCETA
X-Gm-Gg: AR+sD12cL0InWc0ncti+Pxj5337WqOlUXjQzhBilh2bAYwamoT7U4yRV51CEIJdBVYq
	WyQU5c8ISGb/7gDOGX7b8mLEl72tV97v5yrMhwdZD0iN868hqe1pXk2+wtL1zPPvFFGHXS24fSH
	Xwt+Pdw8PiHEG00/PWUosFAoPHSDbVz8FZyW0TDnH/xF8mw8ySKyOJWrMFardzKNo6O8mAG2OKp
	JA6LH1efxEvsKsnB3HsSdDv6CdOYxc5nAHN1ED1m6Cc2Udkrd8JCWuYYomvgCZk7GlpMCsEKGDj
	pxLZbw/XW6cb+X+MaP4nRQewbX2EE51PNrKLQPODcly4zcRJJrxM09u/OCjbWBMho1lJOArp2nE
	+emADVNw3AU7n1+XWc1XZBPDgehyNgWbFUhM98fERLVCoesv7URKD8CJuNqJyh8/O0ZWtRHiuhn
	FKIhIbZhQnxQ7gs89YcX1AP8q2M+eFZqRrfqmFOhr+IEfXqJcGvcWBLotN2zw6+bAi5AZIPJo0p
	qNUHzZpXmVhC2CWfCCSX2Qmulv6AVjzbhuT8egudFlhFr25DGNCw/j+BTwo+HI2TUePq/KnKAFd
	15xQsibDg2HlafXdNZrR
X-Received: by 2002:a05:600c:1d1d:b0:499:ad2e:f7bc with SMTP id 5b1f17b1804b1-49b91c3ddbcmr151221065e9.10.1787995217257;
        Sat, 29 Aug 2026 02:20:17 -0700 (PDT)
Received: from localhost.localdomain (dynamic-077-007-015-136.77.7.pool.telefonica.de. [77.7.15.136])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b91c510c9sm80468505e9.0.2026.08.29.02.20.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 29 Aug 2026 02:20:16 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Haren Myneni <haren@us.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Dan Streetman <ddstreet@ieee.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	linux-kselftest@vger.kernel.org,
	kunit-dev@googlegroups.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/3] lib/842: reject malformed streams before invalid memory accesses
Date: Sat, 29 Aug 2026 11:18:48 +0200
Message-Id: <cover.1787978627.git.kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sw842_decompress() backs the crypto 842 algorithm, the NX-842 software
fallback and zram's 842 backend. Two malformed-stream checks are missing:

  - indexed and short-data templates can write beyond the caller's stated
    output capacity; and
  - a repeat after one to seven bytes of short data reads before the
    output buffer.

The first underflows the unsigned remaining length, so every later capacity
check passes. The decoder keeps writing past the destination and can
return success with an output length the caller will trust.

The decoder already returns errors for format, capacity and CRC problems;
these two cases perform invalid accesses instead.

Patches 1 and 2 add the checks. After them every output write site is
capacity-checked, repeat cannot read before the output, and all input reads
stay bounded. Patch 3 adds KUnit cases for the three malformed streams and
for three valid streams at the exact acceptance boundaries, so the new
rejections cannot regress into off-by-one.

The KMSAN reports from
syzbot+e774233ff687aada969e and syzbot+8f77ff6144a73f0cf71b are unrelated.
They trace poison from uninitialized swapped-page storage, not these bounds
failures.

KUnit under QEMU 10.2.1 TCG, two vCPUs:

                  baseline      fixed
  i386              3/6          6/6
  x86_64            3/6          6/6

Baseline runs applied patch 3 alone: the three boundary cases pass, the
three malformed streams wrongly return success. A fixed x86_64 lockdep
kernel also passes 6/6.

Separately, an x86_64 KASAN QEMU run exercised all three malformed cases
through zram's compressed writeback path by corrupting the backing-disk
contents after writeback. The baseline reported two out-of-bounds writes
and one out-of-bounds read; fixed readback returned -EIO in all three cases
without a KASAN report.

Karl Mehltretter (3):
  lib/842: reject output overflows from index and short data
  lib/842: require a complete history block for repeat templates
  lib/842: add KUnit tests for the decompressor

 MAINTAINERS                      |   1 +
 lib/842/842_decompress.c         |   7 +-
 lib/Kconfig.debug                |  15 ++++
 lib/tests/842_decompress_kunit.c | 144 +++++++++++++++++++++++++++++++
 lib/tests/Makefile               |   1 +
 5 files changed, 167 insertions(+), 1 deletion(-)
 create mode 100644 lib/tests/842_decompress_kunit.c


base-commit: cf72cbb39da84b6f02f90c07f33b102fc10b16f0
-- 
2.53.0
