Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012016.outbound.protection.outlook.com [52.101.66.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977CB439014;
	Fri,  2 Oct 2026 07:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790926788; cv=fail; b=SA/iXByNoykQ2Lecl1V0HBN9/NOxDwXwm4NDzk0hwRKwsG32pd1sTUc/AjIeI2cS8NwgvFu9EGVAzmfV9iFPVzPoluOHV/QRYS/BxXn9tci/evY/5Z1qNJ8hTZs+24/jjsx8m8aL5tuIXcZ7zRaeYeEUoUMLoA+b4ofPuXNxMnA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790926788; c=relaxed/simple;
	bh=azilNuCUlGWGFhUYrSCPSkQBtmC3n1Pbs4W8Fe5cWrA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=iKLUkL4FH90TEVhmdZKlYGURQ5uiWtp8wvmmrmp6Usxx52KerI//a8XMNf6x1BNJoKeCnDEwBTm+q0vfE00Tng3EG44auLqlaE50OyArmvatOdW8yGDOQXu6FNYG5y4UJIHLLjMS8H1YozmFwJUfSSqo1AED40dYDBVMTWm7VQ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=TYy1U58C; arc=fail smtp.client-ip=52.101.66.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="TYy1U58C"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=arRz+0rWPEOGCg51nxjyo9hLZkSRrcHLGyQ2WHme7GgJjrjvBvmY2wqfx0AhZhJ4WjpKHZLAmqdLQ6DCtk2AO8afIqD/DTEMKS/JDE+wWhU2i7/S4euYcbe0PL4y73pIyM2hnCltqHDaA8vBvIgMlICtqP5kwLMsq02YkCE800EK+kgPYfwxfPodh15cz4wRhqtSirim24UC1mpv86j2GgXUSQonYSBOigXnCAtuRBfxLbzgKRA77t+QJY8r27I4JtSJ2wsMJfxH36PZq75f8Q0gocDT6PSoaZxBHUprBYNhU6TbY5cg3URfH295bojTL5qrcC7FPHX0WMYq9rsYXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=faI1FDtHomsXYzyaQZ27N21cNGJajbtf8XrEl4uhr/s=;
 b=NnBIw32aIGvGtbOfLtbPwQsSRE5pxZsWxexxyHiUppWrb7HYsyQzNS4qOJaFikUpCwfJuUVI2ap9GcypmttdH+U0G+r7vd5sFGsD9rBr4vOyTqzT8J1jPD+t/GfCFMdNfixwRl4PXuFalTmZWQe0YUF8/vlpP8onF8u3R2TaB+Ng1MPyme4q9yCMPRVsDIlIdj8XYOUyRv0/McV9rNvTU5oiBrwqsnKLDQQD4UVdXJiaiu8ChECqs8crTVxemNLTvxJMbwR4PkWy7kUyE8lWieNRUL8jLxqI7cImWvfDvP1s52tgJTVGyhK3FgVPE5KnhSk8AnkmefgoFWWsHqNBNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 164.130.1.60) smtp.rcpttodomain=kernel.org smtp.mailfrom=foss.st.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=foss.st.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=faI1FDtHomsXYzyaQZ27N21cNGJajbtf8XrEl4uhr/s=;
 b=TYy1U58CEs7/gIC+Va7IAmwyhj0LPZYYRROp0/dsfwQ2hetXGZxPkEz6I3PK13ss4RJIyWwLkDeFTH9l29T8Nrobned00EG+GbTaeC0HxnlGUSIk5Se+nYLIG8BeHM5eHLJSpE31fG8Q1B1byyab9JIzZHKJmgN3m91UCU9XMnd7lad6u4gQmPDmW01ZGXwOUHmamNDy2y5w8dWkMrRQ12PgU/9YthMSuvqd2ayicLRH89u9IqdN/UWFkfqdsQXGQi46Mx8gxAf7enJRlQK3HVrlF8yqzyiaNgnWGQnhI+3tfiBXbHvkJmU60LpGGXrojk7dVXK70K7nvM7ki0CVdw==
Received: from OS6P279CA0069.NORP279.PROD.OUTLOOK.COM (2603:10a6:e10:3f::8) by
 MRWPR10MB9810.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:501:83::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.16; Fri, 2 Oct 2026 07:39:43 +0000
Received: from CPH1EPF0000051E.eurprd04.prod.outlook.com
 (2603:10a6:e10:3f:cafe::26) by OS6P279CA0069.outlook.office365.com
 (2603:10a6:e10:3f::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.14 via Frontend Transport; Fri, 2
 Oct 2026 07:39:43 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=fail (sender IP
 is 164.130.1.60) smtp.mailfrom=foss.st.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=foss.st.com;
Received-SPF: Fail (protection.outlook.com: domain of foss.st.com does not
 designate 164.130.1.60 as permitted sender) receiver=protection.outlook.com;
 client-ip=164.130.1.60; helo=smtpO365.st.com;
Received: from smtpO365.st.com (164.130.1.60) by
 CPH1EPF0000051E.mail.protection.outlook.com (10.167.241.233) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Fri, 2 Oct 2026 07:39:42 +0000
Received: from STKDAG1NODE2.st.com (10.75.128.133) by smtpO365.st.com
 (10.250.44.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Fri, 2 Oct
 2026 09:45:37 +0200
Received: from [10.48.86.103] (10.48.86.103) by STKDAG1NODE2.st.com
 (10.75.128.133) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Fri, 2 Oct
 2026 09:39:41 +0200
Message-ID: <480b20a8-dd25-4d07-813d-99284823a0fb@foss.st.com>
Date: Fri, 2 Oct 2026 09:39:41 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] hwrng: stm32 - reuse clock rate in
 stm32_rng_clock_freq_restrain()
To: Thorsten Blum <blum@kernel.org>, Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, Maxime Coquelin
	<mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Linus Walleij <linusw@kernel.org>, Can Peng <pengcan@kylinos.cn>
CC: <linux-crypto@vger.kernel.org>,
	<linux-stm32@st-md-mailman.stormreply.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
References: <20261001211612.38124-2-blum@kernel.org>
Content-Language: en-US
From: Maxime MERE <maxime.mere@foss.st.com>
In-Reply-To: <20261001211612.38124-2-blum@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ENXCAS1NODE2.st.com (10.75.128.138) To STKDAG1NODE2.st.com
 (10.75.128.133)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CPH1EPF0000051E:EE_|MRWPR10MB9810:EE_
X-MS-Office365-Filtering-Correlation-Id: 15e4f93d-9fa0-4ca1-7321-08df205852c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|36860700016|376014|1800799024|82310400026|11063799006|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	FxNu0hFtTf1/kH1qfh+5pWeh8ZPp6Rx5JbPbI8gdpYEZRUdxOaRNf/R3tr9Z78l3aYrpWg4X1rSCi7gZHY+azup8gSETiJtOW7WCJxY0z4lLy0xb6XZWAMScfcemHhmbeik2nmdSRNOvgEbUD5gTRmpwO1zIPmkkC/RKh7U/gBKt4Znusez1o9n6ek9KiuCYG4/vUXejgHmkRRC7v01VUVyLa2hDBnQbnIfVTNEnOZ4dfdPSIHGobvVHpyV2/ZRzqQWX0aeKeeDK6MGdFFVXS4rxYiC99YGCV7q5FhzGdfneb9TxBhdXhhq6UYYR+QYduW+iO8VBOvDNczH13W+gvai3dbkwzyYuhgbDLY+T+YpLk2XJCOso8xFYDcexDCA9QuQvBkWIGrz989aZaLP9dBIg4yUE3tsCjISFGZ1FiWCWQcwPOT4tPnyKFLqq1T0rrB6TANIdgAGH6MOfKatvtdR+4jF+W6YDRjoU7opoJFVf/W09SnuVM3O1BNwx79ArrO2t0UcaUtwIBB8hswEpcA4AHE9tBBy8+sHSwrhA0RUb2fwAVsRwMJ5MeWY+y9ya2Ma3ryX8+lOXAKhKviQABkMgGAEdtmpGrVap1GI+bC81z5Hj9KAUDkqrsHsX5DJlXoUU33ik3HKGlTtnhgKJtOxJAHm9BsM4G9AhXZohu7epzCu4Iq0sNFAmUA2pSIMFrLdJZKlv9BNV7CkPRzPngw==
X-Forefront-Antispam-Report:
	CIP:164.130.1.60;CTRY:IT;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:smtpO365.st.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(36860700016)(376014)(1800799024)(82310400026)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	J47n/Tfki9tvEVfzJDPbvyuU9vT88kLyl78btdQJFJ8z2TogOsYM30muegdPF2It2fsZPySMLjNJDPysg4N+5aeCoSQmdVBqiYmyMhCFsXKhpiKCNMPgj7MfPebEt2XQU1nHfdJFp1WKBWGuY5JJP1hSZtKOjY96NgPtKtgZMe57DrCHrqfvP8/CxYgiYk/p0QforBL/WT8lhgWbzaPlN0AV/OA3nqH6xd946nhc+43gHmlveRoBeMfZBhbKOf5LJWij5CP4gB/vdrcr8eKbd5uTvJ2K1cWZwWNoO6Lb3fuSnGevv9plfNi9WeNqzLXnVGIdQW6pXP+2Q0c6t1TchapUA60DkoN1qyxcl0FQKezSfyZJJWO/6jFBhE1yU1zb4judmXXSSxwtE7RJQxyYu6Sl2ViATUlNP4NrXT3WMulgg6ZN99wkG1op5iHGXWNv
X-OriginatorOrg: foss.st.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 07:39:42.7174
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 15e4f93d-9fa0-4ca1-7321-08df205852c9
X-MS-Exchange-CrossTenant-Id: 75e027c9-20d5-47d5-b82f-77d7cd041e8f
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=75e027c9-20d5-47d5-b82f-77d7cd041e8f;Ip=[164.130.1.60];Helo=[smtpO365.st.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CPH1EPF0000051E.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRWPR10MB9810

acked-by: Maxime Méré <maxime.mere@foss.st.com>

On 10/1/26 23:16, Thorsten Blum wrote:
> Reuse clock_rate and avoid calling clk_get_rate() again. Remove the
> extra space before the colon while at it.
> 
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>   drivers/char/hw_random/stm32-rng.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
> index d3fc910f674a..319944d92b82 100644
> --- a/drivers/char/hw_random/stm32-rng.c
> +++ b/drivers/char/hw_random/stm32-rng.c
> @@ -277,7 +277,7 @@ static uint stm32_rng_clock_freq_restrain(struct hwrng *rng)
>   	while ((clock_rate >> clock_div) > priv->data->max_clock_rate)
>   		clock_div++;
>   
> -	pr_debug("RNG clk rate : %lu\n", clk_get_rate(priv->clk_bulk[0].clk) >> clock_div);
> +	pr_debug("RNG clk rate: %lu\n", clock_rate >> clock_div);
>   
>   	return clock_div;
>   }
> 

