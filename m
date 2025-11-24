Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010040.outbound.protection.outlook.com [52.101.193.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384EF2F6179;
	Mon, 24 Nov 2025 09:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763977855; cv=fail; b=IPIizsua4QjK3m7YNqHRiLsyuRI70aLkSUdJDVZieeO3TzABX8SZrk/a1Z/lyV1Iev60F6nqvvcIt0WkI6EBE5+c7jivmC8JhBR+U97K0gtN5yBejGa79osjwPUtXlykd/YVwihLNDxCfUsGby0xmFqa2+2gnPxenZybirAouqs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763977855; c=relaxed/simple;
	bh=cdBAjmNd9lTzKmnZBuG9wNWyTaQyGmadk5+hQpsMKss=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=LkqME6cFMeU/6OeVbD6V/tu6jqhbCiQAc4+KRE1UI4Jkqk8AVTfw7Ia7pPYuDHEcuXxqi9QlInHAUEX+6ATxTezAmZ4PtB/rDhtmF+Eyj47Ug0eckLpz87RXCPWTagZgtZg2gCM0rqYYineuasj15kli3UFQhodGY03gGJynXYc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=MHM2LQTr; arc=fail smtp.client-ip=52.101.193.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="MHM2LQTr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d2HtYl9XaHn0T0ZHkpVV3ifbsVCX3S476v61Ahl3PtZsxnDzFGl1o5duNhPAERGid/n+PaMXnnLZzRywE/mLV2WRXF+OIfE8WaTirrZ7kasf8rKkxYhw/kStz1AImgEG312TbP6gAPhoMDh5vE+LTWe8fPyj3qsOcL1Z7D7ww4U1mrgBpK3VNjp7prnSOvj0+iZgYt9DUThTLuiunGQZq1F4CH5ZfBz5uPd3LugPYaP/yjHTlGYxephp0BEgH9lL9zo3ocuVpeLc5DKq5NAucOkKO4Kv6pxHjyDvG3neNzLEQQUKA+ZjsjySVpDmgOmWFEYsqHZBT8VyjJ1nyZTrYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0HgXEsMCsaLInWXRHax6PGv8y2RyHZFAZTt3JbZ1iRA=;
 b=UA0rlR2tnEvOe8lFIXklbVoC5kTNcgCXsNO0iYcBw/HZ3U1/QdRq5N+xt5QVAc+YnV/6ffaqCRYrFrQgYTxNneuxTBD+WtE9lxcJYKArNBen0QCrY7hXm9VpQNWKAlWneNwbXFZ/qxQ9Rp3qICc5tkTNqS1M19d3G10WXFhxhhelnuBxbHrQM5Z7FW9XTNWUw/frtru5+MCrDAJfU5EGzWp9tWLuhdffsgbzVyDx+m4wTJdNW5qKoyW2sdLkDWXibcpMPUxCP4dRgnzDlqKwYMHubhgkT9kTabfP7HB0cvJ9DYiMtC/RXNfzReUWzcPl0or7V2jXOzTcOACX4+qnvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0HgXEsMCsaLInWXRHax6PGv8y2RyHZFAZTt3JbZ1iRA=;
 b=MHM2LQTrOkd1BumT+QRXw4K4Rhe2WsB8SE96ke+qWFvIjytwBD8UOAr4emhNFq6AW0qqCsBi6JhEHKikeONGfZRkTVWulGk8Io/NWgunrmlsr7JfJXAsXeKg5GtMMthM7nxAjMgGEWIpLvozyCkGZtmfUDwSjzgZrF6FtxRfVPY=
Received: from BY5PR20CA0010.namprd20.prod.outlook.com (2603:10b6:a03:1f4::23)
 by MN2PR10MB4173.namprd10.prod.outlook.com (2603:10b6:208:1d1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 09:50:50 +0000
Received: from MWH0EPF000A6733.namprd04.prod.outlook.com
 (2603:10b6:a03:1f4:cafe::2f) by BY5PR20CA0010.outlook.office365.com
 (2603:10b6:a03:1f4::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.17 via Frontend Transport; Mon,
 24 Nov 2025 09:50:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 MWH0EPF000A6733.mail.protection.outlook.com (10.167.249.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Mon, 24 Nov 2025 09:50:48 +0000
Received: from DFLE215.ent.ti.com (10.64.6.73) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 24 Nov
 2025 03:50:44 -0600
Received: from DFLE213.ent.ti.com (10.64.6.71) by DFLE215.ent.ti.com
 (10.64.6.73) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 24 Nov
 2025 03:50:43 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE213.ent.ti.com
 (10.64.6.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 24 Nov 2025 03:50:43 -0600
Received: from [10.24.69.191] (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 5AO9ofG31749365;
	Mon, 24 Nov 2025 03:50:42 -0600
Message-ID: <2e5c67a4-5497-4084-9568-575321cdd6c9@ti.com>
Date: Mon, 24 Nov 2025 15:20:41 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ahash - Zero positive err value in
 ahash_update_finish
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Manorit Chawdhry <m-chawdhry@ti.com>, "Shiva
 Tripathi" <s-tripathi1@ti.com>
References: <20251113140634.1559529-1-t-pratham@ti.com>
 <20251113140634.1559529-3-t-pratham@ti.com>
 <aR_-jEam8i1qelAT@gondor.apana.org.au>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <aR_-jEam8i1qelAT@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6733:EE_|MN2PR10MB4173:EE_
X-MS-Office365-Filtering-Correlation-Id: bdbd64de-1f18-48ee-13ab-08de2b3ef24d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VkJESFVvLzNGUXBFU2w1ZjcrWWVHU05HaGF2YUFnYmhqUlNXSTBjN3BHQzla?=
 =?utf-8?B?QVFWek4rdzNudG1VMkk5clJZM0hpM2dubXlJTVcyc0FTYU5wMU41OUk3cGVQ?=
 =?utf-8?B?MUJTN1cxTFNFYk9DRzNGNEhMT0NkajZtbnA1UXRiVHpObGxXZVhmaWp2cWpP?=
 =?utf-8?B?S2JmajdjNFIvQk9MNmhiKy91YXNkQUg5aC9uWDBpdHJlZjVJRnlpVDM5em9T?=
 =?utf-8?B?TFpWOFRyZVZJZGZraGlnMzdobHA2Um5HakxQVkRjL3ZFVi9nK3JDdExtSnp4?=
 =?utf-8?B?QTNuNUFyVm5ScHJocUgvT0JQL0NJcWJxR0MzZ0VpSTEvMHlxbmhKdVZrVmFM?=
 =?utf-8?B?bSt3RzVJRVRJdUpzYS9CWS9hYisxSnN5dUQrNWkxemcwNkRWU0FFdzJvVmVz?=
 =?utf-8?B?dUdna2dHY3FjeDUrM3V4QmltTkFhYzZwVjcwSjZLdTlvMkhrK3VDa3kvN29s?=
 =?utf-8?B?MFg3Vm5YT2VEcWsxUlhDcVAyeTJRUGg1dFVTcElITmVMKzJwNXhlNjdQdFBh?=
 =?utf-8?B?bkZDaWh2U1NjTXgxUWVKOVd1eTV3STdzVmxPNDh0dTRibkRWeTRZK0l3RVNn?=
 =?utf-8?B?Y3VNRDJkUkpYMm53b1ZWallIZ2dhUS9XK21PM29aQXI0ZFR5MDV0ME1sOUN3?=
 =?utf-8?B?N3E0dE9XejJUNkltSW1FbktPNlRvU0N3VG9ST0orTTJmQVIra0RuekRHK0k2?=
 =?utf-8?B?LzRPQnZCS2tuT1hxYTRsTEZmVklkM0RRcER1cGZGdGtjbTlDS2d6YWJLR3di?=
 =?utf-8?B?ZWJZNXJHcFlRZU5JUk1VbmdYTjU2QXNyTUlBdVNGaDFzRjFRTm5yMHlCVWVN?=
 =?utf-8?B?Wmd4d1hUWWtNV0Z0NDJsbFdCSmFOcUdoellxaG9XdmRaS0NzNmZ1dG9CWVly?=
 =?utf-8?B?U3I2SEF4ZmlMT1NXSHhjcHJJN1h1S1dJY1pXSUIxM2p6dlFhYXc3K0JHanVS?=
 =?utf-8?B?TU50Z3dqenB5aHpxZGJybGFqRVc3RHBhcHVqMDJvWld4ZmJpaWhYT29GSkNO?=
 =?utf-8?B?YVh0SnVKSXNva0ZMeFBERWE5N0lIK1JNeUtUVFJOSXdVLzhyeW5ud3pLdlZR?=
 =?utf-8?B?REZURWUzNU9DSm5zdDRjaldzdWtHcFBYa01TcE8zWm9uL3RydE1pZUJubUpN?=
 =?utf-8?B?VGhKU3dyaE85NjNmTkJxVHFoR09GZ05TeTBiMkFiQkVYSTMrYjdtQUllbGpP?=
 =?utf-8?B?SGhPbVpFdTBYb0twTjBlV3BZRFRhR0kvZlE3a3QxVTBwYlRpTnpQcXZXclN3?=
 =?utf-8?B?cGFNUzJ5Wk5DamFOUWkvQTlTT3hjRHFyOUtjMVg0c1NwVGlhYXZIY1hSRWdD?=
 =?utf-8?B?SjVXUEtPb3ovZy91dk9OUmw0VlFBNlVxR2xBSk96STJFaWY2UzNVLzRYbDlJ?=
 =?utf-8?B?aWU1SEJIVUtFbXJKckVvVm9aaXVRd3NITkxUckJCdGlTNC94cTVJaXozWk04?=
 =?utf-8?B?RkMrUmJFK1F5MXpPUFliZzdYWjZ2ZWk2MzJ4Um9SY0lKNUtjUWlZdzJZdzMy?=
 =?utf-8?B?aTBBVGRpS1czenBqUkRGc1ZZUG13TkpSQ0pSOXVIVHVianE3RGl2c3ZrK1Fn?=
 =?utf-8?B?V3d2UXNxSDV4VUREQjVEV3VsYkRIcDdCMDB5ZHZTSTBUa3BmbDJjUXByZFFZ?=
 =?utf-8?B?c0NsK0tVRnJ2M1laVU1SNjlpMGs5SXUxa1BxQ1dDc3RGLzNTNkR0aCsvZWZY?=
 =?utf-8?B?ZnNGSGIxYWYzUVhVRHc2VlpzdUdOcFBkbFl6cUwxT25ReWJmM0FMN0Y5Z1dp?=
 =?utf-8?B?c0hvYWRLcm5JcjlzcnYwZnVvMms2Yzl5RTlTdTRkbWxGS3JteUZ2dWhGM2hv?=
 =?utf-8?B?eVZqQThVeHdUVmV6VldXVUwrYnNISmdTSyt6UW40dktRUWZPMXZpclJqRDhM?=
 =?utf-8?B?STVyS1VId01VZHNVZUIrQU8zUVlNTWlveFRZRml0a2tBdkRVNlA1dGE0eHVh?=
 =?utf-8?B?QUZPbzhsOThYUElKc2J2M2VqWXV5YVVDMEZlSVJiWWFrR3N3bTFSS1ZsRVIz?=
 =?utf-8?B?NzF6VGc3Q0NKdXJxTW1wbDA3MnFwcnVqcGY0QVNHU3N1YkRlUVIyVVNTNjVB?=
 =?utf-8?B?QTVlZFZYaXF5MDlhWE5MS2Y4Vm1MS1hkNFJ1bG04elhZV3ZSMHFyRTFEQnZW?=
 =?utf-8?Q?jiKA=3D?=
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 09:50:48.5681
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bdbd64de-1f18-48ee-13ab-08de2b3ef24d
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6733.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4173

On 21/11/25 11:24, Herbert Xu wrote:
> On Thu, Nov 13, 2025 at 07:30:13PM +0530, T Pratham wrote:
> The partial block length returned by a block-only driver should
> not be passed up to the caller since ahash itself deals with the
> partial block data.
> 
> Set err to zero in ahash_update_finish if it was positive.
> 
> Reported-by: T Pratham <t-pratham@ti.com>
> Fixes: 9d7a0ab1c753 ("crypto: ahash - Handle partial blocks in API")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 

This fixes the issue.

Tested-by: T Pratham <t-pratham@ti.com>
-- 
Regards
T Pratham <t-pratham@ti.com>
