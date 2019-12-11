Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F4CC3F68F
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 09:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A9D8205C9
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 09:43:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbfLKJnh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Dec 2019 04:43:37 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:54768 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728370AbfLKJng (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Dec 2019 04:43:36 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ieyWt-0000NR-G6; Wed, 11 Dec 2019 17:43:35 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ieyWs-0001Hg-FV; Wed, 11 Dec 2019 17:43:34 +0800
Date:   Wed, 11 Dec 2019 17:43:34 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/7] crypto: more self-test improvements
Message-ID: <20191211094334.y5ykf4supval6feu@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191201215330.171990-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Organization: Core
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
> This series makes some more improvements to the crypto self-tests, the
> largest of which is making the AEAD fuzz tests test inauthentic inputs,
> i.e. cases where decryption is expected to fail due to the (ciphertext,
> AAD) pair not being the correct result of an encryption with the key.
> 
> It also updates the self-tests to test passing misaligned buffers to the
> various setkey() functions, and to check that skciphers have the same
> min_keysize as the corresponding generic implementation.
> 
> I haven't seen any test failures from this on x86_64, arm64, or arm32.
> But as usual I haven't tested drivers for crypto accelerators.
> 
> For this series to apply this cleanly, my other series
> "crypto: skcipher - simplifications due to {,a}blkcipher removal"
> needs to be applied first, due to a conflict in skcipher.h.
> 
> This can also be retrieved from git at 
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
> tag "crypto-self-tests_2019-12-01".
> 
> Eric Biggers (7):
>  crypto: aead - move crypto_aead_maxauthsize() to <crypto/aead.h>
>  crypto: skcipher - add crypto_skcipher_min_keysize()
>  crypto: testmgr - don't try to decrypt uninitialized buffers
>  crypto: testmgr - check skcipher min_keysize
>  crypto: testmgr - test setting misaligned keys
>  crypto: testmgr - create struct aead_extra_tests_ctx
>  crypto: testmgr - generate inauthentic AEAD test vectors
> 
> crypto/testmgr.c               | 574 +++++++++++++++++++++++++--------
> crypto/testmgr.h               |  14 +-
> include/crypto/aead.h          |  10 +
> include/crypto/internal/aead.h |  10 -
> include/crypto/skcipher.h      |   6 +
> 5 files changed, 461 insertions(+), 153 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
