From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.12
Date: Thu, 8 Jun 2017 17:23:21 +0800
Message-ID: <20170608092320.GA6478@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161215160732.GA16580@gondor.apana.org.au>
 <20170111115646.GA8943@gondor.apana.org.au>
 <20170304074119.GA3041@gondor.apana.org.au>
 <20170523034211.GA12748@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:38120 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750725AbdFHJXq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Jun 2017 05:23:46 -0400
Content-Disposition: inline
In-Reply-To: <20170523034211.GA12748@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes a couple of places in the crypto code that were
doing interruptible sleeps dangerously.  They have been converted
to use non-interruptible sleeps.  This push also fixes a bug in
asymmetric_keys where it would trigger a use-after-free if a
request returned EBUSY due to a full device queue.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Gilad Ben-Yossef (3):
      crypto: asymmetric_keys - handle EBUSY due to backlog correctly
      crypto: drbg - wait for crypto op not signal safe
      crypto: gcm - wait for crypto op not signal safe

 crypto/asymmetric_keys/public_key.c |    2 +-
 crypto/drbg.c                       |    5 ++---
 crypto/gcm.c                        |    6 ++----
 3 files changed, 5 insertions(+), 8 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
