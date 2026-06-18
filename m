Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011035.outbound.protection.outlook.com [40.93.194.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7425D33CEBB;
	Thu, 18 Jun 2026 19:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781812678; cv=fail; b=dS8sqygTSIwuvf7AklOWVVMVxfEldQZ28a1y0NUiKfbYRSz5QjyCjso9vVTyY9o68iXwGm65G+/U4mX4gDDLLUQEoJDo4m+pTle6wlkNCsThXLawyxWNNzjdEQMQ98qDKMOchY9qYtBZGipvANYZNppf/7fGe+UcDDjJ2ukvO1E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781812678; c=relaxed/simple;
	bh=6BJ+fX90HfYUSx0nr+syUbX3KuCF2vftl7Qo5iBUjYE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=thpX4joJyc8v0hZTYNy0oiGLkHIK+J4h0zWAfYccrCXCv3JWPxdUJBXSbn6EXXovC/omN3vekgFoUeRJL0QENtCiASBP0WuJa/BHGWjxTuBq8C0vQ+1F2A5T803O1bu5VUrFzanhQ3q1hLpJnqnM00Lq4p4fMmwRy/kCMYV2vsU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VWpS60qe; arc=fail smtp.client-ip=40.93.194.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VWpS60qe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KgQiGDsDRcbnd9MoVtDj6xID9bRTFMsNVKqo8+bNjMipFimYF4ab3IJBY3nACUfHwyJgBudSY5wwt0FGjPFMWISmB/vg1ZzWet1t0+sIt/FkVgKCpoR7yhGPHm5OQaEKi2f2NBEs0BeaRMWDOpD63ERU0s7yf5aVZ932uY24JqtaMe40K/3yKRCAZGY2ZCbzhWaqaxQphUKdAZvZg03H/VdO82To+T83LklnEInIxzNQMCX7TEOLmirseg7iZmtKr9Wdj3ivxOqS9YJwWrDs+rdeTQBhHZNdqrOse01JG9SGzpaecQPf1e89LEUQidilBg7lqNQwTrqtKLOZX5oIQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ZV7RMxlaTSBdxEcjkppMMoZ+JFirGwLqxZOWcqr3BI=;
 b=LiFH6/oY/mExyz9l9eKvmANUSAam7XBTqPk+sJ5QvKXIcMDdcVQI0uzpJiW+RtHGRHS0NCCbJCvJVcJZtknZSFjgCWGn/PmWvatYMNxDJOwpBUjqpnLMKMl21xLxqDFJSNtRa1ZzXu4PdwQ2mxan6AJDBzjK6RyOJf/Cf48tljGO/7oo0HJ191c5BSLya6Rgh+txvxzNSYAtA7EXaIHjc3p9MYAYrGvL7V8sLZNb4EQNokJ/gjdt/3ZdhH916o1SAbEpURn4pPTupFgAm4driY6Kfd7kn+ha2KgSxmw7xnPD42ZyII8EauEB3lavz3IjNcMMStzA5oyOzvwGPZwaNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ZV7RMxlaTSBdxEcjkppMMoZ+JFirGwLqxZOWcqr3BI=;
 b=VWpS60qeAeCuSrRhNgQkzRqZuQK8063YtTNCwCyTXI6mxPoFWUOj2Ow4+rapQLLntxnh9VcWaiAGMq1sl0lo3+XcKxMQUqOwB45REb7g6S7TKLTuTgGo5DeqGucYYxI+RpNcTVuOGHDi6QN2imZU/XKUCSZORu+mKFAYP/Yz92M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by PH7PR12MB7913.namprd12.prod.outlook.com (2603:10b6:510:27b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Thu, 18 Jun
 2026 19:57:52 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356%5]) with mapi id 15.21.0139.009; Thu, 18 Jun 2026
 19:57:52 +0000
Message-ID: <5849645c-f701-4768-8cdf-1f9032e3226f@amd.com>
Date: Thu, 18 Jun 2026 14:57:45 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 7/7] x86/sev: Add debugfs support for RMPOPT
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
References: <cover.1781419998.git.ashish.kalra@amd.com>
 <cc9aa9b6cfa2ce826f2ad53f8a13d3b7bf0790b6.1781419998.git.ashish.kalra@amd.com>
 <20260618180814.GCajQ0Dv0CoRMJxbP0@fat_crate.local>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <20260618180814.GCajQ0Dv0CoRMJxbP0@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0007.namprd04.prod.outlook.com
 (2603:10b6:610:76::12) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|PH7PR12MB7913:EE_
X-MS-Office365-Filtering-Correlation-Id: 948011d4-c422-45ca-9648-08decd73e173
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|7416014|1800799024|11063799006|56012099006|6133799003|22082099003|18002099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	E6jhuWMmNGT2g9bFmN3Ari/OfBWzixAwkzv6sLhH2sJB4b6AhRz9+U69B5qwo0+t6T9pmR/jFAEuK+RQJ2DLkii65GZqhWe2TVtM8eo56irf5ZBTsymiFYBlgdRpssVcdKxAsIxSLijyppIyiscVIrUxO1jK5F1YwCOuNkJhha4nSK+JdNBaE7CJDqFvsuS2l0UvTqQW552z4u8X93xcb0pwjA8BEU046zI/+TNmyZhin0mifsMyLDpmE01p01xi5gDWjiRmeIJuGBNtI2x9sXkr5PV83USk8PC43AtTtlEfDp1ihkEFbEsYSOC9bEtZXpOgpSGi7TRM3JEHkZQbC3z0aTN8aJ1dII1eLsNEpGzdWTrHBqJN7oRsH0diyaSbLA1RLSSIUBtLifZh3xZwVYws0WD8FNgoji2p2m/oFDiLnuvc8UkK+hjwdSHt+3bkk08Z0YfXXfnFSV2/XU0/eaKyLgUO8v+qJS0D9jxU9N392gQ9bp6+SUeTEa2kVN+jjKg3pXjHMNAh7eXUpjIe6JIxwRkkbOI6TnEjBbJG3mr2bm8yV6HCsotEwTZ2pB1tvAxfEfyGWUjynokgyLfttSEZVsNurLl4k6YpJKNo0Ksju9cGhMluNryA+MhJSxCBia9GNRI5ZBWmkD01PnODHU3i6d7djOXTmpk6TrUg2FQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(7416014)(1800799024)(11063799006)(56012099006)(6133799003)(22082099003)(18002099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RDhxeGxJL0VtcElpTDhsVjhFekJqY3V3cW1vQmNpWS9yVncvOGt6OGZDV0Jn?=
 =?utf-8?B?Y3RjZlVLOHpqUHJ1OGl5YU5LbVRwajh2OFg2dHdoWDRoN0ErWHZOZ3JGM1JY?=
 =?utf-8?B?d090V3pzMlJYUGFzdEY3bHk1aEh2YkFPOG1FNlAySjZRbnhiK3RINDFSYnlt?=
 =?utf-8?B?cUNQMFBNNnZrV01QaW5ocGpiNU42TktHRHkvUXkydlEwZktvZmRHSSt3ME9F?=
 =?utf-8?B?TUg0c3BLTUdqbjRRSWwrNDQvdkNCV0hiOG1pWkhQL0loc09wUjlCS2prV1VB?=
 =?utf-8?B?Vmh5MmdIbVB1REw1SG04djhlRTViNjNEL25mK1pxb2VOLytyLzVGK1gzcXFB?=
 =?utf-8?B?aDF0N3hQVEJSSktnTVVCVFRWWFV5TEw1aFFuTDhxZFJmc3Q2a09nQlVaRDhu?=
 =?utf-8?B?Q0tvOTJRTDQyRWIxdWZFck1DazRlT3BXVEkrc1NXWmNsZW5razhJU2c1dmlS?=
 =?utf-8?B?MC9uN3RxRmRvcE55QmZ4dDF2eFlycXp3amJ0Wjh5NHVtVW5yL2pGcDZPbjNk?=
 =?utf-8?B?Q0RsZ0U0QVNoYXlBZ0xBTGxEa05DSFVRU1U3T3VSVkltMVNYWFRieHB3STRa?=
 =?utf-8?B?T1MzNnprY3dNbUZwNDZMVEFZWFVpVVJzRUt0aTVyV0c0b3lNdHBOQXY2YWcr?=
 =?utf-8?B?QnBiSlVqVkMrRFFlanU0bnE1SE94a0VQZCtXTDJtUTV5OHZ0Rm5zVXFkTE1I?=
 =?utf-8?B?QUsyalZxQU10bThnUEVyWm5TOU00N3pGWDFzbGcyaHRtazFCSmJwUVBLMVhC?=
 =?utf-8?B?Mi96ZHV1dVBoZXEyTE5VMWdlYXd3a1J0aGd2cU9ueG00akdPODluOGo4YXJr?=
 =?utf-8?B?NkZ1V01MS01ZOGltQzcyTG1BVzlzL3BON0dBMXRTK3I0cEQxMUNDbkN5L0l5?=
 =?utf-8?B?dUgrcXpwK0ZLUkJPOUJ5UmMvMU9TSzkvQzBvcmJrM0Q0SW9wOXk4VGZoYWZY?=
 =?utf-8?B?dVI5WHM3U3cvamprSzB6dDVCdTc4TFN3Q3FlbytJdkdDNExteUpFVU9EZ0Ew?=
 =?utf-8?B?a3FMZ2d1SEJZVk9mb0YzdjJmTzJSaFNoc1cxTUNkc3NtNGh2ejdjd3BiZWU4?=
 =?utf-8?B?RlhQeHkzS29LYXpmYmQxbmxha2pEMmVRcmlBLzFIem5rZU1uVHRMOEFjU3hX?=
 =?utf-8?B?Qit2L2IvaUNvN2M2RDNjZ1VOT3FHd1Y5ZGozV2dBa3Nwb1RYamFQbGhFb0w1?=
 =?utf-8?B?ZHNRZ3hVVjRNaEpZWDZ2YUpKOVdlaC8xbVFTMWNGTlA3M0JFWlhMWFJyVjcr?=
 =?utf-8?B?SU9GN0FHTEw4TnNwR0ZJdVhvSWd6M2lGd1k0MDBLWDZiZGxWclRZWXNLSHRS?=
 =?utf-8?B?aFBYbFF5c21QRmRjVTFXSzlFL1B5ckgyUm9ZNDVISGhwczNUSUhsK1UzR1RG?=
 =?utf-8?B?bWFZUGhaZU0xanUyZTlIa3luZ0FkY05kb2VQcGZkSkhub3FEQkNtc21jSUx2?=
 =?utf-8?B?eXRKT0RhYVE1VkdhaFdOV1BhRkRaTjJXRE5oTll4Z1lWejlycHBtcVYvZWNj?=
 =?utf-8?B?MVU0bUxZT3ZTcE5NNHpXN0FqZnltSUJqUDRLanhLWGlRWWV6TTg4bG02MGVY?=
 =?utf-8?B?aU5ObFNuMEVmNHBiRFAwaEtzRER0SzJHUk8xampqRTMvYmoyUjhTRUlmdDhV?=
 =?utf-8?B?bDA0UERnTCt0cGU1cktCWjQvQmRPSWFNZ2JZNEVDeTVVNEREY1c1eGx1cHdO?=
 =?utf-8?B?TFJ0MnZ0QzFlc2IrLzdBbStESG1jMk4vSVNITEdnQVYyRXdZcVM1SDMvaWdI?=
 =?utf-8?B?amxBYXNMeG5DOFNUMHlZY1BJb0NZT1E2amhLUEFMS0xhOEFrOXJFMnAxejFS?=
 =?utf-8?B?QVl2NWdUTUFMRldrSysvTlRUcFJzMkxXVnY0WnZ5eUJyNWpYeE5CemMxazNN?=
 =?utf-8?B?Yi9URVlMRmxVK2t6TjZrcEhqdGR5RCtLcTJicXFDUHhaVkc4bXVuVFdlSjd3?=
 =?utf-8?B?dENLeDZRV0NUT2I3OWNPRGJ0VGxNSmtMdDVVeXF4UzMzbUZmU1V6VzIzckJ5?=
 =?utf-8?B?YTFsSkgvenltaUdIVk1hbXBWZXk0VmVDTGNtNU5ybkpSbFhtSDJBb3BVSjh5?=
 =?utf-8?B?cExlODNzYkYxQ05nR3N6a1JURGlYTWljazVpZmtrSWo2UmRyNWdwU3l0bHlB?=
 =?utf-8?B?OUZwNnVUMnl3K2FzNUoyc0h0d1hmb2grNk1OVFNZc01OYUVMV2sxRVh2REhz?=
 =?utf-8?B?dy9jNFc4K1c4RkJIZzhPekc4WjkxL0k0M2JtOWsyVHNQRmRVM2JybE9qVXJl?=
 =?utf-8?B?N1Q0c0FuV2NjT1R0S2xrYjJYSTljTS9WcWowbTRtZVdqRVExbXVtdmpKZm5h?=
 =?utf-8?B?QmR2NkhZSWg1SlB6eXBEZVl0R3BrQjRCbzBmL0VIc0JDVTAvTVJRdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 948011d4-c422-45ca-9648-08decd73e173
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2026 19:57:52.2967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O96nLbGfssX/CrJgfbUacz6jrx4ZlRIiBQq9BRiYnCyU5OW72oeSJJyBAAlAkQ5Y1g4Tit9xEF8TsEWRU/KJYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7913


On 6/18/2026 1:08 PM, Borislav Petkov wrote:
> On Mon, Jun 15, 2026 at 07:50:56PM +0000, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> Add a debugfs interface to report per-CPU RMPOPT status across all
>> system RAM.
>>
>> To dump the per-CPU RMPOPT status for all system RAM:
>>
>> /sys/kernel/debug/rmpopt# cat rmpopt-table
>>
>> Memory @  0GB: CPU(s): none
>> Memory @  1GB: CPU(s): none
>> Memory @  2GB: CPU(s): 0-1023
>> Memory @  3GB: CPU(s): 0-1023
>> Memory @  4GB: CPU(s): none
>> Memory @  5GB: CPU(s): 0-1023
>> Memory @  6GB: CPU(s): 0-1023
>> Memory @  7GB: CPU(s): 0-1023
>> ...
>> Memory @1025GB: CPU(s): 0-1023
>> Memory @1026GB: CPU(s): 0-1023
>> Memory @1027GB: CPU(s): 0-1023
>> Memory @1028GB: CPU(s): 0-1023
>> Memory @1029GB: CPU(s): 0-1023
>> Memory @1030GB: CPU(s): 0-1023
>> Memory @1031GB: CPU(s): 0-1023
>> Memory @1032GB: CPU(s): 0-1023
>> Memory @1033GB: CPU(s): 0-1023
>> Memory @1034GB: CPU(s): 0-1023
>> Memory @1035GB: CPU(s): 0-1023
>> Memory @1036GB: CPU(s): 0-1023
>> Memory @1037GB: CPU(s): 0-1023
>> Memory @1038GB: CPU(s): none
>>
>> Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>  arch/x86/virt/svm/sev.c | 128 ++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 128 insertions(+)
> 
> https://lwn.net/Articles/309298/
> 

Since the RMPOPT file is a diagnostic (verify the optimization took effect), debugfs is
arguably the right home for it and we are not claiming it to be an API (there is no
Documentation/ABI entry for it) and we are not presenting it as something tools should
depend on, it is a self-contained diagnostic/debug interface.

Maybe i can add a line to this patch's commit message stating it's a debug-only interface
with no stability guarantee.

We have to provide some method/interface for users to verify if RMP optimizations
are enabled for a GB range of memory.

Thanks,
Ashish
