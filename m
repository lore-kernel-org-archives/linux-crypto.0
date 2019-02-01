Return-Path: <SRS0=hzfm=QI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 786A8C282D8
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 06:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46F6420870
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 06:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbfBAGu0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Feb 2019 01:50:26 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:56972 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbfBAGu0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Feb 2019 01:50:26 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gpSef-0000BZ-4j; Fri, 01 Feb 2019 14:50:25 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gpSef-0005nA-0w; Fri, 01 Feb 2019 14:50:25 +0800
Date:   Fri, 1 Feb 2019 14:50:25 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: testmgr - skip crc32c context test for ahash
 algorithms
Message-ID: <20190201065024.xmegxcj2ux3rsig2@gondor.apana.org.au>
References: <20190124045735.331-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190124045735.331-1-ebiggers@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 23, 2019 at 08:57:35PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Instantiating "cryptd(crc32c)" causes a crypto self-test failure because
> the crypto_alloc_shash() in alg_test_crc32c() fails.  This is because
> cryptd(crc32c) is an ahash algorithm, not a shash algorithm; so it can
> only be accessed through the ahash API, unlike shash algorithms which
> can be accessed through both the ahash and shash APIs.
> 
> As the test is testing the shash descriptor format which is only
> applicable to shash algorithms, skip it for ahash algorithms.
> 
> (Note that it's still important to fix crypto self-test failures even
>  for weird algorithm instantiations like cryptd(crc32c) that no one
>  would really use; in fips_enabled mode unprivileged users can use them
>  to panic the kernel, and also they prevent treating a crypto self-test
>  failure as a bug when fuzzing the kernel.)
> 
> Fixes: 8e3ee85e68c5 ("crypto: crc32c - Test descriptor context format")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/testmgr.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
