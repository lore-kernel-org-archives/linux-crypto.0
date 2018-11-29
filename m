Return-Path: <SRS0=WCFZ=OI=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37056 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729463AbeK3BsK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Nov 2018 20:48:10 -0500
Received: by mail-wm1-f68.google.com with SMTP id g67so2487387wmd.2
        for <linux-crypto@vger.kernel.org>; Thu, 29 Nov 2018 06:42:34 -0800 (PST)
From: Corentin Labbe <clabbe@baylibre.com>
To: davem@davemloft.net, ebiggers@kernel.org,
        herbert@gondor.apana.org.au, nhorman@tuxdriver.com
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v5 00/11] crypto: crypto_user_stat: misc enhancement
Date: Thu, 29 Nov 2018 14:42:15 +0000
Message-Id: <1543502546-23870-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello

This patchset fixes all reported problem by Eric biggers.

Regards

Changes since v4:
- Inlined functions when !CRYPTO_STATS

Changes since v3:
- Added a crypto_stats_init as asked vy Neil Horman
- Fixed some checkpatch complaints

Changes since v2:
- moved all crypto_stats functions from header to algapi.c for using
  crypto_alg_get/put

Changes since v1:
- Better locking of crypto_alg via crypto_alg_get/crypto_alg_put
- remove all intermediate variables in crypto/crypto_user_stat.c
- splited all internal stats variables into different structures

Corentin Labbe (11):
  crypto: crypto_user_stat: made crypto_user_stat optional
  crypto: CRYPTO_STATS should depend on CRYPTO_USER
  crypto: crypto_user_stat: convert all stats from u32 to u64
  crypto: crypto_user_stat: split user space crypto stat structures
  crypto: tool: getstat: convert user space example to the new
    crypto_user_stat uapi
  crypto: crypto_user_stat: fix use_after_free of struct xxx_request
  crypto: crypto_user_stat: Fix invalid stat reporting
  crypto: crypto_user_stat: remove intermediate variable
  crypto: crypto_user_stat: Split stats in multiple structures
  crypto: crypto_user_stat: rename err_cnt parameter
  crypto: crypto_user_stat: Add crypto_stats_init

 crypto/Kconfig                       |   1 +
 crypto/Makefile                      |   3 +-
 crypto/ahash.c                       |  17 +-
 crypto/algapi.c                      | 247 ++++++++++++++++++++++-
 crypto/crypto_user_stat.c            | 160 +++++----------
 crypto/rng.c                         |   4 +-
 include/crypto/acompress.h           |  38 +---
 include/crypto/aead.h                |  38 +---
 include/crypto/akcipher.h            |  74 ++-----
 include/crypto/hash.h                |  32 +--
 include/crypto/internal/cryptouser.h |  17 ++
 include/crypto/kpp.h                 |  48 +----
 include/crypto/rng.h                 |  27 +--
 include/crypto/skcipher.h            |  36 +---
 include/linux/crypto.h               | 290 ++++++++++++++++++---------
 include/uapi/linux/cryptouser.h      | 102 ++++++----
 tools/crypto/getstat.c               |  72 +++----
 17 files changed, 676 insertions(+), 530 deletions(-)

-- 
2.18.1
