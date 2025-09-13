Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE0318E25;
	Sat, 13 Sep 2025 10:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757760031; cv=none; b=Av3KyJ5kjXJxuGlU0ySC6HAbg/jHnzB2bhvpgKwpZ9zHM+Mee+t4zk45azWDLe0nY8aAU9NMm9egkDEpcdM1psRLF7Q/YWkngqqFpKxYFzAQN9FjCiFqsWFV0mKm4KGFg6C9ZGsmRkyhTK5ZWrlRiVcpI+oI21JGlWDL+dmof1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757760031; c=relaxed/simple;
	bh=UMCdlUdE4CgcOXDd6+wHo8Ks8fxQLTZteOew0yo/mBU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=IPxHqZXKiNmgGGLk0i4bZ99G9mP4WfBQP0dVxk9DCA0MgCdaA9QnT25XfbnrJcFTyVbnrRofIylzBzUUTVMUiONdALizskHJ2otpIlU1BRQIfPaVKjXbF+UMu7788Tw4HHBIVLDh0Pmja2XNPPwjWRJxSVStl5unuO7qGRCyvh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4cP7470bhczdcHw;
	Sat, 13 Sep 2025 18:35:51 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id E192618048E;
	Sat, 13 Sep 2025 18:40:24 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 13 Sep 2025 18:40:24 +0800
Received: from [10.67.120.171] (10.67.120.171) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 13 Sep 2025 18:40:23 +0800
Message-ID: <868ceb0e-f4ba-4495-a1e1-0e387049281a@huawei.com>
Date: Sat, 13 Sep 2025 18:40:23 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] uacce: implement mremap in uacce_vm_ops to return
 -EPERM
To: Greg KH <gregkh@linuxfoundation.org>, Zhangfei Gao
	<zhangfei.gao@linaro.org>
CC: <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <shenyang39@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <liulongfang@huawei.com>
References: <20250822103904.3776304-1-huangchenghai2@huawei.com>
 <20250822103904.3776304-4-huangchenghai2@huawei.com>
 <2025082208-coauthor-pagan-e72c@gregkh>
 <CABQgh9GEZSasZq5bDthQrTZnJ_Uo8G-swDsrM_gWCecWbtTKgA@mail.gmail.com>
 <2025090608-afloat-grumbling-e729@gregkh>
From: huangchenghai <huangchenghai2@huawei.com>
In-Reply-To: <2025090608-afloat-grumbling-e729@gregkh>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq200001.china.huawei.com (7.202.195.16)


On Sat, 6 Sept 2025 at 20:03, Greg KH wrote:
> On Thu, Aug 28, 2025 at 01:59:48PM +0800, Zhangfei Gao wrote:
>> Hi, Greg
>>
>> On Fri, 22 Aug 2025 at 19:46, Greg KH <gregkh@linuxfoundation.org> wrote:
>>> On Fri, Aug 22, 2025 at 06:39:03PM +0800, Chenghai Huang wrote:
>>>> From: Yang Shen <shenyang39@huawei.com>
>>>>
>>>> The current uacce_vm_ops does not support the mremap operation of
>>>> vm_operations_struct. Implement .mremap to return -EPERM to remind
>>>> users
>>> Why is this needed?  If mremap is not set, what is the value returned?
>> Did some debug locally.
>>
>> By default, mremap is permitted.
>>
>> With mremap, the original vma is released,
>> The vma_close is called and free resources, including q->qfr.
>>
>> However, vma->vm_private_data (q) is copied to the new vma.
>> When the new vma is closed, vma_close will get q and q->qft=0.
>>
>> So disable mremap here looks safer.
>>
>>> And why is -EPERM the correct value to return here?  That's not what the
>>> man pages say is valid :(
>> if disable mremap, -1 is returned as MAP_FAILED.
>> The errno is decided by the return value, -EPERM (-1) or -EINVAL (-22).
>> man mremap only lists -EINVAL.
>>
>> However, here the driver wants to disable mremap, looks -EPERM is more suitable.
> Disabling mremap is not a permission issue, it's more of an invalid
> call?  I don't know, what do other drivers do?
>
> thanks,
>
> greg k-h
Hi Greg,

Thank you for your feedback.

The reason we need to explicitly disable mremap is that when the
driver does not implement .mremap, it uses the default mremap
method. This could lead to a risk scenario:

An application might first mmap address p1, then mremap to p2,
followed by munmap(p1), and finally munmap(p2). Since the default
mremap copies the original vma's vm_private_data (i.e., q) to the
new vma, both munmap operations would trigger vma_close, causing
q->qfr to be freed twice(qfr will be set to null here, so repeated 
release is ok).

Regards,
ChengHai
