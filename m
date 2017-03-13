From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: XTS Crypto Not Found In /proc/crypto Even After Compiled for
 4.10.1.
Date: Mon, 13 Mar 2017 19:06:01 +0200
Message-ID: <20170313170601.ozolfzgixqu6aa4g@kozik-lap>
References: <CALaQ_hpC4G6CaxZAFvwNG3gFjc5Dj1C7zB6b_WQjGeYhbArHKw@mail.gmail.com>
 <20170306173511.6w3e47v4vomu7yv4@kozik-lap>
 <CALaQ_hqhFjb60rJ2AgBnYgyNCPQ7fH5BdOOCeaMiankQR0VwqQ@mail.gmail.com>
 <20170308174542.2rydwxmrb3oehyrc@kozik-lap>
 <20170308211543.euqexxlhdgpfcdjk@kozik-lap>
 <CALaQ_hrikH8Q8ug9WTgnYR3UwSCip1DZtkkjj2NCLJVqcKQdZA@mail.gmail.com>
 <20170310180640.dnacw53vqrqji2xo@kozik-lap>
 <CALaQ_hqomXaZs0z-S3YX6d-hS_giqgBqBSvumwsMm=BzrgZz7Q@mail.gmail.com>
 <20170312191322.bbux5nrkqf5klznq@kozik-lap>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
To: Nathan Royce <nroycea+kernel@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33017 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932099AbdCMRGH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Mar 2017 13:06:07 -0400
Content-Disposition: inline
In-Reply-To: <20170312191322.bbux5nrkqf5klznq@kozik-lap>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Mar 12, 2017 at 09:13:22PM +0200, Krzysztof Kozlowski wrote:
> On Fri, Mar 10, 2017 at 03:44:45PM -0600, Nathan Royce wrote:
> > Sure, I went ahead and rebuilt it just using the bare exynos_defconfig
> > and adding XTS and ECB and no other changes.
> > 
> > No flags were used. No patches were used other than the 2 you
> > provided. Just the barest of bears, the barest of bones, the barest of
> > deserts, the barest of hairless cats.
> >
> 
> Okay, I reproduced it. Beside enabling crypto tests, ECB and XTS, the
> important step is to disable the "ARM Accelerated Cryptographic
> Algorithms" so S5P-SSS will be used with XTS. The xts(ecb-aes-s5p))
> itself passes TCRYPT tests but oopses on cryptswap.

Hi Herbert,

I bisected this to commit f1c131b45410 ("crypto: xts - Convert to
skcipher"). The s5p-sss driver stays the same... but the xts changes and
as a result we have a NULL pointer dereference (actually of value
00000004):
[   18.930195] Unable to handle kernel NULL pointer dereference at virtual address 00000004
...
[   18.972325] [<c0313c98>] (post_crypt) from [<c031408c>] (decrypt_done+0x4c/0x54)
[   18.972343] [<c031408c>] (decrypt_done) from [<c056309c>] (s5p_aes_interrupt+0x1bc/0x208)
[   18.972360] [<c056309c>] (s5p_aes_interrupt) from [<c0164930>] (irq_thread_fn+0x1c/0x54)

Any hints?

Best regards,
Krzysztof
