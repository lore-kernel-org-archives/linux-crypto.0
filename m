Return-Path: <SRS0=t27p=PE=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44702 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729577AbeL0LIG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Dec 2018 06:08:06 -0500
Received: by mail-pg1-f193.google.com with SMTP id t13so8673561pgr.11
        for <linux-crypto@vger.kernel.org>; Thu, 27 Dec 2018 03:08:06 -0800 (PST)
From: Sumit Garg <sumit.garg@linaro.org>
To: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
Cc: mpm@selenic.com, herbert@gondor.apana.org.au, robh+dt@kernel.org,
        mark.rutland@arm.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        jens.wiklander@linaro.org, daniel.thompson@linaro.org,
        ard.biesheuvel@linaro.org, bhsharma@redhat.com,
        tee-dev@lists.linaro.org, Sumit Garg <sumit.garg@linaro.org>
Subject: [PATCH v1 0/2] Add OP-TEE based hwrng driver
Date: Thu, 27 Dec 2018 16:37:09 +0530
Message-Id: <1545908831-25910-1-git-send-email-sumit.garg@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On ARM SoC's with TrustZone enabled, peripherals like entropy sources
might not be accessible to normal world (linux in this case) and rather
accessible to secure world (OP-TEE in this case) only. So this driver
aims to provides a generic interface to OP-TEE based random number
generator service.

Example case is Developerbox based on Socionext's Synquacer SoC [1]
which provides 7 thermal sensors accessible from secure world only which
could be used as entropy sources (thermal/measurement noise).

[1] https://www.96boards.org/product/developerbox/

Sumit Garg (2):
  dt/bindings: add bindings for optional optee rng-uuid property
  hwrng: add OP-TEE based rng driver

 .../bindings/arm/firmware/linaro,optee-tz.txt      |   4 +
 MAINTAINERS                                        |   5 +
 drivers/char/hw_random/Kconfig                     |  15 ++
 drivers/char/hw_random/Makefile                    |   1 +
 drivers/char/hw_random/optee-rng.c                 | 273 +++++++++++++++++++++
 5 files changed, 298 insertions(+)
 create mode 100644 drivers/char/hw_random/optee-rng.c

-- 
2.7.4
