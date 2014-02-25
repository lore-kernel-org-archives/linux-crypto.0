From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH v2 0/3] support for interleaving in generic chaining modes
Date: Tue, 25 Feb 2014 08:34:17 +0100
Message-ID: <1393313660-5258-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:33165 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaBYHe1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Feb 2014 02:34:27 -0500
Received: by mail-we0-f177.google.com with SMTP id t61so15346wes.22
        for <linux-crypto@vger.kernel.org>; Mon, 24 Feb 2014 23:34:25 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert, all,

This is the alternate approach you suggested for interleaving in generic
chaining modes. The non-overlapping case seems an obvious win,  but may benefit
from a crypto_xor() optimized for larger sizes. For the inplace case, it is more
problematic as we still require a block count for the chunk.

Anyway, no performance numbers yet. I will post back once I produce any.

-- 
Ard.



Ard Biesheuvel (3):
  crypto: update generic ECB's driver_name to 'ecb_generic'
  crypto: use ECB to implement CBC decryption
  arm64: add Crypto Extensions based core AES cipher and 4-way ECB

 arch/arm64/Makefile               |   1 +
 arch/arm64/crypto/Makefile        |  13 ++
 arch/arm64/crypto/aes-ce-cipher.c | 382 ++++++++++++++++++++++++++++++++++++++
 crypto/Kconfig                    |   6 +
 crypto/cbc.c                      | 234 +++++++++++++++++++++--
 crypto/ecb.c                      |  12 ++
 6 files changed, 635 insertions(+), 13 deletions(-)
 create mode 100644 arch/arm64/crypto/Makefile
 create mode 100644 arch/arm64/crypto/aes-ce-cipher.c

-- 
1.8.3.2
