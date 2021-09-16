Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.7 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FA7EC433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Sep 2021 09:38:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77E2B60F43
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Sep 2021 09:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245655AbhIQJj6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Sep 2021 05:39:58 -0400
Received: from mo4-p04-ob.smtp.rzone.de ([85.215.255.124]:19060 "EHLO
        mo4-p04-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245556AbhIQJjz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Sep 2021 05:39:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1631871147;
    s=strato-dkim-0002; d=chronox.de;
    h=Message-ID:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=BgeWK/QaAL3/YEwxkT+VsPcSu9Z1869RyoXwVEEs4NA=;
    b=jejDF8jx12QumB+ddhXZrvVcOFT+70cA0YLlpD00zn/24VOHUL6lFtMcT7KNVz2wPZ
    n/8Wfd3+J0Kf+kb2o+qDvPD59G6t9MQC3ECXYDi0NCso1vVFugUV06NDI9ePmoU+jiHS
    GsX4CW1vSug3EK9YeAe1ymWr/4Z9oOJqSvFk8eTRlDt7zDBDu5c/Zsc1tjQH3U7q5E0W
    gg9r2FWIKgeJP2jqC3N/GzG+WFA7s8R38XhWA3keq2h6vJ+BbqM3ImZBQj9j6pSj7qxN
    AoKFLipHBwJiy+Pb/uzLKlsjlcxb+j5COGNX2lXi2m6yBQd/wD2WmEh/v6baT7FYoTS6
    6tFw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXvSOeicf6o="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.33.3 DYNA|AUTH)
    with ESMTPSA id f080d4x8H9WQcpj
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 17 Sep 2021 11:32:26 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Tso Ted <tytso@mit.edu>, linux-crypto@vger.kernel.org
Cc:     Willy Tarreau <w@1wt.eu>, Nicolai Stange <nstange@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Vito Caputo <vcaputo@pengaru.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>,
        William Jon McCann <mccann@jhu.edu>,
        zhangjs <zachary@baishancloud.com>,
        Andy Lutomirski <luto@kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Peter Matthias <matthias.peter@bsi.bund.de>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        Neil Horman <nhorman@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Lavr <andy.lavr@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Petr Tesarik <ptesarik@suse.cz>,
        John Haxby <john.haxby@oracle.com>,
        Alexander Lobakin <alobakin@mailbox.org>
Subject: [PATCH v42 00/13] /dev/random - a new approach
Date:   Thu, 16 Sep 2021 12:09:32 +0200
Message-ID: <2294055.9jK4hKOXjS@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

The following patch set provides a different approach to /dev/random which
is called Linux Random Number Generator (LRNG) to collect entropy within
the Linux kernel. It provides the same API and ABI and can be used as a
drop-in replacement. A general overview is given with [6].

The LRNG implements at least all features of the existing /dev/random such =
as
NUMA-node-local DRNGs. Patches 1 through 3 provide the code that is feature-
identical. The following advantages compared to the existing /dev/random
implementation are present:

* Sole use of crypto for data processing:

 - Exclusive use of a hash operation for conditioning entropy data with
   a clear mathematical description as given in [2] section 2.2 -
   non-cryptographic operations like LFSR are not used.

 - The LRNG uses only properly defined and implemented cryptographic
   algorithms unlike the use of the SHA-1 transformation in the existing
   /dev/random implementation.

 - Hash operations use NUMA-node-local hash instances to benefit large
   parallel systems.

 - LRNG uses limited number of data post-processing steps as documented in
   [2] section 2.2 compared to the large variation of different
   post-processing steps in the existing /dev/random implementation that
   have no apparent mathematical description (see [2] section 4.5).

* Performance

 - Faster by up to 130% in the critical code path of the interrupt handler
   depending on data collection size configurable at kernel compile time -
   the default is now set such that the highest performance is achieved as
   outlined in [2] section 4.2.

 - Configurable data collection sizes to accommodate small environments
   and big environments via CONFIG_LRNG_COLLECTION_SIZE.

 - Entropy collection using an almost never contended lock to benefit
   large parallel systems =E2=80=93 worst case rate of contention is the nu=
mber
   of DRNG reseeds, usually the number of potential contentions per 10
   minutes is equal to number of NUMA nodes.

 - ChaCha20 DRNG is significantly faster as implemented in the existing
   /dev/random as demonstrated with [2] table 2.

 - Faster entropy collection during boot time to reach fully seeded
   level, including on virtual systems or systems with SSDs as outlined
   in [2] section 4.1.

 - Faster processing of external data added to LRNG via /dev/random
   or add_hwgenerator_randomness.

* Testing

 - Availability of run-time health tests of the raw unconditioned
   noise source to identify degradation of the available entropy as
   documented in [2] section 2.5.4. Such health tests are important
   today due to virtual machine monitors reducing the resolution of
   or disabling the high-resolution timer.

 - Heuristic entropy estimation is based on quantitative measurements
   and analysis following SP800-90B and not on coincidental
   underestimation of entropy applied by the existing /dev/random as
   outlined in [4] section 4.4.

 - Power-on self tests for critical deterministic components (ChaCha20
   DRNG, software hash implementation, and entropy collection logic)
   not already covered by power-up tests of the kernel crypto API as
   documented in [2] section 2.14.

 - Availability of test interfaces for all operational stages of the
   LRNG including boot-time raw entropy event data sampling as outlined
   in [2] section 2.15.

 - Fully testable ChaCha20 DRNG via a userspace ChaCha20 DRNG
   implementation [3].

 - In case of using the kernel crypto API SHASH hash implementation, it
   is fully testable and tested via the NIST ACVP test framework, for
   example certificates A734, A737, and A738.

 - The LRNG offers a test interface to validate the used software hash
   implementation and in particular that the LRNG invokes the hash
   correctly, allowing a NIST ACVP-compliant test cycle - see [2]
   section 2.15.

 - Availability of stress testing covering the different code paths for
   data and mechanism (de)allocations and code paths covered with locks.

 - Availability of regression tests verifying the different options provided
   with the LRNG.

* Entropy collection

 - The LRNG is shipped with test tools allowing the collection of
   raw unconditioned entropy during runtime and boot time available at
   [1].

 - Full entropy assessment and description is provided with [2] chapter 3,
   specifically section 3.2.6.

 - Guarantee that entropy events are not credited with entropy twice
   (the existing /dev/random implementation credits HID/disk and
   interrupt events with entropy which are a derivative of each other).

* Configurable

 - LRNG kernel configuration allows configuration that is functionally
   equivalent to the existing /dev/random. Non-compiled additional code
   is folded into no-ops.

 - The following additional functions are compile-time selectable
   independent of each other:

  + Enabling of switchable cryptographic implementation support. This
    allows enabling an SP800-90A DRBG.

  + Enabling of using Jitter RNG noise source.

  + Enabling of noise source health tests.

  + Enabling of test interface allowing to enable each test interface
    individually.

  + Enabling of the power-up self test.

 - At boot-time, the SP800-90B health tests can be enabled as outlined
   in [2] section 2.5.4.

 - At boot-time, the entropy rate used to credit the external CPU-based
   noise source and Jitter RNG noise source can be configured including
   setting an entropy rate of zero or full entropy - see [2] sections
   2.5.2 and 2.5.3.

* Run-time pluggable cryptographic implementations used for all data
  processing steps specified in [2] section 2.2

 - The DRNG can be replaced with a different implementation allowing
   any type of DRNG to provide data via the output interfaces. The LRNG
   provides the following types of DRNG implementations:

  + ChaCha20-based software implementation that is used per default.

  + SP800-90A DRBG using accelerated cryptographic implementations that
    may sleep.

  + Any DRNG that is accessible via the kernel crypto API RNG subsystem.

 - The hash component can be replaced with any other hash implementation
   provided the implementation does not sleep. The LRNG provides the
   access to the following types of non-sleeping hash implementations:

  + SHA-256 software implementation that is used per default. Due to
    kernel build system inconsistencies, the software SHA-1 implementation
    is used if the kernel crypto API is not compiled.

  + SHA-512 hash using the fastest hash implementation available via the
    kernel crypto API SHASH subsystem.

* Code structure

 - The LRNG source code is available for current upstream Linux kernel
   separate to the existing /dev/random which means that users who are
   conservative can use the unchanged existing /dev/random implementation.

 - Back-port patches are available at [5] to apply the LRNG to Linux
   kernel versions of 5.10, 5.8, 5.4, 4.19, 4.14, 4.12, 4.10, and 4.4. Patc=
hes
   for other kernel versions are easily derived from the existing ones.

Booting the patch with the kernel command line option
"dyndbg=3Dfile drivers/char/lrng/* +p" generates logs indicating the
operation of the LRNG. Each log is pre-pended with "lrng".

An entropy analysis is performed on the following systems - details
are given in [2] appendix C:

* x86 KVM virtualized guest 32 and 64 bit systems

* x86 bare metal

* older and newer ARMv7 system

* ARM64

* POWER7 LE and POWER 8 BE

* IBM Z System mainframe

* old MIPS embedded device

* testing with GCC and Clang

[1] https://www.chronox.de/lrng.html - If the patch is accepted, I would
be volunteering to convert the documentation into RST format and
contribute it to the Linux kernel documentation directory.

[2] https://www.chronox.de/lrng/doc/lrng.pdf

[3] https://www.chronox.de/chacha20_drng.html

[4] https://www.bsi.bund.de/SharedDocs/Downloads/EN/BSI/Publications/Studie=
s/LinuxRNG/LinuxRNG_EN_V4_1.pdf

[5] https://github.com/smuellerDD/lrng/tree/master/backports

[6] https://www.chronox.de/lrng/doc/lrng_presentation_v41.pdf

Changes (compared to the previous patch set) - individual patches
are visible at https://github.com/smuellerDD/lrng/commits/master:

=2D Use common ChaCha20 initialization function

=2D enforce max generate ops without reseed of full entropy

=2D remove code duplication

=2D SP800-90C - reseed with security strength once fully seeded

=2D split out aux pool operation

=2D rename entropy source files to lrng_es_*.c

=2D SP800-90C ES oversampling subject to ent-data-conversion

=2D calculate GCD of timer used for IRQ ES

=2D dynamically allocate Jitter RNG entropy source

Stephan Mueller (13):
  Linux Random Number Generator
  LRNG - allocate one DRNG instance per NUMA node
  LRNG - sysctls and /proc interface
  LRNG - add switchable DRNG support
  LRNG - add common generic hash support
  crypto: DRBG - externalize DRBG functions for LRNG
  LRNG - add SP800-90A DRBG extension
  LRNG - add kernel crypto API PRNG extension
  crypto: move Jitter RNG header include dir
  LRNG - add Jitter RNG fast noise source
  LRNG - add SP800-90B compliant health tests
  LRNG - add interface for gathering of raw entropy
  LRNG - add power-on and runtime self-tests

 MAINTAINERS                                   |   7 +
 crypto/drbg.c                                 |  16 +-
 crypto/jitterentropy-kcapi.c                  |   3 +-
 crypto/jitterentropy.c                        |   2 +-
 drivers/char/Kconfig                          |   2 +
 drivers/char/Makefile                         |   9 +-
 drivers/char/lrng/Kconfig                     | 523 ++++++++++++
 drivers/char/lrng/Makefile                    |  20 +
 drivers/char/lrng/lrng_aux.c                  | 136 +++
 drivers/char/lrng/lrng_chacha20.c             | 321 +++++++
 drivers/char/lrng/lrng_chacha20.h             |  25 +
 drivers/char/lrng/lrng_drbg.c                 | 198 +++++
 drivers/char/lrng/lrng_drng.c                 | 444 ++++++++++
 drivers/char/lrng/lrng_es_archrandom.c        |  91 ++
 drivers/char/lrng/lrng_es_aux.c               | 274 ++++++
 drivers/char/lrng/lrng_es_irq.c               | 796 ++++++++++++++++++
 drivers/char/lrng/lrng_es_irq.h               |  71 ++
 drivers/char/lrng/lrng_es_jent.c              |  90 ++
 drivers/char/lrng/lrng_es_mgr.c               | 375 +++++++++
 drivers/char/lrng/lrng_health.c               | 410 +++++++++
 drivers/char/lrng/lrng_interfaces.c           | 648 ++++++++++++++
 drivers/char/lrng/lrng_internal.h             | 446 ++++++++++
 drivers/char/lrng/lrng_kcapi.c                | 227 +++++
 drivers/char/lrng/lrng_kcapi_hash.c           | 103 +++
 drivers/char/lrng/lrng_kcapi_hash.h           |  20 +
 drivers/char/lrng/lrng_numa.c                 | 122 +++
 drivers/char/lrng/lrng_proc.c                 | 185 ++++
 drivers/char/lrng/lrng_selftest.c             | 369 ++++++++
 drivers/char/lrng/lrng_switch.c               | 226 +++++
 drivers/char/lrng/lrng_testing.c              | 689 +++++++++++++++
 include/crypto/drbg.h                         |   7 +
 .../crypto/internal}/jitterentropy.h          |   0
 include/linux/lrng.h                          |  81 ++
 33 files changed, 6926 insertions(+), 10 deletions(-)
 create mode 100644 drivers/char/lrng/Kconfig
 create mode 100644 drivers/char/lrng/Makefile
 create mode 100644 drivers/char/lrng/lrng_aux.c
 create mode 100644 drivers/char/lrng/lrng_chacha20.c
 create mode 100644 drivers/char/lrng/lrng_chacha20.h
 create mode 100644 drivers/char/lrng/lrng_drbg.c
 create mode 100644 drivers/char/lrng/lrng_drng.c
 create mode 100644 drivers/char/lrng/lrng_es_archrandom.c
 create mode 100644 drivers/char/lrng/lrng_es_aux.c
 create mode 100644 drivers/char/lrng/lrng_es_irq.c
 create mode 100644 drivers/char/lrng/lrng_es_irq.h
 create mode 100644 drivers/char/lrng/lrng_es_jent.c
 create mode 100644 drivers/char/lrng/lrng_es_mgr.c
 create mode 100644 drivers/char/lrng/lrng_health.c
 create mode 100644 drivers/char/lrng/lrng_interfaces.c
 create mode 100644 drivers/char/lrng/lrng_internal.h
 create mode 100644 drivers/char/lrng/lrng_kcapi.c
 create mode 100644 drivers/char/lrng/lrng_kcapi_hash.c
 create mode 100644 drivers/char/lrng/lrng_kcapi_hash.h
 create mode 100644 drivers/char/lrng/lrng_numa.c
 create mode 100644 drivers/char/lrng/lrng_proc.c
 create mode 100644 drivers/char/lrng/lrng_selftest.c
 create mode 100644 drivers/char/lrng/lrng_switch.c
 create mode 100644 drivers/char/lrng/lrng_testing.c
 rename {crypto =3D> include/crypto/internal}/jitterentropy.h (100%)
 create mode 100644 include/linux/lrng.h

=2D-=20
2.31.1




