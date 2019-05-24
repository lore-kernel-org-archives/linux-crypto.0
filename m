Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75EDAC072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 16:27:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A55B2075D
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 16:27:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JlhIiBr0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390646AbfEXQ1j (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 12:27:39 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55155 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390605AbfEXQ1j (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 12:27:39 -0400
Received: by mail-wm1-f67.google.com with SMTP id i3so9992195wml.4
        for <linux-crypto@vger.kernel.org>; Fri, 24 May 2019 09:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PW1SRGUIIosnHzTIT8oKHW+BHMniX6kJc68l082Nb68=;
        b=JlhIiBr0LN+EnwR1yra8h8TfNP6AP5PihbHAG9CnLQaVbccxa0gL7XOEb/qPhw6xw2
         21kLfpqUhTCojwj+D/mGusUKs1jjVDGZkz3LyvpjNo1f2NpWouYSEFgNjb88fjsgv8mL
         DFLkoc+BPr3wl3/HYo7l/01oJB4c4rb0UtJ6Qy/7LkGxaxf+dyC5mTwsnvKUy3b/Dtsh
         /P9qWaIzy+l2zGV3aFtyeAOq9GU001faEsS2NFsTAZDM0A978menzvnuZlzVr5h3mazT
         i5FN0VuhV+N5XaldGyHhNDVl648ByGwe16b4tRcdlbaVE3pVIcTICNpEb3pCFCJ0ByCv
         ygkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PW1SRGUIIosnHzTIT8oKHW+BHMniX6kJc68l082Nb68=;
        b=GTmVvK3C3ar1TOecUVB6pKkUvQ9XooL0e9Rah463vnclCMlfxyw8/vUX86rihLUe55
         FwdYXE0v24IPZc3oGVNzsy0yxqtBt1mrTQ5yoT5ULmSRHTT8sufsyKm47Bn0MaWTR4Eu
         F0cAgBH+DSoH9qI2TsChF1Ij5s35bawLHlluAoKsqHaj0/gX0ztNx/y+w8xqmWNaMnaG
         wn632SoPwv416R2pl2eA/x9ddrGOUMIkO+lSbdcF9E3AbfI5RT4rRdlW75c1rMg3g1dg
         lCfVlqyva40QtLLrDqiNgIPoc+4ALY+fbkqUB727o8irbnAKQzFO3Ak8c4kSGH5X5JT2
         1fKg==
X-Gm-Message-State: APjAAAUKP10OJFi+pZU2tOSj6ZAobT/m0UBm8rxwGqrwIl7AQ6JJvjM5
        tKrd8dz57nYkpE+1yXcUtmXAfOMK7v4jF6dl
X-Google-Smtp-Source: APXvYqzFigln+kJPy+/t7Xbc8DEEH5LN8284rdnJjkHyVa5UHTzba6b6EgaPOigSNNHqYBAD5qkMHg==
X-Received: by 2002:a1c:38c5:: with SMTP id f188mr507266wma.9.1558715256725;
        Fri, 24 May 2019 09:27:36 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:2042:d8f2:ded8:fa95])
        by smtp.gmail.com with ESMTPSA id l6sm2200320wmi.24.2019.05.24.09.27.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 09:27:35 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 0/6] crypto - wire up Atmel SHA204A as RNG in DT and ACPI mode
Date:   Fri, 24 May 2019 18:26:45 +0200
Message-Id: <20190524162651.28189-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Socionext SynQuacer based 96boards DeveloperBox platform does not
incorporate a random number generator, but it does have a 96boards low
speed connector which supports extension boards such as the Secure96,
which has a TPM and some crypto accelerators, one of which incorporates
a random number generator.

This series implements support for the RNG part, which is one of several
functions of the Atmel SHA204A I2C crypto accelerator, and wires it up so
both DT and ACPI based boot methods can use the device.

v2:
- update DT binding patches so the SHA204A and ECC508A module bindings are
  in trivial-devices.yaml.
- add acks from Linus and Mika

Assuming Rob is ok now with the DT binding patches, can we please take
this through the crypto tree?

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>

Ard Biesheuvel (6):
  i2c: acpi: permit bus speed to be discovered after enumeration
  crypto: atmel-ecc: add support for ACPI probing on non-AT91 platforms
  crypto: atmel-ecc: factor out code that can be shared
  crypto: atmel-i2c: add support for SHA204A random number generator
  dt-bindings: add Atmel SHA204A I2C crypto processor
  dt-bindings: move Atmel ECC508A I2C crypto processor to
    trivial-devices

 Documentation/devicetree/bindings/crypto/atmel-crypto.txt |  13 -
 Documentation/devicetree/bindings/trivial-devices.yaml    |   4 +
 drivers/crypto/Kconfig                                    |  19 +-
 drivers/crypto/Makefile                                   |   2 +
 drivers/crypto/atmel-ecc.c                                | 403 ++------------------
 drivers/crypto/atmel-ecc.h                                | 116 ------
 drivers/crypto/atmel-i2c.c                                | 364 ++++++++++++++++++
 drivers/crypto/atmel-i2c.h                                | 196 ++++++++++
 drivers/crypto/atmel-sha204a.c                            | 171 +++++++++
 drivers/i2c/i2c-core-acpi.c                               |   6 +-
 10 files changed, 781 insertions(+), 513 deletions(-)
 delete mode 100644 drivers/crypto/atmel-ecc.h
 create mode 100644 drivers/crypto/atmel-i2c.c
 create mode 100644 drivers/crypto/atmel-i2c.h
 create mode 100644 drivers/crypto/atmel-sha204a.c

-- 
2.20.1

