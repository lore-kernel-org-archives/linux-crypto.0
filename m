Return-Path: <SRS0=Hyrp=2W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D0CC2D0DC
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jan 2020 14:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19A2E206E0
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jan 2020 14:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577890242;
	bh=ne8AtH6ir12ZxytcQ+zNs/R8iBizKVr879khSdQfAI8=;
	h=Date:From:To:Subject:References:In-Reply-To:List-ID:From;
	b=i9o1YgrXtesThZUacUVfNFf4psSR43Q3tabQi+DuUX60h1DwlcvjdNd9MS4s8wpuw
	 z2Hht/8fYI76ZnlQRr93BLGkxNjrj4V9FmPR23HQ3weGWaili40QOkBiwJHa/XphE9
	 Lp8KjKQW8hcOgoKrj4NZ/Bfy168ZhyLYRUoY4suo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgAAOul (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Jan 2020 09:50:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:50080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgAAOul (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Jan 2020 09:50:41 -0500
Received: from zzz.localdomain (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94E0C206E0
        for <linux-crypto@vger.kernel.org>; Wed,  1 Jan 2020 14:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577890240;
        bh=ne8AtH6ir12ZxytcQ+zNs/R8iBizKVr879khSdQfAI8=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=Pbhof0FOHm5u6c04llIaZMI1oxuVIYq+bmEhDil3b0JiNg7nDYI+TXi2+1YIu5f3U
         oc84T9J7rXjeLelYLDosUR6VNTFsnO9jhiQH9JlRNu6bQtCdHXyPgiyg/cvBa0Nfwi
         g8JJkpgtOJWGjMJIPJtIL4B+Ys3xJ0243kF9EAJE=
Date:   Wed, 1 Jan 2020 08:50:38 -0600
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH 11/28] crypto: cipher - introduce crypto_cipher_spawn and
 crypto_grab_cipher()
Message-ID: <20200101145038.GA572@zzz.localdomain>
References: <20191229025714.544159-1-ebiggers@kernel.org>
 <20191229025714.544159-12-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191229025714.544159-12-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Dec 28, 2019 at 08:56:57PM -0600, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Currently, "cipher" (single-block cipher) spawns are usually initialized
> by using crypto_get_attr_alg() to look up the algorithm, then calling
> crypto_init_spawn().  In one case, crypto_grab_spawn() is used directly.
> 
> The former way is different from how skcipher, aead, and akcipher spawns
> are initialized (they use crypto_grab_*()), and for no good reason.
> This difference introduces unnecessary complexity.
> 
> The crypto_grab_*() functions used to have some problems, like not
> holding a reference to the algorithm and requiring the caller to
> initialize spawn->base.inst.  But those problems are fixed now.
> 
> Also, the cipher spawns are not strongly typed; e.g., the API requires
> that the user manually specify the flags CRYPTO_ALG_TYPE_CIPHER and
> CRYPTO_ALG_TYPE_MASK.  Though the "cipher" algorithm type itself isn't
> yet strongly typed, we can start by making the spawns strongly typed.
> 
> So, let's introduce a new 'struct crypto_cipher_spawn', and functions
> crypto_grab_cipher() and crypto_drop_cipher() to grab and drop them.
> 
> Later patches will convert all cipher spawns to use these, then make
> crypto_spawn_cipher() take 'struct crypto_cipher_spawn' as well, instead
> of a bare 'struct crypto_spawn' as it currently does.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/cipher.c         | 11 +++++++++++
>  include/crypto/algapi.h | 19 +++++++++++++++++++
>  2 files changed, 30 insertions(+)
> 
> diff --git a/crypto/cipher.c b/crypto/cipher.c
> index aadd51cb7250..924d9f6575f9 100644
> --- a/crypto/cipher.c
> +++ b/crypto/cipher.c
> @@ -92,3 +92,14 @@ void crypto_cipher_decrypt_one(struct crypto_cipher *tfm,
>  	cipher_crypt_one(tfm, dst, src, false);
>  }
>  EXPORT_SYMBOL_GPL(crypto_cipher_decrypt_one);
> +
> +int crypto_grab_cipher(struct crypto_cipher_spawn *spawn,
> +		       struct crypto_instance *inst,
> +		       const char *name, u32 type, u32 mask)
> +{
> +	type &= ~CRYPTO_ALG_TYPE_MASK;
> +	type |= CRYPTO_ALG_TYPE_CIPHER;
> +	mask |= CRYPTO_ALG_TYPE_MASK;
> +	return crypto_grab_spawn(&spawn->base, inst, name, type, mask);
> +}
> +EXPORT_SYMBOL_GPL(crypto_grab_cipher);

kbuild test robot complained that calling crypto_grab_spawn() from here is not
allowed when "crypto" is built-in but "crypto_algapi" is a module.  (cipher.c is
part of "crypto"; this is different from the new-style algorithm types which
have their own modules.)  So I'll be sending out a new version which makes
crypto_grab_cipher() an inline function.

- Eric
