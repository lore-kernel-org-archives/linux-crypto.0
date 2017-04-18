From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.11
Date: Tue, 18 Apr 2017 18:27:49 +0800
Message-ID: <20170418102748.GA574@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161215160732.GA16580@gondor.apana.org.au>
 <20170111115646.GA8943@gondor.apana.org.au>
 <20170304074119.GA3041@gondor.apana.org.au>
 <20170315063151.GA6767@gondor.apana.org.au>
 <20170324134627.GA14273@gondor.apana.org.au>
 <20170331102907.GA11348@gondor.apana.org.au>
 <20170410110432.GA8731@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [198.176.57.175] ([198.176.57.175]:52482 "EHLO
        deadmen.hmeau.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755671AbdDRK2V (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Apr 2017 06:28:21 -0400
Content-Disposition: inline
In-Reply-To: <20170410110432.GA8731@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes the following problems:

- Regression in new XTS/LRW code when used with async crypto.
- Long-standing bug in ahash API when used with certain algos.
- Bogus memory dereference in async algif_aead with certain algos.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Herbert Xu (4):
      crypto: xts - Fix use-after-free on EINPROGRESS
      crypto: lrw - Fix use-after-free on EINPROGRESS
      crypto: ahash - Fix EINPROGRESS notification callback
      crypto: algif_aead - Fix bogus request dereference in completion function

 crypto/ahash.c                 |   79 +++++++++++++++++++++++++---------------
 crypto/algif_aead.c            |   12 +++---
 crypto/lrw.c                   |   16 ++++++++
 crypto/xts.c                   |   16 ++++++++
 include/crypto/internal/hash.h |   10 +++++
 5 files changed, 98 insertions(+), 35 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
