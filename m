Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F43412C12
	for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 08:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785228243; cv=none; b=NnWGXcTQKNMyh2qZwTPYduqacTZQdEnx35eHwIDJBRmEowWw79P9hPpR5T18i4AQZuaOsRrvaJzho3/6RnSiRzN6vgdjkddxuKhPHOBWywMhPgyAAcB+TiKNVVqO2eYWld6rmp6mPDDGNXXf/eUkkv6JBymxIKNdflvuUWlpPzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785228243; c=relaxed/simple;
	bh=jp4Y6tcJCsJWUkScDH2RHqBQ6YMvU2jysVSUdtNO0B4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uKza5j4vQAkiBDDLPlE8WwIKp0iQwtvLwO0g7C5/kXKeI+gY9u6IeUUXjEBcYfDYbk19cjNH+AQ3DeKCdnhj5kU3Xvo98q7MEQ+VacjuAQE0YWnf96Zb3+HdTtMEzJeKhlI/jVa5Q8Kj9WkfEqUX1LSY1xOYMcq8orQwQc2t2K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=smd6tbyt; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="smd6tbyt"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2caced6038eso10336385ad.0
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 01:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785228241; x=1785833041; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=70LqV3/luAFBvmBuYaVNPXmxylm486imesYHKbBesIU=;
        b=smd6tbytwdWwDPTUVw1OjVAHbAH/SPPR29eU80Te5XHB5M+vwnZAgdpWHHyKQeDhDN
         399Zb8ATZuGnUYEAhwzQqoD2w7KlcDO5p9Dk0xxtY7Iu5jOwJ/4vg8nA1BRVYX6Ne2t7
         DtQgRQILOD66EIGKELA0HaJD8tt5TgVYGRQb067jZku4ad94zzbfNNCNTWtLGvF4IokI
         c7HpoLzUCS0WmDu/Wy2qpmf+Tp8Dy1ej42mDklMS44EeJNMDY6iK5q5gIaj6grxgNhcu
         SlekTYRtI8cu7bkIh9veU3C2I+DdSNC1wK+lojlahEvhnVtvN74c8jkpiQziz2mZDHf7
         ji6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785228241; x=1785833041;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=70LqV3/luAFBvmBuYaVNPXmxylm486imesYHKbBesIU=;
        b=MBTa+jbsxAFaAS4bFd2PC2in7nEvPv9K8u0B3fM4he2asdMx0EA/IXywVYIWnkBNzD
         ujsuSCfQQXQXaiaLIBLmyfbpNpX1fyc5oto4XfJozwQsG17KV7gceBzea0rUahQE2W0k
         SYGOfMJerIzr0SPifxCU7QTOFXsCb5FiJbhQYGVQFEOtar8Q4SGcxzya7BWwSqNzTW2A
         I10u1oAokiCx90Ct7DvQQdsK4e666Wi7QcuEPfsZXYEnvTMmBOJK70C85olyrHQpYvNL
         5DQ3FxkbG44teDg61ftyaYVJkhXtfQZoIvpOssBKodDrIg2JQh0FqVY8wjmJ/lCw9vVq
         W+RQ==
X-Forwarded-Encrypted: i=1; AHgh+RqVhiK7ZcUXMZdBdFeVt+auAWGVNvREF7r2740cvhVWMizWTCmuwWbDGo4+y7HUWpqihqUdv+l7TIzO54g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRpJx7e8eXJQicz3DC0RcuZTVtZ/Gj+32hD1ExHhzTiDM8RoFK
	Auu9IDBQwChD4VZVkIQ70LDiNmDtLmtMhwaaXqsdimKG+bLdRseCdQGT
X-Gm-Gg: AR+sD13DXD62fZZpUuDRP9JHLyxBg760SC3ezprz9DmCzUMpX0wcljDtyrV1zrEvxAs
	0CShjHozAUicjsvrFhgWDJliL5ikExGQOyjlKLV6cbaIhajWJoRS6gX5t51EwjTCpEKrXgEPpN1
	Yvtf/qAie1D81D/QivQmYTuDg1H6h2tbFGPEGYdTdRcckqN25GrpSEvYVPVuR7aVvunLcd734ah
	Dou7PM6IJWArQM3KYD2HkDIdQfBSuCltQExqWibgOviGsO2lz2YWt6kmJoyfGTy5SqBAIYbume1
	9WnktXDFeZQOBy3xyu3JTrt/JtDrf3AK++FIx64yNTeUEZd7MgYFLiPwAtGuVgrS88vSBI1ibPW
	cDjvcefzvRDDNqsHJT9Up8Te/LQ7cTUTX3X44JGH8gnyu1iTecZYhInMcqJGJvIRBzVgOto9nci
	5T
X-Received: by 2002:a17:903:2b07:b0:2cf:461a:3863 with SMTP id d9443c01a7336-2d015ee5f1amr16234005ad.22.1785228240978;
        Tue, 28 Jul 2026 01:44:00 -0700 (PDT)
Received: from mincom1 ([175.235.236.1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde7bc585sm48168505ad.51.2026.07.28.01.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 01:44:00 -0700 (PDT)
From: Jihong Min <hurryman2212@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Christian Marangi <ansuelsmth@gmail.com>,
	linux-crypto@vger.kernel.org
Cc: Jihong Min <hurryman2212@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Antoine Tenart <atenart@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] crypto: introduce generic dynamic software fallback and EIP93 support
Date: Tue, 28 Jul 2026 17:43:28 +0900
Message-ID: <cover.1785226804.git.hurryman2212@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series introduces a generic in-kernel Crypto API proxy for dynamic
CPU software fallback, inspired by tcrypt's in-kernel benchmarking and
RAID6's algorithm selection at module load time. It also adds support
for using the proxy with EIP93.

The recent QCE discussion [1][2][3] makes it clear that a crypto device
cannot be evaluated solely by whether there is any performance
improvement over the CPU software path. But at the same time,
performance remains one of the main factors.

Crypto accelerators generally incur submission, DMA, interrupt, and
completion costs. Legacy devices pair those costs with lower hardware
throughput, so small requests can be slower than CPU software. This
series lets drivers describe algorithm groups that share similar scaling
behavior, then opt in at runtime to dispatch requests only to the
implementation that provides a measured performance benefit. This is
possible because Crypto API requests of different sizes have no
dependency on one another, allowing the proxy to select a provider
independently for each request while keeping each stateful operation on
one provider.

EIP93 was chosen as the first target not only because I own and use it,
but also because it illustrates this problem. It still improves
performance for large requests, yet it is much slower for small requests
even when compared with a relatively weak CPU by modern standards, such
as the one in the AN7581. Community patches such as [4] have previously
addressed this with a static size override for AES only. They provide a
useful workaround, but neither determine the crossover point
systematically nor offer a generic framework that is easy to extend to
other devices or algorithms.

The control is exposed through a per-crypto-device sysfs "enabled"
attribute and is disabled by default. While disabled, the proxy
providers are unregistered, so newly allocated transforms bind directly
to the hardware providers and the existing hardware hot path is
unaffected. Proxy generations that still have live transforms are
retained until those transforms are released.

Adding dynamic fallback to a driver
===================================

Select CRYPTO_DYNAMIC_FALLBACK and the software algorithms used for
benchmarking in the driver's Kconfig. Define a crypto_fallback_group
table that groups hardware driver names with similar request-size
scaling. For each group, choose one representative hardware/software
pair and provide the benchmark key and parameters. The
CRYPTO_FALLBACK_GROUP() and CRYPTO_FALLBACK_GROUP_AUTHENC() macros can
be used to initialize these entries.

After registering the hardware algorithms, call
crypto_fallback_register(THIS_MODULE, dev, groups, ARRAY_SIZE(groups))
and keep the returned handle. Call crypto_fallback_unregister() with
that handle before unregistering the hardware algorithms. The framework
creates the per-device enable and group threshold sysfs attributes and
manages the proxy providers, so the driver's request path needs no
changes.

Benchmark method
================

Whenever fallback is enabled or re-enabled, one representative hardware
implementation from each group and its CPU software equivalent are
tested at these request sizes:

  16, 64, 128, 256, 512, 1024, 1420, 2048, 4096, 8192, 16384 bytes

Each implementation gets four warm-up operations followed by eight
measured operations. If their cycle totals differ by at most 10% of the
lower total, both get 16 additional measurements. Equal totals count as
a software win.

The threshold is the tested size before hardware first becomes strictly
faster. It is 0 if hardware wins at 16 bytes and -1 if hardware never
wins. At request time:

  use_software = T < 0 || (T > 0 && request_size <= T)

A failed benchmark uses T = 0, selecting hardware only. Each algorithm
group's threshold can also be overridden by writing to its sysfs
attribute.

Testing
=======

This series was integrated into an OpenWrt community image based on
Linux 6.18 and tested on a W1700K2 HW2.1 equipped with an Airoha AN7581
E2 SoC. Results from tcrypt and OpenSSL:

Enabling fallback took 0.82 seconds and selected these thresholds. A
value of -1 means that software was faster at every tested size.

  Group          Threshold (bytes)
  raw_aes                      512
  raw_des                      256
  raw_3des                      64
  hash_md5                      -1
  hash_sha1                     -1
  hash_sha2                     -1
  authenc_aes                  512
  authenc_des                  128
  authenc_3des                  64

The tcrypt AES-128-CBC results are median cycles from five runs. Lower
is better. Disabled uses cbc(aes-eip93) directly, while enabled uses
fallback(cbc(aes-eip93)).

  Request   Disabled   Enabled   Cycle reduction
   (bytes)   (cycles)  (cycles)
       16        322        18             94.4%
       64        274        43             84.3%
      128        292        74             74.7%
      256        312       138             55.8%
     1024        434       439             -1.2%
     1424        492       488              0.8%
     4096        980      1023             -4.4%

OpenSSL 3.5.7 AF_ALG AES-128-CBC throughput is the mean of two
two-second runs at each request size.

  Request   Disabled   Enabled   Throughput gain
   (bytes)     (MB/s)    (MB/s)
       16       0.560     1.257             124.5%
       64       2.430     4.639              90.9%
      256       9.106    14.168              55.6%
     1024      30.279    30.332               0.2%
     8192      88.807    89.383               0.6%
    16384     101.220   102.068               0.8%

All tcrypt KATs and OpenSSL AF_ALG round-trip tests passed with fallback
both disabled and enabled.

LLM disclosure
==============

Development of patch 2/4 was aided by an LLM, while patch 4/4 was
developed more extensively with LLM assistance. All testing was
performed by me.

[1] https://lore.kernel.org/linux-crypto/20260712-qce-broken-v1-1-85e2bff17871@gmail.com/
[2] https://lore.kernel.org/linux-crypto/20260712-qce-broken-v2-1-b2dfff47f7f5@gmail.com/
[3] https://lore.kernel.org/linux-crypto/20260724050645.223799-1-ebiggers@kernel.org/
[4] https://github.com/stevenj/ph-openwrt-mtk-eip93


Sincerely,
Jihong Min

Jihong Min (4):
  crypto: move cycle benchmark helpers out of tcrypt
  crypto: introduce dynamic software fallback
  crypto: eip93 - add dynamic software fallback support
  crypto: eliminate fallback proxy overhead while disabled

 crypto/Kconfig                                |   24 +-
 crypto/Makefile                               |    3 +
 crypto/benchmark.c                            |  180 ++
 crypto/fallback.c                             | 1479 +++++++++++++++++
 crypto/tcrypt.c                               |  213 +--
 drivers/crypto/inside-secure/eip93/Kconfig    |    7 +
 drivers/crypto/inside-secure/eip93/Makefile   |    1 +
 .../inside-secure/eip93/eip93-fallback.c      |  164 ++
 .../inside-secure/eip93/eip93-fallback.h      |   10 +
 .../crypto/inside-secure/eip93/eip93-main.c   |   19 +-
 include/crypto/benchmark.h                    |   24 +
 include/crypto/fallback.h                     |   96 ++
 12 files changed, 2024 insertions(+), 196 deletions(-)
 create mode 100644 crypto/benchmark.c
 create mode 100644 crypto/fallback.c
 create mode 100644 drivers/crypto/inside-secure/eip93/eip93-fallback.c
 create mode 100644 drivers/crypto/inside-secure/eip93/eip93-fallback.h
 create mode 100644 include/crypto/benchmark.h
 create mode 100644 include/crypto/fallback.h


base-commit: 1163a476a568f6c0f852d469c8e4c5a5f805adac
-- 
2.53.0
