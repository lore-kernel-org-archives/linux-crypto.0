From: "Yang Shi" <yang.s@alibaba-inc.com>
Subject: Re: [PATCH 8/8] net: tipc: remove unused hardirq.h
Date: Fri, 05 Jan 2018 06:46:48 +0800
Message-ID: <b48afbb6-771f-84b1-8329-d5941eff086b@alibaba-inc.com>
References: <1510959741-31109-1-git-send-email-yang.s@alibaba-inc.com>
 <1510959741-31109-8-git-send-email-yang.s@alibaba-inc.com>
 <4ed1efbc-5fb8-7412-4f46-1e3a91a98373@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ying Xue <ying.xue@windriver.com>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, Jon Maloy <jon.maloy@ericsson.com>
To: linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from out0-206.mail.aliyun.com ([140.205.0.206]:44634 "EHLO
        out0-206.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753435AbeADWrC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Jan 2018 17:47:02 -0500
In-Reply-To: <4ed1efbc-5fb8-7412-4f46-1e3a91a98373@windriver.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi David,

Any more comment on this change?

Thanks,
Yang


On 12/7/17 5:40 PM, Ying Xue wrote:
> On 11/18/2017 07:02 AM, Yang Shi wrote:
>> Preempt counter APIs have been split out, currently, hardirq.h just
>> includes irq_enter/exit APIs which are not used by TIPC at all.
>>
>> So, remove the unused hardirq.h.
>>
>> Signed-off-by: Yang Shi <yang.s@alibaba-inc.com>
>> Cc: Jon Maloy <jon.maloy@ericsson.com>
>> Cc: Ying Xue <ying.xue@windriver.com>
>> Cc: "David S. Miller" <davem@davemloft.net>
> 
> Tested-by: Ying Xue <ying.xue@windriver.com>
> Acked-by: Ying Xue <ying.xue@windriver.com>
> 
>> ---
>>   net/tipc/core.h | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/net/tipc/core.h b/net/tipc/core.h
>> index 5cc5398..099e072 100644
>> --- a/net/tipc/core.h
>> +++ b/net/tipc/core.h
>> @@ -49,7 +49,6 @@
>>   #include <linux/uaccess.h>
>>   #include <linux/interrupt.h>
>>   #include <linux/atomic.h>
>> -#include <asm/hardirq.h>
>>   #include <linux/netdevice.h>
>>   #include <linux/in.h>
>>   #include <linux/list.h>
>>
