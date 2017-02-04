From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [RFC PATCH] crypto: algapi - make crypto_xor() and crypto_inc()
 alignment agnostic
Date: Sun, 5 Feb 2017 00:10:53 +0100
Message-ID: <CAHmME9pwhWrXLEXyrPKueFwoVexEVNvSxN=FDFLsi+gHowE2Ww@mail.gmail.com>
References: <1485785489-5116-1-git-send-email-ard.biesheuvel@linaro.org>
 <20170202064716.GB582@zzz> <CAHmME9qtX64rp-bXfb7-vM-vsBd18186MNZ4G9KonLYhsM5uEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:37441 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751292AbdBDXKz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 4 Feb 2017 18:10:55 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 63559ba8
        for <linux-crypto@vger.kernel.org>;
        Sat, 4 Feb 2017 22:57:55 +0000 (UTC)
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ec8366ff (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128:NO)
        for <linux-crypto@vger.kernel.org>;
        Sat, 4 Feb 2017 22:57:55 +0000 (UTC)
Received: by mail-oi0-f46.google.com with SMTP id j15so30242298oih.2
        for <linux-crypto@vger.kernel.org>; Sat, 04 Feb 2017 15:10:54 -0800 (PST)
In-Reply-To: <CAHmME9qtX64rp-bXfb7-vM-vsBd18186MNZ4G9KonLYhsM5uEg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Another thing that might be helpful is that you can let gcc decide on
the alignment, and then optimize appropriately. Check out what we do
with siphash:

https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git/tree/include/linux/siphash.h#n76

static inline u64 siphash(const void *data, size_t len, const
siphash_key_t *key)
{
#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
        if (!IS_ALIGNED((unsigned long)data, SIPHASH_ALIGNMENT))
                return __siphash_unaligned(data, len, key);
#endif
        return ___siphash_aligned(data, len, key);
}

With this trick, we fall through to the fast alignment-assuming code,
if gcc can prove that the address is inlined. This is often the case
when passing structs, or when passing buffers that have
__aligned(BLOCKSIZE). It proves to be a very useful optimization on
some platforms.
