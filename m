From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 0/3] reworked ccm(aes) using blkcipher walk API
Date: Tue, 25 Feb 2014 13:57:49 +0100
Message-ID: <1393333072-15310-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:59466 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaBYM57 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Feb 2014 07:57:59 -0500
Received: by mail-wi0-f176.google.com with SMTP id hi5so4424330wib.15
        for <linux-crypto@vger.kernel.org>; Tue, 25 Feb 2014 04:57:58 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As suggested by Herbert, this is another approach to using the blkcipher walk
API from a context where no [a]blkcipher transform instance exists.

I have copied some data that is retrieved from the transform into the
blkcipher_walk struct, and added alternative blkcipher init and walk functions
that allow these data member (iv size, alignmask, etc) to be supplied directly.

Suggestions for better names than blkcipher_walk_init_raw and
blkcipher_walk_virt_raw are highly appreciated.


Ard Biesheuvel (3):
  crypto: remove direct blkcipher_walk dependency on transform
  crypto: allow blkcipher walks with no associated blkcipher transform
  arm64: add support for AES in CCM mode using Crypto Extensions

 arch/arm64/Makefile                |   1 +
 arch/arm64/crypto/Makefile         |  12 ++
 arch/arm64/crypto/aesce-ccm-core.S | 222 +++++++++++++++++++++++++++
 arch/arm64/crypto/aesce-ccm-glue.c | 301 +++++++++++++++++++++++++++++++++++++
 crypto/blkcipher.c                 |  76 +++++-----
 include/crypto/algapi.h            |  25 ++-
 6 files changed, 602 insertions(+), 35 deletions(-)
 create mode 100644 arch/arm64/crypto/Makefile
 create mode 100644 arch/arm64/crypto/aesce-ccm-core.S
 create mode 100644 arch/arm64/crypto/aesce-ccm-glue.c

-- 
1.8.3.2
