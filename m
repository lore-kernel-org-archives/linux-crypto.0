Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B62CDE9271E
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Oct 2023 17:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbjJERaG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Oct 2023 13:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjJER30 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Oct 2023 13:29:26 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6027F3A81;
        Thu,  5 Oct 2023 10:27:01 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qoLYI-003l8C-Dy; Thu, 05 Oct 2023 18:25:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 05 Oct 2023 18:25:58 +0800
Date:   Thu, 5 Oct 2023 18:25:58 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Chang S. Bae" <chang.seok.bae@intel.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, ebiggers@kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 0/3] crypto: x86/aesni - Improve XTS data type
Message-ID: <ZR6PNg+gJ/d8kh+M@gondor.apana.org.au>
References: <20230925151752.162449-1-chang.seok.bae@intel.com>
 <20230928072508.218368-1-chang.seok.bae@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230928072508.218368-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 28, 2023 at 12:25:05AM -0700, Chang S. Bae wrote:
> V1->V2:
> * Drop the unnecessary casts (Eric).
> * Put the 'Link:' tag right after 'Suggested-by' (Eric).
> 
> ---
> 
> The field within the struct aesni_xts_ctx is currently defined as a
> byte array, sized to match the struct crypto_aes_ctx. However, it
> actually represents the struct data type.
> 
> To accurately redefine the data type, some adjustments have to be made
> to the address alignment code. It involved refactoring the common
> alignment code initially, followed by updating the structure's
> definition. Finally, the XTS alignment is now performed early in the
> process, rather than at every access point.
> 
> This change was suggested during Eric's review of another series
> intended to enable an alternative AES implementation [1][2]. I viewed
> it as an enhancement to the mainline, independent of the series.
> 
> I have divided these changes into incremental pieces, making them
> considerably more reviewable and maintainable.
> 
> The series is based on the cryptodev's master branch:
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> 
> Thanks,
> Chang
> 
> [1] https://lore.kernel.org/all/ZFWQ4sZEVu%2FLHq+Q@gmail.com/
> [2] https://lore.kernel.org/all/20230526065414.GB875@sol.localdomain/
> 
> Chang S. Bae (3):
>   crypto: x86/aesni - Refactor the common address alignment code
>   crypto: x86/aesni - Correct the data type in struct aesni_xts_ctx
>   crypto: x86/aesni - Perform address alignment early for XTS mode
> 
>  arch/x86/crypto/aesni-intel_glue.c | 52 ++++++++++++++----------------
>  1 file changed, 25 insertions(+), 27 deletions(-)
> 
> 
> base-commit: 1c43c0f1f84aa59dfc98ce66f0a67b2922aa7f9d
> -- 
> 2.34.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
