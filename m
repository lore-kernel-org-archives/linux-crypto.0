Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6091815B111;
	Mon, 19 Aug 2024 12:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724070088; cv=none; b=ToKjm98tVuQwXh60lFWUxsT5XR7ZfuG996Lk2SpkwoQ8cHkd2faSt0Ob0jLwDHcqnI2niGbvvch4LsAK6nOE3JAdvStIM0reCIUyKfHppSY6lRl4x22++U4M+Rj4Ne1AHTrNoSEs/JR8IzLM0fx7PL5EplnhKEHNCGWZutLhYUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724070088; c=relaxed/simple;
	bh=CwDadtLSK4MHhxA4C0bap9jx6VN/xQZEC5yBdNE2uOs=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=VPyGBxGqtNvrsgKsEisYx9YKIS0aBneFusAJaHcayDhCtAOamUe85AC21eHC7iblnNbikP5H9sTDep2/OuXLDEPNGO/cwaXEY3PdSDBR5pIvZuMuXfCRz6CHLhPt7svrRCRs+7jnTO7QYPeci0n8ELuloO4C9/06zS/x6a867M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WnWsV1JngzyR3K;
	Mon, 19 Aug 2024 20:21:02 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id AD211180064;
	Mon, 19 Aug 2024 20:21:22 +0800 (CST)
Received: from [10.67.108.52] (10.67.108.52) by dggpemm500020.china.huawei.com
 (7.185.36.49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 19 Aug
 2024 20:21:22 +0800
Message-ID: <63efd8d1-e294-42f0-8b0f-ec0ceb793772@huawei.com>
Date: Mon, 19 Aug 2024 20:21:22 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] crypto: keembay - fix module autoloading
Content-Language: en-US
From: "liaochen (A)" <liaochen4@huawei.com>
To: <linux-crypto@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <declan.murphy@intel.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
References: <20240814024406.3875287-1-liaochen4@huawei.com>
In-Reply-To: <20240814024406.3875287-1-liaochen4@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500020.china.huawei.com (7.185.36.49)

On 2024/8/14 10:44, Liao Chen wrote:
> Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded
> based on the alias from of_device_id table.
> 
> Signed-off-by: Liao Chen <liaochen4@huawei.com>
> ---
>   drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
> index c2dfca73fe4e..e54c79890d44 100644
> --- a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
> +++ b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
> @@ -1150,6 +1150,7 @@ static const struct of_device_id kmb_ocs_hcu_of_match[] = {
>   	},
>   	{}
>   };
> +MODULE_DEVICE_TABLE(of, kmb_ocs_hcu_of_match);
>   
>   static void kmb_ocs_hcu_remove(struct platform_device *pdev)
>   {
Gentle ping

Thanks,
Chen
