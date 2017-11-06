From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.14
Date: Mon, 6 Nov 2017 14:37:38 +0800
Message-ID: <20171106063737.GA14220@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161213132414.GA7898@gondor.apana.org.au>
 <20170223125141.GA17400@gondor.apana.org.au>
 <20170714141855.GA29426@gondor.apana.org.au>
 <20170922084401.GA15541@gondor.apana.org.au>
 <20171012105101.GA29403@gondor.apana.org.au>
 <20171030072048.GA21737@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:51700 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750778AbdKFGiM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Nov 2017 01:38:12 -0500
Content-Disposition: inline
In-Reply-To: <20171030072048.GA21737@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus: 

This push fixes an unaligned panic in x86/sha-mb and a bug in ccm
that triggers with certain underlying implementations.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Andrey Ryabinin (2):
      crypto: x86/sha256-mb - fix panic due to unaligned access
      crypto: x86/sha1-mb - fix panic due to unaligned access

Romain Izard (1):
      crypto: ccm - preserve the IV buffer

 arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S     |   12 ++++++------
 arch/x86/crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S |   12 ++++++------
 crypto/ccm.c                                         |    4 +++-
 3 files changed, 15 insertions(+), 13 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
