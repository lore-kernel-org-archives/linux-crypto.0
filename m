From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: XTS Crypto Not Found In /proc/crypto Even After Compiled for
 4.10.1.
Date: Thu, 6 Apr 2017 17:54:14 +0800
Message-ID: <20170406095414.GA31658@gondor.apana.org.au>
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
Received: from orcrist.hmeau.com ([104.223.48.154]:38134 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751972AbdDFJy3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Apr 2017 05:54:29 -0400
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
> 
> Any hints?

I haven't found any smoking guns, but the locking between the
tasklet and the IRQ routine looks suspect.  First of all the
tasklet is modifying the dev structure without holding any locks.

More importantly, the IRQ routine does not seem to be robust in
the face of spurious interrupts.  Should a spurious interrupt
arrive, it is entirely possible for the tasklet's modifying of
dev->req to race with the IRQ routine which reads dev->req.

However, this does depend on there being a spurious interrupt so
I don't know how likely it is.

Anyway, if we can't get to the bottom of this, we should disable
the broken functionality.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
