Return-Path: <SRS0=1iZj=N3=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37684 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727370AbeKPQm7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Nov 2018 11:42:59 -0500
Date: Fri, 16 Nov 2018 14:31:46 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Fixes for 4.20
Message-ID: <20181116063146.e7a3mep3ghnfltxe@gondor.apana.org.au>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180829033353.agnzxra3jk2r2mzg@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus: 

This push fixes the following issues:

- Potential memory overwrite in simd.
- Kernel info leaks in crypto_user.
- NULL dereference and use-after-free in hisilicon.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Ard Biesheuvel (1):
      crypto: simd - correctly take reqsize of wrapped skcipher into account

Corentin Labbe (1):
      crypto: user - Zeroize whole structure given to user space

Eric Biggers (1):
      crypto: user - fix leaking uninitialized memory to userspace

John Garry (2):
      crypto: hisilicon - Fix NULL dereference for same dst and src
      crypto: hisilicon - Fix reference after free of memories on error path

 crypto/crypto_user_base.c               | 18 +++++++++---------
 crypto/crypto_user_stat.c               | 21 +++++++++++++++++++++
 crypto/simd.c                           |  5 +++--
 drivers/crypto/hisilicon/sec/sec_algs.c | 31 +++++++++++++++++--------------
 4 files changed, 50 insertions(+), 25 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
