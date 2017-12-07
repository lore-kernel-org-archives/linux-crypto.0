From: Jyri Sarha <jsarha@ti.com>
Subject: Re: [PATCH v9 1/8] drm/tilcdc: ensure nonatomic iowrite64 is not used
Date: Thu, 7 Dec 2017 18:15:59 +0200
Message-ID: <3f3ad132-3b53-0f80-ffe7-3617e3cb78e2@ti.com>
References: <20171205233058.5365-1-logang@deltatee.com>
 <20171205233058.5365-2-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        David Airlie <airlied@linux.ie>
To: Logan Gunthorpe <logang@deltatee.com>,
        <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <linux-ntb@googlegroups.com>, <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171205233058.5365-2-logang@deltatee.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 12/06/17 01:30, Logan Gunthorpe wrote:
> Add a check to ensure iowrite64 is only used if it is atomic.
> 
> It was decided in [1] that the tilcdc driver should not be using an
> atomic operation (so it was left out of this patchset). However, it turns
> out that through the drm code, a nonatomic header is actually included:
> 
> include/linux/io-64-nonatomic-lo-hi.h
> is included from include/drm/drm_os_linux.h:9:0,
>             from include/drm/drmP.h:74,
>             from include/drm/drm_modeset_helper.h:26,
>             from include/drm/drm_atomic_helper.h:33,
>             from drivers/gpu/drm/tilcdc/tilcdc_crtc.c:19:
> 
> And thus, without this change, this patchset would inadvertantly
> change the behaviour of the tilcdc driver.
> 
> [1] lkml.kernel.org/r/CAK8P3a2HhO_zCnsTzq7hmWSz5La5Thu19FWZpun16iMnyyNreQ@mail.gmail.com
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Cc: Jyri Sarha <jsarha@ti.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: David Airlie <airlied@linux.ie>

I guess it is about time for me to pick this up for the next pull request.

Thanks,
Jyri

> ---
>  drivers/gpu/drm/tilcdc/tilcdc_regs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/tilcdc/tilcdc_regs.h b/drivers/gpu/drm/tilcdc/tilcdc_regs.h
> index 9d528c0a67a4..5048ebb86835 100644
> --- a/drivers/gpu/drm/tilcdc/tilcdc_regs.h
> +++ b/drivers/gpu/drm/tilcdc/tilcdc_regs.h
> @@ -133,7 +133,7 @@ static inline void tilcdc_write64(struct drm_device *dev, u32 reg, u64 data)
>  	struct tilcdc_drm_private *priv = dev->dev_private;
>  	volatile void __iomem *addr = priv->mmio + reg;
>  
> -#ifdef iowrite64
> +#if defined(iowrite64) && !defined(iowrite64_is_nonatomic)
>  	iowrite64(data, addr);
>  #else
>  	__iowmb();
> 


-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
