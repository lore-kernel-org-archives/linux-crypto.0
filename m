Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010002.outbound.protection.outlook.com [52.101.85.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE3A3A0E99;
	Wed, 29 Jul 2026 17:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785347516; cv=fail; b=UNVtOJo7EDBE5YsX0gxVSzJEwhsXt6PVF+0X8m4ubL+ctVb2wFzH9YN8m7VyfiGFY3sc40em3pqOZo7CQrtyasZecsOkCXGAHoM6lGKx8ahy2xg0BUJcXidBhdRAW09uaIW+fntOMOfhCyIfaZCH+sd5iLZal/N1Iacr37VBnWk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785347516; c=relaxed/simple;
	bh=jtoNynAwMkxnSp1UR++PH2+SWeaAmWPMZcCp9FcIx84=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QgrujZmlHcO8eI4WBsLFX0S44387LIzEWo8S4aTCF66rzD2SZfLY3S9fST/rX4n381/TX+V8m5whpy6f4tJjxe5QEl6CO3dQWGf6hB+pJmy3cR9RTDgsh+8M32c7RrK7hnvnXIHbo+XPDztSTkHwuawN9kEtShuDahpKVwhZ3Pc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YD0HQp6m; arc=fail smtp.client-ip=52.101.85.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YD0HQp6m"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BNYaEJpSbW3O2v8WxHzbj1Ucjzn9w9/+N3FxpntlZ7/dOrPdiUX9swZrO3PLQ22HCQcCjmKZWutkhIMOeufeNFVWOMrQuDZ3LGWVi4UtieF/x0+FDDe0xB1rkJoxxIZTtz+mwUE+od+ZkuJrJChgjkB8FP5rx0+78Q64Ifc/9oOKXOWQk0ISwuMfrPVj8cjDDg1AdfQMPjjpWWjkrmddLgmGh6gWHIDhfKK/CSsaMk2Z0VfFSmtsXHWv4aKBtj+PfCjxIZXp0H6B8brskRcoM2fjRyAeoBTw/5jmiiVN3Gsq/7ZS/m8fNTrsI3YOoNPE2Mc3j+YX4yvlSjk8B0iDMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FqjFnxWpgZH//WbWdsIV8rWiz5A6k2LJDbBFDzk5RlQ=;
 b=ILr6Cyq1qD5+oYeEYymKuFamqHSv91NuqKqxfF4JzSlvMIpjI0qaezbS5YhjXNe6Q9xotIpJDO7Ut9oslg3D9/8mxQDO2/hyVHwLx6Ho7P+jAcXpCYAWJspmdSrGcmnP/OEn4xKllABGc0e6pla1Yp4IivMzrrWiCDQwnxePWlLwHktesYZowfaGs3YE/q4zEPSdx9dK8jrhsA+H9F/OBw637qqJep+mo83lcS+4vXilq0mhSXR76Jls2tr9EOJj/JTc/e3EsOo5xXeBF71r56+T9zEH7tTYhMwZ/vqm8k2vQ7VmJeaWWNlatbvqyYfU0fgKloEWC0RpKKDlJZtQuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FqjFnxWpgZH//WbWdsIV8rWiz5A6k2LJDbBFDzk5RlQ=;
 b=YD0HQp6m/RntRuTot7HPTjv34ZGhoPCqVlcAK1V2IAt2UYJOXRXTYfa7ffnGU3TkI8Sz0GRgqYGsZA+Ia1C9Wu2I+CW4Og2Ymu9JoTBFCb8/xTLE9vuPgbv2fz07KgCE0vwajkL0gLaKLIH9gkDyoaMB1W28Pg6oCLmjbp1MLp4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by IA1PR12MB9499.namprd12.prod.outlook.com (2603:10b6:208:595::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 17:51:47 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0270.012; Wed, 29 Jul 2026
 17:51:46 +0000
Message-ID: <b54b51ab-ea28-4801-bf7f-6629e0b35d9b@amd.com>
Date: Wed, 29 Jul 2026 12:51:39 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 2/6] x86/sev: Disable CPU hotplug while SNP is active
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
References: <cover.1784844080.git.ashish.kalra@amd.com>
 <e1631971b3862bcd6043199feba3df51f3ba336c.1784844080.git.ashish.kalra@amd.com>
 <20260729021520.GEamliOMT67p8svCoM@fat_crate.local>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <20260729021520.GEamliOMT67p8svCoM@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0035.namprd04.prod.outlook.com
 (2603:10b6:610:77::10) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|IA1PR12MB9499:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ddffd7a-e0b2-45ba-c119-08deed9a0ed4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|4143699003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	m2UWvjYb1M+dojDZ8fSIH5cRTM+63fmT4O+Pu0nzJv/ertDtOzMxELg0eIfAcSz1sXrUVc4sIP83VGTjctvc1vOfUvB/Jkcu++2+40CZ0E6Sz63LqgdiIWHfLdz8cxww+9shipEoFzxhfOMAOFIFqDXQc75UDCIvrGB4Lfjrrd2bBy1MRPIy2TiliHhcQd4jhmzdctsX1DHbFhn0EUQrIFDSvw0l64hqwx5YFc/P1tT2mv241NzvVb9gDNJuEPOgCE7CZxff5jJsqJm6/efEGOeFBe7k0TaT6aQOKVtxaEy7lun7NL9XtCD6iXwWPBDRsljupNdr392Lpd9Ryx/sTpDwMzzBZQIb1yCeoKvNjUNQy0nZEkYxt4sCT2BpdqnyBZYZXg9QNn+b8t586YNzojwzho324nlMphDq9tPrVDv3O0shpR+K5SwR+inCE0eWspptc8WEUsw16IA7tEE40WIkiKZH76c+PrlPfwHq53k92PNe0Nd194oqEXcL8GtpEOsJM1VVkTc+mDK8rf3f8DXE6sOqcPwAd2ArPMpY3xNXRXvzJ8edN45B8j48mPZL3Iz+NfceHAEhPziU7DPvhJLCIYsBp3PBcVlW3GRKd7mko6aozQvcgsuE4JfCOSCzdlw0woEjrRNzKU2UD/iGzHYmPQFfeYSWJzUl+7kwvk8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(4143699003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bnp2TWVhZFVOOEJwWVJJTXp4NFI1WSt4R3k3UUpTa2trUktrcmlLTm5FYWJx?=
 =?utf-8?B?Z2Q3Uzd2NlJtMFVYNjJHNlBSQW5ISnRkSHFFbmlVcUhRbEpsZ1k1a3pnNWlk?=
 =?utf-8?B?bDNRWVVMNlFySW13akVja25EbW5BdU53OHZLNjBUcGdyQUFnZ0dpRWd4azZQ?=
 =?utf-8?B?cEttYXVZR2hUT0N0dHZDVVErbXpYYmhIY2NmZjQ2RU9ZWm1hNGtOZWIyWlNx?=
 =?utf-8?B?U0tHTVV2Y3VzcDFvazZRdTc5SEUrWnpIRHZ6UUVxRGx6RGZWd2pFbkIzZzJU?=
 =?utf-8?B?TzhGeGVHOGhsdlRROG1OUG9aMEwyVE91Z0p4VTkyQU1VeUdYYXAvQVE5S0gz?=
 =?utf-8?B?UlY4T2xSSU5oclJTekkyZEpWd1V5eklYRUJabjJkUjdTUUFKNnc2YUVLb3l5?=
 =?utf-8?B?b2lmK1FMWUVMVmUzOGhjZWpyalBVUGlVVnBJMWpLb0tqNHZSbEdkOWZFZmlZ?=
 =?utf-8?B?RWc4bDBrUmhJN0Q2OTI2dDFvekloa09INEdzOGZvc2lPU1Nhb0lyZUhkYXJI?=
 =?utf-8?B?eE9aT29tZE93aHBka1AyMFJSSVJBb2lXV2FjZXhLSHdKOHFYakd4OTN3aVpT?=
 =?utf-8?B?S2lmTHJscm5RZFFRYTFFbmxhM2JEZkIyVGMwSjdJdE9YRHlFQ3JmM1JJcTVz?=
 =?utf-8?B?SGZnUFBRWkd5Y2lQSUJSSzR3LzUwMjNObXdldE1MdDZvc1RiaEJGbnZEeHZj?=
 =?utf-8?B?elUrY1RkU3EzTndFejhCNkppOFF5Z2M3TS9PNXk1ZGdXVitMQ1VOZGFUeWVz?=
 =?utf-8?B?ZGtMdzhJTmtwbnZsaGVaNkw0Nzl6UmVWK2ZRVEhQdzdGS1IyendLejB3UjRl?=
 =?utf-8?B?aWFsamg4NGo2dlFmQlFkY2dJUkM3WEY4Q01HRHBWNndKVW1INlVKZzlWTytB?=
 =?utf-8?B?RnVpNCtUTXRaMGR3RDBCVENWUDBldnJNNzNFY2drZjN0cjJCc1ovSWtPbU1r?=
 =?utf-8?B?am16OWpGV1NDOFhjL2NvaGloZC9oSWZxRWZ2K1F6eXJFa2IvQ1lKYWEyb0R4?=
 =?utf-8?B?OHl4L29ya1FZNXhSWEcrdXpPNXJqZ3NPN0I4V1dNQWhMTHlaNFZkTkV4b2lr?=
 =?utf-8?B?R2cvTGUvTE5jUzNmazFrQyt5QUxDdGgzZGRINHFybFNTVkIzS0EwM1J2WHB6?=
 =?utf-8?B?d1NIVTBseFRWSVVRQkxoVmdrSmQydy85TlRzSTYvZHREVCtFdk9JNHNQNExJ?=
 =?utf-8?B?S0JTTUJ4OEY5blVQbldMdTZtZVVjeGZ0dXhzRHJqNWs1SmUwYWFZUVIrUGI1?=
 =?utf-8?B?ZUhDV05ES0FaTFBaQjhRMWczNWFyOGJNbmhvU3J2WFgwdGpTU1hoUVZxd3Z1?=
 =?utf-8?B?K3drbmlvMGJVdTM0WmZOMXRoOUF5aFBNZm1icHdSeURMNHpNQkxEem5FbjF0?=
 =?utf-8?B?YUg2Q0ZFditFSTl3d2them1CRUhaYjFCd1pRUWQ5aTRGUXlXeFpkNDVqbmRh?=
 =?utf-8?B?eUlVMkxiRDUzSFd4WFJmdm1QSWJuL1hremk3d3hyOWwyTDIrWW5ZVG9YOFpj?=
 =?utf-8?B?c3AzVlNORDh2Y2Fsdk95ZXNkczdQZkc0dVhFNGtFZmVBcFUvZWc5UnhIaXRm?=
 =?utf-8?B?Sjh2N1FreDJrbjl2ejR1bVhnaVAzM1FTV04yS3dlVW9HNnFvWkZ2Z1ppRE1p?=
 =?utf-8?B?enNDWHFuek9tUjRuM2lqOENwSC85L2U0SzB3MFEveGxXalFZc1lpY0U3Wkw2?=
 =?utf-8?B?VnNmSFpOTmQyQ3laOHZMR3dBV2lhWDZrNmN6SnhjYldzaFN6OTlTZzNBMXI1?=
 =?utf-8?B?MUdnbW1JU0JVK0dUeEJnbVg5OVRoU2VaNXZDVlhFYTdZd3dTUUR2RUlLbU1p?=
 =?utf-8?B?NWN2empKVE1zeThyVTZvNi90ZkJTQzQ0NEFIYUhUc2hCYTVFbFRiaHh6VHFq?=
 =?utf-8?B?VDFmajJDTmttM1hQUS83OEVRenVGT0ZMMGxnWllYS0I5Szc2SUNYazl5dEdy?=
 =?utf-8?B?amtYQzdxd1NJd3ViY2NsYzMzdW5jMjJwbVN6cUxjOCtjMWNvd2VxVE5wcU0w?=
 =?utf-8?B?VGlwSndFbktmb0JoZXBBblFlWndiNUVmK2ZncTBLZE9FSEFKTG1MVU5LMmJC?=
 =?utf-8?B?WHROcy9IMTNKTldXYzdYelZVME04dHJ2RU5JVWRkazNYOHV2Y05YWkxyVER4?=
 =?utf-8?B?V3REaVp3SU9MQ1pBT3VGbXV1aTR0T1paVXpzVHZ1STAxUXZzcFpIZHNWR1hz?=
 =?utf-8?B?dVMySjdkelAxV1pEQmlyZGR2YWpLRUU2RG44RitiZkd6ZkpQcm55a0VPRGhF?=
 =?utf-8?B?dndodDZsREp0amZ4NjlSU0tRTzIxQUZ3SCtQbllMcnZ2WDlMNU55aEt6U0Va?=
 =?utf-8?Q?F5GuSAnvvhxU9nMj7U?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ddffd7a-e0b2-45ba-c119-08deed9a0ed4
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 17:51:46.5222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PT8ma5zPB4SgyhytEA05lP6icoZFuV5O0yQ3kwjTCk+YQxDwXRzCm2h9TgGYUrfqsLkd/OAMEYB40mdHIpqhUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9499


On 7/28/2026 9:15 PM, Borislav Petkov wrote:
> On Mon, Jul 27, 2026 at 07:04:31PM +0000, Ashish Kalra wrote:
>> With CPU hotplug now disabled while SNP is active, the online CPU mask is
>> stable, so the cpus_read_lock() previously taken in snp_prepare() to
>> iterate it is redundant.  Drop cpus_read_lock()/cpus_read_unlock() here.
>> The RMPOPT setup and cleanup added later are introduced after this patch
>> and never take the lock for the same reason.
> 
> Why do I even bother writing it?
> 
> "do ... not talk about future patches because git history is not always
> linear"

Will drop the future patch reference from the commit log.

> 
>> Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
>> Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>  arch/x86/virt/svm/sev.c | 39 +++++++++++++++++++++++++++++----------
>>  1 file changed, 29 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
>> index cff285d8ad8e..e2f69fba0938 100644
>> --- a/arch/x86/virt/svm/sev.c
>> +++ b/arch/x86/virt/svm/sev.c
>> @@ -513,7 +513,6 @@ static void clear_hsave_pa(void *arg)
>>  
>>  int snp_prepare(void)
>>  {
>> -	int ret;
>>  	u64 val;
>>  
>>  	/*
>> @@ -526,14 +525,21 @@ int snp_prepare(void)
>>  
>>  	clear_rmp();
>>  
>> -	cpus_read_lock();
>> +	/*
>> +	 * Disable CPU hotplug before enabling SNP: no CPU may come online
>> +	 * without SnpEn while SNP is active, and none may go offline during
>> +	 * enable.  This keeps cpu_online_mask stable for the check and the
>> +	 * on_each_cpu() calls below, so cpus_read_lock() is not needed.  It is
>> +	 * re-enabled in snp_shutdown() once the firmware disables SNP.
>> +	 */
>> +	cpu_hotplug_disable();
> 
> No need for too much splainin' and besides, that comment'll grow out-of-whack
> sooner than you think:
> 

Will trim the comment.

> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index e2f69fba0938..731ea25fba37 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -528,9 +528,7 @@ int snp_prepare(void)
>         /*
>          * Disable CPU hotplug before enabling SNP: no CPU may come online
>          * without SnpEn while SNP is active, and none may go offline during
> -        * enable.  This keeps cpu_online_mask stable for the check and the
> -        * on_each_cpu() calls below, so cpus_read_lock() is not needed.  It is
> -        * re-enabled in snp_shutdown() once the firmware disables SNP.
> +        * enable.
>          */
>         cpu_hotplug_disable();
>  
>>  	if (!cpumask_equal(cpu_online_mask, cpu_present_mask)) {
>> -		ret = -EOPNOTSUPP;
>> +		cpu_hotplug_enable();
>>  		pr_warn("SNP init failed: not all CPUs online. (%*pbl online <-> %*pbl present masks).\n",
>>  			cpumask_pr_args(cpu_online_mask),
>>  			cpumask_pr_args(cpu_present_mask));
>> -		goto unlock;
>> +		return -EOPNOTSUPP;
>>  	}
>>  
>>  	wbinvd_on_all_cpus();
>> @@ -548,12 +554,7 @@ int snp_prepare(void)
>>  	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
>>  	on_each_cpu(clear_hsave_pa, NULL, 1);
>>  
>> -	ret = 0;
>> -
>> -unlock:
>> -	cpus_read_unlock();
>> -
>> -	return ret;
>> +	return 0;
>>  }
>>  EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
>>  
>> @@ -565,6 +566,13 @@ void snp_shutdown(void)
>>  	if (syscfg & MSR_AMD64_SYSCFG_SNP_EN)
>>  		return;
>>  
>> +	/*
>> +	 * The firmware has disabled SNP (SnpEn is clear), so re-enable CPU
>> +	 * hotplug.  A legacy SNP shutdown returns above with SnpEn still set and
>> +	 * leaves hotplug disabled.
>> +	 */
>> +	cpu_hotplug_enable();
> 
> What happens if CPUs get offlined here after hotplug has been enabled and...
> 
>>  	clear_rmp();
>>  	on_each_cpu(mfd_reconfigure, NULL, 1);
> 
> ... they miss the mfd_reconfigure()?
> 
>>  }
> 

Yes, re-enable should happens last in snp_shutdown() (after clear_rmp()/mfd_reconfigure()).

Thanks,
Ashish
