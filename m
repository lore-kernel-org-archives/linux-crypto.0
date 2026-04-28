Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011030.outbound.protection.outlook.com [52.101.62.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412C7332628;
	Tue, 28 Apr 2026 18:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777399474; cv=fail; b=KJGLGbADkO39v5JX7u4afC2HnvDsPUV2A6D5nXiT66O4itkd9uMsmUD+pmqUACJK93y4wqI2IgXa+JBoXfW0nB70sxh1AfNJ2CUN7SxK+Vi8rTwZ072Mc5hgcCDvrthhfvu33qAYzqp8krBmgdhhhWOeGprZx/FqAOQODDr5SrY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777399474; c=relaxed/simple;
	bh=Sl8c2B+EL/sx5JAs0RCHcmJTg70fxNKiYAXdKlOpLck=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kd+N9W6ouHBdSswGqY/5FwjoT3RRvRxXWsdHMuSXlMfvrLiZnae5ZgqOWSSbGqaUZ5SAZB5Uck+L0QmdMbXVRs01XsLH9L3stbCUw54bZ72XYrbAGJJrjaZMJov5UTo29yFZmAB2TyK1+d6vOHcWSnwHoxB8vvU0dXEoJFfUpUU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5OXExj1C; arc=fail smtp.client-ip=52.101.62.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5OXExj1C"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mKv63SoHK0q8/jyhJGMywezI11KekDJ3mCYyXpT1kfsu2bU4qpdNqUuuC5iiPQAjBF3u+IJHiuAbQ8n4i5SB+CODjFYwdrfPilQ13Oq4jLgiOuUq3ujk4PWT9NnHfOV2A/cNaHiVBYZCcudSkNsOlmeQwV3aZxsQl5ADNDWoHU7hpM7iM+8P9oPSim+3Z2RWmSunyfrl7kyahzlH5O+ZX7DwrhpzCpY3qsFnFCXQg48AQ+NN8kEH1KvIRhDmqx0iOLWb9VegHdPzcxPqZ9Pe4wmQSvq3iPevoMG9hOKYUfaHIBF/PdheDCYYZ8TJJs5lKyhSCFbamgJ/Z2PNJrgQHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bTdG+HNKy+zC26eRw/7JtuwytpK9xNgvxmmvbNjGDGE=;
 b=SCSc3nhOCRWSxQPMs7XlpWHEtT24FoI8T4z7yeXOtPhDXGp0SYvoK6Ky8t7yJfbrwFKkMXmEGc/aMKdHFxp56N38oR3t+7K5aUYuRRkZOacndExCUV1xAfTO4vquNQGkwpSXBjPc/BFoqawQG6YWhRszpY7nAMW6gGB5XWS9t7CJoJtcEyDc/dCo2DnK+F2EO4rKM0B2ycObsHA8yPhdE9eDxovmW6TM45oWHv9KdhOkWKEQFMHT872pB1TOAHIrCqD8pMFAJsLkRi/IeXw74jV3GNrq9Ji3ZA7Sidy2fHYzzumf6Qfl9/lWoKWoDMYHYfWl4PrnT/rrqSvht2V82w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bTdG+HNKy+zC26eRw/7JtuwytpK9xNgvxmmvbNjGDGE=;
 b=5OXExj1CsZUf4lP532caJ2H58hz31TNNqSneiKxLvsmAmhMaoBQ7vY57dEMzeaoY+Vhx7gAR81AqJPZcutkxLxm6yvi9zXr77FSkdIIeptdBh5019ydpaPQcWIXvrP+6ua0tvs1E0LTY9B4sZ0rWaq1HW7Zf18Z70oq8+fUAZKg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA1PR12MB999084.namprd12.prod.outlook.com (2603:10b6:806:4a1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.16; Tue, 28 Apr
 2026 18:04:29 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9870.013; Tue, 28 Apr 2026
 18:04:29 +0000
Message-ID: <c38c9074-2ae7-422f-8226-a07027a1abe8@amd.com>
Date: Tue, 28 Apr 2026 13:04:25 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] KVM: SEV: Add the kvm-amd.rapl_disable module
 parameter
To: Sean Christopherson <seanjc@google.com>
Cc: Tycho Andersen <tycho@kernel.org>, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Shuah Khan <shuah@kernel.org>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>,
 Alexey Kardashevskiy <aik@amd.com>, Nikunj A Dadhania <nikunj@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Randy Dunlap <rdunlap@infradead.org>, Dapeng Mi
 <dapeng1.mi@linux.intel.com>, Kees Cook <kees@kernel.org>,
 Marco Elver <elver@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Li RongQing <lirongqing@baidu.com>, Eric Biggers <ebiggers@kernel.org>,
 "Paul E. McKenney" <paulmck@kernel.org>, linux-doc@vger.kernel.org,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260427204847.112899-1-tycho@kernel.org>
 <20260427204847.112899-4-tycho@kernel.org> <ae_TCofu4bHP_Ch-@google.com>
 <afDJZQHNi-qdcEEe@tycho.pizza> <afDYCpbeT0HsXTMF@google.com>
 <20f94bed-2843-44ab-877c-3e68bd4314f8@amd.com> <afDkcpcQ5vPsjQkO@google.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <afDkcpcQ5vPsjQkO@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH3P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:1e8::26) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA1PR12MB999084:EE_
X-MS-Office365-Filtering-Correlation-Id: f300f91c-5870-479c-a5b3-08dea55097a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	4kPJwnOVQ3PvW12EL/o5qjPoXGDLj11jft2VEzBqPWz+5wAb3e5tqtsJHC6biFJEeqNQFZGC5vPGhErgn+F4Yzfcz0JAEewW2SbsiPQYeZL1w4E20su3W7hVbzGVwKoJURmYYvqsjIFxIHXrAE4aKYvxni/GSGP78YSNRkwXW+mbhR13lHTmuX0nODEMS46E6s67HZXpB9lorzuEDXvgG0usMA8Ie5GCqUxOUjvam6K0FlXRUMSLINWrlzJKvkhSV46TFj6ukB9V6p0M0+0wHoWaKGy3oHC4vMyzCA1fF7fVXA9e/N8kfl/pwJtATfXotAORa/5PyelE4t8ENbHCMm6KTlS1foQCDqPZBl1lnWQsLu3pg8Lde2vOGh+f1fNdU3w8uWcUzubQd5Cujh+sd2DQDFxly14lvRnFSL6dlp6lEvy2PkC8X874pHNyjubjsjPv5dkgrWkjmTafExcyFPMOMOrnpPyVCHsnArnfJLmdUIsUBRIwCPKkzh3HvMq7geHZz86iwz/Q6c/7wcGnJwYYrMmonWaREtUDw8JU1rAuuXwOu8hFOYKFX4owvL+GhKQo4hTiwz4oPL7py07ltRHEmKrKvjiPWtc8zmtKtsSfeW4HKS7Xlh2VeAehtxVhwzdGTwccn5VkJakIon0zWBcT4SG5UgsoRrtulGL3qafcu6FuCGHmNZ8dg/37Ai4mzf7sWpoKnsYuZdLSW6A+6J8Hlhhn3gEWq8CAGHXRjqRPNgeScSsoj4+mJrJZ6cWc
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NGhLcFpxbXNXUDlLUTR2L2w2dFJpM1RMdVMyNm5iditQUyt5TnY0SEFDSXJQ?=
 =?utf-8?B?N3llbmE4L2pncjNVVnBtOFVpUlFlZ0NONktaRDFMZk9IU093RHVqdUgrbTZP?=
 =?utf-8?B?T0h1dUw4VTFLNWFROWtpVWdKQWh3TUJTODhVSlNaelhCWi9tcWNvcmRBV3VH?=
 =?utf-8?B?S25GWVJsMURPUXB1QjVDVlNJd01VcVM0SDhHRzVmd2tjVVh1aU9hWFJqbzZJ?=
 =?utf-8?B?MUQ1OW5MUGNpNzR2SzV5UTBkWFhYSkhpa2NzbFZLZXpJWlhzakFSKzlQYkdR?=
 =?utf-8?B?aXlHcTRqdTZRYXNmU3ZFUHhkVHc3NVRvR0FqWUJWT0Y2Q0VKcEcwR1RVTWZx?=
 =?utf-8?B?NmdjaEkxWStzbjFZNWZJa09JSXlXVUUxZTlPODdPWlh0OFVVcGhrU2VnRU43?=
 =?utf-8?B?VU13bG1jR0RJbVRIaURDK1g1Ujk3N2FzTGsvd1EzR0VHV2drWll5dTNqKzNR?=
 =?utf-8?B?QytpS2l0cG5HbHJMN2c1ekVkd2phS1B1b1NSZFpZeGlaTFV3YnRCMkZDM0J1?=
 =?utf-8?B?WW1ZVDM1Syt6a3JacGkzaWJsRDlybXZRTDVUY3ZMK2pEMXpWRjFjeWlsbkVD?=
 =?utf-8?B?eSs2RkFNamlmbHBueDhxdmUzTVB2bVgvak5pc2ZoV0tnTENRbjRxaUY2UGth?=
 =?utf-8?B?TW5qS2g1T21IUTVMcU9jUWZrMVF4UW51ZmFEWnRNNlB2RlJCZVJtaW52WUZx?=
 =?utf-8?B?YTliYi9YMjIzenBiaTl6M0VxTERvWVdNa1pGTW8zVzRQN1lPN2hUK2xsbjVV?=
 =?utf-8?B?bFlIcndoZG16K2J4WXl5MDVOTDNvZDdLR2ZZelBFOXhYeVl2OEZKd05nNjhv?=
 =?utf-8?B?clp3MDkxckZpb1JKa1h4TU9QVzd3RGM3VXhIRmJvZ0NOMmZiM0xRNHBOY0xy?=
 =?utf-8?B?NzdHSkxsSWlBeVNzdHVac25HWlRkUE5qMlJVSWJTN281cDBSQ0twMkRPdVVt?=
 =?utf-8?B?emJYWjNEMGZ5TStrSjJqWlgwd29nMGxId1ZUbGt4ZWtpOXgrS05heWhQVG5w?=
 =?utf-8?B?LzFMaE5GblJFMlhia3pZM1VLemFhYklSWDQ4ckxsMGsreWVIQ0FkVDZBU3Fo?=
 =?utf-8?B?ZDN2c1ZkcW91ZDFkdGxkV0pqdUdpT0lBYW1iSnc1T01CRGp0bDJ2RDcwWU1L?=
 =?utf-8?B?bEtlNzM4VlVxR1NxT3cwdUJhYWRkQ0YyTzVaV3RTWUU2YkVQOEJodTdNOFdH?=
 =?utf-8?B?ME0xZ2pvQXdSYmtyMmQwVnQ3YjMzRzBXUWJFWG1pWW1oVFE5eGVzSzNKMGxW?=
 =?utf-8?B?U0l0T3ExT1FTS3hQNmtuWWlRR3dMNXI3aHBWTGxpRWMxdWR4QTJDOGtldU83?=
 =?utf-8?B?VFZyS0dIRUEzOEl1VjgzcWVBZVpmUnFKRm5UUHFWVHRteXNYNWRQWVNVaGV0?=
 =?utf-8?B?N3R1dGNsZGJzNVhaTXVHUmRUY0VDWW9QRUJlaWVNOEdPZkxZVmFYOHdNUmUz?=
 =?utf-8?B?Q1ZTWkRUTHZ3dXhCTnY2azNiZG1rd3hXNnpaSEZWWHZNaGtZdDFoVFlRT291?=
 =?utf-8?B?cjVDbGoyblZ0a1F1M1ZUSDREcVlsSEpPTlhIaURRQkxuVDBESkVHY3I5UlVS?=
 =?utf-8?B?QWh3NWhuTmhMSm01Ylc3aGd4Zzd3QWk3WTJUeVY5UnFrenVGSitWQmpndUpa?=
 =?utf-8?B?VWhRKzFXT2pRUjhrUlNxNzM4Tlo1OU9qbklYY3h1L3kwc2dkNjJ1KzJUYVBW?=
 =?utf-8?B?RjF6WCtvTTZhdHdDNTl5RUsvZUF2dHBvM1VSVy94VC95U29uZm5RMWszUG9O?=
 =?utf-8?B?eVN4SG9rTm9rZmF1RlJaN1Q3VExWcm9ZSkhlc1JhMGFEeVNRQ1VqdUszYlY0?=
 =?utf-8?B?dWhwUFpIMW9xYkg1Vm5KdWtua0Z4N2wzTVBMNHZoMTZkMWtvODJ3Mlo3WXp6?=
 =?utf-8?B?ejZxbWk3L1AyTzF5aXFGL21Qc1lmMkZuaWhCVUhYSW4yeGVnaHRpT3ZKeTBQ?=
 =?utf-8?B?ZkxKeDh2ZGRialE5SXRpRzV1WCswRWFMNDM0WWx0U0hDdDJ6dDBqZXU5RVNQ?=
 =?utf-8?B?UzRYMDRwU2lLbzdIZUlZSEVoMkRBYzJyVWl5ZkdOVjJCRkNxK3VjZWY2R3Av?=
 =?utf-8?B?NkVqRENGdnRPOE1JWHFjK3hEbVJSckhSeG1ONE12UUJCeXhObldyemFQYVlC?=
 =?utf-8?B?dU5NTDBYVmdVazlqZWZuQW5UNTNUeDVYY25MaUdncHNoZGZPcW9DU0syb0Rl?=
 =?utf-8?B?bkIwQWx0bXBaYXM4ZHloY2IwYW1HMGxrcTFxVDNxSVRTWFlrQm9HRzZERWhO?=
 =?utf-8?B?TEpTN1lQUWl1amRPcmpPTnBSbDNnYWZHdVRUT1JEcTQxV2ZmekV6QzQ1ZEQ2?=
 =?utf-8?Q?PQ2lBEwq7mxpM9xgLD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f300f91c-5870-479c-a5b3-08dea55097a7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 18:04:29.4830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ng4DgiWMwkHwGhbNex6TLy8507xllwnjlF6HGitGWU4Cgnnq1t2NImP2FNze6hmT/5jnAeEchG3cS48Ya7jA/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB999084

On 4/28/26 11:46, Sean Christopherson wrote:
> On Tue, Apr 28, 2026, Tom Lendacky wrote:
>> On 4/28/26 10:53, Sean Christopherson wrote:
>>> On Tue, Apr 28, 2026, Tycho Andersen wrote:
>>>> On Mon, Apr 27, 2026 at 02:20:10PM -0700, Sean Christopherson wrote:
>>>>> I'm pretty sure I said this earlier: KVM absolutely should not be able to disable
>>>>> RAPL for the entire system.  That needs to be a power management thing.
>>>>
>>>> You definitely noted "not CCP", I don't think I quite understood what
>>>> that meant though:
>>>> https://lore.kernel.org/all/aZ86BZWi-GLiHvmt@tycho.pizza/
>>>>
>>>> I'm a little worried that putting it in power management will generate
>>>> some weird dependencies, or weakref symbols that can't change things
>>>> if they are loaded independently of kvm_amd or something. But let me
>>>> see what I can come up with.
>>>
>>> Ugh, and it's not even powerman per se, it's actually a module in perf.  Oof.
>>>
>>> I 100% agree it'll be tricky, but I also stand by comments that neither the CCP
>>> driver or KVM should be allowed to silently pull the rug out from under the RAPL
>>> module.
>>
>> Maybe something that can be added to the current sev= kernel command line
>> parameter, e.g. sev=norapl, or such?
> 
> Yeah.  The only question I have is if we expect end users to want to disable RAPL
> at runtime.  If so, then we probably want a sysfs knob or something.
> 
> However, letting RAPL be toggled on/off will introduce some amount of complexity,
> as the kernel would need to negotiate/coordinate with the RAPL perf module and
> with the CPP driver to ensure RAPL stays in the "correct" state.  E.g. if the
> perf module is loaded, then RAPL is effectively pinned "on".  And if SNP has been
> initialized with RAPL_DIS, then RAPL is effectively pinned "off".  Blech.
> 
>> Maybe even with a kernel config option for a default value?
> 
> Probably overkill?

Yeah, probably.

> 
>> On SNP_SHUTDOWN it will be re-enabled if it was disabled.
> 
> Stating the obvious, if we do this, we open the can of worms I described above.
> 
>>>>> KVM then needs to communicate (and enforce?) the policy to
>>>>> userspace.
>>>>
>>>> KVM doesn't need to enforce anything, the SEV firmware will generate a
>>>> launch error for policy violation if it's not supported.
>>>>
>>>> For communicating to userspace if it's not a kvm module parameter, one
>>>> option is to mask it off in sev_get_snp_supported_policy() if it was
>>
>> Did you mean sev_get_snp_policy_bits() or were you referring to the KVM
>> ioctl() for retrieving them?
>>
>>>> initialized without the support. Then it'll be visible via
>>>> KVM_X86_SNP_POLICY_BITS.
>>>
>>> Ya, this is what I was envisioning.
>>
>> It's still a valid policy bit (if supported by the platform), so I don't
>> think masking it off is appropriate.
> 
> But it's not fully supported, no?  I.e. won't the VM fail if it requests RAPL_DIS?
> 
> Ooh, presumably the subtle difference is that on a platform without RAPL_DIS at
> all, the VM will successfully launch and thus could run with RAPL enabled even
> if the VM requested RAPL_DIS?

No, the VM launch will fail in that case, too. But I thought the
difference there would be getting an INVALID_PARAM for specifying an
unsupported policy bit, but I think you still get POLICY_FAILURE, so maybe
it doesn't matter.

Thanks,
Tom



