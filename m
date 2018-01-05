From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH v2 0/3] crypto: salsa20 - cleanup and convert to skcipher API
Date: Fri,  5 Jan 2018 11:09:56 -0800
Message-ID: <20180105190959.89682-1-ebiggers3@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:45372 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752231AbeAETLX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jan 2018 14:11:23 -0500
Received: by mail-it0-f68.google.com with SMTP id z6so2663513iti.4
        for <linux-crypto@vger.kernel.org>; Fri, 05 Jan 2018 11:11:23 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

This series converts the Salsa20 implementations over to the skcipher
API, in the process fixing a couple bugs and making them be more similar
to the ChaCha20 implementations, rather than doing things slightly
differently for no good reason.  (Note, however, that Salsa20 still
interprets the IV differently from ChaCha20; I didn't change that.)

I'm not sure who is actually using Salsa20 in the kernel, but either way
if we're going to have it at all we might as well keep it up to date.

The Salsa20 algorithms still pass the self-tests after these changes.

Changed since v1:

    - Use '__le32' type for keystream, as suggested by Stephan.

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
2.16.0.rc0.223.g4a4ac83678-goog
