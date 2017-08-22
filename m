From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v7 6/7] ntb: ntb_hw_intel: use io-64-nonatomic instead of
 in-driver hacks
Date: Tue, 22 Aug 2017 23:14:50 +0300
Message-ID: <CAHp75Ve-3JnD2b5Wn5zPX+jW91Wcw3utpAJ5gPkz5zHsG+2reQ@mail.gmail.com>
References: <20170822170228.17196-1-logang@deltatee.com> <20170822170228.17196-7-logang@deltatee.com>
 <CAHp75VfPXjw-gTX=xQsk_0vUhyeTEYiTvoacTzw43RgyGKKaVg@mail.gmail.com> <b4b38bb0-b97f-2240-0ddc-ef5444e289ef@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        linux-ntb@googlegroups.com,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Stephen Bates <sbates@raithlin.com>
To: Logan Gunthorpe <logang@deltatee.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:36452 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752451AbdHVUOw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Aug 2017 16:14:52 -0400
In-Reply-To: <b4b38bb0-b97f-2240-0ddc-ef5444e289ef@deltatee.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 22, 2017 at 8:56 PM, Logan Gunthorpe <logang@deltatee.com> wrote:
>
>
> On 22/08/17 11:41 AM, Andy Shevchenko wrote:
>>>
>>> @@ -59,6 +59,7 @@
>>>   #include <linux/random.h>
>>>   #include <linux/slab.h>
>>>   #include <linux/ntb.h>
>>> +#include <linux/io-64-nonatomic-lo-hi.h>
>>
>>
>> I would rather try to squeeze to most alpabetiacelly ordered part of this
>> block.
>> Otherwise it's a pretty nice clean up!
>>
>
> I don't understand. The includes were not alphabetically in any order
> originally and I'd rather not reorder them in my patch.

In excerpt I see if you put your include before random.h you will get
3 headers in order.
There may be even better sequence, I didn't check.


-- 
With Best Regards,
Andy Shevchenko
