From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.9
Date: Sat, 19 Nov 2016 18:27:48 +0800
Message-ID: <20161119102748.GA4277@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43359 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752421AbcKSK3B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 19 Nov 2016 05:29:01 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes the following issues:

- Compiler warning in caam driver that was the last one remaining.
- Do not register aes-xts in caam drivers on unsupported platforms.
- Regression in algif_hash interface that may lead to an oops.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Arnd Bergmann (1):
      crypto: caam - fix type mismatch warning

Herbert Xu (1):
      crypto: algif_hash - Fix NULL hash crash with shash

Sven Ebenfeld (1):
      crypto: caam - do not register AES-XTS mode on LP units

 crypto/algif_hash.c           |   17 ++++++++++-------
 drivers/crypto/caam/caamalg.c |   11 ++++++++++-
 2 files changed, 20 insertions(+), 8 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
