Return-Path: <SRS0=7kP/=RZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8773FC10F03
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 13:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59572213F2
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 13:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731003AbfCVNDi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Mar 2019 09:03:38 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:49456 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730714AbfCVNDi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Mar 2019 09:03:38 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1h7Jpg-0006Bn-B2; Fri, 22 Mar 2019 21:03:36 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1h7Jpd-0005ce-OK; Fri, 22 Mar 2019 21:03:33 +0800
Date:   Fri, 22 Mar 2019 21:03:33 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>
Subject: Re: [PATCH 0/9] crypto: add SIMD helpers for AEADs
Message-ID: <20190322130333.epv6t5at7zxpchj6@gondor.apana.org.au>
References: <20190310190058.4912-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190310190058.4912-1-ebiggers@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Mar 10, 2019 at 12:00:49PM -0700, Eric Biggers wrote:
> This series updates crypto_simd to support wrapping AEADs, then makes
> all AEADs that implement the same functionality use crypto_simd instead.
> 
> This simplifies the code, and it also fixes the bug where these
> algorithms modify the user-provided aead_request.  This was a problem
> because users may expect to be able to use the same aead_request for
> another encryption/decryption without reinitializing everything.  The
> last patch removes the test workaround now that this bug is fixed.
> 
> Eric Biggers (9):
>   crypto: simd - support wrapping AEAD algorithms
>   crypto: x86/aesni - convert to use skcipher SIMD bulk registration
>   crypto: x86/aesni - convert to use AEAD SIMD helpers
>   crypto: x86/aegis128 - convert to use AEAD SIMD helpers
>   crypto: x86/aegis128l - convert to use AEAD SIMD helpers
>   crypto: x86/aegis256 - convert to use AEAD SIMD helpers
>   crypto: x86/morus640 - convert to use AEAD SIMD helpers
>   crypto: x86/morus1280 - convert to use AEAD SIMD helpers
>   crypto: testmgr - remove workaround for AEADs that modify aead_request
> 
>  arch/x86/crypto/aegis128-aesni-glue.c  | 157 +++------------
>  arch/x86/crypto/aegis128l-aesni-glue.c | 157 +++------------
>  arch/x86/crypto/aegis256-aesni-glue.c  | 157 +++------------
>  arch/x86/crypto/aesni-intel_glue.c     | 204 ++-----------------
>  arch/x86/crypto/morus1280-avx2-glue.c  |  12 +-
>  arch/x86/crypto/morus1280-sse2-glue.c  |  12 +-
>  arch/x86/crypto/morus1280_glue.c       |  85 --------
>  arch/x86/crypto/morus640-sse2-glue.c   |  12 +-
>  arch/x86/crypto/morus640_glue.c        |  85 --------
>  crypto/Kconfig                         |  10 +-
>  crypto/simd.c                          | 269 +++++++++++++++++++++++++
>  crypto/testmgr.c                       |   3 -
>  include/crypto/internal/simd.h         |  20 ++
>  include/crypto/morus1280_glue.h        |  79 ++------
>  include/crypto/morus640_glue.h         |  79 ++------
>  15 files changed, 471 insertions(+), 870 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
