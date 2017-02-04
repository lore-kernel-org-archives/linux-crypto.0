From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [RFC PATCH] crypto: algapi - make crypto_xor() and crypto_inc()
 alignment agnostic
Date: Sun, 5 Feb 2017 00:00:20 +0100
Message-ID: <CAHmME9qtX64rp-bXfb7-vM-vsBd18186MNZ4G9KonLYhsM5uEg@mail.gmail.com>
References: <1485785489-5116-1-git-send-email-ard.biesheuvel@linaro.org> <20170202064716.GB582@zzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:34306 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751033AbdBDXHJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 4 Feb 2017 18:07:09 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id e16474a5
        for <linux-crypto@vger.kernel.org>;
        Sat, 4 Feb 2017 22:47:22 +0000 (UTC)
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3bd730f5 (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128:NO)
        for <linux-crypto@vger.kernel.org>;
        Sat, 4 Feb 2017 22:47:22 +0000 (UTC)
Received: by mail-oi0-f47.google.com with SMTP id j15so30176119oih.2
        for <linux-crypto@vger.kernel.org>; Sat, 04 Feb 2017 15:00:21 -0800 (PST)
In-Reply-To: <20170202064716.GB582@zzz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hey,

On Thu, Feb 2, 2017 at 7:47 AM, Eric Biggers <ebiggers3@gmail.com> wrote:
> I'm wondering whether it has to be that way, especially since it seems to most
> commonly be used on very small input buffers, e.g. 8 or 16-byte blocks.

Note that popular stream ciphers like chacha or salsa wind up XORing
much longer blocks -- 64 bytes. Likewise, CTR mode tends to XOR using
the block size as well. Not sure whether this is directly relavent for
the decision making here, but I thought I'd mention it just in case.
The XOR for this case should be _fast_, and preferably inlineable.

Jason
