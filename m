From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH v2] crypto: gf128mul - define gf128mul_x_* in gf128mul.h
Date: Thu, 30 Mar 2017 20:53:15 -0700
Message-ID: <20170331035315.GA598@zzz>
References: <20170330220442.11012-1-omosnacek@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Milan Broz <gmazyland@gmail.com>,
        Eric Biggers <ebiggers@google.com>
To: Ondrej Mosnacek <omosnacek@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33741 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932265AbdCaDxS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Mar 2017 23:53:18 -0400
Received: by mail-pg0-f66.google.com with SMTP id 79so14197648pgf.0
        for <linux-crypto@vger.kernel.org>; Thu, 30 Mar 2017 20:53:18 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170330220442.11012-1-omosnacek@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 31, 2017 at 12:04:42AM +0200, Ondrej Mosnacek wrote:
> The gf128mul_x_ble function is currently defined in gf128mul.c, because
> it depends on the gf128mul_table_be multiplication table.
> 
> However, since the function is very small and only uses two values from
> the table, it is better for it to be defined as inline function in
> gf128mul.h. That way, the function can be inlined by the compiler for
> better performance.
> 
> For consistency, the other gf128mul_x_* functions are also moved to the
> header file.
> 
> After this change, the speed of the generic 'xts(aes)' implementation
> increased from ~225 MiB/s to ~235 MiB/s (measured using 'cryptsetup
> benchmark -c aes-xts-plain64' on an Intel system with CRYPTO_AES_X86_64
> and CRYPTO_AES_NI_INTEL disabled).
> 

Reviewed-by: Eric Biggers <ebiggers@google.com>

Thanks,

- Eric
