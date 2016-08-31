From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.8
Date: Wed, 31 Aug 2016 22:19:41 +0800
Message-ID: <20160831141941.GA26457@gondor.apana.org.au>
References: <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150415033951.GA1406@gondor.apana.org.au>
 <20150622084457.GA7806@gondor.apana.org.au>
 <20150831135655.GA2694@gondor.apana.org.au>
 <20151102080427.GA8465@gondor.apana.org.au>
 <20160111101450.GA24044@gondor.apana.org.au>
 <20160122101828.GA15966@gondor.apana.org.au>
 <20160801095821.GA1260@gondor.apana.org.au>
 <20160823095130.GA26653@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57664 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933214AbcHaOTv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Aug 2016 10:19:51 -0400
Content-Disposition: inline
In-Reply-To: <20160823095130.GA26653@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes the following issues:

- Kconfig problem that prevented mxc-rnga from being enabled.
- Bogus key sizes in qat aes-xts.
- Buggy aes-xts code in vmx.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Fabian Frederick (1):
      hwrng: mxc-rnga - Fix Kconfig dependency

Giovanni Cabiddu (1):
      crypto: qat - fix aes-xts key sizes

Li Zhong (1):
      crypto: vmx - fix null dereference in p8_aes_xts_crypt

 drivers/char/hw_random/Kconfig           |    2 +-
 drivers/crypto/qat/qat_common/qat_algs.c |    4 ++--
 drivers/crypto/vmx/aes_xts.c             |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
