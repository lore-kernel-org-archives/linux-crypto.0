Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011032.outbound.protection.outlook.com [52.101.62.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046A72727E5;
	Fri, 14 Nov 2025 09:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763111099; cv=fail; b=kjnamclIJqYCZagYcgwh18TCsxd1oZOkV0/8X9rIKZDisnvpSjh10fadoh33wxkWh8+2O8AFdllFYtXPGs2zcjimPJMDwh6Kzh7mF7/iFnFCFyXPURtmbSpFANod8yaEqnZ2rdN9hWGm8Jcb4O5bqJ8hli2duuC2miaoRTkts4E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763111099; c=relaxed/simple;
	bh=dq9aB4luxe5iPD9vLvFvGSE9wZ1YW6eyW9EvgA8Kb8Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=dR6V0ao5+Hpa3cy4eVOR98GAJh9gfCpeOJj4Jz6sPa+RwZ/EcB8fr5YKX43n9+w6szhZE6IpeqkGcWXw8QYwo4pwF07d/mNqb/JFGydCFQhwF0DUPrqXeCHwDVIgTY749WSHH7sYT6cCn0E3qKFOgqVhVTeOjGevuwYgU622efY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=QoKaBiku; arc=fail smtp.client-ip=52.101.62.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="QoKaBiku"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EdwBDvoMEGGxjliQ9q3Az9AFllYkBWnh+rqhSoTlGTj9gNmk5ZSJy5W1ScRgXdebQZfS/V4Ugxdg/Sth2aMU2StL52gfrPhlFrvFKMZ63ov429HPxXhYLA6GR9Lm4fPWaudtHFMAOIQiM+caor1SKlATMqJuRfZ0dt5KL1xJ8nPZxKjpPLHC8gJdJ/NtnQTF/X/c/cPSbiq0ZqbKRG/DGUftFI6UnSg8AZ1IbCJitV6hSYfN2vhnWI/7DlBg6RBcX6FrM6aWq86WwiyAS2cXqyMQGKdhzlUZnvxmA3cqtkqYYACFh2SHx4WEgLWJZcag+2UhS9FsPv9htvYngiITfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tyXjHJ2+gFlRVYGJDg6yBD/3v/zCj4Bijn37qXs3LcM=;
 b=leXHJAsOcLSLJOOzMZ1ukfcT1jgZNmI+xK9ICuVJXC89YylXeMcCpxjlC6lfbV6CyGbgN//7MedxmWtfxY1VwcF38tC5iO4h9OCkhh0daLXjzCANnG3ggTBRT5yEfDvmDf1SQNlTYzHhDY/I84Bpku6WRslqqmNbtEUHPmeIAjPkYhgEdoWiHZekvQGZ40u1qNyS9pnqZDhzaJ1EHLLBJRCVQ79AZyxoVDwov436QeyC+/GiUDwDYowep++OGCxBMOJLsnBFbUO5DPZPNHrilohkCB6yjhh3Ms2iG/vt6HryddGX2urmaHx0R1ssXEHrjE30GAmDqXlC/EmI9N+eDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tyXjHJ2+gFlRVYGJDg6yBD/3v/zCj4Bijn37qXs3LcM=;
 b=QoKaBikuxsiAxmLvvb7lefn0lfFiATDDh0ytG790ZkMv5W0qw5H1Su/XkiK6Rb4xANMfRkoS7oCtlMIWAOsRLpK+pwg80E7xS8aAC5Weixnbv9odwvR/p/w0rI4WgXNUXysxTlq7LQbZOrbXMokItewwrJPB4QZmUDLTUdJli/g=
Received: from CH2PR20CA0019.namprd20.prod.outlook.com (2603:10b6:610:58::29)
 by CH0PR10MB4858.namprd10.prod.outlook.com (2603:10b6:610:cb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Fri, 14 Nov
 2025 09:04:53 +0000
Received: from DS2PEPF00003446.namprd04.prod.outlook.com
 (2603:10b6:610:58:cafe::fa) by CH2PR20CA0019.outlook.office365.com
 (2603:10b6:610:58::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.18 via Frontend Transport; Fri,
 14 Nov 2025 09:04:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 DS2PEPF00003446.mail.protection.outlook.com (10.167.17.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Fri, 14 Nov 2025 09:04:51 +0000
Received: from DFLE205.ent.ti.com (10.64.6.63) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 14 Nov
 2025 03:04:46 -0600
Received: from DFLE203.ent.ti.com (10.64.6.61) by DFLE205.ent.ti.com
 (10.64.6.63) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 14 Nov
 2025 03:04:46 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE203.ent.ti.com
 (10.64.6.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 14 Nov 2025 03:04:46 -0600
Received: from [10.24.69.191] (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 5AE94gsT1757386;
	Fri, 14 Nov 2025 03:04:43 -0600
Message-ID: <f0440e5a-6c3e-4c31-b9c8-1f5ced9ceeba@ti.com>
Date: Fri, 14 Nov 2025 14:34:41 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/4] crypto: ti - Add support for AES-GCM in DTHEv2
 driver
To: kernel test robot <lkp@intel.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>
CC: <llvm@lists.linux.dev>, <oe-kbuild-all@lists.linux.dev>,
	<netdev@vger.kernel.org>, Manorit Chawdhry <m-chawdhry@ti.com>, "Kamlesh
 Gurudasani" <kamlesh@ti.com>, Shiva Tripathi <s-tripathi1@ti.com>, "Kavitha
 Malarvizhi" <k-malarvizhi@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20251111112137.976121-4-t-pratham@ti.com>
 <202511141245.zQcC9EcY-lkp@intel.com>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <202511141245.zQcC9EcY-lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003446:EE_|CH0PR10MB4858:EE_
X-MS-Office365-Filtering-Correlation-Id: cf9dff5a-acee-4da9-c682-08de235cdf17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d1JFSkpFSENLS1ptSTZQY1QyK1habnhHOUcyUUl2NDdUOVYyNkhYY1l2UW96?=
 =?utf-8?B?b0phT09RajZ3Yld1ZmMxU0lGeCtueFpqZElxR0ZpbTdxQlY3NkNNZjZFSCt4?=
 =?utf-8?B?RVFxNU10TUpNMEMwNW1RSlZVTFFSS1pHVXRRK1RwR29LQXpTLzZsaTdXY2Vl?=
 =?utf-8?B?T2EzTUpxN1B1QkxLd0dudWZsc3JsS1Q1b1Y0a2FhdGhnZ1hQZkRZRHRWM2xO?=
 =?utf-8?B?dFUrS1crZ0JPYUJVUVc2VVBkclRtN3prUTlsazZkV0I3a1lONjIwNElKUWVl?=
 =?utf-8?B?NmV3UElIU2hBV3E2R3RjSDVIcmQyRUJWRnRpUE9YallNR2xsSTRJaXFIOHVv?=
 =?utf-8?B?bTNoM3FVb1VsdkREL1lZVTFwVVgyU2lZS1E5cjdOMU5NM1dmc3ZoUWZtOU4r?=
 =?utf-8?B?SVVlZWNBTEZpYkZZdFRuczJyTkxTWVViQmhnQlZzYlFOSWpYTmZKcndzR2pi?=
 =?utf-8?B?RnVPQ3puckQyeDFhcDJ4bis5SUN6bFZ1Rk5yZURCbHgrcWRtcWJyWDZndVFI?=
 =?utf-8?B?SlZjMm9jY2lrSks2L1lyN3dOWFdQYkltS2xEVzI0RWZTVDJ5Z21GL3dpWVlz?=
 =?utf-8?B?dlNEbDdSQndGMXVadkpvMkdsWjI3YjYybnRGdkJwY043ZEZzUTZSN3VZUXJn?=
 =?utf-8?B?eGF0WGJ1TTdKMlltdFJmaWZKZGxxYmt3bUFhd0E2UTRKU0UyV1RVMEIxb0ZJ?=
 =?utf-8?B?b1FYZXQ2N1d0aUJ6NVVSVnZidDl1QXZXWVI2eDQybU5FNFFDQW1YUG9zNFly?=
 =?utf-8?B?TjUvRDdCdkt0RFNpdDdYMVRtQXV0d0NmSU1sS3R2NFdJL05oWG5tOE9YSUt1?=
 =?utf-8?B?UFRLdXRESngvYVM4QTJVYnVtb0tmYVFBMFFaWEVPSVBUR0FrQ2lxbFVFQnU1?=
 =?utf-8?B?NGJpSGk1SVY3L2prZVNESmVhNmRMZFVuTkZRQTQ5UmlMSE1LNktRYTkxdEY3?=
 =?utf-8?B?bWVZcDU1M01LOUQ0bFZibFExMzF4d3FscmhrWGFmQjZXZGpzTEJKMWpnRzBm?=
 =?utf-8?B?NWQyN1pPdWJrMkZBcGpoOWNHUVNYYlZmWk9SOWRzSHlHK2ZPbVlLeExaaURo?=
 =?utf-8?B?b1phV1BkL3k4WFptNWpyQXVrNGJpK1RqOXEvQVRqV0VCazhIMU94ZXBndFpn?=
 =?utf-8?B?WE00bmdJVkZJVTgwQ2VZT2gwSzd1cmJXVFVGeWE0Y0NKTEZyNXJuNzdlN2pE?=
 =?utf-8?B?blU3SHF5bkFxbFhqa2E4M3lhL2FSa3c0YnBzNnZoT1U4ZktCUlBoWXJPME1C?=
 =?utf-8?B?T2phSEVwUVdvUTExcEZJamZTSnFZWjZCd2MvbkVEYy9zSCtSRzhyU2F3V25l?=
 =?utf-8?B?Z1lPb0VSVENCOFh6cGlLTk1NMmxOSyt4NTZzVnh5eEIwcEFSd3FtVEVnOXR5?=
 =?utf-8?B?UGdoSDdtNzZOWjhQWU5CZEFVMzF2M0RFK0htV3AxbmZxRDU0UWk4TGdOK0lO?=
 =?utf-8?B?NHEzRkxFR24xS3NWa0k4UVpSTXF2cUladSswY21uRGdDTTcwS2pHZEVMRTJU?=
 =?utf-8?B?bktNNk1hdmwxWlFDOFhqcDA4SlJxOEgyVmtjSytvZnhCRmlCcHhTWDdKSElw?=
 =?utf-8?B?UUFJby90SjI5UE85UFYwc0RtSFNvY29lQW9OUkRLSW1va0szNUZPNTc1MlpZ?=
 =?utf-8?B?Q1FrSVY4SDBsTEZ2V29SVTlob1YyOUFIcGZSSldTY2diMS9sZVNIMlZ6Y2Ur?=
 =?utf-8?B?b25uR2hMcDdGNUlpS2ZkYmgwL214Z1ZlbFYvZEdnMUlkRC9mUFBURzVvMmNy?=
 =?utf-8?B?Y3htM3ZBaFYzaHUwSklJc3JsS05mR3UyVjRFeHpuU1hNWFhlS0xOMXRwWkV2?=
 =?utf-8?B?d2JGd3l1TTR4ZGFhTXBUcHg3YnJsZ1VYMDRrUUs0Slo4MktCTzdOaGUxR3g2?=
 =?utf-8?B?UWxRZ1VQTjZ3U3ZjVGJKd1pWa2FzdzN6K0l1YnBERDFSako5cEJRN2l1MmZF?=
 =?utf-8?B?NHh6YVhsTmZNOTZueGZsKzJBeGtSZ0tMTWMzWnpGQ3lva0lSczNjejRRazha?=
 =?utf-8?B?N0dVbHJWSE1OS05HZG1Md2p3WmJoRGQxdzdKNkFEZmZ1bWxjV3FESkZpWXNW?=
 =?utf-8?B?VlZxWTRMa0t0WnIyei9xL0xyaTdkWWxWaHB5VUNNbkZybWFLNmwvRGRiN29G?=
 =?utf-8?Q?4G0g=3D?=
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 09:04:51.9332
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cf9dff5a-acee-4da9-c682-08de235cdf17
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003446.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4858

On 14/11/25 12:17, kernel test robot wrote:
> Hi Pratham,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on herbert-crypto-2.6/master]
> [also build test ERROR on linus/master v6.18-rc5]

Applied to incorrect tree. The patch depends on [1] which has been
merged in cryptodev-2.6/master

> [cannot apply to herbert-cryptodev-2.6/master next-20251113]

This is maybe due to the first patch in the series, which was already
present in the tree?

> 
> All errors (new ones prefixed by >>):
> 
>>> drivers/crypto/ti/dthev2-aes.c:573:17: error: call to undeclared function 'crypto_alloc_sync_aead'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>      573 |         ctx->aead_fb = crypto_alloc_sync_aead(alg_name, 0,
>          |                        ^
>    drivers/crypto/ti/dthev2-aes.c:573:17: note: did you mean 'crypto_alloc_aead'?
>    include/crypto/aead.h:181:21: note: 'crypto_alloc_aead' declared here
>      181 | struct crypto_aead *crypto_alloc_aead(const char *alg_name, u32 type, u32 mask);
>          |                     ^
>>> drivers/crypto/ti/dthev2-aes.c:573:15: error: incompatible integer to pointer conversion assigning to 'struct crypto_sync_aead *' from 'int' [-Wint-conversion]
>      573 |         ctx->aead_fb = crypto_alloc_sync_aead(alg_name, 0,
>          |                      ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>      574 |                                               CRYPTO_ALG_NEED_FALLBACK);
>          |                                               ~~~~~~~~~~~~~~~~~~~~~~~~~
>>> drivers/crypto/ti/dthev2-aes.c:588:2: error: call to undeclared function 'crypto_free_sync_aead'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>      588 |         crypto_free_sync_aead(ctx->aead_fb);
>          |         ^
>    drivers/crypto/ti/dthev2-aes.c:588:2: note: did you mean 'crypto_free_aead'?
>    include/crypto/aead.h:194:20: note: 'crypto_free_aead' declared here
>      194 | static inline void crypto_free_aead(struct crypto_aead *tfm)
>          |                    ^
>>> drivers/crypto/ti/dthev2-aes.c:831:2: error: call to undeclared function 'crypto_sync_aead_clear_flags'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>      831 |         crypto_sync_aead_clear_flags(ctx->aead_fb, CRYPTO_TFM_REQ_MASK);
>          |         ^
>    drivers/crypto/ti/dthev2-aes.c:831:2: note: did you mean 'crypto_aead_clear_flags'?
>    include/crypto/aead.h:298:20: note: 'crypto_aead_clear_flags' declared here
>      298 | static inline void crypto_aead_clear_flags(struct crypto_aead *tfm, u32 flags)
>          |                    ^
>>> drivers/crypto/ti/dthev2-aes.c:832:2: error: call to undeclared function 'crypto_sync_aead_set_flags'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>      832 |         crypto_sync_aead_set_flags(ctx->aead_fb,
>          |         ^
>>> drivers/crypto/ti/dthev2-aes.c:836:9: error: call to undeclared function 'crypto_sync_aead_setkey'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>      836 |         return crypto_sync_aead_setkey(ctx->aead_fb, key, keylen);
>          |                ^
>    drivers/crypto/ti/dthev2-aes.c:836:9: note: did you mean 'crypto_aead_setkey'?
>    include/crypto/aead.h:319:5: note: 'crypto_aead_setkey' declared here
>      319 | int crypto_aead_setkey(struct crypto_aead *tfm,
>          |     ^
>>> drivers/crypto/ti/dthev2-aes.c:846:9: error: call to undeclared function 'crypto_sync_aead_setauthsize'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>      846 |         return crypto_sync_aead_setauthsize(ctx->aead_fb, authsize);
>          |                ^
>    drivers/crypto/ti/dthev2-aes.c:846:9: note: did you mean 'crypto_aead_setauthsize'?
>    include/crypto/aead.h:332:5: note: 'crypto_aead_setauthsize' declared here
>      332 | int crypto_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize);
>          |     ^
>>> drivers/crypto/ti/dthev2-aes.c:854:2: error: call to undeclared function 'SYNC_AEAD_REQUEST_ON_STACK'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>      854 |         SYNC_AEAD_REQUEST_ON_STACK(subreq, ctx->aead_fb);
>          |         ^
>>> drivers/crypto/ti/dthev2-aes.c:854:29: error: use of undeclared identifier 'subreq'
>      854 |         SYNC_AEAD_REQUEST_ON_STACK(subreq, ctx->aead_fb);
>          |                                    ^~~~~~
>    drivers/crypto/ti/dthev2-aes.c:856:28: error: use of undeclared identifier 'subreq'
>      856 |         aead_request_set_callback(subreq, req->base.flags,
>          |                                   ^~~~~~
>    drivers/crypto/ti/dthev2-aes.c:858:25: error: use of undeclared identifier 'subreq'
>      858 |         aead_request_set_crypt(subreq, req->src, req->dst, req->cryptlen, req->iv);
>          |                                ^~~~~~
>    drivers/crypto/ti/dthev2-aes.c:859:22: error: use of undeclared identifier 'subreq'
>      859 |         aead_request_set_ad(subreq, req->assoclen);
>          |                             ^~~~~~
>    drivers/crypto/ti/dthev2-aes.c:861:41: error: use of undeclared identifier 'subreq'
>      861 |         return rctx->enc ? crypto_aead_encrypt(subreq) :
>          |                                                ^~~~~~
>    drivers/crypto/ti/dthev2-aes.c:862:23: error: use of undeclared identifier 'subreq'
>      862 |                 crypto_aead_decrypt(subreq);
>          |                                     ^~~~~~
>    14 errors generated.
> 
All the errors are due to the patch [1] not being present in the applied
tree. It should be fine when applied to cryptodev-2.6/master.

[1]:
https://lore.kernel.org/linux-crypto/20251022171902.724369-2-t-pratham@ti.com/
-- 
Regards
T Pratham <t-pratham@ti.com>
