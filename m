Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.56
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795535083;
	b=tPxOi81pf3rlcYSBDpront/TgaaeXI+a73p0djQg8qmKs76IZhg/8MiGEsGQYw2XaAfu
	 eFU3C1kh4kt82vQDKRbRaZrPJlHyvnQHCdacA9Y5ULaQWLMKugB+ypQ3TFcj6ySzMndzW
	 JXUMxUWxk/UpUP8hV5gvfDMhd8oZf09fWTSDk8oPuTG/INnCJ9NYjuHcD1ydq7jOd7mGh
	 INtFfqk3G7nwtZeuXw+1MYfGZ8d/KolPpFbBbBwNOtCG1hc+xX4d3kxC6o7D72wwSJiMA
	 4AoES/Xix/z6heaB2OHONq5jdpzzGXxbYcHDomdFHrOGZfRBY4eOXV6UNaw6RVC1cvA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795535083;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=4p1brzsNY6jQlzdsb8lWFReumC5LUmOhr9ShUsQxot0=;
	b=KildcC5yjACl93lgEYjvV7/w9L5tLS+F7xMg/FfJQ3r2a5NCZ3Gexe1SoXFCv7+KYuO6
	 9OfmKqgFeDT2L8BkQmUS/5SGVEMU0w5QoSIQIo45ZCMCqnq1yHBdtZTyGP+y7kV5+JjDO
	 EhGw4WwtTs9rlbg1h+58EA0cdycggpFP8We5jj51yIMBFW8iqc26ISiyHQFwEkd8ESY1N
	 ZqMRpyi0koJRtjhXXdTc8fQw3xpWopjW2B1ej1B7kihSKppBp+ZDPADxn2b/p7NtbjbLE
	 bi9ZV4cnKV1L4cZ6fX4bCaJY3ynnBtfnQvOMaXrzTdSqo/uKkm7WLhwP8PLecVDr0jA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=ylkPmylZ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.56
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013056.outbound.protection.outlook.com [40.93.201.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A35F606A31E;
	Tue, 24 Nov 2026 15:44:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0A35F606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=ylkPmylZ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gSyzpdC6nJZs8ZnDePzkJl1jfNezxSc8gcIPv4cWENXdg1KaTcSzdN9aKKtEp+1zGxPYVlPt5XUSAorIXESAzK5l6SjWazx9oMiAKgtTnYglIq7dp3yEz+sYV5wbXA+ECoO32fHArkO/vSBqx4Jcf9A/em7wWm7nqy/rC0X4kkUpn3tqA0WMczw8pr2Z7TzgTlofY7qATaQK8QnujjO0ePIVb+FwP3SopW4VnTy3f5aY3I73SoVCCTEHl4HDKJqvjzOE2MgbPDqZi4Bkn4ph2Tt6C+1UmAYz3OJCM6A7eALx3UVViK275JCKfD9rl4cP9sFVOgw8xLMUXUdLcEf12A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4p1brzsNY6jQlzdsb8lWFReumC5LUmOhr9ShUsQxot0=;
 b=jpdLd1wk+G+bGxEET2t0tSkXKqLtLpSmDpqrDGvB9EvTlMSRq5OQYzG7WmqGRWaocKU445frWvhhX/BV1P+su+fj43DLV18p+TYPgPvkL2R/McSX0XSXAi43ok4XfifwQVQ+93NPYVh36eDcXP1vFpb4q3J+Gb/AAk6rhvzX+ETFDjn6p07GpAx+kRfib4dLoXS1Hf5BqpsHvrazNd5+QtWOqlf+BZvgnOw10CDfA5haBkX9CXTl0DGNKdbVY6+sL5CmQC1PqqJEz5TORf9Z2sMMLZJf/nCMKbn+Z+tfMH0uK80Hcdaf/q+o4+XoDWOdmDroUPf4ZjbNGKbmeRXO7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4p1brzsNY6jQlzdsb8lWFReumC5LUmOhr9ShUsQxot0=;
 b=ylkPmylZaPVfJ/T3y5+JUvsSdc3/2O9bXEqO46zbCZKvWTdNRAuV7CcV6exm/ME3giHW01bkgBzQdGOF80xvodXZ2/g2tJSNjxRcfkOyPjzAFt/bLPvMfdAQkDdhjxH30YIqHgH4PZ07aRnxTIIy3d2hF1i/xmVLu81IAecn9M4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by DM4PR12MB8475.namprd12.prod.outlook.com (2603:10b6:8:190::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 15:44:38 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%6]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 15:44:38 +0000
Message-ID: <5a67f759-4c3e-456c-92b6-f375cb58ae8b@amd.com>
Date: Tue, 24 Nov 2026 09:44:35 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] crypto: ccp - unwind PSP sub-devices on partial
 psp_init() failure
To: Kim Phillips <kim.phillips@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>,
 Rijo Thomas <Rijo-john.Thomas@amd.com>,
 Mario Limonciello <mario.limonciello@amd.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
References: <20261116203622.615371-1-kim.phillips@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20261116203622.615371-1-kim.phillips@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:610:b0::8) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|DM4PR12MB8475:EE_
X-MS-Office365-Filtering-Correlation-Id: ab14a0d6-a8c6-4ff6-7150-08df4a41d8e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|11063799006|10067099003|56012099006|261026140227099003|261028144727099003|261022105027099003|261026121527099003|261021121427099003|261022075727099003|261021123027099003|261102123227099003|261009221227099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	2frBjjE+1ZVK60IRTewqbs6bSf8SvYH5BI5RUTVhwgdqZiFGbj9zeOIQGqxBpcnJ39HejMfBMLypn9NBovLS6hHTaXdvoneN9+q/bDbhwfMIQeeR7mqZceYQ+M3V10UG8XYZRfzi/eZawIjKDqmCyk3sRkPxqGgmOGHKD9WsypnXdiFA1KOAr604/AqozxWNKWsdOdNBsQx5qDbI741MbDKBUy9yE2bZ+rhC2Em2zahCIbgrATzF0UZs/dui4KmqhjJZb1DMMgPTGWpFNNvdsUeb933whMMiWHmd4e6fAD+T/kSw3TWYZfOcsfStQ4gbdtHwwOuhCeiJpUSLX2JDlZdtuHcNxCm9KtJ/H1U0DByBi4lw5DO/iru6Bbkr+vy0iZPDA+ShgtMRA4dtiegtuabUi7LoGra9n1ZE8QyxxTI6drzL3wB+MfEQnpDzZi0rCwRC2vd71V/KU5EK+gscxsqRQ0unNY3KVcAy4g0iyAF2JJUX2oHK3K5kc3IJ0J7ORq8MQxg2NEf2VQyV7HMrx9fBtTYdBNK7XIRqeGw1TaQA1n30X1AjY8UlitKTaSnCxtC6vft4zjvOlUr4hfW6/LAp2xRPW4nFF5t8Nr9F1BE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(11063799006)(10067099003)(56012099006)(261026140227099003)(261028144727099003)(261022105027099003)(261026121527099003)(261021121427099003)(261022075727099003)(261021123027099003)(261102123227099003)(261009221227099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bGI2SFVYc3JMSWR0ZGVEYTN0REpnRExnNFJsRVNlQUNHMzZ2QUZCYk1yMXNT?=
 =?utf-8?B?aFZJOW10M1pRMitFSDAwVTN2M0xlSHBLSk01c2l3K3BmYmhLK3NuQVJxVmx6?=
 =?utf-8?B?dXRmL29qLzZPbUhwTlEyRW9SUXFQRjBBS1JnUVZrc1Jna0oyTlZiNCt6RlJ5?=
 =?utf-8?B?R2t5Y3U2UnVBeWNIS3NUcWJXRXc0L2dZWkJ3K0lWM2l5SGt2TitmemFWcnhs?=
 =?utf-8?B?SVlndFJLd1JmdURCamNoRFNUVko0ZWRkZ0RCc1NNUUhsRlNJbUZ0cDc0Sktk?=
 =?utf-8?B?S1p2REF6bzYwNmt2ajFScE5IWFJUamowVFpwVnl4N3FOSVJ1M3hQVmhpWEhT?=
 =?utf-8?B?QXRQeDBodUVhdlU2aW9VMXg2SzA5SzA1L3pvL2VnSTVQTDNCK3IyRFVsN29a?=
 =?utf-8?B?bXBTU3RDeTJQcG1DWWhpN1ZDbEt1ZW5vc0NmOWozMDZUc3EvM04rVmcyajRn?=
 =?utf-8?B?RitrZEVUMmtMTHo0enpSbFczWWJ5ekI3T3RZVHVHa1E5L3RmYzNlWUZhYnFG?=
 =?utf-8?B?bXpYOWxoSHNLZytZbjhJaWFreDJWQURKQVRxTHdZOUppSXRtaEJkdFdmWmlx?=
 =?utf-8?B?T3p0Q202TnpNaWlYMzBsT1RuRmJKdFNVZno3VFFaVVpweHluVHllaUR5d0o3?=
 =?utf-8?B?Y1Q1MUJIWEdwaVVQLzlNS1ExYllIYzBsSjRQOW9sM2h0dWJLdGVsaUZJQjFH?=
 =?utf-8?B?ZHUzTFI2NGh6T2VmeFJ5WkRpSUpUTkw2SFFFcXFQZFB6ZnFyNlMzU3ZuQWpF?=
 =?utf-8?B?RjVCamM4SW92YldPRzZaRlB1VWVPNXpLVW85ZE9seE1nUXF5SkpVcVBFbHhT?=
 =?utf-8?B?eGpqd25UT1Z5LzdHWlpBRXc3cTErQTJhZXR0S0IxS0hpUWV0bEVKZXExZER4?=
 =?utf-8?B?NXQ2ampkV1VqaytaVm5YL1RoZjlyZzJ6VG55U3dwRmk4OFZ5YmdYUmxpUTlS?=
 =?utf-8?B?OU1xbmI4V044dWltM1MyTkNBM2FSWVFNNzJ5c1FwRVFSMU0wQkluVjJyTUwz?=
 =?utf-8?B?YkRWcStVeEhXb3pVc0JzRmN4ajRxN3NYVXY1S1FRdlJJemRnVm9keHdZcVJ5?=
 =?utf-8?B?c3JDUWRscWNOTzVyOUl2R09YQ2pMdm0zRGZCYnRVOXIrQlF3OUhFWHd4cEl6?=
 =?utf-8?B?VlBNTngzQ2JkWWNJSnJGdG1Fd3pOdG1VNGQyUDU3SHh3WVhVYWV6NUpBZHRt?=
 =?utf-8?B?b1o4aWd1UENPMVp0d2hUZFBTYzBkL2lGYUFpUGt3bEg0aVljeitUSmszNi9j?=
 =?utf-8?B?K3ZoR3ZtZnZUV0ozcDFBN1ZtVU1MQmxHV3hMeHc5dFIwZjlLeld2WTYvV2tt?=
 =?utf-8?B?R3B4alkxVkp1T1hUNnR6Y0NiS0Z0ZVpoVzlkMXU2MFNsV1pRdGRIcVZySWpk?=
 =?utf-8?B?NkYxdE5XRXVtZVJrS3BmRjFxY3dpZUUvdU5QUVM0Y2FtaFIyZWJDL0tqSUlT?=
 =?utf-8?B?SWVUeUlkZjZVa0UrNFNydjUzZy85R003M2hlNXRCYWNQVXZFcTNZU1IreHYv?=
 =?utf-8?B?YTlEQVhJWlRUTGdpZ1BacW5kYTVrSUE2cXN0dGdYOTZZbmkxYVVxMlZqODJZ?=
 =?utf-8?B?SCszZ3daekNBZ2lHOS9oTGJzVXFPaGd4eENiUFZVdkNnMURrVlo5cHlXZzR3?=
 =?utf-8?B?Y2pCTUF1VHlxTW5uS2FSUFlsS0xkMXVtRmZFdkQzN09UbVdrakYwdkh4a25x?=
 =?utf-8?B?cVZzTVU0OTRMeVpCVWR2UEpjQUdFdzBZSVdLK1ZQT1lZbzlOcGo2MzdSMVVk?=
 =?utf-8?B?a3IyRFUrU2xDWVNYNnpqSENjelBCZFBMYVZwdDB1ZmFKWXI0SmQya2FmRHZE?=
 =?utf-8?B?Q2FvT295Rml4dHJiTjgxOWpXZWwzRWlaOTNOU3Q2aDFIQlcyS3Z6YmFzdHBE?=
 =?utf-8?B?Q0hLVGJ6ZEs1WXBuR1preXhSeXlPNXpySEdDaE5XeStCUTZPbjJKMmJORW1I?=
 =?utf-8?B?UUtwZWx5b0Q3ZGZrSFVGU0h3UnpPN251RFZkV1diZ0Jlb0pNMTVGeHE1Qlg3?=
 =?utf-8?B?cUozMDBGUTFxSkVjS1pXaVZqamFXdi9LZUc0YmlmVm9TVjBFcjRKRGxwWHE1?=
 =?utf-8?B?QVY0ZE55bDJwU3k2ZEg5M1MyQW90THhBcUgvTnhuZ09XS0YxUjF2d3JsekFr?=
 =?utf-8?B?TEttcEdzNzNRQUEyc0RHVFQyYVpFbytyRTFYaGZ6Nm90UGxOSkN6aERoRW1P?=
 =?utf-8?B?cFNWQm1QeERrWlVGZFdnRW9UeFVuRG5DQW1VUkVuZ09UNUhqWnVROTNyM3Vk?=
 =?utf-8?B?RXFZYzRYUUhLdkNrajBXSG1TWU9QbzVGdzBrRnBuMG0wS01NNGdyNWNhNGF2?=
 =?utf-8?Q?NhyEZKpCHI9SWsCt0Y?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab14a0d6-a8c6-4ff6-7150-08df4a41d8e4
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 15:44:38.3753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uv1AgABEz00sO3NIuC+DdLh3eAX9jHhEmq5klDoIXpOOJlE6SWgd+sjpQGPIAiGtFJVCnoPirfaq75JBwEubZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8475

On 11/16/26 14:36, Kim Phillips wrote:
> psp_init() initializes sub-devices sequentially but returns immediately
> on the first failure, leaving earlier sub-devices registered. Its caller
> psp_dev_init() then sets sp->psp_data = NULL, so the later
> psp_dev_destroy() on unbind bails out early and never unregisters them.
> 
> Non-devm resources such as the /dev/sev and /dev/dbc character devices
> stay globally visible while their devm-allocated backing structures are
> freed by the driver core, giving a use-after-free if userspace opens the
> orphaned device.
> 
> Add reverse-order unwind labels to psp_init() so each sub-device is torn
> down before the error is propagated. Every *_dev_destroy() is already
> NULL-guarded on its own psp->*_data pointer, so skipped or unreached
> sub-devices are no-ops.
> 
> sp_init() continues to ignore the psp_dev_init() return value on
> purpose: a PSP failure must not fail the probe, as the CCP can still
> initialize successfully.

Can we look at only disabling just the service that failed. I think
failing all services and the use of a global psp_dead outside of the
individual service should be addressed instead of failing everything. For
example, if the TEE support fails, it doesn't necessarily mean that SEV
support is bad.

What would it take to handle each service on its own and not clear the
sp->psp_data pointer and instead guard each service with its own psp_dead
variable?

Thanks,
Tom

> 
> Fixes: 33960acccfbd ("crypto: ccp - add TEE support for Raven Ridge")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/bug/linux-0de87f0c-0f5a-4dad-8ef1-f49844eb4cce
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Rijo Thomas <Rijo-john.Thomas@amd.com>
> Cc: Mario Limonciello <mario.limonciello@amd.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>
> ---
> v1: https://lore.kernel.org/linux-crypto/20261021215716.1076732-1-kim.phillips@amd.com/
> 
>  drivers/crypto/ccp/psp-dev.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index b14ce51065d5..3d9341c2876d 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -207,19 +207,19 @@ static int psp_init(struct psp_device *psp)
>  	if (!psp_check_tee_support(psp)) {
>  		ret = tee_dev_init(psp);
>  		if (ret)
> -			return ret;
> +			goto e_sev;
>  	}
>  
>  	if (!psp_check_sfs_support(psp)) {
>  		ret = sfs_dev_init(psp);
>  		if (ret)
> -			return ret;
> +			goto e_tee;
>  	}
>  
>  	if (psp->vdata->platform_access) {
>  		ret = platform_access_dev_init(psp);
>  		if (ret)
> -			return ret;
> +			goto e_sfs;
>  	}
>  
>  	/* dbc must come after platform access as it tests the feature */
> @@ -227,15 +227,28 @@ static int psp_init(struct psp_device *psp)
>  	    psp->capability.dbc_thru_ext) {
>  		ret = dbc_dev_init(psp);
>  		if (ret)
> -			return ret;
> +			goto e_platform_access;
>  	}
>  
>  	/* HSTI uses platform access on some systems. */
>  	ret = psp_init_hsti(psp);
>  	if (ret)
> -		return ret;
> +		goto e_dbc;
>  
>  	return 0;
> +
> +e_dbc:
> +	dbc_dev_destroy(psp);
> +e_platform_access:
> +	platform_access_dev_destroy(psp);
> +e_sfs:
> +	sfs_dev_destroy(psp);
> +e_tee:
> +	tee_dev_destroy(psp);
> +e_sev:
> +	sev_dev_destroy(psp);
> +
> +	return ret;
>  }
>  
>  int psp_dev_init(struct sp_device *sp)
> 
> base-commit: 26ca5f34841f0a86d0883664a1c13be89a01d351

