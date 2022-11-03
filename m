Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E28C433FE
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Nov 2022 19:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbiKCTZG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Nov 2022 15:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231807AbiKCTYr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Nov 2022 15:24:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A6C20364
        for <linux-crypto@vger.kernel.org>; Thu,  3 Nov 2022 12:23:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65B9AB826EE
        for <linux-crypto@vger.kernel.org>; Thu,  3 Nov 2022 19:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E02C433D6;
        Thu,  3 Nov 2022 19:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667503394;
        bh=uD9z3lBJwG61ECI8oHXCaUwxV244EERQyZecdKpsLhE=;
        h=From:To:Cc:Subject:Date:From;
        b=nfCYENU02Xfr4My1iwGMlFPfP+W2STfzVpI7nggoIU+NBhDIBWlpLZLRin7eIAEO5
         tfwt+kJL/Fbw2Rx647MrYpda+gbeZ1hKqG9ZssaBOT9icV852x9Njll3CB6E8FHnPY
         PtaMEe/nZ7+8YFYQjZyMUQ04cKA4CnyCwobFRONZbseO3pn2bSAortM5CJ/UuVgVEe
         GtsfXDIi4Ahg+zO7Rh3OgFDO+aL/5My8eSAH+6AbCeKa0cBUMVYYnftJcEiqOAOnKv
         npIy9r4fCMmrN+Z6bKBK/UqZsDDZRcJAzYsdsBeT9ojjzliPq8jYJTLkDfGorvuUL4
         v+IbjJmTf7AOQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, keescook@chromium.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Robert Elliott <elliott@hpe.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Nikunj A Dadhania <nikunj@amd.com>
Subject: [PATCH v5 0/3] crypto: Add AES-GCM implementation to lib/crypto
Date:   Thu,  3 Nov 2022 20:22:56 +0100
Message-Id: <20221103192259.2229-1-ardb@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2835; i=ardb@kernel.org; h=from:subject; bh=uD9z3lBJwG61ECI8oHXCaUwxV244EERQyZecdKpsLhE=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBjZBUN4D8KkeQV3FOz1yRwYszqfnVgJmNPOnz6Ap4K jQk24ZGJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCY2QVDQAKCRDDTyI5ktmPJCcAC/ 4iWVBHer/xx0QbbtmN3ZS8Jx0UReLOM8GNSVKliYwnAGETX9hcjAwf8urPkXur5vAEuc4yD3TOAVVB M/xO7n+AZrF5GGwXjXW9mNPpzi1Rd8VMW/AXw3fs0ESwHzWUB808/H3DuIYZkmey3mv8J6jt0iiYsX +ZL++7gf3uyll/xzNMeAJvAmWxSCVpnAPdsi6LvZWTmhqj+u85Xnn0CeSbx/8C8eWjTJXE7M+5MOkF ObzN31j087xNdm46mQZGRxWsaGLOJ+nMip3SDfKzK/iqIhWkjNfyyUqQCysSK0/an+NlrViS3eJgL2 CAMoHpKDAhhCciHyUIoC0HLfk/vLSJAxkhOEuEx70SLKx5lcFEp/6Tmh6e8KD7jtaoEQJ9V2oSSOBK 5St47sm6yzbXO2swgUKWaMOzQfQ/53puJApnbCK22eUk5n3NoEiEaQ+pN1MsGswLJMdMBRmfqgO/Dd CVxvANKBHtPduo74VUTKcg4rNzC9nFjqG9DMvWwZa9otE=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Provide a generic library implementation of AES-GCM which can be used
really early during boot, e.g., to communicate with the security
coprocessor on SEV-SNP virtual machines to bring up secondary cores.
This is needed because the crypto API is not available yet this early.

We cannot rely on special instructions for AES or polynomial
multiplication, which are arch specific and rely on in-kernel SIMD
infrastructure. Instead, add a generic C implementation that combines
the existing C implementations of AES and multiplication in GF(2^128).

To reduce the risk of forgery attacks, replace data dependent table
lookups and conditional branches in the used gf128mul routine with
constant-time equivalents. The AES library has already been robustified
to some extent to prevent known-plaintext timing attacks on the key, but
we call it with interrupts disabled to make it a bit more robust. (Note
that in SEV-SNP context, the VMM is untrusted, and is able to inject
interrupts arbitrarily, and potentially maliciously.)

Changes since v4:
- Rename CONFIG_CRYPTO_GF128MUL to CONFIG_CRYPTO_LIB_GF128MUL
- Use bool return value for decrypt routine to align with other AEAD
  library code
- Return -ENODEV on selftest failure to align with other algos
- Use pr_err() not WARN() on selftest failure for the same reason
- Mention in a code comment that the counter cannot roll over or result
  in a carry due to the width of the type representing the size of the
  input

Changes since v3:
- rename GCM-AES to AES-GCM

Changes since v2:
- move gf128mul to lib/crypto
- add patch #2 to make gf128mul_lle constant time
- fix kerneldoc headers and drop them from the .h file

Changes since v1:
- rename gcm to gcmaes to reflect that GCM is also used in
  combination with other symmetric ciphers (Jason)
- add Nikunj's Tested-by

Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Robert Elliott <elliott@hpe.com>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Nikunj A Dadhania <nikunj@amd.com>

Ard Biesheuvel (3):
  crypto: move gf128mul library into lib/crypto
  crypto: gf128mul - make gf128mul_lle time invariant
  crypto: aesgcm - Provide minimal library implementation

 arch/arm/crypto/Kconfig           |   2 +-
 arch/arm64/crypto/Kconfig         |   2 +-
 crypto/Kconfig                    |   9 +-
 crypto/Makefile                   |   1 -
 drivers/crypto/chelsio/Kconfig    |   2 +-
 include/crypto/gcm.h              |  22 +
 lib/crypto/Kconfig                |   9 +
 lib/crypto/Makefile               |   5 +
 lib/crypto/aesgcm.c               | 727 ++++++++++++++++++++
 {crypto => lib/crypto}/gf128mul.c |  58 +-
 10 files changed, 808 insertions(+), 29 deletions(-)
 create mode 100644 lib/crypto/aesgcm.c
 rename {crypto => lib/crypto}/gf128mul.c (87%)

-- 
2.35.1

