Return-Path: <SRS0=FsAa=P2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:48442 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfARKkK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jan 2019 05:40:10 -0500
Date: Fri, 18 Jan 2019 18:40:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Fixes for 5.0
Message-ID: <20190118104006.ye5amhxkgd4xrbmc@gondor.apana.org.au>
References: <20170922084401.GA15541@gondor.apana.org.au>
 <20171128230929.GA17783@gondor.apana.org.au>
 <20171222064931.GA27068@gondor.apana.org.au>
 <20180105073808.GA14405@gondor.apana.org.au>
 <20180212031702.GA26153@gondor.apana.org.au>
 <20180428080517.haxgpvqrwgotakyo@gondor.apana.org.au>
 <20180622145403.6ltjip7che227fuo@gondor.apana.org.au>
 <20180829033353.agnzxra3jk2r2mzg@gondor.apana.org.au>
 <20181116063146.e7a3mep3ghnfltxe@gondor.apana.org.au>
 <20181207061409.xflg423nknleuddw@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181207061409.xflg423nknleuddw@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus: 

This push fixes the following issues:

- Zero-length DMA mapping in caam.
- Illegalling mapping stack memory for DMA in talitos.
- Use after free in cavium/nitrox.
- Key parsing in authenc.
- Undefined shift in sm3.
- Bogus completion call in authencesn.
- SHA support detection in caam.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Aymen Sghaier (1):
      crypto: caam - fix zero-length buffer DMA mapping

Christophe Leroy (2):
      crypto: talitos - reorder code in talitos_edesc_alloc()
      crypto: talitos - fix ablkcipher for CONFIG_VMAP_STACK

Dan Carpenter (1):
      crypto: cavium/nitrox - Use after free in process_response_list()

Eric Biggers (5):
      crypto: authenc - fix parsing key with misaligned rta_len
      crypto: bcm - convert to use crypto_authenc_extractkeys()
      crypto: ccree - convert to use crypto_authenc_extractkeys()
      crypto: adiantum - initialize crypto_spawn::inst
      crypto: sm3 - fix undefined shift by >= width of value

Harsh Jain (1):
      crypto: authencesn - Avoid twice completion call in decrypt path

Horia Geantă (1):
      crypto: caam - fix SHA support detection

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
