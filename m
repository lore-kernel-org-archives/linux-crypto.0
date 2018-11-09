Return-Path: <SRS0=IUQn=NU=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37322 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727532AbeKIT3u (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Nov 2018 14:29:50 -0500
Date: Fri, 9 Nov 2018 17:49:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Paul Crowley <paulcrowley@google.com>
Subject: Re: [PATCH v3 0/2] crypto: some hardening against AES cache-timing
 attacks
Message-ID: <20181109094958.xfasd6hmy4buqz55@gondor.apana.org.au>
References: <20181018043759.7669-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181018043759.7669-1-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 17, 2018 at 09:37:57PM -0700, Eric Biggers wrote:
> This series makes the "aes-fixed-time" and "aes-arm" implementations of
> AES more resistant to cache-timing attacks.
> 
> Note that even after these changes, the implementations still aren't
> necessarily guaranteed to be constant-time; see
> https://cr.yp.to/antiforgery/cachetiming-20050414.pdf for a discussion
> of the many difficulties involved in writing truly constant-time AES
> software.  But it's valuable to make such attacks more difficult.
> 
> Changed since v2:
> - In aes-arm, move the IRQ disable/enable into the assembly file.
> - Other aes-arm tweaks.
> - Add Kconfig help text.
> 
> Thanks to Ard Biesheuvel for the suggestions.
> 
> Eric Biggers (2):
>   crypto: aes_ti - disable interrupts while accessing S-box
>   crypto: arm/aes - add some hardening against cache-timing attacks
> 
>  arch/arm/crypto/Kconfig           |  9 +++++
>  arch/arm/crypto/aes-cipher-core.S | 62 ++++++++++++++++++++++++++-----
>  crypto/Kconfig                    |  3 +-
>  crypto/aes_generic.c              |  9 +++--
>  crypto/aes_ti.c                   | 18 +++++++++
>  5 files changed, 86 insertions(+), 15 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
