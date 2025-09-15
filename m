Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AECA5204096;
	Mon, 15 Sep 2025 01:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757900936; cv=none; b=YbCLG3RMaTlGz7T+Y8Ai0mYdC/S6Q9WPufM/qOezDBqz7m2yPDnvOZnDzJyYcL3u5wU29FHLCWXhjgkpCn99iwV6o979BF8wXvuAGFRCiLRERpz/hOtktZmOU5djsuRzes/txsg54u2kFyf/d4gFfU8xpnY/4uJFcpu2WSIRfI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757900936; c=relaxed/simple;
	bh=M6XMTiV72nwBgNPoTmi+Vfsl2IrEiguTpqxMhrTkadQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=s6YPHdKQjq1HFNmJQ5HOEzNfpZ+IEwpZCiyRCINaiSTvyhUI1S6GysAekh9xKJ1roB30hDpCdfO+YyTDGrKOfYYfHVvcIGwtgj5zfYqoQk8NkM4Jd7CIuDb5oIzNMivb/Qjpzmh2SSZxSbgqvQXGFBml/LQWrxeMKrGQBJUrZyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cQ7CC5NM7z2VRhZ;
	Mon, 15 Sep 2025 09:45:27 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id A42E1140296;
	Mon, 15 Sep 2025 09:48:49 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 15 Sep 2025 09:48:49 +0800
Received: from [10.67.120.171] (10.67.120.171) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 15 Sep 2025 09:48:48 +0800
Message-ID: <a6be1e20-ed27-4883-8aaa-a49a2f5438a2@huawei.com>
Date: Mon, 15 Sep 2025 09:48:48 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] uacce: implement mremap in uacce_vm_ops to return
 -EPERM
To: Greg KH <gregkh@linuxfoundation.org>
CC: Zhangfei Gao <zhangfei.gao@linaro.org>, <wangzhou1@hisilicon.com>,
	<linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
	<linux-crypto@vger.kernel.org>, <fanghao11@huawei.com>,
	<shenyang39@huawei.com>, <qianweili@huawei.com>, <linwenkai6@hisilicon.com>,
	<liulongfang@huawei.com>
References: <20250822103904.3776304-1-huangchenghai2@huawei.com>
 <20250822103904.3776304-4-huangchenghai2@huawei.com>
 <2025082208-coauthor-pagan-e72c@gregkh>
 <CABQgh9GEZSasZq5bDthQrTZnJ_Uo8G-swDsrM_gWCecWbtTKgA@mail.gmail.com>
 <2025090608-afloat-grumbling-e729@gregkh>
 <868ceb0e-f4ba-4495-a1e1-0e387049281a@huawei.com>
 <2025091358-doornail-underpaid-35ca@gregkh>
From: huangchenghai <huangchenghai2@huawei.com>
Content-Language: en-US
In-Reply-To: <2025091358-doornail-underpaid-35ca@gregkh>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq200001.china.huawei.com (7.202.195.16)


On Sat, Sep 13, 2025 at 7:06 PM, Greg KH wrote:
> On Sat, Sep 13, 2025 at 06:40:23PM +0800, huangchenghai wrote:
>> On Sat, 6 Sept 2025 at 20:03, Greg KH wrote:
>>> On Thu, Aug 28, 2025 at 01:59:48PM +0800, Zhangfei Gao wrote:
>>>> Hi, Greg
>>>>
>>>> On Fri, 22 Aug 2025 at 19:46, Greg KH <gregkh@linuxfoundation.org> wrote:
>>>>> On Fri, Aug 22, 2025 at 06:39:03PM +0800, Chenghai Huang wrote:
>>>>>> From: Yang Shen <shenyang39@huawei.com>
>>>>>>
>>>>>> The current uacce_vm_ops does not support the mremap operation of
>>>>>> vm_operations_struct. Implement .mremap to return -EPERM to remind
>>>>>> users
>>>>> Why is this needed?  If mremap is not set, what is the value returned?
>>>> Did some debug locally.
>>>>
>>>> By default, mremap is permitted.
>>>>
>>>> With mremap, the original vma is released,
>>>> The vma_close is called and free resources, including q->qfr.
>>>>
>>>> However, vma->vm_private_data (q) is copied to the new vma.
>>>> When the new vma is closed, vma_close will get q and q->qft=0.
>>>>
>>>> So disable mremap here looks safer.
>>>>
>>>>> And why is -EPERM the correct value to return here?  That's not what the
>>>>> man pages say is valid :(
>>>> if disable mremap, -1 is returned as MAP_FAILED.
>>>> The errno is decided by the return value, -EPERM (-1) or -EINVAL (-22).
>>>> man mremap only lists -EINVAL.
>>>>
>>>> However, here the driver wants to disable mremap, looks -EPERM is more suitable.
>>> Disabling mremap is not a permission issue, it's more of an invalid
>>> call?  I don't know, what do other drivers do?
>>>
>>> thanks,
>>>
>>> greg k-h
>> Hi Greg,
>>
>> Thank you for your feedback.
>>
>> The reason we need to explicitly disable mremap is that when the
>> driver does not implement .mremap, it uses the default mremap
>> method. This could lead to a risk scenario:
>>
>> An application might first mmap address p1, then mremap to p2,
>> followed by munmap(p1), and finally munmap(p2). Since the default
>> mremap copies the original vma's vm_private_data (i.e., q) to the
>> new vma, both munmap operations would trigger vma_close, causing
>> q->qfr to be freed twice(qfr will be set to null here, so repeated release
>> is ok).
> Great, can you please include that in the changelog text?
>
> thanks,
>
> greg k-h
Sure, I will add changelog in the v2 patch lately.

Thanks,
ChengHai
