Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012055.outbound.protection.outlook.com [40.107.200.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B0138887B;
	Thu, 23 Jul 2026 19:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784835904; cv=fail; b=jqGyODXV7C5jVsCsRvCMYSKPSePYbtDMEp5Jrykrg3XyRGKR59L4GNy13HKj9x1fEKLrwDV5IYwD/+8eli4fTDsHjFu50YhghsRLTqnPBdPax+q4leBzbITtQqiAxFozJDHPc6WIqFrMx6ikfQ6CcSLQ/Z8C6y3qRa5Jup2Jg74=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784835904; c=relaxed/simple;
	bh=b+kY3gyv7CSVuGIR1EPKWiCkSP1ET1WbfCgNOr6BrAg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QhfdrUhYPcsArKPc9ll3jfc424LglcRD7OlHPa11WB+xc0cESfHEzp7cJfviKguESPICo7piQVyG2TrdaBUqNEsdZOUFl1Bcq0xcU2U7ajvBK0MfoY8g9sPGap0LS5oI6kdsaMk1OB0PCGRH1PLWT13n0T+zLZ7bv3Elk1HeWAU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cuO97q7r; arc=fail smtp.client-ip=40.107.200.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cuO97q7r"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=htuIq57Jb8zSKnmiDkBlXF5LsHv1jatqEzkNx6C6FRhomdRsPrIdylW/ca17k5W5Q8vmkRBbQhDmPO/7eiZa4m0r9xucO4+4fwTMMZhXpLGZd7OYKBwohqN62CAd8kk7WVmaBaQgd3CRJ6pnhno05MNAumbBAC0LK4lHJGooXpb+6d2CGq0M1IV8zxD3UN08iE+ppJsFiGvZIr2/aUK6UY3McgpwtKwyY1l9ke6fur3D2UcEYAaNROQYndJ9M/8OL2pvUdUa2clJbu8EiQLfuNxxBzVYrwAqecgxfxLiM889cC8dlnINtjHBnwnMvUdbc5LnAY/crByNHgIsoLpp/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/kxSuLcdn5u7iwXM+UnNwkJIResSzKEkrfIinFyPJpY=;
 b=mRk2VUKxUKv0n92CkbxvFqPRYwdSicEzuvmadY17bbB/+up5se4eRiBFjaLNxI3jV09NyUsjyG5l9H6RNc3tWNH5URZ3/CRY0lz6W5GsUg7B+h+d52guyNBTvx/7Zu0rYt3vdudEG2MeoN0eyukHvSme24odvrUtaHOJxCX333NU39AiyNQioHrTdja7/i61TA7Zhlf21lFGd0x5UHk9zakyWFsjBpq6FMBdLe6qm2dei2G3Un8ximhP04Ya1wqEkyvZPznXR/AX1d6hHVTZUiNQLZCRKXOhMO3vUAS7RkOfCtyu3kUiohYJNehj6IHXKZLGV2d0UZ9XyzfF2YnBag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/kxSuLcdn5u7iwXM+UnNwkJIResSzKEkrfIinFyPJpY=;
 b=cuO97q7rAICGa72yPxouaeJ2FWs6jZM+j6nFjoZbnEO6sDZbizpnAEs9oIeAstAH7QxKmJkTyThoH2KYsCdm03eS+HDQKv4RwLYnRo7W09pomyUEWOLHLQNidxUb3d+E1++QBok/tA3nkL30OzDZgICKP/8HlR7ETHlSRpWJV+U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by IA1PR12MB6212.namprd12.prod.outlook.com (2603:10b6:208:3e4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 19:44:51 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 19:44:51 +0000
Message-ID: <404433af-b908-4849-a8b6-1c1ee9d33d8e@amd.com>
Date: Thu, 23 Jul 2026 14:44:47 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 3/6] x86/sev: Disable CPU hotplug while SNP is active
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
References: <cover.1782841284.git.ashish.kalra@amd.com>
 <205a5259f9fd353dc0ca6b00565c8175a96768c7.1782841284.git.ashish.kalra@amd.com>
 <20260723185323.GAamJjI2HoM1gZmExw@fat_crate.local>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <20260723185323.GAamJjI2HoM1gZmExw@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH5PR04CA0021.namprd04.prod.outlook.com
 (2603:10b6:610:1f4::14) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|IA1PR12MB6212:EE_
X-MS-Office365-Filtering-Correlation-Id: c858bf15-2623-45a5-82b1-08dee8f2dc51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|7416014|1800799024|6133799003|56012099006|11063799006|10067099003|4143699003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	CYONZ0kDfEQKy2FigDwTHEaPqSoyQKmgx/RyVnq3zF4w3cdVpxKPRhi5tvtlffwLefjhw2vkYom21KPTEhwk4UGXSz6tYvHKNKx9s1FxmfOee2FM5exS5zoB2Bu7HRySo6dNx4F791168XxridOMeHc2F40nymRSFuYxiGhSt3b4RInCtdGC4NhR7VQB0uD1dRtgT96xtcaewR15auMtkc51dG1each3ZGy7USYZU0VXwMjCLqMJVc9g/1GR7ZFZl9GHU6c99t06vC2o/I0FooPnhtlaDpF0lR5mieJUAT5b+1HLtQZKR0a5jQz1WPS6Rp315+Rm8uHknPVgu9FfmnOjBHDuO2hH2e3OvUoRqgrhuR8PfkVqRzL8IW07r3pG3+A7rJf87G19u7dJ+YrKA9kYdiNUC2npoULWscX3aTdGU/NTZpyB5A+gShbQ62mijWNDdf37dajRzYyEvXzerpbaClc3SjT4yjJ7ewk65a2KW4G02SOV022sol+b2BBBWF4IyNz59QRilDk8fNIyWQVlx1PNr3TYs2cC3GIi5fyFM17vgPrf5SYSUChoRCCdcWsUPsmnXj5gvjyhoCiJcm9Qglp/XJt1C6jxghVzP90bKThXtR+UUMvBw9U72QXj3yUWx9N5BAjt/zxPFSWMpG77NudLQfqRXdKiSqZY/fA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(7416014)(1800799024)(6133799003)(56012099006)(11063799006)(10067099003)(4143699003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SmlpZkM3V2o4ZnpVUlhrcW56SXdrYW02MGVsMnhuK2lROTNtUmtIZXB5YjZQ?=
 =?utf-8?B?cHVyVVYxa0FiLzJOeDVUVEdkMktKQ3BsRHNWdit6WktSTkdEUUdFdlNjVEhp?=
 =?utf-8?B?ek9WVlBZeStaWHlvUkVUQzBlRmRkUzdyOUh0QVhiZFNaRGVwbUVPVWJTdTcr?=
 =?utf-8?B?clZWc0F0ejQ1L0p3ZU8zVC8wYmhDVkorbE5LS2ttb0JhdldaRlBadlZpMXVR?=
 =?utf-8?B?c04rQk9HUGE4TG5qbm1FSlZXTUUyTEZNdld4RzVFUjZjV3Y0VlhtMzRsbkhU?=
 =?utf-8?B?YXV2VGtabWFqVndqUHBHOHBSMUdQdDgyZW5wc3JPMEk0eGlNcWtpQmRtZ3Np?=
 =?utf-8?B?YnVHbkVheFQvVHVNMUdLUDUxV20wY1ZwZk1VeUYycmErUHNoYTBsa2lqd1Zm?=
 =?utf-8?B?NDdIS0xXeUxXTXZYYkNONW1uREV2SnNCZ2hTZ1hhVm5sVEt3TXhYZGxia0hX?=
 =?utf-8?B?RVczMDFqVnhQZEVuTjlxaFVJNEl1cTg5RkZBOE95YW8xMlJUd0lxWHo3dG85?=
 =?utf-8?B?ZWtBRTN6RjBUcmE1bmZxajYrUTJRY1l6SnI5WXp2Y2JVVlpwV2hnZ21BRGEz?=
 =?utf-8?B?dUhXK1p6Q0w0ZHVMQ0s2KzNCNDhuZUFXanprcWFxOUdFOXZaamRDeFZ4ZkZ3?=
 =?utf-8?B?Y1hpMW4yM1hoWE9EeFh6TWhaM0lXZ1RuQWU2bXh2MHVrR3p4QjNYYTlYWEQz?=
 =?utf-8?B?UVhjV2tRV3ZaemZWWmxMSEpra21WTUFGeTRGRk94c2hqSTZYV3cxZGdnUFJv?=
 =?utf-8?B?YnZ5SVMxcml3NGpSdUNtTlF2VXBJbkVEZ3hRakdXdHA5Vnl5SXl1WUxrWHVr?=
 =?utf-8?B?cTM5M2NYMUcrWW80YkVBR1kvY0hPVUtzK3lMeWkwUjV1R2xKTGQ3dVhLVWVC?=
 =?utf-8?B?RFNEc01yeThTS1lFenQ5SjJqVWhTN3pwSHM4ZnNwdmJsUFBBWFVXRjZ3S1FI?=
 =?utf-8?B?dkx6RDFDSTkrT05QNDdhMFg4VjNpaG1LcTJuVGlPUlFvaXZySFZLcnRqY0lu?=
 =?utf-8?B?cHRvNlVScEFFaXBhMnlqTXZ3eWZ3dFFDOEpLb3MxMnBOUklQTUNkUXAzVlJu?=
 =?utf-8?B?bkNHRWg3TkN0aVRsUnBIRFBKOVl1K1lJQWFqWEw4cnQyT1pMZlBxSDIxNlc2?=
 =?utf-8?B?OW43WWRDU0JTR25vWG1wWTBsQ2RPRndiOXNMeEdOZ3pKeFB6eGJnanVNZWI1?=
 =?utf-8?B?Z3RDM1pKc2FlZ3NCclMrUmhhRWVDYUh5eXZ3M0YzZ1RjZGc4Q2EwcUtnSzJr?=
 =?utf-8?B?WkQrR0dFTG9CT0hMYTN3aWlTa3VJZUoycHNmRWpBRUVkVkxweEpQWUpLMWcw?=
 =?utf-8?B?N3Q2OWs1NDhneWhrcWNnaHJNMFBFaUtRb1Vva0ovSndqZlVZRSt2dm9BSVdq?=
 =?utf-8?B?WW9URktYeVFEOGhleWY3Sjl1VEVubnVIV3N3RGt0aTMydFVsQ05vbHNBbUk0?=
 =?utf-8?B?ckxhQlFPRXFlTHZ6TWtOcUtJL21VNC9qZy93TE50M3NpLzJkNUFPRVVzN20y?=
 =?utf-8?B?Wm1XR2JYUGlEazRpUFF2aEhhY3hrZ2lQdWxqSUZwcEVTUDhBcHhJd2tzQ0s0?=
 =?utf-8?B?Y1lEcmMrOEpyWUQxc0ljMmFsajVIcXR1S2c4emVzY2hZdElXaXh4RkVDb2cy?=
 =?utf-8?B?dGY1Mm84aERBUGI2QVkrZE1LVEJPaTgvRlhiODQ3eHRGNDF4N0NjM3dqQ1pu?=
 =?utf-8?B?V1pCcXJwSWVUQXZvZ3BsVkYyZU1VSUxqYUJ6ZkZVb0ZIcUJYb3FOVStGNWJX?=
 =?utf-8?B?eGtxY1BrclY2Y3VHcW1rYTBZVWk3eXFxMUFWS2phV1h2dDVmK0RmRFYxSXdN?=
 =?utf-8?B?ZjlTVTV2QjRlWGdNR0x2bW9FKy81OGpleE0wR0hyVTM2TFBrZGkyS1YzT1pE?=
 =?utf-8?B?UXlaTldXdHFUUmZSbXdZRzdpbGlpbTdCTG9JeWVJNnRHZDdPMTlwNit3dWcy?=
 =?utf-8?B?MHlYN0R4WXBCS3FibUdKdnl4ekEzZTlST3liU2pUNGRLVE5ETXVjV2JnVlRa?=
 =?utf-8?B?TTh6OE00UkFIdUlHd3VtemxQVzFMc3NFcHhEa0tvMFBFQUVST0Q2Z3ovUVlt?=
 =?utf-8?B?dXlDaWhEajVpdjRQSk5RWjBSaityV3BVcFZzRTNPeWg0aTNXOU5tdWhsODNC?=
 =?utf-8?B?c2x0QW8wcDlMSWxlMVJWWkdrMndYQWFTYTd0d2F6dzZpQXNxQkM1SVEzekQw?=
 =?utf-8?B?OUJMenZXWmsxdlNkNmhwRU9VV281MkdueGRiUHR4eXN2bjQwVWpKTWQ1VlNj?=
 =?utf-8?B?dTR1N0hiakduM1A0NjJFUmRxRkRGa1ZsUzYvRHlFTmZXUmpnQ29BT2VtWVNT?=
 =?utf-8?Q?TiSSqRMFcTNwVLuDCC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c858bf15-2623-45a5-82b1-08dee8f2dc51
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 19:44:51.1102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T27Poma8rUERgwrfAo0DWjdGr40J9KOk0yC4fn/duReJXIfCVKFKi0xQ7EZAF9RG/5BF8zsQ1pwjkrfMxy4RVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6212


On 7/23/2026 1:53 PM, Borislav Petkov wrote:
> On Tue, Jun 30, 2026 at 06:11:03PM +0000, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> While SNP is active, every memory write is checked against the RMP to
>> protect SEV-SNP guest memory.  A core performs these RMP checks only once
>> ...
> 
> Use this commit message for your next revision. The idea is to split it into
> smaller paragraphs for easier parsing, do simple formulations and not talk
> about future patches because git history is not always linear:
> 
> "While SNP is active, every memory write is checked against the RMP to
> protect SEV-SNP guest memory.  A core performs these RMP checks only once SNP
> has been initialized via SNP_INIT and the SNP-enable bit in SYSCFG is set on
> that core; the firmware requires the SNP-enable bit to be set on every present
> CPU before SNP initialization.
> 
> A core that is not SNP-enabled and not SNP-initialized performs no RMP checks
> at all, so there is no valid configuration with SNP active and any CPU exempt
> from RMP checks.
> 
> The firmware determines which CPUs are present from the processor and the
> BIOS/UEFI configuration (e.g. SMT disabled in the BIOS) and enumerates them at
> SNP init; it is not aware of the OS bringing CPUs online or offline
> afterwards.
> 
> SNP_INIT fails unless SnpEn is set on all CPUs, so a CPU that is offline when
> SNP_INIT is issued, does not have SnpEn set, SNP_INIT fails, and there can be
> no SNP guest memory.  OS CPU hotplug can thus diverge from the firmware's
> expectations and break SNP.
> 
> Tie CPU hotplug to the SNP-enable bit: disable it in snp_prepare() before
> SNP is enabled, and re-enable it in snp_shutdown() once the firmware has
> disabled SNP.
> 
> If snp_prepare() fails before enabling SNP it re-enables hotplug itself; once
> SNP is enabled hotplug stays disabled, including across a failed SNP_INIT and
> across the legacy SNP_SHUTDOWN_EX path, both of which leave SNP enabled.
> 
> A kexec target that boots with SNP already enabled, disables hotplug once in
> snp_rmptable_init(), since snp_prepare() bails when SNP is already enabled."
> 

Sure.

>>
>> Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>  arch/x86/virt/svm/sev.c | 31 +++++++++++++++++++++++++++++++
>>  1 file changed, 31 insertions(+)
>>
>> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
>> index dab6e1c290bc..04a58ac4339c 100644
>> --- a/arch/x86/virt/svm/sev.c
>> +++ b/arch/x86/virt/svm/sev.c
>> @@ -535,6 +535,15 @@ int snp_prepare(void)
>>  
>>  	clear_rmp();
>>  
>> +	/*
>> +	 * Disable CPU hotplug before enabling SNP, so no CPU can come online
>> +	 * without SnpEn while SNP is enabled; it is re-enabled in snp_shutdown()
>> +	 * once SNP is disabled.  Must be before cpus_read_lock():
>> +	 * cpu_hotplug_disable() takes cpu_add_remove_lock, which nests above
>> +	 * cpu_hotplug_lock.
>> +	 */
>> +	cpu_hotplug_disable();
>> +
>>  	cpus_read_lock();
> 
> What's the point of grabbing the hotplug lock if you just disabled hotplug?
> 
>>  	if (!cpumask_equal(cpu_online_mask, cpu_present_mask)) {
>> @@ -560,6 +569,10 @@ int snp_prepare(void)
>>  unlock:
>>  	cpus_read_unlock();
> 
> ditto.
> 

This is part of the base code, but i will have to modify it now that hotplug is explicitly disabled.

Actually, i will have to remove cpus_read_lock()/unlock() across the whole patch series and also in
the original code.

Thanks,
Ashish
