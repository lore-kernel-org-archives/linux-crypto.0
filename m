From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.13
Date: Fri, 1 Sep 2017 15:53:39 +0800
Message-ID: <20170901075339.GA8289@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161213132414.GA7898@gondor.apana.org.au>
 <20170223125141.GA17400@gondor.apana.org.au>
 <20170714141855.GA29426@gondor.apana.org.au>
 <20170728084955.GA19586@gondor.apana.org.au>
 <20170809120424.GA32740@gondor.apana.org.au>
 <20170814094347.GA13880@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:38598 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751519AbdIAHx6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Sep 2017 03:53:58 -0400
Content-Disposition: inline
In-Reply-To: <20170814094347.GA13880@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus: 

This push fixes the following issues:

- Regression in chacha20 handling of chunked input.
- Crash in algif_skcipher when used with async io.
- Potential bogus pointer dereference in lib/mpi.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Ard Biesheuvel (2):
      crypto: chacha20 - fix handling of chunked input
      crypto: testmgr - add chunked test cases for chacha20

Stephan Mueller (2):
      lib/mpi: kunmap after finishing accessing buffer
      crypto: algif_skcipher - only call put_page on referenced and used pages

 crypto/algif_skcipher.c   |    9 +++++++--
 crypto/chacha20_generic.c |    9 +++++++--
 crypto/testmgr.h          |    7 +++++++
 lib/mpi/mpicoder.c        |    4 +++-
 4 files changed, 24 insertions(+), 5 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
