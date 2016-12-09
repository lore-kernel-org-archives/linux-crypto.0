From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v6 1/2] sparc: fix a building error reported by kbuild
Date: Fri, 9 Dec 2016 22:58:51 +0100
Message-ID: <20161209215851.GA7717@ravnborg.org>
References: <1481171829-116496-1-git-send-email-arei.gonglei@huawei.com>
 <1481171829-116496-2-git-send-email-arei.gonglei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, qemu-devel@nongnu.org,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, luonengjun@huawei.com,
        mst@redhat.com, stefanha@redhat.com, weidong.huang@huawei.com,
        wu.wubin@huawei.com, xin.zeng@intel.com,
        claudio.fontana@huawei.com, herbert@gondor.apana.org.au,
        pasic@linux.vnet.ibm.com, davem@davemloft.net,
        jianjay.zhou@huawei.com, hanweidong@huawei.com,
        arei.gonglei@hotmail.com, cornelia.huck@de.ibm.com,
        xuquan8@huawei.com, longpeng2@huawei.com, wanzongshun@huawei.com,
        sparclinux@vger.kernel.org
To: Gonglei <arei.gonglei@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from asavdk3.altibox.net ([109.247.116.14]:51305 "EHLO
        asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753109AbcLIV7C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Dec 2016 16:59:02 -0500
Content-Disposition: inline
In-Reply-To: <1481171829-116496-2-git-send-email-arei.gonglei@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Gonglei.

On Thu, Dec 08, 2016 at 12:37:08PM +0800, Gonglei wrote:
> >> arch/sparc/include/asm/topology_64.h:44:44:
> error: implicit declaration of function 'cpu_data'
> [-Werror=implicit-function-declaration]
> 
>  #define topology_physical_package_id(cpu) (cpu_data(cpu).proc_id)
>                                                ^
> Let's include cpudata.h in topology_64.h.
> 
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: sparclinux@vger.kernel.org
> Suggested-by: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: Gonglei <arei.gonglei@huawei.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>

> ---
>  arch/sparc/include/asm/topology_64.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/sparc/include/asm/topology_64.h b/arch/sparc/include/asm/topology_64.h
> index 7b4898a..2255430 100644
> --- a/arch/sparc/include/asm/topology_64.h
> +++ b/arch/sparc/include/asm/topology_64.h
> @@ -4,6 +4,7 @@
>  #ifdef CONFIG_NUMA
>  
>  #include <asm/mmzone.h>
> +#include <asm/cpudata.h>

Nitpick - if you are going to resend this patch, then please
order the two includes in alphabetic order.

For two includes this looks like bikeshedding, but when we add
more having them in a defined arder prevents merge conflicts.
And makes it readable too.

We also sometimes order the includes with the longest lines topmost,
and lines with the ame length are ordered alphabetically.
But this is not seen so often.

	Sam
