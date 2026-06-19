Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012020.outbound.protection.outlook.com [40.107.209.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7507036212C;
	Fri, 19 Jun 2026 21:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781904682; cv=fail; b=kGnAArsNn0AjXO/FoKR2IDUWDVmtG29oTJg6ATMZY7x1WywRFrLh9ull+ZLb215OYdXdvAtqibVXr2FQu582bO/tcnDa0rBxZ6ubOatgmMybQS4BJ1jZksgwQ7CTSUQcL4RCwwh+E9SqcGWiSD0DfpqGsL5MoNbvttAZnt3a0W8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781904682; c=relaxed/simple;
	bh=j+avIa3434lUq0mLX6te+WfAQDjvbJJBTAmz2ZYEK+k=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eoYf9rXK8IBd5x6R+44DokCjXmn1jSeCsVplxbD5N03asFhFOBXW73A/6fIM3VhoVg+AlPMXTQ0enn/hv28PzKs+z/ULwsP4qRfbOE5RqDe7gT8WGmNirk5uN0w1MwlqbTTW9Xop6lTRRswY4r0n0PBYh6h2sHFYdROMZfawQaU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MbW8bWl7; arc=fail smtp.client-ip=40.107.209.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MbW8bWl7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qZpPiwJGppajg4b3+H/OBICQ4/qNyrLSGVmuOQs6vBuGplNPFkQgY+ZtoMHq+Q83+xFMvnGvuFGcEiXI9v3J6xZgEV6AhlhHxSh6s1qpQ5/qwyAnu5ny8YBqmv+9+fS2JShmqQLKbjqbnUrD6Uo5Rz9Cz4l6/k+KEbEOaZ9+jKKzUkAW8kVyH+5ThwWxM958lVrXVomYeOhDgodzQrJjqpYI0c2IoqUcmx5PSedN0rVDn6gLrN1+yll6qUTNTLL6JQIV92EScupMbEN94v/hkQ3aqeYQwR5J/2ROxRgE6JWOkrKwdfsfAaRWJNh7yEW9JFnhp/MOLtVU8b7vrdFvHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YUQLdVRmOTGJqtexeETY25U1LU9JchvD4PflIIYZ9hQ=;
 b=sSgc8ItLCATcWgorxOqKyRtvIdFcIknXh42zkyuP1dWL0JM0HOqxOS7DJIAWjOEL7BmOEECgf9kVzQ+uHepixEK9hEgXfvyAOq0kAubH+jm/DazMQVu359CoxuV1ubhOP311zqbrRBt06PIi2zpPTsijGEkIAu4/0fNgTRK9uC29pYOgYldFqUV3cM5z86kkb6XoiFpFljTSsLp+swaTR/OSzIoTVr0mdgdM5qK8i6Zeu/8nAZzyZa+K2XhuJylaUtzEkw0l2kb0919roNI6m8T5qrqwlDBrCeIyiENPSRAaxvmf0r35Cm5TElfZd/japnzczM5imu/P1JiHSSJYGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YUQLdVRmOTGJqtexeETY25U1LU9JchvD4PflIIYZ9hQ=;
 b=MbW8bWl74NFnPwNOPsrexIy7r3sxKSrnGuj84y6k2LzDPNQ16AgR+ACp6DiZ8r/eIGZXbL/azgjZvzGQGKzbUbnATNiAy9ZoZAwZzcVE0PzyTUIGVhj5F2QUkjKvDHqTI6c1wAQyJ3A3ZFQ86xVaoxwGzmZGYeR3/KElxBJgAQA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by DS7PR12MB6192.namprd12.prod.outlook.com (2603:10b6:8:97::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.139.11; Fri, 19 Jun 2026 21:31:17 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356%5]) with mapi id 15.21.0139.009; Fri, 19 Jun 2026
 21:31:17 +0000
Message-ID: <03201e6b-a9ff-44d7-9a20-219066c10611@amd.com>
Date: Fri, 19 Jun 2026 16:31:12 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/7] crypto/ccp: Disable CPU hotplug while SNP is
 active
From: "Kalra, Ashish" <ashish.kalra@amd.com>
To: Dave Hansen <dave.hansen@intel.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
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
Content-Language: en-US
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <bd2dc2e0-e975-40a9-8e0a-4403db858316@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0234.namprd03.prod.outlook.com
 (2603:10b6:610:e7::29) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|DS7PR12MB6192:EE_
X-MS-Office365-Filtering-Correlation-Id: 117640dd-7505-4d34-7827-08dece4a18c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|22082099003|18002099003|921020|56012099006|11063799006|5023799004|4143699003;
X-Microsoft-Antispam-Message-Info:
	HicwE/frJ26EnaYj9mwQKi4JjQsO3swyK3ql/HUVGfRIPnYXLwLCsbH8yavdmq7AZA6E2g/hyJeB+I58yL8HCiQ7UaArRdq6c+aWizMPjJGNak9vThOaQSVUJOiMNabr6zxk02esazJsTP0ZcwYyvb8bsyRKYgQFJJJBAQk8aFK6Q5C2JqJ7bPv7qZxOihK+vEJc3QonHk7oD+bZgL1pf12za4MX6FhNStig1mWeYxUbM1NMcL8ZfvXtZBPA4SfApl3rQkp9J69oHoxRcsSO8PnjIdiltgTzRc8JtZ5LCOx5qhJeLEEoRy19zEDdgbnE5DJzrJeyV3pROuIebPHiZJDcw/pIiv9a+YcRztaz8bHDluhNE4UW6KCtcRkRuzqy5ZY0KWMLzHhdifwy+IOR8n8ZYkJEJLDJqUfZinPQiXe4ybdmrNUsXhNTVVLFDD+wJfuEX8MJsvocCMrx/8aoQdyMyXs2iA5FfFGkEkmUiJdcGv//lUA24KVposCWXne07OU8CZDoH8ZncyU8SrsGZqRpyDVxPqVBxym8LyvXJpdM+c8INkN2OHqvVcVz3Ady8GJQnAZtcAwp03iegtVb8Zmpm+t7TY70sndiPw3pBV9nfVh3JxvdLyybQGPqVhsJvhYrMgZE3tUO+Lh/KNkEIi3LnUWr+VPn+wBkibjDdx+0y07T+Uz5n9uQEJxzzYv1TWMBulLCwsuNJRoyEgB36w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(22082099003)(18002099003)(921020)(56012099006)(11063799006)(5023799004)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VTQ2aHJrclowbXVaVWJNaHJZdnQvZWVLSmJoTjkwVnNjMk9RQ3VGNGlGKzRE?=
 =?utf-8?B?NXJrNDVTcGZMWllMTE9qUjEvTmkzQ3hMa3c0Qm9OeGpwVXJ2cjhXdTgrbGRi?=
 =?utf-8?B?eXVLdXQxZktoalRmeVU3U1NpZUZoRFlOSTA3YmMxbWxsVTk3ckNMUWtVV3Rj?=
 =?utf-8?B?YWx3dkNDVjVZT2FRUXhtNGpDejVXaFpoWlg0V0xnUEw4UytLN0tsMXZXcjFN?=
 =?utf-8?B?KzM1YXBwaUJ6Z3dLTkN2Um11Z2ZicVdkUXc0SFQwcFdMazRhMmxXOW1sWjZY?=
 =?utf-8?B?L0FnU0kwNjRwbkY5WmlCejJldklEU0gyMmsvT2l5RlErQTRFTjZDakc2cnpX?=
 =?utf-8?B?VnhjRHFRV3gvalUwaVRqSWVxYWxmeTdTWHdUczRLNGVnUDZURzFqT1JXRlFl?=
 =?utf-8?B?K2NGd3FmTHdQeWRYV1NKL2o4YmozbVpKMEVrK2Z0blhmZUlUSjF1OEM0dyti?=
 =?utf-8?B?UEdaK0lXN05qS0xoNzgzVTVNODdzbDFKdURaZGhxdTJjUWpNaGRIK3BtYUJv?=
 =?utf-8?B?OHFOQkZucEZ0dHQ1Vkcxc09kdGlmdVFCQVcycEFUdmxWU2VqT0Z1V3phbGJm?=
 =?utf-8?B?Y1duMnR0Z1BRODJtT3k4Zjdwa0NZVjdTR3AzKzB3V2xNU2p4VlNEZDVWUnhI?=
 =?utf-8?B?WFhLN1JPS0QrYzRnMk1Udm1tMXFGbXd3Uy9heTV3KzNKS0I4YkZtOGVQenlF?=
 =?utf-8?B?K2x5NWhFaWlkenhSNHJscDRNVEpHc1NGNTI2bXExZ3AzZW9tbnM1T3NFVnRj?=
 =?utf-8?B?UUY3Lzc3V0g0T1hBb2lscThBa25XUVVWQ3RUR2tOdVo3R1JJNjBNbmphWG9G?=
 =?utf-8?B?b3Z3eGVkUFVTQmRSYzFPV2pUWjhxZG1jRzdJd2dTV0NiMTY3a3IvUkRVOXBw?=
 =?utf-8?B?NXgySDhsZ3RVQlJGcCtHQjhpOExSWmlRMEppdEh6bnhWQnRlS28zcXBFSFg5?=
 =?utf-8?B?VWg0eGxBVnh5cysyYmNBV2ZUMUNwb3VVeWFLckRTWm5YekQrb29Nb1IrajhQ?=
 =?utf-8?B?UlA3UldtanBsaGQ3OUFVZUdadXJDQXI0YU1qdGpOKzZTclQweG1BbGdrcE5y?=
 =?utf-8?B?bzFCeThTeng4WjZVYm9BWGViVnVHenQ0a2NCRVlqV2pld1craUlWYm9EaEh3?=
 =?utf-8?B?R3lXR2QxRVAxOFNueVpuVi9RS1VnNThYeGFGTVpwcEs2b1NiWUVnVWVyRjli?=
 =?utf-8?B?TFVOSHg0MEtEVlRKQzBlMG5SR2ZDaGF5YVhLQm9Ld1FST2V2ZGF0VkRqTk1l?=
 =?utf-8?B?Q0JVcTFvUi82SnJlczBEOU01OXFEckJSK09hN3pEeGVRd1JHNU9kREpiMkFV?=
 =?utf-8?B?L1dISFpqZVFHZWVudHpxMTlDcmRCTTYxc1lwN0lMeFduOUZmYVhnR0Z1QU9p?=
 =?utf-8?B?RlhheHlPd0tyZStxeDVhSUdaWmIxYk5Ob25taUVFT0tnOFZxN1Y5QVMyL3BV?=
 =?utf-8?B?STFhVktTaGhteFlPTTgrd2RDbWpBQkgyTDNNYmxvbE5FQStncWFWVWd1VDNw?=
 =?utf-8?B?UkdwNWJnN3c0Tll6NlhKVzhESVI2OTVTSWcyRTIvTVpuL1dOQTdjdHE2VjJ4?=
 =?utf-8?B?WEpmNzJCZSs1NThFL0tXa3hlZ2lZMGFISG9KbXhLRG9mVTNpTVYza3MzY0hS?=
 =?utf-8?B?bjF1aitacUE1RkpwdGZseTNod29CTWQyUkhXNE5TVDRtYmtyendHRFVwZEZ5?=
 =?utf-8?B?WEI3ZU9mdlBIVDZFVzRoK0V5R0JUMFdvcW8xM0hBZmo2UHp2YmVoT2V2eEcy?=
 =?utf-8?B?Nkw2aWlrbkZjZzdqVzZCMzNCelhZYStmaldyVUlBUGJsK3lZbmppZ1BQK1FR?=
 =?utf-8?B?WU50YVMvUDNKMW9KUWZMUFFZclBXZkoycmdQUjJKT1I2M0k1bVppczFNeEFG?=
 =?utf-8?B?bUF1cFpVcHV0ejFXLzBkL1QwaGtOcy9QdFlGLzBYcWJWWHhReTBUNGQ1SDlo?=
 =?utf-8?B?VVQ1T0l5N1JDejg0dUFrYmZPb1hXZnB6bGUrQUhkUWdFNVhENDNLKysrcm45?=
 =?utf-8?B?ZWlmSzRwQ3JQbW85Zkx4L3FnK1VRLzFBbjh0cXlnbGhpbXFlQlQ0d0k2SjBq?=
 =?utf-8?B?TFlIT1RnWWlXTXFYKzRQUDVKT1VPU29kdng4YjlpbnpmYmpzdUkweWJ5R2xT?=
 =?utf-8?B?dVdQanByS3Q5eXpoY2tlMjYyMGFCd2FqTFlUZUZJSVR3SlNlYnBReDV6cXh3?=
 =?utf-8?B?aCtxVGF4b0Y5WnVLSU1jcmQ2bzA4TnhLVWMrcElIWmlhREVmUWI3c0NoQ045?=
 =?utf-8?B?TklGLy9vS0Rub0xBbW5XakJhY3JxR1FLdnFNMlEzdE50emtqN3JQQlVuYjd1?=
 =?utf-8?Q?sT9DciF3E+EAELEaoc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 117640dd-7505-4d34-7827-08dece4a18c9
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2026 21:31:17.4811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lFmrXVooXm9nqEbNyNWuVmjO8nlBS+UIraVaDVt6lpw7KBpBRDn0RAT1W9+quF57M8KfCZARF5ErX27ktnT1lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6192


On 6/19/2026 3:51 PM, Kalra, Ashish wrote:
> 
> On 6/18/2026 4:35 PM, Dave Hansen wrote:
>> On 6/15/26 12:49, Ashish Kalra wrote:
>>> +	/*
>>> +	 * Disable CPU hotplug while SNP is active.  Guard against stacking
>>> +	 * the disable count: the legacy SNP_SHUTDOWN_EX path clears
>>> +	 * snp_initialized without re-enabling hotplug, so this can run
>>> +	 * again while hotplug is already disabled.
>>> +	 */
>>> +	if (!snp_cpu_hotplug_disabled) {
>>> +		cpu_hotplug_disable();
>>> +		snp_cpu_hotplug_disabled = true;
>>> +	}
>>
>> This seems like a hack, guys.
>>
>> cpu_hotplug_disable() seems like more of a temporary lock than enforcing
>> basically permanent system state.
>>
>> This seems like it would be better implemented by registering a CPU
>> hotplug callback and then refusing to offline if sev->snp_initialized is
>> set.
>>
>> snp_setup_rmpopt() can be run any time, right? It doesn't need to be
>> after sev->snp_initialized=1.
> 
> Yes, snp_setup_rmpopt() doesn't depend on snp_initialized. Programming RMPOPT_BASE only needs
> the CPU online and the system rmpopt_capable.

After feedback from Tom, adding here that RMPOPT_BASE (RMPOPT_EN) can only be set if 
SNP and SegmentedRMP are enabled. 

Therefore, we can only call snp_setup_rmpopt() after snp_prepare() has enabled SNP in
__sev_snp_init_locked() (CCP module).

Additionally, as SNP_INIT, clears the RMPOPT table contents to 0, therefore we call it
after SNP_INIT_EX.
 
Thanks,
Ashish
 
> 
> Based on Dave's feedback, i am going to drop this cpu_hotplug_disable()/cpu_hotplug_enable()
> and instead implementing and registering the CPU hotplug callback and then refusing to go offline
> if SNP is enabled, unless anyone else here has a different thought/suggestion.
> 
> Thanks,
> Ashish
