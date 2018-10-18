Return-Path: <SRS0=XFsj=M6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727297AbeJRMiq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Oct 2018 08:38:46 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Paul Crowley <paulcrowley@google.com>
Subject: [PATCH v3 0/2] crypto: some hardening against AES cache-timing attacks
Date: Wed, 17 Oct 2018 21:37:57 -0700
Message-Id: <20181018043759.7669-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series makes the "aes-fixed-time" and "aes-arm" implementations of
AES more resistant to cache-timing attacks.

Note that even after these changes, the implementations still aren't
necessarily guaranteed to be constant-time; see
https://cr.yp.to/antiforgery/cachetiming-20050414.pdf for a discussion
of the many difficulties involved in writing truly constant-time AES
software.  But it's valuable to make such attacks more difficult.

Changed since v2:
- In aes-arm, move the IRQ disable/enable into the assembly file.
- Other aes-arm tweaks.
- Add Kconfig help text.

Thanks to Ard Biesheuvel for the suggestions.

Eric Biggers (2):
  crypto: aes_ti - disable interrupts while accessing S-box
  crypto: arm/aes - add some hardening against cache-timing attacks

 arch/arm/crypto/Kconfig           |  9 +++++
 arch/arm/crypto/aes-cipher-core.S | 62 ++++++++++++++++++++++++++-----
 crypto/Kconfig                    |  3 +-
 crypto/aes_generic.c              |  9 +++--
 crypto/aes_ti.c                   | 18 +++++++++
 5 files changed, 86 insertions(+), 15 deletions(-)

-- 
2.19.1
