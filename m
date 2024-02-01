Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD56EACC;
	Thu,  1 Feb 2024 01:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706752733; cv=none; b=c5OwqIx6MhlWyVdnCuHVPRFcOOf3i+arUTCNUQzaUTDjLY+MIObIka3fp2fVReg1+OnJgczzz8PaRsc9F7X+nBf8ujVVwwKrqDRdYZQ+YAI40CyThyFXtJsIfue3nB7ZQrm1/WoClhdiAdSRpsGNA0oVEcyaBg/FCYc5xoFl1PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706752733; c=relaxed/simple;
	bh=Xor6owu58Ln6T3Af5RESZax2j6h4UOSBR2UkbAZpWec=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=YdYyftGt9Hyv1IPUsDVrjdDZsYqE3IDB+4CguNW64LukF1xSLgH6WwYOxgGxiF9WRiw9MRd700UP1WOXQCbLHx4fMaPpAaKwckXMLBz5zXsFZI12eZ0c8BHmyF/X9EfvSll8OAHLTbAmhbvqaKUmrF7+j816YTGHHdFQsa3dnig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4TQMTh6yvDz29kq5;
	Thu,  1 Feb 2024 09:56:56 +0800 (CST)
Received: from dggpeml500001.china.huawei.com (unknown [7.185.36.227])
	by mail.maildlp.com (Postfix) with ESMTPS id F36961400D4;
	Thu,  1 Feb 2024 09:58:47 +0800 (CST)
Received: from [10.67.121.42] (10.67.121.42) by dggpeml500001.china.huawei.com
 (7.185.36.227) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 1 Feb
 2024 09:58:47 +0800
Message-ID: <667a313b-beae-4340-9173-82363c8e9aa8@huawei.com>
Date: Thu, 1 Feb 2024 09:58:47 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] some updates and cleanups for hisilicon/sec2.
From: taoqi <taoqi10@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<liulongfang@huawei.com>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
References: <20240126093828.14131-1-taoqi10@huawei.com>
In-Reply-To: <20240126093828.14131-1-taoqi10@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500001.china.huawei.com (7.185.36.227)

On 2024/1/26 17:38, Qi Tao wrote:
> This seires patch mainly add some RAS registers to enhance the
> DFX positioning function and fix some cleanup issues.
> 
> [PATCH v1 3/4] -> [PATCH v2 3/4]
> 	sec_sqe3->c_len_ivin |= cpu_to_le32(c_req->c_len);
> -	sec_sqe3->tag = cpu_to_le64((unsigned long)(uintptr_t)req);
> +	sec_sqe3->tag = cpu_to_le64((unsigned long)req);
> 
> Other patches are not modified.
> 
> Qi Tao (3):
>    crypto: hisilicon/sec2 - updates the sec DFX function register
>    crypto: hisilicon/sec2 - modify nested macro call
>    crypto: hisilicon/sec2 - fix some cleanup issues
> 
> Wenkai Lin (1):
>    crypto: hisilicon/sec - remove unused parameter
> 
>    drivers/crypto/hisilicon/sec2/sec_crypto.c | 33 ++++++++--------------
>    drivers/crypto/hisilicon/sec2/sec_main.c   |  5 ++++
>    2 files changed, 17 insertions(+), 21 deletions(-)
> 

The email is sent repeatedly. Please ignore other duplicate patches.

Thanks
taoqi
