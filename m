Received: from mx07-00178001.pphosted.com (mx07-00178001.pphosted.com [185.132.182.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B849A1DDC9;
	Mon,  7 Oct 2024 15:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.132.182.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728313274; cv=none; b=tNwGPAu0Q33cn5wLdzssp7MIHizdxgvIdo6e++NI06rEg0ERDYpKoIoq+apOCFVA5Ud0knMK0eMHCfPajItBMqHY6by5utXY+MdMbwnJvrJTmh7bSUBCkuIYIZ368zgxXZmebzIad0REUsaNb8BM/AQ3LnwhKHVmYYgFFAhcW+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728313274; c=relaxed/simple;
	bh=qE8wZ+gDGWCnPkH+WVw/mcs9lDttSkwGYaOIzdr4U8s=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=l3tBhc7qV5PlbJ7jX4ffvIpqq3BsaOBsw/8mOktuty+157cQwOaJjkD3HqCHK1a0mnzoS2rTpPcHwzH4Ub3AGsJ868hc0h61WnojeCJpOiDo9pHSOjUpZRaXiLWfDI1/WY9cato8yVfcrkU/uEWQ7wXBrp2hblT5fontIGQvb+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=W7wzoXSl; arc=none smtp.client-ip=185.132.182.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="W7wzoXSl"
Received: from pps.filterd (m0288072.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 497BwB4Z004331;
	Mon, 7 Oct 2024 17:00:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	qE8wZ+gDGWCnPkH+WVw/mcs9lDttSkwGYaOIzdr4U8s=; b=W7wzoXSlQueKttxg
	y5n+RZKKhj2fRMRxSAGXhQSskcRsMVHezHj39OHV1CRAX3fCCdLFX+b2CDMIwvpX
	HyG0WdbkIHO8Jn0ZflUmznB8SnZMES5iBrMncl3xXDea2QmsY+fDmY42ZXHU65eT
	RVq78FL2UHVNmlKWtUGFlgdOwL5uKRR913OI6buzjCPu7jvJIj5IODMnACjs7wFN
	BsuK4mYdBIgvL4zcei8wCHDS3jDPBECgJMU7BQtLi1F0C1gmK/HhEZ0dSUYpzdgn
	7/4AwOQ+i7WZNTnd/ru1V40hVeEcCeeA91/yINJRd6yRa6k7u1zJW89nO8xQOI/t
	k647Fw==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 422xv71hh4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Oct 2024 17:00:43 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 22CCF40047;
	Mon,  7 Oct 2024 16:59:14 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 86106226AF5;
	Mon,  7 Oct 2024 16:58:19 +0200 (CEST)
Received: from [10.48.86.225] (10.48.86.225) by SHFDAG1NODE1.st.com
 (10.75.129.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37; Mon, 7 Oct
 2024 16:58:18 +0200
Message-ID: <25630f20-de0e-401a-8002-4aec03f6e2f1@foss.st.com>
Date: Mon, 7 Oct 2024 16:58:18 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] hwrng: stm32 - update STM32MP15 RNG max clock
 frequency
To: Marek Vasut <marex@denx.de>, Olivia Mackall <olivia@selenic.com>,
        Herbert
 Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof
 Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley
	<conor+dt@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre
 Torgue <alexandre.torgue@foss.st.com>
CC: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
        Lionel
 Debieve <lionel.debieve@foss.st.com>,
        <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Yang
 Yingliang <yangyingliang@huawei.com>
References: <20241007132721.168428-1-gatien.chevallier@foss.st.com>
 <20241007132721.168428-4-gatien.chevallier@foss.st.com>
 <41fb71cf-7ae8-47b8-bd0e-fc24da9d0bd3@denx.de>
Content-Language: en-US
From: Gatien CHEVALLIER <gatien.chevallier@foss.st.com>
In-Reply-To: <41fb71cf-7ae8-47b8-bd0e-fc24da9d0bd3@denx.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SHFCAS1NODE2.st.com (10.75.129.73) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01



On 10/7/24 15:55, Marek Vasut wrote:
> On 10/7/24 3:27 PM, Gatien Chevallier wrote:
>> RNG max clock frequency can be updated to 48MHz for stm32mp1x
>> platforms according to the latest specifications.
>>
>> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
> Does this also apply to MP13 ?

Max frequency for MP13 is already 48MHz.

Gatien
