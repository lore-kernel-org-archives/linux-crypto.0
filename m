From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: XTS Crypto Not Found In /proc/crypto Even After Compiled for
 4.10.1.
Date: Sat, 8 Apr 2017 14:23:23 +0200
Message-ID: <20170408122323.x34ytemitl7h7rzz@kozik-lap>
References: <CALaQ_hqhFjb60rJ2AgBnYgyNCPQ7fH5BdOOCeaMiankQR0VwqQ@mail.gmail.com>
 <20170308174542.2rydwxmrb3oehyrc@kozik-lap>
 <20170308211543.euqexxlhdgpfcdjk@kozik-lap>
 <CALaQ_hrikH8Q8ug9WTgnYR3UwSCip1DZtkkjj2NCLJVqcKQdZA@mail.gmail.com>
 <20170310180640.dnacw53vqrqji2xo@kozik-lap>
 <CALaQ_hqomXaZs0z-S3YX6d-hS_giqgBqBSvumwsMm=BzrgZz7Q@mail.gmail.com>
 <20170312191322.bbux5nrkqf5klznq@kozik-lap>
 <20170313170601.ozolfzgixqu6aa4g@kozik-lap>
 <20170406095414.GA31658@gondor.apana.org.au>
 <20170408020246.GA4815@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Nathan Royce <nroycea+kernel@gmail.com>, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:34134 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752226AbdDHMX1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 8 Apr 2017 08:23:27 -0400
Content-Disposition: inline
In-Reply-To: <20170408020246.GA4815@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Apr 08, 2017 at 10:02:46AM +0800, Herbert Xu wrote:
> On Thu, Apr 06, 2017 at 05:54:14PM +0800, Herbert Xu wrote:
> > On Mon, Mar 13, 2017 at 07:06:01PM +0200, Krzysztof Kozlowski wrote:
> > >
> > > I bisected this to commit f1c131b45410 ("crypto: xts - Convert to
> > > skcipher"). The s5p-sss driver stays the same... but the xts changes and
> > > as a result we have a NULL pointer dereference (actually of value
> > > 00000004):
> > > [   18.930195] Unable to handle kernel NULL pointer dereference at virtual address 00000004
> > > ...
> > > [   18.972325] [<c0313c98>] (post_crypt) from [<c031408c>] (decrypt_done+0x4c/0x54)
> > > [   18.972343] [<c031408c>] (decrypt_done) from [<c056309c>] (s5p_aes_interrupt+0x1bc/0x208)
> > > [   18.972360] [<c056309c>] (s5p_aes_interrupt) from [<c0164930>] (irq_thread_fn+0x1c/0x54)
> > > 
> > > Any hints?
> > 
> > I haven't found any smoking guns, but the locking between the
> > tasklet and the IRQ routine looks suspect.  First of all the
> > tasklet is modifying the dev structure without holding any locks.
> 
> I think I see the problem.  Could you please try this patch and
> let me know if it fixes the crash?

Yes, fixed! Thanks.
Tested on Odroid XU3 with following script:
https://github.com/krzk/tools/blob/master/tests/s5p-sss-cryptsetup.sh

Tested-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
