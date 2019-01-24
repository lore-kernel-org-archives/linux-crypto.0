Return-Path: <SRS0=smUI=QA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 645A6C282C3
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 05:55:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30A6821872
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 05:55:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="KuywJLgB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbfAXFzE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jan 2019 00:55:04 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44481 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbfAXFzE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jan 2019 00:55:04 -0500
Received: by mail-pg1-f195.google.com with SMTP id t13so2178378pgr.11
        for <linux-crypto@vger.kernel.org>; Wed, 23 Jan 2019 21:55:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=f3mH1zt27XKy50kPI5h5z7hgUmi46ubxd/mWwTNb9fA=;
        b=KuywJLgBLewmwrD5PMgOKRHG053MSpBF7pWRHhQSjjOi4NyG0vkFzU10Qw08z2gpvo
         TaBJIGnEyUtYIysk0USUc2rCRKYpLczmJi8xvCdIJsKlaFPKzGJC8+se3IHbs6O/2PU5
         x7oqpuXM63Qvf/83ow8jhnWlQeGCEdyQtRBcU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=f3mH1zt27XKy50kPI5h5z7hgUmi46ubxd/mWwTNb9fA=;
        b=ZvQUxpfoUoVDdV9F+MSlKvkh4PQCe9oxBqti3S0j9jOvSNJ8kWCIhTMja09+G0uLqT
         59M4/YqrtWInQvaEsNFipqf08GxvoGNSFjdXZ+1U13TVoVXvx/VVTzNzRYkqs1GzKPoV
         5AOjjuH+Yd6Hfw1lX83eqPszglxx/BRC3aVY0tSucyYoSJyQZxJoyGT7u5am1pJMRzy+
         e9mSlKHHU5ttJ8X6CGS/BC7a86ZC0Y47HjfSrqHCfdGMsXgVrmnkzlMu1UOOicjLeakI
         uR9blhwH2Q21Uwiy4Fs8AAJZbl7DNrJZ+IjHekvB0bI+Q2ppL72jjiKtD4rIcPMbAZng
         KHtA==
X-Gm-Message-State: AJcUukfrz6skFGxl2TKT+lgIJEyZrNrUH8w7OySjjZB0EcDJ4I60CxeI
        rUAtMF3olCP9IEwisF8klSkmPQ==
X-Google-Smtp-Source: ALg8bN64Q/zM1iaiESuEO7bGbu7SJeJ6e4tUgPYhtye8Ywr0olZB1+VjGezeW36flJNHIkoEsbttxg==
X-Received: by 2002:a62:a99:: with SMTP id 25mr5040473pfk.121.1548309303259;
        Wed, 23 Jan 2019 21:55:03 -0800 (PST)
Received: from localhost.localdomain ([117.196.233.31])
        by smtp.gmail.com with ESMTPSA id i2sm32297287pfi.66.2019.01.23.21.54.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Jan 2019 21:55:02 -0800 (PST)
From:   Sumit Garg <sumit.garg@linaro.org>
To:     jens.wiklander@linaro.org, herbert@gondor.apana.org.au,
        ard.biesheuvel@linaro.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com,
        michal.lkml@markovi.net, mpm@selenic.com, robh+dt@kernel.org,
        mark.rutland@arm.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        daniel.thompson@linaro.org, bhsharma@redhat.com,
        tee-dev@lists.linaro.org, Sumit Garg <sumit.garg@linaro.org>
Subject: [PATCH v5 0/4] Introduce TEE bus driver framework
Date:   Thu, 24 Jan 2019 11:24:35 +0530
Message-Id: <1548309279-5281-1-git-send-email-sumit.garg@linaro.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

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

Changes in v5:

1. Add support in module device table for TEE bus devices.
2. Correct license for optee-rng module.

Changes in v4:

1. Use typedef instead of single member tee_client_device_id struct.
2. Incorporate TEE bus nitpicks.

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
 drivers/char/hw_random/optee-rng.c | 274 +++++++++++++++++++++++++++++++++++++
 drivers/tee/optee/Makefile         |   1 +
 drivers/tee/optee/core.c           |   4 +
 drivers/tee/optee/device.c         | 153 +++++++++++++++++++++
 drivers/tee/optee/optee_private.h  |   3 +
 drivers/tee/optee/supp.c           |  10 +-
 drivers/tee/tee_core.c             |  70 +++++++++-
 include/linux/mod_devicetable.h    |   9 ++
 include/linux/tee_drv.h            |  38 ++++-
 scripts/mod/devicetable-offsets.c  |   3 +
 scripts/mod/file2alias.c           |  19 +++
 14 files changed, 599 insertions(+), 6 deletions(-)
 create mode 100644 drivers/char/hw_random/optee-rng.c
 create mode 100644 drivers/tee/optee/device.c

-- 
2.7.4

