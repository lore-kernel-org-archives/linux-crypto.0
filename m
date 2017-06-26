From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH 6/7] drm/tilcdc: clean up ifdef hacks around iowrite64
Date: Mon, 26 Jun 2017 10:26:35 -0600
Message-ID: <3ffb5648-00f6-26cb-116a-370085038a0d@deltatee.com>
References: <20170622164817.25515-1-logang@deltatee.com>
 <20170622164817.25515-7-logang@deltatee.com>
 <504da99a-838c-48ec-c5b2-6b611d587a10@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Bates <sbates@raithlin.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        David Airlie <airlied@linux.ie>
To: Jyri Sarha <jsarha@ti.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-ntb@googlegroups.com,
        linux-alpha@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-crypto@vger.kernel.org, dri-devel@lists.freedesktop.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:38358 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751405AbdFZQ0s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Jun 2017 12:26:48 -0400
In-Reply-To: <504da99a-838c-48ec-c5b2-6b611d587a10@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Jyri,

Thanks for the ack. However, I'm reworking this patch set to use the
include/linux/io-64-nonatomic* headers which will explicitly devolve
into two 32-bit transfers. It's not clear whether this is appropriate
for the tilcdc driver as it was never setup to use 32-bit transfers
(unlike the others I had patched).

If you think it's ok, I can still patch this driver to use the
non-atomic headers. Otherwise I can leave it out. Please let me know.

Thanks,

Logan


On 26/06/17 02:55 AM, Jyri Sarha wrote:
> Acked-by: Jyri Sarha <jsarha@ti.com>
> 
> And thanks!
> 
>> ---
>>  drivers/gpu/drm/tilcdc/tilcdc_regs.h | 6 ------
>>  1 file changed, 6 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/tilcdc/tilcdc_regs.h b/drivers/gpu/drm/tilcdc/tilcdc_regs.h
>> index e9ce725698a9..0b901405f30a 100644
>> --- a/drivers/gpu/drm/tilcdc/tilcdc_regs.h
>> +++ b/drivers/gpu/drm/tilcdc/tilcdc_regs.h
>> @@ -133,13 +133,7 @@ static inline void tilcdc_write64(struct drm_device *dev, u32 reg, u64 data)
>>  	struct tilcdc_drm_private *priv = dev->dev_private;
>>  	void __iomem *addr = priv->mmio + reg;
>>  
>> -#ifdef iowrite64
>>  	iowrite64(data, addr);
>> -#else
>> -	__iowmb();
>> -	/* This compiles to strd (=64-bit write) on ARM7 */
>> -	*(u64 __force *)addr = __cpu_to_le64(data);
>> -#endif
>>  }
>>  
>>  static inline u32 tilcdc_read(struct drm_device *dev, u32 reg)
>>
> 
