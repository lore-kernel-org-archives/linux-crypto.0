Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AC78C10F14
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 14:26:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4215D206B6
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 14:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389132AbfDRO0f (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 10:26:35 -0400
Received: from [5.180.42.13] ([5.180.42.13]:55182 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389121AbfDRO0f (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 10:26:35 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hH7zl-0004m8-Qc; Thu, 18 Apr 2019 22:26:33 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hH7zl-0004DX-Mu; Thu, 18 Apr 2019 22:26:33 +0800
Date:   Thu, 18 Apr 2019 22:26:33 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 0/7] crypto: fuzz algorithms against their generic
 implementation
Message-ID: <20190418142633.7xjznwqh2navv2ds@gondor.apana.org.au>
References: <20190412045742.1725-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190412045742.1725-1-ebiggers@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 11, 2019 at 09:57:35PM -0700, Eric Biggers wrote:
> 
> Eric Biggers (7):
>   crypto: testmgr - expand ability to test for errors
>   crypto: testmgr - identify test vectors by name rather than number
>   crypto: testmgr - add helpers for fuzzing against generic
>     implementation
>   crypto: testmgr - fuzz hashes against their generic implementation
>   crypto: testmgr - fuzz skciphers against their generic implementation
>   crypto: testmgr - fuzz AEADs against their generic implementation
>   crypto: run initcalls for generic implementations earlier
> 
>  crypto/842.c                 |   2 +-
>  crypto/adiantum.c            |   2 +-
>  crypto/aegis128.c            |   2 +-
>  crypto/aegis128l.c           |   2 +-
>  crypto/aegis256.c            |   2 +-
>  crypto/aes_generic.c         |   2 +-
>  crypto/algboss.c             |   8 +-
>  crypto/ansi_cprng.c          |   2 +-
>  crypto/anubis.c              |   2 +-
>  crypto/arc4.c                |   2 +-
>  crypto/authenc.c             |   2 +-
>  crypto/authencesn.c          |   2 +-
>  crypto/blowfish_generic.c    |   2 +-
>  crypto/camellia_generic.c    |   2 +-
>  crypto/cast5_generic.c       |   2 +-
>  crypto/cast6_generic.c       |   2 +-
>  crypto/cbc.c                 |   2 +-
>  crypto/ccm.c                 |   2 +-
>  crypto/cfb.c                 |   2 +-
>  crypto/chacha20poly1305.c    |   2 +-
>  crypto/chacha_generic.c      |   2 +-
>  crypto/cmac.c                |   2 +-
>  crypto/crc32_generic.c       |   2 +-
>  crypto/crc32c_generic.c      |   2 +-
>  crypto/crct10dif_generic.c   |   2 +-
>  crypto/crypto_null.c         |   2 +-
>  crypto/ctr.c                 |   2 +-
>  crypto/cts.c                 |   2 +-
>  crypto/deflate.c             |   2 +-
>  crypto/des_generic.c         |   2 +-
>  crypto/dh.c                  |   2 +-
>  crypto/drbg.c                |   2 +-
>  crypto/ecb.c                 |   2 +-
>  crypto/ecdh.c                |   2 +-
>  crypto/echainiv.c            |   2 +-
>  crypto/fcrypt.c              |   2 +-
>  crypto/fips.c                |   2 +-
>  crypto/gcm.c                 |   2 +-
>  crypto/ghash-generic.c       |   2 +-
>  crypto/hmac.c                |   2 +-
>  crypto/jitterentropy-kcapi.c |   2 +-
>  crypto/keywrap.c             |   2 +-
>  crypto/khazad.c              |   2 +-
>  crypto/lrw.c                 |   2 +-
>  crypto/lz4.c                 |   2 +-
>  crypto/lz4hc.c               |   2 +-
>  crypto/lzo-rle.c             |   2 +-
>  crypto/lzo.c                 |   2 +-
>  crypto/md4.c                 |   2 +-
>  crypto/md5.c                 |   2 +-
>  crypto/michael_mic.c         |   2 +-
>  crypto/morus1280.c           |   2 +-
>  crypto/morus640.c            |   2 +-
>  crypto/nhpoly1305.c          |   2 +-
>  crypto/ofb.c                 |   2 +-
>  crypto/pcbc.c                |   2 +-
>  crypto/pcrypt.c              |   2 +-
>  crypto/poly1305_generic.c    |   2 +-
>  crypto/rmd128.c              |   2 +-
>  crypto/rmd160.c              |   2 +-
>  crypto/rmd256.c              |   2 +-
>  crypto/rmd320.c              |   2 +-
>  crypto/rsa.c                 |   2 +-
>  crypto/salsa20_generic.c     |   2 +-
>  crypto/seed.c                |   2 +-
>  crypto/seqiv.c               |   2 +-
>  crypto/serpent_generic.c     |   2 +-
>  crypto/sha1_generic.c        |   2 +-
>  crypto/sha256_generic.c      |   2 +-
>  crypto/sha3_generic.c        |   2 +-
>  crypto/sha512_generic.c      |   2 +-
>  crypto/sm3_generic.c         |   2 +-
>  crypto/sm4_generic.c         |   2 +-
>  crypto/streebog_generic.c    |   2 +-
>  crypto/tcrypt.c              |   2 +-
>  crypto/tea.c                 |   2 +-
>  crypto/testmgr.c             | 989 +++++++++++++++++++++++++++++++----
>  crypto/testmgr.h             |  22 +-
>  crypto/tgr192.c              |   2 +-
>  crypto/twofish_generic.c     |   2 +-
>  crypto/vmac.c                |   2 +-
>  crypto/wp512.c               |   2 +-
>  crypto/xcbc.c                |   2 +-
>  crypto/xts.c                 |   2 +-
>  crypto/zstd.c                |   2 +-
>  85 files changed, 986 insertions(+), 197 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
