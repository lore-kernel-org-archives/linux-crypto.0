From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH v12 1/9] iomap: Fix sparse endian check warnings
Date: Mon, 19 Mar 2018 14:38:04 -0600
Message-ID: <9a55914e-142c-2a1b-2eef-66d7922a58b8@deltatee.com>
References: <20180316154852.13206-1-logang@deltatee.com>
 <20180316154852.13206-2-logang@deltatee.com>
 <20180317190311.tdmx2vlcjttsjs5j@ltop.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-crypto@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Kate Stewart <kstewart@linuxfoundation.org>
To: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180317190311.tdmx2vlcjttsjs5j@ltop.local>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Luc,

Thanks for the feedback. I'll try to address your points in a v13 shortly.

Logan


On 18/03/18 10:13 AM, Luc Van Oostenryck wrote:
> it looks correct but if you should explain why the warning
> is not a valid one. Once done, you can then explain what problem
> you have fixed instead of saying you suppressed a warning.
> 
>> Also, it looks like the wrong conversion function was used in
> 
> I would suggest to split the patch in two since it does two
> different things which should have their own explanation.
> 
>> diff --git a/lib/iomap.c b/lib/iomap.c
>> index 541d926da95e..a05d9fa21794 100644
>> --- a/lib/iomap.c
>> +++ b/lib/iomap.c
>> @@ -106,8 +106,10 @@ EXPORT_SYMBOL(ioread32be);
>>  #endif
>>  
>>  #ifndef mmio_write16be
>> -#define mmio_write16be(val,port) __raw_writew(be16_to_cpu(val),port)
>> -#define mmio_write32be(val,port) __raw_writel(be32_to_cpu(val),port)
>> +#define mmio_write16be(val, port) \
>> +	__raw_writew((u16 __force)cpu_to_be16(val), port)
>> +#define mmio_write32be(val, port) \
>> +	__raw_writel((u32 __force)cpu_to_be32(val), port)
>>  #endif
> 
> I think that in this sort of replacement, it's better to not split
> the lines (even if larger than 80, that's it).
> 
> -- Luc Van Oostenryck
> 
