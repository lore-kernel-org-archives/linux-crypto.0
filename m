From: Ying Xue <ying.xue@windriver.com>
Subject: Re: [PATCH 8/8] net: tipc: remove unused hardirq.h
Date: Fri, 8 Dec 2017 09:40:30 +0800
Message-ID: <4ed1efbc-5fb8-7412-4f46-1e3a91a98373@windriver.com>
References: <1510959741-31109-1-git-send-email-yang.s@alibaba-inc.com>
 <1510959741-31109-8-git-send-email-yang.s@alibaba-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        Jon Maloy
	<jon.maloy@ericsson.com>,
        "David S. Miller" <davem@davemloft.net>
To: Yang Shi <yang.s@alibaba-inc.com>, <linux-kernel@vger.kernel.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1510959741-31109-8-git-send-email-yang.s@alibaba-inc.com>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

On 11/18/2017 07:02 AM, Yang Shi wrote:
> Preempt counter APIs have been split out, currently, hardirq.h just
> includes irq_enter/exit APIs which are not used by TIPC at all.
> 
> So, remove the unused hardirq.h.
> 
> Signed-off-by: Yang Shi <yang.s@alibaba-inc.com>
> Cc: Jon Maloy <jon.maloy@ericsson.com>
> Cc: Ying Xue <ying.xue@windriver.com>
> Cc: "David S. Miller" <davem@davemloft.net>

Tested-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Ying Xue <ying.xue@windriver.com>

> ---
>  net/tipc/core.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/net/tipc/core.h b/net/tipc/core.h
> index 5cc5398..099e072 100644
> --- a/net/tipc/core.h
> +++ b/net/tipc/core.h
> @@ -49,7 +49,6 @@
>  #include <linux/uaccess.h>
>  #include <linux/interrupt.h>
>  #include <linux/atomic.h>
> -#include <asm/hardirq.h>
>  #include <linux/netdevice.h>
>  #include <linux/in.h>
>  #include <linux/list.h>
> 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
