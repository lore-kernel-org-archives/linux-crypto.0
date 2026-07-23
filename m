Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012031.outbound.protection.outlook.com [40.93.195.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F303EBF18;
	Thu, 23 Jul 2026 08:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784793633; cv=fail; b=glbFv0nNb95Swl3UEJHe74fQCudlMBLVahQdzTlSg91wZ4wKbNdvZW9ENbdIiQZDtG+ja4BA0hGPln4Lpfjeg2QtQdvNpzKfw5GrTx7RuZSdkIeCXdFpyDgPSTZb655kEVuNHkAdRBYQB2AszzsJMF9Crr3YB830tVUnqRV5lTg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784793633; c=relaxed/simple;
	bh=+IEwh1Q1wVZR+t70RhH8I+mazcvJp7kmx/xBaYmLJiY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oQ8dTraVnQsmtQ/ANZNdMdzYh7M5wwQa/Scr7nZi23jK7IUkPujoXgUJ0MKiz4A0FHvSCmC6kU+Je0T4QsK4F3fiVSjV7CWkvXAIeCFquqC79SIrnEf7kVHCSxOSOleiExB2HEie86nFnf6GMlwngKaEyoNn6HW1tR0cAYQsOzM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zJQL+awn; arc=fail smtp.client-ip=40.93.195.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zJQL+awn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MUuuyNXlbqoEam1lio8af+5P05TV9NKJDPbrHbT3oMemUNGnApnajl1G+pYACdmfZ3Rl6GdurJilTeYyZnCmpnO5bB01Jd1jyDgcfC2uMQSzTKkcNHLKhOkARj7KZHOLMc6B3qybC51v8rMvYdZ3WkYLDbfL5BZDYeJk+8R4LIC9mRbZANfdSwkGY3E1eFYVshdC0zpPY2slXerfugHF3bvZzoO3ftC1PvM6Q/K1C5OpmXvlUi1pNaEVTLdU/xfbx6F59vzXzDcWMU0KSusT2lQBYC7o+6CXvSl+BFuwp9nhGMfWflEg50eYP8hHIibds+vne5OmHavBvROslA/IOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MbkE+uSwyaWRfX2qw+q3LZpRZBeGSOTib8Odfk2Y70o=;
 b=EcH+W0ACPtiI4nMZMsweqadg4xNTXDCOVfhPKLgeoVrHgLzI5q7JJ+UjAB3gnTkL63WwCq4+Nsr2FGxUNDVVuRqmLcC76Qbu+mDGgaUSqeY+/RIGD83I6AEkfl3HJH2EXMPn4gI0Yv/KvH1/R/6EK1D/Ie6SloR39Pj64AqTmmK9JMOcRae394dKc7tjhb9WEUUpOWCEvONDz8JFM5B+LaLF2CzdQyf+4h52aVyvY802wYcQ38iLxU3Fe5mmM8SK7QBxNoE8GxtfxeZQcrIB0O2JkWWG0o+WP9UVGG9XRfLoV9R9Gp3hDmxvPEQVBvCV3yMUgP7pHWli3G6um31p5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MbkE+uSwyaWRfX2qw+q3LZpRZBeGSOTib8Odfk2Y70o=;
 b=zJQL+awnhkuQi889MVnQredYoxlg4DZPMxyiKoBXEglNvbSx9ebaOIRNTA6O7zqnQLHAK3DRR2HcHHryUB5dOCWwSBIVNj4sRmDSdabexBA3bs5Ab2uRpdIsHIxfCOFcgHptC+go+zDx+mN4ZcHpuyLQzDBei1U6nTi4kuthQng=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DS7PR12MB6311.namprd12.prod.outlook.com (2603:10b6:8:94::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 08:00:26 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 08:00:25 +0000
Message-ID: <2d482d4d-b0f7-4da6-b08f-f7b5bfe3265a@amd.com>
Date: Thu, 23 Jul 2026 03:00:21 -0500
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
 <6b284f81-3551-471b-bdaa-5c5f8203bdab@amd.com>
 <535c2a43-47b9-45ac-be9f-d0c53f9f01cc@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <535c2a43-47b9-45ac-be9f-d0c53f9f01cc@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH5P222CA0002.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:610:1ee::22) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DS7PR12MB6311:EE_
X-MS-Office365-Filtering-Correlation-Id: 00571478-2676-4f03-7185-08dee8907407
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|7416014|376014|4143699003|5023799004|11063799006|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	LP+FJLC5DhuUZIHryCTXCuLqijsByAF/6XTVHVSxCB2NsXvE6UiuHQCZP+iYx0SZ138CPpUWozqIBC2yvuhV+t5eESuTMMAfF4Yen1j7NjQ5dseDe4ulAp4Wh/JdpDr+W0C08rSAMLRV1UaZAzsVP3RjO4ijlnDTQiWyTgoj4FMyZQv4S5iynwU9XNK6SqcJhVI34V8EbvvFTGPR6zKsbC3ovqWYmFqoyglgYmrlySe50UD8hIXB7AOADsgqBW4Qi2pD65iRebOCCZr+fQwT2/IOCQoJoxPVdH4UQpXi4C52A1/Cf0afoa3GCN8FzaqNWh4V0i92qUIf2d95McniSzbN66F4dZBkLgtSlnzEBtQ4yrG1rQXGMUYiFPJ1NGR+ROM/+fnu4myGMsW3uS7vIDP3wdOhLtiBGDhX97xIlQjTr68mQ7iR7cpPzPnl11/TjDWkHQFAxQZE3WNJ7EotjJdrsCVPUCNwLZsGpALubH5KddoFIK86wY8I3dJdeMUdnl7cUxg7bPh+biI41x2nj2ut9Cwqk+EPv3VZV+1NgdbGC71aLrR/c/b+ImrAYvCdUQy1kGj2o/MbKhlKMz9Ygy7Omtxaddy0b4soDFLQW3Pexp+BT79YJQ5S8q4ykycevmL14tLNIAwChXYPR1ajB4LutpY6DxIT7mR3kXE6nKg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(7416014)(376014)(4143699003)(5023799004)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cmt0QlJaaGkxRHNzaUMrdjF6UkwvOWpoK2xYUTFyRnVSNjFNUU9WcVBQckRI?=
 =?utf-8?B?ZzdLVFg0VGdVYWdBR1dpSXBndFlBQUNXckZNWmVJRW9PNXVJdjh4dWJNeWdK?=
 =?utf-8?B?SW1xNWQvazlBZ1pwd09UR2VqSmY2aDdWZjZmL2pzeHdJOWgweEt4YzBpUzVt?=
 =?utf-8?B?c29SdkxGNWV3OW5tN3R3L0VseGMyR3NpSTJ4cUtKZjRCVEFnd1Q4QzBIa0My?=
 =?utf-8?B?VWI3Z2c4ZUc3UVlNMUMwQWJvT1I5T3ZiOWhBQk9ZVDIwWFVUeXEyNWk2Wjk2?=
 =?utf-8?B?UHdkemRZY0pUSmtFWkZsbmp5Ymh3ZXNvZHRMVTBoeEN1cnhDTXhBaUFicW5x?=
 =?utf-8?B?OEJ5dkdVbnhjNzdOa3AvQjR4T29JMTRjb1BmcjAxbEpZTTk4WU1BM001dUhU?=
 =?utf-8?B?SzAvRzZLNTZDYVdIenlURC9JKzVKZ3dPcTFuS3VvSTBGWjJnbk1ZZnVxY1BQ?=
 =?utf-8?B?MC9LOG5GNlFmY0cvRTlDakZ2azAwSkg1S2lLUEtnRGp4b0cxYjcvdU8xVDFN?=
 =?utf-8?B?c1JWKzdzZWhsNWxWWWZpMHkrWVNIRStoRkhEcG9ja0g3OWhhd3hON2tIY0xr?=
 =?utf-8?B?UVB1YmdUYUhRTHpEYlZIcFI1TWM3WjhnbkVqVHFhTGtUUWVKY1FBUE9PMm5Z?=
 =?utf-8?B?cHNVaXozWHdYc2FmVVF5L0h4S2lLbzZaSmZFQlNmeHNxQ2t4QnVtS0RZK1JG?=
 =?utf-8?B?OVlxcUdhREpCTy9TK1RpSXVscngwVldLK3U1VW15Q0JuNVVrdk81a1YvQkN0?=
 =?utf-8?B?WWxtdkJUYlhabVBkeXAzTWZjc0dkRzF4OEphWTRTaUY0V3ZwOEdrb2FEQkVR?=
 =?utf-8?B?djdJeUo5aEkwYnF1WWI5M1p2TC83d2VZQ3lhcU15Z0pTTXE0MzR3TndPb3Y4?=
 =?utf-8?B?K01EeXFzT013MlpucDVPMjRsRFlDM0d5M1JmOHJNME1NdlpWblUvZkNza1pK?=
 =?utf-8?B?eWNyNnRYOW5iaU1RSW9aYkhpS0ZzdkdDNjF2QUw2WGFjVWdKUjZhZ09pa0dp?=
 =?utf-8?B?RFMvWE9lTU0yN3RWR1FySnpBbWRnU0lrTEJPbUxKV0UvV1U1WkJNcDgvVGl3?=
 =?utf-8?B?aUZDUm80Sk92aEJ3ZHJXR0xoejkvY0dFanFyQkxjMVBIOFh5c2E5Ny9HN1JN?=
 =?utf-8?B?Qjloend1eDJ1OWU4M0hodFpjQ05TcVFESlVVc09qeFcxaXhSVko5d2Q0Zmtm?=
 =?utf-8?B?dGFydVVHQi9KTFc1Ukdhd3dGSEJOTmdNeFJVVXRWWFcrdWxqaVlpclNaZURh?=
 =?utf-8?B?dml0NHI3ejRrSzNxUjdIRnJSZXZPSnVLZUQ1Sk9pZks4R0FmM1NNbjNPaVQ0?=
 =?utf-8?B?eUNBU3pjSUZVcDhZQkJqSzdBZm82UnZRZVlBQ1JZRVFhdmllRWJaeURkNkdn?=
 =?utf-8?B?T2tRU2QzR0hiSGIwNkdsY2d0bDVDcit3NnlvanFsaTlzRENaaEZtM3FVRVBr?=
 =?utf-8?B?YkZkSlRVYU4xY2JHcDZ0M240N3pTOW04RnUxU3E3QVNZS3lXUDcxWEdjZWox?=
 =?utf-8?B?SzFTalF3L0NJdzN3OFZGVzFyVGUrUVZDMHdMa1ZNZ2FadytsZmZUMHlGdXdT?=
 =?utf-8?B?REErTHI1aStwNkpKS0tPeTUxSitsdDY3QmNqZHdqOTNYNVhRNXhRVlU4RDZI?=
 =?utf-8?B?Ly9WRjBzNmJYbGpBY3hlUENjZXVXME9kS0FVNUsvNXRLR1JZRndWR3dOcmtt?=
 =?utf-8?B?WDAxZjYvaHorMGNiaUVObS9vMTNYZWZ3UTQvbzRZYllaVkpXWXVpY2N3b1Z3?=
 =?utf-8?B?S2ZkZTdtV1paNS85ZTJObTNZQWkrdERKREgyRWJuUjJiWlAxb01VSmxyeXp6?=
 =?utf-8?B?cUs1a3FmZTg5ZGFFZ21VQThHb3orQmpTSUgrSmFLYlZneXFpU1l5NTd2RnY2?=
 =?utf-8?B?SjJCMTErTEhVU3QxekV5T1EwS0VjZ3V4dy83c2JIY040Wnh6a01DUDhOYTg2?=
 =?utf-8?B?MG50dWdyU29DcmF3aUc5L0V2UU9FQ2lxSzFnVXVZL1RpZkFLeEZWYUhmYitP?=
 =?utf-8?B?ek1wZUlZVElybE1mYXJyOWxDMEx4WGpUeitQdStINnVkMlMvdUJNVlZSQnAy?=
 =?utf-8?B?RWxpeURiZnlFbW8vV1JockhiV2lWOVMyTytWTjA5QWxlUnVpazZ2YkNFQU1P?=
 =?utf-8?B?dlkzMXFFK2VXK2J2VFFCbnJmVlYyOTlsOGRScCsyRjNqc0pvSnVwdGZURmli?=
 =?utf-8?B?ZlZZNXM4R0VZNTRmdDlLbnREMUF2Tkw5UExEd2NvRkFtRVZiUGI5c3RyblEr?=
 =?utf-8?B?SXV5YVI0LzdEVUhHM2VyakZPWGZFbXVTSVgrcnlhOC9CTWJBbmxmb3JBUGNa?=
 =?utf-8?Q?ttG84j2zlTZF1y5Dwr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00571478-2676-4f03-7185-08dee8907407
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 08:00:25.4404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iwk17N4ndsHurqfDhvnmWtKSRCyIjlGVWmDhlGPbDmT5zHOfa/RM3k0P/7ZU5SUI4CD9WHpOuzrN/uvr73IK0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6311


On 7/23/2026 2:16 AM, K Prateek Nayak wrote:
> Hello Ashish,
> 
> On 7/23/2026 12:33 PM, Kalra, Ashish wrote:
>> Hello Prateek,
>>
>> On 7/23/2026 12:58 AM, K Prateek Nayak wrote:
>>> Hello Boris,
>>>
>>> On 7/23/2026 10:44 AM, Borislav Petkov wrote:
>>>> On Thu, Jul 23, 2026 at 10:23:56AM +0530, K Prateek Nayak wrote:
>>>>> The offline cores will remain offline since hotplug is disabled. RMPOPT
>>>>> is simply a performance optimization for RMP checks and leaving the
>>>>> offline cores (that will never exit idle) unoptimized should be
>>>>> acceptable.
>>>>
>>>> What happens if you boot with a subset of cores, the boot flow enables RMPOPT
>>>> and then you online the rest?
>>>
>>> RMPOPT happens at __sev_snp_init_locked() for all online cores. Until
>>> then, SnpEn is still 0 and we don't need RMPOPT because RMP checks
>>> haven't been enabled yet.
>>>
>>>>
>>>> Have we tried that?
>>>
>>> That said, Ashish, should snp_rmptable_init() do a
>>> snp_rmpopt_all_physmem() (or something equivalent) when it finds SNP_EN
>>> set in MSR_AMD64_SYSCFG after a kexec?
>>>
>>
>> It already happens, just later in the sequence. On kexec __sev_snp_init_locked() still runs: snp_prepare() returns early
>> (SnpEn set), SNP_INIT re-initializes the firmware context, and then snp_setup_rmpopt() is called.
> 
> But that only happens when the first SNP guest is created right? Until
> then RMP checks are enforced but no confidential guest is running and
> the CPUs are paying price for those checks.

Typically, on RMPOPT-capable platforms SnpEn isn't inherited across kexec. 

As i mentioned earlier (on v9 thread), kexec with SNP active currently requires
a full SNP shutdown before the kexec. SNP_SHUTDOWN_EX (and the IOMMU SNP shutdown it performs)
fail if there are any active SNP guests or assigned ASIDs, so a working kexec has to terminate
all SNP guests and run a full shutdown first (via systemctl kexec). 

Now, on any platform that supports the x86 SNP shutdown, that issues SNP_SHUTDOWN_EX with x86_snp_shutdown=1, 
the firmware clears SnpEn before the kexec. The kexec kernel boots with SnpEn clear, exactly like a normal boot. (The
only case SnpEn survives kexec is the legacy shutdown path, and those platforms don't support RMPOPT anyway.)

Thanks,
Ashish

> 
>> On the fresh kexec kernel, rmpopt_wq is NULL, so snp_setup_rmpopt() does the full setup — programs the per-CPU RMPOPT_BASE MSRs and
>> queues the initial all-physmem optimization pass. So RMPOPT is re-applied on kexec through the normal path.
>>
>> Doing it in snp_rmptable_init() would be too early: the per-CPU RMPOPT_BASE MSRs aren't programmed until
>> snp_setup_rmpopt(), so a pass there would have no base configured.
> 
> Ack! Which is why I mentioned something equivalent ;-)
> 
