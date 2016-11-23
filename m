From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.9
Date: Wed, 23 Nov 2016 13:36:58 +0800
Message-ID: <20161123053658.GA23532@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39437 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750824AbcKWFmP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Nov 2016 00:42:15 -0500
Content-Disposition: inline
In-Reply-To: <20161119102748.GA4277@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

The last push broke algif_hash for all shash implementations,
so this is a follow-up to fix that.  It also fixes a problem
in the crypto scatterwalk that triggers a BUG_ON with certain
debugging options due to the new vmalloced-stack code.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Herbert Xu (2):
      crypto: algif_hash - Fix result clobbering in recvmsg
      crypto: scatterwalk - Remove unnecessary aliasing check in map_and_copy

 crypto/algif_hash.c  |    2 +-
 crypto/scatterwalk.c |    4 ----
 2 files changed, 1 insertion(+), 5 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
