Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011015.outbound.protection.outlook.com [52.101.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC2C367B6F;
	Fri, 14 Aug 2026 11:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786707878; cv=fail; b=PkJVMEKanE5wOewPR9oVT7Pw26OS4d/q/uK8Zexn68F2n1hVTTdjWgpXMGy/rXxzT+dd7KNfFXJIe2IOFSkm0xyfW6HPYqjROt+sZ29HNRMrdxrxEfG+DM7U907Ppi7k8DYNfqc3gOxAEFru2v/uM3Gqei9GlPKQeIYGpj0OJlA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786707878; c=relaxed/simple;
	bh=2icJhd5KJk+dJwaaRg47ie5wQBN59QUTnE/xmccGYp4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=BPjLLxiWTXOmlHYbiMDO+W9Q3BNxIAjY8yihjRZb0SoGkmz9X4TOxh4U8b81jlwqcIzZIVaEcKednw4JPH3FVtcNcIn5sjiwZ8VEjBBJ1wpDhljxrw9rcq8bpz81lXwj9ijTZZk+abGRGMta/nCEeqjp4NB+n6Qx+w6i7BvEueM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=ef4K3LI8; arc=fail smtp.client-ip=52.101.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="ef4K3LI8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Duus6zkavTgl9zYAgF6IigbZGptfLaXelB0I4OedsRgHiWYoW620+3tiG2NrOm7pYUIBKKloya9PS019djHt+HIx2ZXO1R2vBq3CQcAujL9pGHKmRXGK8J0amjTOl/Yl3vYu0NoJSIuiN9ixsuD0Ky8zfdinlVxX90mgn8tzkWMdNmtI9FD28rpvm7SqKvqOAbn1jKgtlr6FZfcXoLMcO23ZjB98rzV/twDZOwHIYcpuQv9Nde0shRkyJUfd32s1QBpyr014HZCG1uCXjvilfylhr4xLgZ4F/onq658F/ov70NiT+WbPBA2w6JiomSAkKYgu95Sy+9b8VOTTQsXDtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ugE8ncdpALLHbq3fEPhJ5HaIGd/jZGzGG4jF0JvJuUM=;
 b=MIhqKFgG3czknPA3KPLeqE6kiUj5uxzCPuNfU19Q/0LhkdNF//MtMjSqilOWZkw7kQwq91/prj+yGNMytTlg6lBwbM9ZsozE7JOdy1YleTiF95OD0WAuFJSLBmk6kEIvz81stLb5G3PzDZWmnNWxq+YVLNDxTRrGq2xK9zxcvunRTFxWhnVrvdl4EJSU1l7AJriezkmeNl7EgeSPMA3KYlsWKNazTfH/MGlzqfYb6G6BWi00RFSzM+ssF8WOnocAbOXWBWulO5/Nb+FnT54PAwcNxu5IjZLHvj8xZKwUL+gYpp3JP9MQjdq3dC7iA1kxgWnn/mMVdRme6C51zYS7JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 164.130.1.59) smtp.rcpttodomain=gmail.com smtp.mailfrom=foss.st.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=foss.st.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ugE8ncdpALLHbq3fEPhJ5HaIGd/jZGzGG4jF0JvJuUM=;
 b=ef4K3LI8WmCu7jdOEoCNsGV2yrjq795Vg/V9Z+4ykACMbMWXYbP5YVPDpX/zXvUhNu/F4MntaLX/TxIB1XElqOm46oQqeTBW0fYQ4rW7+DNUDhGKV9dgxIT+7DP2LfhsEWQBY+lWmDToIi4BqSut9qwdiNNKi0lh6QHSWfCAtRAdx/9ju3oBmj9EVFqzvRiETRxFcQ0mdsJPS2/I657hXN2QDkLEzQGit4mVX0Gz8R2nB5dOg2Jh14I1r8lSNqBcIKHWrlPsIK3PNnyp2OqqpxXIVF6yBIYtY+AosU54raJKKV1AIOultVp9BXNB/+ji2csW/mzAkQh1z21vEgE4Lw==
Received: from DUZPR01CA0043.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:468::6) by DB4PR10MB6168.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:10:387::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.15; Fri, 14 Aug
 2026 11:44:33 +0000
Received: from DU6PEPF0000A7E4.eurprd02.prod.outlook.com
 (2603:10a6:10:468:cafe::9c) by DUZPR01CA0043.outlook.office365.com
 (2603:10a6:10:468::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.15 via Frontend Transport; Fri,
 14 Aug 2026 11:44:33 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 164.130.1.59)
 smtp.mailfrom=foss.st.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=foss.st.com;
Received-SPF: Fail (protection.outlook.com: domain of foss.st.com does not
 designate 164.130.1.59 as permitted sender) receiver=protection.outlook.com;
 client-ip=164.130.1.59; helo=smtpO365.st.com;
Received: from smtpO365.st.com (164.130.1.59) by
 DU6PEPF0000A7E4.mail.protection.outlook.com (10.167.8.43) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.3 via Frontend Transport; Fri, 14 Aug 2026 11:44:33 +0000
Received: from STKDAG1NODE2.st.com (10.75.128.133) by smtpo365.st.com
 (10.250.44.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Fri, 14 Aug
 2026 13:49:58 +0200
Received: from [10.48.86.103] (10.48.86.103) by STKDAG1NODE2.st.com
 (10.75.128.133) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Fri, 14 Aug
 2026 13:44:25 +0200
Message-ID: <fc5c6571-34e5-408c-a6f0-e5cd46c816d6@foss.st.com>
Date: Fri, 14 Aug 2026 13:44:25 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: stm32/hash: fix autosuspend cleanup during
 teardown
To: Guangshuo Li <lgs201920130244@gmail.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue
	<alexandre.torgue@foss.st.com>, Thorsten Blum <thorsten.blum@linux.dev>,
	"lionel.debieve@st.com" <lionel.debieve@st.com>,
	<linux-crypto@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <stable@vger.kernel.org>
References: <20260808094114.2750088-1-lgs201920130244@gmail.com>
Content-Language: en-US
From: Maxime MERE <maxime.mere@foss.st.com>
In-Reply-To: <20260808094114.2750088-1-lgs201920130244@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ENXCAS1NODE2.st.com (10.75.128.138) To STKDAG1NODE2.st.com
 (10.75.128.133)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU6PEPF0000A7E4:EE_|DB4PR10MB6168:EE_
X-MS-Office365-Filtering-Correlation-Id: 981ea5a2-2d51-467d-429b-08def9f968cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|1800799024|82310400026|376014|7416014|10067099003|921020|11063799006|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	dqMjFpzWuWVoEox1Oz2KxMUyZkHfcDQsBNakSfPAxxeCH+eU6KaISr8AJDv2ECyDNtK2cCanCuQjrJmQ83OTQ7qRvJbIJUJLiJEfx9Qne3sYcTsH8iW5a67VZmju6tt2ufJe/w/3fxLWxa8B4bFwS/L7hYQujIHlh2rVbFg5VfXFUp4zeFosBQHW5OF+/VcNX9h5psipCdCcJBn7o6vgUgPKnZsEt0sPHfx8Hup+cy5kRYoHgzOFybrPzIORnk8DVhSOty2HXv2JGYsMT29LeKWzzBMzXNMlSh64brkJkQe1WbBot7yNqi+z/wdVV2uinY2DUFsNZeaHgIzkmfl/3xI/ApI9qMF43gWKhFtDu+P9LMLzx1P/Ww8lvUd6MMGH0Dm85ytn7mkVS65Pebgz++vNId1M9RWxIneJ7rk0cFJp1YDcbjIKFO494YofLzIkhS7i2jc8wsRfBFMHqAqmyrYEoSuiQtvp1HoTIaG4+orevupklWCpyaVR2LBgH4SMWwOWssafdkZnaFIUVr33w9RVowVip5tDRwftffbLZ2F21kSRHNyAJmM3aP31ERTuwkEZ3ahEu93QW0RHMCOggieBH57xrtv58wKYz6zct3mgqXyWjIU16WOj5jq7qg6Qzcc1k9iBCYV0rXuAe4NFTc+Dd4XKu1wMkLjwb/1hSN0uYur01hCZRfrW5NOq1R9X29qcN7BbZMueNfqVGuw5O2b9jE+EztAQeCB+iQbPFSeYaSjX4Lcvv/EcD658S8Us
X-Forefront-Antispam-Report:
	CIP:164.130.1.59;CTRY:IT;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:smtpO365.st.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(1800799024)(82310400026)(376014)(7416014)(10067099003)(921020)(11063799006)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	K5fVDMzeRxzxqQxTlIuLqH4pqnlcIDFcG9KBa3Z0icUIGnocKYoOFKgRrfm0fAA7xuSFi6W3i9Kl7swsdE8IKAyXCmRMqw5LQky7nW4CvDQyzp5bNVobEhdyG1G9nYpdKIjSY1ZhjjgKOJqswfwqVeQAppWlhCkTlEf4+1deYJEQ9PSzUgyY0d7SAUm/ClIbCdt3p2iPWj3YoHXJhNqWdUC9ml5IleWozNf3SjE0+UtIiTfxfbHE0cIcYFQUF/UJZaPQb+1ko2r5f857mYbVlbszr6ZTgrQUvMixLoDf9qtOxwQBOTIXs7mdWZQk2H/PSUCe5ESoYCTzyTx99wsmxbdjPV0r3ph59PnbPCQ2RZD9GZz7S+90iTJj97nJQTEzOsndkju3kV7l4r10zUv9tGkEG3uGnLZRD0V0Zs7p4t9ktb5MhMy/OK7hUkvmVyWM
X-OriginatorOrg: foss.st.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2026 11:44:33.2343
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 981ea5a2-2d51-467d-429b-08def9f968cc
X-MS-Exchange-CrossTenant-Id: 75e027c9-20d5-47d5-b82f-77d7cd041e8f
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=75e027c9-20d5-47d5-b82f-77d7cd041e8f;Ip=[164.130.1.59];Helo=[smtpO365.st.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000A7E4.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR10MB6168



On 8/8/26 11:41, Guangshuo Li wrote:
> stm32_hash_probe() calls pm_runtime_use_autosuspend(), but neither the
> probe failure path nor stm32_hash_remove() calls the matching
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
> Fixes: 8b4d566de6a5 ("crypto: stm32/hash - Add power management support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Maxime Méré <maxime.mere@foss.st.com>

Cheers,

Maxime

