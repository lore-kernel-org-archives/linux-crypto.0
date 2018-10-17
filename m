Return-Path: <SRS0=Iqog=M5=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726429AbeJQOMm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Oct 2018 10:12:42 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Paul Crowley <paulcrowley@google.com>
Subject: [PATCH v2 0/2] crypto: some hardening against AES cache-timing attacks
Date: Tue, 16 Oct 2018 23:18:11 -0700
Message-Id: <20181017061813.32751-1-ebiggers@kernel.org>
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

Eric Biggers (2):
  crypto: aes_ti - disable interrupts while accessing S-box
  crypto: arm/aes - add some hardening against cache-timing attacks

 arch/arm/crypto/aes-cipher-core.S | 26 ++++++++++++++++++++++++++
 arch/arm/crypto/aes-cipher-glue.c | 13 +++++++++++++
 crypto/aes_generic.c              |  9 +++++----
 crypto/aes_ti.c                   | 18 ++++++++++++++++++
 4 files changed, 62 insertions(+), 4 deletions(-)

-- 
2.19.1
