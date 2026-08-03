Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011005.outbound.protection.outlook.com [40.93.194.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3923AEF36;
	Mon,  3 Aug 2026 21:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785792232; cv=fail; b=MIbNuysoAJVDsBHCtduAITCgpzpE0gmFQfhbEjOXMHIJJDaSpre2NUealsLjPRAT3oVVPwbbS26pfk00BGylGIW1kzQ/Fn/JeIaXQFpBDR8Vq0oDCkzRfBNv02YswluskODkbbQcTUgwxq3gWi/N8meQmjg4m4ez5h5mKWUhm6E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785792232; c=relaxed/simple;
	bh=I5y0x/HBli2YOWYwmDV+Y3VIUlXmj7QLFOFc2Ha0Cv8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cMRfwtQLCsjBkvwh/Fs+Yv+Qxu6XBLoGhewX5EYLEsYIKc1L0qUIDXDTDAJncQfPyW+gFxYoKSSxNbj+kSNxce9/ZN/5NyCpbpDLI/t/RE7tJMG1+QKu9XQ+U27sShuKK2kXGsq6EW6pejYOuxt00TN62CRhEF22VDX3avFHa0Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=USyJzcng; arc=fail smtp.client-ip=40.93.194.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="USyJzcng"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vz9xGzmHVaxocqEmz6nnrbE5DxaQp4AGWkvBjUJIeNDqYGZmeH8TiIqJWN9jfdgoa3PoZQG7tfnErMYk8RBiBrnvQYXiIMAjY5tr3dTdE+9ezVVKny99M77sTzBV9X2/cTwfCCJPJm7ZDJ4/ip1M6hmgs+MNOzQZc1C44MUYEZiVgSEJTi9D1/27Z/w3OBdUjYRzhfMTUlWYDdGT53khWvMYSg6mE14h5e+8GdSkT9Bf/PExv97yEKTd2O8XLJBhzx/TKR15CTge+YSWxo7/nNpQyYnufacBf0j74Adh+ObuUQ6RhBoe45kNks8MqPK6lbJbM5sGRpFVXwIlURVwyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t7GIqMIq6OUhWhZ8ZLLLpyGFIHy/mcEosRjD9RIkFCg=;
 b=RY5bG/VTjRzsaBX8bcdGDEtC8KmiHXzW1HwKZQyFacWPDcVImjH187qJit5bwwteT62F1YWttlpEdhSdUCi7bcry/sif4wJmPYgUI7avfBVDchay35eKVyGZoBPrk7cag/ONTjMj5zUGy++y0fWbXnXrDOPY4ncnfjW9faVO8ep2x/YXLXMZt32ejzTPLx2nGuZ7C0/i3CwVBIsGlv6F5LYpNOpkXX7CFtCkwT9eEQRhcsAuIqOKe9Sx1UvxrS6LPdhe3kwAkMI6F3fc/Q4Mnv+1UDw3KxfvthzLo+/+5K62w5y6VaYWOH0i2GMg/pL4rLsfpDA07TnEY2pd3Sz6lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t7GIqMIq6OUhWhZ8ZLLLpyGFIHy/mcEosRjD9RIkFCg=;
 b=USyJzcng+ntSX5rVbbaigBy8iPPN132G0NZgJrCYdByuG5ao9g+Xep2DZM3pG/HX9ttN28HgFcdTHV/VufCOKiIGrdl1aNyjIUBsHLwAcQr39J0Xi2/dpEw/ytYidxIAVt1fxELczf+ctTaxibKdZSecgzxeuHzU9FKRdU2y/kw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by CH3PR12MB8282.namprd12.prod.outlook.com (2603:10b6:610:124::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Mon, 3 Aug
 2026 21:23:45 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0270.017; Mon, 3 Aug 2026
 21:23:45 +0000
Message-ID: <d7a17bde-4af0-45ad-96bc-4717a1fa1545@amd.com>
Date: Mon, 3 Aug 2026 16:23:41 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 4/6] x86/sev: Add support to perform RMP optimizations
 asynchronously
To: Borislav Petkov <bp@alien8.de>
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
References: <748785f1-f176-4f0a-8b8d-eadf46b20960@amd.com>
 <178578506318.2377606.14791252769672870038@Ubuntu-2204-jammy-amd64-base>
 <df5f5f6f-7278-42e7-bc7d-8e56187d1438@amd.com>
 <8DAAEA48-F2FA-4D52-8E56-4B7213155F12@alien8.de>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <8DAAEA48-F2FA-4D52-8E56-4B7213155F12@alien8.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0093.namprd13.prod.outlook.com
 (2603:10b6:806:24::8) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|CH3PR12MB8282:EE_
X-MS-Office365-Filtering-Correlation-Id: 9351744f-a9a6-4b99-d06f-08def1a57fec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|20046099003|11006099006|6133799003|18002099003|22082099003|4143699003|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	pvvHdSYTOTDGEthBXiXbpMkLEG6j4zJCpYh8IqQ4hNchKr2RHhN2Cdbqa8A3x74GUzvNUaUVYQj0PiR2iPopSM+uU6m378XalaidXN7Q1MjKP8jsKHCDihjhG1jSmxyzpqjGJWiNp+2SFcEvr+jR2sImN4z4bZB4FzbPf3socypJmcpQaOKUHtg0lMwgFAOwpcR9TNZ2Ri04GrMa3voFeJ1OjPqItgn4fMuyiXpLGUkaWV58V2sLv8WDBKgssGjKYxLA3CYX0d0zJwBUL7rh2NGMV+NB5L6LbOpAnVHTCzZoB0mhr0wX+FyU15BBW7Rw/1WwJbieW6vxrrymWeVH/ivoHGpWlPMu+VcVYQQeQgoIwc+rpk+y9CHduTbePPsF/34DNJRhvzpDu5OE0+xdHN4snYWuATiLJeZahh3EXVN5zqDPOKrOlxR/bDbAZ+7S/gr+YOlq3ZJwQrqSAEjUIkgxovU6B7A5cGH1Rh+/mdVQ0HE2BRFZIXPYAKOSsvAbl56oJR3yLSnTiKSplFa58WYisu6QIe7HUBj7jZcd+6Z4qzQDTmVV1P4IGM5oS8zATKXwsPHiZt4RW83HO4lcK9qnkz3MG9+pBFHYijhJOfaz2BJtpQLdLRtynZYr/ZMAZHuSoeomaG0bL46IMrVgqU+BzWhyzi1dMKe4MmHlOAo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(20046099003)(11006099006)(6133799003)(18002099003)(22082099003)(4143699003)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K3RjZ3lpcW1zNlQvcW9KNDl6MzBiU0dWMnQ2MHR0elJFbUdHU3lsa1pBYi9o?=
 =?utf-8?B?aE15KzJyMEw0TUdyMm8wVndkalVvR0dRWjkrc1YyOXJSMEtSQmFoN1AvT1VN?=
 =?utf-8?B?MUtpRnlPRExRY2RmbFI4WmtoZ1NJRUtYaFg2TDJTZ3FwaXRTa0lqZ2ZsUjBL?=
 =?utf-8?B?dUZNMHhCazJFNXd0VkJRbjNHME54RCt6VUNrdENCTU8wVVF5SGQ0UGt4SlZT?=
 =?utf-8?B?ajNiWHhJUS9ncndBNmY1Y2tUcjY2Q2lOdG9OV1cxbTNqamU3QkZlZFh3aG0v?=
 =?utf-8?B?QWxvWnQ5R0NHVkZqTTFUekVOaitiNExiTjBoRDhIREVPU3VmaWNSNGxKUjNv?=
 =?utf-8?B?R2RpYWhWRElaQ2dlWSsrRDJFUnhvQnVqckR1KzJKVUJzWnRJTlViT2trMkt3?=
 =?utf-8?B?emljTWV0ekVQWnpyWWU2bXJvdlJUTUhwSUxuMmZjdERUNVQycWppVmY2Nm8x?=
 =?utf-8?B?MURqT0V0aHpZMno4L3UyRWtXRW9Rd29pK0hmVzIvK1h0NFIvVHB0b09rV3Mw?=
 =?utf-8?B?azVrclhKKzZaNUtTOXZqb1dhdFAvZlhyR2JmbkorVU5aUjJzZ1FRaEtnZDBZ?=
 =?utf-8?B?MWdhdTZ6WUo5bDdhOEpuWXZUbEJ6cFpDcnQ5dG5PbFVFcDkvMmIyTG1VelhG?=
 =?utf-8?B?dFVBV042OXF3dE15Q0FxVjNWTkVqZmlza010L2gyYzBEWlBaWjBzRmVvTXg3?=
 =?utf-8?B?NVlMcldzZy9VaEoyMHBNRGdQYmRyNmlOd1g2NlArWW9Nb0VTZTkvbXZwNnYz?=
 =?utf-8?B?UTVWZ0hmS0NiRkx4RU9qOVM2ODlVL0FZeEtGWUFyZFViMFJBYlFoNFB3T0hP?=
 =?utf-8?B?UmlCbmZuT3dpekFIMXFiUjE4Zkw0ZnUxcnUzSDlNTkFLWVdHeHNKdForNXU0?=
 =?utf-8?B?Qm5BUTdGbUg1OWdTcWxlalhjbnU3MldJRW90cEtRT0YxWjg5aE1HVTNFekZw?=
 =?utf-8?B?bEFXQkhxeXJhQ2JFR0hlRWQ4eUVvTTJkOW5hTzd1bkVTUUdyZzRZZDhJcXlr?=
 =?utf-8?B?RUVJSGtma0M3bC92QWRCbk85cWJYZHVjL2VTbUFMRGxaN1ZxSlhLcmFXd1Nz?=
 =?utf-8?B?RWFuU0VDeFB0MVFoSG1YazRCOGRFamRxZnI1SEVvczhISGpGejlQMUdNdU9M?=
 =?utf-8?B?LzdOMUpLVUlSUnlSUzRDK3NVOWlyZU9YZnorTGZvMGZEZzVpNU1rYnNrdWd3?=
 =?utf-8?B?a2FXNUIvTmdvTnlBUFZNVmsra1MwOTJsYitDdTdsaVk1QzNqTVcyZGhnQS9B?=
 =?utf-8?B?a2F3QUhJWG5yang5amJvRjVnTXJRME1IYkpETjBiMzFja0tQK0NYYzFEcGFN?=
 =?utf-8?B?VC80bFpZTUpDeVJPdlNhRUpVc09zOU9IQytJL084VDIrSlFFREVnVnl6K3JY?=
 =?utf-8?B?cm1KOHZwTFhqMmZnUHBqKzVSc0pVY3lGUDZWMXIrTmliQVB0b1g4U1NMS1VF?=
 =?utf-8?B?WGxaWUNZcFFPcHFKWEJDajRZLythbVd6MWJOVWVOb0JKNjdHMkZMY3RVOUJU?=
 =?utf-8?B?cDRXY1ZIWFVuSXVKUWFjUCswL1Y2MjBoeWpRYlp2NUJIVHpraW9HV0VrNm12?=
 =?utf-8?B?RG5yZVV0NUx5UUFNOFQ5TEl4a1pDQkRLQm13TVhjeUU2YmdVQ0hDd1gzMWZQ?=
 =?utf-8?B?SS9yY3MweGFKTnE0OXlZVHNJT1VqTForS0J2RlY5N0dwYzFyUEdvY3JDREJO?=
 =?utf-8?B?MnNmaVRUbHdmOTJOVjNzRDk5bm91VWR0M0NEcnMrVXRib0NrUUJZWlNxaVRW?=
 =?utf-8?B?VXZuSkZianpTVEJCUmFRK2JxaHJydFhNZkROcDV1VWswMDgrTVk3STBKM1Jl?=
 =?utf-8?B?bnFQdDg5SVRuQlNjMUNZamgxbTNhN21OOGgyb3pIbDNFUUdiOS9mWU9wc1gv?=
 =?utf-8?B?TWZIZXhJeDJvZzVNYXZFSUt3Tk1maUFMbDBGY0UwRVpla0dWOWViQ1FqQjlz?=
 =?utf-8?B?QU8wNzY5STNjcGdZRkhEK1hEOTNTNnVHcWpqWlZZc2tGSFl5OUJtaGxvUUN5?=
 =?utf-8?B?L3NvbEZYSTFlUnNFNlZvZTlTbVNvRTVrSjdyM3R0VE9YMVYzM0FwNnVoclR5?=
 =?utf-8?B?RUdzMjJyOGdubmVOUEk0MkVDSjJqazU2TVNyOFlXMFdFS010QUx2YmFCai81?=
 =?utf-8?B?c0RBa05kZ2NUQlZjSk9wNGIvWm1YeW9xcWhZUW0rbm9qZmdaMDdJMG92SGF4?=
 =?utf-8?B?dE1PYWhOVHhWYjVQYlFPblQxaElaZldyYis4M0N2N0FGVDlBY2xKZ2QrMUxN?=
 =?utf-8?B?Wjc4MzFQRjNVY0g4RkhKeFV3aCtjeVluSm9hdFQrQTBvWmdYcWdZdyszcEJV?=
 =?utf-8?Q?C/j1UXB7EKznMU5KE2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9351744f-a9a6-4b99-d06f-08def1a57fec
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 21:23:45.3963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xyI38OBAWpvvbtijm1Furu6N9rjH6Tdmda4/eo++4IumMk7f1F2pD4jgYhidaJcWUBenR2p1NGZOX4uOVjjZ8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8282


On 8/3/2026 4:02 PM, Borislav Petkov wrote:
> On August 3, 2026 7:37:59 PM UTC, "Kalra, Ashish" <ashish.kalra@amd.com> wrote:
>> RMPOPT_WORK_TIMEOUT is used by snp_rmpopt_all_physmem() (mod_delayed_work()), which is added in the next patch — I'll
>> move the define there so each patch is self-contained. 
> 
> Yes, very much so.
> 
>> It isn't periodic either: the handler doesn't re-arm itself. The work runs at setup and re-init with queue_delayed_work(), 
>> and then per SNP-guest teardown via mod_delayed_work() (batched by the timeout) once the later patches wire that up.
> 
> Then I am missing an important aspect here: RMPOPT optimizes RMP checks but then what's the point if you do this only on SNP guest teardown and I'm assuming at guest init too? 
> 
> What happens to long-running guests which never get restarted? 
> 
> This would lead to the system fragmenting ad absurdum and us never optimizing the RMP table practically.
> 
> But the guest could, in its lifetime, free up a contiguous 1G. When are we optimizing this one then?
> 
> Is that what the sentence about optimizing during 1GB page cleanup in your 0th message all about? 

The case where a guest frees a contiguous 1 GB mid-life is exactly the follow-on I mentioned in the cover letter —
yes, that's what the "optimizing during 1 GB page cleanup" sentence is about: once 1 GB hugetlb guest_memfd support lands,
RMPOPT re-optimization will hook that 1 GB cleanup path. I'll spell out these trigger points in the commit message.

Thanks,
Ashish

> 
> In any case, your commit message needs to talk about when those optimization runs are happening and why.
> 
> Thx.
> 
