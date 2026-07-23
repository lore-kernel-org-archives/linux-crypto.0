Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012037.outbound.protection.outlook.com [52.101.43.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D382270EC3;
	Thu, 23 Jul 2026 07:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784790212; cv=fail; b=LDAjxyk6b+G86e8OI/dlxZ3np17P+7XDvJb+4Ltobl0TIAJW8pkv4iXf7KfyhV/KLw8Bg0MFtj4PqRz9blz3L2lxLN2TDvgFaVwKkUa2HS6AqUokAy+W/V7wTUagTB/asrQzdK66VcAkc3if+NPmfYXJ/tDSZlfldK1QMswAIRE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784790212; c=relaxed/simple;
	bh=C7PxaUuwEX5wktlma8Bt6yDCUEHLPStoPZL0AF2ANUM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Z1fbWmPP5AhY3gjIVhDvhiMSGwUSB1Xdri4wUw3W/h32qrtRngxBaiIp2jmDMnwt7qSNWCDg6mYtm9fnNtazRtGkvtUb40AuzeQo4jI2B2yJNekhb2kSAnl8vSuorLGuUROXaF6aZRfTso1UUTqBHOG+mOgIxB8uCDitbMx8Zb8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HVM5/cjH; arc=fail smtp.client-ip=52.101.43.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HVM5/cjH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j0Wgdc+NUfUlj1pxyd3iSzwcjRnj3Y/KfZ0bmX/kANZDdHTc36ytVd1rLn76LCuq+EamRXyUaZy+89+yBHDelNDEUDuyYkviXTZJc4Tshinv33ACRmr8ebDhb22GD5fQ1Bwamc43BE+cW8QlNAINgDM8MIY021/gqFWhJxu0zbNP+tUNTv4AAhUdhj5WIkl3yhHJtYjlpIYDKqOT647Elc15J0F8lfJjb8ehWEmt3sBthOX6169eo8L0dR5sac7k/bNs5QBxLbypSVmLngQQwJImc50BfyJDlmAxnV5wUKtnqAKXBtXA/ALwlEBQOElunzr7aThpcX4UmHn1FQkH7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vb+fUJQBUsjGywsl8Af/9NcCpNXvrSRm2FVLjup6Jpg=;
 b=DTkU+dwG6XBhmARPjuEqdacbt+AAH1nqrKwdtdgnmflDByhrQRcW1bj7jS5iES4neIjOHR604NjDPN1DCqIgA4FZ/hAMGvaNk3V1dtCzhP4H94FOlwo+DJOzp9mL+uNobvimiBeuCFNWwE2/vjAPj+ZRh+jncSP4Z4/Y9fHk130Tou+bBWHihK9vNnslqJFjoL+ep0YSTwQPQjoIhAOgtntnJm+4P8kQCM59pvpDMBhZWM3/VE+0c2zarvsLKLShJUNwbHQot1boAtFYTsmP0wnPOnPBfkg2l9QRdX4zUY9Nvua6uQbWQDVesrapiDjZlvVPFji0HTXikuvnWV8rfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vb+fUJQBUsjGywsl8Af/9NcCpNXvrSRm2FVLjup6Jpg=;
 b=HVM5/cjHs+kgxl22BHYSAywKJh52Ixz52CXHfzdScpK6jgJtVzQcOes4CS3kxUiAHccZvsyGVnO1/9os6YXG0JCr+svFX8EE+loSChvQP6S3Y7M3HMKkqQWOfw6BDBUYx0Uewvf83ZH2N+rrD0Op3sg0RhSrfhgxjxK8ZbrdNFY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SJ2PR12MB7867.namprd12.prod.outlook.com (2603:10b6:a03:4cd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 07:03:24 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 07:03:23 +0000
Message-ID: <6b284f81-3551-471b-bdaa-5c5f8203bdab@amd.com>
Date: Thu, 23 Jul 2026 02:03:18 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 2/6] x86/sev: Initialize RMPOPT configuration MSRs
To: K Prateek Nayak <kprateek.nayak@amd.com>, Borislav Petkov <bp@alien8.de>
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 thomas.lendacky@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 ardb@kernel.org, pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com, ackerleytng@google.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
 darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1782841284.git.ashish.kalra@amd.com>
 <8518e02c46d6edf1f37a180569c708a3cfa7c413.1782841284.git.ashish.kalra@amd.com>
 <20260723011031.GGamFqB1i4zt4Zlsx6@fat_crate.local>
 <9cfe76f4-8e16-4b21-a414-126a06859489@amd.com>
 <20260723051422.GGamGjLhlTqRDcFlee@fat_crate.local>
 <70580cfc-8625-4f35-a77b-7154a52e10a5@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <70580cfc-8625-4f35-a77b-7154a52e10a5@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0082.namprd11.prod.outlook.com
 (2603:10b6:806:d2::27) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SJ2PR12MB7867:EE_
X-MS-Office365-Filtering-Correlation-Id: 17e3b63f-a12b-4ae0-28f3-08dee8887c55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|18002099003|22082099003|56012099006|11063799006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	xrTEeUhFdMkoHbvQNpZ02zVvkgRFkfXYuUnJBzaOSv1Uh5Esr/58Zdct82QRRKOh5EwGCYQEM6KCtROeJzRMQ6dIQnk3a/EH01lpLuhWLZsDzaLuIW+lzvZE5XgoD7i6n2rHyB1wlxsvO34srHv+cAUNmWfMKXr/U+W98yTFXJypidMtJqjNSV6Ne1XOIgqmiP5VHNimXAvijzAeO4usp4U8eMWGrHs/zRrKdxh1gz+8V4JvDIkT8YVlLcMKjCz5pDbuTcbBJ0t+4HDVopSeEXVTc8Z2gsCDZojN44NR+N7cNk7uNSZl9hJj4Byd/mbcCfMxnCov8LCFe/xXJaAclS8KjVx8sGOxqEKktcta9JDadhBAyWlIoJ5lCkahsnaSf9rcHMWjb6naiO4j8Or+KPStkwL5adLgcHuPCKF753hgyIq9UVDmvFxPgyyLR9IMt9r3blY10VQEbSCyL9MNVHmRXVhqnHQ/9yCdjpomF2JL4NFtst4M5ERamCsLNgRhStmoCY9MVJ2OZZAGyzeLRzgpMvZbDnM0CXReoxZs8ezEa24FH0wsP8oZDBaYyqjLK98WMHLdzYDOxm15iNylT51mM76RsUtarBT+eXVycl2+1DdbZ3/NXdsViPZYAxhrcASZX2GMMq7l4x9HdF5NtZYwujrfxL0yRxhkJEOz/8w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UVl4eUJSODFaNkgxVVZHbEJ3WkJ1b1EyMjJlTUF0b0tMbXQxWFNYMGFLeFdu?=
 =?utf-8?B?Y3VmMFROK25KNnY2MVYyZklOa2l0K3VCWUJ5WVFiclZoZWF5ZXB6U01KWHM3?=
 =?utf-8?B?NnByRzFDSGVES29JbHFkVmRSVDY2NTlaTkRrZzBFQUFUMGgwcVY1UklITGx6?=
 =?utf-8?B?Q1JFUlJEdWJJUEFZd284YVBoRlIxcU1LbjMwZWFkUDBUT0tsVVR0eHFMRzdL?=
 =?utf-8?B?bWhEWk5reGZXYUNiVVdKaUowVXdEZjVVbnRYdzZiUVFVY3RhMjJDemVVWFBM?=
 =?utf-8?B?aEVsaW53U3NJR1J4Tnh5Z0pjanEyYTcxOTRqdXd1bXpDVE9mT2xiNmc0UFFM?=
 =?utf-8?B?L3FzRnJhNTdjT2dwOG12U3o0QjZtS0wxcll0TnF6WDlQSkxkWkd1Z0tud044?=
 =?utf-8?B?L3RnL2crdmw2NjcvTkNWNkhqMU4vT3c4TmNKQWRFME9VWkMwcktjVFZ5L09J?=
 =?utf-8?B?Uk5naXlEK09KK2xWa3pwZUF3VTlma3hjcUVSMUl6akFVRk5YbldqWkFqUWVT?=
 =?utf-8?B?akhVMDRhSlQySlZETC91ZGMvdW5iWGdaV294ZjF2TTRyNFZxUGZMUURZckdQ?=
 =?utf-8?B?L090YnNWZWNIdkxXanlpb0NwYkN6S3FMUjZMMHdySnBnQUVYL1Y5L09JL0Fz?=
 =?utf-8?B?Y0dUamg4WjJaMFcrbjdQdWZJWC90MHF1dExFb1ovdlNUUHZUdFh4WGlKV1hV?=
 =?utf-8?B?eWxsZWpFbG5VdnJYM3UvVFlsZHRBRkRUZmo4L09HSzZ3T0toZTNwUW56T2c5?=
 =?utf-8?B?TWFSamdhb25VNkpJWFZwTStKZzhEUUZxeEQ5MjNMWVZHVjZKMTZ6eE9vU3ZL?=
 =?utf-8?B?UkFNMlNMUndadWlXRFVCSjFkR1RDeWY0ZW9LV0Exek0yZ2JpZlFSRk1jY0ZU?=
 =?utf-8?B?bmJGVGtjUUZtd3A1S0tjZzE1LzRkRzM4Z25VVkNQNmtKeE5GWUs5QWNmRGJx?=
 =?utf-8?B?MFdaR2tJVjQwMmRsZ0greUdKUWNoZ1B5dWdvTGpWZnJkN3h0NHluejNSSUFh?=
 =?utf-8?B?b1NZMHBrSURmQVpYNStmdHRaSXpBRkNNSWR0bzdjSE1PSWIxelN3SEVma3BX?=
 =?utf-8?B?WEgvMlpER2VuWjBYNWNhZkE2c2tqQVc4dlhoZm5rZ3JJaHRuWFZwa0tqN08v?=
 =?utf-8?B?YndxMWhiQmJ6dVE3dWdYTXVINFRhSGRNNTBrQzZ4Zm9qUDNhbjNaUFJyU3di?=
 =?utf-8?B?dzVNVG1yNWVXeEdzK0VPcGk3MUR3S3dGdk5DeHE2Y0s5QjZ5dTRzam51K1V6?=
 =?utf-8?B?YXdVWlR4dU5vM3JPZjhWSEN4aW04ME1RVFFENTIvVDV2TklVSFdHVllORUFI?=
 =?utf-8?B?b3NTUExENHU3RjQ4Wi9xTnMzcHQwSEdpb2VIMW10VjlYWEtQd2RxZmgrcHUr?=
 =?utf-8?B?RjR5eEJ1Uys2K2hubitDZXdURWUwOUU1UkN3U1FJQXMvTnVmSDlMR2R4Vjg4?=
 =?utf-8?B?emU4MzFYNndjWVhtRFdQc3NHc0h1ckNOWTR0cGhLc3FlSkxsS0NNRWpqVjNJ?=
 =?utf-8?B?S01YNUxWRFNtS0RPSlFCZW9TdnhDZHZNdkF4amYzVTFDWjJxczdDN2MvVzJz?=
 =?utf-8?B?Uk80bkpoZlZpdTVzaFUwZHNsQzBBVWlqNnJ4dnZhWnRya3NDNHpWbXVnbGdH?=
 =?utf-8?B?Q25ldjFObmxhWGRkbGZjNTN4MVZFd0hQclowdEdjUjF2bzNDYWJEdnlBWWU2?=
 =?utf-8?B?WGpDNnhFS3dka0dKYTFBT2JsWVZkcXFHZ1JWUjBYNWJqZjloR0FQMGhndlJL?=
 =?utf-8?B?bFg1WXc5Vm9xRVhIU2kvYmJtR0ZwYTIzTWNUTzJKN1hjUlI0d29SYjBTQy85?=
 =?utf-8?B?ZEdOU1ZUa0lzOW9ZR1JkeFB0RlRuclMxc0tyUE9SeTdhM29UMFJYcXc1Qm1o?=
 =?utf-8?B?VlYwZ2UrNXVXOEFIdmovYzBmUG5pWU5nVmc5WE13Vis2cmhodTdJdUxqaUtE?=
 =?utf-8?B?bGxUVTh2SHM0TXdZL1pJQ1VOYWM0Y2xzUzhTcVB3ZjhoaXVmT0xIOHkrUzRM?=
 =?utf-8?B?K2xDdFJKdVR2LzNzTFVpK055R20zcUkrRkVUMGQxOUdJd0pWS2l3ckx1SkdF?=
 =?utf-8?B?L25qZmFqcGhLNW45dXNrWlQwWThCczFHbVIzM3lENWV0YmlUMDQ3cjVuWWwr?=
 =?utf-8?B?NWMxUXZQOHRjamNUMjR0RFpiSXlLMVQ5ZVVGRjJrZy8xNVZmeHJnMVdwY3BG?=
 =?utf-8?B?bDRFZDBEcElydythMVpyZWl2dXN1Q2VmSUxUclBMMmVuOG1pOUo0TlBlemxm?=
 =?utf-8?B?MTRGdVQwank2a2EvTEJ0NFovMVV5SVFpa3F3cGRlSXlHaXBwcDRCdnlMTzVt?=
 =?utf-8?Q?OdR90WlV+2x4UhWTZv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17e3b63f-a12b-4ae0-28f3-08dee8887c55
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 07:03:23.6650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uM2AX00zFWTruGDLQFrZcQMoJLL1UlzNTOsabm00WAJt5JGN4piu0XfKFmaKHZ001N9s2JylMpP4YN6TTak1Kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7867

Hello Prateek,

On 7/23/2026 12:58 AM, K Prateek Nayak wrote:
> Hello Boris,
> 
> On 7/23/2026 10:44 AM, Borislav Petkov wrote:
>> On Thu, Jul 23, 2026 at 10:23:56AM +0530, K Prateek Nayak wrote:
>>> The offline cores will remain offline since hotplug is disabled. RMPOPT
>>> is simply a performance optimization for RMP checks and leaving the
>>> offline cores (that will never exit idle) unoptimized should be
>>> acceptable.
>>
>> What happens if you boot with a subset of cores, the boot flow enables RMPOPT
>> and then you online the rest?
> 
> RMPOPT happens at __sev_snp_init_locked() for all online cores. Until
> then, SnpEn is still 0 and we don't need RMPOPT because RMP checks
> haven't been enabled yet.
> 
>>
>> Have we tried that?
> 
> That said, Ashish, should snp_rmptable_init() do a
> snp_rmpopt_all_physmem() (or something equivalent) when it finds SNP_EN
> set in MSR_AMD64_SYSCFG after a kexec?
> 

It already happens, just later in the sequence. On kexec __sev_snp_init_locked() still runs: snp_prepare() returns early
(SnpEn set), SNP_INIT re-initializes the firmware context, and then snp_setup_rmpopt() is called.

On the fresh kexec kernel, rmpopt_wq is NULL, so snp_setup_rmpopt() does the full setup — programs the per-CPU RMPOPT_BASE MSRs and
queues the initial all-physmem optimization pass. So RMPOPT is re-applied on kexec through the normal path.

Doing it in snp_rmptable_init() would be too early: the per-CPU RMPOPT_BASE MSRs aren't programmed until
snp_setup_rmpopt(), so a pass there would have no base configured.

Thanks,
Ashish
