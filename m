From: "Yang Shi" <yang.s@alibaba-inc.com>
Subject: Re: [PATCH 6/8] net: caif: remove unused hardirq.h
Date: Fri, 08 Dec 2017 03:13:55 +0800
Message-ID: <9ad5b35a-8d4c-448a-912b-2816c4c8c53f@alibaba-inc.com>
References: <1510959741-31109-1-git-send-email-yang.s@alibaba-inc.com>
 <1510959741-31109-6-git-send-email-yang.s@alibaba-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
        "David S. Miller" <davem@davemloft.net>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1510959741-31109-6-git-send-email-yang.s@alibaba-inc.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi folks,

Any comment on this one?

Thanks,
Yang


On 11/17/17 3:02 PM, Yang Shi wrote:
> Preempt counter APIs have been split out, currently, hardirq.h just
> includes irq_enter/exit APIs which are not used by caif at all.
> 
> So, remove the unused hardirq.h.
> 
> Signed-off-by: Yang Shi <yang.s@alibaba-inc.com>
> Cc: Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>
> Cc: "David S. Miller" <davem@davemloft.net>
> ---
>   net/caif/cfpkt_skbuff.c | 1 -
>   net/caif/chnl_net.c     | 1 -
>   2 files changed, 2 deletions(-)
> 
> diff --git a/net/caif/cfpkt_skbuff.c b/net/caif/cfpkt_skbuff.c
> index 71b6ab2..38c2b7a 100644
> --- a/net/caif/cfpkt_skbuff.c
> +++ b/net/caif/cfpkt_skbuff.c
> @@ -8,7 +8,6 @@
>   
>   #include <linux/string.h>
>   #include <linux/skbuff.h>
> -#include <linux/hardirq.h>
>   #include <linux/export.h>
>   #include <net/caif/cfpkt.h>
>   
> diff --git a/net/caif/chnl_net.c b/net/caif/chnl_net.c
> index 922ac1d..53ecda1 100644
> --- a/net/caif/chnl_net.c
> +++ b/net/caif/chnl_net.c
> @@ -8,7 +8,6 @@
>   #define pr_fmt(fmt) KBUILD_MODNAME ":%s(): " fmt, __func__
>   
>   #include <linux/fs.h>
> -#include <linux/hardirq.h>
>   #include <linux/init.h>
>   #include <linux/module.h>
>   #include <linux/netdevice.h>
> 
