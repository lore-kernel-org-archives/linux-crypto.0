From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 0/3] crypto: salsa20 - cleanup and convert to skcipher API
Date: Sun, 31 Dec 2017 17:46:39 -0600
Message-ID: <20171231234642.22621-1-ebiggers3@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers3@gmail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:44555 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750936AbdLaXwB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 31 Dec 2017 18:52:01 -0500
Received: by mail-it0-f66.google.com with SMTP id b5so35644406itc.3
        for <linux-crypto@vger.kernel.org>; Sun, 31 Dec 2017 15:52:01 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series converts the Salsa20 implementations over to the skcipher
API, in the process fixing a couple bugs and making them be more similar
to the ChaCha20 implementations, rather than doing things slightly
differently for no good reason.  (Note, however, that Salsa20 still
interprets the IV differently from ChaCha20; I didn't change that.)

I'm not sure who is actually using Salsa20 in the kernel, but either way
if we're going to have it at all we might as well keep it up to date.

The Salsa20 algorithms still pass the self-tests after these changes.

Eric Biggers (3):
  crypto: salsa20-generic - cleanup and convert to skcipher API
  crypto: salsa20 - export generic helpers
  crypto: x86/salsa20 - cleanup and convert to skcipher API

 arch/x86/crypto/salsa20-i586-asm_32.S   | 184 +-----------------------
 arch/x86/crypto/salsa20-x86_64-asm_64.S | 114 ---------------
 arch/x86/crypto/salsa20_glue.c          | 105 ++++++--------
 crypto/Kconfig                          |   2 +
 crypto/salsa20_generic.c                | 240 ++++++++++++++------------------
 include/crypto/salsa20.h                |  27 ++++
 6 files changed, 174 insertions(+), 498 deletions(-)
 create mode 100644 include/crypto/salsa20.h

-- 
2.15.1
