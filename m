From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.18
Date: Mon, 9 Jul 2018 00:20:35 +0800
Message-ID: <20180708162035.zunfeflnq5hgwq6n@gondor.apana.org.au>
References: <20161213132414.GA7898@gondor.apana.org.au>
 <20170223125141.GA17400@gondor.apana.org.au>
 <20170714141855.GA29426@gondor.apana.org.au>
 <20170922084401.GA15541@gondor.apana.org.au>
 <20171128230929.GA17783@gondor.apana.org.au>
 <20171222064931.GA27068@gondor.apana.org.au>
 <20180105073808.GA14405@gondor.apana.org.au>
 <20180212031702.GA26153@gondor.apana.org.au>
 <20180428080517.haxgpvqrwgotakyo@gondor.apana.org.au>
 <20180622145403.6ltjip7che227fuo@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180622145403.6ltjip7che227fuo@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus: 

This push fixes the following issues:

- Add missing RETs in x86 aegis/morus.
- Fix build error in arm speck.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Borislav Petkov (1):
      crypto: x86 - Add missing RETs

Eric Biggers (1):
      crypto: arm/speck - fix building in Thumb2 mode

 arch/arm/crypto/speck-neon-core.S     |    6 ++++--
 arch/x86/crypto/aegis128-aesni-asm.S  |    1 +
 arch/x86/crypto/aegis128l-aesni-asm.S |    1 +
 arch/x86/crypto/aegis256-aesni-asm.S  |    1 +
 arch/x86/crypto/morus1280-avx2-asm.S  |    1 +
 arch/x86/crypto/morus1280-sse2-asm.S  |    1 +
 arch/x86/crypto/morus640-sse2-asm.S   |    1 +
 7 files changed, 10 insertions(+), 2 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
