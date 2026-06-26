Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011066.outbound.protection.outlook.com [52.101.62.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8F539282C;
	Fri, 26 Jun 2026 02:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782441534; cv=fail; b=twPOTkw4aoFVfnMJbtksLt1aJTqssrQ4Pvl0iWeEHBXW/ZB9jBH9bndzaakzDHNrCJ8g3Ln9bJ5LzqlnmOdrwGaVzwnnHi1FpuR7TGPpu5Vev+Ei9f10a4iwX2Y9B80DOH+j0vau0yxs1/7lvAQBxKpdbrWsE9f/ZmrlcWsexNg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782441534; c=relaxed/simple;
	bh=xP4RkgMqooXMIEVG1ZHqWl7BO8G6nJqeolhPDgu0LFA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uwQzPuI/t3QMjQJ/QGBOIPGY7v3ddcErRhMa4OFG3z52h+UfSWf4e9XWNoTNX66yGyjMGSvpZmlkUH+5F8LrFpS4O/SRRPWJ8PSBevJoEi7r2VQa3AAO93fghfSx3y58/8m8ATaxV1G6ThUflfEVBWy6tiX5wogLxB/kJK0hkdA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0AtJxIW8; arc=fail smtp.client-ip=52.101.62.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0AtJxIW8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iFjl1cMqkhTKDyWecLt8pgIT6yh1/o5YJVVY05vrmL2i4KJxvh/37vZ1kfAz15GdtWy7wkQ0LOQwFo8FXCGnwADCNLJRWdRSONi5nLm1eti4cjUKaCd8hycJ7qVU3fDujsRFq3vWEVKxBuXeRB6LRyUpndFE9+r1mG6hWCZmu4XiuSAj1/ss1QmD3HsDhuJ6WtMM4rBAbrXKYh10U9f8JoYKB/4sUDEKy0p6C3l/Uv3u2LRYTvhxECWnT0FHlZdryIfsTfNFLy2fWBtXnKe3xavxycdaJE0N6OzaZ0utlhb9h5nqYPJ/r0BkrNYa+HcCIgEXnjUpnG4BbQ2L9bJveA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WlevGwQtcfFfHQF749V3+EY5pgaKBXNH5bySVOTQpso=;
 b=rOA1jtxSKO5z76OPUI5a5HnxjvZztv4RvLQrVgv5kktQeMQ8cwDl4a1ciwvcWHpDO7XnFemiNhboazOj9SFXZODGiF10AM6Ql1Y36bczkD1XngVCc9YCL25VtzqJAGUFaEb8X53KZWN3vZ/hn0jqpe4Cmzf7RACvh1BxkKCoJbBC0GZZfnuDH6Hmt7BRHLc1CqPTkITnXQGYHfJCOQnngNGSO3ceVF0/Eeh6t8zioFV+j7HrCOA9DThEViahsdOxxDpZv0O4XOIqouZA4CA9ANINCvJIZf4h//f9p1vWNyueaY4eRv4y7c74B82yP9i0G0FmN9uAHIShxt/9xJ9vqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WlevGwQtcfFfHQF749V3+EY5pgaKBXNH5bySVOTQpso=;
 b=0AtJxIW8E6df2AO4d7fLNNWOcz1sUKAISVF6cl+4lENfeaxtCZ8NOaB/seHIJk7BaztxWkiZq3UBYfFLyN5BIRDVzVhrbgrMPP/+Sw4PZEJItYRfLVdde82F0tK0lMVXLy2iAK3P0b1btdc5dk7cuMVDEU6ufXGbJUdn1FAiJ1A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by IA1PR12MB7661.namprd12.prod.outlook.com (2603:10b6:208:426::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.17; Fri, 26 Jun
 2026 02:38:47 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0159.012; Fri, 26 Jun 2026
 02:38:47 +0000
Message-ID: <b9777de5-a6fa-418c-92d2-89c095e91837@amd.com>
Date: Thu, 25 Jun 2026 21:38:40 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 3/6] x86/sev: Disable CPU hotplug while SNP is active
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
References: <cover.1782336473.git.ashish.kalra@amd.com>
 <ba146ca15b7f76eee386c8c073fb3f1cc36e5781.1782336473.git.ashish.kalra@amd.com>
 <20260625150253.GAaj1DHZC8ULg6PzbI@fat_crate.local>
 <7c64d96f-f932-4db9-8119-b9e40d5b7fd9@amd.com>
 <898e378a-cf7c-4310-b439-e28ec0a71338@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <898e378a-cf7c-4310-b439-e28ec0a71338@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR13CA0035.namprd13.prod.outlook.com
 (2603:10b6:610:b2::10) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|IA1PR12MB7661:EE_
X-MS-Office365-Filtering-Correlation-Id: 131ebb63-c9fe-4860-c625-08ded32c0bb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|18002099003|22082099003|4143699003|56012099006|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info:
	AvdlQENNHTK5q5Ray9YWmKALg23tDwDQUWM2GCfetMJ8XdapKS73wmu9zrAZtl+10F+Q0mUKDw9X6oRAw6d41EquQ+pLBIB9K3TObdIXETjnc1hq12c3fMXUCwxywtHyrPsQhF+m99cHW9uZp0asddfaRpKsx2LyCjaqinQ1MPtmDLKtUvfahG+4uBrGZi9thOADY4rb4LSJAwA6/triVCItDxDcvn6JJOGK2eSXadjK/gGnoP2q8VteZD+el34litxRiiVPDlF+oEcx5ebiCGtwxASO3/U5+rMbeGZhHbeJzX2fhol0kTkdJQ13gLJ5QPRjQkLrzQRrCYXFi5oFlq1sa0FhZWC8/SYQcop6SlfvnbvbN1jzEEJHF2Scm5/hpN2pNBBZevTWLzOKqciFhH2ZAWFs7AaJj03oYEc6S0K6AEYE8/Kaz9teNUTNW5xZvzMS30/C0JBBjHqO/nOve/CiYtJuVW+HODON2DnuE/6xTFWxB3KDNGN9hVsxtCoAtro08wk7EIzLo76glhT1pPv+MelMuP26F8RBIkow46TWxzBjSpPvyAWxyfOokS4YOIn8HpDc6CwxIafizBqp//lUaLdiADUOjlzBn8SENoBaqU7yXbt55cX9ctPaLXWwIgmBEdpmlzPSftbqhMC39KIig1mLwHZZ8/ECrkVqTAw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(18002099003)(22082099003)(4143699003)(56012099006)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WUdIdjVZRzZCaW5zcHpaTm1ITUlJcldjU2pVTlZJN1J2L002R2NMUDJxRWRq?=
 =?utf-8?B?Z3NUMGtiRVpSL0VtdnRQVjU1UEFqa3MvMWRPMHdvc3VlMFovN3p0QlZoNDgy?=
 =?utf-8?B?VGVvVWtzcEYrajJDNFpLZWh5TEJTZGUycENZa3lMSjNiYlRMK1E3OVVWdFg1?=
 =?utf-8?B?QllJK0twVzloWG4vaHFZNTVuTjdkNWtnd3pkanROdVNOeER0anQrNExnMnhx?=
 =?utf-8?B?ZTNvRUNUeXZYVFZMNE9DQ2ZQdnpGZXQxMHI4RGpWdEhYWTk4ejJ0d2hGK0di?=
 =?utf-8?B?UzcyM0pYMU1IclZGL0ZRU0RVelZTNWI0bW5DWkJuOXkyNlpQTXdsVE5HTFhD?=
 =?utf-8?B?ZDViWkd6VENGMkM3a1laOXN0NWJyVi9WRjBnYzVDMTk0WlZMTjRMSURQY3lO?=
 =?utf-8?B?MkNmaSthM0hVRnlRSVU2VEN6Z0pXWGNFMW84V1Q3aTZ0bVBheHlWQm9IQXp6?=
 =?utf-8?B?OEhla002TVdCWk9yNWYrb0hVTkNnRndFeDNSWHVpZjJPSklRUVZ0VjNWeGcy?=
 =?utf-8?B?bnZKWFc1alJuRjlYZWVzYllUR3BVa3JtdnZvZ3FyN2tGV2N6UUNxQTUvVWtl?=
 =?utf-8?B?aEkrR3YxK1RWdFVoL3FTNmVXZUI4dk9aSFprM01aVEdPNURtNkZWZitBdHc5?=
 =?utf-8?B?Tlo3OGIzL3AxUFRhN1BUY0hzRU5zN1N0WXg1ak1Nb0lSVkRSQllkdWJkc05u?=
 =?utf-8?B?dHFheW1OckoyeFQ0elE5aWI2b0NJQWdicGM3WFlFaldLSGYvRlhtbTY1cHRQ?=
 =?utf-8?B?U0htZDJJeThqeHR1RnM0V09QNm5NS3VmQi9vOWVRaXo4QkFFMUZYTWxhZHpB?=
 =?utf-8?B?dVRDTzJMZTQzN1pPVHNMUjlaSC9GbXNYYWNCTFZLdlBSUXdVYXpHYWNXbTEv?=
 =?utf-8?B?ZVA5a0pkZ2JtOER6SFBaQWh5ak8rd0ZOM3o4VFNJZk5DeE9iVkJHUVNtZWxu?=
 =?utf-8?B?M0luVExlQWdzdGkvYUw3ejJOdXIyRjVrMllnNW11N2JYWnBmbmVZcXlRdmlJ?=
 =?utf-8?B?dlNpQ0djNVYySy9vOU44WEVCRllBdmd4alZEeVNSU09XYnBHaUZ5WjZKMlBQ?=
 =?utf-8?B?L2pnK29PWHIvM0Mrb0NyNUo5UkZSLzU2MkJEZVorU01QVUdSRHVJcWJqakVD?=
 =?utf-8?B?ZFRrdGxTZkljNnZnbXBtUlpKRXVXWHI1NzdQNVFjTmVYWElERXl0QVA4M09H?=
 =?utf-8?B?ZUtZU0wzaWxWVmNKd3VSOVdLWWgwU3ZXWDVCeUN3TXZScko5WWpxRi9OT2lF?=
 =?utf-8?B?VUt0NE1kOE5KUlhHRkxHc3NTVHYvaTRCSlU4bk5hcWJNV0pxTUk5TUpQV0pj?=
 =?utf-8?B?eUIzSTZHa2VsTXgvdEN2VktTNVk2VVFBYi9EMTRQSFl4bDJQMDQyM0lOTE9w?=
 =?utf-8?B?OUZ5ZktJbUFWUkgxYzJwQmdYOXVwQytkTXdzR1YwRnZmQXc1NGpwRGFMeE9K?=
 =?utf-8?B?QWhMaFQ2SWtpMjJ4dEMvWFU0KzlCVms4cWxyaEdQVS9TS1AyaHNVTjZkbEFk?=
 =?utf-8?B?RnRPNHprcUZjbU1ueFMrVDgwZzRaOWthaFlTN09iWGl2LzBrTUp6aUFidlUz?=
 =?utf-8?B?Znl1VHU1Wmw0ZDlYUmhXR2JUeXVrUDZtbWRLYWFoaTJZTDJQaTRJTzh3TUpJ?=
 =?utf-8?B?VzBIRFRZMFVZelUxZFlJU3c3aUN2N2JlZis5VGtFLzgzeFhlelE2RHdNQSsw?=
 =?utf-8?B?NXczbVpqWVZxbXBBOFk0U2ZXeHV1MU0xRnZvRjJ0M1VLV3RiWTF2RmtxclAw?=
 =?utf-8?B?MDRBWDR4eWNoTnNBcWZTTXVvMGoyYXZSV0JzZ0R5ckowQUlFQW5zTlR4U25x?=
 =?utf-8?B?Vzd6TGJkUEVRMFdvUkNodzNGK3lYOU9qVzRUK2l5TDZKRTB2eXBPREF3bkxs?=
 =?utf-8?B?akUvTjdlcVpZcFM4YXNlVEQvTW1wZEo3V0pQR1hDMVlGanRKai9FbVVPNWdI?=
 =?utf-8?B?UVRoT0o5cU9NbmxLVEp3bmNmRVhBc0xYcFBncnZuK25tK2tKL0ZqRGVMamF5?=
 =?utf-8?B?OXJLUFU3NnBoaTRtTzVUZkszS1ZKK3hFQjJRb3hLRlNUbG5NNVMrWHpCaDZr?=
 =?utf-8?B?U2FLMitKV0Y2Rjhkd3FFN1JVL241a2VQVGo0MEdRMVdXdGhLa0sydml5c1Er?=
 =?utf-8?B?M1lRR3lUWmR0cEFva2dvWXhQNW8xSUxuYVRjaHljekxyZHJXaEx2akJFUDhU?=
 =?utf-8?B?Qlk3SjZKdjlXUVZjbHplM2RhRlRZSGNKczBnZmhZRmZvRzNEVUNXZ0pYMHlQ?=
 =?utf-8?B?THBucG1jZnRwd0NYOGUrczY0TGdHWHhxMXkvMUYzdXZPazY0VEd3R1Z2OGtU?=
 =?utf-8?Q?j6I1lswaf+d96xWBTQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 131ebb63-c9fe-4860-c625-08ded32c0bb7
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2026 02:38:46.6960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 78NsXeOzFzR/2p8Wm6R3AopRFCqbrG/f4/RNW9/pBnytTeprBlwGvX6YZBlRpNwDNwl7kubGK+DppAUdkca3qQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7661


On 6/25/2026 5:16 PM, K Prateek Nayak wrote:
> Hello Ashish,
> 
> On 6/26/2026 1:12 AM, Kalra, Ashish wrote:
>> Hello Boris,
>>
>> On 6/25/2026 10:02 AM, Borislav Petkov wrote:
>>> On Wed, Jun 24, 2026 at 09:56:49PM +0000, Ashish Kalra wrote:
>>>> +/* Set while SNP has CPU hotplug disabled (kernel-lifetime; survives ccp reload). */
>>>> +static bool snp_cpu_hotplug_disabled;
>>>
>>> Do you really need this?
>>>
>>
>> Yes.
>>
>> cpu_hotplug_disable()/cpu_hotplug_enable() are refcounted (cpu_hotplug_disabled++/--,
>> with a WARN on underflow), so they have to be balanced. This flag collapses them to
>> exactly one outstanding disable per SNP-active window, because the disable and enable
>> sites are not reached a symmetric number of times:
>>>   - On firmware without SNP_X86_SHUTDOWN_SUPPORTED, __sev_snp_shutdown_locked() does not
>>   call snp_shutdown() (it's gated on data.x86_snp_shutdown), so SNP stays enabled in
>>   hardware — SNP_EN stays set and hotplug stays disabled — while sev->snp_initialized is
>>   cleared. Re-init after that is routine, the SNP ioctls self-bracket init and shutdown
>>   (e.g. SNP_COMMIT, SNP_SET_CONFIG, SNP_VLEK_LOAD):
>>
>>   if (!sev->snp_initialized)
>>           snp_move_to_init_state(...);   /* -> __sev_snp_init_locked -> snp_prepare() */
>>   ... SNP_CMD ...
>>   if (shutdown_required)
>>           __sev_snp_shutdown_locked(...);
>>   - So whenever SNP isn't already initialized (psp_init_on_probe off, or after a prior
>>   legacy shutdown), every such ioctl does init -> command -> legacy shutdown. Each init
>>   reaches snp_prepare() with SNP_EN already set, and the disable now sits at the top of
>>   snp_prepare(), so it fires on every cycle. Without this flag that keeps bumping
>>   cpu_hotplug_disabled while the legacy shutdown never re-enables — hotplug ends up stuck
>>   disabled. This flag makes all but the first disable a no-op.
>>  
>>   - Also, importantly, kvm-amd module reload on legacy firmware is the same pattern: 
>>   unload leaves SNP_EN set, reload re-inits.)
> 
> Looking at snp_prepare(), we have an early-bailout for
> 
>     rdmsrq(MSR_AMD64_SYSCFG, val);
>     if (val & MSR_AMD64_SYSCFG_SNP_EN)
>          return;
> 
> Does executing SHUTDOWN command lead to the firmware clearing SNP_EN in
> SYSCFG on all CPUS?

Yes, in case of X86_SNP_SHUTDOWN (available if firmware supports X86SnpShutdown feature)
SNP is disabled on all cores by clearing SYSCFG[SNPEn] bit.

If X86_SNP_SHUTDOWN is set to 1, the firmware clears the SYSCFG[SNPEn] bit in each core. 

But, in case of legacy SNP shutdown, SNP_EN bit is not cleared and so SNP remains enabled.

> 
> If SNP_EN remains set (and Linux can't clear it since it is
> "Write-1-only" bit), then a subsequent snp_prepare() will skip setting
> SYSCFG if it sees SNP_EN on local CPU.
> 
> It can so happen that we enable hotlpug at shutdown, CPUs come online
> without setting SNP_EN in SYSCFG, subsequent snp_prepare() runs on a CPU
> where SNP_EN is still set and skips configuring it for the CPUs that
> don't have it set, and we'll be in a pickle still.
> 
> The comment above that bailout saying "this can happen in case of kexec
> boot" makes me believe that SNP_EN remains set until a full system
> reset.
> 
> The only safe way to do this is to ensure all possible CPUs are online
> during snp_prepare() and do snp_enable() regardless of whether local CPU
> has SNP_EN or not.
> 
> Am I missing something?
> 

The piece that makes the early bailout safe is the disable this patch adds:
hotplug is disabled while SNP is active, so the online set can't change under an
active SNP. snp_prepare() already requires online == present, so at a successful
init every present CPU gets SNP_EN, and because hotplug is then disabled none
can leave or rejoin without it. So whenever the bailout is hit with SNP active,
every online CPU already has SNP_EN:

  - kexec: SNP_EN is already set on all CPUs by the previous kernel.
  - re-init while SNP is still active (e.g. after a legacy SNP_SHUTDOWN that
  leaves SNP_EN set): hotplug was disabled the whole time, so the online set is
  unchanged and all of them still have SNP_EN.

The only way a CPU can be online without SNP_EN is when SNP is not active --
i.e. after an SNP_INIT failure, where this patch re-enables hotplug. That is
deliberately the same as the behavior before this support existed (hotplug was
never disabled then), and it is benign: SNP_EN only gates RMP checks, the RMP
itself is initialized by SNP_INIT, so on a failed init the RMP is all-zeroes --
every entry is in the default HV-owned state, no page is assigned, no check ever blocks
and snp_initialized stays false, so no SNP guest can be created.
Nothing is enforced and nothing is protected.

So I've kept snp_prepare()'s existing bailout / snp_enable() behavior unchanged;
what this patch adds is disabling hotplug while SNP is active, which is what
actually closes the window (a CPU coming online without SNP_EN while SNP is
live). That window -- and the SNP_EN-stays-set-on-failure situation -- already
exist in today's code, this patch constrains the dangerous (active) case and
otherwise matches current behavior.

(On the v9 placement specifically: I'm moving the disable into snp_prepare()
ahead of SNP_EN in the next version; in v9 it sits after SNP_INIT, which leaves
the window you originally pointed out.)

Thanks,
Ashish

>>
>>   - On the enable side it avoids an unbalanced cpu_hotplug_enable() when the teardown/failure
>>   paths run without an outstanding disable (e.g. shutdown of a never-fully-initialized SNP).
>>
>> So it's not redundant with cpu_hotplug_disabled — it tracks whether the outstanding disable
>> belongs to this SNP-active window in this kernel, which keeps the single disable/enable
>> balanced across the asymmetric legacy-vs-full SNP teardown paths and re-init.
