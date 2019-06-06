Return-Path: <SRS0=NolZ=UF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED6ABC04AB5
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 06:53:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFBE7207E0
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 06:53:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725784AbfFFGxA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Jun 2019 02:53:00 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:38854 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbfFFGxA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jun 2019 02:53:00 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hYmGh-0006vU-4w; Thu, 06 Jun 2019 14:52:59 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hYmGh-0006k1-14; Thu, 06 Jun 2019 14:52:59 +0800
Date:   Thu, 6 Jun 2019 14:52:59 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Elena Petrova <lenaptr@google.com>
Subject: Re: [PATCH] crypto: testmgr - test the shash API
Message-ID: <20190606065258.cgacbfxtaefg7cmq@gondor.apana.org.au>
References: <20190528164055.21404-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528164055.21404-1-ebiggers@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 28, 2019 at 09:40:55AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> For hash algorithms implemented using the "shash" algorithm type, test
> both the ahash and shash APIs, not just the ahash API.
> 
> Testing the ahash API already tests the shash API indirectly, which is
> normally good enough.  However, there have been corner cases where there
> have been shash bugs that don't get exposed through the ahash API.  So,
> update testmgr to test the shash API too.
> 
> This would have detected the arm64 SHA-1 and SHA-2 bugs for which fixes
> were just sent out (https://patchwork.kernel.org/patch/10964843/ and
> https://patchwork.kernel.org/patch/10965089/):
> 
>     alg: shash: sha1-ce test failed (wrong result) on test vector 0, cfg="init+finup aligned buffer"
>     alg: shash: sha224-ce test failed (wrong result) on test vector 0, cfg="init+finup aligned buffer"
>     alg: shash: sha256-ce test failed (wrong result) on test vector 0, cfg="init+finup aligned buffer"
> 
> This also would have detected the bugs fixed by commit 307508d10729
> ("crypto: crct10dif-generic - fix use via crypto_shash_digest()") and
> commit dec3d0b1071a
> ("crypto: x86/crct10dif-pcl - fix use via crypto_shash_digest()").
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  crypto/testmgr.c | 402 +++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 335 insertions(+), 67 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
