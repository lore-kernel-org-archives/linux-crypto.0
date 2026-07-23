Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011058.outbound.protection.outlook.com [52.101.62.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0192947DD4D;
	Thu, 23 Jul 2026 13:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784813113; cv=fail; b=ULBwWTTzqA8GbHncDvI2mcR0Y2Lw2Y+a8WeRjDeI8rFyXjQM7HTUKpV+Elxfp0nvOSmCB+64BR+dAKQ5VP/1ndxSSf1rdxGE3YnOXNm2VKtp6ny4sUHAu18huxW9RPZVsYNMnQAfQnVpBtAhljJULSS++RYCBqErgnRFU+qOO5c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784813113; c=relaxed/simple;
	bh=dpbwz4UCLvFkD3jj+osZ6XlAkKLYsfuaAI/vYivt7Q8=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qO/h9/a1Jmb2iK3ekXSaVcBhKg/2oyHRLqGCiQ+fneUZx/vbp3TG8jH6XAptmhsiUcoE3B294FOu7Nb7j/tCNc81VMp5og8oiitpq5Ix6BXDmjHhL0/URik3RanmFQGp5HWIaYtq4Nc0mrjJ16mTX7ZR+hXlqwKoMT1vUZ6PQ7U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XgXSlqIj; arc=fail smtp.client-ip=52.101.62.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XgXSlqIj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=euKxMDOI4ltpbpNNqBFUgbDEB3EKsQ5/J8AJGZCCcvqtVXtBrJ+TsXxA9iMQFAfetlRKpd39jHso2I2WuNrrVwxX+OvOH3ISyCm+zM4yAnelp2lSGNGBCcsIi1ES3vN7NACN2BiHbydzA2E8RSGsm4Imv8JN7HDPlRfQTh7oel3BaXbFXdMOge+bhnqltMSiKXNWZygiQSsos0CsecsOB8euK/L00LN141AQIwJcukzdKnmxZmndplI/ryIlkJuFgImwuKoXBb9i9oRSyxVu4U57RDZ8k4duiuedi/bGz5WKexxi42O1uksEwbquONciUuYsx3YBEYz7OnQYzIhRjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g/egDmcHofbDGYyYI2ym0QXGndMmoO1CKouMBzHBtK0=;
 b=qFdztVBWYrYGmYMPvGlXyxn8QBnVDteBScEPY7L6lEFdx9eneD3KyyYVqOczz9EUW/MzPtVtK7NK6g8jt/NJF6e0sr1Vk9D9fxlRuBsDmFL4LAjJVIaEbCO7i06QtX0nWqIhO+nD7GmgKNooBC3f3DqhoxEitA3g63CyVkF4dWNKh7vMh8fU2t3H55NY0Een/wVPLAFEof/OADhrl51+DxLir+rzrn+JK94M0mLSLM9i0u3PXhyvRPVpyAVXTHufD/TFZ7eJYCLU7sybOEsbQpLSOKQ4hbBgyy3BKPFAZBs6Jfl7ocEzud7S1PweFGZJ1HF6sJTsZZFA8f+Fap9HvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g/egDmcHofbDGYyYI2ym0QXGndMmoO1CKouMBzHBtK0=;
 b=XgXSlqIj5YyKpMOFd5V1wBZuK68N2eEUJATaMUBcfrfQPC/1hZf9b9AYozjy8W7pcJWI1ZHjwixZC921ff6wGROHUvSkEScQKnibotB85OAwMAu8Blg3E0xAUWFCimI5mC6MPQ25q3CEmAZymXRB1jqB+gXE/DIQgG50aBLDcic=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by PH7PR12MB5976.namprd12.prod.outlook.com (2603:10b6:510:1db::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 13:25:01 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 13:25:00 +0000
Message-ID: <0b471f38-8c96-4d6b-869a-44a3684ebdd7@amd.com>
Date: Thu, 23 Jul 2026 08:24:56 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 2/6] x86/sev: Initialize RMPOPT configuration MSRs
From: "Kalra, Ashish" <ashish.kalra@amd.com>
To: Borislav Petkov <bp@alien8.de>, K Prateek Nayak <kprateek.nayak@amd.com>
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
 <5460b946-b511-4060-8951-264d17a2b21b@amd.com>
Content-Language: en-US
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <5460b946-b511-4060-8951-264d17a2b21b@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0161.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::16) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|PH7PR12MB5976:EE_
X-MS-Office365-Filtering-Correlation-Id: c49bac2d-10c3-4022-e212-08dee8bdcc2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|18002099003|22082099003|5023799004|4143699003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	mSZqTLQcA+hNCa5y/XX01/s/CerzvfXEVQGF4/MuuPC9PfbPikAyvgF2zg2CewwY+HdE574oUuwEGMXPRXdS2oIIgW2MN/EpnCWpIcn0x3URfeqUr4cW9AwKvohlZtcgZ9TInasHXI8eRIdsgVHby5Lwi0I5J1kpER+4GLlKuSYN7RyJbMODYuycxm++cYwnCl8Le0aLTB608Zyc1VlDkMU5n4jw5+XfKScfct8HCbl94a608gPZ/xeKS5IZ1ONlMUF2/2Cg7XEanz5lFaTasw5nD+xU1iMxzGDEje5E+yId1IhN+1wjJHqPvcH6kQU7NNAcywaQPsTzNR1OCMtXQI3L6pYOycr8DZD2/IuOiG7gzfZzvXdO1kCnbR6TFdLtZQryeZfJ+v2FBw5Hvc/hdv0wl7ngKZyITCZbAA4vMp8VeYgXJYFaPqx7nvR+JPvBZLgHNn5Wqs8BHpHNvOhfquXIztRyABxwpytfyfV3gECBiLLPHO/ZCOvPxQOi66ut4knPn048T3ekez8ep029m6yIOwDvZKnZ4NkdzrVqw/0PcRS17mihpY3O6QiyRs0vgB1mjfz1e9aQ15hBX/oZj0QAc9DsiB5NroJ2Z25nu5a4wNh2DDH5NZFmAukRCGpaZMDwqiTQEPqS53a2JOzoZ0rrL8kayjoNe37292IqIp4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(18002099003)(22082099003)(5023799004)(4143699003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?djFuUW9hZmJRZHlreXRjRnBNYUdLdFBpNjBWL0VvOGFGbGtSZGQ3VE5uellp?=
 =?utf-8?B?R3BqbnZWcGljaUdHQ0pPcXp4d0o3aDVxdSt5TVQ2SFFKTzRwa2dUbHRtY0NV?=
 =?utf-8?B?QWRYbm9uUUFtZTBwSEtvOWpGMjMxMlNMYVFGYlVqcW1pZE9BZmVvQStoMjlT?=
 =?utf-8?B?cGsxK054emlveGVHb2k5aXZ4WHNMc2FrN3ZxbE82ZWNLaU5LN1pSaWZERXFV?=
 =?utf-8?B?QXBRQ1N0ZzIzTGlDZHNnNy92anRvTFZ1U1ZleHcrckIxMkFYS3ZTbi8rcVlT?=
 =?utf-8?B?U2FhdW5IZDFrcnViWGpoaGcyQ1p0ZUs4akVKQXcxT0ZpS0dNNFc0d1dlbGxp?=
 =?utf-8?B?cWNpQ2t0WUduZytWWGE4MXBFQXdRai9JajdZUWtZOHhHNGl6emNrdW1ML0FC?=
 =?utf-8?B?UU1SdFJxWWJuYXpZenhJK2JOajdtbDNhUUtlZThUWWthVHZOU2pkSVdrZWdJ?=
 =?utf-8?B?cE5pUXIrK1FnMjFqSUVSaHBFRVBFNjM5RmhSOG9RWDlxRzBTZVlhN2Z4dUgv?=
 =?utf-8?B?WHNpS2VoMytadHk0VmJOREtIQWNTZTROUVZEdjlmTHRGOFhFakhKMXM2Y3Zj?=
 =?utf-8?B?ZmpIQXovSStjRkd6MTQ3Y085R01yenpPbk9lYkhyeXdyZUg5UDlFOWhFZ0hw?=
 =?utf-8?B?RjRGa3lyb3lCbHl5U21Cd1BockFKWXkwRDlwY1Jlenc3Q2VTZDNBcnA4Q0lq?=
 =?utf-8?B?a1d5VkFJblhrQkRXM01KNXZpSWdLTDdaVmtXL0JuVG1yNk80U1hkTVNQZm9h?=
 =?utf-8?B?aTJZZDNyVDlTVVA4YjhtQUUwNGZxRU5nUE4zLzJaNFAvLzY0TEFHK0VtL1Yy?=
 =?utf-8?B?YUZNVEtMNG9pbFU1L0NFSU5yVjVvSGRXWHAwZG0zV3pHKzJFcTY1NjlndWt0?=
 =?utf-8?B?S2VHK24zelMxRjF1ZmdRUWZaZjBVMllSL2tubGl4RGRIcEYxc0pTZUczZjUr?=
 =?utf-8?B?ZEZxbGU5ZDc0ak5iaFd3aVRFZDJYakgyaUZlWVd2dXdJMmdabkRvRTVnbUVB?=
 =?utf-8?B?NWIvcFdMMEdvdmlWMkdPaERVRjIyZlRiMmUwbWl1RWl3N1l4MGRqVjFYVW0v?=
 =?utf-8?B?Njl1elVnSUd5UTZrZVQwUW9ndlJZKytPVGtpU01rQm8vRm1xb2hqcU9nRHBv?=
 =?utf-8?B?WkYxOS9WRmpEN3I5WkFkSFFYekdYd2xZdFZ0SmM4emlCVFVhSU1mbGdHV2py?=
 =?utf-8?B?M1A4eHhCMnRyTmJLdkc4cXFIaFlBd24zNmZPbXQ5aUNUVU1sUFM0T05rb0FI?=
 =?utf-8?B?VFdCKzI0QW5meDZseE15MVptUTZNbFZUVGRtUndRcDk0MXZHdFdsaFE4QWJM?=
 =?utf-8?B?TElMVXpNek0zUThuK3Z4QUgzZlBBWW81bWpyMDd2MHJWQnh2bUpIc1VqWkpp?=
 =?utf-8?B?eDR3cm1TT25iM1ZRK2NoRU5yQkkreTE2YzU5L1NqVnQzYTYrcnpKUDY1OC9i?=
 =?utf-8?B?T0VITkxVRXk5TWZvUlJ0SFhZaEd3L3FGblIzdys1WWJBOTVCbUhPZ2gzRXBX?=
 =?utf-8?B?MUN2eUJwTzlQN1YrY0tudWh4bHNETTIxS2JNNi9EajdQZkJBMndWdC9TTUN5?=
 =?utf-8?B?a096anBrUjBheXVjNGxoUnNnVXpCckVvMnVieENLTFpESEhTaXMvUXhHUEh6?=
 =?utf-8?B?V1VRenNwbkpMUXlIVno4NXdLZ0ptLzNqQUhsZ04zcnFESnpQV2RmMXhLS2ds?=
 =?utf-8?B?T2lqalFUNXdOTGdQRGg0MkRqMW9NT1ZDSFVSSUZlOFExWThDSGRoWHZQckpI?=
 =?utf-8?B?R1ZpMU9xYjVLaXdkZ3BOUjJ2dWR3UUJyOHJpYk53Y3BzMXhNODRSUUExdWZ2?=
 =?utf-8?B?VnJVT0xOaDFxeTJjb3hxbnJaYTR4aUcvRkdxNzhOalVQREw4aWdzUmJsTUdt?=
 =?utf-8?B?ZldXMENCUytMT1lKdXI2dk5xV21zdC9Md3E2RzBHUDN1QXBaNy8zUE0rSnVH?=
 =?utf-8?B?dS9ZKzd4akozY0NxdGw4dklQN2pINnRrbHcvWVVocCtIU3ZSR0wvQzFmUXF2?=
 =?utf-8?B?MjY5TjVQOEY3YVRnMTFudkhialV6bmVtbVpkZTEyNy9jWVI3ZjF4aXRXcmpG?=
 =?utf-8?B?blJ0NW1hTWdRNExSUlRGaFVvc2p3NkJlSW9rek4zQmp2TTlvNDRSRHhpbTFr?=
 =?utf-8?B?cG0yL05wTDdCUEl6SlR1b3BVakVBT1lubkkrcWJrb01qei9XK2pyNStyeUxC?=
 =?utf-8?B?UlNqTUw4VzNZWXN0NFFSMTRPVEhpTXZTeDVSNGZURTZwWHE0R0RvNVFubUlR?=
 =?utf-8?B?Wk9JVFNoRGZ3V2psY0RURUU5VW5LVzRld1RnblNvU3F3Mmd5R3dCQjMyQ2Vw?=
 =?utf-8?Q?j5e+BP7B6TuNG21h94?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c49bac2d-10c3-4022-e212-08dee8bdcc2a
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 13:25:00.7916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bv5jAuPBdilVJuPEG/dJaFUkJE4+FPkoTgryOqwz4lIBVrL9K0PslEvR7Hug2iSklp0/R2Q3mEUuYNuGZeV8ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5976


On 7/23/2026 1:50 AM, Kalra, Ashish wrote:
> Hello Boris,
> 
> On 7/23/2026 12:14 AM, Borislav Petkov wrote:
>> On Thu, Jul 23, 2026 at 10:23:56AM +0530, K Prateek Nayak wrote:
>>> The offline cores will remain offline since hotplug is disabled. RMPOPT
>>> is simply a performance optimization for RMP checks and leaving the
>>> offline cores (that will never exit idle) unoptimized should be
>>> acceptable.
>>
>> What happens if you boot with a subset of cores, the boot flow enables RMPOPT
>> and then you online the rest?
>>
>> Have we tried that?
>>
> 
>  It can't happen here. snp_prepare() does the following, in order:
> 
>   1. cpu_hotplug_disable() — freeze the CPU set.
>   2. fail SNP init (-EOPNOTSUPP) unless every present CPU is online (cpumask_equal(cpu_online_mask, cpu_present_mask).
>   3. enable SNP.
> 
>   snp_setup_rmpopt() runs only after snp_prepare() succeeds, so all present CPUs are online and stay online (hotplug is
>   disabled). No core's primary thread can be offline at this point.
> 
>   (The kexec path is the one exception — snp_prepare() returns early there — which I'm handling in the other thread.)
> 
>   Thanks,
>   Ashish
> 

Additionally for kexec considerations: on RMPOPT-capable platforms kexec clears SnpEn (full SNP_SHUTDOWN_EX, x86_snp_shutdown=1),
so snp_prepare() re-runs its cpumask_equal() all-online check on the kexec boot exactly as on a normal boot.

So no kexec-specific case where RMPOPT gets set up with a partial CPU set.

Thanks,
Ashish
