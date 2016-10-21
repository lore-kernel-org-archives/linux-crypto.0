From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH RESEND] hwrng: core - don't pass stack allocated buffer to rng->read()
Date: Fri, 21 Oct 2016 14:04:27 -0700
Message-ID: <CALCETrUUBJT81Yxm7f19kX+dbyqx9skYEVjYMzMx4zm-vGWWXQ@mail.gmail.com>
References: <20161021204809.14068-1-lersek@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Richard W.M. Jones" <rjones@redhat.com>,
        stable <stable@vger.kernel.org>,
        Amit Shah <amit.shah@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kees Cook <keescook@chromium.org>,
        Matt Mackall <mpm@selenic.com>
To: Laszlo Ersek <lersek@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:33895 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933808AbcJUVEt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Oct 2016 17:04:49 -0400
Received: by mail-ua0-f172.google.com with SMTP id m26so7629023uaa.1
        for <linux-crypto@vger.kernel.org>; Fri, 21 Oct 2016 14:04:48 -0700 (PDT)
In-Reply-To: <20161021204809.14068-1-lersek@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 21, 2016 at 1:48 PM, Laszlo Ersek <lersek@redhat.com> wrote:
> The virtio-rng backend for hwrng passes the buffer that it receives for
> filling to sg_set_buf() directly, in:
>
> virtio_read()       [drivers/char/hw_random/virtio-rng.c]
>   register_buffer() [drivers/char/hw_random/virtio-rng.c]
>     sg_init_one()   [lib/scatterlist.c]
>       sg_set_buf()  [include/linux/scatterlist.h]
>
> In turn, the sg_set_buf() function, when built with CONFIG_DEBUG_SG,
> actively enforces (justifiedly) that the buffer used within the
> scatter-gather list live in physically contiguous memory:
>
>   BUG_ON(!virt_addr_valid(buf));
>
> The combination of the above two facts means that whatever calls
> virtio_read() -- via the hwrng.read() method -- has to allocate the
> recipient buffer in physically contiguous memory.

Indeed.  This bug should be fixed by:

https://git.kernel.org/cgit/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=6d4952d9d9d4dc2bb9c0255d95a09405a1e958f7
