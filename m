Return-Path: <SRS0=9Ofa=N6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33884 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbeKTGSr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Nov 2018 01:18:47 -0500
Received: by mail-wr1-f65.google.com with SMTP id j2so5005136wrw.1
        for <linux-crypto@vger.kernel.org>; Mon, 19 Nov 2018 11:53:37 -0800 (PST)
From: Corentin Labbe <clabbe@baylibre.com>
To: davem@davemloft.net, ebiggers@kernel.org,
        herbert@gondor.apana.org.au, nhorman@tuxdriver.com
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 00/11] crypto: crypto_user_stat: misc enhancement
Date: Mon, 19 Nov 2018 19:53:19 +0000
Message-Id: <1542657210-37739-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello

This patchset fixes all reported problem by Eric Biggers.

Regards

Changes since v2:
- Better locking of crypto_alg via crypto_alg_get/crypto_alg_put
- remove all intermediate variables in crypto/crypto_user_stat.c
- splited all internal stats variables into different structures

Corentin Labbe (11):
  crypto: move crypto_alg_get/crypto_alg_put to linux/crypto.h
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

 crypto/Kconfig                       |   1 +
 crypto/Makefile                      |   3 +-
 crypto/ahash.c                       |  23 ++-
 crypto/algapi.c                      |  10 +-
 crypto/crypto_user_stat.c            | 160 ++++++------------
 crypto/internal.h                    |  12 --
 crypto/rng.c                         |   6 +-
 include/crypto/acompress.h           |  38 +++--
 include/crypto/aead.h                |  38 +++--
 include/crypto/akcipher.h            |  72 ++++----
 include/crypto/hash.h                |  30 ++--
 include/crypto/internal/cryptouser.h |  17 ++
 include/crypto/kpp.h                 |  43 +++--
 include/crypto/rng.h                 |  22 ++-
 include/crypto/skcipher.h            |  32 ++--
 include/linux/crypto.h               | 236 ++++++++++++++++++---------
 include/uapi/linux/cryptouser.h      | 102 +++++++-----
 tools/crypto/getstat.c               |  72 ++++----
 18 files changed, 525 insertions(+), 392 deletions(-)

-- 
2.18.1
