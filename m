Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010008.outbound.protection.outlook.com [52.101.201.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDAE1F5847;
	Tue,  5 May 2026 20:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778013270; cv=fail; b=qQzLsf482sHmy47VyLC6Xr7xw8KhkLyV7ts5uDJJqwlPXyHgQANmUHVSCNzxHsUPIJ3lGnFVElS7oJ60aR1uyzhurXCU9+FQRyGXjOJoflvHRlLF+apEH90aA3uHG9Gv6WQTsuVscm78Pa9jhJtwsC5q9/v8bAUVz2gkLu6fhxY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778013270; c=relaxed/simple;
	bh=X1yGRVp5+QSEiEI4wGyHOlIFpk3pitM081Mfx7WWq4M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IzHbSxJ3xLDBMAXAX+M7s0RHeOeOS3YPrVQkF8qIS6ksPYPpX2lhYOEXiJ1wwu2FYjWrFaREE4WIYQt2jDK2yikYgFSj2M77G1ueY8xxZWGJJFRmms+8lId+iaGKRP6fcNCa0v+kAyh8EXUDzC5v6JP4N1xbMI/oITdGerK6la8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=T6L2laZS; arc=fail smtp.client-ip=52.101.201.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="T6L2laZS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JujnVwxoL5nC+RX25AhpvI+Nl4Y77n9ltQa+Ph1YIdMhAHfyMqoIAeobxJWYqzJvH24b+x6DSkVteg8/sjvPXhVCR6SPvfol+tF3HOu4nk2FX+95MuuaAdIbY6qdJsCjm8dCWhABcnZy8/pz5oKgMZQCOeoz92FAqYUCpYTr/dflIe3h8RU6/dDkC3hbkonBlCkgZrxHTrTOOVpLiact/QQsGCEZsIb3k0CbxN8FNUrv4CCB1ab/eF9C084n0OZ4Y4ymoLSLF5VS/NdgGGeGVv60NGlmNC+oyTwZ1H9isLKmXBlykPDWPk7h3ZXrY6PLfJWaU/0GdXUVfdD27qXN3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n5CKBAncffo7OepBZwcd5so42Y5Rml0gR4l+XvD2zsI=;
 b=wt8q5+XxURZVaXzsO/hpMlNpA5GlB2XQ18+wgeSoElhF089Ajw6cVdnoM9THUW3533A5GjjUSsm3HvQAsLhALhBZBy2gZ5hszPqeo5tj58Y4vTMcN1E96/TwQRGy0KewCREWNkIfzO7S51opT5ds677Eaf8h2HQJIMf/B2XjKhVKiCVU9cRgcs95CUM0kV4/nIJJVNUzqOjeGloAhQwToer+ILS72ZUyOwTR3m5wyqUzreZwc6Jysyz6ElwZac7Yl5rso9Ht6yTyHfQJGrav3MAo5Sd2SwjeONvLoYF3r1oXfrlJZmldGi5quDtTFO9h7TLOkd0+aoT4PahV6L7ctg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n5CKBAncffo7OepBZwcd5so42Y5Rml0gR4l+XvD2zsI=;
 b=T6L2laZSKiQ5URWdIeLhg9qd8zmkwyFMmyUlvotRMeyHjIgf5j08crYjE1yYywyPQvsiHhEpvRBjdu0IGERblmPulvosJeCrBRbQe/lvrdlsC9nWH6G6V2xkhT4vsZGjb0ef+LNOSE7WM1fBeyBqaQ41S3KypNCbb7oYjxHigaE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DS4PR12MB9561.namprd12.prod.outlook.com (2603:10b6:8:282::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Tue, 5 May
 2026 20:34:25 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.20.9870.023; Tue, 5 May 2026
 20:34:25 +0000
Message-ID: <60935140-a275-4190-8db9-dc187673b372@amd.com>
Date: Tue, 5 May 2026 15:34:20 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/7] KVM: SEV: Perform RMP optimizations on SNP guest
 shutdown
To: Ackerley Tng <ackerleytng@google.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
 darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1775874970.git.ashish.kalra@amd.com>
 <0c15142ecf6689ebe31a9c0f6f331398fc04f6d2.1775874970.git.ashish.kalra@amd.com>
 <CAEvNRgGP4ZHz9=MOGybGwe2A4XHkVF6nXnr_KdHavz1rR62U4w@mail.gmail.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <CAEvNRgGP4ZHz9=MOGybGwe2A4XHkVF6nXnr_KdHavz1rR62U4w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0041.namprd04.prod.outlook.com
 (2603:10b6:610:77::16) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DS4PR12MB9561:EE_
X-MS-Office365-Filtering-Correlation-Id: a73ae65c-97fb-4da9-5564-08deaae5b256
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|921020|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	YJLI6bUauLnhYH08SXRPcbBcFXQULlQn+MPWDbqvrJOyXUOSLt3xcGJEQmWN/NDxu/oINMJt5IisqNUDfvosT5qu1JikeyN6eserCuquYUu1lvp3wvO5lFyarQKTdMZGQaWjc05OFJVZNR7kA7wbRJhvFuOdIt1inDMHf9m62A+I9VZ3beq5U2FeNp+pkSr0G1jTmuY/SVsN48Sx45CRoxACoN0dnoYYJJaeEpFWRTbSu8DU4Jt8G2LpEXg/dXCUP1i9cy22PrZ30S/NoX7V/B8Cg1ckc7F54oOMdNQI0f+7ZCU2VZ9KQu9ygcbyzJHdcAy65feyVswjV6cGbaxYiyuWdm32xtDCcrD5t4QfzMCgBwcuR9TM0dZ0Tk8ROOkcwMO2Y10iGT3T4TJchhuj0aRHqqC8FcOpH1YQNCNEgdP3A+c04h8jms4xFXyINUgTqu3PII2DLr+mou1dmH/BOCvWJlLSqOa1AtJTgenoif0GLtWmfhCBuDsQHl2ReTq380FwPQThwJfJayws6Ubn7Jjs9I5v1/qP4IrAt5I0MqxlaOsptIkpmnMIqr0UQ24QIuED/DxectUpZi0WKkluqOLowqMLEW4LK9f4bAPUkm157dlJtfbqkwHC57UhlGjSsyM6132iw0MZCFbzBhVsE7LxVu/F7QjC6VKs7ZRSy2UPkFtW1dkWhA1MAURm7tCzBanJBH36XB6mqF5XqZy5d80eDIFSm4+tlOO4+eAVvKyBxVZ+Plzzz9q/HLAgasKH
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(921020)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dWJIT1FVWU5YeVFjRXFmR2ZKTWVkLzB2b1JKN2UzT1A1d05Ia3loR245cmFo?=
 =?utf-8?B?ejFDNCtRaEVXSmxFL1dvdnM1VmM0czlVMXUwWFR6b3EvdjFFMHdQS0VLQm54?=
 =?utf-8?B?UUFIMmV3WVB5L0o3QjJOTkhaWTh5NHlNY0tLN1IzZnE4REw2Vm56K1BHSWxo?=
 =?utf-8?B?QUVtV1RrQUpwWmVJalU1V3lOSUxGNHFselhZd2QrNlpjRWs3QkVWQUF0aWRF?=
 =?utf-8?B?S0xrT2hoSXk4TkFKY0pjOXJTTHd6NUhOOEQwYmJkODdkV1lWUTAxRXlLbDJE?=
 =?utf-8?B?bU9DR2c3UlYySUkwRlpmaWdhWmhva3VRbVdiWnRGTkpmZHhTQmJwaWdZeUxS?=
 =?utf-8?B?WFpGZ0pVeE96OTBjai9FZ2taZWxtTVVQR1RVSkFuWnVqSStsa3l5UmtJUW1X?=
 =?utf-8?B?WXQ5SG9ESDI0YzJNa3RDbytIMUxodGwvSUF2Y0FHQ2FaQmR1UUUzTVNZRWxF?=
 =?utf-8?B?bTVTdDRpZksxS2IwaTducWpVSWQzckZBOUcvaEJ2bFArY1oxTzBCUEhDUHdP?=
 =?utf-8?B?dUxZeGV1S21zN0tEYzRvU2tRQ1dBMytJekl4NDN1ek9QOG1XMDQzMTgySzRh?=
 =?utf-8?B?aDQ2d3hoTi9iU25acFhGQThsemZjWUdnL04yUkQ5SmJoWnlKSGZ1R2FqaFJ1?=
 =?utf-8?B?LzRyYnVVL09OdHhqVVlvZCtiQi96TVJYRW1veWFpdncrdGJOeHRJVjFlUTha?=
 =?utf-8?B?ZVZMZnh5Vk5mVDdzMVMwOXZXR1hJVEc5ZWNaNHgrVjMwMkJtaDNCNXFyY0tJ?=
 =?utf-8?B?N09SbzdvNUFLYy94b0VRVlR0TVBXbHp0VnYrL1pHd2M1c1QwUHlLd0Q1K1VQ?=
 =?utf-8?B?QUl0cml2OHNpWFplSDZjcEhTUXdCS2dSd3FMcDdwWHJyZHhBemF1aVRwcWM4?=
 =?utf-8?B?VkVEdXRhbCtWeDhzdWxLNEZLWXk2T1ZpWHZITFZPK3pMVmtRellZSWdyUnpV?=
 =?utf-8?B?TTYxQVpobm5wbll5c05Ua1Zrcmw2VHIvMFQ0NWVkdXNmRWRFODJHL3RsZ3lI?=
 =?utf-8?B?eHFYRnRUakZ2eWRjb1dWenR2SEtIOEhycU5hUVA2NjdpWmNNa01OVjNDRWlh?=
 =?utf-8?B?WEx3NkJIblBrRFRQVjdWM3ZkTTkxb0RCQkFhSHdtb0U5a0FpK3ZXbjBGVWNx?=
 =?utf-8?B?U05OYkxLSE5CbGo2T3p6RXkwcnd3cnZ3MnNidzN2Y1NXMUc3U0ZENUYxdU0v?=
 =?utf-8?B?YWFwV0dZOEpoMDlFcml5Z3hrcWc0UnY4dk1rcDFBdUJFUWd2eUNSUXFabjMv?=
 =?utf-8?B?Q0JWYVAvYzg3M01QZ1BmZVJjTmhDaU5SK2pVOHJaWUZUcEpQb0ZRYkVrcEpJ?=
 =?utf-8?B?dmlqNkZ5QVY2Q3gyMWtxOGZNZWNOQ0w3aW9Fai8wdk5ITlZlaXZvRzV2RG9w?=
 =?utf-8?B?TmNrVHdINGE0QXc0VENPWEU1YVBpQnpLREh1ZndaUE9Dc3pXYmZoNGdlNGUw?=
 =?utf-8?B?eFFKUFVnYVNCWWRwbnFTNTlMRFVENWY2WGI0SW1CcVg2N3FaSFVCcVFEVzZV?=
 =?utf-8?B?anZ1YkFaaHBiTXVXTUNqVHlKZEtoQ0pkcG9DZDhQMFhZOEc3WFlUK0x6Ujhk?=
 =?utf-8?B?RE5qRkFCdnI0U25HdlFWYVJCaS95Y1N1MUE4TDhWdmdqTm9pS0ZJdDJwVnd5?=
 =?utf-8?B?Umx2VDUrRE1QVHFkWG9pWG5sS3Z6dzVVcjYrallHM0RnSFdIQ3Y1Sm4rYkhi?=
 =?utf-8?B?UDlnSWpJV2pLVEJ5Umk4eGxOTkIzNmNyY201c1BURSttNEFvTDVIY204UUNy?=
 =?utf-8?B?ZGRBYTdDTUZwS0N5T1ovNVQydURXdXZWUjByMjhVY3o2UFJFVlIzQ3FJbms4?=
 =?utf-8?B?OWQzT1ZQOEM1YW1GeU9LK1BJM3ZzRHNqNituNjNYaDNvS2VIVXAwVVhQRDIy?=
 =?utf-8?B?MU00NUlRalNVNnhlYmFaNlJrRFE0czJxRUtrVy85bDdHS3NiREpLTGRURUsv?=
 =?utf-8?B?SGlZbkpKTUo5TklMWEtvcTIvUkN6YXlrREJ1ZUpJcUo4L3hRWUQ4ZXd0VkhU?=
 =?utf-8?B?WCt2Z3NEYVdTeXlXMm9XVGFVQkFlMXY0ckxBQXZnSHFZRG52SkswaXJXWnBy?=
 =?utf-8?B?d3B0MEo4YUs2eTlmQkxSN2pvMmEwaGhzM1hGYXJ2TFFTd0VIdXJWM3hhdFQ4?=
 =?utf-8?B?RmxXZFh1M0MybEtRM1pTemY0ZGpnUklpS0ZJdm1FWWFJSmN2MWx2QjhEWExR?=
 =?utf-8?B?U3UxT2FLMkFId3VCQXNrbElkZWtvb29rbUMwS3hjdFl6NHc1bkZPdFcvSG9D?=
 =?utf-8?B?VytyTkdiMnhhSjhnb0MxRnBKNTVIU0FmUVFpVlB5U1dSWCs1SWozV3kyTXUy?=
 =?utf-8?Q?QkvQGKQmldqMnLT2pf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a73ae65c-97fb-4da9-5564-08deaae5b256
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2026 20:34:25.1512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w3a7Vm+ZkJH2dwbzOgb1m3WOCrMNmokpwrxlLzjSDRqsDUKH7BH166v63pY0fXsueiUbdg8U0ZAjMHPV2qi4kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9561

Hello Ackerley,

On 5/1/2026 2:12 PM, Ackerley Tng wrote:
> Ashish Kalra <Ashish.Kalra@amd.com> writes:
> 
>>
>> [...snip...]
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 3f9c1aa39a0a..e0f4f8ebef68 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -2942,6 +2942,8 @@ void sev_vm_destroy(struct kvm *kvm)
>>  	if (sev_snp_guest(kvm)) {
>>  		snp_guest_req_cleanup(kvm);
>>
>> +		snp_rmpopt_all_physmem();
>> +
> 
> I see this is what you suggested in [1]. The time-based batching you
> suggeested works because adding to the workqueue when there's already a
> job just does nothing. Thanks!
> 
> I think optimizing when the VM is destroyed makes sense, in most cases
> for SNP VMs, we don't expect large 1G blocks of memory to be shared
> anyway, so even if we try to RMPOPT on every conversion to private, most
> of those tries would be optimizing nothing.
> 

Yes.

Thanks,
Ashish

> I guess the remaining optimization would be to update based on only the
> range of pfns where guest_memfd has private memory, but that could be
> done in another patch series.
> 
> Reviewed-by: Ackerley Tng <ackerleytng@google.com>
> 
> [1] https://lore.kernel.org/all/31040bb7-653a-40f9-8899-40bc852f7e1f@amd.com/
> 
>>  		/*
>>  		 * Decomission handles unbinding of the ASID. If it fails for
>>  		 * some unexpected reason, just leak the ASID.
>> --
>> 2.43.0
