From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH v3] crypto: gf128mul - define gf128mul_x_* in gf128mul.h
Date: Fri, 31 Mar 2017 20:44:07 -0700
Message-ID: <20170401034407.GA598@zzz>
References: <20170331092703.2520-1-omosnacek@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Jeffrey Walton <noloader@gmail.com>,
        Milan Broz <gmazyland@gmail.com>,
        Eric Biggers <ebiggers@google.com>
To: Ondrej Mosnacek <omosnacek@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33718 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751078AbdDADoK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Mar 2017 23:44:10 -0400
Received: by mail-pf0-f193.google.com with SMTP id 197so268293pfv.0
        for <linux-crypto@vger.kernel.org>; Fri, 31 Mar 2017 20:44:10 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170331092703.2520-1-omosnacek@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 31, 2017 at 11:27:03AM +0200, Ondrej Mosnacek wrote:
> The gf128mul_x_ble function is currently defined in gf128mul.c, because
> it depends on the gf128mul_table_be multiplication table.
> 
> However, since the function is very small and only uses two values from
> the table, it is better for it to be defined as inline function in
> gf128mul.h. That way, the function can be inlined by the compiler for
> better performance.
> 
> For consistency, the other gf128mul_x_* functions are also moved to the
> header file. In addition, the code is rewritten to be constant-time.
> 
> After this change, the speed of the generic 'xts(aes)' implementation
> increased from ~225 MiB/s to ~235 MiB/s (measured using 'cryptsetup
> benchmark -c aes-xts-plain64' on an Intel system with CRYPTO_AES_X86_64
> and CRYPTO_AES_NI_INTEL disabled).
> 
> Signed-off-by: Ondrej Mosnacek <omosnacek@gmail.com>
> Cc: Eric Biggers <ebiggers@google.com>

Reviewed-by: Eric Biggers <ebiggers@google.com>

Also, I realized that for gf128mul_x_lle() now that we aren't using the table we
don't need to shift '_tt' but rather can use the constant 0xe100000000000000:

        /* equivalent to (u64)gf128mul_table_le[(b << 7) & 0xff] << 48
         * (see crypto/gf128mul.c): */
        u64 _tt = gf128mul_mask_from_bit(b, 0) & 0xe100000000000000;

        r->b = cpu_to_be64((b >> 1) | (a << 63));
        r->a = cpu_to_be64((a >> 1) ^ _tt);

I think that would be better and you could send a v4 to do it that way if you
want.  It's not a huge deal though.

Thanks!

- Eric
