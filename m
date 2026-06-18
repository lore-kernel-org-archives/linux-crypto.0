Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013000.outbound.protection.outlook.com [40.93.196.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7FA364045;
	Thu, 18 Jun 2026 18:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781807015; cv=fail; b=G+iav9+q/0jfLzx1JBbLTGidL+rjU+J6QOtWZuwF8mVhsTSDEFPrsRzMvk6HUOh9ae26RvmMb4+U5z6UKXfpwGpgHI5qSprCnqU+RVF0bneAS+sCGQkREXcoxFCiCFfaAN0ZL+x8p6HhSXWNRCD3JzSI+0UYqy0D+Z7WCQJ1V+4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781807015; c=relaxed/simple;
	bh=06DfR60ELhFyZZ/o8SFG0tF7ecvJne9kDgy+UsMLMUc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=inwJaI/pnFBOZ8oP0wdbeGiyOpndYSfILbl55VWH7bifmHlbS57gsSBS561K6tNmO6ZoJBdOKtCy1niKuIDFy9ZxSla/8Ybey6l5z+4rO09SjSDcNlgbSqqKQXv3Jr4KMVeQM1+ab5tXICtcrvJtzUHwMpnYoyYbtNYO1f4+dkY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=crFIgW6w; arc=fail smtp.client-ip=40.93.196.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="crFIgW6w"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qCRiGqn8uL5xtzx1bCpUDAoUgbz1XPQii8mDToDBJJqFiBQmTO5Kk8ix+8qB4fTlxwmb2kkCh9h2aqaElI+/LXBNl211m6s0s1PxJc6nrufu/L/w9gvQKJGjgild5b908DIVHdZ1o6N/RDO3B+7NcjdCHgGASeMpAsyzvvDQdcJ0RicMBxr4hNk44SOXf/Wvh6qEe6QhJyXrUNoLtTPksVmXpl1JhZi+5rKKIYTTZeYE6LePWOlDvw7EZgpPYHiaJ+Dngr+up+iPa1iIun2uGK5aM2CN2SImnRtE1QeAXNN2nRN6/sTO+4Z6vBvYcfU7pYQ4rqPm0HZyPB7Q/EVM+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xMsDy+x5vfu+N7fJ14S8JujY2t4exhR6UEdfBW3pDkc=;
 b=YjZzDWQNNGFk4ygi+EjNa7AYPbZjGuvXtbb60ipMKItioP/cGeVwfwVzDrK4T4ch6TaGDpU7fFPMIKQhXYZYfvvh3/MGP8eAylBgfMv+xT27PHnpDv4Zj4u3dnpmhk2wuvkf84amham9PM4f3lRPQhKlOC/FkaZbXIqUA0jdihkQCM6f2kU/ZJPAqpTpXnu9izZL5lhX92AmgE5Zc2eWe2wbNuMjyyatI7//R2rXDxSmLSMCL71vZj2WY+Ih9/bk7DCmhfQ/8Diawkv4cGxfGDlIDmp1zX1wVdZXwdxyMmI7GHVUdtuQNyIqbwyswa9beITnGHF8QRYaXdB135Begw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xMsDy+x5vfu+N7fJ14S8JujY2t4exhR6UEdfBW3pDkc=;
 b=crFIgW6wlE/r+GAvtM7TwY2SkyAgy4mEogtSODxrQ523KXKlGk+IwLttXLOlzJRcVZ+bPdTA7izRRuAV2yGX6/x7X+Uv3+6iasqAMOgVPp+Q/7pERQq5WUcsnZhA2rL0jK0EupG9ZgCiVvhe6n1eauSp1C6MyzdqcToOJP+Uw5A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by EAYPR12MB999134.namprd12.prod.outlook.com (2603:10b6:303:2c0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.15; Thu, 18 Jun
 2026 18:23:30 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356%5]) with mapi id 15.21.0139.009; Thu, 18 Jun 2026
 18:23:30 +0000
Message-ID: <e699c695-189e-43a4-9e11-e9454541b3d8@amd.com>
Date: Thu, 18 Jun 2026 13:23:24 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/7] x86/sev: Initialize RMPOPT configuration MSRs
To: K Prateek Nayak <kprateek.nayak@amd.com>, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 thomas.lendacky@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com, ackerleytng@google.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
 darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1781419998.git.ashish.kalra@amd.com>
 <6a4d0ec9e037d91c0fdba9c525942ca288e1b1b2.1781419998.git.ashish.kalra@amd.com>
 <fb2f1105-3bef-4197-bccd-865c013ce712@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <fb2f1105-3bef-4197-bccd-865c013ce712@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN9PR03CA0560.namprd03.prod.outlook.com
 (2603:10b6:408:138::25) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|EAYPR12MB999134:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bc72e0c-f432-470f-971f-08decd66b26e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|921020|56012099006|4143699003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Koggab0OzIy0vtmQJ8sZoNDIugwqFtyN+23tB4gAENgjAQrPFI9d+UT4+9/Jb7uKP37BwjdkwonVDyqmuhPnX1hUGOf4OQlMRy42PM83Ckrkz+pP82/37V5TxfDXvJaalyWQOfdB8AY07udo0YmQQ0teLE82GaWd1Q1o0Qc1vTDiiaXf/ZGgf63ajyh/kZoimW2xLhIncYAUs2t3edSNI1J8prSrF6yDucMNdlhmev8U1t3xDV7PXOGZdypRjyOcUvSNLOwXvLNPgflS3L+FH6QtYdYv4MV0yNU4Kal0j9/arvmSL7IU0DguKFrh9IsDRGgEQMgpZBNzAUzT26fPYSiYVlL1JRg1IgDyvmaiKXt4FqgX9jRo8tWgizCRNiKrmHkd2Hoqgpr9EyyvR3Drj5CY9zwum9x2U0E1KSQ1tflLY98JOdTLswPwo0VH6gjpeeYgLRjC7s1LQVwXNgkrxgmBu46czuFVgh7WKAcf+lLH7Qs6i2fek5FPqkwYIKF2UEHRbnY0Zigdq3UEpA5ekHm9ALABvMsNoF6whd1lTgrvMQeu54/MZ751oZH3EYs2KbB6J+evaM+PrNv9Y7vo+ggS9dnayqYhGdZNEWwIhFO5gfWN/2QuEnOX8JRUJSEGXb9/eN8eiNawjqFLqwfZb7PLbuzbtXdyoF96EhzICZofC/A3a5msI+8zWuvBRSTvcJiWvPhMBQ4sEeIccXc1PRIs+V+W+Egf3a6iO4AY7D0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(921020)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cU94VjNyNHJXa1BlcEd0UDhlamNBN1NtY2RqYkRYelBWSzJUa3dTOS9wVlQy?=
 =?utf-8?B?WXZ3RWtNRVVHaEFsRkdGUGFpV0NST2hENkFpNFpXdXI1dk5Dc1d5V20vclNr?=
 =?utf-8?B?QVJaZ3FJYklNRnN0V0ozMzhQaFlxdE1CZHd5aCs2OFZOVW9Ock9LRlR0Vlk0?=
 =?utf-8?B?bjFmTzBOUUM4enA5ODBHTENXalllMitQQnZVWTVNUlFJbEVoclZKWmEydUFp?=
 =?utf-8?B?eWhnMi9CajR6UVpWS3djblp0QTc5RythSVBmdEJzMXY0TkxoV3lYaHIxZ0kx?=
 =?utf-8?B?QTlNdFVVVkJvZjhsLzBBa0N6K3VRYlc3eFo2N3JlVE9SSGsydXpIVGtIYXdW?=
 =?utf-8?B?UmNqUENMMUNUdzV4eWZTRVJyV0s1WlJXaVRrTHRSbUR1cE5XQksrTWI1V251?=
 =?utf-8?B?ekhtRDZZWXNkdFJ1cGtYcnorU1RDaUdod2Q1NE5UaWlOY3VKM2pkUmlnMGRH?=
 =?utf-8?B?UDZDcm9MRGpPejRBb2tHNDBnQ2xvc3lOenZueTQ3dE9DZWlBTm9BaVB6WVE0?=
 =?utf-8?B?a2lhdTJIb1VabXBLWkxZazZRbCthUEdnWUQ2U0hNVDRsdnVsSWJ6YUVBdFYv?=
 =?utf-8?B?NDFzLzlRRGdnVTczUUhzNlF2R2ZVcVFNYUN1Mk16Sk5nQ3YzUUtPMFluUUl2?=
 =?utf-8?B?ZjVRdTB2OEdIS3NSS1QvVlQzNnowdVR5YUxidVpNSUs5c2RsUEMzME9JRmgx?=
 =?utf-8?B?am1CNERKQmRZaXFQNzZnc3hDY2lITkcrYmFRM2lBK0xCMUFyMkUxYWNBVnNP?=
 =?utf-8?B?QUxRWm5nQ3daeVBzMEdQb1htRndWTVdvc043L0hPcFlmK2xEMFhnc05URjRU?=
 =?utf-8?B?WHJMbmFQbkdiT1pzdDV5eW9tN1dtUzA3TkM5UEw4NFp0ZmhUL2NpazJFTWt6?=
 =?utf-8?B?RmZJajBYN1ROa2g3TjNhUlQ5MkV3RWs5YzJzcCtOejNTTW15c3VzTC9sM2hH?=
 =?utf-8?B?MmE0MllBRnBPZzNYd1MvdnVpcTVEbS8rT0ZrWmJ5Rjg4Ly91YmV5OUM1QWhJ?=
 =?utf-8?B?OC9LdXU4SXlpaWh1Wkl2NWZHNVRSM2RXMmpLR3VMdkdlUTE4MHJpR3NySWgw?=
 =?utf-8?B?Tm1LNjN4Wjg4MDd3T0QyVnJsaWF6cXFicy9MN0FqamtNR1JMUzZzSmNGNWlO?=
 =?utf-8?B?U3BpcEg1RDR0QWxRTFFLUmo0SHM3b3VBUWxqU1VEVTZMdnJpZ3J2UzhtUnpz?=
 =?utf-8?B?bCtIZmJkOGprYnQ5ejYzakpobDZ4a3h0RXlYUnZnM01WUWkwY2lJOHNWUldG?=
 =?utf-8?B?bExOVkh0UEcvdFZqa2lwRE9RZGFZQUwyV3VvOENpT3huYzRoZ1ZJZlBRVDYv?=
 =?utf-8?B?RUpDNEUxWklqZzlHWWpFQjdCNStScGRQeENnYTYvbkVQQVdGazkrQVdIVU9O?=
 =?utf-8?B?RmFGRGRldDBoSytTTWV1ejBaRUNMYTRqbUdZenYvenQ1WndMeDZWYlkxcENq?=
 =?utf-8?B?Z1V6RUExT0NHckFyQVlHWUtXSVIxU2k5OXRkc0JCVnNZTXQyd3prTzhDWklZ?=
 =?utf-8?B?dy9VMmIxNkZKZWZsZ21wb1orcFV3TU1QNUxXWWYzRE5hbUNJc3hLRmtUazAr?=
 =?utf-8?B?ZTl4ZE5Db0xvRE0xRXNCWUdEa1FZS29VTiszTGJHNnFXaUFCWTAvOW52WWFh?=
 =?utf-8?B?RXlHc1NGWGVaQU1XZnBpUno5RlJINlJpbVNJR1JvZHIvSWpWUGZyc0JxRm92?=
 =?utf-8?B?ZkpManloQ3daQjZsbmtxdms2ZldqSWFmQW5uZVZENCtpRVdqV20wcGQ4U2V5?=
 =?utf-8?B?NVBldHFsbks0aXhEVGF4YTIwdmZNRFYvWjM1MUZ4aWNKK2lBSFJvaEkzNVIz?=
 =?utf-8?B?U2gzbUoydTQzQmZkb2R5dGYwTjNIRWdzZEJWMmlOdmp1MFViUmdoQ0p4c0Zj?=
 =?utf-8?B?ZFNxL2hBajJsSU9SWEZlUFNNR0p2aEpZaFNrM0lXN0JUL0NvT3lIMnhveXRy?=
 =?utf-8?B?QjJYUmMwRDlzYzh1OUx2UElSM1hKVGd3bDBoczIwUTd2dy91V29NdnpBYyth?=
 =?utf-8?B?TVVkbGNWUVNscStQOVM0cWFybzl3ZDVtVHhWS3VaT2NXeVk0dTVFSi93MXY5?=
 =?utf-8?B?bmZYb25pRUJKU0pwRzNjVHFrSHMrL2w1UGRLeVN3QzltTDJQb2kyWWc4MGxs?=
 =?utf-8?B?aWQrK3NrVHNpdXVCSkUrWWw0YlNISG1mTHp6SFVzaENYNHpOVXJobVVMZHJ0?=
 =?utf-8?B?T01ZVFVEMUFSY0IzQ3RXYnpGcUo4cWtjb1F1WW1kY2NzZkpWaHNINEFYMzZB?=
 =?utf-8?B?QzBQU2pOVzNxUHhpQjFXQUkzTHdCTkhyZVgzNW1VbitQMkcwL0dCNlZpWFh0?=
 =?utf-8?Q?B/iuk7wOtbsUrkVH6g?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bc72e0c-f432-470f-971f-08decd66b26e
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2026 18:23:30.0342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8AKA6/T3eZwBG3NVRXdMduv1vum7QLj2oCwNjjqMdkecY9RCfgK9nX19XuiN87qLRFq/Y5aqsUlgK1nfT+U2Rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: EAYPR12MB999134

Hello Prateek,

On 6/16/2026 1:03 AM, K Prateek Nayak wrote:
> Hello Ashish,
> 
> On 6/16/2026 1:18 AM, Ashish Kalra wrote:
>> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
>> index 8bcdce98f6dc..1b5c18408f0b 100644
>> --- a/arch/x86/virt/svm/sev.c
>> +++ b/arch/x86/virt/svm/sev.c
>> @@ -124,6 +124,10 @@ static void *rmp_bookkeeping __ro_after_init;
>>  
>>  static u64 probed_rmp_base, probed_rmp_size;
>>  
>> +static cpumask_t rmpopt_cpumask;
> 
> nit.
> 
> I believe you can use cpumask_var_t here and do a zalloc_cpumask_var()
> during snp_setup_rmpopt(). That way !X86_FEATURE_RMPOPT configs don't
> have to needlessly waste space to keep a redundant cpumask around.
> 
> Same comment for rmpopt_report_cpumask in Patch 7 which can be
> allocated dynamically during rmpopt_debugfs_setup().
> 

Yes.

>> +static phys_addr_t rmpopt_pa_start;
>> +static bool rmpopt_configured;
>> +
>>  static LIST_HEAD(snp_leaked_pages_list);
>>  static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
>>  
>> @@ -490,7 +494,12 @@ static bool __init setup_rmptable(void)
>>  	if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) {
>>  		if (!setup_segmented_rmptable())
>>  			return false;
>> +		rmpopt_configured = true;
>>  	} else {
>> +		/*
>> +		 * RMPOPT requires a segmented RMP table, so leave
>> +		 * rmpopt_configured clear on contiguous RMP systems.
>> +		 */
>>  		if (!setup_contiguous_rmptable())
>>  			return false;
>>  	}
>> @@ -555,6 +564,21 @@ int snp_prepare(void)
>>  }
>>  EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
>>  
>> +static void rmpopt_cleanup(void)
>> +{
>> +	int cpu;
>> +
>> +	cpus_read_lock();
> 
> nit.
> 
> You can use guard(cpus_read_lock)() unless there is a complicated
> locking pattern where you need to drop and re-acquire the read lock.

But if i use guard(cpus_read_lock)(), cpus_read_lock stays held across as it is
function-scope, so it will be still held for code following the wrmsrq_on_cpu(),
which is harmless but still changes code behavior.

Probably, the other option is to use scoped_guard form ? 

Thanks,
Ashish

> 
>> +
>> +	for_each_cpu(cpu, &rmpopt_cpumask)
>> +		WARN_ON_ONCE(wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, 0));
>> +
>> +	cpus_read_unlock();
>> +
>> +	cpumask_clear(&rmpopt_cpumask);
>> +	rmpopt_pa_start = 0;
>> +}
>> +
>>  void snp_shutdown(void)
>>  {
>>  	u64 syscfg;
> 
