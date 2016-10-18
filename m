From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/5] ARM: add module autoloading support for crypto modules
Date: Tue, 18 Oct 2016 11:52:14 +0100
Message-ID: <1476787939-21889-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: steve.capper@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux@arm.linux.org.uk, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:36495 "EHLO
        mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752193AbcJRKwc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Oct 2016 06:52:32 -0400
Received: by mail-lf0-f50.google.com with SMTP id b75so340890317lfg.3
        for <linux-crypto@vger.kernel.org>; Tue, 18 Oct 2016 03:52:31 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series wires up the crypto modules that use the ARM 32-bit versions of
the ARMv8 Crypto Extensions to udev autoloading, by exposing the HWCAP2
feature bits via the CPU modalias. This is very similar to the arm64
implementation, with the notable exception that ARM has its CPU feature
definitions split across HWCAP and HWCAP2.

Given that the crypto feature bits are all exposed via HWCAP2, and considering
that there are currently no features exposed via HWCAP that are relevant to
udev module autoloading, exposing HWCAP2 only should be sufficient, at least
for now.

Note to Herbert: patches #2 - #5 all depend on #1, which requires an ack from
Russell, so please don't pull anything until #1 has been acked and/or merged.

Ard Biesheuvel (5):
  ARM: wire up HWCAP2 feature bits to the CPU modalias
  crypto: arm/aes-ce - enable module autoloading based on CPU feature
    bits
  crypto: arm/ghash-ce - enable module autoloading based on CPU feature
    bits
  crypto: arm/sha1-ce - enable module autoloading based on CPU feature
    bits
  crypto: arm/sha2-ce - enable module autoloading based on CPU feature
    bits

 arch/arm/Kconfig                  |  1 +
 arch/arm/crypto/aes-ce-glue.c     |  5 ++-
 arch/arm/crypto/ghash-ce-glue.c   |  6 ++--
 arch/arm/crypto/sha1-ce-glue.c    |  5 ++-
 arch/arm/crypto/sha2-ce-glue.c    |  5 ++-
 arch/arm/include/asm/cpufeature.h | 32 ++++++++++++++++++++
 6 files changed, 41 insertions(+), 13 deletions(-)
 create mode 100644 arch/arm/include/asm/cpufeature.h

-- 
2.7.4
