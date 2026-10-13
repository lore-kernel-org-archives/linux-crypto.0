Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012060.outbound.protection.outlook.com [52.101.53.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D976448B83;
	Tue, 13 Oct 2026 23:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791933877; cv=fail; b=N/yY3Z4ZAlDiG1oHUWGgo9bZRnUeTuQRnjWAME7p4QSdKqffJ9JR7rJiak2bvsMXYcJvNS0L7x04uMgd/yL64G3eFgnHGtpQzeCH/spEJiSRqWYjg7NJfHfz2ap7bQwRyTRKuNCKnkUxqIUQ2skYGt2CZPiGOQu3KxvAl6LBT3k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791933877; c=relaxed/simple;
	bh=2iBoWPcp4l/HGsgU+C1E/EC0zENrEzj6Ivf/bDUkU5w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=o7PiGb+HTLYpYc6H/64RBjLH3upSoGIa6ji6cyJMSS+ujEo+jPb76xKkVkqSwogHela1vwPB2efJzX5oxrZtr1ZVg3u4UegvAsg9o52anJltgcJ48Bw3U2pHQ/Hg+OCV+tJswi0JB61KgianJxRzrAizlBJAX3eTKtI9Ln5TxEg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=u/5nfBVo; arc=fail smtp.client-ip=52.101.53.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="u/5nfBVo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o9FQdVoLDwysIdno9Ojwf3S07dkswCEZKYiTXPaRV6Qmiq+/2NksHN4EjKjekeGJlCSU63KM+yW6VE0aZ2TTRLBvRLw4PCDNMVu7enexkR396Y9hDoGZwHFlE+Zy/QMCMUSrz3JlDApXL2w9zcdQFjWvZBoc2JxSRuTZbnKaYYawUCCnv29bPAM/wqf9BKorKCslHSSnG86Vr39/SjLN2imSd+EVPDvYgz287K3yoeSUTewKSUFB0VVwTDxwlTjf6fR8An/fl+J3xBHbv6/ItxF/dZjQTpFmXijHvFuHL3fPLH+hyZpKCQ/TIMn0aIPd+BdDzqe7aAC0Yhn7A4BiOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gpf/UDzFguynbpI3xNCi4vsA5uW4YzIO1D7769AHtks=;
 b=Vd9U2kmHQhdHj8nv486appAZXeTe9pcX/cekwWrMAX3eeGyj1oS7C5P+uQIuL0BETFLNqEh9dhO2wjEFX9PZuBgSxWYPwJjQId0i15jk1unqLP/dhvKVHADSK0ouzMF2GABwOTqdb/NX1G5eG09vLPFWWEAgtvZZPMbTU8mhtppnnQiYG3wB7ymq7Ec2C1UgP8eECj742SNj3p2MaYpRZ/xnTRgFASgftSR6knJw/HzQzGDR/0INALy/UFJBB3mOle9a5Dahh0DJVYgXd92PaaYuHcEkL3RxtGex6bLRyW/dLAmO5H98VcLqHuXch0OE7XCKUtuCAnNPQYrAgqHh6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gpf/UDzFguynbpI3xNCi4vsA5uW4YzIO1D7769AHtks=;
 b=u/5nfBVo6dGPOlJ6+Aw6fPCIEdGaO024qsADRghjQHU+FDVv9AUIQmDahJtsjwbbaHDJH0I3W3u2GeGBxMPuQMjAlS5e2Z/QWNO8iG2xAotAwACi6gAMrrDVn8tmk4nJsLlKLXPqxBFwf8ifVYOGwcrlADquqsHqjPj4HHn0SRY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SA1PR12MB8600.namprd12.prod.outlook.com (2603:10b6:806:257::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 23:24:31 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%4]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 23:24:30 +0000
Message-ID: <4d46de3d-6205-4352-9fb4-9cefeb217882@amd.com>
Date: Tue, 13 Oct 2026 18:24:19 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] x86/sev: Clear RMPOPT when segmented RMP is disabled
 by firmware
To: Borislav Petkov <bp@alien8.de>
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 thomas.lendacky@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 ardb@kernel.org, pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1791905953.git.ashish.kalra@amd.com>
 <24ec806222fb8cda660269d3360780687403d150.1791905953.git.ashish.kalra@amd.com>
 <20261013222653.GAas6wLTEwIw9Te240@fat_crate.local>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <20261013222653.GAas6wLTEwIw9Te240@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9P223CA0013.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:806:26::18) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SA1PR12MB8600:EE_
X-MS-Office365-Filtering-Correlation-Id: 86c9f8f3-eda4-4637-d68a-08df298121ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|6133799003|18002099003|22082099003|10067099003|11063799006|4143699003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	LXcwOK0RIaPQiifcUvubIcRIxUX6ge47RftHoW984BvKMz6Ewhi8G9G55jl2oUJxnEpF8AACdLJt7//mPdCGF6JWZmZ8eTbbx3xynZ0576hvqVduEln3HXU5/lVXiof9Y9TileWKq5cr75wDLAelGlF0iDLCr+StvaftSINCSSgeriHiUX036RASfTnMAhfVUBshV37i3EWMzv4IzMhamotevrAfDLvFohZlAmh9BmrvB7YS3a7zElnDaeqA1Cphin1xtiG8TV8jTAw98N9rtzKMZXoy1x5Ql5z+i8YpNAiTVJMwVD7xgRMUjxX6nhkcTtY4lflx5wZfUNj8Jfhyh3miId2d7KprBYuGZO0mAxPaNdRz0+0FiIaDzwus7m2/goVV9JW6ujVB3cR+qHuk/S/utlznCFqNBR5/WDXoPr0cGaxmOpSS8tvtCi09aC8DONbnwoDPWrxRr+Glb/n6Kc62KGSnxPNYVmSOo88MYOPPfniW+wRBJbuljOAx0hx1ty7fvmUzgM+Ct9BHlR5q2aUzMZq3UJZK5HzMU0zzdeDhQmaHipDKTvr49A6Bmpr+TfUOygdAitjDsMcoMEa4lVt6zNgtN87ALRPDnWRLPS22qxtn74WMt5UPjcZVFQiisFZTefe79LAN6Bg7Ne0QpT1KSBGx17r9bqSZu2hLIUU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(6133799003)(18002099003)(22082099003)(10067099003)(11063799006)(4143699003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d284OTNBUzVVdzREbU41ZUtVU1hmd2daWWZOVjU3NlJqeDRLMTNISXY1MzNV?=
 =?utf-8?B?VTVDZ29BSVJWem0zS2VVaTMwcWxTMytEMWhTZEZ6Q0YrcWJPcmN3SmJNazZk?=
 =?utf-8?B?VnhhMTUwNlpJM09PRTlBaTVBSGthRjlHZ0wxaHptV3VxVEkvYTNjcjRBaVN1?=
 =?utf-8?B?a2J4clpTSmRlckd2NE1nSy9mZ29tTVlJVnZHMHYyUEdxbWZINU1TY1ZuWElX?=
 =?utf-8?B?ODU1emllS1NQQnRyVk91Y2MyQjgrNFpVMmJhQURHV0c5b1RtVDU1aFFUb2hq?=
 =?utf-8?B?VlFHeDkzSmdUZVZ6YWFwY3NxZDhIUnZJamtIaS9ka0pxdWR2b0NKazkxU2JP?=
 =?utf-8?B?YzNTb1NVNzNQS0JQakZweDByUVpncmN0ZjFZck1iOWR6elZCZ2lkNGtsd3ZD?=
 =?utf-8?B?WTljODRwZjB3WkcyRTVGR2d2emgrVFcrbFRSdkVQaUFEOXF2ZnJHcGs2ZlFa?=
 =?utf-8?B?cWt0cy8xbjNrczZFc1VhM2NUYmh6SUk1VUptZ3VZcUgwSTduL2VXSEh5bW5j?=
 =?utf-8?B?aUJYb0xvUGlXbjBkaGFkV0M3emhkRG1MNlFkLzluNjRmMFJ4MjJIUlFxRk9t?=
 =?utf-8?B?MWlLVFpXWlQxN2pac0xtM1R2cTEvVHF0VzVzT0NrbWVoSlhqYktyOFV6VTYw?=
 =?utf-8?B?cm9INWhBaVczc1pLSXNxbHhLTzFLZ0FZNXJrRVZUaDI1YUQ2OG5BQmRCOVNa?=
 =?utf-8?B?QmpmdU1UNWRnV1VpaXYrUUZzMXVUK1dVdXIzTkxSMm9vcERDcVBLYndyd0k5?=
 =?utf-8?B?S0dmYkpuVVg0UzB3NDJ1ekxGSDhPSWc4QS9sNW1Qb3J2dUdiSFhucm96MjJN?=
 =?utf-8?B?TEpadXJiZnVaUStoZFJuWEs0KzRBWUlwNGxodEd5cjZFQjQxd0hYUDNORlYz?=
 =?utf-8?B?NElKT3ZOTjFhbUF5ZlU3QmJ6bU5MaTlDSy80L0hhSUhFMHNwaysrOTcrTmNs?=
 =?utf-8?B?WCt1WG90aWl1V0tKMDg2dklXeUNGa2JmQkxDOW5ORDkzaVowR3ZFc3VPRlZK?=
 =?utf-8?B?b25qRmVYS1pZditVR1NFcmJNaEVSQkUwS0pMcjM1SkgyU3o1aGQrOHplVFFz?=
 =?utf-8?B?WmpuZ1RZSGxmTXYyU1BOUGtiTGw3VUFQc1VhZnd5cEVMdjRSdlZlY1BSSWxJ?=
 =?utf-8?B?UDlNNEEra2hjbzB6RVhQTnNmYjh2WFExMlFZekszUURiNnNPVkdmVFhFYzd0?=
 =?utf-8?B?UkF1WGJVcms3ZDdyeUdkbkpUVHBHNCsySTIrWTREWE5uY2svTVdsdzVuK3Fm?=
 =?utf-8?B?SFpsVEVxVU50am41Rkxvd2RETCtjangvREZVUlRGRGVVZkFxQ0FhaWpFd2Fv?=
 =?utf-8?B?VVBGNC9QL1U5OTdNUlphVXNFa0pKWGtXRlU0VXFJZlZnVExhejNuRmVDcmh6?=
 =?utf-8?B?cnVYUjlUaXVnZTBEbWdiVUY0c2VyTTdIY2t6d3NyNWZZNlVPUXJwT25TNTB4?=
 =?utf-8?B?UWdob2Fva2ltRW0xN0JUb01UOUdDL1oxQng3eW95dUR3ejhLbjRkMy9Qb0Fx?=
 =?utf-8?B?MUxJNzFrNVo0RjQwRFNkaEVteTRseW03aDdWTWErUHNKZXdsU0dZbFNrWFg2?=
 =?utf-8?B?MlRwVFR4d0xhZ3p5YnRnVXhxU2ZtWjB2bWluZkswWFZFSWFjRjByRWg1YXJC?=
 =?utf-8?B?YW1SR0t0Z0haeU5jVkV5Sys2eTBIM0tsZ1p2TXZ4aHQzVlZCYkVhanh0bis0?=
 =?utf-8?B?aG5GNjlkalo5RlFQcWVkbjA5MzlYVzFDVlgzZU1kUStjSXl2VzVDcXQ5Titl?=
 =?utf-8?B?bTBUNTdVRHIxSFl3M2NWSjdXT2dHTDlRSUd3VFBocDlRaHZUb21kR0xMR0lX?=
 =?utf-8?B?K2FGbVJkbzh2Q1BMUytUUldndHFuVjEwbTBVT3JncFdkeWFQZTN5YkR0N3RF?=
 =?utf-8?B?RklNQUZhK3Y2WDJVQVNtbEpPU2loOU05aEhCd3JoMWxPMVRDZzlMZEgxRzNo?=
 =?utf-8?B?MUdEa3NQZFRCbGpQQTBBN01sSDltQmpSaWxtUVlLd2V6Zks4dW1nYnBrbi94?=
 =?utf-8?B?Qzk5WG9xNStYYnl5RXJQVElKRWdOK2haSWNkckxmaG5lZHlpM0VtRmI1VTFH?=
 =?utf-8?B?c21aNHhSWTcvQkd4bmE3Mlp4MlFRRVJ2T2dnSG1oNk00SjRlejR6aTdRaEZG?=
 =?utf-8?B?dUZZQkxvQlRTL1d5SElCQlkzRVBzYzlsTkdNL2tSKzIwWG1KSHpRQWN4Y0RJ?=
 =?utf-8?B?a0F0dHNxVEFIU1RhWmZRVlMycE5jK1h3U1ptM3BpMHRBWVVMNW00OCtJVFNE?=
 =?utf-8?B?UnBqLzcrWVJVbXBrZlBFTXl3SjU4eEQ3MG0wWFphd0lXZnFLd2tuUmU4dG1u?=
 =?utf-8?Q?zD5IhLeHfSQRXSgI+O?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86c9f8f3-eda4-4637-d68a-08df298121ad
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 23:24:30.4495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yTQuqDvNRW8hv+WDdXOcpJlfVi9V1/tt3Jjv6VdqJUllx84cAfTLt0ELXLr6PxYblRg1YEqHwAtMZzB2EBBytA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8600


On 10/13/2026 5:26 PM, Borislav Petkov wrote:
> On Tue, Oct 13, 2026 at 03:44:18PM +0000, Ashish Kalra wrote:
>> snp_probe_rmptable_info() only clears X86_FEATURE_RMPOPT when the platform
>> does not advertise X86_FEATURE_SEGMENTED_RMP, or when the segmented RMP
>> table probe fails.  It misses the case where the platform advertises
>> segmented RMP but the firmware has it disabled (MSR_AMD64_RMP_CFG's
>> SEG_RMP_ENABLED bit is clear)
> 
> What does that mean: "the platform advertises segmented RMP"?
> 
> The CPUID bit is still set?

Yes, "Advertises" is the X86_FEATURE_SEGMENTED_RMP CPUID bit set. That's separate from segmented RMP being enabled,
which is MSR_AMD64_RMP_CFG[SEG_RMP_ENABLED] (0xc0010136, bit 0), programmed by firmware

> 
> Or anything else?
> 
> How do you create this configuration?

There is a BIOS option to enable/disable Segmented RMP. Disabling it on a part that supports/advertises segmented RMP
feature brings the RMP up contiguous (SEG_RMP_ENABLED clear) while the SEGMENTED_RMP CPUID bit stays set.

Thanks,
Ashish

> 
> Thx.
> 
