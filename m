From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: XTS Crypto Not Found In /proc/crypto Even After Compiled for
 4.10.1.
Date: Tue, 14 Mar 2017 17:20:25 +0800
Message-ID: <20170314092025.GC711@gondor.apana.org.au>
References: <CALaQ_hpC4G6CaxZAFvwNG3gFjc5Dj1C7zB6b_WQjGeYhbArHKw@mail.gmail.com>
 <20170306173511.6w3e47v4vomu7yv4@kozik-lap>
 <CALaQ_hqhFjb60rJ2AgBnYgyNCPQ7fH5BdOOCeaMiankQR0VwqQ@mail.gmail.com>
 <20170308174542.2rydwxmrb3oehyrc@kozik-lap>
 <20170308211543.euqexxlhdgpfcdjk@kozik-lap>
 <CALaQ_hrikH8Q8ug9WTgnYR3UwSCip1DZtkkjj2NCLJVqcKQdZA@mail.gmail.com>
 <20170310180640.dnacw53vqrqji2xo@kozik-lap>
 <CALaQ_hqomXaZs0z-S3YX6d-hS_giqgBqBSvumwsMm=BzrgZz7Q@mail.gmail.com>
 <20170312191322.bbux5nrkqf5klznq@kozik-lap>
 <20170313170601.ozolfzgixqu6aa4g@kozik-lap>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nathan Royce <nroycea+kernel@gmail.com>, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60535 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750749AbdCNJUj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Mar 2017 05:20:39 -0400
Content-Disposition: inline
In-Reply-To: <20170313170601.ozolfzgixqu6aa4g@kozik-lap>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 13, 2017 at 07:06:01PM +0200, Krzysztof Kozlowski wrote:
> 
> I bisected this to commit f1c131b45410 ("crypto: xts - Convert to
> skcipher"). The s5p-sss driver stays the same... but the xts changes and
> as a result we have a NULL pointer dereference (actually of value
> 00000004):
> [   18.930195] Unable to handle kernel NULL pointer dereference at virtual address 00000004
> ...
> [   18.972325] [<c0313c98>] (post_crypt) from [<c031408c>] (decrypt_done+0x4c/0x54)
> [   18.972343] [<c031408c>] (decrypt_done) from [<c056309c>] (s5p_aes_interrupt+0x1bc/0x208)
> [   18.972360] [<c056309c>] (s5p_aes_interrupt) from [<c0164930>] (irq_thread_fn+0x1c/0x54)

Well that's hardly surprising since xts prior to this commit used
simple AES as opposed to ecb(aes) so it couldn't have triggered
this bug.

> Any hints?

I'll have a look when I have time but no promises.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
