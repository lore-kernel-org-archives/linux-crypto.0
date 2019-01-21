Return-Path: <SRS0=ru6j=P5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EB74C676EF
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Jan 2019 09:30:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE89B20989
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Jan 2019 09:30:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="bm2OnHA3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbfAUJ3z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Jan 2019 04:29:55 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42594 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbfAUJ3z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Jan 2019 04:29:55 -0500
Received: by mail-pf1-f194.google.com with SMTP id 64so9853381pfr.9
        for <linux-crypto@vger.kernel.org>; Mon, 21 Jan 2019 01:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=ezNTvp94HxKfIHnuTDGydgVtNdYFJn6q8Xf3NcPa2u4=;
        b=bm2OnHA3iMTFUED27Q3idWBXeh8Qos+EktXabpmpTUs33p0wICYqztSSpUPVGyn0ni
         fDlRIj+cxLoUVBl4ZguBFkQEaPWF0mHhmsGdi06pcOpCffcMKdcTcYwJQVohdak7YV47
         yqbCYv0KazcwxOlJYINw0M6QPfJTT/Fd5Yveg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ezNTvp94HxKfIHnuTDGydgVtNdYFJn6q8Xf3NcPa2u4=;
        b=uk/E2Po/VCcr1Iw97cIDy9htcxEZO6Uo9CtDUUHdqnxuaNvMx1NCscU8wvzNicY9XR
         HbQL0x0Z45xsZl6eXaFeXpiPT+j8Z7Bkjn/mTPMm9KQIZYHRg5fGbr0AHHqB0OgdPp8I
         ti7Txrp/+pH1XlCRTOaPiyRUerGDe0NhL79YdC5be9dIaEycCRn8v0DWAl8/ibZZvY9D
         dt/ixUA3NfjLoAtBcj1nODAJu74i/7DybUSbXWHxzWLoBt4zhSBZzRzugCsuGS+BN3ne
         GsNd13WyVBA1k5B96/V9PhpFi+42F88cHE2iv6KZlKnJQBYpJ0552rMa4RUGs1ZhEMKj
         VIMQ==
X-Gm-Message-State: AJcUukem4ZWo6fm+bz2ZfHrM59KFVzbxSyXP5yIWHnWUx5DNPuDdPSAN
        cze0ouQtVptYuAktlVLWak8eL2YF3rY=
X-Google-Smtp-Source: ALg8bN5F+t/mRV0Mf1/foRV3v0b5kBnK/KF97jtxYUW6VhpyWS2UD2SuHvsQdpJXPIgAQ/y4pBi8CQ==
X-Received: by 2002:a63:5026:: with SMTP id e38mr27560627pgb.123.1548062993927;
        Mon, 21 Jan 2019 01:29:53 -0800 (PST)
Received: from localhost.localdomain ([117.252.65.115])
        by smtp.gmail.com with ESMTPSA id h9sm16182777pgd.53.2019.01.21.01.29.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 21 Jan 2019 01:29:53 -0800 (PST)
From:   Sumit Garg <sumit.garg@linaro.org>
To:     jens.wiklander@linaro.org, herbert@gondor.apana.org.au
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, mpm@selenic.com, robh+dt@kernel.org,
        mark.rutland@arm.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        daniel.thompson@linaro.org, ard.biesheuvel@linaro.org,
        bhsharma@redhat.com, tee-dev@lists.linaro.org,
        Sumit Garg <sumit.garg@linaro.org>
Subject: [PATCH v4 0/4] Introduce TEE bus driver framework
Date:   Mon, 21 Jan 2019 14:59:15 +0530
Message-Id: <1548062959-31860-1-git-send-email-sumit.garg@linaro.org>
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
 drivers/char/hw_random/optee-rng.c | 272 +++++++++++++++++++++++++++++++++++++
 drivers/tee/optee/Makefile         |   1 +
 drivers/tee/optee/core.c           |   4 +
 drivers/tee/optee/device.c         | 153 +++++++++++++++++++++
 drivers/tee/optee/optee_private.h  |   3 +
 drivers/tee/optee/supp.c           |  10 +-
 drivers/tee/tee_core.c             |  58 +++++++-
 include/linux/tee_drv.h            |  43 +++++-
 11 files changed, 559 insertions(+), 6 deletions(-)
 create mode 100644 drivers/char/hw_random/optee-rng.c
 create mode 100644 drivers/tee/optee/device.c

-- 
2.7.4

