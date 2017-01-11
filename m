From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.10
Date: Wed, 11 Jan 2017 19:56:46 +0800
Message-ID: <20170111115646.GA8943@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161215160732.GA16580@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161215160732.GA16580@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus:

This push fixes a regression in aesni that renders it useless
if it's built-in with a modular pcbc configuration.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Herbert Xu (1):
      crypto: aesni - Fix failure when built-in with modular pcbc

 arch/x86/crypto/aesni-intel_glue.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)
 
Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
