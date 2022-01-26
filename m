Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D245BC2BA4C
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jan 2022 07:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237574AbiAZHHa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Jan 2022 02:07:30 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.169]:42537 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237569AbiAZHH1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Jan 2022 02:07:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1643180842;
    s=strato-dkim-0002; d=chronox.de;
    h=Message-ID:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=SGs0oV4J96NbISh9Fa5d6Soto2HLZrt9B0f82iJ84Q8=;
    b=moQrozm8g07oItpu26IzdZsxMxFbIybxes3Tz6NrNF96O55yRc2Hwa5+gRgQiGrUTo
    HK0bEe2xsmBEFDQXLGzqZcr6bjkwfuumrmWPZ1bMId7B7HxAtNNh6hErBYqqqXeu7r7v
    BrAp3meBUxNG/0bkIX7V5e8zJbq+GlmyEyhKL6NeRft2+sK+2Wh9Y3kCFuAqI4T54Vdf
    /WaXbnXEdsXgFG32SKEssMZq2zUvrz78HVFuS2NWLEMLTumNhcv4r7QHp5hnLuQNOgz+
    hbBtmbmLPMXHQZns7kpT4jgSqBYmNjsjttRZq/CpL9zP2FR850URIvW00gdLjYJovKKi
    QDjw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaJvScdWrN"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.38.0 DYNA|AUTH)
    with ESMTPSA id v5f65ay0Q77MiuT
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 26 Jan 2022 08:07:22 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, simo@redhat.com,
        Nicolai Stange <nstange@suse.de>
Subject: [PATCH 0/7] Common entropy source and DRNG management
Date:   Wed, 26 Jan 2022 08:02:54 +0100
Message-ID: <2486550.t9SDvczpPo@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The current code base of the kernel crypto API random number support
leaves the task to seed and reseed the DRNG to either the caller or
the DRNG implementation. The code in crypto/drbg.c implements its own
seeding strategy. crypto/ansi_cprng.c does not contain any seeding
operation. The implementation in arch/s390/crypto/prng.c has yet
another approach for seeding. Albeit the crypto_rng_reset() contains
a seeding logic from get_random_bytes, there is no management of
the DRNG to ensure proper reseeding or control which entropy sources
are used for pulling data from.

The task of seeding and reseeding a DRNG including the controlling
of the state of the entropy sources is security sensitive as the
strength of the data obtained from the DRNG rests in large parts on
the proper seeding. In addition, various aspects need to be considered
when (re)seeding a DRNG. This gap is filled with the Entropy Source and
DRNG Manager (ESDM) proposed by this patch set.

The ESDM consists of two managers: the manager for the DRNG(s) and
manager for the entropy sources. The DRNG manager ensures that DRNGs
are properly seeded before random numbers are obtained from them.
Similarly, the entropy source manager ensures that the available
entropy sources are properly initialized if needed, and that data
is obtained with an appropriately considered entropy rate.

Both, the DRNG and entropy source managers offer a pluggable interface
allowing to use different DRNG implementations as well as various
entropy sources. Each provided entropy source may be enabled during
compile time. The ESDM therefore provides flexibility in the future
to extend the set of entropy sources or the supported DRNGs to the
required algorithms.

The patch set consists of the following changes:

- Patch 1 removes the seeding and reseeding logic from the DRBG
  transforming it into a pure deterministic implementation.

- Patch 2 removes the special AF_ALG interface used to test
  the DRBG implementation which requires bypassing of the DRBG
  automated seeding from entropy sources. With patch 1 this is
  not needed any more.

- Patch 3 adds the ESDM with its DRNG and entropy source
  managers. It contains the support to use the kernel crypto
  API's DRNG implementations.

- Patches 4 and 5 use the existing Jitter RNG as an entropy
  source for the ESDM.

- Patch 6 provides the glue code to use the get_random_bytes
  function as entropy source to the ESDM.

- Patch 7 adds the ESDM interface to register it with the kernel
  crypto API RNG framework as "stdrng" with the highest priority.
  This way, the ESDM is used per default when using the call
  crypto_get_default_rng().

With this patch series, callers to the kernel crypto API would not
experience any difference. When using the RNG framework, the function
crypto_get_default_rng is commonly used. Instead of providing the
DRBG implementation, the ESDM is used which returns random numbers
from a properly seeded DRBG.

Stephan Mueller (7):
  crypto: DRBG - remove internal reseeding operation
  crypto: AF_ALG - remove ALG_SET_DRBG_ENTROPY interface
  crypto: Entropy Source and DRNG Manager
  crypto: move Jitter RNG header include dir
  crypto: ESDM - add Jitter RNG entropy source
  crypto: ESDM - add Kernel RNG entropy source
  crypto: ESDM - add kernel crypto API RNG interface

 crypto/Kconfig                                |  11 +-
 crypto/Makefile                               |   1 +
 crypto/af_alg.c                               |   7 -
 crypto/algif_rng.c                            |  74 +-
 crypto/drbg.c                                 | 640 ++++-------------
 crypto/esdm/Kconfig                           | 166 +++++
 crypto/esdm/Makefile                          |  15 +
 crypto/esdm/esdm_definitions.h                | 141 ++++
 crypto/esdm/esdm_drng_kcapi.c                 | 202 ++++++
 crypto/esdm/esdm_drng_kcapi.h                 |  13 +
 crypto/esdm/esdm_drng_mgr.c                   | 398 +++++++++++
 crypto/esdm/esdm_drng_mgr.h                   |  85 +++
 crypto/esdm/esdm_es_aux.c                     | 332 +++++++++
 crypto/esdm/esdm_es_aux.h                     |  44 ++
 crypto/esdm/esdm_es_jent.c                    | 128 ++++
 crypto/esdm/esdm_es_jent.h                    |  17 +
 crypto/esdm/esdm_es_krng.c                    | 120 ++++
 crypto/esdm/esdm_es_krng.h                    |  17 +
 crypto/esdm/esdm_es_mgr.c                     | 372 ++++++++++
 crypto/esdm/esdm_es_mgr.h                     |  46 ++
 crypto/esdm/esdm_es_mgr_cb.h                  |  73 ++
 crypto/esdm/esdm_interface_kcapi.c            |  91 +++
 crypto/esdm/esdm_sha.h                        |  14 +
 crypto/esdm/esdm_sha256.c                     |  72 ++
 crypto/jitterentropy-kcapi.c                  |   3 +-
 crypto/jitterentropy.c                        |   2 +-
 crypto/testmgr.c                              | 104 +--
 crypto/testmgr.h                              | 641 +-----------------
 include/crypto/drbg.h                         |  84 ---
 include/crypto/esdm.h                         | 115 ++++
 include/crypto/if_alg.h                       |   1 -
 .../crypto/internal}/jitterentropy.h          |   0
 include/crypto/internal/rng.h                 |   6 -
 include/crypto/rng.h                          |   4 -
 include/uapi/linux/if_alg.h                   |   2 +-
 35 files changed, 2615 insertions(+), 1426 deletions(-)
 create mode 100644 crypto/esdm/Kconfig
 create mode 100644 crypto/esdm/Makefile
 create mode 100644 crypto/esdm/esdm_definitions.h
 create mode 100644 crypto/esdm/esdm_drng_kcapi.c
 create mode 100644 crypto/esdm/esdm_drng_kcapi.h
 create mode 100644 crypto/esdm/esdm_drng_mgr.c
 create mode 100644 crypto/esdm/esdm_drng_mgr.h
 create mode 100644 crypto/esdm/esdm_es_aux.c
 create mode 100644 crypto/esdm/esdm_es_aux.h
 create mode 100644 crypto/esdm/esdm_es_jent.c
 create mode 100644 crypto/esdm/esdm_es_jent.h
 create mode 100644 crypto/esdm/esdm_es_krng.c
 create mode 100644 crypto/esdm/esdm_es_krng.h
 create mode 100644 crypto/esdm/esdm_es_mgr.c
 create mode 100644 crypto/esdm/esdm_es_mgr.h
 create mode 100644 crypto/esdm/esdm_es_mgr_cb.h
 create mode 100644 crypto/esdm/esdm_interface_kcapi.c
 create mode 100644 crypto/esdm/esdm_sha.h
 create mode 100644 crypto/esdm/esdm_sha256.c
 create mode 100644 include/crypto/esdm.h
 rename {crypto => include/crypto/internal}/jitterentropy.h (100%)

-- 
2.33.1




