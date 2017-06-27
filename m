From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 6/7] drm/tilcdc: clean up ifdef hacks around iowrite64
Date: Tue, 27 Jun 2017 22:40:16 +0200
Message-ID: <CAK8P3a2HhO_zCnsTzq7hmWSz5La5Thu19FWZpun16iMnyyNreQ@mail.gmail.com>
References: <20170622164817.25515-1-logang@deltatee.com> <20170622164817.25515-7-logang@deltatee.com>
 <504da99a-838c-48ec-c5b2-6b611d587a10@ti.com> <3ffb5648-00f6-26cb-116a-370085038a0d@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Jyri Sarha <jsarha@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-ntb@googlegroups.com, linux-alpha@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-crypto@vger.kernel.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Bates <sbates@raithlin.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        David Airlie <airlied@linux.ie>
To: Logan Gunthorpe <logang@deltatee.com>
Return-path: <linux-alpha-owner@vger.kernel.org>
In-Reply-To: <3ffb5648-00f6-26cb-116a-370085038a0d@deltatee.com>
Sender: linux-alpha-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jun 26, 2017 at 6:26 PM, Logan Gunthorpe <logang@deltatee.com> wrote:
> Hi Jyri,
>
> Thanks for the ack. However, I'm reworking this patch set to use the
> include/linux/io-64-nonatomic* headers which will explicitly devolve
> into two 32-bit transfers. It's not clear whether this is appropriate
> for the tilcdc driver as it was never setup to use 32-bit transfers
> (unlike the others I had patched).
>
> If you think it's ok, I can still patch this driver to use the
> non-atomic headers. Otherwise I can leave it out. Please let me know.

You'd have to first figure out whether this device is of the lo-hi
or the hi-lo variant, or doesn't allow the I/O to be split at all.

Note that we could theoretically define ARM to use strd/ldrd
for writeq/readq, but I would expect that to be wrong with many
other devices that can use the existing io-64-nonatomic headers.

The comment in set_scanout() suggests that we actually do rely
on the write64 to be atomic, so we probably don't want to change
this driver.

         Arnd
