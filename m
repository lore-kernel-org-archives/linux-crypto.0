From: Joel Fernandes <joelf@ti.com>
Subject: Re: [PATCH 02/10] crypto: omap-aes: Add useful debug macros
Date: Thu, 15 Aug 2013 02:27:14 -0500
Message-ID: <520C82D2.8040700@ti.com>
References: <1376521969-16807-1-git-send-email-joelf@ti.com>
 <1376521969-16807-3-git-send-email-joelf@ti.com>
 <1376522998.1949.118.camel@joe-AO722> <520C156D.2090003@ti.com>
 <1376527636.1949.120.camel@joe-AO722> <520C472D.8000904@ti.com>
 <520C73D6.3010904@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Tony Lindgren <tony@atomide.com>, Rajendra Nayak <rnayak@ti.com>,
 Mark Greer <mgreer@animalcreek.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Herbert Xu <herbert@gondor.hengli.com.au>,
 Santosh Shilimkar <santosh.shilimkar@ti.com>,
 Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
 Joe Perches <joe@perches.com>, Linux OMAP List <linux-omap@vger.kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Lokesh Vutla <lokeshvutla@ti.com>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <520C73D6.3010904@samsung.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On 08/15/2013 01:23 AM, Dmitry Kasatkin wrote:
> On 15/08/13 06:12, Joel Fernandes wrote:
>> On 08/14/2013 07:47 PM, Joe Perches wrote:
>>> On Wed, 2013-08-14 at 18:40 -0500, Joel Fernandes wrote:
>>>> On 08/14/2013 06:29 PM, Joe Perches wrote:
>>>>> On Wed, 2013-08-14 at 18:12 -0500, Joel Fernandes wrote:
>>>>>> When DEBUG is enabled, these macros can be used to print variables
>>>>>> in integer and hex format, and clearly display which registers,
>>>>>> offsets and values are being read/written , including printing the
>>>>>> names of the offsets and their values.
>>>>> []
>>>>>> diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
>>>>> []
>>>>>> @@ -15,6 +15,14 @@
>>>>>>  
>>>>>>  #define pr_fmt(fmt) "%s: " fmt, __func__
>>>>>>  
>>>>>> +#ifdef DEBUG
>>>>>> +#define prn(num) printk(#num "=%d\n", num)
>>>>>> +#define prx(num) printk(#num "=%x\n", num)
>>>>> pr_debug?
>>>> Sure, can change that.
>>>>
>>>>>> +#else
>>>>>> +#define prn(num) do { } while (0)
>>>>>> +#define prx(num)  do { } while (0)
>>>>>> +#endif
>>>>> []
>>>>>> @@ -172,13 +180,35 @@ struct omap_aes_dev {
>>>>>>  static LIST_HEAD(dev_list);
>>>>>>  static DEFINE_SPINLOCK(list_lock);
>>>>>>  
>>>>>> +#ifdef DEBUG
>>>>>> +#define omap_aes_read(dd, offset)					\
>>>>>> +	do {								\
>>>>>> +		omap_aes_read_1(dd, offset);				\
>>>>>> +		pr_debug("omap_aes_read(" #offset ")\n");		\
>>>>>> +	} while (0)
>>>>>> +
>>>>>> +static inline u32 omap_aes_read_1(struct omap_aes_dev *dd, u32 offset)
>>>>>> +#else
>>>>>>  static inline u32 omap_aes_read(struct omap_aes_dev *dd, u32 offset)
>>>>>> +#endif
>>>>>>  {
>>>>>>  	return __raw_readl(dd->io_base + offset);
>>>>>>  }
>>>>>>  
>>>>>> +#ifdef DEBUG
>>>>>> +#define omap_aes_write(dd, offset, value)				\
>>>>>> +	do {								\
>>>>>> +		pr_debug("omap_aes_write(" #offset "=%x) value=%d\n",	\
>>>>>> +			 offset, value);				\
>>>>>> +		omap_aes_write_1(dd, offset, value);			\
>>>>>> +	} while (0)
>>>>>> +
>>>>>> +static inline void omap_aes_write_1(struct omap_aes_dev *dd, u32 offset,
>>>>>> +				  u32 value)
>>>>>> +#else
>>>>>>  static inline void omap_aes_write(struct omap_aes_dev *dd, u32 offset,
>>>>>>  				  u32 value)
>>>>>> +#endif
>>>>>>  {
>>>>>>  	__raw_writel(value, dd->io_base + offset);
>>>>>>  }
>>>>> Umm, yuck?
>>>>>
>>>>> Is there any real value in read_1 and write_1?
>>>> Can you be more descriptive? There is a lot of value in them for debug
>>>> to show clearly sequence of read/writes. Moreover, they are no-op'd when
>>>> DEBUG is disabled.
>>> pr_debug is no-op'd when DEBUG is not #defined.
>>> so just use a single
>>>
>>> omap_aes_write(...)
>>> {
>>> 	pr_debug(...)
>>> 	__raw_writel(...);
>>> }
>> Actually this doesn't work, as the pr_debug cannot print the name of the
>> offset as my original patch set does using "#offset".
>>
>> There are many places where named offsets are used to pass to
>> read/write, and this macro helps to visually see which offset is being
>> written to by name.
>>
>> So the original patch would stand in its current form except for a small
>> rewrite of the write debug part of it as follows to be cleaner getting
>> rid of the _1. For the read , we still need it as we need to return the
>> value from a function which cannot be done in a macro.
>>
>> So the new patch would look something like this:
>>
>> #ifdef DEBUG
>> #define omap_aes_read(dd, offset)                                      \
>>                 omap_aes_read_1(dd, offset);                           \
>>                 pr_debug("omap_aes_read(" #offset ")\n");
>> static inline u32 omap_aes_read_1(struct omap_aes_dev *dd, u32 offset)
>> #else
>> static inline u32 omap_aes_read(struct omap_aes_dev *dd, u32 offset)
>> #endif
>> {
>>         return __raw_readl(dd->io_base + offset);
>> }
> 
> Bellow version "write" looks much more readable - never re-define
> function signature by macro.
> Above should be similar as well...

Yes, I'll write the read in the final version of this patch like the
write. Its certainly cleaner.

-Joel



>> #ifdef DEBUG
>> #define omap_aes_write(dd, offset, value)                              \
>>         do {                                                           \
>>                 pr_debug("omap_aes_write(" #offset "=%x) value=%d\n",  \
>>                          offset, value);                               \
>>                 __raw_writel(value, dd->io_base + offset);             \
>>         } while (0)
>> #else
>> static inline void omap_aes_write(struct omap_aes_dev *dd, u32 offset,
>>                                   u32 value)
>> {
>>         __raw_writel(value, dd->io_base + offset);
>> }
>> #endif
> 
>>
>>
>> Thanks,
>>
>> -Joel
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
