From: "Yang Shi" <yang.s@alibaba-inc.com>
Subject: Re: [PATCH 6/8] net: caif: remove unused hardirq.h
Date: Fri, 05 Jan 2018 06:51:36 +0800
Message-ID: <a2f9ddc4-f3e1-4f80-6b05-398d1243e225@alibaba-inc.com>
References: <1510959741-31109-1-git-send-email-yang.s@alibaba-inc.com>
 <1510959741-31109-6-git-send-email-yang.s@alibaba-inc.com>
 <9ad5b35a-8d4c-448a-912b-2816c4c8c53f@alibaba-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
 Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
 "David S. Miller" <davem@davemloft.net>
To: linux-kernel@vger.kernel.org
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <9ad5b35a-8d4c-448a-912b-2816c4c8c53f@alibaba-inc.com>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

Hi David,

I'm not sure if CAIF is still maintained by Dmitry Tarnyagin. Do you 
have any comment on this one?

Thanks,
Yang


On 12/7/17 11:13 AM, Yang Shi wrote:
> Hi folks,
> 
> Any comment on this one?
> 
> Thanks,
> Yang
> 
> 
> On 11/17/17 3:02 PM, Yang Shi wrote:
>> Preempt counter APIs have been split out, currently, hardirq.h just
>> includes irq_enter/exit APIs which are not used by caif at all.
>>
>> So, remove the unused hardirq.h.
>>
>> Signed-off-by: Yang Shi <yang.s@alibaba-inc.com>
>> Cc: Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> ---
>>   net/caif/cfpkt_skbuff.c | 1 -
>>   net/caif/chnl_net.c     | 1 -
>>   2 files changed, 2 deletions(-)
>>
>> diff --git a/net/caif/cfpkt_skbuff.c b/net/caif/cfpkt_skbuff.c
>> index 71b6ab2..38c2b7a 100644
>> --- a/net/caif/cfpkt_skbuff.c
>> +++ b/net/caif/cfpkt_skbuff.c
>> @@ -8,7 +8,6 @@
>>   #include <linux/string.h>
>>   #include <linux/skbuff.h>
>> -#include <linux/hardirq.h>
>>   #include <linux/export.h>
>>   #include <net/caif/cfpkt.h>
>> diff --git a/net/caif/chnl_net.c b/net/caif/chnl_net.c
>> index 922ac1d..53ecda1 100644
>> --- a/net/caif/chnl_net.c
>> +++ b/net/caif/chnl_net.c
>> @@ -8,7 +8,6 @@
>>   #define pr_fmt(fmt) KBUILD_MODNAME ":%s(): " fmt, __func__
>>   #include <linux/fs.h>
>> -#include <linux/hardirq.h>
>>   #include <linux/init.h>
>>   #include <linux/module.h>
>>   #include <linux/netdevice.h>
>>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
