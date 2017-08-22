From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH v7 6/7] ntb: ntb_hw_intel: use io-64-nonatomic instead of
 in-driver hacks
Date: Tue, 22 Aug 2017 11:56:34 -0600
Message-ID: <b4b38bb0-b97f-2240-0ddc-ef5444e289ef@deltatee.com>
References: <20170822170228.17196-1-logang@deltatee.com>
 <20170822170228.17196-7-logang@deltatee.com>
 <CAHp75VfPXjw-gTX=xQsk_0vUhyeTEYiTvoacTzw43RgyGKKaVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        linux-ntb@googlegroups.com,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Stephen Bates <sbates@raithlin.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <CAHp75VfPXjw-gTX=xQsk_0vUhyeTEYiTvoacTzw43RgyGKKaVg@mail.gmail.com>
Content-Language: en-US
Sender: linux-arch-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 22/08/17 11:41 AM, Andy Shevchenko wrote:
>> @@ -59,6 +59,7 @@
>>   #include <linux/random.h>
>>   #include <linux/slab.h>
>>   #include <linux/ntb.h>
>> +#include <linux/io-64-nonatomic-lo-hi.h>
> 
> I would rather try to squeeze to most alpabetiacelly ordered part of this block.
> Otherwise it's a pretty nice clean up!
> 

I don't understand. The includes were not alphabetically in any order 
originally and I'd rather not reorder them in my patch.

Logan
