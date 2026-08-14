Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011061.outbound.protection.outlook.com [52.101.65.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FB0377ABF;
	Fri, 14 Aug 2026 11:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786707867; cv=fail; b=EuLopb3QjCjG1wnB44Vxiy1pPIF00RASoPpaGFnW7VtVcoWsfWpmDbaM9MLO7Z6wwvCzWPm/ZLMj3bqCfLI2L5Lpx0o37abHvGK9dR2JpDWho1+GSFogBNoVjKaDbOdgjJkcGwqtOztawIUpCCn2raqOc9yVU5mR7DE8qUpy7Vs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786707867; c=relaxed/simple;
	bh=sdgbjdjJbKb4a4rjZOlBWCzVGa9w/YmJzYKSzB1WWMA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=sXuOsSBjZifTk3gozlfWjyE/gR1k0FqGpf0F24+ZhTaRd7V34Hx7tN9ly1ibfEjF0ojo3ww2/JpUyiDsFXu7tEx//SNdTyWahvOlV8onltE6n+IaowFF8aWIK84Jaoao+XJz6s7fa0EwTViScoKYhOEN0Lr7oNl22ti2UBf7sPw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=lYgkHPpk; arc=fail smtp.client-ip=52.101.65.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="lYgkHPpk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eVOi6DZ5uMNWMjbQJvHuay3iYhj24wcjYgzpdcM5KgLOjQp3fA6ts/EVB+tcUDQFCiXdRn54wZEDqxynBVVNBUAzIsghk13LylU6pyFN9nzqup3Ea0bGp9I1dXLy/d3VpqD/Nwr8B5GDGjAyUdhQEN4AcqKbAOmgdvWH4MOP4YXNX2wIKx8EIyoi3+8gukBXF+U4cUiQFvc7DJg8vdeDPUmVGc/HnH8Xr3e0/F3JcpXWLqi6zVxQVN3+5JZyOsB8wUNK6uK9BQZExfmUnXB0msviJgjsbpk5Ce8pAjE46CZZEy/efKGYT5bYX4dTrzIwgEQieS3gD4bZ6M2vfhmwkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6NSKeVHpKMlrgd5XGjdCINGiyAv0DgmCBlJEfaodfrE=;
 b=Ge5cO+zRmud+Iwd7hIEtyVGiisGJCrE2eIBxFW2pbpcu+GW8Pj72F1W42l4YAChxeyfjOvm3Iid7qWS3ENZIEB5MRwbZln3wsPoYSuFSI7t653+PpRaNWMTBPJJUgqE2o4khEBy+igT11f1CrL647PJhP4dMuMsNbaunqvwApMPa5APC4tNo4yXaCsRgNrkrx1HNvCItvxGBpHpHRHVbv90UHRflPDoaEUzhIq6UMrYKIXjIOwJUFzeaxBRTjDPXyJ4tK35H7fzHaLSxlCy9K6QjSSWIZDipcfc7A2UOJv6EptZKuZjBuKp6ENfdE9ctpRPVKhk/KdeVbZJl2MUCTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 164.130.1.60) smtp.rcpttodomain=gmail.com smtp.mailfrom=foss.st.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=foss.st.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6NSKeVHpKMlrgd5XGjdCINGiyAv0DgmCBlJEfaodfrE=;
 b=lYgkHPpkYOCUL8SUHHWOl3yuS6d+ukgLM8m8ZZ9PE8xaXHuP4YKJZ3yOXta3R7UztQupFnIWKaVTUdZKnCC7qMMRTgxdkSLNw7AN4jGu69MZFPDSQLmfdpwAOdx2B+loUhyLfit6rXPdGz5ljctaxPxBIsIhg5aauZuUB21tPKHeltzzzk9O5CryRA9jpTKO1faa7t++ZOIESMLNFN6424lb0L6fUAUbooGQzc79/rQwQAf/Me8x2CeF35vD4Ln4OrUQ4DrvLT6TrCsOxsFCgZWSsuLeMEC6k6gzXiPSEGzHcizlwkJteOtvPGIveIJNfyR/vXmSFi0ijFeihvbZTg==
Received: from AM8P189CA0019.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:218::24)
 by AMCPR10MB992216.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:783::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.16; Fri, 14 Aug
 2026 11:44:21 +0000
Received: from AM3PEPF00009B9B.eurprd04.prod.outlook.com
 (2603:10a6:20b:218:cafe::99) by AM8P189CA0019.outlook.office365.com
 (2603:10a6:20b:218::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.15 via Frontend Transport; Fri,
 14 Aug 2026 11:44:21 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 164.130.1.60)
 smtp.mailfrom=foss.st.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=foss.st.com;
Received-SPF: Fail (protection.outlook.com: domain of foss.st.com does not
 designate 164.130.1.60 as permitted sender) receiver=protection.outlook.com;
 client-ip=164.130.1.60; helo=smtpO365.st.com;
Received: from smtpO365.st.com (164.130.1.60) by
 AM3PEPF00009B9B.mail.protection.outlook.com (10.167.16.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.3 via Frontend Transport; Fri, 14 Aug 2026 11:44:21 +0000
Received: from STKDAG1NODE2.st.com (10.75.128.133) by smtpO365.st.com
 (10.250.44.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Fri, 14 Aug
 2026 13:49:17 +0200
Received: from [10.48.86.103] (10.48.86.103) by STKDAG1NODE2.st.com
 (10.75.128.133) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Fri, 14 Aug
 2026 13:44:19 +0200
Message-ID: <a9038d8a-cc47-4c06-8e52-0e645d2e1d23@foss.st.com>
Date: Fri, 14 Aug 2026 13:44:19 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: stm32/cryp: fix autosuspend cleanup during
 teardown
To: Guangshuo Li <lgs201920130244@gmail.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue
	<alexandre.torgue@foss.st.com>, Thorsten Blum <thorsten.blum@linux.dev>, Kees
 Cook <kees@kernel.org>, Colin Ian King <colin.i.king@gmail.com>,
	"lionel.debieve@st.com" <lionel.debieve@st.com>,
	<linux-crypto@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <stable@vger.kernel.org>
References: <20260808093623.2744314-1-lgs201920130244@gmail.com>
Content-Language: en-US
From: Maxime MERE <maxime.mere@foss.st.com>
In-Reply-To: <20260808093623.2744314-1-lgs201920130244@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ENXCAS1NODE2.st.com (10.75.128.138) To STKDAG1NODE2.st.com
 (10.75.128.133)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM3PEPF00009B9B:EE_|AMCPR10MB992216:EE_
X-MS-Office365-Filtering-Correlation-Id: 511cee6a-4e8d-4609-ef73-08def9f96194
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|376014|36860700016|1800799024|7416014|10067099003|56012099006|11063799006|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	7RwLAZrhEEwcUJN1rMb6Ac6RCHB9577url9Ewg8rloBD+WIMFFPFvj+tCbbTrGxdMpWa2WTlpDvXajW02rAWKCoKXuGLzil8E3A/uhYby2MGlBH0zBbNFIIohd7SKop9KeNTXBk/3nEdW6tV0KcCkQqfQKYuse9ysKXWkpz8qIaoiBv3oxMKmaV1pZzti+Yw5zd4I3v7Ls467X/pOeLZgT/r3vruCSW3QkFL48yFNtkyIADlz5W4ygVaXrOryESXcBHAKq4+fEZpUpEXSmqm7/PvD6rkcEGIvay0AzOWh31kkDVSJz4p/tH7VKlYrq8kdrDxBiLhYyhWZE1N87BeyFOV4Ij+y7Q1lgzq4CYhl+IwtiVFh0jRlDu6SRwjeo9bsilBpA0SLN9Ho8CML0DzZy9buDk0Xi7WwjuindqYy0Y+O6lN4Y/90TlURQjmIjnWytn0qMijWPrYzzveI2XdKz+Jfc7Gkkc9eon51paNjjWq3W57mF72LqzaxmqCHtFYZSO2Xt3XIKRHBYPUSmvPKP8AnYtXmczZhJSaDFg0rWvuhuCXb6smwLjuoyJtR8ffzDi4iX2oaGHeVDbhupFzbo3uzVN9StTO94WaYs8WmHLWVTEnkgdKaq/3vae9xjUxhHnrbAZCzViUh+khYjxnbOldxaq4Q+oPLHcdkpknIU6fc4VNncsKBVaiNwsl4AHg1lSJaYLY2eQJATFNwUjliDk5KKHm1aSL3vLCeroNJwiKmQxsbTUw0ouqCfaH46cV
X-Forefront-Antispam-Report:
	CIP:164.130.1.60;CTRY:IT;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:smtpO365.st.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(376014)(36860700016)(1800799024)(7416014)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	JLxAM44Jgc998VwK1Xyzi/9DQHQQd3KGcabyByKzAf5VeE2hQVEXC8P1NDfGjd27dFGqcRruTAyZ882f7oyIX7T3mgkMGnT2ke4zHrcDu2hmGHUNpipU8vYH79Xbqe6nZQZ/w0dHg8XrkZfxuD+i5jO03XkSNJs/5R2j+qFrJuTGHOPb1EZ+ClWn1YozYd2KIvTOhk8Tln3BWLtXtya2NAuGZTrCxX8fSy/7XHEOToqAkqbVZRqM4RTWlqBF2gC1rh4SOdsuOHw+xKfBWZjRaS20dtV1SC6cWZHswyyvtX07eSJgQwkOTg5vqQToUwapcvUMSz2d3euETQUB2A9SXUZAFOVt6wNO5PvFxpgBiKur5pxavci1rWzCCDrG/pZ9ZLKwl4BnBMj864c0sg1ijxSHx4RYAah8NYSdYkXQGkWbwsMnYkGMizHxway/wGUk
X-OriginatorOrg: foss.st.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2026 11:44:21.1672
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 511cee6a-4e8d-4609-ef73-08def9f96194
X-MS-Exchange-CrossTenant-Id: 75e027c9-20d5-47d5-b82f-77d7cd041e8f
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=75e027c9-20d5-47d5-b82f-77d7cd041e8f;Ip=[164.130.1.60];Helo=[smtpO365.st.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009B9B.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMCPR10MB992216



On 8/8/26 11:36, Guangshuo Li wrote:
> stm32_cryp_probe() calls pm_runtime_use_autosuspend(), but neither the
> probe failure path nor stm32_cryp_remove() calls the matching
> pm_runtime_dont_use_autosuspend() before disabling runtime PM.
> 
> If the autosuspend delay is set to a negative value while autosuspend
> is enabled, the runtime PM core increments usage_count to prevent
> runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
> during teardown, this reference is not dropped and usage_count remains
> unbalanced.
> 
> Add the missing pm_runtime_dont_use_autosuspend() calls to both the
> probe failure and remove paths before disabling runtime PM.
> 
> This issue was found by manual code inspection.
> 
> Fixes: 65f9aa36ee47 ("crypto: stm32/cryp - Add power management support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---
>   drivers/crypto/stm32/stm32-cryp.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
> index b79877099942..74f6e329b1fa 100644
> --- a/drivers/crypto/stm32/stm32-cryp.c
> +++ b/drivers/crypto/stm32/stm32-cryp.c
> @@ -2691,6 +2691,7 @@ static int stm32_cryp_probe(struct platform_device *pdev)
>   		dma_release_channel(cryp->dma_lch_out);
>   err_dma:
>   err_rst:
> +	pm_runtime_dont_use_autosuspend(dev);
>   	pm_runtime_disable(dev);
>   	pm_runtime_put_noidle(dev);
>   
> @@ -2722,6 +2723,7 @@ static void stm32_cryp_remove(struct platform_device *pdev)
>   	if (cryp->dma_lch_out)
>   		dma_release_channel(cryp->dma_lch_out);
>   
> +	pm_runtime_dont_use_autosuspend(cryp->dev);
>   	pm_runtime_disable(cryp->dev);
>   	pm_runtime_put_noidle(cryp->dev);
>   

Reviewed-by: Maxime Méré <maxime.mere@foss.st.com>

Cheers,

Maxime
