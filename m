From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 0/6] crypto: module alias fixes
Date: Sun, 11 Jan 2015 18:17:41 +0100
Message-ID: <1420996667-31693-1-git-send-email-minipli@googlemail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:53944 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbbAKRSM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 11 Jan 2015 12:18:12 -0500
Received: by mail-wi0-f177.google.com with SMTP id l15so10631675wiw.4
        for <linux-crypto@vger.kernel.org>; Sun, 11 Jan 2015 09:18:11 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

this series is a follow up to commit 5d26a105b5a7 ("crypto: prefix
module autoloading with "crypto-""). In patch 1 it adds the required
MODULE_ALIAS_CRYPTO annotation where needed to bring back automatic
crypto module loading. Namely, modules that have a file name matching
the cipher they implement still need the MODULE_ALIAS_CRYPTO()
annotation. Otherwise they won't get loaded.

Patches 2 to 6 fix bogus module descriptions or aliases with the
exception of patch 4 which adds a missing crypto module alias.

At least patch 1 should go to crypto-2.6 to not regress the crypto API
for v3.19 in regard to automatic module loading.

The others are probably safe to apply, too.

Please apply!

Thanks,

Mathias Krause (6):
  crypto: add missing crypto module aliases
  crypto: sparc64/aes - fix module description
  crypto: sparc64/camellia - fix module alias
  crypto: sparc64/des - add "des3_ede" module alias
  crypto: sparc64/md5 - fix module description
  crypto: x86/des3_ede - drop bogus module aliases

 arch/powerpc/crypto/sha1.c        |    1 +
 arch/sparc/crypto/aes_glue.c      |    2 +-
 arch/sparc/crypto/camellia_glue.c |    2 +-
 arch/sparc/crypto/des_glue.c      |    1 +
 arch/sparc/crypto/md5_glue.c      |    2 +-
 arch/x86/crypto/des3_ede_glue.c   |    2 --
 arch/x86/crypto/sha-mb/sha1_mb.c  |    2 +-
 crypto/aes_generic.c              |    1 +
 crypto/ansi_cprng.c               |    1 +
 crypto/blowfish_generic.c         |    1 +
 crypto/camellia_generic.c         |    1 +
 crypto/cast5_generic.c            |    1 +
 crypto/cast6_generic.c            |    1 +
 crypto/crc32c_generic.c           |    1 +
 crypto/crct10dif_generic.c        |    1 +
 crypto/des_generic.c              |    7 ++++---
 crypto/ghash-generic.c            |    1 +
 crypto/krng.c                     |    1 +
 crypto/salsa20_generic.c          |    1 +
 crypto/serpent_generic.c          |    1 +
 crypto/sha1_generic.c             |    1 +
 crypto/sha256_generic.c           |    2 ++
 crypto/sha512_generic.c           |    2 ++
 crypto/tea.c                      |    1 +
 crypto/tgr192.c                   |    1 +
 crypto/twofish_generic.c          |    1 +
 crypto/wp512.c                    |    1 +
 27 files changed, 31 insertions(+), 9 deletions(-)

-- 
1.7.10.4
