Return-Path: <SRS0=CSIn=PT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39720 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729272AbfAKLt7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jan 2019 06:49:59 -0500
Received: by mail-pg1-f195.google.com with SMTP id w6so6232808pgl.6
        for <linux-crypto@vger.kernel.org>; Fri, 11 Jan 2019 03:49:59 -0800 (PST)
From: Sumit Garg <sumit.garg@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jens.wiklander@linaro.org,
        mpm@selenic.com, herbert@gondor.apana.org.au, robh+dt@kernel.org,
        mark.rutland@arm.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        daniel.thompson@linaro.org, ard.biesheuvel@linaro.org,
        bhsharma@redhat.com, tee-dev@lists.linaro.org,
        Sumit Garg <sumit.garg@linaro.org>
Subject: [PATCH v3 0/4] Introduce TEE bus driver framework
Date: Fri, 11 Jan 2019 17:17:27 +0530
Message-Id: <1547207251-9372-1-git-send-email-sumit.garg@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series introduces a generic TEE bus driver concept for TEE based
kernel drivers which would like to communicate with TEE based devices/
services.

Patch #1 adds TEE bus concept where devices/services are identified via
Universally Unique Identifier (UUID) and drivers register a table of
device UUIDs which they can support. This concept also allows for device
enumeration to be specific to corresponding TEE implementation like
OP-TEE etc.

Patch #2 adds supp_nowait flag for non-blocking requests arising via
TEE internal client interface.

Patch #3 adds TEE bus device enumeration support for OP-TEE. OP-TEE
provides a pseudo TA to enumerate TAs which can act as devices/services
for TEE bus.

Patch #4 adds OP-TEE based hwrng driver which act as TEE bus driver.
On ARM SoC's with TrustZone enabled, peripherals like entropy sources
might not be accessible to normal world (linux in this case) and rather
accessible to secure world (OP-TEE in this case) only. So this driver
aims to provides a generic interface to OP-TEE based random number
generator service.

Example case is Developerbox based on Socionext's Synquacer SoC [1]
which provides 7 thermal sensors accessible from secure world only which
could be used as entropy sources (thermal/measurement noise).

[1] https://www.96boards.org/product/developerbox/

Changes in v3:

1. Fixed bus error path in Patch #1.
2. Reversed order of Patch #2 and #3.
3. Fixed miscellaneous syntax comments and memory leak.
4. Added comments in Patch #2 for supp_nowait flag.

Changes in v2:

Based on review comments, the scope of this series has increased as
follows:

1. Added TEE bus driver framework.
2. Added OP-TEE based device enumeration.
3. Register optee-rng driver as TEE bus driver.
4. Removed DT dependency for optee-rng device UUID.
5. Added supp_nowait flag.

Sumit Garg (4):
  tee: add bus driver framework for TEE based devices
  tee: add supp_nowait flag in tee_context struct
  tee: optee: add TEE bus device enumeration support
  hwrng: add OP-TEE based rng driver

 MAINTAINERS                        |   5 +
 drivers/char/hw_random/Kconfig     |  15 ++
 drivers/char/hw_random/Makefile    |   1 +
 drivers/char/hw_random/optee-rng.c | 272 +++++++++++++++++++++++++++++++++++++
 drivers/tee/optee/Makefile         |   1 +
 drivers/tee/optee/core.c           |   4 +
 drivers/tee/optee/device.c         | 153 +++++++++++++++++++++
 drivers/tee/optee/optee_private.h  |   3 +
 drivers/tee/optee/supp.c           |  10 +-
 drivers/tee/tee_core.c             |  56 +++++++-
 include/linux/tee_drv.h            |  42 ++++++
 11 files changed, 558 insertions(+), 4 deletions(-)
 create mode 100644 drivers/char/hw_random/optee-rng.c
 create mode 100644 drivers/tee/optee/device.c

-- 
2.7.4
