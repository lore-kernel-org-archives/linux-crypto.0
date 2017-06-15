From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.12
Date: Thu, 15 Jun 2017 08:54:43 +0800
Message-ID: <20170615005443.GA30435@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161215160732.GA16580@gondor.apana.org.au>
 <20170111115646.GA8943@gondor.apana.org.au>
 <20170304074119.GA3041@gondor.apana.org.au>
 <20170523034211.GA12748@gondor.apana.org.au>
 <20170608092320.GA6478@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170608092320.GA6478@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus:

This push fixes a bug on sparc where we may dereference freed stack
memory.

 
Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


David Miller (1):
      crypto: Work around deallocated stack frame reference gcc bug on sparc.

 drivers/infiniband/sw/rxe/rxe.h |    5 ++++-
 fs/btrfs/hash.c                 |    5 ++++-
 fs/f2fs/f2fs.h                  |    5 ++++-
 lib/libcrc32c.c                 |    6 ++++--
 4 files changed, 16 insertions(+), 5 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
