Return-Path: <SRS0=IFNk=NQ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42586 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728136AbeKEWLC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Nov 2018 17:11:02 -0500
Received: by mail-wr1-f66.google.com with SMTP id y15-v6so9379543wru.9
        for <linux-crypto@vger.kernel.org>; Mon, 05 Nov 2018 04:51:25 -0800 (PST)
From: Corentin Labbe <clabbe@baylibre.com>
To: davem@davemloft.net, ebiggers@kernel.org,
        herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 0/5] crypto: crypto_user_stat: misc enhancement
Date: Mon,  5 Nov 2018 12:51:09 +0000
Message-Id: <1541422274-40060-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello

This patchset fixes all reported problem by Eric biggers.
This patchset should be applied on top of Eric biggers patchset "crypto: crypto_user reporting fixes and cleanups"

Regards

Corentin Labbe (5):
  crypto: crypto_user_stat: made crypto_user_stat optional
  crypto: crypto_user_stat: convert all stats from u32 to u64
  crypto: crypto_user_stat: split user space crypto stat structures
  crypto: tool: getstat: convert user space example to the new
    crypto_user_stat uapi
  crypto: crypto_user_stat: fix use_after_free of struct xxx_request

 crypto/Makefile                      |   3 +-
 crypto/ahash.c                       |  14 ++-
 crypto/algapi.c                      |  12 ++-
 crypto/crypto_user_stat.c            | 134 +++++++++++++--------------
 include/crypto/acompress.h           |  30 +++---
 include/crypto/aead.h                |  30 +++---
 include/crypto/akcipher.h            |  56 ++++++-----
 include/crypto/hash.h                |  25 ++---
 include/crypto/internal/cryptouser.h |  17 ++++
 include/crypto/kpp.h                 |  26 +++---
 include/crypto/rng.h                 |   8 +-
 include/crypto/skcipher.h            |  24 +++--
 include/linux/crypto.h               |  74 +++++++--------
 include/uapi/linux/cryptouser.h      | 103 ++++++++++++--------
 tools/crypto/getstat.c               |  54 +++++------
 15 files changed, 329 insertions(+), 281 deletions(-)

-- 
2.18.1
