From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.14
Date: Mon, 30 Oct 2017 15:20:48 +0800
Message-ID: <20171030072048.GA21737@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161213132414.GA7898@gondor.apana.org.au>
 <20170223125141.GA17400@gondor.apana.org.au>
 <20170714141855.GA29426@gondor.apana.org.au>
 <20170922084401.GA15541@gondor.apana.org.au>
 <20171012105101.GA29403@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:50404 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751536AbdJ3HVS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Oct 2017 03:21:18 -0400
Content-Disposition: inline
In-Reply-To: <20171012105101.GA29403@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus: 

This push fixes an objtool regression.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Jason A. Donenfeld (1):
      crypto: x86/chacha20 - satisfy stack validation 2.0

 arch/x86/crypto/chacha20-avx2-x86_64.S  |    4 ++--
 arch/x86/crypto/chacha20-ssse3-x86_64.S |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
