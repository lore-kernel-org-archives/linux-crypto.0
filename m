From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 0/3] crypto: poly1305 - get rid of cra_alignmask
Date: Fri, 29 Dec 2017 10:10:23 -0600
Message-ID: <20171229161026.28102-1-ebiggers3@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Martin Willi <martin@strongswan.org>,
        Eric Biggers <ebiggers3@gmail.com>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:36870 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751246AbdL2QM4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Dec 2017 11:12:56 -0500
Received: by mail-it0-f67.google.com with SMTP id d137so32022179itc.2
        for <linux-crypto@vger.kernel.org>; Fri, 29 Dec 2017 08:12:56 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series gets rid of the cra_alignmask set on poly1305-generic and
poly1305-simd, since it was only actually used when outputting the final
digest.  By removing the alignmask, the crypto API will no longer need
to waste time aligning the buffers.

Eric Biggers (3):
  crypto: poly1305 - use unaligned access macros to output digest
  crypto: poly1305 - remove cra_alignmask
  crypto: x86/poly1305 - remove cra_alignmask

 arch/x86/crypto/poly1305_glue.c |  1 -
 crypto/poly1305_generic.c       | 10 ++++------
 2 files changed, 4 insertions(+), 7 deletions(-)

-- 
2.15.1
