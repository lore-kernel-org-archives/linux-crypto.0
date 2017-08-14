From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.13
Date: Mon, 14 Aug 2017 17:43:47 +0800
Message-ID: <20170814094347.GA13880@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161213132414.GA7898@gondor.apana.org.au>
 <20170223125141.GA17400@gondor.apana.org.au>
 <20170714141855.GA29426@gondor.apana.org.au>
 <20170728084955.GA19586@gondor.apana.org.au>
 <20170809120424.GA32740@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:44608 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751653AbdHNJoC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Aug 2017 05:44:02 -0400
Content-Disposition: inline
In-Reply-To: <20170809120424.GA32740@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus: 

This push fixes an error path bug in ixp4xx as well as a read
overrun in sha1-avx2.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Herbert Xu (1):
      crypto: ixp4xx - Fix error handling path in 'aead_perform()'

megha.dey@linux.intel.com (1):
      crypto: x86/sha1 - Fix reads beyond the number of blocks passed

 arch/x86/crypto/sha1_avx2_x86_64_asm.S |   67 +++++++++++++++++---------------
 arch/x86/crypto/sha1_ssse3_glue.c      |    2 +-
 drivers/crypto/ixp4xx_crypto.c         |    6 +--
 3 files changed, 40 insertions(+), 35 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
