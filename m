Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287A3236ED6;
	Tue, 14 Jan 2025 12:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736857342; cv=none; b=opDZvl5vADWjCSwb5QWyJew6XNJhb5mzssLe3fuwpapk8el9jDr4rDx5Pr683kA8qqQ5cgm+cl+o/jHHoZBxGEJSiP5nslxlxjYVLeExWrk4EDgaaVWsgC63GqVXQWsMF/jKCS5/tCFjT1dtGrZJPlATN6nHB1gGeGjDAy1ASm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736857342; c=relaxed/simple;
	bh=Cu1/Ka79Y5eHcbzWkfiQUFKxz09A1hC/IsJ/ycYNC+0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Rln4yaBQgmbmzkCuA/5oeNOKcj2RtyyEdTmvTVFd7/YXIAN5l1Rb+a0ZW0HqaaSy56J98INeCEzAwvqQpEm7Ub7EjceFRwnQl29Nq44CxcT4X3pyDhYbttwASIzef9qxDtCBGA2TZpS2h8cKMOo/vcBEENagfNec4mmRk1oVTNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4YXSpx6zkfz1kyQk;
	Tue, 14 Jan 2025 20:19:05 +0800 (CST)
Received: from kwepemd100013.china.huawei.com (unknown [7.221.188.163])
	by mail.maildlp.com (Postfix) with ESMTPS id E1CC81402CE;
	Tue, 14 Jan 2025 20:22:14 +0800 (CST)
Received: from [10.67.109.79] (10.67.109.79) by kwepemd100013.china.huawei.com
 (7.221.188.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.34; Tue, 14 Jan
 2025 20:22:14 +0800
Message-ID: <7b912100-3504-4d9d-a94a-d45f98aee00c@huawei.com>
Date: Tue, 14 Jan 2025 20:22:13 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] padata: avoid UAF for reorder_work
To: Daniel Jordan <daniel.m.jordan@oracle.com>, Chen Ridong
	<chenridong@huaweicloud.com>
CC: <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>,
	<nstange@suse.de>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <wangweiyang2@huawei.com>
References: <20250110061639.1280907-1-chenridong@huaweicloud.com>
 <20250110061639.1280907-4-chenridong@huaweicloud.com>
 <vub7syv7k5t44snkkkdrqsco6jlw6bfen5xbbvyz5wothfjfv5@n3w3gdqjrx2p>
Content-Language: en-US
From: chenridong <chenridong@huawei.com>
In-Reply-To: <vub7syv7k5t44snkkkdrqsco6jlw6bfen5xbbvyz5wothfjfv5@n3w3gdqjrx2p>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemd100013.china.huawei.com (7.221.188.163)



On 2025/1/14 1:00, Daniel Jordan wrote:
> On Fri, Jan 10, 2025 at 06:16:39AM +0000, Chen Ridong wrote:
> ...
>> Fixes: bbefa1dd6a6d ("crypto: pcrypt - Avoid deadlock by using per-instance padata queues")
>> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> 
> Series looks good, thanks for the persistence.
> 

Thank you for your patience.

Best regards,
Ridong
> Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
> 
>> diff --git a/kernel/padata.c b/kernel/padata.c
> ...
>>  static void invoke_padata_reorder(struct work_struct *work)
>> @@ -364,6 +370,8 @@ static void invoke_padata_reorder(struct work_struct *work)
>>  	pd = container_of(work, struct parallel_data, reorder_work);
>>  	padata_reorder(pd);
>>  	local_bh_enable();
>> +	/* Pairs with putting the reorder_work in the serial_wq */
> 
> s/putting/getting/
> 
