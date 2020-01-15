Return-Path: <SRS0=cdcO=3E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52D3EC32771
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Jan 2020 16:43:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FDC22187F
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Jan 2020 16:43:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgAOQnp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Jan 2020 11:43:45 -0500
Received: from mga05.intel.com ([192.55.52.43]:59258 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbgAOQnp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Jan 2020 11:43:45 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jan 2020 08:43:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,323,1574150400"; 
   d="scan'208";a="226170948"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga006.jf.intel.com with ESMTP; 15 Jan 2020 08:43:42 -0800
Subject: Re: [PATCH v11 2/4] uacce: add uacce driver
To:     zhangfei <zhangfei.gao@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        jonathan.cameron@huawei.com, grant.likely@arm.com,
        jean-philippe <jean-philippe@linaro.org>,
        Jerome Glisse <jglisse@redhat.com>,
        ilias.apalodimas@linaro.org, francois.ozog@linaro.org,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        guodong.xu@linaro.org, linux-accelerators@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Zaibo Xu <xuzaibo@huawei.com>
References: <1578710919-12141-1-git-send-email-zhangfei.gao@linaro.org>
 <1578710919-12141-3-git-send-email-zhangfei.gao@linaro.org>
 <20200111194006.GD435222@kroah.com>
 <053ccd05-4f11-5be6-47c2-eee5c2f1fdc4@linaro.org>
 <20200114145934.GA1960403@kroah.com>
 <c71b402c-a185-50a7-2827-c1836cc6c237@linaro.org>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <9454d674-85db-32ba-4f28-eb732777d59d@intel.com>
Date:   Wed, 15 Jan 2020 09:43:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <c71b402c-a185-50a7-2827-c1836cc6c237@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 1/15/20 4:18 AM, zhangfei wrote:
> Hi, Greg
> 
> On 2020/1/14 下午10:59, Greg Kroah-Hartman wrote:
>> On Mon, Jan 13, 2020 at 11:34:55AM +0800, zhangfei wrote:
>>> Hi, Greg
>>>
>>> Thanks for the review.
>>>
>>> On 2020/1/12 上午3:40, Greg Kroah-Hartman wrote:
>>>> On Sat, Jan 11, 2020 at 10:48:37AM +0800, Zhangfei Gao wrote:
>>>>> +static int uacce_fops_open(struct inode *inode, struct file *filep)
>>>>> +{
>>>>> +    struct uacce_mm *uacce_mm = NULL;
>>>>> +    struct uacce_device *uacce;
>>>>> +    struct uacce_queue *q;
>>>>> +    int ret = 0;
>>>>> +
>>>>> +    uacce = xa_load(&uacce_xa, iminor(inode));
>>>>> +    if (!uacce)
>>>>> +        return -ENODEV;
>>>>> +
>>>>> +    if (!try_module_get(uacce->parent->driver->owner))
>>>>> +        return -ENODEV;
>>>> Why are you trying to grab the module reference of the parent device?
>>>> Why is that needed and what is that going to help with here?
>>>>
>>>> This shouldn't be needed as the module reference of the owner of the
>>>> fileops for this module is incremented, and the "parent" module depends
>>>> on this module, so how could it be unloaded without this code being
>>>> unloaded?
>>>>
>>>> Yes, if you build this code into the kernel and the "parent" driver 
>>>> is a
>>>> module, then you will not have a reference, but when you remove that
>>>> parent driver the device will be removed as it has to be unregistered
>>>> before that parent driver can be removed from the system, right?
>>>>
>>>> Or what am I missing here?
>>> The refcount here is preventing rmmod "parent" module after fd is 
>>> opened,
>>> since user driver has mmap kernel memory to user space, like mmio, 
>>> which may
>>> still in-use.
>>>
>>> With the refcount protection, rmmod "parent" module will fail until
>>> application free the fd.
>>> log like: rmmod: ERROR: Module hisi_zip is in use
>> But if the "parent" module is to be unloaded, it has to unregister the
>> "child" device and that will call the destructor in here and then you
>> will tear everything down and all should be good.
>>
>> There's no need to "forbid" a module from being unloaded, even if it is
>> being used.  Look at all networking drivers, they work that way, right?
> Thanks Greg for the kind suggestion.
> 
> I still have one uncertainty.
> Does uacce has to block process continue accessing the mmapped area when 
> remove "parent" module?
> Uacce can block device access the physical memory when parent module 
> call uacce_remove.
> But application is still running, and suppose it is not the kernel 
> driver's responsibility to call unmap.
> 
> I am looking for some examples in kernel,
> looks vfio does not block process continue accessing when 
> vfio_unregister_iommu_driver either.
> 
> In my test, application will keep waiting after rmmod parent, until 
> ctrl+c, when unmap is called.
> During the process, kernel does not report any error.
> 
> Do you have any advice?

Would it work to call unmap_mapping_range() on the char dev 
inode->i_mappings? I think you need to set the vma->fault function ptr 
for the vm_operations_struct in the original mmap(). After the mappings 
are unmapped, you can set a state variable to trigger the return of 
VM_FAULT_SIGBUS in the ->fault function when the user app accesses the 
mmap region again and triggers a page fault. The user app needs to be 
programmed to catch exceptions to deal with that.

> 
>>>>> +static void uacce_release(struct device *dev)
>>>>> +{
>>>>> +    struct uacce_device *uacce = to_uacce_device(dev);
>>>>> +
>>>>> +    kfree(uacce);
>>>>> +    uacce = NULL;
>>>> That line didn't do anything :)
>>> Yes, this is a mistake.
>>> It is up to caller to set to NULL to prevent release multi times.
>> Release function is called by the driver core which will not touch the
>> value again.
> Yes, I understand, it's my mistake. Will remove it.
> 
> Thanks
