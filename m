Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011060.outbound.protection.outlook.com [52.101.62.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7FA3624D3;
	Fri, 19 Jun 2026 21:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781905690; cv=fail; b=KP5P7pS+A/eRLEeNEDGyBrNQ42yFBvAkaIu78JizOkStFOqcjlLlI3EjKxQ+p+PO0yD9/mEiM36kQvDofEQGDTkUOz8AxOChZxfqbKnr9iRO7poDTI/d5FuTt5UoT2KeN1StSkcYE6pQ0wswWiZSIkkCti4D6t8LoHW7KFM0xP4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781905690; c=relaxed/simple;
	bh=glG6uMULmqFQAXKAfC0b21RZAOGIxbJGfj5bO0HzDe4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aikZDIQpsW6lHexr4Ib66N1g03mW6870q9Ibc4Dz836HP6RZog39BY+ZKumhSgKQ80oMTWMG1rNaXzB1gWvZKVtTIZjjg6518KmX4nNqPJluW3X1syoRZUfeoudM+cj1zY6anscZwmHW18UieW/hHiteKdzuF04QzwLVAGecTyU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ccvfrmDL; arc=fail smtp.client-ip=52.101.62.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ccvfrmDL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=akJYTDzB2+oF5IFDe5PXD1YpT5YhBXxfm4X/qbDJ65bRkQA9ej7KcyWgLlvXl0M9Xam/HoFJhaACEEydINDKwdDGNk/45AFN9OOHcWlsLlKpbuAAmNHU7GJtAmePdwhjY4y/IQW30pK9hLuvQYysdVP1MxbDoQIXGPRhTuqlzzWPK43xmrBo/Y9aXfBTo9uCu1/MM+hLKDhNiM9apwtyJjqqMYgcKkz1qurTRYQFEB7yKhjeArm6jjnAa+lU7Iz11Sgv28K6oG94DZWStvfexFCX6+CGCyB8aS7UBLvWfgw5v2LKmX7VKuL6yGzjwIJLQe6lsFiLEdIprBt4jYx16w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GsxvE1uIaYtC5NzO5bsC+wVHF3X+fnd4nuI8JIIy8fU=;
 b=yg5QRMHIcA4RrQsArq/FhB/UKec/TdAjsgcfO5eYlW+ExV/gNxPowp5kToZMsZ0cI8aY9AZ+xLNlp9aIhjq9lXe1H1BiT17x0Wg/lP35r2HwiluyPs8MezzPABAZEi/Q7VGX8SMBVSTDEv/cbJWF1hi1x7A69lakjyNu8U/pL0z4K7jXx4LXy4r3IzCNFw9O5doon8qSMAfBETHSqu7Pdm9Ft3vDTCvFKmeYZi7P4FWnlnoHtEK1LPyesUn8Ka1hkVcwzawnjUfFL7mAISU8YQkR9bcQ59uTEbTTe3weiaToi3nNC5J7mLcTaicPBVN0qhWfVJ5TNdVuWiF0B5LQYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GsxvE1uIaYtC5NzO5bsC+wVHF3X+fnd4nuI8JIIy8fU=;
 b=ccvfrmDLJAhZtkyeHXvS52uu01phhwF5Trjbm/L2IOGKvAJAxwFMWg+Rg+O48nAdFepKF3DtsNcCVKcTpW6dCoJnVHKJGUrSrOi7pHlt9BdijgukGhjb3ZsaFTQpe9c1aZn2RU05CAWZQdjH6uudFI2ZYkrsQoBd1z3bRnj6YuM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by IA4PR12MB9762.namprd12.prod.outlook.com (2603:10b6:208:5d3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Fri, 19 Jun
 2026 21:48:06 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356%5]) with mapi id 15.21.0139.009; Fri, 19 Jun 2026
 21:48:06 +0000
Message-ID: <825205ca-e9a7-4903-b624-9a0ceaed9472@amd.com>
Date: Fri, 19 Jun 2026 16:48:01 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 7/7] x86/sev: Add debugfs support for RMPOPT
To: Dave Hansen <dave.hansen@intel.com>, Borislav Petkov <bp@alien8.de>
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 thomas.lendacky@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 ardb@kernel.org, pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1781419998.git.ashish.kalra@amd.com>
 <cc9aa9b6cfa2ce826f2ad53f8a13d3b7bf0790b6.1781419998.git.ashish.kalra@amd.com>
 <20260618180814.GCajQ0Dv0CoRMJxbP0@fat_crate.local>
 <5849645c-f701-4768-8cdf-1f9032e3226f@amd.com>
 <56eef9fa-d8cb-480a-b3b1-f01456ebdb4f@intel.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <56eef9fa-d8cb-480a-b3b1-f01456ebdb4f@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0405.namprd03.prod.outlook.com
 (2603:10b6:610:11b::15) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|IA4PR12MB9762:EE_
X-MS-Office365-Filtering-Correlation-Id: ac168d51-70b1-4e45-90c0-08dece4c723b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|18002099003|22082099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	mRdSJypZwqgKNGWBjSoxioOsnCRV9cM9l0/sglGWN04q9DkgEgS/uwOyBejUdc4tmnzB5XLcjkSU5oePaNssK8rV1kQZXOcPrAT1aVeXvxNY6UzRxFZNi07bf9AeOMoMa9MdeRPSFH64kdYip6g1/QXvi86EHOWebyQLRmiMBALsdpWpYFdmoA9qQ2fC+S9v3PTusc+wh8yJ2cmzmuDlBA61Bc1BcyPWORdRXLpXE49/6Dtp3QM6NA3vivXlQWt1MH+xZ7h+W3odQcrsN/ckXDqGsFQLol9HA+8+JV6k5GqjvWIwWfFy3bacb38s5Hgbx1pyTB+97vlhDgSFAYJ7bRRID5OaxUxE3+ywx6JC4Lx8UFvz6PDONJktVR3lY5QqdFMwcq0DDpsyik65XU5ZgwLdJ4GAmir5MvdR1w2XpsdVsWuYSrjArY4SIpPtzCWZEwgkCONsIqxwHcpogRJJ6d6FZenj0JbEeB0gfYcJfv0US9rnXcH5ZSEVGXfYYpJB3c1jRWBISAeNLSYlQD+jv4YuKk6Snbf/uXYt7C08lMcXVfVyxI2vqa2bDJkzrnTBCZ7Yjn8vot1q7EGsiRb+cjiHe098eFwwVzOHtm1J2bthj6RhNgVF8SPg+DqdCY80239cW5PcHUy7ydUotfp22C84dv4uK5V5nSsfmbrRqi8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(18002099003)(22082099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NWlXeURBdUpOMUp2ZFJpR0lBd1VQc0hPN3RSdnJSL1FMSUZDaFVldkZUdXhi?=
 =?utf-8?B?bXRrNG5sMlg0UTVnR3lLVDdLSEpRcU1nWGNiUFlQR3RUS3BxY3FtN1ZCL3hM?=
 =?utf-8?B?MzBRRGlBK1pMZC9GWWRUdnZFakRTaENObTBEeHVqMStFSHJPRjBHRHNYbFB2?=
 =?utf-8?B?TEVUamZudXZsVDdoaXFGTittV1B1bTFFSzJZaTFFWll5Zmt1d0MyQmZ5ZkpV?=
 =?utf-8?B?VmhkeUMzYTdwQlhVd052Vk9NbkJYVWdJS1kyVFhsSEw1R3d0aWJMZVpyR09k?=
 =?utf-8?B?WUVrYnNzWkZIaVUwdS9FaUFydmNBYVIzQWR3MFFYRlRFWWNyNC9WeEJmVkJr?=
 =?utf-8?B?TGVpcHkvM3dyVVBxSUVsR29MUWk4RUlNellON1NvR2FPRjBtVmhzZU1VTU5C?=
 =?utf-8?B?enhBRlhFRlN6ditwYlNpYUgyR05zcnRDU2tzMVVPY01vaEdaRnVsVEMyaTVm?=
 =?utf-8?B?VDROeVZrMGpMYktqZWhJd1dhLzNaMm5QcllKRnFueTdkbVorUmt3QW8vbHRp?=
 =?utf-8?B?V0JadWRuMnNhRFJkcGV2SWJYdW9GdXZOQ0JKTkRQUGtNVStxb0ZvM3NNMXJS?=
 =?utf-8?B?SitSNU5iNVRZSXBBR2RQMTNlV3RhK1hDWm9VRnoxQzEwVTVObkxUM0ZRVFp3?=
 =?utf-8?B?N1BlK0FsNUFXNU9qNnBTM3JGZ2laYkNvbkM0eVdCUmlvaStKdEJWZHlnaHZ0?=
 =?utf-8?B?RzFWcWFBVXRxZG1URnE4QmRIalpNaFBWMVJUWmhPV1ZXdjZLTXNTVlByRHRD?=
 =?utf-8?B?eUxkY3BEZHNvTHpkY2I1YUdXdC9pUG1jLzdqK2ZrcE9TcWFjRDNWUEJrSzJW?=
 =?utf-8?B?TmN5UXBMOGVLNmhFSUhodkcxUGFiSHl5MkVrdllrT0ZZWXJ6UXh1cE4zWXpX?=
 =?utf-8?B?cm1ydEtmZEVwMUlsWXF1N0txMXAwL0tzc2N2OXdSdEZadzdjT09YRllRVzhT?=
 =?utf-8?B?NkMzakpEeFNxZjA5amdtaDBBaEJveVdtVlBlTmwwRTlaY1E1Qk5tRTJqVFFp?=
 =?utf-8?B?eDFlVm5PVElJbGVHNWsvQWpITzBpMmRHU24rSWpuUTBnb09tdFpKNjJwaG9x?=
 =?utf-8?B?eWx6c20xaXhrUStzRUVGUmtZN2pEdVFYakhqM2hLYW1lRzZ2WTRQSUU5TEpO?=
 =?utf-8?B?VUhmQWE0eWFxUHNhVDQxOGdod0RNQnRkNnNyR0xha040OWhxSnIzRDBsY0Jw?=
 =?utf-8?B?TnFTTjlYOGlCbmNVSFF1SG9mUVhnK1JCN3dFeE5Cc0J0WmJoYTFRWXBjV3pS?=
 =?utf-8?B?TldZOE1kK1NyQzhqZVAzMDRvVWx5blR0SUx4aENBdTdzcENoQ2hYOWFUUCs2?=
 =?utf-8?B?QWJ5NDQvWUY3M3Qxck94R2VlbE85VEVFUHFPUEszRTdsUis0SXJDdWtMSjU3?=
 =?utf-8?B?K3d1dVQ4KzBDRXN3U1hULzErNXk0V2tMR3dFbDZpdmRITFNLdnB5NWU3R2hO?=
 =?utf-8?B?UXlQQXc5REI3azlxaWFzMlRiZWEwYS9KS2pZc0ozbENiL1ltYjR4T1I3aDNP?=
 =?utf-8?B?TDlnak5pRm9NazlZZWZNSDdEcHpObVZ4cDJ6M0dGTndEZTJWTFBETU05VThn?=
 =?utf-8?B?ZkJqYXNhVXM0YkwvZkJ2Z3pVNktwL0RsK3lQN2IrR3dnekliSlYrT3ZyY2Ji?=
 =?utf-8?B?bm5RNTE3ZUcxbU5qc3hFbGVxUzN5NVg4bllvV201N3FEWEMxVFN6em1sUGIv?=
 =?utf-8?B?SVVCS0s1T1ptYjhacitpWUo3cWJRSUpHTkFBdUx2aUhDdFY2Z2d6VzBqaExO?=
 =?utf-8?B?SjhRUGNnaVRqa0ZmZ2R4MXl4cEwraG1OTXRkU2l0UHZJaW9MRUR3RE50bXE2?=
 =?utf-8?B?K05PNytzRzNoakE5Z1dMZFRxV0dUUVZVbDFMQmE5VFJ3S2FWSnJtOWcxcGdp?=
 =?utf-8?B?cnU4V2tSVkRKcE5WQlJBck5nT21tTEpNdjk0NWhJa0kvNjdiZUdqdFRsNFdl?=
 =?utf-8?B?VWc4WjhzbTVnSTN5MHRaTEJrdDVDQ0NmcGdTdzJLSDdQQTEzVHE0V3E2bGwr?=
 =?utf-8?B?cVpVSHA4RmcvTVJsT0tZRDFPcGNpTmVJZ0V0MEJycmlrajB6MlVaVUwwbFNK?=
 =?utf-8?B?RnV2dHpHVjRPcTI1RXRyN1p6cVZOemhJYXNqZ0hBMWlRUDN6NEpIbzRQV1pO?=
 =?utf-8?B?czhvclBQUzlMaVpBWTNVREIrYXArL1hjSTVmcG40VEd0azgwZmRHQjIwUUV4?=
 =?utf-8?B?MWhDWEVpMVBQb0Z4U1JKUlFyQTg0VGVGRVBZZlB2RGtPMXdIMHVqbG9hc1Z3?=
 =?utf-8?B?M2pGekxuT0FydzVNMWFReThVdUJtY08yUHhkVGpwQXpzUGZId29DeEY4Zklx?=
 =?utf-8?Q?xpCcPI24AZAzK1vy6V?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac168d51-70b1-4e45-90c0-08dece4c723b
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2026 21:48:06.4800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IFPg23rv7xYd8fEmU/Mz0QxCUItULJiyLSxeG/qK9xyixBXV+rLAptsqUFNVYRnA7meb8HTGZdQpjN1ai/XAFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9762


On 6/18/2026 4:42 PM, Dave Hansen wrote:
> On 6/18/26 12:57, Kalra, Ashish wrote:
>> Maybe i can add a line to this patch's commit message stating it's a
>> debug-only interface with no stability guarantee.
> 
> I'd highly suggest reading the lwn article Boris referenced.
> 
> In the meantime, drop this patch from the series. Please. Let's revisit
> debugging interfaces *after* this gets merged. That way, you can
> concentrate on functionality and not debug interfaces that aren't
> critically needed.

I will drop this patch from the series and then revisit the debugging/
observability interface after this series gets merged.

Thanks,
Ashish
