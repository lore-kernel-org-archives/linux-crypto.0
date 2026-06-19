Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012070.outbound.protection.outlook.com [52.101.53.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A7525782A;
	Fri, 19 Jun 2026 22:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781908491; cv=fail; b=QST/IaVlsqvGG8GGfjbvGq0m86mHgkBMK72eNwYXY9/DlQuwGOYa3o2HH2l+Di1BwSOvorJuSOa85m4nNlbk8xsqZ1MqTVOWzYTP/WryldK6Xew1VIMhUiSffuaQOsW90Ubdn3w62ff+stq+IjQ9SCOpM6ArvtenU/lHjNkbg4o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781908491; c=relaxed/simple;
	bh=qgSE614f9FN7Mg49Q+5ciiXhyxQswVYKe5XB3Z6kz8k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nusSRpcsjgD3lH6SN4bNLWyXvUUDTE6ZZyVIcL7sVhpWApvvCpG7xuFrE5SHUQ7W0L35jp4spjn+llY3eq02n8WQDkQnQ+wRY0NKuH/xLF2OdukfIt2/fRBI/9yt7YlUj1WIG9JTafGIhzD6bUEOlhoM41mKfhQ+aHHwj1M3Zhc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lAAaXAFc; arc=fail smtp.client-ip=52.101.53.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lAAaXAFc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gOW2DUmDw+TGFKTK9o4kiaYrVyi14wDLtm3oerHo5+yiB3v2SRTB5BPfgkl+VBkxZQH/G5njnuLt4BhcO459hCgBm4A5ZBqcu++dGOgMYTqaUomJKwQDEegZqEj/6pAaWLCK2eDheyKkn9jk47lTQHnTr0pDY6joa2Ai6hvH6aERC8ZgGgg1B3Plt0oGuHPHV6nAN1q51PasChfcXYxB3bQ1ywh2u+UMxh3hcvpwnW+Ch2msYzh26LQ7mNNhzc3NLIWcY9XyhV/iYjYuHH70tOw/XcMF+QlPcIzY50MHlYzQLEVIBvuzQ4Iqa3saxNHU3FXgg2dujOwOP7KnN76MKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l4Fgc/yXbdnP5B8Hu+25u4Qbp0HQbMQUvGF86WkFrb8=;
 b=RhGuOYUZp0LTEspTJKDSr1WQZpbIyLNGCKLyR9RBT55XpoeX8KWtfoiyI+OI7m39fO9Jlo3Hc9hiCE08D1OP9Fp1LRmMyp/LSMPe0Hecs6oXWn4u5qKIkTJKI7EFMvlKMZLoAuBC14vRqyariqHiX1ldz5zCDFfnspKyrntweLoFlHhh1MS95xmxh9Dv+4lIglZ9wIOvrqajBfev/2Kudb+K6kIe5oC4ewkaBQ0kPYr2up3wW61Ivxoz3un5hdZdUICClHcVtN1//Ed4XgmqDunMQihb+PUzwSRpyKICffYlpmo7BvkrWziFrPzp9aDrrDjTBOyq7TDBn3QzcIltWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l4Fgc/yXbdnP5B8Hu+25u4Qbp0HQbMQUvGF86WkFrb8=;
 b=lAAaXAFcFKRn6bOL2Kh9IDVDHdP4UGvMi7AwrV/n/jnS7LLHYBKvIZwIzEHca1MP3oyJCz2jbJ58eG2tWB2VV/cz4kVY3+/kZfKlhIMim5dhv1AiYRBtUsXc5kZZQpQippN9IrqziLshD/M9FuCTg4+OCHNxFSJ+1qQPxroiuWE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by IA0PR12MB7773.namprd12.prod.outlook.com (2603:10b6:208:431::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Fri, 19 Jun
 2026 22:34:44 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356%5]) with mapi id 15.21.0139.009; Fri, 19 Jun 2026
 22:34:43 +0000
Message-ID: <d91bf0a8-0c4a-4552-9009-0ecef46aa279@amd.com>
Date: Fri, 19 Jun 2026 17:34:37 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/7] crypto/ccp: Disable CPU hotplug while SNP is
 active
To: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@intel.com>, tglx@kernel.org, mingo@redhat.com,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org,
 pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1781419998.git.ashish.kalra@amd.com>
 <1feccf6e2a56d949b30f403c0ca7949f580e5982.1781419998.git.ashish.kalra@amd.com>
 <49380c3e-c275-4211-876a-c51f644aeb17@intel.com>
 <bd2dc2e0-e975-40a9-8e0a-4403db858316@amd.com>
 <20260619221022.GBajW-TvxyCuGo0FWX@fat_crate.local>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <20260619221022.GBajW-TvxyCuGo0FWX@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR08CA0028.namprd08.prod.outlook.com
 (2603:10b6:610:33::33) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|IA0PR12MB7773:EE_
X-MS-Office365-Filtering-Correlation-Id: e038a543-7a1a-495e-8181-08dece52f55f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|11063799006|4143699003|5023799004|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	r8ZwfBy9cXRBB66umown9vIFYN98z09f4+jprqwLJUud1F26Dg7yVPcSldCSzbONkNlCRZ1yNoIxrZVDYfK7ZW7qLh8xlipWykizk7MTRduaIdG1l6QCME+uYzONYt8nq98FauVYVM/poBvSKpFkvek6CREM+2LByABz14/5lHJ2OxoainzI9hyZge3Md20RI0Hgc9wgAyPm6zM9jesWJOPFkDqvenX6mxFbU2KrWRxZX9Ut+5yp449R5CaArInXfC+dvFpz4qpe43j12YR/SiFgsvlT5diONlOyqF0y3HsYsHQe6lAKhc1nKV3JX7ki8UZ/CuqSPaN45WNEsTRIN0jq7LLeZllK0XTJOSwLSW2fYdhTR2IFmCcY626k98t7Qx14W7PkLFnMk3HAi8yuHMQBPKeDX7ZNx0sVLkIar+oUVdkZja2oD4mKEGLBK5qRWZt91xdaRPtrCqfXhfWNsY9QoqE71CHqf5YfKJI5M1KYMh81KvqaJHUFkBefmtchWDXDyAa2MqWpoTIkU52mcX85q9kji0hj9U1jFwb5kXynfsv4uqzxcO0zl805/icKdiwzP4Er9ag7kjDF3KZpIaLVxDUys/rNQzh264PcD15zGZ86zhfKpqMtharWqOgfK5kCpBUNxJLX9TODpiOtXFQYafhhJAb7XcPQU1rdOpU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(11063799006)(4143699003)(5023799004)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?REFSMU83NTBNTk80aWkzNnN3RytsMy9rRFdJZHRLM2wwMmdCdUhONTBKcDVj?=
 =?utf-8?B?anJNMjBtZ29GdFp6VnJ3VzJjWmNoVjNMYjA0aWpNb1ZBRzJYeFlGZXJHOTNp?=
 =?utf-8?B?YjZ5WjNUM0RDNE5QdTFYSzRBKzFoR0tpSXR0UWpWWXJKeCtJT2lQaGFDalpF?=
 =?utf-8?B?S3ZtcjM4Vm1MYjNMbDJSRW1vRllMUTBjdXNmRXBXRGJSN3pJVE5XbkdiRzBF?=
 =?utf-8?B?MTFXQlhyZTNaSWU1cEFxdHluU1kxNUtuNVZPdUlFYTIyaUgyazhybjNpRUdJ?=
 =?utf-8?B?TnV2QUpCNFlRSnlOeklzeERvZTE2N1RVSTF2ZWpLUmRmdFZBTjJzRmgwTzVq?=
 =?utf-8?B?V1UzTEV0elpNS3p2a1hYMjZFRXF2eHh2U0FjT0RybFBGYitxTTZmaEtlRGl3?=
 =?utf-8?B?QzJBM0x4a0swckV6QjdpUy90dGRmWjhUeTF4bXo2Q1NhY05qaXQ0cU00dkNI?=
 =?utf-8?B?NkpSeGJnRlJnaTB4TkV1cDkza2VJQUFrL2MyZHFDYVBlVTYrc3BNQnI4bGkx?=
 =?utf-8?B?bkR4ZHVBRGthdFVyajN5aXFRYUREUllqS1ZYWnYzbHpEL0JJaXRhTEowVE1U?=
 =?utf-8?B?SXZQZGRmS2M4RUJDeGZmY0lOOWVFb2xMU3NPZ1ZtcnBvb2pNMFNPTkZrdDRT?=
 =?utf-8?B?L0UxZ2FaczFGTXB4QXpaNXRvNXZWZTA2bG1TK1Rwc2pUSzNEa0JjU2U0T2k1?=
 =?utf-8?B?d3MrT3F3d0NFV0F3eEdSQlFrNTZzNHVJbzhobjZCZjd3Vk9YeFlOTzdQZlBV?=
 =?utf-8?B?ZFMzMlJtNVlGdisxbFBrek5xTlhCVWMzK013VHpEaHpNOERSd1BUMGpLNEdU?=
 =?utf-8?B?dkVKME0vNm8zbXdtYzBSMmZXQmhIZHh5Z1k4R0xXSCtKNXBleS9xdjNrcHVL?=
 =?utf-8?B?bFp1UzZlamhqb2hEV2V0Y1QyUTdTWjBMdGl2bEFzVUV1WFVYS1NFVkxWTThM?=
 =?utf-8?B?d0poNllwSStzbW1FTjRpWkVCc2RDMUt1YTNhcWQwQUk4T1hadXNnUkY4WGhk?=
 =?utf-8?B?Yno2ZzhDbTY5MHN1cHpVY2x5SlBaNEpEWHUrbVRkTUVNSnhMQ0FUMldLSGM2?=
 =?utf-8?B?MEFvN3MrT0t6NnNhdThhbGpDVnRYSVZWQysyOEpCZkp3UXdpeExLaXdielk5?=
 =?utf-8?B?WWFsSEUybXFiSWRGV2FZY01VcFN5MGtVcDgzc1FoSm5odTJNQm1ObkVuNW1o?=
 =?utf-8?B?dUxTVGVKeXd2bUpPWm1NaFcwRTBXYVJCU0tSYUtxNTRXeThNdm9zV2VjVE1G?=
 =?utf-8?B?UFZWRm43eFRHZmNYVHJ5VDZJZUFCeGFjbzg2amorZXNMamFzWnF1cnlIT2Ey?=
 =?utf-8?B?cmduSXg4VGx6Uy8yRTliN1I0dHo5SWQ3bktWK2V4dk04N2wvck9QV0cvTWUr?=
 =?utf-8?B?Z0pBY1J1T2QzNy9UbVdmbHFMWTg2RW9Zb0tNQlZpRjgvU0FlNEt1QzhDQUF1?=
 =?utf-8?B?eHpqOUJqRDJPZnpGTWZQbXI3MEhpWDYwTzF0NHVoVnM4eDBFTGhXdys1SGtu?=
 =?utf-8?B?NkRKdFNVQlkxaXRIeURpVFhFREk2TVdWY0p5Zks2aHN0Tm9YNy9FbEVSNW5X?=
 =?utf-8?B?dk5TNEF4NTlVQnlFQ0pZUk43ZGRtZGZTT2c5RjhFRDZyNnBrTUpsSDhmbDhp?=
 =?utf-8?B?NldtLzV5WHViazlZK1lJbktzV1ZCUWRhUldyT3NFdVpWU3VGSjJOMjhEQWxC?=
 =?utf-8?B?dWNsQlBQSVJoUXgvdisydWpidW9TKzkwWHlWemhEcVh0T2pNWVRYM3BXRHVU?=
 =?utf-8?B?UDRXSFNoc05xQzk3bmFZVVRLRXRMOWhGQWpZeUpEU3RGQlRtdjIvT0xsK0Ni?=
 =?utf-8?B?TFJHYlpXcUNsNkFoTVhHeDluSzVzTXJIS1JwQmRIV0R2cmRGc0hYNkVXK1px?=
 =?utf-8?B?VDNXTFlucFo0QWdrekFoazhFVjFyUnh4SysySG5ZSGtGUzNsak50RFgwenkr?=
 =?utf-8?B?ZXZNYy9hWWRTUk51Tk12R2EwbU1qRGYyZnNFSVBWV0hQS2paME5tV3ZjVllj?=
 =?utf-8?B?dGJ0eUh4ZUpVaDhsbHJVQi80L3c2MWRxd08raVlkVDZxaHByM3JGT0VGWWJ0?=
 =?utf-8?B?bGp3WGRFVUwxOG1CSmpEdnlxN0RXVER5U3hlM3o3Q1ZMeVBaMDlILzNXTVg4?=
 =?utf-8?B?MEtlMmh2bExkNHlXT1p0REhLVDhpaFBDMVpwdmpNZ3VLenpTNjkzSncxV1Mz?=
 =?utf-8?B?VXhKeG5hVkg3VmtOaVAzckNTSU9XZlVQL0pDQ2N3Sjh0Y2V0L0Nsc0lpQ2lC?=
 =?utf-8?B?UWNkK1l3VzZhSk9NNTJRcU1UUXRXcTRFMTJ5UndoVXdMeUt0ZUpGWGdnNyts?=
 =?utf-8?Q?BZvkXFpaT0OjtyKO6S?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e038a543-7a1a-495e-8181-08dece52f55f
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2026 22:34:43.6623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hXBjkJZBpM4+NshhcWZswoQKwmB+pmfHlsWA9rM8aG2AZzlD2jmvWDacZG2Wc64LzZXSPVqquD4KU6ONFyBNRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7773

Hello Boris,

On 6/19/2026 5:10 PM, Borislav Petkov wrote:
> On Fri, Jun 19, 2026 at 03:51:20PM -0500, Kalra, Ashish wrote:
>> Based on Dave's feedback, i am going to drop this
>> cpu_hotplug_disable()/cpu_hotplug_enable() and instead implementing and
>> registering the CPU hotplug callback and then refusing to go offline if SNP
>> is enabled, unless anyone else here has a different thought/suggestion.
> 
> What happened to using cpu_hotplug_disable_offlining() as I've been saying
> a bunch of times now?
> 

One thing about cpu_hotplug_disable_offlining() is that it is permanent and one-way (__ro_after_init). 

Once SNP host RMP/SNP is enabled at boot, offlining is disabled for the entire boot — no re-enable, even if
SNP is fully shut down later. In comparison, there is the possibility to re-enable CPU hotplugging during
SNP shutdown path by calling cpuhp_remove_state_nocalls().

It has to invoked at boot-time, so it's tied to "RMP/SNP host enabled at boot". So on a host with SNP/RMP enabled
but where SNP firmware is never initialized (KVM/SEV never used), it would still permanently disable CPU offlining — 
which is arguably wrong, since SNP isn't in use there. 

It is otherwise a clean interface, the offline path returns -EOPNOTSUPP, distinct from an -EBUSY return
via the cpuhp interface.

To summarize, using cpu_hotplug_disable_offlining() is simpler than the cpuhp interface, but the 
trade-offs are (a) coarser granularity (SNP enabled vs SNP initialized) and (b) no re-enable.

Thanks,
Ashish
