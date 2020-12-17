Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E60FC4361B
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 17:17:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3A92238EC
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 17:17:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgLQRRj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Dec 2020 12:17:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:35772 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728760AbgLQRRi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Dec 2020 12:17:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7A7FDACBD;
        Thu, 17 Dec 2020 17:16:57 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7D751DA83A; Thu, 17 Dec 2020 18:15:17 +0100 (CET)
Date:   Thu, 17 Dec 2020 18:15:17 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: Re: [PATCH 2/5] crypto: blake2b - define shash_alg structs using
 macros
Message-ID: <20201217171517.GT6430@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Paul Crowley <paulcrowley@google.com>
References: <20201215234708.105527-1-ebiggers@kernel.org>
 <20201215234708.105527-3-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215234708.105527-3-ebiggers@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 15, 2020 at 03:47:05PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The shash_alg structs for the four variants of BLAKE2b are identical
> except for the algorithm name, driver name, and digest size.  So, avoid
> code duplication by using a macro to define these structs.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: David Sterba <dsterba@suse.com>

> +static struct shash_alg blake2b_algs[] = {
> +	BLAKE2B_ALG("blake2b-160", "blake2b-160-generic",
> +		    BLAKE2B_160_HASH_SIZE),

Spelling out the algo names as string is better as it is greppable and
matches the module name, compared to using the #stringify macro
operator.

> +	BLAKE2B_ALG("blake2b-256", "blake2b-256-generic",
> +		    BLAKE2B_256_HASH_SIZE),
> +	BLAKE2B_ALG("blake2b-384", "blake2b-384-generic",
> +		    BLAKE2B_384_HASH_SIZE),
> +	BLAKE2B_ALG("blake2b-512", "blake2b-512-generic",
> +		    BLAKE2B_512_HASH_SIZE),
>  };
>  
>  static int __init blake2b_mod_init(void)
> -- 
> 2.29.2
> 
