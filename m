From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 0/3] support for interleaving in generic chaining modes
Date: Thu,  6 Feb 2014 13:25:01 +0100
Message-ID: <1391689504-28160-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
	jussi.kivilinna@iki.fi, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:56582 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084AbaBFMZF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Feb 2014 07:25:05 -0500
Received: by mail-wg0-f43.google.com with SMTP id y10so1194782wgg.34
        for <linux-crypto@vger.kernel.org>; Thu, 06 Feb 2014 04:25:03 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

My apologies if this has been discussed/debated before on linux-crypto.

When working on accelerated crypto for ARM and arm64, I noticed that many of
the existing accelerated implementations for other architectures duplicate much
of the chaining modes, not because they can be accelerated themselves but mainly
because the generic chaining mode implementations cannot present the data in
large enough chunks for the accelerated implementations to reach their optimal
speed.

This series proposes a way to improve on that. I have only implemented the CBC
example because it makes for nice a benchmark, but CTR and XTS are other obvious
candidates for the treatment.

I have included my arm64 AES cipher implementation for reference.

Ard Biesheuvel (3):
  crypto: add interleave option to cipher_alg
  crypto: take interleave into account for CBC decryption
  arm64: add Crypto Extensions based core AES cipher

 arch/arm64/Makefile               |   1 +
 arch/arm64/crypto/Makefile        |  13 ++
 arch/arm64/crypto/aes-ce-cipher.c | 257 ++++++++++++++++++++++++++++++++++++++
 crypto/Kconfig                    |   6 +
 crypto/cbc.c                      | 109 ++++++++++++----
 include/linux/crypto.h            |   4 +
 6 files changed, 363 insertions(+), 27 deletions(-)
 create mode 100644 arch/arm64/crypto/Makefile
 create mode 100644 arch/arm64/crypto/aes-ce-cipher.c

-- 
1.8.3.2
