From: "Yang Shi" <yang.s@alibaba-inc.com>
Subject: Re: [PATCH 7/8] net: ovs: remove unused hardirq.h
Date: Sat, 18 Nov 2017 09:48:45 +0800
Message-ID: <7877c3bd-74ec-a7d2-61d3-85a4c452e710@alibaba-inc.com>
References: <1510959741-31109-1-git-send-email-yang.s@alibaba-inc.com>
 <1510959741-31109-7-git-send-email-yang.s@alibaba-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        pshelar@ovn.org, "David S. Miller" <davem@davemloft.net>,
        dev@openvswitch.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1510959741-31109-7-git-send-email-yang.s@alibaba-inc.com>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

It looks the email address of Pravin in MAINTAINERS file is obsolete, 
sent to the right address.

Yang


On 11/17/17 3:02 PM, Yang Shi wrote:
> Preempt counter APIs have been split out, currently, hardirq.h just
> includes irq_enter/exit APIs which are not used by openvswitch at all.
> 
> So, remove the unused hardirq.h.
> 
> Signed-off-by: Yang Shi <yang.s@alibaba-inc.com>
> Cc: Pravin Shelar <pshelar@nicira.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: dev@openvswitch.org
> ---
>   net/openvswitch/vport-internal_dev.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
> index 04a3128..2f47c65 100644
> --- a/net/openvswitch/vport-internal_dev.c
> +++ b/net/openvswitch/vport-internal_dev.c
> @@ -16,7 +16,6 @@
>    * 02110-1301, USA
>    */
>   
> -#include <linux/hardirq.h>
>   #include <linux/if_vlan.h>
>   #include <linux/kernel.h>
>   #include <linux/netdevice.h>
> 
