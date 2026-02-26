Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010038.outbound.protection.outlook.com [40.93.198.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747E42DA75B;
	Thu, 26 Feb 2026 12:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772110730; cv=fail; b=VpROaWSIZscsoGSXqxkAwhf3NSBICX/fPcV0EyqGkQOuG9DafhwLjBzo58Psf2AwS7lamV6/AFNvm06BRnrG0aUktGhRPwToHx9G90Vr1IewuKsXC6QWieN1RTm8gxWrMQqohV5cuIP/i5N2Jb+DuvoRMszu6MEkgqplM7GElhI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772110730; c=relaxed/simple;
	bh=ijohF5ZNvNeJepEdXSSGRe1GZpN9YqUvcUhz9/KBGpI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=iTWuYxNiDcG07mH2gJSnZo2dzEAsgwlSw0JNPqwL7br5utF1yv1hZEhMDNRDeKEgc92A77O4ocFUuTDSOQOA2a/xgJW5TRjFe0fwYsMdlvn4Cg0LaYdztpF+3HXPt38H6QnqcmFSYhyeQwNXMwigl7x0HxOuiuJ4h+H3Q5Qhb6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=wzao9rSi; arc=fail smtp.client-ip=40.93.198.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="wzao9rSi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ssN51lw3KdzuQBy0l7WSgjLnH9TqDcKOkFIGc028Wb7nANMa5ZG//lq4FTbzLzrVrslKFoFq4wwL+5+WW29l9dptzos21fu3omXy79MO1kPNeSFP/NbXyDcDmrcrHlMM3v5YrP+k8pRkkTIgu6d0ET+XoicP3Y6IwN57quJ51qwTo/+JKTKBX01Hq0X2SXrqzhWSGzz51AgRcNWirPx3md8Tt18caJj+d2sow6NE3CPKrcHoc1lITTIBvy9exgvfmpmaKeLqBOKlbI+BWUtFxgdM47Ko6Bg/4W4i+tFDGkD1PlrGKu79m7fNtyQ67uIzkcggMsfElgjlBxxpWnzfTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GTXfl8evh0zM6l7uC/zp8pKq+QPX8QtWewSTLbrflI8=;
 b=SHVIsPgwefecXBbqlMpYs8uubxHzONm4Do8+0+6PQMZUG6d0UfTNoFzPNZmYobzUKYoWJoSjpniz4/M6D8XaLHEAyhCUgUDJ6dt2WbZ96V1AvJfCNWpUVh2XyimRbtp50cD+WdplHnpYk7zMkzKdrx+eacuPFcQxp08qL/ZIaMSaFQKOGwXlqhm4mumfblE7VCS8ovK+pfILiqFLQE0X7H+yODf/zy7VK2TsJisx3WIoY69/8djDpX0XqgKLeY45xDn7C0wWWenWLPG5qVvTzF4IBKh0BO+5CKPmZ2QYDQBBGnd8VJOk0oR2UcJyT/vG+T+ENOFTUegM7MzeHJN5vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GTXfl8evh0zM6l7uC/zp8pKq+QPX8QtWewSTLbrflI8=;
 b=wzao9rSikTwTj6XS/wywpQ3Ikbi1VDyWimyrijk3hFIH5+pxR6BAkuLpEdkPVON6y+4qdF/rSaJl0FaXg5u2oaiiHhNAHnoSUsbPjfXEO7W0Q4F5idN1N86eHLn3q7y7o3W3t7uyMJ6PDYGw5uBt/MupEaKvomf5fOXRLWRNPVo=
Received: from BL1PR13CA0361.namprd13.prod.outlook.com (2603:10b6:208:2c0::6)
 by PH0PR10MB4741.namprd10.prod.outlook.com (2603:10b6:510:3d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 12:58:47 +0000
Received: from BL6PEPF0001AB75.namprd02.prod.outlook.com
 (2603:10b6:208:2c0:cafe::54) by BL1PR13CA0361.outlook.office365.com
 (2603:10b6:208:2c0::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.22 via Frontend Transport; Thu,
 26 Feb 2026 12:58:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 BL6PEPF0001AB75.mail.protection.outlook.com (10.167.242.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Thu, 26 Feb 2026 12:58:46 +0000
Received: from DLEE203.ent.ti.com (157.170.170.78) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 26 Feb
 2026 06:58:46 -0600
Received: from DLEE215.ent.ti.com (157.170.170.118) by DLEE203.ent.ti.com
 (157.170.170.78) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 26 Feb
 2026 06:58:46 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE215.ent.ti.com
 (157.170.170.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 26 Feb 2026 06:58:46 -0600
Received: from [10.24.69.191] (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 61QCwhXk2387482;
	Thu, 26 Feb 2026 06:58:43 -0600
Message-ID: <d7167ed7-2b6a-46d5-8b0f-16e867588332@ti.com>
Date: Thu, 26 Feb 2026 18:28:42 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 0/3] Add support for more AES modes in TI DTHEv2
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
	<davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Manorit
 Chawdhry" <m-chawdhry@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>, "Shiva
 Tripathi" <s-tripathi1@ti.com>, Kavitha Malarvizhi <k-malarvizhi@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri <praneeth@ti.com>
References: <20260213130207.209336-1-t-pratham@ti.com>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <20260213130207.209336-1-t-pratham@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB75:EE_|PH0PR10MB4741:EE_
X-MS-Office365-Filtering-Correlation-Id: a1f57424-f429-4efe-0cff-08de7536c796
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|34020700016|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	UnJZkk/IRo9F4VnaD47TO6KxIH0V81D6U0sB0fkxxjQaXBYXw8DBEzyNXN5BRF41Sx55ZTectVKuDXz8ern7v68eN4IXMEhTk/Ng7WIwyOpzU1Uq0h9tfK9kbMKrnIfDHQQf1RUgVu/+NaeVZ2enlTp4Uc6tVau+HFy/w3SDvSXwmzvtsr8cbnJvXN/XYyeJQ/+a5j9ZaHW1/+ru1OeO7BNpd2/KXa6g8RzgkqYlP5uT+B6N9l3lFSIE6BLxsKjlhECXED1wkkgn1gh/IXKAs7mDi9U7jkBUGaajq7X59+GEQULA5r56NTrQzeMrJif4K5E0fvW4fp+OmXYR712JmiVCHNNx8TBhouf3auDQbWSbf4RM6/KXnsheaR0RPL1h0ibvZQOaQcf14wGydCadZwrhsOhvOGLtmFVmR8Oqj/fHep7FPleQvWhaLNg5pikkdCXuT4aCTCsiPh/+g2F9Wnnxg+kYoSF+WYVbMdjJ2mtaMe4Ht0ohUR9ykodc7SK8kSFPPiivAF20MOKzO3qrkgEaqdZHxyLaGxSDPcoksizf4ex/Pfe6g1EfP+5ealwpRVZ+p9jd5lwn6K/D1eOk/RooS1SdMufol+F8bXzuW7ZenLsJGyKu21fUn91cwLzPB4IwQXjWFO//GEL8VjggMEAz+OTJaLIL8ySRUYuqrbqHpK1f/KVAjmt7YsvinQhoztnKMUZa7VtliZ2gOCaes+r74mGVk8txXCjFyv1RD+gxVrjMCWdE79xJON7RJxiTGWjyVw1q3ir2JOfqy2uJ00dZZZzRYHofUaPEroj5A8w=
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(34020700016)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qn024r8DesTVoz06/2SSVh0O7uYFQFst4gnKwxH1FO7OHVTs7aQVyT9aqH+4Eoi7G3LlXyNw7InBWrQT2MkI8nOHguEAfXD9T5yJwDgAyUNMLPbi+vaVtp0euvEOy6y2EVnC/sVXYdi6LLVl0WhiKwJDKNiM8NZWBe07zZEfQH/ucJC1aKYWdwFiPsH30SRCNznHHvaX9bmLtJboF+XkcSXTVX+zhNwHKQq1LQkjkJ+t7xrdhzuBfZptEMQ8FyLK4COGligNIcNZUNb8fZLeX8hmBANx+bzcZjJkjZGnlrsdN4iTKb85/dJgDFPeDZtKpMC+/EqL0wkltQZpqlpRzvBZ43lRD7uAGpSjv06Z2UC8lI9XNrLIIxH+ijsfiDdgMyzhk0pOeOjhgGzwEnZDgY2LLHPSrv4H1KtDB/+3dAMqHxnRrEUzgstoH0ZygdRV
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 12:58:46.9163
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1f57424-f429-4efe-0cff-08de7536c796
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB75.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4741

On 13/02/26 18:32, T Pratham wrote:
> DTHEv2 is a new cryptography engine introduced in TI AM62L SoC. The
> features of DTHEv2 and details of AES modes supported were detailed in
> [1]. Additional hardware details available in SoC TRM [2].
> 
> This patch series adds support for the following AES modes:
>  - AES-CTR
>  - AES-GCM
>  - AES-CCM
> 
> The driver is tested using full kernel crypto selftests
> (CRYPTO_SELFTESTS_FULL) which all pass successfully [3].
> 
> Signed-off-by: T Pratham <t-pratham@ti.com>
> ---
> [1]: [PATCH v7 0/2] Add support for Texas Instruments DTHEv2 Crypto Engine
> Link: https://lore.kernel.org/all/20250820092710.3510788-1-t-pratham@ti.com/
> 
> [2]: Section 14.6.3 (DMA Control Registers -> DMASS_DTHE)
> Link: https://www.ti.com/lit/ug/sprujb4/sprujb4.pdf
> 
> [3]: DTHEv2 AES Engine kernel self-tests logs
> Link: https://gist.github.com/Pratham-T/aaa499cf50d20310cb27266a645bfd60
> 
> Change log:
> v9:
>  - Removed modifying scatterlist in AES-CTR. Replaced with allocating
>    our own scatterlist for the same purpose to handle padding.

Please ignore this series. I found that I had used a function in the
first commit of this series in the above change in v9, but that function
was being defined in the second commit for the first time. Thus making
the series non-bisectable.

Sent an updated version here:
https://lore.kernel.org/all/20260226125441.3559664-1-t-pratham@ti.com/

-- 
Regards
T Pratham <t-pratham@ti.com>
