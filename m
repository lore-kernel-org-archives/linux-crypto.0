From: "Gonglei (Arei)" <arei.gonglei@huawei.com>
Subject: RE: [PATCH v8 1/1] crypto: add virtio-crypto driver
Date: Fri, 13 Jan 2017 01:56:03 +0000
Message-ID: <33183CC9F5247A488A2544077AF19020DA18F954@DGGEMA505-MBX.china.huawei.com>
References: <1481767396-187748-1-git-send-email-arei.gonglei@huawei.com>
 <1481767396-187748-2-git-send-email-arei.gonglei@huawei.com>
 <e235caf4-f51c-dccf-4eb7-548d3fa71644@de.ibm.com>
 <33183CC9F5247A488A2544077AF19020DA182B83@DGGEMA505-MBX.china.huawei.com>
 <c4282723-2afb-1764-2431-ef41f7126371@de.ibm.com>
 <a8384ff8-ff65-c578-c338-e6d8ebf498c4@de.ibm.com>
 <20170112161729-mutt-send-email-mst@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
        "virtualization@lists.linux-foundation.org"
        <virtualization@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        Claudio Fontana <Claudio.Fontana@huawei.com>,
        Luonengjun <luonengjun@huawei.com>,
        "Hanweidong (Randy)" <hanweidong@huawei.com>,
        "Xuquan (Quan Xu)" <xuquan8@huawei.com>,
        "Wanzongshun (Vincent)" <wanzongshun@huawei.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "Zhoujian (jay, Euler)" <
To: "Michael S. Tsirkin" <mst@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([45.249.212.189]:2451 "EHLO
        dggrg03-dlp.huawei.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750819AbdAMB66 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 20:58:58 -0500
In-Reply-To: <20170112161729-mutt-send-email-mst@kernel.org>
Content-Language: zh-CN
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> 
> On Thu, Jan 12, 2017 at 03:10:25PM +0100, Christian Borntraeger wrote:
> > On 01/10/2017 01:56 PM, Christian Borntraeger wrote:
> > > On 01/10/2017 01:36 PM, Gonglei (Arei) wrote:
> > >> Hi,
> > >>
> > >>>
> > >>> On 12/15/2016 03:03 AM, Gonglei wrote:
> > >>> [...]
> > >>>> +
> > >>>> +static struct crypto_alg virtio_crypto_algs[] = { {
> > >>>> +	.cra_name = "cbc(aes)",
> > >>>> +	.cra_driver_name = "virtio_crypto_aes_cbc",
> > >>>> +	.cra_priority = 501,
> > >>>
> > >>>
> > >>> This is still higher than the hardware-accelerators (like intel aesni or the
> > >>> s390 cpacf functions or the arm hw). aesni and s390/cpacf are supported
> by the
> > >>> hardware virtualization and available to the guests. I do not see a way
> how
> > >>> virtio
> > >>> crypto can be faster than that (in the end it might be cpacf/aesni +
> overhead)
> > >>> instead it will very likely be slower.
> > >>> So we should use a number that is higher than software implementations
> but
> > >>> lower than the hw ones.
> > >>>
> > >>> Just grepping around, the software ones seem be be around 100 and the
> > >>> hardware
> > >>> ones around 200-400. So why was 150 not enough?
> > >>>
> > >> I didn't find a documentation about how we use the priority, and I assumed
> > >> people use virtio-crypto will configure hardware accelerators in the
> > >> host. So I choosed the number which bigger than aesni's priority.
> > >
> > > Yes, but the aesni driver will only bind if there is HW support in the guest.
> > > And if aesni is available in the guest (or the s390 aes function from cpacf)
> > > it will always be faster than the same in the host via virtio.So your priority
> > > should be smaller.
> >
> >
> > any opinion on this?
> 
> Going forward, we might add an emulated aesni device and that might
> become slower than virtio. OTOH if or when this happens, we can solve it
> by adding a priority or a feature flag to virtio to raise its priority.
> 
> So I think I agree with Christian here, let's lower the priority.
> Gonglei, could you send a patch like this?
> 
OK, will do.

Thanks,
-Gonglei
