From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/7] iomap: implement ioread64 and iowrite64
Date: Mon, 26 Jun 2017 22:43:40 +0200
Message-ID: <CAK8P3a1Uh=PQbGi540KGLpkoEVH+KUW18mzqN3aiijroXwEMWQ@mail.gmail.com>
References: <20170622164817.25515-1-logang@deltatee.com> <20170622164817.25515-3-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-ntb@googlegroups.com, linux-alpha@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-crypto@vger.kernel.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Bates <sbates@raithlin.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Suresh Warrier <warrier@linux.vnet.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>
To: Logan Gunthorpe <logang@deltatee.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20170622164817.25515-3-logang@deltatee.com>
Sender: linux-arch-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

> +u64 ioread64(void __iomem *addr)
> +{
> +       u64 low, high;
> +
> +       low = ioread32(addr);
> +       high = ioread32(addr + sizeof(u32));
> +       return low | (high << 32);
> +}
> +u64 ioread64be(void __iomem *addr)
> +{
> +       u64 low, high;
> +
> +       low = ioread32be(addr + sizeof(u32));
> +       high = ioread32be(addr);
> +       return low | (high << 32);
> +}
> +#endif

This hardcodes the behavior of include/linux/io-64-nonatomic-hi-lo.h, which
I find rather confusing, as only about one in five drivers wants this
behavior.

I'd suggest you don't add it in lib/iomap.c at all for 32-bit architectures,
but rather use the same logic that we have for readq/writeq in
io-64-nonatomic-hi-lo.h and io-64-nonatomic-lo-hi.h, adding
{lo_hi,hi_lo}_{ioread,iowrite}{,be} to the same files, and provide
the {ioread,iowrite}{,be} macros only if they have not been defined
at that point.

       Arnd
