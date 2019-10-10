Return-Path: <SRS0=yFEM=YD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 371A6C4360C
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 12:58:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 181B6206B6
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 12:58:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbfJJM6d (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Oct 2019 08:58:33 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37690 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728274AbfJJM6d (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Oct 2019 08:58:33 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1iIY1W-000218-B3; Thu, 10 Oct 2019 23:58:31 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 10 Oct 2019 23:58:25 +1100
Date:   Thu, 10 Oct 2019 23:58:25 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, t2@gert.gr,
        jelledejong@powercraft.nl, ebiggers@kernel.org, florian@bezdeka.de
Subject: Re: [PATCH v2] crypto: geode-aes - switch to skcipher for cbc(aes)
 fallback
Message-ID: <20191010125825.GK31566@gondor.apana.org.au>
References: <20191005091110.12556-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191005091110.12556-1-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Oct 05, 2019 at 11:11:10AM +0200, Ard Biesheuvel wrote:
> Commit 79c65d179a40e145 ("crypto: cbc - Convert to skcipher") updated
> the generic CBC template wrapper from a blkcipher to a skcipher algo,
> to get away from the deprecated blkcipher interface. However, as a side
> effect, drivers that instantiate CBC transforms using the blkcipher as
> a fallback no longer work, since skciphers can wrap blkciphers but not
> the other way around. This broke the geode-aes driver.
> 
> So let's fix it by moving to the sync skcipher interface when allocating
> the fallback. At the same time, align with the generic API for ECB and
> CBC by rejecting inputs that are not a multiple of the AES block size.
> 
> Fixes: 79c65d179a40e145 ("crypto: cbc - Convert to skcipher")
> Cc: <stable@vger.kernel.org> # v4.20+ ONLY
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
> v2: pass dst and src scatterlist in the right order
>     reject inputs that are not a multiple of the block size
> 
>  drivers/crypto/geode-aes.c | 57 +++++++++++---------
>  drivers/crypto/geode-aes.h |  2 +-
>  2 files changed, 34 insertions(+), 25 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
