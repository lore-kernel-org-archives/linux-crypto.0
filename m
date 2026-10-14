Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012018.outbound.protection.outlook.com [52.101.43.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8949E418346;
	Wed, 14 Oct 2026 19:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792006414; cv=fail; b=QZw3ZkD8Y27ZnATH44eB8leDURlO1YqP/4052AJH+hodLvGaQeIcFOMr+pjgkIDbJITE7Fmg1/zG11Isi1PqdFWnB5sXMf1Q1VYCAajp7MybuLNWHtEt4AqfD2xvcg44666eMnu8rhqjZRPEeJYR+FHF5wRWy36Os0kHAV9qnjc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792006414; c=relaxed/simple;
	bh=8gVHgDm1ycbyat5G7Ovw3fG0SiRNLIHLaqEWT+9Ska4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Va/IgWnQegKLZ0v9zzVfhy6LgXm8dO7YXyCLQFdU2iAxJuWjs0clFZOG9bPUxzC4KY8mJ5dBIo9WV5xlUfhx+M6nvh3CpQrgMxav8UhMPJLBVHuM71oxVYSesM9WzfZeVWvzWXosz8ysB/NEb5NOn2XIJWjHBJOSVdvdEsgzit4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lw1GCEv6; arc=fail smtp.client-ip=52.101.43.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lw1GCEv6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B/OHLYcgcTwF9TdH5bVyn3vTllDG3qeZzIlFkluMYi7Zfm6xUaSFIb/+gi9sxDj2zWRWoG8sT7HacaiyAX3qXQ53+jDPUXtiqfap1flrKRSYHmwpK5rlrb0dwOEXU1Gc4rrYn+I1Q++6XIACiVr7kmTVFKfC4tZ4iW8oaG85oJXzmLlLITOpCGmfowvIxn2XYMpoyQfEpZl8806faIOfk+vuKVzrRSdMMm/SBFwL7HFxjlh2FykudijQJbZqTK7xloEe8sFt075IydXPrB0owHU5djs+3nXEUZzgKQ7wjwUB406zTDTd8g9caE3wrd93WBhvXpMRCgcIDsjvT9VvbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dlIUr+jKklOP5V0YF0Qbm88nubKrpkEpZrHG4Hzm/h0=;
 b=WYip3WU+Hc2dfw18aiy+pfJf9DrymUpwF/dkunOgkY//6AH8hkxMtBshR9v4muAAdUSvjukoZ+Mv30bkuiJuKVc5sPy36ES5wbu3i/Nu52aBUHe1VZDH20BZtcSuGvWW45RmBjt0xoBHV5FeA/WvP2eXxrFHHw4KorLLUHHl6wXnmmKEBwkQTqvmjrylksdW6V0w92w9rl3kL/nmAIj4IpE5gWQjymqUykJ1rYW2ixkpzZV1cu8yKZZdnqNDrDxWBxLeZ0VuRBB46bUdg+PlHLngatE091ikGR/vE4gp7MIKrQ9uwBQDA2KrE2Y/32AgSEwHNWorDFwfR8pCB1FcZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dlIUr+jKklOP5V0YF0Qbm88nubKrpkEpZrHG4Hzm/h0=;
 b=lw1GCEv6dqBRBXWkUYQsnFqMkNTTirhAs1M5DBlgOOMoSzfUfwHBGtzmFxgEFvtWzI+Oyf9uEkD7pWlFoPxixN4oSyknYhLofGR4MftkMkUd0zc3d9WPyuGV8YN2kwf5fyw5KNJcTibHFiIzw44KZMG1e9OjdqAEGD4puJ6tzG4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DM4PR12MB9069.namprd12.prod.outlook.com (2603:10b6:8:b8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Wed, 14 Oct
 2026 19:33:30 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%4]) with mapi id 15.21.0496.021; Wed, 14 Oct 2026
 19:33:29 +0000
Message-ID: <9f16cbfe-7864-4733-b4d3-4da03d731d7a@amd.com>
Date: Wed, 14 Oct 2026 14:33:18 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] x86/sev: Only announce RMPOPT optimizations when SNP
 is enabled
To: Tom Lendacky <thomas.lendacky@amd.com>, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1791905953.git.ashish.kalra@amd.com>
 <11df35266257afcad3825a8e89c965bb0cf7cf34.1791905953.git.ashish.kalra@amd.com>
 <a66f932d-4ca2-402d-9f76-628ef53a1107@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <a66f932d-4ca2-402d-9f76-628ef53a1107@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CY5PR18CA0046.namprd18.prod.outlook.com
 (2603:10b6:930:13::8) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DM4PR12MB9069:EE_
X-MS-Office365-Filtering-Correlation-Id: 772719cf-1564-4a7a-3a06-08df2a2a05ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|18002099003|22082099003|6133799003|10067099003|4143699003|11063799006|261009223027099003|921020|56012099006;
X-Microsoft-Antispam-Message-Info:
	Cjw9wSaocTTeGonGcmP1+LbQH25pjFmoYFKpxU58fckY6Hvd0pja9XIZGPS/yL+1wjhdN6Y4m+hVuL5+yjwpXCJ0mWUB3ffnG8ckxITyWxbhI+9o4Zn/psl7GQ+4+5kpCKiW0ZUQppmyTw9FUFnfLoie1rrelDTahzrgD8uL69TSrSKoLhn3uvoNewmroWzYIa27xb4JT1XWvfFksjlyExBQqP2enRzZbPPGoqQnhCCabHOvgWh6kO+ZSFKb4SfOkuZCKCRPyG0l7geRoV5b8J/LgPZ0TrzElEvfQzOwjbtV1aihCZrll6LOkpUCU5TVKN8W7rJUBFQBocDoCMJIA2f/miMM6Row91QMfh0r+L/YFUqePTu9a20//iSY31hJaLBW7SDWk87FD7uS0/mr+ykg1Fm4JGYy/qKwLuOh7MWs79JzgYLGyIYYO1TTCwAJfdaO3cLcZOCH6m2yLJLYT/q2UUNmTZiDxhCnbxRDOaJmpsN1z4ECpLUDeFcy2RHLr+D+GIE+cQLgRKxLQ2q2QhEi1gp3WuZ6N61ASRMyqglc+a0oxHhV/rXAR1evNAcP9JMtqUp8lJeUaSJoqpqWxHTCIeC1NLF8Z0KKZl2iHw478kbhzmmhMCLMQpgUX1MjQ+9gWu9HYWe54AtRyZiN6cVelt2g5akvvJyRnHqGIxPK+8+aYHZytOD1XRw36Ii3XJ+oEYLwp+SuznTzsR/lWQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(18002099003)(22082099003)(6133799003)(10067099003)(4143699003)(11063799006)(261009223027099003)(921020)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aUdnMGdnL0NvQ0R2ZHAzK1FOYnE5OHBKWGo0SmU4QWtvV052K3pwVmpFZkVq?=
 =?utf-8?B?RnNRTzVEZDl6R04rUVRYdW9GK1hWT21tY0dTb2REYnQwZlNFcVIra3RrZGcw?=
 =?utf-8?B?QkJMNEZGOTNLdFFocUxxbjNpaFFmQm9YdG9FbHJwcjF4cC9wZDVLV1lxRS8x?=
 =?utf-8?B?MWFVdHlPK2ZWTzFoWWtSc0xqWjhMU3FiY3VNWmliQytxNnhDaStvaDFSYnAw?=
 =?utf-8?B?MEhzblJMRHE4UGFKWTd3c005TjE2OXQzQlRiVXZNcXFiVk5PajVYQS9WRnNF?=
 =?utf-8?B?NUVmazdvM2NUbVZoQ2Eyc1lsL0xBVWxjSVFsT2RmZHo0eUVZTSsxdlZjYmFH?=
 =?utf-8?B?QlkvSDdyTndhU0NLbDhFSHB4S0NQS1FDV0Y4VU93aXJrU2Y5cEd5Y0l6UW44?=
 =?utf-8?B?ck0rSExhZ2U3MHVia05nU2ZoVVpoTUNSL2lmZWlCMGpPMldmTjF1YjAyVSts?=
 =?utf-8?B?eVdLUDNUTndFaW9RZzJwVlV5OHJuUk1XZVp3OG1ZNWxPcFhPUk9PekY0RU9x?=
 =?utf-8?B?cERJcVQyRzVGSmhFMFRvdnVXMmI5aDFRY0lTZElxZ2tVWmxyRnpsaE53RnVL?=
 =?utf-8?B?NDZPQXpweDNmakdXRWZsOXU4cnYwbnB1d0prSkZhbnhMWmUvRlR0d2Rka0Yy?=
 =?utf-8?B?WTcwOHJjVDlGdG9TYkEyQm5BdDZBK1NGY3FZRm9UM1djU2h3ZnJ4bDRRSXJz?=
 =?utf-8?B?a2NSZm1PQTJOdmFFYjI4MTQ2SFd0K2daWnhodzFWM3B1QjFUK0hBQmFBWE1T?=
 =?utf-8?B?ZU13MDIyL3RHdnVWRWVDMHdVMmo2YTJWUUh6NUp5eE0wWWtnM3pKcG5VSUVw?=
 =?utf-8?B?dk9nRllxS0UzZlBMS0dNYVc3RGRqTkVqVHRtRkxJUFluS1hyRUlCNWdOWHJ4?=
 =?utf-8?B?Z1c0VjVzOGRaWUc5UUVwMmcvdVZUUzFLUFR0MWVwU2d5L0o2eE9LbDA4TFRX?=
 =?utf-8?B?ellvSHZyT1NyTTlwem54THYwWUhCZC9VN1l5NGhhTFd5YTVjNHJpRmZISnh2?=
 =?utf-8?B?Y0ZoYXVFdnE0YXFaNzN3K2JEVi8vYXZPbE9kVGxianUzNHRjc3dEbW1nS2lt?=
 =?utf-8?B?YWFxQlNoakZ5RGpjRnR1RzNua0ZPTjcxeW9UOGIzYWRaYzlySGhLOGNObzl4?=
 =?utf-8?B?bnRldVJ1RWhWdGhZZS80VGttOGlHTjltQlU4N0xsYjQ1ZDNXTU5FRGRkUDJx?=
 =?utf-8?B?UnJpK0lNd1Q1enZZK1N3aDZ5MHZ5Q3NNVDlISUQ2OTVpOTR2eGVzZ2RoNXg4?=
 =?utf-8?B?Qk1MM1ViSllhems3YlBiRlZERmwvbU1YdVFjbmhmRzRVbHJ4aEpwQmt1czlZ?=
 =?utf-8?B?cVY0NUQ5UG9ZczJYOTA2Q0I5ZGtvMzVheDRaakZhc3NqNlc2NmRTVWdXdzl0?=
 =?utf-8?B?UlU0Vlpyc0FBZVdUZURPanI3aGtiNXMwd3BIcFdsZlczZ2p2Ly9EbDJrcTVp?=
 =?utf-8?B?UzZHSG1HM3MvZUQ3eFJIaHVITDlIN1YvSEF4NFF6aUFCekpERnd3WGF1dTRT?=
 =?utf-8?B?TTd4cFcyR0ZTaWUyR2dJY1lIdG56aUhsZ0lmWGQwOERMR1p4aHhyUk5FeFJN?=
 =?utf-8?B?bC9naXM1SjEyYklJS0FpK0o1MUVqK2ZQb2pOckw2TVIxdFdDWXVNNEZ6b3Jh?=
 =?utf-8?B?cWdsNERWWUpCcUZsUWZIUHBycWdEWk0rbERDQnFLZ0o0L0xXcGdsQTRRTktF?=
 =?utf-8?B?aHgzOFJFMDdqa211a1JPZmE3UERkTWFTUkxOYm9lajRzTXRYOVhiWFU3emlK?=
 =?utf-8?B?aTczNXpWenZQOERxZVV1ajFnVGZhc2JDM2NiOWsyNFNGSnJlR1Nyby9NQ0Ji?=
 =?utf-8?B?QlRHM1ZhdnpEa085SVJFWk1vR292Q1lWdjRuREJnTnE2K3pjcHJaMXZWdUFF?=
 =?utf-8?B?QThDYjJlaDJ0Z3VVN1RkUE5ZdFUzYSt6cHlhMXNwRWFQZ0hhNFRtYjFFaFh2?=
 =?utf-8?B?bWJDb1AybXVlTFpBV0hQV3JsM2JUNzNMWm1hT3ZIV051eHY4YnErVFhYSFUr?=
 =?utf-8?B?QWRvQXA0K1JscHhHYVg2dzlFN1BidTZ0Yi9GOGdEWVZLT1pLWjh3S0hMck92?=
 =?utf-8?B?RlJWU1dzZDBQYzNOcjhxR2RkVFZrdXR5UW5kRGdxS2dudWt3QVBMUzk1NWhT?=
 =?utf-8?B?NEpJeXJOZ1FTUEhwOFZGN016MlVidHMwWTJwT25KSjZJTjdXRjFTS05TRmJq?=
 =?utf-8?B?NUVwR0FGNnFYOW5iN0pScVJHVysvdDdTaThzeHFTMjN3WW1FbGJyaWJqUlBK?=
 =?utf-8?B?Q05aeDFmRVBCc25WT25NZWZDdTFvNGRwa1EyaWZFODFXa08vQjBQVTJKbVJr?=
 =?utf-8?Q?hCP0z6RJzZon4abvdc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 772719cf-1564-4a7a-3a06-08df2a2a05ce
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 19:33:28.9641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2GMeg354a0nWpz4SDjYDT4TP0h/wZhAamU7VY6auIcZ+wXYTtsz6IAUlk6R2KMEvYq+PQswXZ1zhcyEZalxYbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB9069


On 10/14/2026 8:24 AM, Tom Lendacky wrote:
> On 10/13/26 10:44, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> rmpopt_init() prints "RMPOPT optimizations enabled" gated only on
>> X86_FEATURE_RMPOPT, which is a CPUID bit advertised independently of
>> whether SNP is active.  On a system where SNP is disabled in the BIOS the
>> message is still printed at boot even though RMPOPT is never actually used
>> (snp_enable_rmpopt() bails out on !CC_ATTR_HOST_SEV_SNP), which is
>> misleading.
>>
>> rmpopt_init() is only the software setup (workqueue and the delayed work);
>> the capability that matters for the message - an active SNP host - is
>> checked in snp_enable_rmpopt().  Move the announcement there, as a
>> pr_info_once(), so it is emitted only when RMPOPT is actually enabled on an
>> SNP host.
>>
>> Fixes: c6c6f156d192 ("x86/sev: Perform RMP optimizations asynchronously")
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>
>> Note: in the posted series the pr_info_once() lived in
>> snp_enable_rmpopt() (SNP-gated); when applied, c6c6f156d192 moved it to
>> rmpopt_init() (feature-only-gated) as a plain pr_info().  This restores the
>> original placement.
>>  arch/x86/virt/svm/sev.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
>> index 43e4945e6cdf..6f5f4ee821d0 100644
>> --- a/arch/x86/virt/svm/sev.c
>> +++ b/arch/x86/virt/svm/sev.c
>> @@ -656,8 +656,6 @@ static int __init rmpopt_init(void)
> 
> Should the check at the start of rmpopt_init() just be
> 
> if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP) ||
>     !cpu_feature_enabled(X86_FEATURE_RMPOPT))
> 
> so that you don't even bother setting up the workqueue, etc.?
> 

Thanks, that's cleaner, and gating on X86_FEATURE_SEV_SNP avoids the workqueue setup entirely on a non-SNP host. 

Will add this and post a v2, keeping the pr_info() in rmpopt_init().

Thanks,
Ashish

> Thanks,
> Tom
> 
>>  	if ((rmpopt_pa_end - rmpopt_pa_start) > SZ_2T)
>>  		rmpopt_pa_end = rmpopt_pa_start + SZ_2T;
>>  
>> -	pr_info("RMPOPT optimizations enabled\n");
>> -
>>  	rmpopt_soft_init = true;
>>  
>>  	return 0;
>> @@ -690,6 +688,8 @@ void snp_enable_rmpopt(void)
>>  
>>  	mod_delayed_work(rmpopt_wq, &rmpopt_delayed_work,
>>  			 msecs_to_jiffies(RMPOPT_WORK_TIMEOUT));
>> +
>> +	pr_info_once("RMPOPT optimizations enabled\n");
>>  }
>>  EXPORT_SYMBOL_FOR_MODULES(snp_enable_rmpopt, "ccp,kvm-amd");
>>  
> 
