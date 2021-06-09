Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E4BCC48BCF
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Jun 2021 22:34:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28CB3613E7
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Jun 2021 22:34:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhFIWge (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Jun 2021 18:36:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229534AbhFIWge (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Jun 2021 18:36:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E84FC613C8;
        Wed,  9 Jun 2021 22:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623278079;
        bh=buFRo+uDS2vnOLY9vRPpgCoZ9jSvFr5f8/YIKuV4D90=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P6pBJ8KcsiOe0uK0uxA81FmuVljxHmAWD1873DnsrdQ9L9yXxrVHpv+nYtX06Mgg3
         /+fGg4AVeF9fPBlVr2bK61o+c9j7efsr1Ppa6uz0CeNB616xZdRPyUatKWCgX0b/Rw
         1rw9ZwdyanC9DHvWcEzuJzy+BtA+AmMcEojW9E7gGpeewEZqNXADxHYSoa3OHt/HpZ
         fwN1xHRC6V902E/BbBDaIHsFIVcQBP0So5Us0+LaDFoXVsj7Rz8HO2J6AEK3Xd/Xkf
         254+zx7tCTm5XEU2OcjxuBvG4oEr22pDU/vuXAD2nJunUJ5cf7fzmplBhaC7FvlhFK
         sWjpyp6QX5q4w==
Date:   Wed, 9 Jun 2021 15:34:37 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH v2] crypto: shash - avoid comparing pointers to exported
 functions under CFI
Message-ID: <YMFB/QztaLqocqVw@gmail.com>
References: <20210605065902.53268-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210605065902.53268-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jun 05, 2021 at 08:59:02AM +0200, Ard Biesheuvel wrote:
> crypto_shash_alg_has_setkey() is implemented by testing whether the
> .setkey() member of a struct shash_alg points to the default version,
> called shash_no_setkey(). As crypto_shash_alg_has_setkey() is a static
> inline, this requires shash_no_setkey() to be exported to modules.
> 
> Unfortunately, when building with CFI, function pointers are routed
> via CFI stubs which are private to each module (or to the kernel proper)
> and so this function pointer comparison may fail spuriously.
> 
> Let's fix this by turning crypto_shash_alg_has_setkey() into an out of
> line function, which makes the problem go away.
> 
> Cc: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
> v2: add code comment to explain why the function needs to remain out of
> line
> 
>  crypto/shash.c                 | 20 +++++++++++++++++---
>  include/crypto/internal/hash.h |  8 +-------
>  2 files changed, 18 insertions(+), 10 deletions(-)
> 
> diff --git a/crypto/shash.c b/crypto/shash.c
> index 2e3433ad9762..36579c37e27d 100644
> --- a/crypto/shash.c
> +++ b/crypto/shash.c
> @@ -20,12 +20,26 @@
>  
>  static const struct crypto_type crypto_shash_type;
>  
> -int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
> -		    unsigned int keylen)
> +static int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
> +			   unsigned int keylen)
>  {
>  	return -ENOSYS;
>  }
> -EXPORT_SYMBOL_GPL(shash_no_setkey);
> +
> +bool crypto_shash_alg_has_setkey(struct shash_alg *alg)
> +{
> +	/*
> +	 * Function pointer comparisons such as the one below will not work as
> +	 * expected when CFI is enabled, and the comparison involves an
> +	 * exported symbol: as indirect function calls are routed via CFI stubs
> +	 * that are private to each module, the pointer values may be different
> +	 * even if they refer to the same function.
> +	 *
> +	 * Therefore, this function must remain out of line.
> +	 */
> +	return alg->setkey != shash_no_setkey;
> +}
> +EXPORT_SYMBOL_GPL(crypto_shash_alg_has_setkey);

Looks okay, but the comment isn't great since it doesn't get to the point until
the last sentence.  Also it talks about an exported symbol, which is confusing
because shash_no_setkey won't actually be exported anymore.  I'd prefer
something like the following:

/*
 * Check whether an shash algorithm has a setkey function.
 *
 * For CFI compatibility, this must not be an inline function.  This is because
 * when CFI is enabled, modules won't get the same address for shash_no_setkey
 * (if it were exported, which inlining would require) as the core kernel will.
 */
bool crypto_shash_alg_has_setkey(struct shash_alg *alg)
{
        return alg->setkey != shash_no_setkey;
}
EXPORT_SYMBOL_GPL(crypto_shash_alg_has_setkey);

