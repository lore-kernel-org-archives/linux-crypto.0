From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Update for 2.6.28
Date: Sat, 11 Oct 2008 10:13:57 +0800
Message-ID: <20081011021357.GB3685@gondor.apana.org.au>
References: <20080421024306.GA6813@gondor.apana.org.au> <20080714121403.GA28523@gondor.apana.org.au> <20081010070918.GA28057@gondor.apana.org.au> <alpine.LFD.2.00.0810101118050.3503@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:35783 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753248AbYJKCOH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Oct 2008 22:14:07 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810101118050.3503@nehalem.linux-foundation.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 10, 2008 at 11:22:44AM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 10 Oct 2008, Herbert Xu wrote:
> > 
> > Here is the crypto update for 2.6.28:
> 
> Umm. "Here" was empty.

Sorry, I somehow deleted that bit while adding the changelog :)

> Also, please us
> 
> 	git diff -M --stat --summary
> 
> for the diffstat. That way I would have seen the

Thanks, I'll run that from now on.

Here it is again:

The highlight of this batch is the new run-time self-test framework
for algorithms.  This reorganises the same tests that we've always
had such that they're run at algorithm registration time so that
only algorithms passing the tests of their type are made available
to users.  Hopefully that means people won't be sending me any
more algorithm updates that fail these tests :)

Apart from that a new algorithm type for random number generators.
The only two algorithms in that type are the existing kernel RNG
plus a PRNG based on AES.  This is used by IPsec for IV generation.

We also have a new implementation of CRC32c that uses the Intel
instruction for CRC32c.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Adrian Bunk (1):
      crypto: Kconfig - Replace leading spaces with tabs

Austin Zhang (1):
      crypto: crc32c - Use Intel CRC32 instruction

Herbert Xu (10):
      crypto: api - Export crypto_alg_lookup instead of __crypto_alg_lookup
      crypto: api - Display larval objects properly
      crypto: tcrypt - Avoid using contiguous pages
      crypto: tcrypt - Abort and only log if there is an error
      crypto: tcrypt - Add alg_test interface
      crypto: cryptomgr - Add test infrastructure
      crypto: api - Use test infrastructure
      crypto: cryptomgr - Test ciphers using ECB
      crypto: skcipher - Move IV generators into their own modules
      crypto: skcipher - Use RNG interface instead of get_random_bytes

Neil Horman (2):
      crypto: api - Add fips_enable flag
      crypto: rng - RNG interface and implementation

 arch/x86/crypto/Makefile           |    2 +
 arch/x86/crypto/crc32c-intel.c     |  197 +
 crypto/Kconfig                     |  127 +-
 crypto/Makefile                    |   12 +-
 crypto/algapi.c                    |  147 +-
 crypto/{cryptomgr.c => algboss.c}  |   92 +-
 crypto/ansi_cprng.c                |  417 ++
 crypto/api.c                       |   81 +-
 crypto/blkcipher.c                 |   29 -
 crypto/chainiv.c                   |   44 +-
 crypto/eseqiv.c                    |   35 +-
 crypto/fips.c                      |   27 +
 crypto/internal.h                  |   18 +-
 crypto/krng.c                      |   66 +
 crypto/proc.c                      |   57 +-
 crypto/rng.c                       |  126 +
 crypto/seqiv.c                     |   27 +-
 crypto/tcrypt.c                    | 1347 +-----
 crypto/tcrypt.h                    | 8709 +-----------------------------------
 crypto/testmgr.c                   | 1868 ++++++++
 crypto/{tcrypt.h => testmgr.h}     |   85 +-
 include/crypto/internal/rng.h      |   26 +
 include/crypto/internal/skcipher.h |    6 -
 include/crypto/rng.h               |   75 +
 include/linux/crypto.h             |   35 +
 25 files changed, 3531 insertions(+), 10124 deletions(-)
 create mode 100644 arch/x86/crypto/crc32c-intel.c
 rename crypto/{cryptomgr.c => algboss.c} (69%)
 create mode 100644 crypto/ansi_cprng.c
 create mode 100644 crypto/fips.c
 create mode 100644 crypto/krng.c
 create mode 100644 crypto/rng.c
 create mode 100644 crypto/testmgr.c
 copy crypto/{tcrypt.h => testmgr.h} (99%)
 create mode 100644 include/crypto/internal/rng.h
 create mode 100644 include/crypto/rng.h

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
