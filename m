From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.19
Date: Wed, 19 Sep 2018 14:22:01 +0800
Message-ID: <20180919062201.ov5o4vljvholgsed@gondor.apana.org.au>
References: <20170223125141.GA17400@gondor.apana.org.au>
 <20170714141855.GA29426@gondor.apana.org.au>
 <20170922084401.GA15541@gondor.apana.org.au>
 <20171128230929.GA17783@gondor.apana.org.au>
 <20171222064931.GA27068@gondor.apana.org.au>
 <20180105073808.GA14405@gondor.apana.org.au>
 <20180212031702.GA26153@gondor.apana.org.au>
 <20180428080517.haxgpvqrwgotakyo@gondor.apana.org.au>
 <20180622145403.6ltjip7che227fuo@gondor.apana.org.au>
 <20180829033353.agnzxra3jk2r2mzg@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180829033353.agnzxra3jk2r2mzg@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Greg: 

This push fixes a potential boot hang in ccp and an incorrect
CPU capability check in aegis/morus on x86.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Brijesh Singh (1):
      crypto: ccp - add timeout support in the SEV command

Ondrej Mosnacek (1):
      crypto: x86/aegis,morus - Do not require OSXSAVE for SSE2

 arch/x86/crypto/aegis128-aesni-glue.c  |  1 -
 arch/x86/crypto/aegis128l-aesni-glue.c |  1 -
 arch/x86/crypto/aegis256-aesni-glue.c  |  1 -
 arch/x86/crypto/morus1280-sse2-glue.c  |  1 -
 arch/x86/crypto/morus640-sse2-glue.c   |  1 -
 drivers/crypto/ccp/psp-dev.c           | 46 ++++++++++++++++++++++++++++++----
 6 files changed, 41 insertions(+), 10 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
