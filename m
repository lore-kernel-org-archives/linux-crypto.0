From: Jyri Sarha <jsarha@ti.com>
Subject: Re: [PATCH v6 1/7] drm/tilcdc: ensure nonatomic iowrite64 is not used
Date: Sat, 5 Aug 2017 16:30:35 +0300
Message-ID: <cf74e6d6-5028-6d1b-a014-2617b9102a78@ti.com>
References: <20170803183018.5889-1-logang@deltatee.com>
 <20170803183018.5889-2-logang@deltatee.com>
 <2b41b02c-07e3-b927-f276-a29480f94285@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Stephen Bates <sbates@raithlin.com>,
        David Airlie <airlied@linux.ie>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <linux-ntb@googlegroups.com>, <linux-crypto@vger.kernel.org>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <2b41b02c-07e3-b927-f276-a29480f94285@ti.com>
Content-Language: en-GB
Sender: linux-arch-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 08/04/17 16:03, Tomi Valkeinen wrote:
> On 03/08/17 21:30, Logan Gunthorpe wrote:
>> Add a check to ensure iowrite64 is only used if it is atomic.
>>
>> It was decided in [1] that the tilcdc driver should not be using an
>> atomic operation (so it was left out of this patchset). However, it turns
>> out that through the drm code, a nonatomic header is actually included:
>>
>> include/linux/io-64-nonatomic-lo-hi.h
>> is included from include/drm/drm_os_linux.h:9:0,
>>             from include/drm/drmP.h:74,
>>             from include/drm/drm_modeset_helper.h:26,
>>             from include/drm/drm_atomic_helper.h:33,
>>             from drivers/gpu/drm/tilcdc/tilcdc_crtc.c:19:
>>
>> And thus, without this change, this patchset would inadvertantly
>> change the behaviour of the tilcdc driver.
> 
> I haven't really followed the discussion on this, but if the tilcdc's
> use of iowrite64 causes (real) problems/complications elsewhere, I think
> we could drop it.
> 
> The problem is that the HW has a race issue, and the two registers in
> question should be written as close to each other as possible. We
> thought a single 64bit write, writing to both registers in one go, would
> improve that slightly, compared to two 32 bit writes.
> 
> Jyri, correct me if I'm wrong, but we have no proof that it actually
> helps, and it might be that even if it helps, the difference is
> theoretical. Probably if we ensure the irqs are off when we do two 32
> bit writes, we're already close enough to the optimal case.
> 

For the sake of this particular case you are right, the atomicity is
probably not that important here. But in general ARM7 has an atomic
64bit write and I think it is a shame if it can not be easily used in
linux kernel.

Best regards,
Jyri
