From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH v5 0/4] gf128mul refactoring
Date: Tue, 4 Apr 2017 21:13:51 -0700
Message-ID: <20170405041351.GA4761@zzz>
References: <20170402191916.9309-1-omosnacek@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Jeffrey Walton <noloader@gmail.com>,
        Milan Broz <gmazyland@gmail.com>
To: Ondrej Mosnacek <omosnacek@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33202 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750712AbdDEENy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Apr 2017 00:13:54 -0400
Received: by mail-pf0-f195.google.com with SMTP id 197so335721pfv.0
        for <linux-crypto@vger.kernel.org>; Tue, 04 Apr 2017 21:13:54 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170402191916.9309-1-omosnacek@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Ondrej,

On Sun, Apr 02, 2017 at 09:19:12PM +0200, Ondrej Mosnacek wrote:
> This patchset contains the following gf128mul-related changes:
>   1. The gf128mul_x_* functions are moved to gf128mul.h for performance reasons.
>   2. The gf128mul_x_ble function is fixed to use the correct block type.
>   3. The le128_gf128mul_x_ble function from glue_helper.h is removed and its
>      usages replaced with gf128mul_x_ble calls.
>   4. The now obsolete dependency of CRYPTO_XTS on CRYPTO_GF128MUL is removed.
> 
> v4 -> v5: added the other three patches
> v3 -> v4: a faster version of gf128mul_x_lle
> v2 -> v3: constant-time implementation
> v1 -> v2: move all _x_ functions to the header, not just gf128mul_x_ble
> 
> Ondrej Mosnacek (4):
>   crypto: gf128mul - define gf128mul_x_* in gf128mul.h
>   crypto: gf128mul - switch gf128mul_x_ble to le128
>   crypto: glue_helper - remove the le128_gf128mul_x_ble function
>   crypto: xts - drop gf128mul dependency

These all look good to me, and you can add

	Reviewed-by: Eric Biggers <ebiggers@google.com>

to the patches.

I think the change to le128 is an improvement, but what I've actually wanted to
do is have the GF(2^128) elements strongly typed, with ble128, bbe128, and
lle128 types, so that the types would reflect both the bit order and the byte
order.  But that's harder to do and I ran into some issues when I tried it last.

- Eric
