Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010054.outbound.protection.outlook.com [52.101.46.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51A71ADC7E;
	Tue, 28 Apr 2026 16:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777393643; cv=fail; b=aOkkYFoprlPNzqZfPtFlW3PN4ACbzokZ128yAZlRpjfjYyCuf1kARbuGV2o19fVIte9uPuD0RE4yFOTrWpoByj9ub2kVaozE0lZv5x/r7T59XG01zudpIevrUjGh4QTaz8cGhP4mU3oFNxACa7v15X+mvZF642kEjt6AOJpG5mY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777393643; c=relaxed/simple;
	bh=dW0qoqWM6MDEl2RaZKgSOCb/tHoUBX16OPiVDpJdwXI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=STFO00dUn8Js7oFkCwezli7tmr3KfP8c0yWChqUFJZPdAroggYK0rtZORTd1ZVV9qCXZ1NuHPnq7Ym5hBalLMXT/Qve+JVBDGRtJ05eZkRod6FAL/hxMmzIiPZNE85LbdObyoS1WCEArsylsDxzHryq66kAix7Zlw3oL3WpCr/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=j3Gfieh2; arc=fail smtp.client-ip=52.101.46.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="j3Gfieh2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OreXSVKPRxdeQfdMMkKD3GU/BhpUaVMbwGKiJrlfn3gc4dMcuQnYjqAJxPbe+dTfRz4JkSyynA0fT3YK4WIsQda/T5ziicHfituDCKc88GYZeYgD37Maf4nKovlg2pkcVsZcTKLncNTbgavITlPpwmOjGZYu+ynTvETs2+KGbgm6O/4B8CWsqH0eR6dIePLeifXX8oxkZifszA00pCxZm+6ZkgfM3t+zRiDd6+Qv4AFyppp6YA0gVWklLH/+0Y0IlUydEuzkft0mEZBLSGSvoyFQVOmgnET6O4zIuI5SNFEWutmtPD2lUetke2y1/BBqKNZ+WnXi6UH8fZU4Rq4HIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lr1+oQdCRNL7lhJ52dAz8H0bhkxdHBMQMiHKId5uUH8=;
 b=iE79EYI3IiFs3Wy0NTx5JpfWNfyBGbf6Yk80ZHxojpJQ+hEL8t2j3MOlF4wwOVTjBImS18sY05Q+ATAyGpYdTpXL3X5ZlqxYQmORfzgEVaJDj49kKXGkFtVxwLEcHDoXFS6Gqy4hJUfklE1ZOTJyywVm4PnANbWQ1TRXTZeqag3XLVI3zZoW+5ltHv5EtlFNs9arQPK4TCSzhFepTc7da/xVVsO3/nfvbE+JpUDD7g0rDPLZ1hyeCWfviK0zENKTEUqhTSgW5AVZIkUwVFFJ4P+Tb3KyNbDnycDEKgydNQJsvrTRAjidjyBA1CyJfDNW+v337CiUiQkG5iIbwQJ0Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lr1+oQdCRNL7lhJ52dAz8H0bhkxdHBMQMiHKId5uUH8=;
 b=j3Gfieh26gICJNDmsNJX+chIOZio+rmukIfLWQ2P3uv2lgzDUkepAxH8/p5UEODeQWIySsJ3Va3S9hevrbCTAoZeS4i3kuvZDF5b/73Tc6ZwQ+vIN53bZt7Am3CRuh+kx4s1+HoBwRS6lc/s6yxQtG26LN2qgoc12eitozfXALY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH2PR12MB4230.namprd12.prod.outlook.com (2603:10b6:610:aa::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.17; Tue, 28 Apr
 2026 16:27:13 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9870.013; Tue, 28 Apr 2026
 16:27:13 +0000
Message-ID: <20f94bed-2843-44ab-877c-3e68bd4314f8@amd.com>
Date: Tue, 28 Apr 2026 11:27:09 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] KVM: SEV: Add the kvm-amd.rapl_disable module
 parameter
To: Sean Christopherson <seanjc@google.com>, Tycho Andersen <tycho@kernel.org>
Cc: Ashish Kalra <ashish.kalra@amd.com>, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
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
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <afDYCpbeT0HsXTMF@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH3P220CA0023.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:1e8::29) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH2PR12MB4230:EE_
X-MS-Office365-Filtering-Correlation-Id: b8bebb70-fd5f-4e66-c28d-08dea54300e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	Kbx5dUmLfKQLSjvkDCUQf69cRuQBFpE/fx0EYdMp7iurWdyzSee/3cmSO1ZleiyDeNssSLAgjKXzttcRemxyGBbHPskHfP45Ex4vjUs4RHhW1RGAg596MnOCK0e60Kx9zk1xh3wSyTS5qZN5EGlmgEl0bk6s11uyc8xoTAkevXJYN2o25spE+0jyCXhHgpNWhrb68gwQZ10vX6fr53RvI9yaAAIq/jP6v6cz9VFtVtrQHPvWTjD/sM6iHroYMr5PcAZVqwmI98UEq0Szb6GJhqNx6vE12CNoFBPUnUTtpngJT1BK6egH9zUWFZTt1jFieQ7Bmi/1mT8GjywOBHsZd5ltrOj4WWamvAPRSSz9eyGZjMnv7+os568CL0HROLh04Rah5logpM1jyaeGrYna8xxI173UfXiwTxutNYggFkJP1+nxoVqM0iNSIXN6LaUgqIA6dmYspfpVPqhSW1JwLTJ+SkRvsodi1gPAiO1TxLyfpwmyvKTr1hlCO3qRIGTE+OU6y8pLJfNOs0X6FIaZT5cMY+W0agR+3N2hRxRNPajKNgYhvyAsgOoLFleRvrWoXegiVQMYP3gx3ud6fpBpq3uw2iL53ZXdyAyU9Zw3RMifblXLsiy5gSrlePNQJ8MpvZ/7sFloMvXSNdhOw+QKtiAxCqjyjDRwhzXKz1ilo2ZIaR0LFGeBeKITGIHQgCPujk81ZRQ+OkdEF8F5I9E1pNSHjXWKJhsrTq9IhkMhUkQj1/tQF5zrqVfWwXGaZVSM
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SXNBcUN3aGl4RGRqU2s5NGpUY3dZNS9oYkxGNHBsclcwb1pkakRxTlEvWk5B?=
 =?utf-8?B?QWw3OEFGR1RtWE5UNHdWanVXNkEzb1RzYnUxWUlxRlk3WkpIM28rS1RGSUpa?=
 =?utf-8?B?S3RhNEtSdXZBNXo3SXMyeXhPbHRqaGI5bHF0WkNpT2laNDk5d3krSzV4b1dl?=
 =?utf-8?B?OXJmekVmRkVKZFR5aUVQZWRBUTFSN2R6ZC9BbjF5ak1hTTNVL3BBaVRya3RT?=
 =?utf-8?B?TjB1eGF6eGxJeWVZZFljbm04d2lvdFdDbHV2Z3BUKys3ak03Z0JWNTQzSzFr?=
 =?utf-8?B?QUdaQjFMd3piK3NCUitOZWVYUkpjQW83OFJIMURvQkk2WVNIZmlGK2g4MDIw?=
 =?utf-8?B?Rk42WTNWb0FOOTI5UlNjR3R5VVVtbnRnS0J1WlRzWnhKUGVQSExmNTgxVzRC?=
 =?utf-8?B?WkF5TnYrdk93SWlIdzlrOUNrWkIyd1AvR21CTFVad2RCT3pEUlJRSktUUDh1?=
 =?utf-8?B?QkFoZXRWd3NCZkRXVE1DM1BOMEZRdEpWNUNPSDBDYmlWV0dsVWhkK0VBMWRC?=
 =?utf-8?B?dmFxWFRtT0NxVjlFTWQ1NHcvUU02VnZ2VlFEcWgwQW9VRk9HYlVtK0RzbVVD?=
 =?utf-8?B?Nmxvd2RFQWRCeDUxZWY2OGRkSjBoWmJLRzEweUhVOElhcW5RL012Wk5MM2Z5?=
 =?utf-8?B?VHEvTjNBYVRwZWl1Vnc2RkZzUHlHcjcrMmdjR2Uva3lxMFRMMGlaaXhtZHY5?=
 =?utf-8?B?OFR2azN3akJnMFlZYzJCL2NGZkhaR0dScldNUDRxNHpMZFJjZW9XL0E0SVE0?=
 =?utf-8?B?dExIdEQxSC93WnRKMDhWeTRvcGJnYmp5a05YdmV5WnRIWnR0L21qdkowWnVi?=
 =?utf-8?B?a0ZzbndWdnJKeng4SjZSMWx0dSt0MlVrZmFIempRMmY3RDU3QlRKVmZwVlpu?=
 =?utf-8?B?LzJ5emh4L0d5WEt4c3dJUDJaVFdETXFYYTdGYVlhQ2VjTmtBdktFRXJrYUZs?=
 =?utf-8?B?SDhRMTI4TFpEbW42RlpzN0tJdFdjSjVvNmI2Vi9PYVVOVEowcHM1WlZ3MU85?=
 =?utf-8?B?ZlltdGNBV0N6SEpKbzZ4Qm9zMjJ2YW9rVlhjL0UzQUg1Zlp2cGI1VGlYTENE?=
 =?utf-8?B?V3pGYXA5bldUeE1TOFhycUpwVUY5NVZFRWtUb3NXTndkRXlOejE1dTlhWVgy?=
 =?utf-8?B?VFdTY0pROEJMK01kczlSOU04SU4zMFRXa0x1MlNZbXhvQjgvcWVrVitPOTIw?=
 =?utf-8?B?YUtPNjc2aTh0d1JwbkZGcDVIS0tnNHg3ZHczeGxFMXFtcjhoNnlzZFk4VmZN?=
 =?utf-8?B?RTBvdnJVQ3JhTmMrRUpvUFFzYjNqald1bEZaWlhRaWpEQjh5VCs2MElpb1VG?=
 =?utf-8?B?cWpNRitIY2dNTzluT1RnMUl5eFpGZjVsNlYrQ29SVTdnbFVXSnlET2Uzczcy?=
 =?utf-8?B?Wm9VaGs5WGtRNXd1Y2tBeld4czZScmgzc2MreUZpQTk5dEc1bFNVNFBsOTR1?=
 =?utf-8?B?OGFOK0ZURGJBVklVN05DeXlDaloreWI2YWo0QzdRUDhTei8vQ0dxRUk5UVRM?=
 =?utf-8?B?MWl1cDZuckpMOUlYTEtmUDVRZEIwOTZCcGFKQnVldys5cm91Ti8xekZSWnlj?=
 =?utf-8?B?Sm80S3hlTTdhVHhGQmlVRUhTMlQwMUNlcmNBN1BwYVVlR09zbTM3eGxsQ3JV?=
 =?utf-8?B?Y09rMDlkb0N5bnozK1ZvQmtHanBRTFcwNmxWdXJMWnRFNThES3p2K3FYSVJk?=
 =?utf-8?B?ODEzT0MvMEd3K0ZkSlBLaDBHOTBJSDkxSnFWVHVwdk9XdWZQajh2YVhDOHBK?=
 =?utf-8?B?NFdNR3NIWURHM09wQTAya0cwY2FMRFJySW1BYWpIa1VBemk4RlowekQ3Z09Y?=
 =?utf-8?B?YzhuMnhTWjZmdVBGQVJHWmRkRmN0VExodmc1bTVDZWxicnVhNzFibUFSOVRM?=
 =?utf-8?B?VTNxc1dBMUJVMlJZYzQzenllYUgyY1JLWFd6Z0M4bjBYYXhoQW8vRXJzVHZ0?=
 =?utf-8?B?ZnlPQnVDck12TlA2dFdwSmczTmF6aW1EN3pwOWhvT3FmdWxKay8zYnFab3JI?=
 =?utf-8?B?MThCMzZMWDBxUGFVU3VGdXMxNGpMZTN0WjMyTUFKWWpxZFRxWlQrNlBpZGsx?=
 =?utf-8?B?MGE4MjBQbFJYU08xK2c1T2RhWlR5RW9QVmxXVTBpTGU1VmsxQVFiNElkS1NI?=
 =?utf-8?B?RW5PSEpJYnBhQkt5UnJVZ1piL3A3aXNpOWp3bjhiMWYyTFdFMWJUQ1J4M3hk?=
 =?utf-8?B?OHZ1bDNOenNaS3pNRDA2Mit3OUZSVWY5cmRzTDJpd3pmNURrMStoOGxtL2JM?=
 =?utf-8?B?MWZhZkhBRVJKOXdGUGszWmpEMElhTy9sdis1bVQyL2dRRHErTEVXNDg3a0I5?=
 =?utf-8?Q?0V8qXElDqA1Mhx1vfE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8bebb70-fd5f-4e66-c28d-08dea54300e2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 16:27:13.1276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D5JZ8f7gXqE7vml8nFjxdq9ZILs1E41v/7LYbBYx7t2O1CTNECk/l6RB0TAcXUIPoL3hCLqAz3cMKDQ0q1SJCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4230

On 4/28/26 10:53, Sean Christopherson wrote:
> On Tue, Apr 28, 2026, Tycho Andersen wrote:
>> On Mon, Apr 27, 2026 at 02:20:10PM -0700, Sean Christopherson wrote:
>>> On Mon, Apr 27, 2026, Tycho Andersen wrote:
>>>> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
>>>>
>>>> Add a user-visible way to set the RAPL_DIS bit for SNP init.
>>>>
>>>> Since setting RAPL_DIS affects the whole system, put the module parameter
>>>> in kvm_amd instead of in the CCP driver to hopefully make it more obvious
>>>> to admins.
>>>>
>>>> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
>>>> ---
>>>>  Documentation/admin-guide/kernel-parameters.txt | 5 +++++
>>>>  arch/x86/kvm/svm/sev.c                          | 8 ++++++++
>>>>  2 files changed, 13 insertions(+)
>>>>
>>>> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
>>>> index 4d0f545fb3ec..2b50eed8664c 100644
>>>> --- a/Documentation/admin-guide/kernel-parameters.txt
>>>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>>>> @@ -3207,6 +3207,11 @@ Kernel parameters
>>>>  			max_snp_asid == min_sev_asid-1, will effectively make
>>>>  			SEV-ES unusable.
>>>>  
>>>> +	kvm-amd.rapl_disable=	[KVM,AMD] Whether to disable RAPL
>>>> +			(Running Average Power Limit) when initializing the SNP
>>>> +			firmware. This disables the counters for the entire system until an
>>>> +			SNP shutdown command is issued.
>>>
>>> I'm pretty sure I said this earlier: KVM absolutely should not be able to disable
>>> RAPL for the entire system.  That needs to be a power management thing.
>>
>> You definitely noted "not CCP", I don't think I quite understood what
>> that meant though:
>> https://lore.kernel.org/all/aZ86BZWi-GLiHvmt@tycho.pizza/
>>
>> I'm a little worried that putting it in power management will generate
>> some weird dependencies, or weakref symbols that can't change things
>> if they are loaded independently of kvm_amd or something. But let me
>> see what I can come up with.
> 
> Ugh, and it's not even powerman per se, it's actually a module in perf.  Oof.
> 
> I 100% agree it'll be tricky, but I also stand by comments that neither the CCP
> driver or KVM should be allowed to silently pull the rug out from under the RAPL
> module.

Maybe something that can be added to the current sev= kernel command line
parameter, e.g. sev=norapl, or such? Maybe even with a kernel config
option for a default value? On SNP_SHUTDOWN it will be re-enabled if it
was disabled.

> 
>>> KVM then needs to communicate (and enforce?) the policy to
>>> userspace.
>>
>> KVM doesn't need to enforce anything, the SEV firmware will generate a
>> launch error for policy violation if it's not supported.
>>
>> For communicating to userspace if it's not a kvm module parameter, one
>> option is to mask it off in sev_get_snp_supported_policy() if it was

Did you mean sev_get_snp_policy_bits() or were you referring to the KVM
ioctl() for retrieving them?

>> initialized without the support. Then it'll be visible via
>> KVM_X86_SNP_POLICY_BITS.
> 
> Ya, this is what I was envisioning.

It's still a valid policy bit (if supported by the platform), so I don't
think masking it off is appropriate.

Thanks,
Tom




