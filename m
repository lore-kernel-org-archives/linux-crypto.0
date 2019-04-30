Return-Path: <SRS0=YET+=TA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E910C04AA6
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Apr 2019 16:29:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DCAA20644
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Apr 2019 16:29:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kAt6Dfvs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfD3Q3q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Apr 2019 12:29:46 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37495 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfD3Q3q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Apr 2019 12:29:46 -0400
Received: by mail-wr1-f68.google.com with SMTP id r6so21781617wrm.4
        for <linux-crypto@vger.kernel.org>; Tue, 30 Apr 2019 09:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pJcnizSX09s8fd54NDpfsOEpZWqIjJb4KGon6CoHIdE=;
        b=kAt6DfvsoMEHFhgdnVzV+s9YIgmyxSKYpBh6b+I2H9eu/PEnBAoh+w/TypaG5YDPUp
         QJghPybgsEgarbZMdnKUYaQszvNm9YfL6CT/sl4vYcCLSomRGRtOvzL76Wthc3URDenE
         kq602HzH60sURQqKmhZFfLvKUfMjmcEqZJl14K8JPoBiJtW8FfvzhhSd/rRyaVY5k4D2
         V0rPDJE5XWxwTCsX7u0fzq70bvCPbxqHb3LM0cDe9SSfYvLK0pz++qIFqdClZl2TKKIN
         8BhXdozQndFP1q7WSc/caAVc1yP3paxyB+UuvJD0UFUuxjrofnpGsp6uTstCsj8GG932
         ZKng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pJcnizSX09s8fd54NDpfsOEpZWqIjJb4KGon6CoHIdE=;
        b=VkLqPmQuOEyrYjfsulN5U4GstqydRAiI3YvNbCSLrmvgTPXwB/rEa8VnbXMhhSngPj
         Pb8AMX3WK8D3G69608TNsXE9N5iuf6Zl1pdFXmzT8GI0JeGRAxOOAsbm1jkige1SoJie
         ZIAVqnq3OEnYqIuPQH+sI3Q+9a3fYZdJ+N2roXRogeoe6tyQRHkiFNA4NOhTZlnyQB3Q
         J6w8tbbB6JE0C3JdZ6Iog3qoIjZYxZyu5YBIOCKDcyaDvzA64LrCz7hMTQR/GIDrAnbe
         IHZdN3L765+M0ALR52Ri2rOfEQH3uIt/edlnpg6uhXnIZImLuFfZoA8pCg9dwMX15qz4
         qScg==
X-Gm-Message-State: APjAAAWPjdzuEoH58Hx35ogCzvTDy+yzGkiyfh1WEzYMzJv2oYtU45Rt
        SvfFgMiFFHKGVO7NQOz+YWS1VtRVkpwNdQ==
X-Google-Smtp-Source: APXvYqz5wZra/C9A30s60jxmqc5nStLHxnlqkLWQ+B1O25gRbpQOXIuGcHg5wrlsF8QZ5T4qlXp61Q==
X-Received: by 2002:a5d:6347:: with SMTP id b7mr754362wrw.1.1556641783915;
        Tue, 30 Apr 2019 09:29:43 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:1ca3:6afc:30c:1068])
        by smtp.gmail.com with ESMTPSA id t67sm5848890wmg.0.2019.04.30.09.29.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 09:29:42 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linus.walleij@linaro.org,
        joakim.bech@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 0/5] synquacer - wire up Atmel SHA204A as RNG in DT and ACPI mode
Date:   Tue, 30 Apr 2019 18:29:04 +0200
Message-Id: <20190430162910.16771-1-ard.biesheuvel@linaro.org>
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

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Tudor Ambarus <tudor.ambarus@microchip.com>

Ard Biesheuvel (5):
  i2c: acpi: permit bus speed to be discovered after enumeration
  crypto: atmel-ecc: add support for ACPI probing on non-AT91 platforms
  crypto: atmel-ecc: factor out code that can be shared
  crypto: atmel-i2c: add support for SHA204A random number generator
  dt-bindings: add Atmel SHA204A I2C crypto processor

 Documentation/devicetree/bindings/crypto/atmel-crypto.txt |  13 +
 drivers/crypto/Kconfig                                    |  19 +-
 drivers/crypto/Makefile                                   |   2 +
 drivers/crypto/atmel-ecc.c                                | 403 ++------------------
 drivers/crypto/atmel-ecc.h                                | 116 ------
 drivers/crypto/atmel-i2c.c                                | 364 ++++++++++++++++++
 drivers/crypto/atmel-i2c.h                                | 196 ++++++++++
 drivers/crypto/atmel-sha204a.c                            | 171 +++++++++
 drivers/i2c/i2c-core-acpi.c                               |   6 +-
 9 files changed, 790 insertions(+), 500 deletions(-)
 delete mode 100644 drivers/crypto/atmel-ecc.h
 create mode 100644 drivers/crypto/atmel-i2c.c
 create mode 100644 drivers/crypto/atmel-i2c.h
 create mode 100644 drivers/crypto/atmel-sha204a.c

-- 
2.20.1

