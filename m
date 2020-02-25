Return-Path: <SRS0=ER22=4N=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A0D4C35DF5
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Feb 2020 09:13:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEA9021744
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Feb 2020 09:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729153AbgBYJNd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Feb 2020 04:13:33 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10687 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726916AbgBYJNd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Feb 2020 04:13:33 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 9490EC4477B67687CCAC;
        Tue, 25 Feb 2020 17:13:30 +0800 (CST)
Received: from [127.0.0.1] (10.67.101.242) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Tue, 25 Feb 2020
 17:13:19 +0800
Subject: Re: [PATCH] uacce: unmap remaining mmapping from user space
To:     zhangfei <zhangfei.gao@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <jonathan.cameron@huawei.com>, <dave.jiang@intel.com>,
        <grant.likely@arm.com>, jean-philippe <jean-philippe@linaro.org>,
        Jerome Glisse <jglisse@redhat.com>,
        <ilias.apalodimas@linaro.org>, <francois.ozog@linaro.org>,
        <kenneth-lee-2012@foxmail.com>, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        <guodong.xu@linaro.org>
References: <1582528016-2873-1-git-send-email-zhangfei.gao@linaro.org>
 <a4716453-0607-d613-e632-173d1ebc424e@huawei.com>
 <cf1f7ec2-7181-63fd-598d-b74d5a3efa15@linaro.org>
CC:     <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-accelerators@lists.ozlabs.org>,
        <linux-crypto@vger.kernel.org>
From:   Xu Zaibo <xuzaibo@huawei.com>
Message-ID: <844f8fc1-1c6c-0102-5412-df799cd327c5@huawei.com>
Date:   Tue, 25 Feb 2020 17:13:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <cf1f7ec2-7181-63fd-598d-b74d5a3efa15@linaro.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.101.242]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,
On 2020/2/25 16:33, zhangfei wrote:
> Hi, Zaibo
>
> On 2020/2/24 下午3:17, Xu Zaibo wrote:
>>>   @@ -585,6 +595,13 @@ void uacce_remove(struct uacce_device *uacce)
>>>           cdev_device_del(uacce->cdev, &uacce->dev);
>>>       xa_erase(&uacce_xa, uacce->dev_id);
>>>       put_device(&uacce->dev);
>>> +
>>> +    /*
>>> +     * unmap remainning mapping from user space, preventing user still
>>> +     * access the mmaped area while parent device is already removed
>>> +     */
>>> +    if (uacce->inode)
>>> +        unmap_mapping_range(uacce->inode->i_mapping, 0, 0, 1);
>> Should we unmap them at the first of 'uacce_remove',  and before 
>> 'uacce_put_queue'?
>>
> We can do this,
> Though it does not matter, since user space can not interrupt kernel 
> function uacce_remove.
>
I think it matters :)

Image that the process holds the uacce queue is running(read and write 
the queue), then you do 'uacce_remove'.
The process is running(read and write the queue) well in the time 
between 'uacce_put_queue' and
'unmap_mapping_range', however, the queue with its DMA memory may be 
gotten and used by
other guys in this time, since you have released them in kernel. As a 
result, the running process will be a disaster.

cheers,
Zaibo

.


> Thanks
> .
>


