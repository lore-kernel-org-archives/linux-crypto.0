Return-Path: <SRS0=KDyu=3C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CEDDC32771
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jan 2020 03:35:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D302206D6
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jan 2020 03:35:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="k+FPJXn+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733148AbgAMDfV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 12 Jan 2020 22:35:21 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43898 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733020AbgAMDfV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 Jan 2020 22:35:21 -0500
Received: by mail-pg1-f196.google.com with SMTP id k197so4014479pga.10
        for <linux-crypto@vger.kernel.org>; Sun, 12 Jan 2020 19:35:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=xFqcxE7gzA9H12FKOdbMb//B/oYmfZK/RzAcHl+CnTs=;
        b=k+FPJXn+qDrc8Rv9GkbgTYmLV+c06ODhfg3UhsWFDxASC2rDKBsa5hPArKfSnHOiHf
         SiqlCOxOzq9cRabPerK7MdccjmcZQQqUHr2ENSp13QJ2VYuqA+dCtQri/vOUCtYve+4N
         AdsmmYGs2PctIv6buQ3S2tTWv/krI5/wFhyhKQd/xrBZSxjlsdI+/ZM9XoGe9y/wdc45
         WdtqH8HGpuq7/0MpnZxHh1QWEUyQ9CK5sCVbvZvGRdDEy1YF8XxySFRhTKPlbKh4FMzg
         qTb2Q7X//1CY+5EHEEXdNPyHCSpbf6OEWnK25vSgDkemlto12Le5Ftx4cxIgFJpTfKJo
         +qrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=xFqcxE7gzA9H12FKOdbMb//B/oYmfZK/RzAcHl+CnTs=;
        b=XSPvh/GQx7JeyqAswBTZZJA28jwbAF3cytsTLy0gUzqsQDj2m4SPi89xHciXP8QvGI
         n4/xw2V/BAdLO7S/LewBn4NbheIAq12AYjRdBW3OmSWoMBrjI99t5/0N5aYD0zUNsAGJ
         V7kq/xtXP2S7YEnGBRFxg2guxIQaFqK9iWM/JWK8Mvfz2NrUMIJA2cVpEsys0r1roNKJ
         mz0zmUNh4rh8sZ5nZomcQ28hi9SbRPhTkAjFkqFs2NyNfE+gQhTzHiyDGCvYVZzRrm0R
         e2RBUcupiL2tWvA6wEP9CDKIq+T/OWHwpM723cq8YuZzXeiwRPWBvziYCPqkpO/qKYjU
         n6OQ==
X-Gm-Message-State: APjAAAWZO3LOR4PtaAD3tAN5S5Q7SjJxff+qYTVdb33+L5N1IjCPh/i6
        NDsgB9osTNu9gKLZV/yMAxpJtA==
X-Google-Smtp-Source: APXvYqyqrcJ6o1XIvrpDQ5dkfiQ1M/tSGBDgRllqQQCfDUJXDziAz94M3vBA0n9IcAGZZQJU78RI2A==
X-Received: by 2002:aa7:982d:: with SMTP id q13mr17816648pfl.152.1578886521046;
        Sun, 12 Jan 2020 19:35:21 -0800 (PST)
Received: from ?IPv6:240e:362:498:8200:f030:f64d:8b7a:5e5a? ([240e:362:498:8200:f030:f64d:8b7a:5e5a])
        by smtp.gmail.com with ESMTPSA id i23sm11662197pfo.11.2020.01.12.19.35.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 12 Jan 2020 19:35:20 -0800 (PST)
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
From:   zhangfei <zhangfei.gao@linaro.org>
Message-ID: <053ccd05-4f11-5be6-47c2-eee5c2f1fdc4@linaro.org>
Date:   Mon, 13 Jan 2020 11:34:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200111194006.GD435222@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi, Greg

Thanks for the review.

On 2020/1/12 上午3:40, Greg Kroah-Hartman wrote:
> On Sat, Jan 11, 2020 at 10:48:37AM +0800, Zhangfei Gao wrote:
>> +static int uacce_fops_open(struct inode *inode, struct file *filep)
>> +{
>> +	struct uacce_mm *uacce_mm = NULL;
>> +	struct uacce_device *uacce;
>> +	struct uacce_queue *q;
>> +	int ret = 0;
>> +
>> +	uacce = xa_load(&uacce_xa, iminor(inode));
>> +	if (!uacce)
>> +		return -ENODEV;
>> +
>> +	if (!try_module_get(uacce->parent->driver->owner))
>> +		return -ENODEV;
> Why are you trying to grab the module reference of the parent device?
> Why is that needed and what is that going to help with here?
>
> This shouldn't be needed as the module reference of the owner of the
> fileops for this module is incremented, and the "parent" module depends
> on this module, so how could it be unloaded without this code being
> unloaded?
>
> Yes, if you build this code into the kernel and the "parent" driver is a
> module, then you will not have a reference, but when you remove that
> parent driver the device will be removed as it has to be unregistered
> before that parent driver can be removed from the system, right?
>
> Or what am I missing here?
The refcount here is preventing rmmod "parent" module after fd is opened,
since user driver has mmap kernel memory to user space, like mmio, which 
may still in-use.

With the refcount protection, rmmod "parent" module will fail until 
application free the fd.
log like: rmmod: ERROR: Module hisi_zip is in use
>
>> +static void uacce_release(struct device *dev)
>> +{
>> +	struct uacce_device *uacce = to_uacce_device(dev);
>> +
>> +	kfree(uacce);
>> +	uacce = NULL;
> That line didn't do anything :)
Yes, this is a mistake.
It is up to caller to set to NULL to prevent release multi times.

Thanks
