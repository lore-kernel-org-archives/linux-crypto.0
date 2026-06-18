Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012008.outbound.protection.outlook.com [52.101.48.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900EF221F20;
	Thu, 18 Jun 2026 21:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781819388; cv=fail; b=c0Cff/7fIFIwq24y6/tRXOc2yDT9nIRnRaXrgrVZhA3HzCmg0ZLJauqTI95TP2EkDK0/92M/u07aFQNmKbXOXAzRhQSgDHZfU1vvAmr4TGN0TYDdnHNsltdxgdS5RWlhsDSscRzbpYYyO3aUfzKVe/0p1bmlwibeRgs72MtMGC0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781819388; c=relaxed/simple;
	bh=HntEm/50HodJp0ksgUU2Fl+61gWvDjKNeGNHJRt2n2U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OGdIKQJv4mxg24iZXQIP/IVnjQs+9wrGO9sXlSHJS/bduXNrZF+rmmedtJk94feeuyFVONf/Z3Pu5RVWvoUU02fLPezv35/vq6RVoHZxvFLIpbn+LuUE3ba+MmeRMbnj0PbeDX0cZrskkxLOX/Si9uMls4bUTefQig7ji7IpT/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=j0ZGeEcE; arc=fail smtp.client-ip=52.101.48.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="j0ZGeEcE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hQ5/lEiqoYSjbfakuJfOoHkk+BivREXlQTq3RMQMO8AzEUWZ4zOHdUPPm07p2M/c9XYe9yAZdGqBY7TyWDkBS8N6BuGqKW/IjymWsZvRMW6aho2K7T3faAFbKrnXc7O1qSnBoMlRGMAzcNdWGdJK1vjfKZij3XA7R6ZrOetNG0rIsg8ojvqfNnNnNFTwK6JZBoXPcji1fRe2XYIcmuOocqmlUxwNpN5dwhaCuCxMZHVaw4S10AK/1jwvEtWI5SIehM61qD+UJdyvKTZekLBO8/f568wP1BT6/Dtz5YSNRgZOEEDPUSSHz2vL8iKJLyxqxwKvzbp6RsbBXIcW3Aumow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3DRjmhu4ftfrdIllSuhsMNqp2CYmK3aOQX12QwP9NrM=;
 b=cuIAebHoUS3WhcBmpeskJb4/GTaR69rLx81WfCDknYc/KRIxxQrvjzGTac0gwf3nD3/E8lY3jpNeuDJg58+qM8+cFSdsrGSmzwFKxDGZj7KKwGQugAFpYGbf40ZUxbeALU15hQlxm5mHC7k/kmX2DzhQO0iZFYIr5dQ+BPdZrAdC7OkAhaabicTmKuKcgCLZx21dJ0WJHL1OQpCDEX4GlZrQZM7V0O1E3UUHn4BadPGCkLn3WBbiXUVEiyLwkWZzTeAhIDSGE2l7U3dpW0glqjhtLOk/PY5n/p1H94jbp4aQvRb925+8UVp7842wtcpk8So6r40sZB830JHqMwtCrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3DRjmhu4ftfrdIllSuhsMNqp2CYmK3aOQX12QwP9NrM=;
 b=j0ZGeEcEXOKGBv+DxsiCBidNvrT7sTV7akfkMllaI9HSNgi3u/KdxvXBXkTWTkdfAaMIcdGI47Qgn/IpK2Z9IqiyzLzqnHVZfBbbG0v9lZSUlfHQ2hzQSHpYXRcjnT7VF60Vdpe2TwIlWbVrJEDZtVn8kpWU4up+wDg0liS06wY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by DM6PR12MB4402.namprd12.prod.outlook.com (2603:10b6:5:2a5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Thu, 18 Jun
 2026 21:49:43 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%4]) with mapi id 15.21.0139.009; Thu, 18 Jun 2026
 21:49:43 +0000
Message-ID: <08918aa1-13ba-43d3-a06c-b01135eeb24c@amd.com>
Date: Thu, 18 Jun 2026 16:49:38 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/7] crypto/ccp: Disable CPU hotplug while SNP is
 active
To: K Prateek Nayak <kprateek.nayak@amd.com>,
 Ashish Kalra <Ashish.Kalra@amd.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, herbert@gondor.apana.org.au,
 davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com, ackerleytng@google.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
 darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1781419998.git.ashish.kalra@amd.com>
 <1feccf6e2a56d949b30f403c0ca7949f580e5982.1781419998.git.ashish.kalra@amd.com>
 <763bff29-e737-4033-ab30-cec8fd3e7438@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <763bff29-e737-4033-ab30-cec8fd3e7438@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0370.namprd03.prod.outlook.com
 (2603:10b6:610:119::11) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|DM6PR12MB4402:EE_
X-MS-Office365-Filtering-Correlation-Id: 13f179c6-8138-4141-fdc8-08decd83815f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|7416014|56012099006|4143699003|11063799006|3023799007|921020|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	M/zX7+owTb44um46/UGy7HzVtk+8TZdA5j9bVZjEeWQTnjA8JQJisebTb8oGnAMrSkXSnkaVrXO/j4JTJMflupmXECggxyUbIPwoz/ypWIFGhD7joS8SAfvH2E8uVXD9HsiL38ZidujNtzFNfgc6hT1Z67008TOne012SgTJTrB7KMNwuQV4RgDnbsspi2PdiDMy1LBX2J0nKoYvvzoJRv23Nlk5Pxp2jnpCJKNEaJ7O5jngbUkLZI6js6nWMiKEgghWZfxC2Q03Da0rgeX6QavvN0Pn5JPW9LMICxuMbYmUzlyj7+sH1CcmtqndEt1/8J2WGnpSApx37eh6if5rDXw3T7nHr15OSBKaeyCeMt6BztlOEToCu3SNrMuXHme9DC+Wf7voW/10bf1n0YSvkM7HiLNuwqg1Az1hWphy/9w3JyqUhS/+FdbwTFg1GN40GGRyvidSHI+z+0QIAvtaX6eO27C0BckPrmQhOV/4EEYFBJVmIqgXWRvh/VH6vVCSM5UJhei/dghw+qAfobeoZNbRvoFxEHHqZTcjWl3ifD4uEHPvhU8PBdROKeXyxAbScmLO2Tjga7BF03XpXlirr+BwCThCIMDzmdIgNUwHalqMZ586Mz5dN5AnvUjRY2Od4D3j6IUI1Hzht/5MdZngZPXXM4zFKOgXS820GOaiuaNWT4PCaOXpMZVwx0a9+uy56MJoI8kVrlJHlANJS1Fx5A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(7416014)(56012099006)(4143699003)(11063799006)(3023799007)(921020)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R0wzVHhkWWFMQkJlbm4yRXQ3ZDYrZThkN1JOaFFTLzJTYzFLT0cxeFE3N3FX?=
 =?utf-8?B?RE1xV3oxN01oaGdaK21uSG4xYVgyR3JnRDJmZnhBZHMvSXhiR3g1bzBqdUhY?=
 =?utf-8?B?SU55bGtZSXdhOVFiMVFUWG83M0ZGNXFadklHYlp2aHJ2b2VwK21MUEtSOWFw?=
 =?utf-8?B?eXhNM2c2dHZPSEtSd0dzRTVHN0ZzNHl4VzZrMXVPU0hQWG5sS1JkVGQzNEhS?=
 =?utf-8?B?S0c3aE5hYVlGL0c5a3BMMGhlS1B6ZnFKTGQwRFBpMXYrTlFYOGtCM2o4azAy?=
 =?utf-8?B?OExWQWV0aCtQNGNoTEY5QkVwcldJUTlMbHAra2FEbnRYS25zZkcvTUszYjc4?=
 =?utf-8?B?SDdSSExCVkM1YkJZREQ2dG9hbUZtRHFYbDVVSFZaemJ5UFhpVW1qNUNHdEhr?=
 =?utf-8?B?TnJJVWxTOWtVOVlPNnUwNkt2bnlQREE4ekZQQ2xPRjdGODNNMjRsOXVJaHJt?=
 =?utf-8?B?aDV2VGpLTUJKT2tBdmFUTnExSWNUT3AwcFVQZU1aNWY2RlBwQzViQVdGVnd0?=
 =?utf-8?B?dHU5YUU0SXRXdytJUUcvQUFBY2xub3NIY0NtbU5hL3A2UEIxeFduRFgxbXQy?=
 =?utf-8?B?S1JxR2h2Uko4MTYvZVQxVnByTU55NjZOVlc4QkUxMW8yM1B6OXZoSUs4bTdU?=
 =?utf-8?B?NW9mZENlRTZWb2FSL05nbXFWYjAxMEd2c3lha3o1ckxGQTlEVWVBSU90cDhE?=
 =?utf-8?B?Snlzdm9iV1lHUjdJcFFKbFlmMnM2SEVrZ0ljWnVONkZTQmtQK3RNaVJiWFZB?=
 =?utf-8?B?U3NIWmtYbGNtdm16WlJTSDNGRFZxV2NaTEJ4UHRzem5kek1UZWNnYU9yYzhS?=
 =?utf-8?B?VTBaQjNQaVBKTUVCamxSN1c0aldLM0JhM21vejUyL3JUUWJweEYvS3pWSmhI?=
 =?utf-8?B?OVlydUc2NGMxZ1c3cDBvbTZJV3B2OEdVWTRKL3dpYXNydTVsbGh1SzVUQjA3?=
 =?utf-8?B?ckQyTFJZNmhGZnFwSW0xNW8waGZvUXNISkhOTDVkODNhY3FqUzFJWDY3M3Ay?=
 =?utf-8?B?R1plWGlxSDdUMHRqUnMzZ2dEQlhJdi9UQnRnc3gwTDdSSVpWUFRURjdWNkRL?=
 =?utf-8?B?RW8xOWxSSUF2WjkzYU1PWWpJWFBaczRpWkRIOFRZSXNxY2NKaTFraEQreVNn?=
 =?utf-8?B?WVMyNlQzM2hSKzlrSlEvUy9TRldVYUROUGV5UDNPQmhWTmNpVXBzeU5CRXdS?=
 =?utf-8?B?VGFSQ1NyV3NtRVlXTmJEa2JmRXZjaHdFM0dzRzFiQi9Sa0d4bmNZR2hsdGZw?=
 =?utf-8?B?eVRvUlVRcDNhdyt6aEt6YkZ3N0N5dmdqTjVndGJFYUN2ZEtsbnU4REdLZVVW?=
 =?utf-8?B?bGRmM2dGMnQ4a1p2SzNyMkFPTnJ1QXUydTV1R2tTam8zR3RKWEJvbUZraHFt?=
 =?utf-8?B?TStWRlgxQnJ4QldOTS9xSnRCTEZCUTJ2UU0wYjdTdnNrS0tSdHk5NjVhNnB0?=
 =?utf-8?B?bGRkZHN4ME9xZzVEYk94T3VTQ2FwdzFUbHZFWjFqZVZ3bHc1eEJtVXVBYWdX?=
 =?utf-8?B?U3Bkczl4bXRKcFdzOGNCZ2lRVmtqQXdhZFZyNUFDTSt5Y3NVc3Evd1F3SGwr?=
 =?utf-8?B?Ni9MQlk1OGs0MmI3LzYrdmpkMnRQRHV5RlI0YUVNdHNjMUlTZEgyWjRaK1Jm?=
 =?utf-8?B?L1c5L2NzdjV2Wms0eXl1TzA0Wm9nUy95NWE2SjFOUEErQzhoTVN4YTR5Z1Jy?=
 =?utf-8?B?V0JmN2tzU1QyK3NhRUtxWkFnOXo4YjVNYmI3ZlhWUnB3TE5MRkdJWXRpcDho?=
 =?utf-8?B?UStJelVaODZXeEFKMmFUUis3cENMc1NybzB2cnFmOUZEM3lqZGFuNnMvQUpB?=
 =?utf-8?B?elRFNFc0TmN4c2doS0NiMjdhZlVjVVVkUFBHV1pleHg2MnNhbXBwallYTk9r?=
 =?utf-8?B?S0R1UnNnRTdTQ2loWUxzU2tJWTBWQkFXN0t6YzRIbmtKVkxnSk9kcFNoTXNG?=
 =?utf-8?B?NWhXSGZlQWkwQnJINFd5OENHTHB3STFJZURGRm11aDlmTDNyaEU3cC9iUERQ?=
 =?utf-8?B?YzErTmFNb01Nc2VESnV3d0tocVpZbm9FeExvYjVkLzkxbTVldFg4R1M4MUow?=
 =?utf-8?B?QXR6cTQ1K0kvdGhlQ3VRKy96cHlvZlUvL1lHVFZrMGVTOEJhMUhlUzluOGJG?=
 =?utf-8?B?NjEzV1YyRG9RTW1JMlBMU2dsWW5jV1ByamppKzBCUXZXcDJ3VzRBbEpyd2lp?=
 =?utf-8?B?TWlmMGQvTklybk5XMHBDRDlFVWhFVXc4aW5hSWJxc1RwbzBZWGZPYlp4WldO?=
 =?utf-8?B?SjF1eU5TWFJoeG16MStQTXJ6ZjA5R2oyVWwzZDE5NGJBdk9BWlZLMFV0aE5K?=
 =?utf-8?Q?e1GXceR6V5qCcinqif?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13f179c6-8138-4141-fdc8-08decd83815f
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2026 21:49:43.0173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rcFkKi/7rmVRlDkJGvcvGhPqV7YjTvrbuPQLpk4GlDDfamkhl7ZuWR479+YppFiGmjFEte7VoFJRlfkY2W9cxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4402

On 6/16/26 23:33, K Prateek Nayak wrote:
> Hello Ashish,
> 
> On 6/16/2026 1:19 AM, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> The SEV firmware enumerates the CPUs at SNP initialization and is not
>> aware of the OS bringing CPUs online or offline afterwards, so OS CPU
>> hotplug can diverge from the firmware's expectations and break SNP.
>> Disable CPU hotplug while SNP is active.
> 
> Dumb question: Is this specific to RMPOPT? Otherwise ...
> 
>>
>> SNP is fully torn down only on the SNP_SHUTDOWN_EX x86_snp_shutdown
>> path; the legacy path leaves SNP enabled in hardware while clearing
>> snp_initialized, so __sev_snp_init_locked() can run again.  Track the
>> disable with a flag so it is balanced by a matching enable rather than
>> stacked, and re-enable hotplug only on the x86_snp_shutdown path, after
>> snp_shutdown() has cleared the per-core RMPOPT_BASE MSRs with hotplug
>> still disabled.
>>
>> This also keeps the CPU set stable for the asynchronous RMPOPT scan
>> added later in this series, and ensures cpus_read_lock() in the scan
>> is uncontended.
>>
>> Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>  drivers/crypto/ccp/sev-dev.c | 29 ++++++++++++++++++++++++++++-
>>  1 file changed, 28 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 217b6b19802e..c8c3c577463c 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -106,6 +106,9 @@ struct snp_hv_fixed_pages_entry {
>>  
>>  static LIST_HEAD(snp_hv_fixed_pages);
>>  
>> +/* Set while SNP has CPU hotplug disabled. */
>> +static bool snp_cpu_hotplug_disabled;
>> +
>>  /* Trusted Memory Region (TMR):
>>   *   The TMR is a 1MB area that must be 1MB aligned.  Use the page allocator
>>   *   to allocate the memory, which will return aligned memory for the specified
>> @@ -1479,6 +1482,17 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>>  
>>  	snp_hv_fixed_pages_state_update(sev, HV_FIXED);
>>  
>> +	/*
>> +	 * Disable CPU hotplug while SNP is active.  Guard against stacking
>> +	 * the disable count: the legacy SNP_SHUTDOWN_EX path clears
>> +	 * snp_initialized without re-enabling hotplug, so this can run
>> +	 * again while hotplug is already disabled.
>> +	 */
>> +	if (!snp_cpu_hotplug_disabled) {
>> +		cpu_hotplug_disable();
>> +		snp_cpu_hotplug_disabled = true;
>> +	}
>> +
> 
> ... should this be done before __sev_do_cmd_locked(SEV_CMD_SNP_INIT_EX)
> is issued?
> 
> I'm assuming that is when the firmware enumerates the CPUs during SNP
> initialization and any hotplug after that should be disallowed?

Any hotplug before would be bad, too. SEV firmware understands what CPUs
are physically available based on the installed processor and BIOS/UEFI
settings (e.g. disabling SMT from the BIOS), not what Linux has online
at the time of SNP_INIT_EX.

So maybe the commit message needs updating about that.

Thanks,
Tom

> 
>>  	snp_setup_rmpopt();
>>  
>>  	sev->snp_initialized = true;

