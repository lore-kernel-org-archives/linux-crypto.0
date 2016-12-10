From: "Gonglei (Arei)" <arei.gonglei@huawei.com>
Subject: RE: [PATCH v6 1/2] sparc: fix a building error reported by kbuild
Date: Sat, 10 Dec 2016 08:40:02 +0000
Message-ID: <33183CC9F5247A488A2544077AF19020DA159386@DGGEMA505-MBX.china.huawei.com>
References: <1481171829-116496-1-git-send-email-arei.gonglei@huawei.com>
 <1481171829-116496-2-git-send-email-arei.gonglei@huawei.com>
 <20161209215851.GA7717@ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
        "virtualization@lists.linux-foundation.org"
        <virtualization@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Luonengjun <luonengjun@huawei.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "Wubin (H)" <wu.wubin@huawei.com>,
        "xin.zeng@intel.com" <xin.zeng@intel.com>,
        Claudio Fontana <Claudio.Fontana@huawei.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "pasic@linux.vnet.ibm.com" <pasic@linux.vnet.ibm.com>,
        "davem@davemloft.net" <davem@davemloft.
To: Sam Ravnborg <sam@ravnborg.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([45.249.212.189]:2431 "EHLO
        dggrg03-dlp.huawei.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752513AbcLJIkq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Dec 2016 03:40:46 -0500
In-Reply-To: <20161209215851.GA7717@ravnborg.org>
Content-Language: zh-CN
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>





Regards,
-Gonglei


> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org
> [mailto:linux-crypto-owner@vger.kernel.org] On Behalf Of Sam Ravnborg
> Sent: Saturday, December 10, 2016 5:59 AM
> To: Gonglei (Arei)
> Cc: linux-kernel@vger.kernel.org; qemu-devel@nongnu.org;
> virtio-dev@lists.oasis-open.org; virtualization@lists.linux-foundation.org;
> linux-crypto@vger.kernel.org; Luonengjun; mst@redhat.com;
> stefanha@redhat.com; Huangweidong (C); Wubin (H); xin.zeng@intel.com;
> Claudio Fontana; herbert@gondor.apana.org.au; pasic@linux.vnet.ibm.com;
> davem@davemloft.net; Zhoujian (jay, Euler); Hanweidong (Randy);
> arei.gonglei@hotmail.com; cornelia.huck@de.ibm.com; Xuquan (Quan Xu);
> longpeng; Wanzongshun (Vincent); sparclinux@vger.kernel.org
> Subject: Re: [PATCH v6 1/2] sparc: fix a building error reported by kbuild
> 
> Hi Gonglei.
> 
> On Thu, Dec 08, 2016 at 12:37:08PM +0800, Gonglei wrote:
> > >> arch/sparc/include/asm/topology_64.h:44:44:
> > error: implicit declaration of function 'cpu_data'
> > [-Werror=implicit-function-declaration]
> >
> >  #define topology_physical_package_id(cpu) (cpu_data(cpu).proc_id)
> >                                                ^
> > Let's include cpudata.h in topology_64.h.
> >
> > Cc: Sam Ravnborg <sam@ravnborg.org>
> > Cc: David S. Miller <davem@davemloft.net>
> > Cc: sparclinux@vger.kernel.org
> > Suggested-by: Sam Ravnborg <sam@ravnborg.org>
> > Signed-off-by: Gonglei <arei.gonglei@huawei.com>
> Acked-by: Sam Ravnborg <sam@ravnborg.org>
> 
Thanks.

> > ---
> >  arch/sparc/include/asm/topology_64.h | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/sparc/include/asm/topology_64.h
> b/arch/sparc/include/asm/topology_64.h
> > index 7b4898a..2255430 100644
> > --- a/arch/sparc/include/asm/topology_64.h
> > +++ b/arch/sparc/include/asm/topology_64.h
> > @@ -4,6 +4,7 @@
> >  #ifdef CONFIG_NUMA
> >
> >  #include <asm/mmzone.h>
> > +#include <asm/cpudata.h>
> 
> Nitpick - if you are going to resend this patch, 

It depends on the maintainer's thought. :)

> then please order the two includes in alphabetic order.
> 
> For two includes this looks like bikeshedding, but when we add
> more having them in a defined arder prevents merge conflicts.
> And makes it readable too.
> 
> We also sometimes order the includes with the longest lines topmost,
> and lines with the ame length are ordered alphabetically.
> But this is not seen so often.
> 

Regards,
-Gonglei
