Return-Path: <SRS0=cdcO=3E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70E04C33CB1
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Jan 2020 11:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 422762187F
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Jan 2020 11:18:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="g3Mcxwnk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729747AbgAOLS6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Jan 2020 06:18:58 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42892 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgAOLS6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Jan 2020 06:18:58 -0500
Received: by mail-pf1-f194.google.com with SMTP id 4so8386885pfz.9
        for <linux-crypto@vger.kernel.org>; Wed, 15 Jan 2020 03:18:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=fXqQU6rEG13cTg0zIPcmRK0xunIDxm/XK6227+s03nA=;
        b=g3McxwnkUANkgahUsKI7co1RacshzyopeqJjkhK09l59YJUmMmGMx6/LWt3mOzcUO4
         mw3t0NReHqJDSWcyPsbwbwjtA/tAjeFFeJpb5e+QJhaHuJT5ZiyiiXzqpZqrkwE0EL2T
         CSSa/Eeg+ZCYGW7arDj+xGWsXc3E+2liHsByajZb2107lndiT4wwOi127YPB8mAOWCwI
         JYHw14WoDEFoeNk9yxP1XtMEoYfEeGkkAI4nxW6PWcWzKHPBeiIyNOTNs1Jlcrwf9YyM
         3v6UdXIs9DS4zqOWlKHOXCyhk5UflqruxB1yYtWiIFvxWMnGWsJHhnlEkD8+goIpAzad
         OQgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=fXqQU6rEG13cTg0zIPcmRK0xunIDxm/XK6227+s03nA=;
        b=Rq+KpvoNfyGWvcfeK9GhXygm2GDSqrA5JNLHvKXA0LshAI2t7326DV0w0YgBaRfvfU
         s8Qavy2pPz5zyzQBb7Fm8f9RnP/jFNOA5umz5teBgjqB0PvoG78WNMWwGhbNxpCit2TU
         JZ+Hn8q++8Y5KgtImGdJtHxYBaEwtfweGs7GlvJP+1rEyO6qRY/CBSpN4IldRXXufCeR
         kvL2mfJZtsWyndYccFevL+Z9O6MqT2WWl3f4KAyugZ5IZCnlCg28mpCRPY0hoFanFpb/
         +EViYXX62ApkXLwMbz3dRtiNJPaQySCRdSxZXx3GKahhwD4ndf6vhuJ1K3CLGsY3g2GV
         G/nw==
X-Gm-Message-State: APjAAAXSsHM76iP60IcoefGgOz6QV/sKA7VT66V0Oo/gG8SuU4B1ldx6
        D+NwdT/nZAlzpl9FMVTbEt+RWA==
X-Google-Smtp-Source: APXvYqwzl+XFVZuDlxHINgXocwnPKmenS6n4tYr3MFMQB417i0lAf852X/6hrV3aU+jpJeUh7Th2Fw==
X-Received: by 2002:a63:3409:: with SMTP id b9mr32626131pga.320.1579087137475;
        Wed, 15 Jan 2020 03:18:57 -0800 (PST)
Received: from [10.79.0.170] ([45.135.186.87])
        by smtp.gmail.com with ESMTPSA id a28sm21582026pfh.119.2020.01.15.03.18.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Jan 2020 03:18:56 -0800 (PST)
Subject: Re: [PATCH v11 2/4] uacce: add uacce driver
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        jonathan.cameron@huawei.com, dave.jiang@intel.com,
        grant.likely@arm.com, jean-philippe <jean-philippe@linaro.org>,
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
From:   zhangfei <zhangfei.gao@linaro.org>
Message-ID: <c71b402c-a185-50a7-2827-c1836cc6c237@linaro.org>
Date:   Wed, 15 Jan 2020 19:18:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200114145934.GA1960403@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi, Greg

On 2020/1/14 下午10:59, Greg Kroah-Hartman wrote:
> On Mon, Jan 13, 2020 at 11:34:55AM +0800, zhangfei wrote:
>> Hi, Greg
>>
>> Thanks for the review.
>>
>> On 2020/1/12 上午3:40, Greg Kroah-Hartman wrote:
>>> On Sat, Jan 11, 2020 at 10:48:37AM +0800, Zhangfei Gao wrote:
>>>> +static int uacce_fops_open(struct inode *inode, struct file *filep)
>>>> +{
>>>> +	struct uacce_mm *uacce_mm = NULL;
>>>> +	struct uacce_device *uacce;
>>>> +	struct uacce_queue *q;
>>>> +	int ret = 0;
>>>> +
>>>> +	uacce = xa_load(&uacce_xa, iminor(inode));
>>>> +	if (!uacce)
>>>> +		return -ENODEV;
>>>> +
>>>> +	if (!try_module_get(uacce->parent->driver->owner))
>>>> +		return -ENODEV;
>>> Why are you trying to grab the module reference of the parent device?
>>> Why is that needed and what is that going to help with here?
>>>
>>> This shouldn't be needed as the module reference of the owner of the
>>> fileops for this module is incremented, and the "parent" module depends
>>> on this module, so how could it be unloaded without this code being
>>> unloaded?
>>>
>>> Yes, if you build this code into the kernel and the "parent" driver is a
>>> module, then you will not have a reference, but when you remove that
>>> parent driver the device will be removed as it has to be unregistered
>>> before that parent driver can be removed from the system, right?
>>>
>>> Or what am I missing here?
>> The refcount here is preventing rmmod "parent" module after fd is opened,
>> since user driver has mmap kernel memory to user space, like mmio, which may
>> still in-use.
>>
>> With the refcount protection, rmmod "parent" module will fail until
>> application free the fd.
>> log like: rmmod: ERROR: Module hisi_zip is in use
> But if the "parent" module is to be unloaded, it has to unregister the
> "child" device and that will call the destructor in here and then you
> will tear everything down and all should be good.
>
> There's no need to "forbid" a module from being unloaded, even if it is
> being used.  Look at all networking drivers, they work that way, right?
Thanks Greg for the kind suggestion.

I still have one uncertainty.
Does uacce has to block process continue accessing the mmapped area when 
remove "parent" module?
Uacce can block device access the physical memory when parent module 
call uacce_remove.
But application is still running, and suppose it is not the kernel 
driver's responsibility to call unmap.

I am looking for some examples in kernel,
looks vfio does not block process continue accessing when 
vfio_unregister_iommu_driver either.

In my test, application will keep waiting after rmmod parent, until 
ctrl+c, when unmap is called.
During the process, kernel does not report any error.

Do you have any advice?

>>>> +static void uacce_release(struct device *dev)
>>>> +{
>>>> +	struct uacce_device *uacce = to_uacce_device(dev);
>>>> +
>>>> +	kfree(uacce);
>>>> +	uacce = NULL;
>>> That line didn't do anything :)
>> Yes, this is a mistake.
>> It is up to caller to set to NULL to prevent release multi times.
> Release function is called by the driver core which will not touch the
> value again.
Yes, I understand, it's my mistake. Will remove it.

Thanks
