Return-Path: <SRS0=zJfq=QF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35150C169C4
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Jan 2019 05:50:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05F4D20989
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Jan 2019 05:50:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="HhrYi0zk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfA2FuG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 29 Jan 2019 00:50:06 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46804 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfA2FuG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Jan 2019 00:50:06 -0500
Received: by mail-pg1-f194.google.com with SMTP id w7so8276686pgp.13
        for <linux-crypto@vger.kernel.org>; Mon, 28 Jan 2019 21:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=25+EHUW/QviVkEKkPntqDGS9uSaHWPwEdP3cMqn+uH0=;
        b=HhrYi0zkE1/W1dskxLTKFXudDjf1IrbxwRmZ1Dbox2C4stm/elFzLNyP9whCYtq+1w
         rWW9V+gSWoyagoaf4ITBQ+H1Ix7zqRvaimyBKm8RSBkxgcIKqYR82Q7bo09XNEoV5CSI
         K4vbY6+lhKzJg9ts7FySJ0ONgYDuC1HmkGCYk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=25+EHUW/QviVkEKkPntqDGS9uSaHWPwEdP3cMqn+uH0=;
        b=RzylKI9rV2w81JQE9XPjOFEvw7nt/XRU6QkGEBIb1GWPDnttwjOlEEAXUAR/4tFK5P
         E06D92lb0hqhhU+fQ1GAXjSJMTKWH4xiN+PQjiQd05zNF81Ae2/ENF0Yi/h3a7qI9Gtb
         Z4LzPnGESI83RZWni9+CBmAohUxtx6XgBO+V8lr5XGco+xk2+kebhpPshnSTTcossNTl
         zfRDyRF8EhJBk1oOSaThpAqFqwJ8w49HlXO0NsmA71WW4uRlxMi6Tfk50KKkxvTI9JZn
         xKBddyfdym2l4048t4ZKroPx8seDRtaDhY4jnACXPOrLB3kd8O6hm27ekAO4uC8m3f6N
         wzGg==
X-Gm-Message-State: AJcUukfVbksdmkzi4jamWbfMYhyWYH6+fTZqJYbu+r7zERLftmeU/pBe
        gn/susHvyWp1Fx5UqDEbBPAjzg==
X-Google-Smtp-Source: ALg8bN5uf7lhKRp8F1xGSW2J9DBg7/knYKJdQQ+eIf6pqzX4vPltxwUfAWN1tnqNG5JMVZYGbHu1PA==
X-Received: by 2002:a63:c141:: with SMTP id p1mr22499168pgi.424.1548741005087;
        Mon, 28 Jan 2019 21:50:05 -0800 (PST)
Received: from localhost.localdomain ([117.252.69.38])
        by smtp.gmail.com with ESMTPSA id y12sm57379437pfk.70.2019.01.28.21.49.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 28 Jan 2019 21:50:04 -0800 (PST)
From:   Sumit Garg <sumit.garg@linaro.org>
To:     jens.wiklander@linaro.org, herbert@gondor.apana.org.au
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com,
        michal.lkml@markovi.net, mpm@selenic.com, robh+dt@kernel.org,
        mark.rutland@arm.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        daniel.thompson@linaro.org, ard.biesheuvel@linaro.org,
        bhsharma@redhat.com, tee-dev@lists.linaro.org,
        Sumit Garg <sumit.garg@linaro.org>
Subject: [PATCH v6 0/4] Introduce TEE bus driver framework
Date:   Tue, 29 Jan 2019 11:19:34 +0530
Message-Id: <1548740978-28495-1-git-send-email-sumit.garg@linaro.org>
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

Changes in v6:

1. Incorporate some nitpicks in patch #1 and #3.
2. Bundle all statics in a data structure in patch #4 and use dev_*
   instead of pr_*.
3. Add reviewed-by tags for patch #1, #2 and #3.

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
 drivers/char/hw_random/optee-rng.c | 298 +++++++++++++++++++++++++++++++++++++
 drivers/tee/optee/Makefile         |   1 +
 drivers/tee/optee/core.c           |   4 +
 drivers/tee/optee/device.c         | 155 +++++++++++++++++++
 drivers/tee/optee/optee_private.h  |   3 +
 drivers/tee/optee/supp.c           |  10 +-
 drivers/tee/tee_core.c             |  67 ++++++++-
 include/linux/mod_devicetable.h    |   9 ++
 include/linux/tee_drv.h            |  38 ++++-
 scripts/mod/devicetable-offsets.c  |   3 +
 scripts/mod/file2alias.c           |  19 +++
 14 files changed, 622 insertions(+), 6 deletions(-)
 create mode 100644 drivers/char/hw_random/optee-rng.c
 create mode 100644 drivers/tee/optee/device.c

-- 
2.7.4

