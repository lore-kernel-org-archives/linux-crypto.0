Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010005.outbound.protection.outlook.com [52.101.193.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAD82F5492;
	Mon, 24 Nov 2025 09:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763977682; cv=fail; b=RgIVhuFBZIAv2vdzQauwtAvIKCMoAzOXcypregSNd69K0GK72ON//rJuUeAPGoiQvTFApoDAdneYQYYZNz0ZbQspJimgmcRAdCKy7PBfVXG8dq7BVfJQDiCpChfqpyqAu1kR0Hfyi3s7khm7j0PaNwaAEiSS2uSkrZdAXp/1EwU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763977682; c=relaxed/simple;
	bh=UWmlhM95VfqVW8W+kyrHhdRbcaj7zB8BhKxwp3ZOfk8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=j45jaQoDl2GbTxtpfgPYD+05+/zdOW280p10c/2UQ29uq2WpcE5eAECqXrd3ag5CWsSLieMj/IT3ZYdw36b8BPUietfoKkg4bxWWFu4GfbrNrU5V0WQaQZfOKgD+NbcSkJd+KbiqY88YKBaUgQpfxB99zdWtVeVRsNzZRgt+M2Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=ny+lHRqu; arc=fail smtp.client-ip=52.101.193.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="ny+lHRqu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PRlZ+XlR/5Ft45OAw8SIAj+cGHV1z3DdxTx9Vz1cPbvvXNSzRBbifOkQI47calV7Q9iWVxvOh2Coz7KbivRylbP8hgLLmhYrIDQQDfb24ir89WKGWZf8a2c9C/ycQ1TWCWF+TaWpixINh29Ngj3AraV4Aye5dZfuYDx8QxFHqjPIoXs5zAHQMxAEdW4oriVpyct6IB245TQMxmTaQuXS0fYCN6sf0NnKqt66GELyyxRB666nwHDlldtH7/v8jeYJYFo5SVCyN3TgXYIkDoSz1jV5Z8k3dWyXRSpmJlZL/NXmyuEyQ1S9OOTOQWzP2NRIg/Flyo0WCxA86xAjEg0WAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yLCu50CB/fDUp/vXBu32UYfbIbC/0TKnA8TugFqQGPU=;
 b=gD87yJ2tEDCWiyCP64+/HofW43tt5IBE/B0oDFd926qPZo5BJlU1JSurSOTePhiOf1rZTBs8EiIM2BcOTVTIN5KXsHOjNLOcgUD+rmltKDn9lreQlOFK5l7/PnpFVmqNhLroQh5P9DhdBSKdBIxva6Y8tjvUK/iKr8LjnKQmKibhacyjBMSM4elgCvoATZ+IUsd+MF19Wqg46T/9+Mcb6/teRzf4XV5YTPOqYiIxV7SmbLv7FTALEBYdfx51NEUl3aIHNo9tqJ6tbsOLLtezXVGLWqsmqJKxIhVaXgIUFsXfGmrIjW8nsw5PXmUr9m4h3cYmGSp1GcGOOJ8t5hrlUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yLCu50CB/fDUp/vXBu32UYfbIbC/0TKnA8TugFqQGPU=;
 b=ny+lHRqubnyaQCftF+exnq1SQY5oHYiFFvwsh0GKao9bbgUd7rjG4ZFTH6sG6a7s6klwm2K4OX9fK3DrDPNFC8OdJZbyi9+LmiLzyqpMVR5WLNU3wSNSv+GvrFWwvir7xulhKpKbH5CeogOriqV56fi4qAqza3Z3EdXy44HJLI8=
Received: from SA1P222CA0174.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c3::23)
 by PH5PR10MB997733.namprd10.prod.outlook.com (2603:10b6:510:34c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 09:47:58 +0000
Received: from SA2PEPF00003F67.namprd04.prod.outlook.com
 (2603:10b6:806:3c3:cafe::5) by SA1P222CA0174.outlook.office365.com
 (2603:10b6:806:3c3::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.17 via Frontend Transport; Mon,
 24 Nov 2025 09:47:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 SA2PEPF00003F67.mail.protection.outlook.com (10.167.248.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Mon, 24 Nov 2025 09:47:58 +0000
Received: from DLEE209.ent.ti.com (157.170.170.98) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 24 Nov
 2025 03:47:57 -0600
Received: from DLEE214.ent.ti.com (157.170.170.117) by DLEE209.ent.ti.com
 (157.170.170.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 24 Nov
 2025 03:47:57 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE214.ent.ti.com
 (157.170.170.117) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 24 Nov 2025 03:47:57 -0600
Received: from [10.24.69.191] (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 5AO9lsGv1745718;
	Mon, 24 Nov 2025 03:47:55 -0600
Message-ID: <890ea55e-c6b7-43ff-b9ca-423bb7fe4979@ti.com>
Date: Mon, 24 Nov 2025 15:17:54 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ahash - Fix crypto_ahash_import with partial
 block data
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Manorit Chawdhry <m-chawdhry@ti.com>, "Shiva
 Tripathi" <s-tripathi1@ti.com>
References: <20251113140634.1559529-1-t-pratham@ti.com>
 <20251113140634.1559529-2-t-pratham@ti.com>
 <aR_6Q4yjEzsQvm4c@gondor.apana.org.au>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <aR_6Q4yjEzsQvm4c@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F67:EE_|PH5PR10MB997733:EE_
X-MS-Office365-Filtering-Correlation-Id: d49b8e68-2a98-4437-eb6e-08de2b3e8caa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QUFxVThUMXBwTXFIeVA4ODEzYm5IcjcwVEE4bUxJQU90bGFpdEF3eS9ZOXhZ?=
 =?utf-8?B?QXlwa2ZYNHpmaUkwc1ZVQXdsZDdJQnJ1a0MxTFlOUlpQbW9PRU5rN0hUZ0E4?=
 =?utf-8?B?NFlSN1cxNmJhaGoxZCtDWjIrOWVnak5oWHhWd2YwakVTNXM5cFFYQldRK01i?=
 =?utf-8?B?RHE1Y2sxblNrQVV0eEhVTklQcmRKd1dVMmR0dkpOY1p3V3BVd0NRRHl1QUov?=
 =?utf-8?B?S280eDNPeldrRnIwUm1JYXFjbjFqcTc0M2IzY3Vub3VtNXRjK09DRnNxVlZu?=
 =?utf-8?B?SDZZb0dYT2I3c0x6MkVTakFpcWRyTWhJV0pBNHh5K29hcmhiK0lNaFpxMmlK?=
 =?utf-8?B?dEdGa2xuU1lqT1BlbGEvR2s0bjZ5L2gweFk2OS9UTlAxSWd4c3lJZURuYXhI?=
 =?utf-8?B?b2ZsUUhEbWZMMDdFMXhNV0xucFM1TlNVU2xXenBnVkdoVU9uMEFmWStNQkZT?=
 =?utf-8?B?dzBtWnhEd0Iyc29QU0tmRStXb0tobXpMUEJBdVpYdFgvQzM2ekgzSW5ZbFBL?=
 =?utf-8?B?QjJtVFBSdDN4eGF0WjlhVFBOcWlPSkpmMENOK3E2NUJPVHBQUDJ0cVRMbXF6?=
 =?utf-8?B?MkdYMFNDQ3M2MjNNTVJzemd6clN2UlpaY2crNDlueTZnM3NKdWlzYnhaT0ts?=
 =?utf-8?B?dDBJMm80dzRCR0ZtWGJCZDFsc3JlSXlORzFkK1ZNWGtpcFhJNnRrdFpUMmVn?=
 =?utf-8?B?M0Mvd0doOVNXL1pmR1JlR3JHdUl6RTlobCtsWVY0T3hzd2xzSHJhMVBNazho?=
 =?utf-8?B?TTcrMGoweDdHcDB5KzM2YjNXZStDRmhCazRqRWJtTGFPcXdlS0ZwcUdiK3hB?=
 =?utf-8?B?R0UvKzdieDFzVnNrNUt5eHExU25QUVRMOHdBUkRYTjRXTG4wT29SUEZObER6?=
 =?utf-8?B?RzNrSEduRWgxOFp0TGplTXAyOTVPaUlia2xadTVkRnIvb1YxZmdsbzVCRWxY?=
 =?utf-8?B?Zm5HMXd0R2doRzQwR1dPalZob3g3aytXMVhCZmtKVm15M3ErV3hKVy9MZWNQ?=
 =?utf-8?B?NXV6S0NoOGpiR2F1dkxHcFZ4U0lQZC9zVDZOUHRyYTU4SmFacVhaRmZWR2dQ?=
 =?utf-8?B?aHcyUzFqR282c1lyeTZJR1RvTFZjU3IvNUNTcWRmYVg4alJkdSsxTThMRVds?=
 =?utf-8?B?WDdKM3lTRitFb21wakVXZmFEVEE0d0tKMzlxcWhFZjdGOVVmZGFQMEY0NEV1?=
 =?utf-8?B?L3ZYb3lMVnlscnFyaHNtVGpSRkt0SFl0K3M0cDZEY0Y4NUJJWWFrVUhIQTJK?=
 =?utf-8?B?UHliUmZUWGRjdHRuQ3IvVldXaWJCeGxxQ2QzT2paeWNXZi9CZE5Qc2NMQjVT?=
 =?utf-8?B?WmtvbE1SU0FNR3p5M00zVlJIRzMwSUV3RWNld1Q3WWdyc0QxSk41cjRybEx0?=
 =?utf-8?B?aXZDWDY4MUJkc1JGZGpBc1pseU1nNXZvTjhKVndBNXR5WG54eEM5Tkk0RGpt?=
 =?utf-8?B?Z01RS29kSzAzWUh2SjEvb0lIbDFQai96SmJCR1pmZnVrYjMwR0NDZ0RiMGdP?=
 =?utf-8?B?Wno3MWxXUXh3SUpPMkNxbS9qS1Z1MHJHcENRMEhUWFNaODBNaDVJQStDbVBp?=
 =?utf-8?B?ZTNvVXVjSE9JM1paME5aSldHdm0zWUpyZkdFWVp0Q1VCeGZIclBqcmhwQXhD?=
 =?utf-8?B?cmlCTWM4RTVYODVVZmJuVTRCWG5ITHJFQXBlbUxRaExZTFZjbWZqRWJ3T2Fw?=
 =?utf-8?B?MERCNk1xNTBBM1Q2eUdMSzB0dGJHQklILzhTQUo4bnZnZU1yZGdEMXkrRkxh?=
 =?utf-8?B?ekU4b3ZHVGs1amIvTkZGKzZPcU5hMXhpeFJlV21NbmNGRkhvdU5PcWFyNU5H?=
 =?utf-8?B?ekRiQk1CVlpWbDN5TXFDbGY1eCtEcHNkOUhDUUxwbVlSVHNiaUNzQ0M0QW5F?=
 =?utf-8?B?bUJTTGZSeUJJSzZiWkExWHFRKzlCeGtQOVFESG8rcTNselJwWWc0QjNIUkVx?=
 =?utf-8?B?cXVGdGNqZE5HZlY3SDlqU1gyczUzdlZnLzNLRS9wTWlTUXdPR1h2SDVpU2VT?=
 =?utf-8?B?L2FmWWNLSWZkeXd6Sy94anMrSHhBbG90THdOdW5OTmFYVEVlaHh6TjJWc2cx?=
 =?utf-8?B?c0w2ZlQwZW8xVWVlRGVzTVR3Zis5YThpVUExeHNXdUNpTFk1ejBiazZkUGps?=
 =?utf-8?Q?9wBM=3D?=
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 09:47:58.0417
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d49b8e68-2a98-4437-eb6e-08de2b3e8caa
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F67.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH5PR10MB997733

On 21/11/25 11:06, Herbert Xu wrote:
> On Thu, Nov 13, 2025 at 07:30:12PM +0530, T Pratham wrote:
>>
> Restore the partial block buffer in crypto_ahash_import by copying
> it.  Check whether the partial block buffer exceeds the maximum
> size and return -EOVERFLOW if it does.
> 
> Zero the partial block buffer in crypto_ahash_import_core.
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
