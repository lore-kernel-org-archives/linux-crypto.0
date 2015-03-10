From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 0/5] ARM: crypto: ARMv8 Crypto Extensions
Date: Tue, 10 Mar 2015 09:47:43 +0100
Message-ID: <1425977268-27835-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: nico@linaro.org, will.deacon@arm.com,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: herbert@gondor.apana.org.au, jussi.kivilinna@iki.fi,
	linux-crypto@vger.kernel.org, linux@arm.linux.org.uk,
	linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:33446 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbbCJIr6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Mar 2015 04:47:58 -0400
Received: by wggz12 with SMTP id z12so180793wgg.0
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2015 01:47:57 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is v2 of the ARM crypto series I sent out yesterday, erroneously without
a cover letter.

Patch #1 moves all the ARM specific crypto options to arch/arm/crypto/Kconfig.

Patches #2 - #5 implement SHA1, SHA-224/256, AES-ECB/CBC/CTR/XTS and GHASH,
respectively.

Changes since v1:
- fixes for BE (currently still untested)
- added alignment hints where appropriate (e,g., [rX, :128])
- various minor tweaks

There are all tested on LE using the respective tcrypt tests.

Ard Biesheuvel (5):
  crypto/arm: move ARM specific Kconfig definitions to a dedicated file
  crypto/arm: add support for SHA1 using ARMv8 Crypto Instructions
  crypto/arm: add support for SHA-224/256 using ARMv8 Crypto Extensions
  crypto/arm: AES in ECB/CBC/CTR/XTS modes using ARMv8 Crypto Extensions
  crypto/arm: add support for GHASH using ARMv8 Crypto Extensions

 arch/arm/Kconfig                |   3 +
 arch/arm/crypto/Kconfig         | 123 ++++++++++
 arch/arm/crypto/Makefile        |   8 +
 arch/arm/crypto/aes-ce-core.S   | 518 +++++++++++++++++++++++++++++++++++++++
 arch/arm/crypto/aes-ce-glue.c   | 520 ++++++++++++++++++++++++++++++++++++++++
 arch/arm/crypto/ghash-ce-core.S |  94 ++++++++
 arch/arm/crypto/ghash-ce-glue.c | 318 ++++++++++++++++++++++++
 arch/arm/crypto/sha1-ce-core.S  | 134 +++++++++++
 arch/arm/crypto/sha1-ce-glue.c  | 150 ++++++++++++
 arch/arm/crypto/sha2-ce-core.S  | 134 +++++++++++
 arch/arm/crypto/sha2-ce-glue.c  | 203 ++++++++++++++++
 crypto/Kconfig                  |  75 ------
 12 files changed, 2205 insertions(+), 75 deletions(-)
 create mode 100644 arch/arm/crypto/Kconfig
 create mode 100644 arch/arm/crypto/aes-ce-core.S
 create mode 100644 arch/arm/crypto/aes-ce-glue.c
 create mode 100644 arch/arm/crypto/ghash-ce-core.S
 create mode 100644 arch/arm/crypto/ghash-ce-glue.c
 create mode 100644 arch/arm/crypto/sha1-ce-core.S
 create mode 100644 arch/arm/crypto/sha1-ce-glue.c
 create mode 100644 arch/arm/crypto/sha2-ce-core.S
 create mode 100644 arch/arm/crypto/sha2-ce-glue.c

-- 
1.8.3.2
