From: Kenneth Lee <liguozhu@hisilicon.com>
Subject: Re: [RFC PATCH 0/7] A General Accelerator Framework, WarpDrive
Date: Fri, 10 Aug 2018 09:37:40 +0800
Message-ID: <20180810013740.GJ91035@Turing-Arch-b>
References: <20180802040557.GL160746@Turing-Arch-b>
 <20180802142243.GA3481@redhat.com>
 <20180803034721.GC91035@Turing-Arch-b>
 <20180803143944.GA4079@redhat.com>
 <20180806031252.GG91035@Turing-Arch-b>
 <20180806153257.GB6002@redhat.com>
 <11bace0e-dc14-5d2c-f65c-25b852f4e9ca@gmail.com>
 <20180808151835.GA3429@redhat.com>
 <20180809080352.GI91035@Turing-Arch-b>
 <AADFC41AFE54684AB9EE6CBC0274A5D1912B39B3@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: Jerome Glisse <jglisse@redhat.com>,
        Kenneth Lee <nek.in.cn@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zaibo Xu <xuzaibo@huawei.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        Hao Fang <fanghao11@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Philippe Ombredanne" <pombredanne@nexb.com>,
        Thomas Gleixner <tglx@linu
To: "Tian, Kevin" <kevin.tian@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D1912B39B3@SHSMSX101.ccr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 09, 2018 at 08:31:31AM +0000, Tian, Kevin wrote:
> Date: Thu, 9 Aug 2018 08:31:31 +0000
> From: "Tian, Kevin" <kevin.tian@intel.com>
> To: Kenneth Lee <liguozhu@hisilicon.com>, Jerome Glisse <jglisse@redhat.com>
> CC: Kenneth Lee <nek.in.cn@gmail.com>, Alex Williamson
>  <alex.williamson@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>,
>  "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Jonathan Corbet
>  <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Zaibo
>  Xu <xuzaibo@huawei.com>, "linux-doc@vger.kernel.org"
>  <linux-doc@vger.kernel.org>, "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
>  Hao Fang <fanghao11@huawei.com>, "linux-kernel@vger.kernel.org"
>  <linux-kernel@vger.kernel.org>, "linuxarm@huawei.com"
>  <linuxarm@huawei.com>, "iommu@lists.linux-foundation.org"
>  <iommu@lists.linux-foundation.org>, "linux-crypto@vger.kernel.org"
>  <linux-crypto@vger.kernel.org>, Philippe Ombredanne
>  <pombredanne@nexb.com>, Thomas Gleixner <tglx@linutronix.de>, "David S .
>  Miller" <davem@davemloft.net>, "linux-accelerators@lists.ozlabs.org"
>  <linux-accelerators@lists.ozlabs.org>
> Subject: RE: [RFC PATCH 0/7] A General Accelerator Framework, WarpDrive
> Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D1912B39B3@SHSMSX101.ccr.corp.intel.com>
> 
> > From: Kenneth Lee [mailto:liguozhu@hisilicon.com]
> > Sent: Thursday, August 9, 2018 4:04 PM
> > 
> > But we have another requirement which is to combine some device
> > together to
> > share the same address space. This is a little like these kinds of solution:
> > 
> > http://tce.technion.ac.il/wp-content/uploads/sites/8/2015/06/SC-7.2-M.-
> > Silberstein.pdf
> > 
> > With that, the application can directly pass the NiC packet pointer to the
> > decryption accelerator, and get the bare data in place. This is the feature
> > that
> > the VFIO container can provide.
> 
> above is not a good argument, at least in the context of your discussion.
> If each device has their own interface (similar to GPU) for process to bind 
> with, then having the process binding to multiple devices one-by-one then
> you still get same address space shared cross them...

If we consider this from the VFIO container perspective, with a container, you
can do DMA to the container applying it to all devices, even the device is added
after the DMA operation.  

So your argument remains true only when SVM is enabled and the whole process space
is devoted to the devices. 

Yes, the process can do the same all by itself. But if we agree with that, it
makes no sense to keep the container concept in VFIO;)

> 
> Thanks
> Kevin

-- 
			-Kenneth(Hisilicon)

================================================================================
本邮件及其附件含有华为公司的保密信息，仅限于发送给上面地址中列出的个人或群组。禁
止任何其他人以任何形式使用（包括但不限于全部或部分地泄露、复制、或散发）本邮件中
的信息。如果您错收了本邮件，请您立即电话或邮件通知发件人并删除本邮件！
This e-mail and its attachments contain confidential information from HUAWEI,
which is intended only for the person or entity whose address is listed above.
Any use of the 
information contained herein in any way (including, but not limited to, total or
partial disclosure, reproduction, or dissemination) by persons other than the
intended 
recipient(s) is prohibited. If you receive this e-mail in error, please notify
the sender by phone or email immediately and delete it!
