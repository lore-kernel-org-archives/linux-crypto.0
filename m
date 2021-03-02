Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 752E7C4160E
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Mar 2021 01:43:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4389564EBD
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Mar 2021 01:43:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239570AbhCCBhj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Mar 2021 20:37:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:55688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245418AbhCBRkL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Mar 2021 12:40:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9095B64F12;
        Tue,  2 Mar 2021 17:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614706768;
        bh=4PXtG4bGHaK3TW0WRz7auQNev9K7TX4p38IsgAbYnD8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=saP8zQTEbv/NcJLYrTMmiXD6bkhHfu2t2/LvegFwZ9NBF6Fx7unIYUj7Y7EN84RAd
         GiQh3MctYKRRPCF20js89xqPIstrwfCGWxJ6SEluS2A1cXpm1EL9HKf/uIMJdeYPph
         WHw17HpKN2iDcgH3fPg28FKzWcbWJxtZdNmET8+ia4rw3waf9qqgDLF2gnutcOxOr6
         3vA+jNrIurUdRNfPfLFescY7CrwSzEChFSC2gueMwl3nkpEuDC2GEr5cvNZo5oe+ly
         cTTNdrTfy1yDkSHoKQowA94FYP36M8eT9RvYswsnOWCi+Lr6jy0sAlEvgs7bF/IJ8A
         NZtpnSFUHs0NQ==
Date:   Tue, 2 Mar 2021 09:39:27 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        syzbot+12cf5fbfdeba210a89dd@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] crypto: api - check for ERR pointers in
 crypto_destroy_tfm()
Message-ID: <YD54T+WRkGIrpuTM@sol.localdomain>
References: <20210302075530.29315-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302075530.29315-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 02, 2021 at 08:55:30AM +0100, Ard Biesheuvel wrote:
> diff --git a/include/crypto/hash.h b/include/crypto/hash.h
> index 13f8a6a54ca8..f065dbe2205c 100644
> --- a/include/crypto/hash.h
> +++ b/include/crypto/hash.h
> @@ -281,6 +281,8 @@ static inline struct crypto_tfm *crypto_ahash_tfm(struct crypto_ahash *tfm)
>  /**
>   * crypto_free_ahash() - zeroize and free the ahash handle
>   * @tfm: cipher handle to be freed
> + *
> + * If @tfm is a NULL or error pointer, this function does nothing.
>   */
>  static inline void crypto_free_ahash(struct crypto_ahash *tfm)
>  {

You missed crypto_free_shash().

Otherwise this looks good, feel free to add:

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
