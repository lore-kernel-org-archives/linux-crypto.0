From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.18
Date: Thu, 9 Aug 2018 13:47:09 +0800
Message-ID: <20180809054709.gd5whukrd3vf6j3m@gondor.apana.org.au>
References: <20170714141855.GA29426@gondor.apana.org.au>
 <20170922084401.GA15541@gondor.apana.org.au>
 <20171128230929.GA17783@gondor.apana.org.au>
 <20171222064931.GA27068@gondor.apana.org.au>
 <20180105073808.GA14405@gondor.apana.org.au>
 <20180212031702.GA26153@gondor.apana.org.au>
 <20180428080517.haxgpvqrwgotakyo@gondor.apana.org.au>
 <20180622145403.6ltjip7che227fuo@gondor.apana.org.au>
 <20180719073931.q5ny7tqgwws27lnq@gondor.apana.org.au>
 <20180803054420.4eehj2uneqimcf7g@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180803054420.4eehj2uneqimcf7g@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus: 

This push fixes a performance regression in arm64 NEON crypto as
well as a crash in x86 aegis/morus on unsupported CPUs.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Ard Biesheuvel (1):
      crypto: arm64 - revert NEON yield for fast AEAD implementations

Ondrej Mosnacek (1):
      crypto: x86/aegis,morus - Fix and simplify CPUID checks

 arch/arm64/crypto/aes-ce-ccm-core.S    |  150 ++++++++++++--------------------
 arch/arm64/crypto/ghash-ce-core.S      |   76 ++++++----------
 arch/x86/crypto/aegis128-aesni-glue.c  |   12 +--
 arch/x86/crypto/aegis128l-aesni-glue.c |   12 +--
 arch/x86/crypto/aegis256-aesni-glue.c  |   12 +--
 arch/x86/crypto/morus1280-avx2-glue.c  |   10 +--
 arch/x86/crypto/morus1280-sse2-glue.c  |   10 +--
 arch/x86/crypto/morus640-sse2-glue.c   |   10 +--
 8 files changed, 101 insertions(+), 191 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
