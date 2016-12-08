From: "Gonglei (Arei)" <arei.gonglei@huawei.com>
Subject: RE: [PATCH v5 1/1] crypto: add virtio-crypto driver
Date: Thu, 8 Dec 2016 02:10:19 +0000
Message-ID: <33183CC9F5247A488A2544077AF19020DA156A4C@DGGEMA505-MBX.china.huawei.com>
References: <1480595945-63656-2-git-send-email-arei.gonglei@huawei.com>
 <201612041032.loAEWLIy%fengguang.wu@intel.com>
 <33183CC9F5247A488A2544077AF19020DA1528DE@DGGEMA505-MBX.china.huawei.com>
 <20161207202039.GA27878@ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: kbuild test robot <lkp@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kbuild-all@01.org" <kbuild-all@01.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
        "herbert@gondor.apana.org.
To: Sam Ravnborg <sam@ravnborg.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:2373 "EHLO
        dggrg02-dlp.huawei.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753523AbcLHCL2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Dec 2016 21:11:28 -0500
In-Reply-To: <20161207202039.GA27878@ravnborg.org>
Content-Language: zh-CN
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Sam,

>
> Subject: Re: [PATCH v5 1/1] crypto: add virtio-crypto driver
> 
> On Mon, Dec 05, 2016 at 03:12:52AM +0000, Gonglei (Arei) wrote:
> > I don't think the root cause of those warnings are introduced by virtio-crypto
> driver.
> >
> > What's your opinion? Sam and David?
> 
> Root cause here is that arch/sparc/include/asm/topology_64.h
> references cpu_data without including arch/sparc/include/asm/cpudata.h
> 
> I think other architectures pull in the dependency from
> either smp.h or they have it topology.h.
> 
> The easy fix would be to include cpudata.h in
> arch/sparc/include/asm/topology_64.h.
> And that should also be a correct fix.
> 
> Could you include this in your patch-set and build test it?
> 
Sure, I can add this one at the head of my patch set, but because I
haven't sparc environment, so it depends on the kbuild test robot
to test.

Thanks,
-Gonglei
