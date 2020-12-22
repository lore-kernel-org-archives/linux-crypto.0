Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F34C433DB
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Dec 2020 08:56:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1362221FA
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Dec 2020 08:56:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgLVI4W (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Dec 2020 03:56:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:48446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725969AbgLVI4V (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Dec 2020 03:56:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E46B72076B;
        Tue, 22 Dec 2020 08:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608627341;
        bh=6+Q/aDQwfEeRbIfrJ72Rui8B2j9KbWtqX+1S2Ruz6eY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DPyem3X7Zyksrg4ItyQ4SoSrhselzzPihS/MRL6bjClLOhNUpCQI1T/Eds5JddM63
         OWH0qyF5BxZzL9z2ZyJJGyP5emUQjWyxa7KP9wA5e+DGMsR5Wf734pqzZr+PxGBjTQ
         N4CXX0Iine//+kO1JI92UFMW8QQIqMEPhvr5SjuMvdBl6nBb+kmyCtzizB3jnm+jnn
         Lxw6O5S2ZIE7ELe+o3L0Z6Bok/BGTLonEgNSUlURauhPJsZEh6GaTCd7V0C+WighMG
         OnoK5EqLwwDEdVseIwrnE9Ua/E79GM5Rb7SMlYaUWNTSbEmfkeawYva0PR4uHQ2wxv
         bJ+ffnNyULZ2Q==
Date:   Tue, 22 Dec 2020 00:55:39 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: Re: [PATCH v2 09/11] crypto: blake2s - share the "shash" API
 boilerplate code
Message-ID: <X+G0i377pXH8OssZ@sol.localdomain>
References: <20201217222138.170526-1-ebiggers@kernel.org>
 <20201217222138.170526-10-ebiggers@kernel.org>
 <CAHmME9oW-_GXJ+nVwyiEV7wfjmzqBgqrSynnJ6xoN5UA_Nzh1Q@mail.gmail.com>
 <X90MPh/uwXXu3F/Y@sol.localdomain>
 <CAHmME9pAEssKZGUchD6kh=waNnUcK=MOW2-=9Qv0Tsec4=0xgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9pAEssKZGUchD6kh=waNnUcK=MOW2-=9Qv0Tsec4=0xgQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Dec 19, 2020 at 01:01:53AM +0100, Jason A. Donenfeld wrote:
> Hey Eric,
> 
> The solution you've proposed at the end of your email is actually kind
> of similar to what we do with curve25519. Check out
> include/crypto/curve25519.h. The critical difference between that and
> the blake proposal is that it's in the header for curve25519, so the
> indirection disappears.
> 
> Could we do that with headers for blake?
> 

That doesn't look too similar, since most of include/crypto/curve25519.h is just
for the library API.  curve25519_generate_secret() is shared, but it's only a
few lines of code and there's no function pointer argument.

Either way, it would be possible to add __blake2s_update() and __blake2s_final()
(taking a blake2s_compress_t argument) to include/crypto/internal/blake2s.h, and
make these used by (and inlined into) both the library and shash functions.

Note, that's mostly separate from the question of whether blake2s_helpers.ko
should exist, since that depends on whether we want the functions in it to get
inlined into every shash implementation or not.  I don't really have a strong
preference.  They did seem long enough to make them out-of-line; however,
indirect calls are bad too.  If we go with inlining, then the shash helper
functions (crypto_blake2s_{setkey,init,update,final}()) would just be inline
functions in include/crypto/internal/blake2s.h too, similar to sha256_base.h,
and they would get compiled into both blake2s_generic.ko and blake2s-${arch}.ko.

- Eric
