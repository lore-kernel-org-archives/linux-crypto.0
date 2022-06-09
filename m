Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38693C43334
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jun 2022 10:16:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234332AbiFIKQJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jun 2022 06:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241879AbiFIKQF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jun 2022 06:16:05 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2039DB36EE;
        Thu,  9 Jun 2022 03:16:01 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nzFCF-004yZH-QF; Thu, 09 Jun 2022 20:15:25 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 09 Jun 2022 18:15:24 +0800
Date:   Thu, 9 Jun 2022 18:15:24 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: x86/camellia - Replace kernel.h with the
 necessary inclusions
Message-ID: <YqHIPE0MlZLP8C5I@gondor.apana.org.au>
References: <65634fb748cc0ce2cc5bafaf904cb5f76bd4edc4.1654414362.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65634fb748cc0ce2cc5bafaf904cb5f76bd4edc4.1654414362.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Jun 05, 2022 at 09:32:53AM +0200, Christophe JAILLET wrote:
> When kernel.h is used in the headers it adds a lot into dependency hell,
> especially when there are circular dependencies are involved.
> 
> Replace kernel.h inclusion with the list of what is really being used.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  arch/x86/crypto/camellia.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/crypto/camellia.h b/arch/x86/crypto/camellia.h
> index 1dcea79e8f8e..547fb7e30928 100644
> --- a/arch/x86/crypto/camellia.h
> +++ b/arch/x86/crypto/camellia.h
> @@ -4,7 +4,7 @@
>  
>  #include <crypto/b128ops.h>
>  #include <linux/crypto.h>
> -#include <linux/kernel.h>
> +#include <linux/types.h>
>  
>  #define CAMELLIA_MIN_KEY_SIZE	16
>  #define CAMELLIA_MAX_KEY_SIZE	32

This is not sufficient.  For example, asmlinkage isn't explicitly
defined by any of these header files so it would be relying on an
implicit inclusion which is prone to breakage.

Did you audit the entire file?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
