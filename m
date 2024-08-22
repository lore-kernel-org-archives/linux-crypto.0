Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2078.outbound.protection.outlook.com [40.107.93.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1AB2CCAA;
	Thu, 22 Aug 2024 15:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724339860; cv=fail; b=eakMRPiBGjcXLe7tUgSo+pMb5umteHo3+OAhFk8vmBqmozPkIkiyNQJNhW1GOuvGCKTJiwFp6krB1drO5KlD6yHwyCCSvs3S2S/Ng3cYzFuY8C7a385lLvjmlQ0uIVAN36kAnBacfwfgVrio8KAHYUF2ZKul1zoaESTXpOC+Jeg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724339860; c=relaxed/simple;
	bh=48HtDG5uGMw4QEEkF6QDgMfV4IyQQRC2d6R1Ihmb4lQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=O7+FvF3YKKanbCRYrTW3IdOJmoXvVrwOOt+dKBpUnFQtrhVdferD3t9SB3TDiqYUhmfVA8UO7MdkAOJajhegC9e7lzbCZ2Lb6JqSfziHAxy5a1FXGMeXIbsvh2nz9bqq9e1g9sf70TA/1ce4NLn9CBBoQqpRPYnIVE/Ukt62Krc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sdCS3DF5; arc=fail smtp.client-ip=40.107.93.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sdCS3DF5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rhbRAK9OrARRcGJ6cCLWLlqFWNtpdpBMxfbfV2/7lVMmR2sVh90DkEx3QnZY5trRRR3JYk7A1WVFhRIV9AztO2swGIcKBaFcTwiDxgWr9djfEMvkV28KZ4qahRBaTjlkUmwVbaX1bn5Ao6nsAhOLkHgVZjNb4PnQ4diCI+IFkwYLRPf6ynCl6w0qYNy+J50U8ByBEzmlNA1TZXgymXnHWf8UWzaF8BCi6b3VNJxp/lpQ24j7gDTb926gj3uN42N4QB7XbD7SvRNc5rLNc+o7R7bfSBQaBYbIoOey84jed16km1Z+WV9p1jw0gNl4z4Cgvx+uja0+vlz+N0PrT4opgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K6iYCIjKjFvAvb45sY3Baf3PeVqIA3IFr+tLIII29HQ=;
 b=O3TAjXsLnoW5Udx+LGg+WzNflAnMyQIQgqnJW1Vy3AGYW606yqu5yJonG/noOZjLrA30sXxgoeIWQokp6JK3tIRmw+haD8c0qLp2SOM351ZV6XHrJbJctOvBvAno+XNCCXRmwzf9SvD5bBQ0qkUqPi1Szf5vfbLwhIYXyhjnmbNBoDYZRdz7qwAWshB4wroq2xnWzTRS1rNljj3YSOFZ97Cz1/fQUaaxQWgRUas5Dw80twEipkll4aRMqzUsg75zjETNzQ5YgV7N6gdj61kAHyXsLR1ughio6++71h/ZY8kRLTADp51AdpTWaEVA32Ovk6FSlpk+JGgfpx4SIjgNqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K6iYCIjKjFvAvb45sY3Baf3PeVqIA3IFr+tLIII29HQ=;
 b=sdCS3DF57HW3g8eviLbp8V/gtY37RgpA9DonSI9X8Mmp196Da43YKAzgCsiUyEL9Tsfx0GCs5kD6hBWhcCtz8RVexUfhzYg5SVKnYRrEYnRwhwa13Zp9YDcr7d9HMUxUrOeP2iRfQ5yHVE1QljKRvMGPFjIcDxBg2RKi5DHSdgc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA0PR12MB4447.namprd12.prod.outlook.com (2603:10b6:806:9b::23)
 by SJ2PR12MB8831.namprd12.prod.outlook.com (2603:10b6:a03:4d0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Thu, 22 Aug
 2024 15:17:36 +0000
Received: from SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::b4ba:6991:ab76:86d2]) by SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::b4ba:6991:ab76:86d2%5]) with mapi id 15.20.7897.014; Thu, 22 Aug 2024
 15:17:36 +0000
Message-ID: <1c6365b1-c134-d1a9-9fb2-22b26abf1a87@amd.com>
Date: Thu, 22 Aug 2024 10:17:34 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] crypto: ccp: Properly unregister /dev/sev on sev
 PLATFORM_STATUS failure
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Ashish Kalra <ashish.kalra@amd.com>, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>, stable@vger.kernel.org
References: <20240815122500.71946-1-papaluri@amd.com>
Content-Language: en-US
From: "Paluri, PavanKumar" <papaluri@amd.com>
In-Reply-To: <20240815122500.71946-1-papaluri@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0057.namprd05.prod.outlook.com
 (2603:10b6:803:41::34) To SA0PR12MB4447.namprd12.prod.outlook.com
 (2603:10b6:806:9b::23)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB4447:EE_|SJ2PR12MB8831:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c510f7e-21af-4e8a-f641-08dcc2bd8d8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QmVUOVhpbEVQMmV3UDB0NHRwS3dnK0xtbXJSK3BUYUt2WE9TTkhGWGpKVGc1?=
 =?utf-8?B?ZnZqSzd6Y2hZQnQzK1JlWGI3T2hlQXArSEgwZ0hJVmJQYjBNRmpLdGQzcHpF?=
 =?utf-8?B?ZU5pM2EzY0FWYUxDRlFvTDNmeVU1a1dEVEVCZnN1NXVUaVBIck16M1Iwb1lz?=
 =?utf-8?B?alMxbXg5VGM3SDJFdXJTazFiaHVXcDIrRUZyRFR1dTR1NWRlU1pRQ2w2bzdO?=
 =?utf-8?B?dzRvVUtiby9UZk9DQVBsU2JrRGh0RXJJcTJ5QTlrQnZrRXY4NG42U3Npcm1K?=
 =?utf-8?B?ckxKVmpack0xc25GeDNWZWlqemRFdFIwY1dac1FOeXQ2Mll1NmFmbTB2QURX?=
 =?utf-8?B?cElWamhMRWhWblRUSzQ5dksrRms3aDBiK0F2amRmRi82TUlnTDYxYnFYR0h4?=
 =?utf-8?B?bVJUUzF2cFZ6SStQSlI1c3J6MFZIZC9Uclh0MEprNUtDcWVnRjExN2lzN3hX?=
 =?utf-8?B?SE9XQzRzemt3Lysyam1UMWR0ZkJVTXlZUndiSzRObi9zL3RuVi9mRGVhM0Y1?=
 =?utf-8?B?cjVVVFNaT2hjWGF3aTFveEhUOUlZRitWL1k3WkpFTTE1RGRVTWxxSC91MjJL?=
 =?utf-8?B?bWVUQnluamZVbnVvZDNwQjd3dHk5N25zM3NULzJ0RzhyWmtwMGt3ZGFhTnpJ?=
 =?utf-8?B?U0VXd0s0R1ppRHpSS2krcHlydmNMeU84MWI5SVRQaUczYlJMYURuYlE4RTlH?=
 =?utf-8?B?TFVaeWdJdzVBNzROSWw1NEJacjV4WHd6d0pNbU9JaEFaNjRyR3RCYjVEbHBF?=
 =?utf-8?B?d0JGSWhVY2duY0J6ZFBBMFZaenBiMm1rRFVnYU1NV081Rnd5ZXU3UnVSUnk4?=
 =?utf-8?B?RUhwMHFCdEZnbDNMM09WLzlWK1ZzYUFvcnpLY3Z6MEJwWE9zTDZ6ZE1YclIr?=
 =?utf-8?B?R25wUWpWMVNnelBya3FQbm0wRlZ1UDd5b3RBMDgrY1htN2lkZlVmSmVYclND?=
 =?utf-8?B?QW9WS25rVklMS05ad1Z6Z0JDcXdxcnNJRW1DNk00d2VoOHBIa0VtY0k4UFRw?=
 =?utf-8?B?aG9Xb2lheng3em9USytZS1NMNzlDekQ5Zk9qb0JwU0FaVm9rNDdHTDI0aW9R?=
 =?utf-8?B?bGFFT1BTOEhCQ2dCVVBUUGoyVzVCQ2RqRFh5anFQZzB0VTNrRXpnTmNGYmNq?=
 =?utf-8?B?b0g4MkZtYXFrOTZIOFFDSTNWSWIrMXRrazRuN2FRNU14Zk9JU3MxU0p6cmZj?=
 =?utf-8?B?QzV4Ymp1N2pWR0xpRlNPUVg4K1pod2lsa2VsU3EycFRwa21CZy9WanR6WUtO?=
 =?utf-8?B?ZHlObUVPQWppNzVmUzFPcEk2RThiT252VVU3Z3ZIWDI1R0NYaXJrcWVmcFVI?=
 =?utf-8?B?OW83TFZ3djZlU3Z5RVB5cHZvd1Zha1Jxdi9RZmZJa1VVbUJTVXV0cXFGbkV4?=
 =?utf-8?B?Vy9WU2tmS0tUeFFjb2xsVDBsbUhCaHpLYVk0OU5DM0szTTNJNW9BUkdmVDdQ?=
 =?utf-8?B?di9SWDJlK0pIVkh2MDVMMXQ4bjVwQXllem5UYmkwKzJDT1REZnZFQUdUVFh6?=
 =?utf-8?B?WTlDNXRRajNHc21TeWY0OHR3bk1kR05hYXZTY1RpK0dkSmxVakJRN2l0a3ZX?=
 =?utf-8?B?RTRLUUVsVno4N0w2bXgzZE9OZ2h4bXpOcHJDd0VZZTNSWW5lWU1LUUlDeUlG?=
 =?utf-8?B?T3hmYzdrT3VJdTVzQXg1QlYxckQzSHJZcGNPR01oWDdGaW95eW9EZkNMR0Ro?=
 =?utf-8?B?d0JkU0FXcUZJSDR3Q1JlZ1hsQW1OMU1tYVdydHZDRFVVaEcwVVpMWGNtK1pm?=
 =?utf-8?B?ZXREOGVYb2szdEtQbGl0ZjY2Q0RacWpCVm01YWkvbUpQTUVISTRTdVptZEVD?=
 =?utf-8?B?Z3BWTjdQR3pOUHRsRnJNdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4447.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d3NFSk1EVXhmM0xLaUJqN3U4blNhZllZMngycUZRdlZqUm9XeUEzczM3ZHhO?=
 =?utf-8?B?cjArTGVTbEE3cUE4bEQ5NzQxZGdaN3Y5eHhkcWtndVdJUUI5dEJFdTYxN1NU?=
 =?utf-8?B?SzlTeEd6YTU1WmN5QWh0ZE1nQWFnZjduYTRUWXAvUlo4dll2UTYwdFVTZ016?=
 =?utf-8?B?V085QTJEOFk3cE41Tm50eGtGTkFwd0VOWmJWTVBQaFNEMHhKQ1Vnb3N4TGZU?=
 =?utf-8?B?ZlhuNVVadGVpeVBNOVNpOUIvaGovM1k0REs4UDZZL1FNTkVrWWRhbXRXaU01?=
 =?utf-8?B?TFlaaUxPQXBLUEtSeGNpQW9zc2JjWjNJU0YyZWtYMldZN2RIYWxUNm1YOUZB?=
 =?utf-8?B?MW5oYTlYK05VRldOMXJiTGhFelh3MzhkUENIUGpvMlo1ZS9ucU93REIwSlJ4?=
 =?utf-8?B?RFdwQmtxZllraDlCbHluQ2RpbHZmSWg4cGVzRUZnQXQ0enc0OTZzTy8wOEI0?=
 =?utf-8?B?Q0crLy9hMWtZem9QQU9lZ3ZsVkVXSmYweXJQNm12Y2lhSEpMeTRZaXNPanov?=
 =?utf-8?B?MmJDcmxoTXZEbFM4TjdMNnFCdG9FVWhwUjJHWGdyZWdyd0FRQjk3eFZ6VUkv?=
 =?utf-8?B?WE5wYVpYSnFKUGZ3aFgwR29pQlVCbmpNQkhkU0RIY0lLb1RMcVh3bmpCbEFD?=
 =?utf-8?B?eFJPZ2dPdkVSbTVUTU5MamJwUGV0YU0vYkliZm5LVnErSk9RbElkNEprelVX?=
 =?utf-8?B?SHhUaFloOG5hUFV2QThYUUlITzVLLzluQUZkN05yMTlLVVJvd1FpZXI5WEQ2?=
 =?utf-8?B?NDdHQVFUdjhxQzFEemNEM05EaERMSERvT3VKMU1ramlaMGhKc0ZzSWUyRUNp?=
 =?utf-8?B?ZDJ1RG51NlptUy90RUEzUGhNWFBXZEVuQ1Y0WWtrRFgvOXlSZlNQS3FKK3lE?=
 =?utf-8?B?Nm9sZkIxVmZkdW1iVkxtY3pLaG9iNjVUbXVmSkRBMlo2Umg5RzBnVVRhRGJk?=
 =?utf-8?B?RENsWFR4NDBmdUNkRWgxQjRQMlN2MmI4MTNmUXFRbGllbTh1ck1FMGplVWk4?=
 =?utf-8?B?dUVLZzQ5OVFJZm1WMTNtcVM4REoxU1FiVTZJY0RoRlJkU3REWEVndTlFbklY?=
 =?utf-8?B?ZDhmbEl4cjJWdkIwUDNLc0xGKzFjYmFzTWg5VUZkZDREN0ZTdE5wRUlDbVEr?=
 =?utf-8?B?NlVEb005NmJIYnZ2bEFVVjJ5eGVkNEZkaENhV0Fhd2Y0cVUxM08vd1hLTUha?=
 =?utf-8?B?dWJpVnV6L2o0OWUrVGNYT1FQMk8xZFh1NFRiTUZ0Q3dTNUYzc05QWmlNUFRw?=
 =?utf-8?B?QUtRWmZlak5kdC9SYitnN01IcEpGd0tmVlZtUFRkeTZGd1lOWDFtT003VFFR?=
 =?utf-8?B?aU1LRXZZM1ltaWhhdVd2YWZJR05LdjRtVncxSGY5NFBsWjlLQURwenRxbW1y?=
 =?utf-8?B?WG0xK1hLTGYwdkNxNzA0TnE1YUtoUGhzUk80dmJyR2wvMGJVV1pTak1vRTNY?=
 =?utf-8?B?RFJqT0hZRmtKUVZEK1VkQ2R0VGFuNGwweVlsRmpvRncxK0U4aHZaY0xkazI2?=
 =?utf-8?B?VGVEa0hsa2NnZXhuR21teFFhVlRWdWJpZlBiZll3eERQanUwUW5ZSEE5S1VS?=
 =?utf-8?B?bklXbWNGa3hVMlZrYlFOanJVenV3eFU4QTUrczRqc3RMWTZPa0xxUkxFa2Nn?=
 =?utf-8?B?VUp6cEdIWW04Uk1zd0VKQUhaRWcvK3llK3hzQm1TRkpoNGg2WUNncFJ6U1V4?=
 =?utf-8?B?VEo5M3F1elZjdktMQndUdE1kRGJqRGsrMEFKZUlPRWUzemJERVBsWFdkYmxi?=
 =?utf-8?B?bitmNUwyN0w2SDBKWHJtenFxNHUyK1EvKzdBdE9FeWxwMGoyTjdtY0NzOTdN?=
 =?utf-8?B?MmFRZHM4eEtzaXg0SGgwblNFdWxkMWlHL2xjbHFXWGF2aENObmtYOWNvcmo1?=
 =?utf-8?B?czRWSnNLTTM0cWo4akFTM2JXZmxzR3AxdnpiOURYL2lTTDltSGM4NTVCdmpk?=
 =?utf-8?B?azNtNmVqc1ZhWk5nWFJPc3E2ekRWRkRTTUNYbmlUYk1IbFh4NGZIVWxRbjVL?=
 =?utf-8?B?OHZCVVFRcFBwRmRaMUE2b2YzbHU0bHg2WitxZU4xM2p6RjBURmtoWERCcXZw?=
 =?utf-8?B?SXR3V0ZiVEZuU0Z0RFJURlJ5ZkZvM0w3VHl6OVlINnlCOHlBMVFVSWFOVE81?=
 =?utf-8?Q?uISE59zG/yAXm2tOgqcO9lGKk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c510f7e-21af-4e8a-f641-08dcc2bd8d8b
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4447.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2024 15:17:36.1179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5v9SouLnsNpkkX00OT785zaauBpQR6oIlA/dd5TSTsOuv40clYUpgNNKBVxj+UsFdfrFfVUbnHFEEpOLPzRVuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8831



On 8/15/2024 7:25 AM, Pavan Kumar Paluri wrote:
> In case of sev PLATFORM_STATUS failure, sev_get_api_version() fails
> resulting in sev_data field of psp_master nulled out. This later becomes
> a problem when unloading the ccp module because the device has not been
> unregistered (via misc_deregister()) before clearing the sev_data field
> of psp_master. As a result, on reloading the ccp module, a duplicate
> device issue is encountered as can be seen from the dmesg log below.
> 
> on reloading ccp module via modprobe ccp
> 
> Call Trace:
>   <TASK>
>   dump_stack_lvl+0xd7/0xf0
>   dump_stack+0x10/0x20
>   sysfs_warn_dup+0x5c/0x70
>   sysfs_create_dir_ns+0xbc/0xd
>   kobject_add_internal+0xb1/0x2f0
>   kobject_add+0x7a/0xe0
>   ? srso_alias_return_thunk+0x5/0xfbef5
>   ? get_device_parent+0xd4/0x1e0
>   ? __pfx_klist_children_get+0x10/0x10
>   device_add+0x121/0x870
>   ? srso_alias_return_thunk+0x5/0xfbef5
>   device_create_groups_vargs+0xdc/0x100
>   device_create_with_groups+0x3f/0x60
>   misc_register+0x13b/0x1c0
>   sev_dev_init+0x1d4/0x290 [ccp]
>   psp_dev_init+0x136/0x300 [ccp]
>   sp_init+0x6f/0x80 [ccp]
>   sp_pci_probe+0x2a6/0x310 [ccp]
>   ? srso_alias_return_thunk+0x5/0xfbef5
>   local_pci_probe+0x4b/0xb0
>   work_for_cpu_fn+0x1a/0x30
>   process_one_work+0x203/0x600
>   worker_thread+0x19e/0x350
>   ? __pfx_worker_thread+0x10/0x10
>   kthread+0xeb/0x120
>   ? __pfx_kthread+0x10/0x10
>   ret_from_fork+0x3c/0x60
>   ? __pfx_kthread+0x10/0x10
>   ret_from_fork_asm+0x1a/0x30
>   </TASK>
>   kobject: kobject_add_internal failed for sev with -EEXIST, don't try to register things with the same name in the same directory.
>   ccp 0000:22:00.1: sev initialization failed
>   ccp 0000:22:00.1: psp initialization failed
>   ccp 0000:a2:00.1: no command queues available
>   ccp 0000:a2:00.1: psp enabled
> 
> Address this issue by unregistering the /dev/sev before clearing out
> sev_data in case of PLATFORM_STATUS failure.
> 
> Fixes: 200664d5237f ("crypto: ccp: Add Secure Encrypted Virtualization (SEV) command support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 9810edbb272d..5f63d2018649 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -2410,6 +2410,8 @@ void sev_pci_init(void)
>  	return;
>  
>  err:
> +	sev_dev_destroy(psp_master);
> +
>  	psp_master->sev_data = NULL;
>  }
>  
> 
> base-commit: b8c7cbc324dc17b9e42379b42603613580bec2d8

A gentle reminder,

Thanks,
Pavan
