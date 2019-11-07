Return-Path: <SRS0=gVpy=Y7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37807C5DF61
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Nov 2019 13:24:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F01402187F
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Nov 2019 13:24:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wS3cFYC3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388506AbfKGNYW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Nov 2019 08:24:22 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37083 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730980AbfKGNYW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Nov 2019 08:24:22 -0500
Received: by mail-pf1-f194.google.com with SMTP id p24so2705676pfn.4
        for <linux-crypto@vger.kernel.org>; Thu, 07 Nov 2019 05:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=abkWy+Oddv6Ij4UP5bVkGHy+5VTitE0a6BW1tGfeL4w=;
        b=wS3cFYC3VchQ+daBnwvoHKQ3kpjJ87fI/Gj4wRIdhbzdS6GLR9iEP6fh4owwt7U78L
         qvcajNr4YSCwoX4s8u7i3ezp98B7wzTv8Grig8cGiFgEqZfYauOc9Pqe7q8UPHG+B635
         CrwMVg5mqLS6cUVGYkLReMtq9oj+RnKHd0abmjGNqAnL3WPL+U94nlzNWfnCKYVhixx9
         VwYWi7TK7rmakwy/FHi7rOK1KL9mlCUU4lQ4qHnw/wu9UkEfUauEjt+GbbcDK7vSfyRe
         dWaOuyleLLY26hEZwM6eRsgySxgE0fcQ6FXL05R7OiGJP9xzawohFQqKELiPobwCwYC6
         OOfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=abkWy+Oddv6Ij4UP5bVkGHy+5VTitE0a6BW1tGfeL4w=;
        b=kOOLjzCPUr7mfXLs+Torv49RFcjyiqdWvnIt8ijaJMFJN9w84KFpYx7xOnoH536Gzx
         1rAN5RxKYvxHwEcy1hTeD7Z5XCOr6jkk3jUZLtIGesgzb55RWSVe0lRI+qYrww3ooG5M
         AOsRABkQ66qr57kNhe61KdVsmnDbejdb3RErtqUtzfO6p+wqiErcXMioOO2s6XfABfaU
         I9Yu47z6MpauiDGgapy8eumQH+IGq2YxWbhE1oC1eSu8vKVEtBcEf7IQzcDVoBKjcKGn
         cQtQ4H1NR4ToMlnna9a1N/LhQhTocG7VkPDw2f+grJeRFV/KCRCwN2H2XL6tE+wrfbFo
         GDpQ==
X-Gm-Message-State: APjAAAV6/L5cR2saACUbLaMCK1LVE4lrkWBgvXp+CCX3G3M8gv+Ht3+F
        C3uUm8jDV5gdz8Vtflpl7TSwWQ==
X-Google-Smtp-Source: APXvYqzNjvdYp9aTK9x1ERPxbkkcc4Ya8Rz4vq6p7QYJVZIQF1q3aoXDQDqXMkT48TNlbCxy4Jjp5Q==
X-Received: by 2002:a63:6744:: with SMTP id b65mr4447027pgc.13.1573133061336;
        Thu, 07 Nov 2019 05:24:21 -0800 (PST)
Received: from [192.168.11.202] (li1566-229.members.linode.com. [139.162.86.229])
        by smtp.gmail.com with ESMTPSA id z63sm2405155pgb.75.2019.11.07.05.24.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Nov 2019 05:24:20 -0800 (PST)
Subject: Re: [PATCH v7 2/3] uacce: add uacce driver
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        jonathan.cameron@huawei.com, grant.likely@arm.com,
        Jerome Glisse <jglisse@redhat.com>,
        ilias.apalodimas@linaro.org, francois.ozog@linaro.org,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        guodong.xu@linaro.org, linux-accelerators@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Zaibo Xu <xuzaibo@huawei.com>
References: <1572331216-9503-1-git-send-email-zhangfei.gao@linaro.org>
 <1572331216-9503-3-git-send-email-zhangfei.gao@linaro.org>
 <20191105114844.GA3648434@lophozonia>
 <24cbcd55-56d0-83b9-6284-04c29da11306@linaro.org>
 <20191106153246.GA3695715@lophozonia>
From:   zhangfei <zhangfei.gao@linaro.org>
Message-ID: <0cad8084-8ba8-03bd-7d29-cc7ba22c29ab@linaro.org>
Date:   Thu, 7 Nov 2019 21:23:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191106153246.GA3695715@lophozonia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2019/11/6 下午11:32, Jean-Philippe Brucker wrote:
> On Wed, Nov 06, 2019 at 04:17:40PM +0800, zhangfei wrote:
>>> But I still believe it would be better to create an uacce_mm structure
>>> that tracks all queues bound to this mm, and pass that to uacce_sva_exit
>>> instead of the uacce_device.
>> I am afraid this method may not work.
>> Since currently iommu_sva_bind_device only accept the same drvdata for the
>> same dev,
>> that's the reason we can not directly use "queue" as drvdata.
>> Each time create an uacce_mm structure should be same problem as queue, and
>> fail for same dev.
>> So we use uacce and pick up the right queue inside.
> What I had in mind is keep one uacce_mm per mm and per device, and we can
> pass that to iommu_sva_bind_device(). It requires some structure changes,
> see the attached patch.
Cool, thanks Jean
How about merge them together.
>
>>> The queue isn't bound to a task, but its address space. With clone() the
>>> address space can be shared between tasks. In addition, whoever has a
>>> queue fd also gets access to this address space. So after a fork() the
>>> child may be able to program the queue to DMA into the parent's address
>>> space, even without CLONE_VM. Users must be aware of this and I think it's
>>> important to explain it very clearly in the UAPI.
>>> [...]
>>>> +void uacce_unregister(struct uacce_device *uacce)
>>>> +{
>>>> +	if (!uacce)
>>>> +		return;
>>>> +
>>>> +	mutex_lock(&uacce->q_lock);
>>>> +	if (!list_empty(&uacce->qs)) {
>>>> +		struct uacce_queue *q;
>>>> +
>>>> +		list_for_each_entry(q, &uacce->qs, list) {
>>>> +			uacce_put_queue(q);
>>> The open file descriptor will still exist after this function returns.
>>> Can all fops can be called with a stale queue?
>> To more clear:.
>> Do you mean rmmod without fops_release.
> Yes I think so. What happens when userspace starts some queues, and
> the device driver suddenly calls uacce_unregister(). We call
> cdev_device_del() later in this function, but quoting the documentation:
> "any cdevs already open will remain and their fops will still be callable
> even after this function returns." So we need to make sure that any of the
> fops is safe to run after the uacce device disappears.
We can protect stale queue via q->state, since q is released later in 
fops_release.
And uacce_unregister: put_queue will set q->state = UACCE_Q_ZOMBIE.
Will add state check in mmap too.
>
> I noticed a lock dependency inversion on uacce->q_lock: uacce_unregister()
> calls iommu_sva_unbind_device() while holding the uacce->q_lock, but
> uacce_sva_exit() takes the uacce->q_lock with the SVA lock held. In theory
> we could simply avoid calling iommu_sva_unbind_device() here since it will
> be done by fops_release(), but then disabling the SVA feature in
> uacce_unregister() won't work (because there still are bonds). The
> attached patch should fix it, but I haven't tried running uacce_register()
> yet.
Have tested, it is OK.

Thanks

