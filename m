Return-Path: <SRS0=4jM/=QP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42F46C169C4
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 07:47:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BF3921919
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 07:47:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbfBHHrp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Feb 2019 02:47:45 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:34220 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfBHHrp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Feb 2019 02:47:45 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gs0sx-0000nA-Bw; Fri, 08 Feb 2019 15:47:43 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gs0sx-0002Sm-8D; Fri, 08 Feb 2019 15:47:43 +0800
Date:   Fri, 8 Feb 2019 15:47:43 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/15] crypto: improved skcipher, aead, and hash tests
Message-ID: <20190208074743.62joumuvya7uq75l@gondor.apana.org.au>
References: <20190201075150.18644-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190201075150.18644-1-ebiggers@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 31, 2019 at 11:51:35PM -0800, Eric Biggers wrote:
> Hello,
> 
> Crypto algorithms must produce the same output for the same input
> regardless of data layout, i.e. how the src and dst scatterlists are
> divided into chunks and how each chunk is aligned.  Request flags such
> as CRYPTO_TFM_REQ_MAY_SLEEP must not affect the result either.
> 
> However, testing of this currently has many gaps.  For example,
> individual algorithms are responsible for providing their own chunked
> test vectors.  But many don't bother to do this or test only one or two
> cases, providing poor test coverage.  Also, other things such as buffers
> spanning a page boundary, misaligned IVs, and CRYPTO_TFM_REQ_MAY_SLEEP
> are never tested at all.
> 
> Test code is also duplicated between the chunked and non-chunked cases,
> making it difficult to make other improvements.
> 
> To improve the situation, this patch series basically moves the chunk
> descriptions into the testmgr itself so that they are shared by all
> algorithms.  However, it's done in an extensible way via a new struct
> 'testvec_config', which describes not just the scaled chunk lengths but
> also all other aspects of the crypto operation besides the data itself
> such as the buffer alignments, the request flags, whether the operation
> is in-place or not, the IV alignment, and for hash algorithms when to do
> each update() and when to use finup() vs. final() vs. digest().
> 
> Then, this patch series makes skcipher, aead, and hash algorithms be
> tested against a list of default testvec_configs, replacing the current
> test code.  This improves overall test coverage, without reducing test
> performance too much.  Note that the test vectors themselves are not
> changed, except for removing the chunk lists.
> 
> This series also adds randomized fuzz tests, enabled by a new kconfig
> option intended for developer use only, where skcipher, aead, and hash
> algorithms are tested against many randomly generated testvec_configs.
> This provides much more comprehensive test coverage.
> 
> I've run these improved tests on x86, arm32, and arm64 with all crypto
> algorithms enabled, and they have already found many bugs.  Patches 1-7
> and the patches from Ard Biesheuvel fix most of the bugs found so far.
> A bug was also detected in the Rockchip crypto driver which remains to
> be fixed.  Also many AEADs incorrectly change aead_request::base.tfm,
> but for now I'm temporarily working around that in the tests as I plan
> to fix it later after the other types of bugs are addressed.
> 
> If anyone reading this has access to systems with other architectures or
> crypto drivers that may not have been tested yet, you can help by
> applying these patches on your system, enabling
> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS, and reporting or fixing any test
> failures.
> 
> This patch series can also be found in git at
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
> branch "testmgr-improvements".
> 
> Changed since v1:
> 
> - Made CONFIG_CRYPTO_MANAGER_EXTRA_TESTS depend on CONFIG_DEBUG_KERNEL.
> - Improved commit description of AEGIS and MORUS fixes.
> - A few very minor cleanups to the test code.
> 
> Eric Biggers (15):
>   crypto: aegis - fix handling chunked inputs
>   crypto: morus - fix handling chunked inputs
>   crypto: x86/aegis - fix handling chunked inputs and MAY_SLEEP
>   crypto: x86/morus - fix handling chunked inputs and MAY_SLEEP
>   crypto: x86/aesni-gcm - fix crash on empty plaintext
>   crypto: ahash - fix another early termination in hash walk
>   crypto: arm64/aes-neonbs - fix returning final keystream block
>   crypto: testmgr - add testvec_config struct and helper functions
>   crypto: testmgr - introduce CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
>   crypto: testmgr - implement random testvec_config generation
>   crypto: testmgr - convert skcipher testing to use testvec_configs
>   crypto: testmgr - convert aead testing to use testvec_configs
>   crypto: testmgr - convert hash testing to use testvec_configs
>   crypto: testmgr - check for skcipher_request corruption
>   crypto: testmgr - check for aead_request corruption
> 
>  arch/arm64/crypto/aes-neonbs-core.S    |    8 +-
>  arch/x86/crypto/aegis128-aesni-glue.c  |   38 +-
>  arch/x86/crypto/aegis128l-aesni-glue.c |   38 +-
>  arch/x86/crypto/aegis256-aesni-glue.c  |   38 +-
>  arch/x86/crypto/aesni-intel_glue.c     |   13 +-
>  arch/x86/crypto/morus1280_glue.c       |   40 +-
>  arch/x86/crypto/morus640_glue.c        |   39 +-
>  crypto/Kconfig                         |   10 +
>  crypto/aegis128.c                      |   14 +-
>  crypto/aegis128l.c                     |   14 +-
>  crypto/aegis256.c                      |   14 +-
>  crypto/ahash.c                         |   14 +-
>  crypto/morus1280.c                     |   13 +-
>  crypto/morus640.c                      |   13 +-
>  crypto/testmgr.c                       | 2549 +++++++++++++-----------
>  crypto/testmgr.h                       |  407 +---
>  16 files changed, 1556 insertions(+), 1706 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
