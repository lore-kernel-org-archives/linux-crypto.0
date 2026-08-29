Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011015.outbound.protection.outlook.com [52.101.57.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93494382F03;
	Sat, 29 Aug 2026 15:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788016085; cv=fail; b=h0ry9IK6qxJDSplTSnQ5Z5a+MSmGH6zd9pqXMsV4EEZMQ8OxDTI57ZiQepbH3HJmLtaeXyvJsFaxxs+UHnd/JDujtgoyr7tqDxcXfaJDp0ZPmsmUqRlZ3VAYcPSiyQta+Y14qDvlosRZUlGIYmP5/p8hTLMWOIhBg5I+P2TQ94E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788016085; c=relaxed/simple;
	bh=fAWQAi8Bf0+G0X70kolOo5BvJmcy2vmoL6XGw1bwDqA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FSuao+Camx3Fhtj1T+xDSCPNuBXAYqngJLvLnAsAC2r9I5QYdwYAJHe1373akmZh8GkPyQd+Q44JSu6zGvNY/W3RKhBaCfR+rWmCtvsFYvNlsGqVQU957R9FkK2XdmgaXL+rahimjtMjAWi6/NvU/50ITeRFfrguBfbnM+C4Bss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PMGwYfJO; arc=fail smtp.client-ip=52.101.57.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PMGwYfJO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BTfIB4yLVEib+GE9ORUdgyI+Fz2KLYzs6scNarzL8ugqRfps4zFUj5llp36vFuvJL6oqwH6p4nQSPqTJRGTmdr0PNafkVJSj5ya6nq8hm2KHisovCAlzxSCCZS1kbB9WqzwB4YCqJ4uxX20712yDFth9DRFAVDUywOZ1Fov9KKpDMclGanqGUAHGTxpQxZ1z1Pcsfkzo9zQ69ytJRC31neX3D9mcxgJ2ulQN6s4rY5XEshmvnRuh+cgBRQmWBvJq5myDeJTklVBqQ/vPBZqWKYQQ4LKS2PV892dfU5s7TOk8CFRJKtrxCVtvhJqFPJCfuHBzpbBO2rC8+KdKqOaNww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g6alh7U1JJwHPfTATb7dW6Il5QcrUB3zUGu9aemhrvA=;
 b=gOnsQBQ2KOSOM8qIz+jYOODDoQj3RIkGIfoj0okuL+D6+bOYd20hPyeMcUes1TaGCWOmtiRGt8citFwfB2Ne4EflunK0hUNghM4VX4fhAPtImRQK/JnBlT0N66Ij/WhQhP3YEjSI9vLlI4mCX324nAoe+ly0ZfRbUbJEOnhgz8SyXUyqVR36gcDaTVPZOXE8QLPWOBFAKWwZN+wa4SOcs5ddIIyPIZv9GpOeAz+NxiNTdX5y9GWflouXNJAdo9GY+VpUSe+2SmoL0ogn0EJsU36V43enjdedXmRShLyEyb+oRvAXHcyeOQJKAVS6yQoglY04bjHu6Pv46816QGYlEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g6alh7U1JJwHPfTATb7dW6Il5QcrUB3zUGu9aemhrvA=;
 b=PMGwYfJOMAIxtSeKn1JYtgl6ex9WMJUC1SzqwGsax/lmKnF3bSy2zTVUos+cVA3O79ARWEL09E551ATJDpsNPIaE/Dnj2l4FPn1skoqejDsKt3Y6AUPfrSE8CAAuc1shxhcUrZF+LxA9NO74RRZofIBER/DlD4o9Vzn2Y/qGWqE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by DM3PR12MB9287.namprd12.prod.outlook.com (2603:10b6:8:1ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.12; Sat, 29 Aug
 2026 15:07:59 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%4]) with mapi id 15.21.0360.008; Sat, 29 Aug 2026
 15:07:58 +0000
Message-ID: <8a00da60-ccdc-4579-804e-0c7d7c12ebe1@amd.com>
Date: Sat, 29 Aug 2026 10:07:55 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ccp: Initialize DBC ioctl mutex before
 registering device
To: Runyu Xiao <runyu.xiao@seu.edu.cn>, mario.limonciello@amd.com
Cc: jianhao.xu@seu.edu.cn, john.allen@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260829133410.1708684-1-runyu.xiao@seu.edu.cn>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260829133410.1708684-1-runyu.xiao@seu.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR07CA0037.namprd07.prod.outlook.com
 (2603:10b6:610:5b::11) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|DM3PR12MB9287:EE_
X-MS-Office365-Filtering-Correlation-Id: 45599b5d-766f-43b1-27be-08df05df4fee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|6133799003|10067099003|5023799004|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	K6CJHnFgsAmEKo2F04RRsAT6Az20zBcCPYtnPYhvG0vcwIeyWOwqlTomd9nLkfG/CFvXoCXQgqLTNZzLTb/q6OI6RMYlih8ltCDfNJ9MCT4tybR6vsXzAzTmO3+2+pNMQZf3NS11NCpNB/HG9mGxIjHsliXpXjw+XGA9Kj+ogXbpJ5ryjjo4GirtLsyAcdcO9S0HhHYgEx46Ib5kEpods2Vrt/s3HP9NIuKv2ryaXSgrbmZSfNAwFDjVrtWMoaV5KQVOsA+sBF+6prWKfv3i+9hCbQDppkTGl0bkj9VdZG5m8uls4gMmLN3OCJpfdA6bG3wktFQGJOHkQSFXm+IrD8FbwYKQpJMfybLdUAYMW2Q0vUsbJGwwLOxMIocwJsLvIxZKjtBfxPmd3PAvyY+YvKoB/qOgnBoEfXsLEn1Z+MvX288dlYqwjgu4U0A2vJv+O5Xf5E2FmP6WLfpFD7d3IP1SQoR+b13b1g6wdhCdUxQ1Dh/hJJML+bto5mh/399arb5sB4Ah7mlwAo+KSNM7Mw8j9MsFNpZz+vfaXtKPBWfMD9kJiGk8m+81WDmW8aEKj+wUqoGFyiMdZ9VTrcBVTyO/GCi3jYyOQkGg+J4uhOxTtWZEHtvA8L08Ni80iZ6pl6h7N1FV6TV4U6DwdMwqIdHG2E9wAfRb0e8VPIIwJu4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(6133799003)(10067099003)(5023799004)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SnVtbkdkb2tFcTVBRmhjQ3BQNzROV3RvS0xYcm1zSnI3aTZhNUZjc1NpOFdz?=
 =?utf-8?B?WjFvNVJDL3NteTE1MmxaSXhMUnBuSlFEOEpNMjg0bXFyNlZtMTU3c1VzS0xy?=
 =?utf-8?B?L21HT2Q5Nm52SERLdWFmay8yZjFtOWlhVENGajc5SVROZTNKSGhzUVBSaC9v?=
 =?utf-8?B?dEw0RUhyTTdTU1lNemtkcjhKb3g4Q1VOT25CV2grZnVKTm4rb1hLcEVpUW1Q?=
 =?utf-8?B?YjB3dHpqUVNuTklzb09CbHM5dHRSUkIzKzI5UHR2dXhwR3RWeHBvRC9GYkRp?=
 =?utf-8?B?S1BFQ3lDajFiNUs2U0NpUlQvdVI1NnBWNkJKQkdnT0k5WlVZcDUwQ3l4d3FZ?=
 =?utf-8?B?ZldmVlZVdkRNenh1elVlTEY3UkFoeDNNQ0dzajRILy9YcEtXNG1aOFZObklp?=
 =?utf-8?B?cUtWOE1INVJCNG94UlBlYTB3RFNiNHVxRHp2Y2wrN21Mc1ltL2ZuSkVUY09T?=
 =?utf-8?B?MjJzNlVNdENwWit6aHQxTlR5RDNlOE9vYUhxdWZOSGNaSi9wUUNpTDdCVWhx?=
 =?utf-8?B?ak1CcXNoSk9Sc0JoVmFsM0hkcVFRejI5TnhBaU4xREd3aUZMSmJ6MnFsZ1E4?=
 =?utf-8?B?SldUZUVMMVdyYktOTFJYZTZQOXJXbWJMaVdmZmNHMDEzbHdLUkxIUWdzL1pz?=
 =?utf-8?B?STRUVFIyRUs1MWFuUFZYZzRkYlVlZjRDTkZtZXlHNlNqOEpOMlJoVHlXN0lm?=
 =?utf-8?B?c0dBOC85cVhteDlFaDlRbTNVb3gyUWFVV1RLU3hVenNpQUJNdlZrTFVQRFoz?=
 =?utf-8?B?TkVGcXBhVGVJSHhCWUEvQkFLTTJLMkdNV2pwcHhhVmVBeXUwMmpWOSt0NnFM?=
 =?utf-8?B?ZXhaVW5VN2k4QmlMVHcyekY0YjhUcStFaFhDbDVoay9mbERtQ3JQYWtib3lC?=
 =?utf-8?B?Q3JkRURUdXE2YkgweE45VFdzaG9NZFE0b0J0YVNIQUtZd1hEVytCMGVybVRD?=
 =?utf-8?B?TCtXTHV2dkRFalZpV1FUM3VUQTQyOUZWcjdkVkRNckNwd2taK1BGNFVXM1B4?=
 =?utf-8?B?c0kvMi9sT0pGV3I0QmUrbnpLL3YrdDd3Y3BiQ3dkNGswWWNYQnExYWYwdExr?=
 =?utf-8?B?WDg2eXdCK2pVRXgxcUJCTkZZaWVwZVFVR2dNMGRFM0tSUUR6b2hsSmxDbGZw?=
 =?utf-8?B?ejY4TDJUdDM3YXE0djhrQmRnN1dXU0NTamJnRkFOZUhvYjgzOSs0UVg5Z0to?=
 =?utf-8?B?TkFRbnhCc2RyKzNZbG8waHNDR09hdWZGdTBhVm1DYVJXVkk3RzdDbTd5UUd0?=
 =?utf-8?B?ZjJPMHduVm5jUkxDeVYvV1hiVTB3eHN4bmtMWlJRcmJXbUNwQndYS2FET01r?=
 =?utf-8?B?Q1ByT2Jady8reTJVQ2lRY1Rhcy9VZjdZb3JDQzRDa2lva3l0Rmd3bzk5bXNK?=
 =?utf-8?B?VGk3d29RVENBVDF0OTR0M001SGlhdUFCZW5hK29TTmtZRDJmNGdpaEZ2ckJQ?=
 =?utf-8?B?bTZTN1ZWeEJXWnpuYUgwS29NZEUybTZsa3JITVQxVEVsOU5EOWhWOEJWMFJx?=
 =?utf-8?B?bWRiZ3B0SFZ2NEtsbXhlempRanhPZUVKQklyVks1cHhOdHdUWjlubmdMOHpX?=
 =?utf-8?B?UFgzbnJoQis5NVlFSVh5Tnl3V09abmk5TC9jL2Q1K0g5Tkk3cWdUNndUVUhv?=
 =?utf-8?B?d3RvWVBkRHZLM2NJTllNSWtaUllIazVZcnBwTkU4VEJXT3ViWkNqb0tRRVdq?=
 =?utf-8?B?OWYxNkIwTVhsbEVxK0kwaTdXODloV0ZKMDlGR2hvZmptemtoVVFsYXRYT0N1?=
 =?utf-8?B?MmJrQysvcWlwcUlGV1g2WHduTkd6SEN2b1krenRvRjB3dmFHUWlGRG9xZ0FK?=
 =?utf-8?B?YXhxaWJldG5pTkFkSjViVm5TTHdiT2RXa1dMRU1CTzZ5RWRndHpMTXNBSXpZ?=
 =?utf-8?B?ancwTXRvY2hRVkdneTRDSCt3Qlp6S3pycndYclI3VFFmMkZQSkE0WG9ISFZx?=
 =?utf-8?B?VUdWcllDSHpnT0xUR3BJejcwNTJ4SS9Kd2p4Q2VpTlpNblZyZjd3Nkl0SWI4?=
 =?utf-8?B?WFAzUXBVQjRTUkZ4LzhUbUlxdi9OYmFNN0cxelVXWmFDUkxUUnJDLy9oWEU3?=
 =?utf-8?B?UkNJV1pmWnNHSUdSUXB3cEljd1BwSUdUMEN2UlFSYXB3dW02K1pRMFROdXkw?=
 =?utf-8?B?d3d3YW83MTM3b0FFNHdQSFdPbTFOTitYN05XVHZKb2pTVHZaUGNHK3pKTVQr?=
 =?utf-8?B?VElGUWtkejRxOFF3eTZjdThlT01DdnljMzRLRWZHNGxJNVYyUXVlaXdjcGtI?=
 =?utf-8?B?YlRtcHBWQnBybUxNNm4vanFmYXlOdXFCM2lYUG12OU5SNHU4YVdxaXVSR21G?=
 =?utf-8?Q?EeYyxe6+kFBfL36r20?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45599b5d-766f-43b1-27be-08df05df4fee
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2026 15:07:58.8137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S7WY4hE3GQtOppsdYyZ7ZFGC9sJ4Vaw6Ai/Ii3tsU/8OqhMVWxoHBYvU9Ur1FUbFkP6cJLgnQOMyxDDxTglMPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9287

On 8/29/26 08:34, Runyu Xiao wrote:
> dbc_dev_init() registers the DBC misc device before initializing
> ioctl_mutex. Once misc_register() publishes the device, userspace can
> open it and invoke dbc_ioctl() while the mutex is still uninitialized.
> 
> Initialize ioctl_mutex before calling misc_register() so the published
> ioctl callback always sees an initialized mutex.
> 
> Fixes: c04cf9e14f10 ("crypto: ccp - Add support for fetching a nonce for dynamic boost control")
> Cc: stable@vger.kernel.org
> Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
> Assisted-by: Codex:GPT-5
> ---
>  drivers/crypto/ccp/dbc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/dbc.c b/drivers/crypto/ccp/dbc.c
> index 410084a90..00c864413 100644
> --- a/drivers/crypto/ccp/dbc.c
> +++ b/drivers/crypto/ccp/dbc.c
> @@ -240,12 +240,12 @@ int dbc_dev_init(struct psp_device *psp)
>  	dbc_dev->char_dev.name = "dbc";
>  	dbc_dev->char_dev.fops = &dbc_fops;
>  	dbc_dev->char_dev.mode = 0600;
> +	mutex_init(&dbc_dev->ioctl_mutex);

This mixes it in with the misc_register() settings and the call, move it
to just before all the settings.

Thanks,
Tom

> +
>  	ret = misc_register(&dbc_dev->char_dev);
>  	if (ret)
>  		goto cleanup_mbox;
>  
> -	mutex_init(&dbc_dev->ioctl_mutex);
> -
>  	return 0;
>  
>  cleanup_mbox:

