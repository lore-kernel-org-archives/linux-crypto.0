From: "Gonglei (Arei)" <arei.gonglei@huawei.com>
Subject: RE: [PATCH v8 1/1] crypto: add virtio-crypto driver
Date: Tue, 10 Jan 2017 12:36:27 +0000
Message-ID: <33183CC9F5247A488A2544077AF19020DA182B83@DGGEMA505-MBX.china.huawei.com>
References: <1481767396-187748-1-git-send-email-arei.gonglei@huawei.com>
 <1481767396-187748-2-git-send-email-arei.gonglei@huawei.com>
 <e235caf4-f51c-dccf-4eb7-548d3fa71644@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Huangweidong (C)" <weidong.huang@huawei.com>,
        Claudio Fontana <Claudio.Fontana@huawei.com>,
        "mst@redhat.com" <mst@redhat.com>,
        Luonengjun <luonengjun@huawei.com>,
        "Hanweidong (Randy)" <hanweidong@huawei.com>,
        "Xuquan (Quan Xu)" <xuquan8@huawei.com>,
        "Wanzongshun (Vincent)" <wanzongshun@huawei.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "Zhoujian (jay, Euler)" <jianjay.zhou@huawei.com>,
        longpeng <longpeng2@huawei.com>,
        "arei.gonglei@hotmail.com" <arei.gonglei@hotmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Wubin (H)" <wu.wubin@huawei.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
To: Christian Borntraeger <borntraeger@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
        "virtualization@lists.linux-foundation.org"
        <virtualization@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e235caf4-f51c-dccf-4eb7-548d3fa71644@de.ibm.com>
Content-Language: zh-CN
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

> 
> On 12/15/2016 03:03 AM, Gonglei wrote:
> [...]
> > +
> > +static struct crypto_alg virtio_crypto_algs[] = { {
> > +	.cra_name = "cbc(aes)",
> > +	.cra_driver_name = "virtio_crypto_aes_cbc",
> > +	.cra_priority = 501,
> 
> 
> This is still higher than the hardware-accelerators (like intel aesni or the
> s390 cpacf functions or the arm hw). aesni and s390/cpacf are supported by the
> hardware virtualization and available to the guests. I do not see a way how
> virtio
> crypto can be faster than that (in the end it might be cpacf/aesni + overhead)
> instead it will very likely be slower.
> So we should use a number that is higher than software implementations but
> lower than the hw ones.
> 
> Just grepping around, the software ones seem be be around 100 and the
> hardware
> ones around 200-400. So why was 150 not enough?
> 
I didn't find a documentation about how we use the priority, and I assumed
people use virtio-crypto will configure hardware accelerators in the
host. So I choosed the number which bigger than aesni's priority.

Regards,
-Gonglei
