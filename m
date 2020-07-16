Return-Path: <SRS0=7zOR=A3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4DD1C433E5
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 11:55:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F5DD207BB
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 11:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbgGPLzm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jul 2020 07:55:42 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:40138 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726855AbgGPLzl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jul 2020 07:55:41 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jw2UE-0008Sa-Mh; Thu, 16 Jul 2020 21:55:39 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Jul 2020 21:55:38 +1000
Date:   Thu, 16 Jul 2020 21:55:38 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     mpatocka@redhat.com, linux-crypto@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: [PATCH v2 0/7] crypto: add CRYPTO_ALG_ALLOCATES_MEMORY
Message-ID: <20200716115538.GA31461@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710062042.113842-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
> This series introduces a flag that algorithms can set to indicate that
> they allocate memory during processing of typical inputs, and thus
> shouldn't be used in cases like dm-crypt where memory allocation
> failures aren't acceptable.
> 
> Compared to Mikulas's patches, I've made the following improvements:
> 
> - Tried to clearly document the semantics of
>  CRYPTO_ALG_ALLOCATES_MEMORY.  This includes documenting the usage
>  constraints, since there are actually lots of cases that were
>  overlooked where algorithms can still allocate memory in some edge
>  cases where inputs are misaligned, fragemented, etc.  E.g. see
>  crypto/skcipher.c and crypto/ahash.c.  Mikulas, please let me know if
>  there are any concerns for dm-crypt.
> 
> - Moved the common mechanism for inheriting flags to its own patch.
> 
> - crypto_grab_spawn() now handles propagating CRYPTO_ALG_INHERITED_FLAGS
>  to the new template instance.
> 
> - Inherit the flags in various places that were missed.
> 
> - Other cleanups.
> 
> Additional changes v1 => v2:
> 
> - Made crypto_check_attr_type() return the mask.
> 
> - Added patch that adds NEED_FALLBACK to INHERITED_FLAGS.
> 
> - Added patch that removes seqiv_create().
> 
> Eric Biggers (5):
>  crypto: geniv - remove unneeded arguments from aead_geniv_alloc()
>  crypto: seqiv - remove seqiv_create()
>  crypto: algapi - use common mechanism for inheriting flags
>  crypto: algapi - add NEED_FALLBACK to INHERITED_FLAGS
>  crypto: algapi - introduce the flag CRYPTO_ALG_ALLOCATES_MEMORY
> 
> Mikulas Patocka (2):
>  crypto: drivers - set the flag CRYPTO_ALG_ALLOCATES_MEMORY
>  dm-crypt: don't use drivers that have CRYPTO_ALG_ALLOCATES_MEMORY
> 
> crypto/adiantum.c                             |  14 +--
> crypto/algapi.c                               |  21 +++-
> crypto/authenc.c                              |  14 +--
> crypto/authencesn.c                           |  14 +--
> crypto/ccm.c                                  |  33 ++---
> crypto/chacha20poly1305.c                     |  14 +--
> crypto/cmac.c                                 |   5 +-
> crypto/cryptd.c                               |  59 ++++-----
> crypto/ctr.c                                  |  17 +--
> crypto/cts.c                                  |  13 +-
> crypto/echainiv.c                             |   2 +-
> crypto/essiv.c                                |  11 +-
> crypto/gcm.c                                  |  40 ++----
> crypto/geniv.c                                |  19 +--
> crypto/hmac.c                                 |   5 +-
> crypto/lrw.c                                  |  13 +-
> crypto/pcrypt.c                               |  14 +--
> crypto/rsa-pkcs1pad.c                         |  13 +-
> crypto/seqiv.c                                |  18 +--
> crypto/simd.c                                 |   6 +-
> crypto/skcipher.c                             |  13 +-
> crypto/vmac.c                                 |   5 +-
> crypto/xcbc.c                                 |   5 +-
> crypto/xts.c                                  |  15 +--
> .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c |  12 +-
> .../crypto/allwinner/sun8i-ss/sun8i-ss-core.c |  12 +-
> drivers/crypto/amlogic/amlogic-gxl-core.c     |   6 +-
> drivers/crypto/axis/artpec6_crypto.c          |  20 ++-
> drivers/crypto/bcm/cipher.c                   |  72 ++++++++---
> drivers/crypto/caam/caamalg.c                 |   6 +-
> drivers/crypto/caam/caamalg_qi.c              |   6 +-
> drivers/crypto/caam/caamalg_qi2.c             |   8 +-
> drivers/crypto/caam/caamhash.c                |   2 +-
> drivers/crypto/cavium/cpt/cptvf_algs.c        |  18 ++-
> drivers/crypto/cavium/nitrox/nitrox_aead.c    |   4 +-
> .../crypto/cavium/nitrox/nitrox_skcipher.c    |  16 +--
> drivers/crypto/ccp/ccp-crypto-aes-cmac.c      |   1 +
> drivers/crypto/ccp/ccp-crypto-aes-galois.c    |   1 +
> drivers/crypto/ccp/ccp-crypto-aes-xts.c       |   1 +
> drivers/crypto/ccp/ccp-crypto-aes.c           |   2 +
> drivers/crypto/ccp/ccp-crypto-des3.c          |   1 +
> drivers/crypto/ccp/ccp-crypto-sha.c           |   1 +
> drivers/crypto/chelsio/chcr_algo.c            |   7 +-
> drivers/crypto/hisilicon/sec/sec_algs.c       |  24 ++--
> drivers/crypto/hisilicon/sec2/sec_crypto.c    |   4 +-
> .../crypto/inside-secure/safexcel_cipher.c    |  47 +++++++
> drivers/crypto/inside-secure/safexcel_hash.c  |  18 +++
> drivers/crypto/ixp4xx_crypto.c                |   6 +-
> drivers/crypto/marvell/cesa/cipher.c          |  18 ++-
> drivers/crypto/marvell/cesa/hash.c            |   6 +
> .../crypto/marvell/octeontx/otx_cptvf_algs.c  |  30 ++---
> drivers/crypto/n2_core.c                      |   3 +-
> drivers/crypto/picoxcell_crypto.c             |  17 ++-
> drivers/crypto/qat/qat_common/qat_algs.c      |  13 +-
> drivers/crypto/qce/skcipher.c                 |   1 +
> drivers/crypto/talitos.c                      | 117 ++++++++++++------
> drivers/crypto/virtio/virtio_crypto_algs.c    |   3 +-
> drivers/crypto/xilinx/zynqmp-aes-gcm.c        |   1 +
> drivers/md/dm-crypt.c                         |  17 ++-
> include/crypto/algapi.h                       |  25 ++--
> include/crypto/internal/geniv.h               |   2 +-
> include/linux/crypto.h                        |  36 +++++-
> 62 files changed, 562 insertions(+), 405 deletions(-)

Patches 1-6 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
