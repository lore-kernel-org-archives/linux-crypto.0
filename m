Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8EC170A30;
	Fri, 29 Nov 2024 08:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732867243; cv=none; b=HQnLLIefqP975ESam2wEPjZLkXQGX6s2d7H0KC5ylQJs12bBKJrqz8iEjDpm60m3gPBTLU45udSQPA2X2yZTANHV1pTpcDTyCxbR+nrdQ6M9xNxjh2h2QCV89hFhUSC/zQ1nJm01InazCobM/lpL80T5hvHEmDWoe5umKbrCaLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732867243; c=relaxed/simple;
	bh=IlTsVjzTIrahARgtfXZv5o/31pQs3csHSvihWW86J7c=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=l2mj6aJE0JLyPyyketjMOt0qMzUuN8n13MZWNNmQlqsDWHFqII9SbEwoHvcA6WBKCkjQp3wPV8kkYmBNI9R2NPA93nST6YzTcd4TgM5mgVcw97pVadCADZeJ30jfNshRG4zsi3ICscZu7g/8W53jNZfinw7+ZzHF1jrJKFI9zOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Y05CL0SZzz1k0VP;
	Fri, 29 Nov 2024 15:58:22 +0800 (CST)
Received: from kwepemd100013.china.huawei.com (unknown [7.221.188.163])
	by mail.maildlp.com (Postfix) with ESMTPS id 35DD6180041;
	Fri, 29 Nov 2024 16:00:32 +0800 (CST)
Received: from [10.67.109.79] (10.67.109.79) by kwepemd100013.china.huawei.com
 (7.221.188.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.34; Fri, 29 Nov
 2024 16:00:31 +0800
Message-ID: <54e1d22f-04cd-41fc-aeca-4ec09d446b96@huawei.com>
Date: Fri, 29 Nov 2024 16:00:30 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] padata: add pd get/put refcnt helper
To: Chen Ridong <chenridong@huaweicloud.com>, <steffen.klassert@secunet.com>,
	<daniel.m.jordan@oracle.com>, <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<wangweiyang2@huawei.com>
References: <20241123080509.2573987-1-chenridong@huaweicloud.com>
 <20241123080509.2573987-2-chenridong@huaweicloud.com>
Content-Language: en-US
From: chenridong <chenridong@huawei.com>
In-Reply-To: <20241123080509.2573987-2-chenridong@huaweicloud.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemd100013.china.huawei.com (7.221.188.163)



On 2024/11/23 16:05, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> Add helpers for pd to get/put refcnt to make code consice.
> 
> Signed-off-by: Chen Ridong <chenridong@huawei.com>

Friendly ping.

I am looking forward to someone reviewing these patches, and if there
are any opinions, I will update the patch, as well as fixing the compile
warnings.

Thanks,
Ridong
