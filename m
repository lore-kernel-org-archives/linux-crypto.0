From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: Re: [PATCH v3 12/20] media: Remove depends on HAS_DMA in case of
	platform dependency
Date: Mon, 7 May 2018 09:21:47 +0200
Message-ID: <CAMuHMdXp8u9O7Yt3W+WxuOOadYOM+_28DLOMfktwgy_WqML_0A@mail.gmail.com>
References: <1523987360-18760-1-git-send-email-geert@linux-m68k.org>
	<1523987360-18760-13-git-send-email-geert@linux-m68k.org>
	<20180505094743.4d201ba0@vento.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ulf Hansson <ulf.hansson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>,
	linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"open list:REMOTE PROCESSOR \(REMOTEPROC\) SUBSYSTEM"
	<linux-remoteproc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	ALSA Development Mailing List <alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org>,
	Bjorn Andersson <bjorn.andersson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
	Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	MTD Maling List <linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
	Linux I2C <linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux1394-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>,
	Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>,
	Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Jassi Brar <jassisinghbrar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Marek Vasut <marek.vasut-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"open list:SERIAL DRIVERS" <linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Matias Bjorling <mb@light
To: Mauro Carvalho Chehab <mchehab+samsung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20180505094743.4d201ba0-ch4gOOMV7nf/PtFMR13I2A@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi Mauro,

On Sat, May 5, 2018 at 2:47 PM, Mauro Carvalho Chehab
<mchehab+samsung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Em Tue, 17 Apr 2018 19:49:12 +0200
> Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org> escreveu:
>
>> Remove dependencies on HAS_DMA where a Kconfig symbol depends on another
>> symbol that implies HAS_DMA, and, optionally, on "|| COMPILE_TEST".
>
> Applying a patch like that is hard, as there are lots of churn at
> the code. That's against latest media upstream:

[...]

I can rebase. What's your preferred target? media-next?

>> In most cases this other symbol is an architecture or platform specific
>> symbol, or PCI.
>>
>> Generic symbols and drivers without platform dependencies keep their
>> dependencies on HAS_DMA, to prevent compiling subsystems or drivers that
>> cannot work anyway.
>
> Actually, depends on HAS_DMA was introduced on media because builds
> were failing otherwise. We started adding it before the addition
> of COMPILE_TEST.

Indeed. Before the 5 commits below, a missing dependency on HAS_DMA
would cause the build to fail for NO_DMA platforms.

    f29ab49b5388b2f8 dma-mapping: Convert NO_DMA get_dma_ops() into a real dummy
    ab642e952f80c66c dma-coherent: Add NO_DMA dummies for managed DMA API
    c1ce6c2beea38171 mm: Add NO_DMA dummies for DMA pool API
    bff739b6559e2fce scsi: Add NO_DMA dummies for SCSI DMA mapping API
    1f674e16f9ce6eb2 usb: gadget: Add NO_DMA dummies for DMA mapping API

> Can we just remove all HAS_DMA Kconfig dependencies as a hole from the
> entire media subsystem, with something like:
>
>         $ for i in $(find drivers/media -name Kconfig) $(find drivers/staging/media -name Kconfig); do sed '/depends on HAS_DMA/d;s/ && HAS_DMA//g' -i $i; done
>
> Or would it cause build issues?

It should not cause build issues, but it would enable lots of drivers that
need DMA platform support on platforms where they wouldn't work, making the
life of distro configurators harder.

That's why my series removes HAS_DMA only for symbols that have a platform
dependency.

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
