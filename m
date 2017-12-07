From: "Yang Shi" <yang.s@alibaba-inc.com>
Subject: Re: [PATCH 8/8] net: tipc: remove unused hardirq.h
Date: Fri, 08 Dec 2017 03:15:50 +0800
Message-ID: <da42d136-4e51-6d04-4120-cb53df03c661@alibaba-inc.com>
References: <1510959741-31109-1-git-send-email-yang.s@alibaba-inc.com>
 <1510959741-31109-8-git-send-email-yang.s@alibaba-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1510959741-31109-8-git-send-email-yang.s@alibaba-inc.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi folks,

Any comment on this one?

Thanks,
Yang


On 11/17/17 3:02 PM, Yang Shi wrote:
> Preempt counter APIs have been split out, currently, hardirq.h just
> includes irq_enter/exit APIs which are not used by TIPC at all.
> 
> So, remove the unused hardirq.h.
> 
> Signed-off-by: Yang Shi <yang.s@alibaba-inc.com>
> Cc: Jon Maloy <jon.maloy@ericsson.com>
> Cc: Ying Xue <ying.xue@windriver.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> ---
>   net/tipc/core.h | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/net/tipc/core.h b/net/tipc/core.h
> index 5cc5398..099e072 100644
> --- a/net/tipc/core.h
> +++ b/net/tipc/core.h
> @@ -49,7 +49,6 @@
>   #include <linux/uaccess.h>
>   #include <linux/interrupt.h>
>   #include <linux/atomic.h>
> -#include <asm/hardirq.h>
>   #include <linux/netdevice.h>
>   #include <linux/in.h>
>   #include <linux/list.h>
> 
