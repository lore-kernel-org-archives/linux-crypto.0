Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011014.outbound.protection.outlook.com [52.101.52.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C70B314D16;
	Thu, 28 May 2026 23:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780012360; cv=fail; b=ApWlQdfL8u0CLR6EQUHtXiwmjnpNkbWVxxTPWm+sXLBeiSNQpJetqfhTr4V3uK2/aG+ErF3wcFyQmqIHijrI0okEUgSESG8l+m4ajx7sFEJPF9uY0yFjIRsCSgxcufm2rig7r3cxpLjPgQTOTgffTGXvLCeRiPxnoEE6RSHYCs8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780012360; c=relaxed/simple;
	bh=6C3oIXDWlU9kM7lroWXQm1AToM1iS/UZFcXMNiWXY40=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iDCG2nQ+u/0uc6pcBW/Ee2mpgPRy2bMNGIowskXx9vOvEjvrm04EYhd9DChb/UbqMkTfEAVLIYrXIbtuxpW13/CXQ3FyeWxifvkVB/vVGhIHbHRyFBPR7xmnqNTB9t8pWgX4I9frB3Qhfk4QMHCUO/SmOHSLLwAr2DO/sevnIqk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=E1YMAK2m; arc=fail smtp.client-ip=52.101.52.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="E1YMAK2m"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yiu6a9XSSuyTR7s7/xLVT0ZhxGB68wImwAyjBMFsRCW2fn+2+o26YGdAlrU5FvzBMpPqsMQVKoZlgWVIwGn+8PMNPIzKFZdwmHRC7AKY3khc/1gHWyIH6Z0wAynZxMJ7OlLe5BmkncDjrHIjE9AqZjqZ/GNOoIa1niXfCIF/s0JDvTUKx7ORbaeM4RC6QblzOfmcTUMv9XyoiI+xH6PXubwLufnJvg60nn0GGknk28gVAN6lQbTjnAZs54K1dqWKzY08KQIjEuq7HkP9oOnU6b66fEWcsNysutudwiPSlW7AxO5wIFF0keMzkopBX/qf4i0wven8l7A9vzdhZLi2/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7zyF78lHsOVFRZkmcjYwY2coAeENoGVQ65NcGSEO5UA=;
 b=IJ5f5zVSFoc3iF5gcOtmNGEeyHriW7CF7/q318ClQTrDC05BANGwLYDsB5FKHeHIFewKjeUVXv6Tr0Lc3CKufBuodQQ+pc1prpkqqTNhFniNmXbOiLg4ZPh/QBkgK8ayRTvJjswhZP6K/WQyJk3QGFE8wJjFUlHaQN8rzvnOVhSyG9Q/py19l7G4Vgr/otN0XyWYzRScEmLFDTShcSHdfRB/0g+ODaCt7KJoKXfVmKxivr8H8Q6PF5l+sAsKdozYR04xt/3k4X8uBJ8P9BM8TJNvWVpjllFOVK1YUU/9oICX/ZUUcj8UkJ5ZTZAeebHGOsijJTQ/ApKcEo6ybTaZTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7zyF78lHsOVFRZkmcjYwY2coAeENoGVQ65NcGSEO5UA=;
 b=E1YMAK2m93lN+h8HBn1VSChxqx+FZV/ckYIBZC6NT+lUljzI5/MsnCz2Fg0vbZG7A9Sx9NFLtPGAyvdSvl/qz6Bk2qYtqsPLYF5i4aqhZE6Vj97E19lWifiyWokWsghagN+hyNtFJkeWj1LhhSw/S34VM3K9QTyRsKrL7zNH/yo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by PH0PR12MB7488.namprd12.prod.outlook.com (2603:10b6:510:1e9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.14; Thu, 28 May
 2026 23:52:31 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.21.0071.011; Thu, 28 May 2026
 23:52:31 +0000
Message-ID: <8b7f6c93-ad5a-45e1-aa70-945518d29ddc@amd.com>
Date: Thu, 28 May 2026 18:52:27 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/7] x86/sev: Add support to perform RMP optimizations
 asynchronously
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
References: <cover.1779133590.git.ashish.kalra@amd.com>
 <6f1ec3d8ebcf3aaceccc099c07d0deb545dd4ab9.1779133590.git.ashish.kalra@amd.com>
 <CAEvNRgGfyb7zvZ1u1j7YLomD+JdAxnVW36gtvNG9gxgZ80vMyQ@mail.gmail.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <CAEvNRgGfyb7zvZ1u1j7YLomD+JdAxnVW36gtvNG9gxgZ80vMyQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR13CA0030.namprd13.prod.outlook.com
 (2603:10b6:610:b1::35) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|PH0PR12MB7488:EE_
X-MS-Office365-Filtering-Correlation-Id: 30e112fe-4271-41b6-4d1b-08debd142e84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|18002099003|22082099003|921020|11063799006|6133799003|4143699003|3023799007|56012099006;
X-Microsoft-Antispam-Message-Info:
	CV0BvoRXdn5g9ZHSIRoz1rr/fvq7u7BkLws3p+8G3iowncd3mzMiuKAewx+BkgTpefDWCVbN+wBjKW3XRwSOE/eLjVieekKbf+MQkrgDt1g04MwH/YxaqllUolpfw9txml0SmezpVPmnfIyCC+qqzv9Qe+ln42gN5WpoOUuM+CPKTe73BlfnH7EnWeiWmtaBNK63MRIvN7qUiibngutyWfe4ge4QUq6tHlIfzBHQIlIDr5RZlswK1QpFMvJgDYHtzAFje5hl5wd+kYhWj4/P5uhJUwxmiYp5UwqC1sVNEgE73GyA3RLzZq6spKx8rSkruC51g2i2rhyJmt6g0F1ULrv+H4lYNbgmADYRQGTWMhny+SfMC4vJN3uCh9zIeBnlLYSEjR/0FEbyHnV65mSZsLT3yLIjo+tl33NO+oIWq/GWqF+RenaHhthGOOMfgmcshyLHe7ZyzVlttkQ3/EFb+6eBoRZMuofEsAf2efVLJ7+Q8KoCKonJq/M8fJ8y2GylJIBsTuo5ogZEu3vpfTf3TYAbCjxsWM0dyg81GtssqbStVZvAQ7Ah0B+ErKJIgGf3vlv/6lrf/K8OGhv5XEfBjP/2SLGbgF/+2PgfUnIKn6B58nlFcoFFooPW3/twUfpx11vTV4CPHgz8aEiWF2RLjLC5FOmjJR6v9NCVgQN52pfxR8n07opp7Y+9j0k5BZEi3XSxAhPvdhmAPnE+bZDi4opsxa+8ZZifJfur42x/uQ8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(18002099003)(22082099003)(921020)(11063799006)(6133799003)(4143699003)(3023799007)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UnlvdDJwblljZjlTYkVGSzB6aWdBNEg5K2p5bjNNK0pHZUNZdG9Hd2ZqS0NE?=
 =?utf-8?B?a3Bzc2ZMcC84QTFmdThvbENIeU1ueEJ2bE45U2FjUm5VT0I0THpycHZZdTgy?=
 =?utf-8?B?OENoMXlZTU5HYnhLSTBYYkhQZ3l0WE9Dai9MRzlCMEtXRFNSZStrK2R1dS8w?=
 =?utf-8?B?Y3NmdGJyK2lMV05kOVpGeUQ3MnNYN1N6TlA3VzRKbmVNL2pUa0hSZGdKdFQ1?=
 =?utf-8?B?YzZhUGNMU0x2K0YyT25abGZNclJzSk9kamEyWjFuajJqeW1IVmhZSTk5ZkFW?=
 =?utf-8?B?T1ZjblB0R2RUVEd1bVo3Q08rMHNiTHM4N3VLRVkrZWxJZzNSSXNvdU84S1BW?=
 =?utf-8?B?S1ZzUkY2M0dvNFIwQ2dPaFVYODg3NUNPNGRyOSs4L2pENVNMcTNEZ0VDS3VY?=
 =?utf-8?B?aUc5eW9ZSXdkTmo5RHV5YjJvaFJROGFrOFdwR0NlbVpUQ2lQeGZqMDkwd1Y0?=
 =?utf-8?B?R0R5QUFjNWQ1Yjl5V2xiSjFKMWF4Nnp6QTN0N2xsV1lBeXU5UWpRSmRxR2tQ?=
 =?utf-8?B?bjRGRmx1NmdNTlJHeXNFekhtaUhIZXlDY2orMDRsV3JWTnlXNmdocndWNTRZ?=
 =?utf-8?B?eklMeVYzcVRPMEtkZlFNRUhCMDQyZVJhRWtqYkhMWWlaVXQ2QVJNOGNHQlhL?=
 =?utf-8?B?SXFoRUREYll2Z05IRXJmZ05YMDM2dldLM2pmREJxM2ptQStUS0U3M0poQ0R1?=
 =?utf-8?B?NzRPbUhIQ1B2OWc3dUhMNG1oVGh2VUdBWldBaVRoem9oNGRlUmFOTncxeU52?=
 =?utf-8?B?WVV5MWFMcnVCT1RCTWdBY25WQ0Y5UURYUWlkM083MW85cmxsOEk3dm1SdFYx?=
 =?utf-8?B?S29UZm0ySExLVnpDTnU0TjhjMXpPWEY1YTV3ZXlnWHV1cmVhU0x5ZzNCTjdF?=
 =?utf-8?B?UjBzS1JyOUx3QnA1VEcrcmRudWI2UzRtSDUrQ1lhYlBEa0hFMFp2dzdYVHJQ?=
 =?utf-8?B?RTY1akU3ZHBhaEtRRWlrU1BqQWYxc0ZRUDZZYWxTMCtUWU50TUhSaVFETElB?=
 =?utf-8?B?Qmd1V2F1VkR3N0lTamQvaWdPTmQ4L1ZPNDBOVExEdEdJL3A5T3FzZ1ZScXl6?=
 =?utf-8?B?OGFGMFIwNlZ0blNPbEJqR0tZdERQRjM2eEdUaWs1bUNWYk02R2hrdlZmR1kv?=
 =?utf-8?B?eitUSnBUNytYanYvMFJYNTlyOFM5TmF4R3lJWThqbHBuaUpwTnFPa1JEazV4?=
 =?utf-8?B?Y3BNUHdOejVDWVRFVXoxNGsvWFJwOGxmT21ScGVmL2xLbDhOem9MTzNJRmJS?=
 =?utf-8?B?UHUvWktKc0JKOWZkUlJyTC9WKzVDeWY1WHNod0NSc0YwcTE0WXVnUWE4ajJm?=
 =?utf-8?B?Q1pOM0VFSEhGTWN3TnpUajI3Y2RnMkpUc3lwVTVHeW5wQm10NGRERVgwYkVz?=
 =?utf-8?B?MDFJdE5nYXQyK1N1WlFkN3VKeEgrQU5POHZhT3B2cTg3S2QyRndnTUlEeHdr?=
 =?utf-8?B?WjBycXVub0k4NG1RQ0ZQOFYxa0tzbG41ZkRSZVEvRUVMU3FzN3VqYVl4d3hC?=
 =?utf-8?B?R3BnSTN3WGp2VzduZjRTNS9NalI0blZOenJTeWRQSFlIeU95Nklmd0I0SlhR?=
 =?utf-8?B?NjQ1QytleDNyWFYvYVJNT2NSNFVpd2hCc3pNNGREOGFwd0MxamhXcFUyUCs1?=
 =?utf-8?B?b1IrYjV5V0k2WnhJMTVtVnBFa0N5bHhaQ2o0bVJUaTlwLzgzcFN5dCtXbS9p?=
 =?utf-8?B?bGVETXBiZUgzTDFLRktzc2tEbHBSdWRIaHRHQ1hVelBraDlMb2NtUzQwa0pI?=
 =?utf-8?B?VzdobXdGd3Q2RWVNYVk1VmYzWmF3YmgxQTgydFVwUFRyWC9WQ2FqN1RLbnZB?=
 =?utf-8?B?bjgxUnNEN2JURFI4ZUlEYkxOd2RnMXhRYXpCNUlYYWZaSlJsNS83L1N6NG01?=
 =?utf-8?B?eDBwYTQ2dXJKdkxLdzF0NWs5OU5nVjZXdEt1b2FrYVA4anQ3RWY0L1ZhQk4r?=
 =?utf-8?B?bHowb28zcHNjOE1TZ3VQL2swRDdEKzI0TjIvaGJMRHlEcUdkZjNuV0RDV1FR?=
 =?utf-8?B?RENwVTdYTEZmNEpLK0J2dUJGMzIyUUkzTTJldUsyQ09xbVhkUE9jeGtyNm5r?=
 =?utf-8?B?Zmc1aWtOWFh3UmxoSnZhMmFpREZDdXVsTXZnc01kTmR3aEN6ODRibmtlU3F6?=
 =?utf-8?B?cURoczk1QkRQQ2xoTVBneVBFak9HTGsrS1ZNWFNHYlg3YXluNE1OTzdaNi9q?=
 =?utf-8?B?YmF5VFQ5eGQ3YzAwVk5FY0hXSzlYUHN2VHF3dUMyUE50T1FHa3dTOUg3SG5m?=
 =?utf-8?B?Rlk2T09IaVVvVDNZN3F1MGRReFp3ZmpzSHVjaGRDYXBlbDBnblM2SExEdmsw?=
 =?utf-8?Q?/OLKphMKSeBot36ODC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30e112fe-4271-41b6-4d1b-08debd142e84
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2026 23:52:31.3697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K/x9DfYPPOfox0kqqH22zICShRcez3dioIgHT5Lck15TIT3BD0LWqG6rXKjjU49mP5da8sRAPKnKjg1gLXhzdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7488

Hello Ackerley,

On 5/28/2026 9:45 AM, Ackerley Tng wrote:
> Ashish Kalra <Ashish.Kalra@amd.com> writes:
> 
> Thank you Ashish!
> 
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> When SEV-SNP is enabled, all writes to memory are checked to ensure
>> integrity of SNP guest memory. This imposes performance overhead on the
>> whole system.
>>
>> RMPOPT is a new instruction that minimizes the performance overhead of
>> RMP checks on the hypervisor and on non-SNP guests by allowing RMP
>> checks to be skipped for 1GB regions of memory that are known not to
>> contain any SEV-SNP guest memory.
>>
>> Add support for performing RMP optimizations asynchronously using a
>> dedicated workqueue.
>>
>> Enable RMPOPT optimizations globally for all system RAM up to 2TB at
> 
> This should also be updated to say "Enable RMPOPT optimizations for up
> to 2TB worth of system RAM at..."
> 
> The current phrasing sounds like only addresses [0, 2TB) are allowed to
> be optimized, but actually any address [start, start + 2TB) can be
> optimized?

Yes, i will update it.

> 
>> RMP initialization time. RMP checks can initially be skipped for 1GB
>> memory ranges that do not contain SEV-SNP guest memory (excluding
>> preassigned pages such as the RMP table and firmware pages). As SNP
>> guests are launched, RMPUPDATE will disable the corresponding RMPOPT
>> optimizations.
>>
>> Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
>> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
>> Reviewed-by: Ackerley Tng <ackerleytng@google.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>  arch/x86/virt/svm/sev.c | 167 +++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 164 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
>> index 82f9dc7a57c3..8876cac052d5 100644
>> --- a/arch/x86/virt/svm/sev.c
>> +++ b/arch/x86/virt/svm/sev.c
>> @@ -19,6 +19,7 @@
>>  #include <linux/iommu.h>
>>  #include <linux/amd-iommu.h>
>>  #include <linux/nospec.h>
>> +#include <linux/workqueue.h>
>>
>>  #include <asm/sev.h>
>>  #include <asm/processor.h>
>> @@ -125,7 +126,18 @@ static void *rmp_bookkeeping __ro_after_init;
>>  static u64 probed_rmp_base, probed_rmp_size;
>>
>>  static cpumask_t rmpopt_cpumask;
>> -static phys_addr_t rmpopt_pa_start;
>> +static phys_addr_t rmpopt_pa_start, rmpopt_pa_end;
>> +
>> +enum rmpopt_function {
>> +	RMPOPT_FUNC_VERIFY_AND_REPORT_STATUS,
>> +	RMPOPT_FUNC_REPORT_STATUS
>> +};
>> +
>> +#define RMPOPT_WORK_TIMEOUT	10000
>> +
>> +static struct workqueue_struct *rmpopt_wq;
>> +static struct delayed_work rmpopt_delayed_work;
>> +static DEFINE_MUTEX(rmpopt_wq_mutex);
>>
>>  static LIST_HEAD(snp_leaked_pages_list);
>>  static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
>> @@ -564,12 +576,21 @@ EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
>>
>>  static void rmpopt_cleanup(void)
>>  {
>> +	guard(mutex)(&rmpopt_wq_mutex);
>> +
>> +	if (!rmpopt_wq)
>> +		return;
>> +
>> +	cancel_delayed_work_sync(&rmpopt_delayed_work);
>> +	destroy_workqueue(rmpopt_wq);
>> +
>>  	cpus_read_lock();
>>  	wrmsrq_on_cpus(&rmpopt_cpumask, MSR_AMD64_RMPOPT_BASE, 0);
>>  	cpus_read_unlock();
>>
>>  	cpumask_clear(&rmpopt_cpumask);
>> -	rmpopt_pa_start = 0;
>> +	rmpopt_pa_start = rmpopt_pa_end = 0;
>> +	rmpopt_wq = NULL;
>>  }
>>
>>  void snp_shutdown(void)
>> @@ -587,6 +608,105 @@ void snp_shutdown(void)
>>  }
>>  EXPORT_SYMBOL_FOR_MODULES(snp_shutdown, "ccp");
>>
>> +static inline bool __rmpopt(u64 rax, u64 rcx)
> 
> Perhaps use pa_start instead of rax and op_type for rcx?
> 

I used these parameters to align with the RMPOPT specifications (rax and rcx)
which i think makes more sense.

>> +{
>> +	bool optimized;
>> +
>> +	asm volatile(".byte 0xf2, 0x0f, 0x01, 0xfc"
>> +		     : "=@ccc" (optimized)
>> +		     : "a" (rax), "c" (rcx)
>> +		     : "memory", "cc");
>> +
>> +	return optimized;
>> +}
>> +
>> +static void rmpopt(u64 pa)
>> +{
>> +	u64 rax = ALIGN_DOWN(pa, SZ_1G);
>> +	u64 rcx = RMPOPT_FUNC_VERIFY_AND_REPORT_STATUS;
>> +
> 
> And pa_start and op_type here too.
> 
>> +	__rmpopt(rax, rcx);
>> +}
>> +
>> +/*
>> + * 'val' is a system physical address.
>> + */
>> +static void rmpopt_smp(void *val)
>> +{
>> +	rmpopt((u64)val);
>> +}
>> +
>> +/*
>> + * RMPOPT optimizations skip RMP checks at 1GB granularity if this
>> + * range of memory does not contain any SNP guest memory.
>> + */
>> +static void rmpopt_work_handler(struct work_struct *work)
>> +{
>> +	bool current_cpu_cleared = false;
>> +	phys_addr_t pa;
>> +	int this_cpu;
>> +
>> +	pr_info("Attempt RMP optimizations on physical address range @1GB alignment [0x%016llx - 0x%016llx]\n",
>> +		rmpopt_pa_start, rmpopt_pa_end);
>> +
>> +	/*
>> +	 * RMPOPT scans the RMP table, stores the result of the scan in the
>> +	 * reserved processor memory. The RMP scan is the most expensive
>> +	 * part. If a second RMPOPT occurs, it can skip the expensive scan
>> +	 * if they can see a cached result in the reserved processor memory.
>> +	 *
>> +	 * Do RMPOPT on one CPU alone. Then, follow that up with RMPOPT
>> +	 * on every other primary thread. This potentially allows the
> 
> I like the leader and follower comments below, thanks! With this
> leader/follower setup, will the followers definitely see the cached scan
> results, or might the followers still potentially not benefit from the
> caching? If it's still only "potentially", why?

I am verifying with the H/W architects if this is always going to be true or not,
will the followers always benefit from the scan results cached by the leader (first CPU)
or there is a possibility that the followers cannot see/access/get the cached results
and instead do full RMP scanning ?

> 
>> +	 * followers to use the "cached" scan results to avoid repeating
>> +	 * full scans.
>> +	 */
>> +
>> +	/*
>> +	 * Pin the worker to the current CPU for the leader loop so that
>> +	 * this_cpu remains valid and the RMPOPT instruction executes on
>> +	 * the CPU that was cleared from the cpumask.  The workqueue is
>> +	 * WQ_UNBOUND, so without pinning, the scheduler could migrate
>> +	 * the worker between the cpumask manipulation and the leader
>> +	 * loop, causing the leader to run on a different CPU while
>> +	 * this_cpu's core is skipped entirely.
>> +	 *
>> +	 * Use migrate_disable() rather than get_cpu() to prevent
>> +	 * migration while still allowing preemption.
>> +	 *
>> +	 * Note: rmpopt_cpumask is modified here without holding
>> +	 * rmpopt_wq_mutex.  This is safe because the delayed_work
>> +	 * mechanism guarantees single-threaded execution of this
>> +	 * handler, and rmpopt_cleanup() calls cancel_delayed_work_sync()
>> +	 * to ensure handler completion before tearing down the cpumask.
>> +	 */
>> +	migrate_disable();
>> +	this_cpu = smp_processor_id();
>> +	if (cpumask_test_cpu(this_cpu, &rmpopt_cpumask)) {
>> +		cpumask_clear_cpu(this_cpu, &rmpopt_cpumask);
>> +		current_cpu_cleared = true;
>> +	}
>> +
> 
> Instead of reusing the global rmpopt_cpumask, why not make a copy of
> rmpopt_cpumask for this function? Then this function won't have to
> figure out current_cpu_cleared or restore rmpopt_cpumask at the end.
> 
> I'm thinking to also drop the test and clear, this function can just
> always clear, like
> 
>   cpumask_clear_cpu(smp_processor_id(), followers_cpumask);
> 
> and later
> 
>   on_each_cpu_mask(&followers_cpumask, ...);

That's surely a much cleaner approach. Instead of modifying global
rmpopt_cpumask and using a local copy:

  cpumask_var_t follower_mask;
  alloc_cpumask_var(&follower_mask, GFP_KERNEL);
  cpumask_copy(follower_mask, &rmpopt_cpumask);

  migrate_disable();
  this_cpu = smp_processor_id();
  cpumask_clear_cpu(this_cpu, follower_mask);  // modify local only

  // leader loop on this_cpu...
  migrate_enable();

  // follower loop with follower_mask...
  on_each_cpu_mask(follower_mask, rmpopt_smp, ...);

  free_cpumask_var(follower_mask);

This eliminates:
- current_cpu_cleared variable
- The restore at the end
  
Additionally, the global rmpopt_cpumask is never modified, so no concurrency concerns with debugfs or other readers.

> 
> Actually, if for whatever reason cpumask_test_cpu(this_cpu,
> &rmpopt_cpumask) above returns false, would that mean somehow some cpu
> exists that wasn't enabled right when rmpopt was initialized? 

The work handler can always execute on a cpu which is not in the rmpopt_cpumask, so i believe the
cpumask_test_cpu() needs to be there.

The leader loop must only run on a CPU that has RMPOPT_BASE MSR programmed. If the WQ_UNBOUND scheduler puts the
handler on a CPU not in rmpopt_cpumask, that CPU's core never had RMPOPT enabled -> RMPOPT instruction causes #UD.

  So the leader should be conditional:

  cpumask_copy(follower_mask, &rmpopt_cpumask);

  migrate_disable();
  this_cpu = smp_processor_id();

  if (cpumask_test_cpu(this_cpu, follower_mask)) {
      cpumask_clear_cpu(this_cpu, follower_mask);

      /* Leader: prime the RMPOPT cache on this CPU */
      for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
          rmpopt(pa);
  }

  migrate_enable();

  /* Followers: run RMPOPT on remaining cores */
  cpus_read_lock();
  for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
      on_each_cpu_mask(follower_mask, rmpopt_smp, (void *)pa, true);
      cond_resched();
  }
  cpus_read_unlock();

If the current CPU isn't in rmpopt_cpumask, the leader is skipped and all cores run as followers — they lose the caching
optimization from a leader priming pass, but correctness is maintained.

Alternatively, i could pick the first CPU from rmpopt_cpumask as the explicit leader instead of relying on whichever CPU the
scheduler chose.

 	cpumask_copy(follower_mask, &rmpopt_cpumask);

        migrate_disable();
        this_cpu = smp_processor_id();

        if (cpumask_test_cpu(this_cpu, follower_mask)) {
                /* Fast path: leader runs locally, no IPIs */
                cpumask_clear_cpu(this_cpu, follower_mask);

                for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
                        rmpopt(pa);
        } else {
                /*
                 * Current CPU does not have RMPOPT_BASE MSR programmed.
                 * Pick an explicit leader from the cpumask to avoid #UD.
                 */
                int leader_cpu = cpumask_first(follower_mask);

                cpumask_clear_cpu(leader_cpu, follower_mask);

                for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
                        smp_call_function_single(leader_cpu, rmpopt_smp,
                                                 (void *)pa, true);
        }

        migrate_enable();

        /* Followers: run RMPOPT on remaining cores */
        cpus_read_lock();
        for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
                on_each_cpu_mask(follower_mask, rmpopt_smp,
                                 (void *)pa, true);

                /* Give a chance for other threads to run */
                cond_resched();
        }
        cpus_read_unlock();

        free_cpumask_var(follower_mask);
  }

> If yes, what happens if we call rmpopt() on a cpu where it wasn't initialized?

That will cause a #UD exception, if RMPOPT instruction is issued on 
a CPU where RMPOPT is not enabled (RMPOPT_BASE.RMPOPT_EN==0), so
it is essential to issue RMPOPT instruction only on the cpumask (covers both
primary and secondary threads) which was setup initially when rmpopt was
initialized and on which the RMPOPT_BASE MSR was setup and RMPOPT enabled.

I believe, there are actually three cases to be considered here: 

  1. Current CPU is in rmpopt_cpumask -> primary thread, run leader locally, remove from followers
  2. Current CPU's sibling is in rmpopt_cpumask -> sibling thread, RMPOPT_BASE per-core is programmed, run leader locally, 
     remove the sibling's primary from the follower mask
  3. Neither -> new/unknown CPU, RMPOPT_BASE never programmed on this core, fall back to explicit leader via IPI.

So this seems to the *correct* implementation of the RMPOPT loop: 

   	cpumask_copy(follower_mask, &rmpopt_cpumask);

        migrate_disable();
        this_cpu = smp_processor_id();

        if (cpumask_test_cpu(this_cpu, follower_mask)) {
                /*
                 * Current CPU is a primary thread in rmpopt_cpumask.
                 * Run leader locally and remove from follower mask.
                 */
                cpumask_clear_cpu(this_cpu, follower_mask);

                for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
                        rmpopt(pa);
        } else if (cpumask_intersects(topology_sibling_cpumask(this_cpu),
                                      follower_mask)) {
                /*
                 * Current CPU is a sibling thread whose primary is in
                 * rmpopt_cpumask.  RMPOPT_BASE MSR is per-core, so it
                 * is safe to run the leader locally.  Remove the sibling's
                 * primary from the follower mask as this core is already
                 * covered by the leader.
                 */
                cpumask_andnot(follower_mask, follower_mask,
                               topology_sibling_cpumask(this_cpu));

                for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
                        rmpopt(pa);
        } else {
                /*
                 * Current CPU's core does not have RMPOPT_BASE MSR
                 * programmed.  Pick an explicit leader from the cpumask
                 * to avoid #UD.
                 */
                int leader_cpu = cpumask_first(follower_mask);

                cpumask_clear_cpu(leader_cpu, follower_mask);

                for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
                        smp_call_function_single(leader_cpu, rmpopt_smp,
                                                 (void *)pa, true);
        }

        migrate_enable();

        /* Followers: run RMPOPT on remaining cores */
        cpus_read_lock();
        for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
                on_each_cpu_mask(follower_mask, rmpopt_smp,
                                 (void *)pa, true);

                /* Give a chance for other threads to run */
                cond_resched();
        }
        cpus_read_unlock();

        free_cpumask_var(follower_mask);
  }

Thanks,
Ashish

> 
>> +	/* Leader: prime the RMPOPT cache on this CPU */
>> +	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
>> +		rmpopt(pa);
>> +
>> +	migrate_enable();
>> +
>> +	/* Followers: run RMPOPT on all other cores */
>> +	cpus_read_lock();
>> +	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
>> +		on_each_cpu_mask(&rmpopt_cpumask, rmpopt_smp,
>> +				 (void *)pa, true);
>> +
>> +		 /* Give a chance for other threads to run */
>> +		cond_resched();
>> +	}
>> +	cpus_read_unlock();
>> +
>> +	if (current_cpu_cleared)
>> +		cpumask_set_cpu(this_cpu, &rmpopt_cpumask);
>> +}
>> +
>>
>> [...snip...]
>>
