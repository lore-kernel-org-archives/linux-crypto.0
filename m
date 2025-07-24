Received: from mx07-00178001.pphosted.com (mx07-00178001.pphosted.com [185.132.182.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9564248869;
	Thu, 24 Jul 2025 12:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.132.182.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753358959; cv=none; b=qfsQR3GsI9yqS32oznNAifdszFC3PA6xdWIl1w+VB15U6VVisF/9kE1/hrzCslrDb0qwbP3eYAj2ByPLfwkx73/IsrLh2Qd1iYOwSbPf4DOY1OUxS4RW+vG71OwPvo2Qfndgq1HiVVIebf03+adJ+TNlp7Iezd8YrPYzNZCmqjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753358959; c=relaxed/simple;
	bh=xmZ07XI9r/Uh+O5y9f8xrftA4OuFq+r8O4rn20bpwC4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=YszLVl1lJ4/HwB6c1H2pJpt0B533nNy8GQ4e+BLxEK1FofSZWH/jfFfJ3CcI3JTsSyg9REhhYQ6iBwgvZydVRUKghk8RBNKVFmGbjWMv9nekZVKQs+QCY2H1078bvm0KGBK4K/24aE6Hcr0ytb853v0XBAFK9kl0W20FITxbgQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=0tZ/WVhY; arc=none smtp.client-ip=185.132.182.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="0tZ/WVhY"
Received: from pps.filterd (m0241204.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56OBrGXN014397;
	Thu, 24 Jul 2025 14:08:59 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	3RnDGhuhVntOp6Bg9NBCgGc0N9Ug1qhTvHYB+v00dW0=; b=0tZ/WVhYUJ/aOg/R
	scH3RUnxsqa9j+TqXSLg0ad6+qeu5Yqpc/MO5HTw5hmwdUFL1QzorTPoLIP7+UYA
	9wYcFoLw5Yy0Skm/sktJp2umdkzY1Mwii/e30qhvAHPqFrov6hKaOhSKmARNZHwD
	5yafeHYwLujwoaz7glh5PvGL2ylvQkPapjtz9NWbValnpD6rMlqFsL0mmSMhNrxA
	gTCJLGsoq3PBljWlAx5e8r4eGDZwvF+lR6iwuTbzs9Gmt762tvw26HAhZclAru3b
	gYDmLxKEW59nHDZuPSy/Jes3VhnT+ED2QLp47DT9136WAx7VjD8JEBuLSA0r9MZR
	GIMM7A==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 4802q2hdar-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 24 Jul 2025 14:08:59 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id BFB5840046;
	Thu, 24 Jul 2025 14:07:56 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node3.st.com [10.75.129.71])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 810B56C49AC;
	Thu, 24 Jul 2025 14:07:20 +0200 (CEST)
Received: from [10.48.86.103] (10.48.86.103) by SHFDAG1NODE3.st.com
 (10.75.129.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 24 Jul
 2025 14:07:19 +0200
Message-ID: <7ef4ce0e-8690-43ab-90c4-84cebb4e58e7@foss.st.com>
Date: Thu, 24 Jul 2025 14:07:19 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] crypto: stm32: Fix spelling mistake
 "STMicrolectronics" -> "STMicroelectronics"
To: Colin Ian King <colin.i.king@gmail.com>,
        Herbert Xu
	<herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue
	<alexandre.torgue@foss.st.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>
CC: <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20250724105754.140400-1-colin.i.king@gmail.com>
Content-Language: en-US
From: Maxime MERE <maxime.mere@foss.st.com>
In-Reply-To: <20250724105754.140400-1-colin.i.king@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: EQNCAS1NODE4.st.com (10.75.129.82) To SHFDAG1NODE3.st.com
 (10.75.129.71)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-24_02,2025-07-24_01,2025-03-28_01

Hi, thanks for the typo fix.

Acked-by: Maxime Méré <maxime.mere@foss.st.com>

On 7/24/25 12:57, Colin Ian King wrote:
> There is a spelling mistake in the module description text. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>   drivers/crypto/stm32/stm32-cryp.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
> index a89b4c5d62a0..5e82e8a1f71a 100644
> --- a/drivers/crypto/stm32/stm32-cryp.c
> +++ b/drivers/crypto/stm32/stm32-cryp.c
> @@ -2781,5 +2781,5 @@ static struct platform_driver stm32_cryp_driver = {
>   module_platform_driver(stm32_cryp_driver);
>   
>   MODULE_AUTHOR("Fabien Dessenne <fabien.dessenne@st.com>");
> -MODULE_DESCRIPTION("STMicrolectronics STM32 CRYP hardware driver");
> +MODULE_DESCRIPTION("STMicroelectronics STM32 CRYP hardware driver");
>   MODULE_LICENSE("GPL");

