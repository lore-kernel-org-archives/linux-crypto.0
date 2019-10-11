Return-Path: <SRS0=ziyG=YE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B17C47404
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 06:04:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1C782196E
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 06:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570773863;
	bh=2KzIFkkGEI2VuMb83WNxRjserT5q3UnApPnjTlQ1PsI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ZiCjkbwWlyK+NHmdkWeWjAtriYqAV0025IDgXlC0SNx8urpmkMPy0hdOt757huIzp
	 RPwxqu9qaysAYCHdEKLq+mICj/WPZTnKrVbtNyC3k0F4Yv04yzb87a3tqErh41eekI
	 nPD50FeEXDtD1XIY2PVPeSiQbi69YGsE+FQF/Rz4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfJKGEX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Oct 2019 02:04:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726455AbfJKGEX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Oct 2019 02:04:23 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B86A20659;
        Fri, 11 Oct 2019 06:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570773862;
        bh=2KzIFkkGEI2VuMb83WNxRjserT5q3UnApPnjTlQ1PsI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a3r6Ea+DCr+bTvvnotWGvRHRbVdUqbXNTG3gM4Eod/1VxvswCbqn2tySWbRnlo+nm
         aXRNTJj/o9er1MKO7R+0onGb1akg6rOv+dLP2Up2C9TcgrAKd0FlzCy8ZLi7cmTt9w
         tfkRB2nyTJoJMpSEMbVrewQ4nfA9FEGbL/1r20oY=
Date:   Thu, 10 Oct 2019 23:04:20 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>
Subject: Re: [PATCH v3 11/29] crypto: chacha - unexport chacha_generic
 routines
Message-ID: <20191011060420.GC23882@sol.localdomain>
Mail-Followup-To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>
References: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
 <20191007164610.6881-12-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007164610.6881-12-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 07, 2019 at 06:45:52PM +0200, Ard Biesheuvel wrote:
> Now that all users of generic ChaCha code have moved to the core library,
> there is no longer a need for the generic ChaCha skcpiher driver to
> export parts of it implementation for reuse by other drivers. So drop
> the exports, and make the symbols static.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  crypto/chacha_generic.c          | 28 +++++++++-----------
>  include/crypto/internal/chacha.h | 10 -------
>  2 files changed, 12 insertions(+), 26 deletions(-)
> 
> diff --git a/crypto/chacha_generic.c b/crypto/chacha_generic.c
> index ebae6d9d9b32..a794df0e5b70 100644
> --- a/crypto/chacha_generic.c
> +++ b/crypto/chacha_generic.c
> @@ -12,6 +12,12 @@
>  #include <crypto/internal/skcipher.h>
>  #include <linux/module.h>
>  
> +static void crypto_chacha_init(u32 *state, const struct chacha_ctx *ctx,
> +			       const u8 *iv)
> +{
> +	chacha_init_generic(state, ctx->key, iv);
> +}

The 2 places that call this could just call chacha_init_generic() directly
instead.

- Eric
