From: Xu Zaibo <xuzaibo@huawei.com>
Subject: Re: [RFC PATCH 0/7] A General Accelerator Framework, WarpDrive
Date: Thu, 2 Aug 2018 20:24:39 +0800
Message-ID: <5B62F807.8030407@huawei.com>
References: <20180801102221.5308-1-nek.in.cn@gmail.com>
 <20180801165644.GA3820@redhat.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D191290E1A@SHSMSX101.ccr.corp.intel.com>
 <20180802111000.4649d9ed@alans-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jerome Glisse <jglisse@redhat.com>,
        Kenneth Lee <nek.in.cn@gmail.com>,
        "Hao Fang" <fanghao11@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Kenneth Lee <liguoz
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>,
        "Tian, Kevin" <kevin.tian@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180802111000.4649d9ed@alans-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

On 2018/8/2 18:10, Alan Cox wrote:
>> One motivation I guess, is that most accelerators lack of a
>> well-abstracted high level APIs similar to GPU side (e.g. OpenCL
>> clearly defines Shared Virtual Memory models). VFIO mdev
>> might be an alternative common interface to enable SVA usages
>> on various accelerators...
> SVA is not IMHO the hard bit from a user level API perspective. The hard
> bit is describing what you have and enumerating the contents of the device
> especially when those can be quite dynamic and in the FPGA case can
> change on the fly.
>
> Right now we've got
> - FPGA manager
> - Google's recently posted ASIC patches
> - WarpDrive
>
> all trying to be bits of the same thing, and really there needs to be a
> single solution that handles all of this stuff properly.
>
> If we are going to have any kind of general purpose accelerator API then
> it has to be able to implement things like
>
> 	'find me an accelerator with function X that is nearest my memory'
> 	'find me accelerator functions X and Y that share HBM'
> 	'find me accelerator functions X and Y than can be chained'
>
> If instead we have three API's depending upon whose accelerator you are
> using and whether it's FPGA or ASIC this is going to be a mess on a grand
> scale.
>
Agree, at the beginning, we try to bring a notion of 'capability' which 
describes 'algorithms, mem access methods .etc ',
but then, we come to realize it is the first thing that we should come 
to a single solution on these things such as
memory/device access, IOMMU .etc.

Thanks,
Zaibo

>
> .
>
