Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B4A3C61DA4
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Feb 2023 05:17:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjBPFRo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Feb 2023 00:17:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjBPFRn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2023 00:17:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0E13E095
        for <linux-crypto@vger.kernel.org>; Wed, 15 Feb 2023 21:17:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 28AABCE2786
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 05:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E634C433EF;
        Thu, 16 Feb 2023 05:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676524658;
        bh=tmXGYhxT45VfAGShXNT313qZ/DyneyyuKQn/UkQnPTI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=seobBHdXFDaxjT9fBR1zFYtp3sRrKMTL57L+SUGszj2pkJzdlUbPaGqCHx9oei7V0
         RGbFRNnDqWPHjcHcjEqN+8mPaGzyT9KE2HVFr0sySu6yye1do6BITB1kP+QEdEnnb6
         mFPGRzBeIXhSK7nFM82PVnG/qLdzRGQB+CSEkPY5PJPNaxo/WW4pW/e7MDjDNagg2d
         tEhfNMMpDbglowOVLxYlZqLiOi/AnSpwxS2qGgwQTX3IW1VTeiF3b85ipp31maP1dD
         2gBMODiD67xE8On0lAOaYgfNN5u+wedyu4DrwJIPH1j/7l1H7QKwvmhTI5ALC3BF1X
         Xf8Qid/8Lg89A==
Date:   Wed, 15 Feb 2023 21:17:36 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 9/10] crypto: api - Move MODULE_ALIAS_CRYPTO to algapi.h
Message-ID: <Y+28cG3kezAyPZSN@sol.localdomain>
References: <Y+ykvcAIAH5Rsn7C@gondor.apana.org.au>
 <E1pSE2W-00BVm0-2d@formenos.hmeau.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pSE2W-00BVm0-2d@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 15, 2023 at 05:25:24PM +0800, Herbert Xu wrote:
> This is part of the low-level API and should not be exposed to
> top-level Crypto API users.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
> 
>  include/crypto/algapi.h |   13 +++++++++++++
>  include/linux/crypto.h  |   13 -------------
>  2 files changed, 13 insertions(+), 13 deletions(-)

For this to work, drivers/crypto/qat/qat_common/adf_ctl_drv.c needs to include
<crypto/algapi.h>.

There could be others too.

- Eric
