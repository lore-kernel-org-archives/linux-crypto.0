Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51AB3B1AF;
	Fri, 25 Oct 2024 01:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729819502; cv=none; b=RfcpqwHAAsYIliD2N4BHDxEYCjA4OVwHTii3FQ+6KoI0iN3swgIgzKtMLKjSB/IzVi0BDIroY+YBbMA7ldSnd+5Fxqho7PjwwClVMBdkk3PKvIosqAO+xWoZRuASh68yO4VKS+9JY6zV2aDcXpbt1SMUirr461mRpALvfkJ/ukw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729819502; c=relaxed/simple;
	bh=R3yO1rRlWxgpc97VNo9W2eZ8nHpFCWZ3ltYyF4bF/yM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=TwHLOOHyCIlsHrzCX207zykW+YEC8+niXfTmsQqXf9vGu+stsOcn2KKfBIvu3bqMx8SCd/9mfIO/+szmNY33a+MTKzwJ0EEFJ9KbL9E4ELmMAug7A16EZJkP0fqcnATxlyTsXEJV2kmhv79VorbPlhLc+ZXMp+mQlffu3WxF2zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4XZQ2R2lF8z1HLDS;
	Fri, 25 Oct 2024 09:20:31 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (unknown [7.193.23.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 12142180043;
	Fri, 25 Oct 2024 09:24:54 +0800 (CST)
Received: from [10.174.176.245] (10.174.176.245) by
 kwepemm600001.china.huawei.com (7.193.23.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 25 Oct 2024 09:24:52 +0800
Message-ID: <1094e5d9-208c-4c41-83cd-5a77081aa5c1@huawei.com>
Date: Fri, 25 Oct 2024 09:24:52 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: qat - Fix missing destroy_workqueue in
 adf_init_aer()
To: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<ahsan.atta@intel.com>, <mun.chun.yep@intel.com>,
	<markas.rapoportas@intel.com>, <damian.muszynski@intel.com>,
	<furong.zhou@intel.com>, <adam.guerin@intel.com>, <zhangxiaoxu5@huawei.com>,
	<qat-linux@intel.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20241024140057.18548-1-wanghai38@huawei.com>
 <ZxpeVD/D9Y7sfL7H@gcabiddu-mobl.ger.corp.intel.com>
Content-Language: en-US
From: Wang Hai <wanghai38@huawei.com>
In-Reply-To: <ZxpeVD/D9Y7sfL7H@gcabiddu-mobl.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600001.china.huawei.com (7.193.23.3)



On 2024/10/24 23:04, Cabiddu, Giovanni wrote:
> On Thu, Oct 24, 2024 at 10:00:57PM +0800, Wang Hai wrote:
>> The adf_init_aer() won't destroy device_reset_wq when alloc_workqueue()
>> for device_sriov_wq failed. Add destroy_workqueue for device_reset_wq to
>> fix this issue.
>>
>> Fixes: 4469f9b23468 ("crypto: qat - re-enable sriov after pf reset")
>> Signed-off-by: Wang Hai <wanghai38@huawei.com>
>> ---
>>   drivers/crypto/intel/qat/qat_common/adf_aer.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
>> index ec7913ab00a2..907144ec7e65 100644
>> --- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
>> +++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
>> @@ -281,8 +281,10 @@ int adf_init_aer(void)
>>   		return -EFAULT;
>>   
>>   	device_sriov_wq = alloc_workqueue("qat_device_sriov_wq", 0, 0);
>> -	if (!device_sriov_wq)
>> +	if (!device_sriov_wq) {
>> +		destroy_workqueue(device_reset_wq);
> The missing destroy_workqueue() here is intentional as the device_reset_wq
> is destroyed in adf_exit_aer() which is called if adf_init_aer() fails,
> see [1].
> 
Hi, Giovanni.

Thanks for the review.

If adf_init_aer() fails, it will goto err_aer and then call
adf_exit_misc_wq() instead of goto err_pf_wq and then call
adf_exit_aer(). So this patch is needed.

static long adf_ctl_ioctl(struct file *fp, unsigned int cmd, unsigned 
long arg)
{
...
	if (adf_init_aer())
		goto err_aer;
...		
err_pf_wq:
	adf_exit_aer(); // will not be called when adf_init_aer() failed
err_aer:
	adf_exit_misc_wq();
err_misc_wq:
...
}
> With this change, destroy_workqueue() is called twice.
> 
> Regards,
> 

