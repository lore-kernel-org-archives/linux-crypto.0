Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7746ECAAA3
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Aug 2022 11:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343910AbiHZLJn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Aug 2022 07:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343637AbiHZLJm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Aug 2022 07:09:42 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F81E4B48F;
        Fri, 26 Aug 2022 04:09:41 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oRXDP-00FQH2-6w; Fri, 26 Aug 2022 21:09:32 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Aug 2022 19:09:31 +0800
Date:   Fri, 26 Aug 2022 19:09:31 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        "Jason A . Donenfeld " <Jason@zx2c4.com>,
        "Justin M . Forbes" <jforbes@fedoraproject.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: lib - remove unneeded selection of XOR_BLOCKS
Message-ID: <Ywip6/79IEQFXt3g@gondor.apana.org.au>
References: <20220826050456.101321-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826050456.101321-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 25, 2022 at 10:04:56PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> CRYPTO_LIB_CHACHA_GENERIC doesn't need to select XOR_BLOCKS.  It perhaps
> was thought that it's needed for __crypto_xor, but that's not the case.
> 
> Enabling XOR_BLOCKS is problematic because the XOR_BLOCKS code runs a
> benchmark when it is initialized.  That causes a boot time regression on
> systems that didn't have it enabled before.
> 
> Therefore, remove this unnecessary and problematic selection.
> 
> Fixes: e56e18985596 ("lib/crypto: add prompts back to crypto libraries")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> I've separated this fix out from the larger patch
> https://lore.kernel.org/r/20220725183636.97326-3-ebiggers@kernel.org
> that is currently queued in cryptodev.
> 
>  lib/crypto/Kconfig | 1 -
>  1 file changed, 1 deletion(-)

Patch applied.  Thanks. 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
