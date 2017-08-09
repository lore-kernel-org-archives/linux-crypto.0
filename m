From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.13
Date: Wed, 9 Aug 2017 20:04:24 +0800
Message-ID: <20170809120424.GA32740@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161213132414.GA7898@gondor.apana.org.au>
 <20170223125141.GA17400@gondor.apana.org.au>
 <20170714141855.GA29426@gondor.apana.org.au>
 <20170728084955.GA19586@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170728084955.GA19586@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus: 

This push fixes two regressions in the inside-secure driver with
respect to hmac(sha1).


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Antoine Tenart (2):
      crypto: inside-secure - fix invalidation check in hmac_sha1_setkey
      crypto: inside-secure - fix the sha state length in hmac_sha1_setkey

 drivers/crypto/inside-secure/safexcel_hash.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)
 
Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
