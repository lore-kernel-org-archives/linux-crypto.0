Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010035.outbound.protection.outlook.com [40.93.198.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452E532BF5D;
	Thu, 28 May 2026 19:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998154; cv=fail; b=vEDX8AGE+mGv5gDmW+6D4rbCmYjUPgrFZzXdjIJKrxw2m+5k3bBSV6lQK3xGEMIuKBoFUcpP4MOR+kYIsZ454BjE9NFvwtyXAPq1vkziYSgyUoIHlX6FNwv3FeWQnHQ1LAywbCDccQGFJbBVFIFJvvzfqH3cBFX8+Yp7IdmRSQs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998154; c=relaxed/simple;
	bh=5smqwzYg4iB+UPDaZ2S21C/x5++xItNUEeii3yA6svQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PbbI7cl15P8VZLQNsqqoRZxaIronuNvXaogTIs7sU8DfkYMXJoNf2kLjVg88jE7yc9eq5fNQUSwiFvf/tbzQclgCZBi4SuAI+yu380CGP+jIouuhehNcTsLdKBm5c+0KS6CypeLS3r95uA6IC7XhelUCi5xma4caI4rxNCf3Lp0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=B9w1p06Q; arc=fail smtp.client-ip=40.93.198.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="B9w1p06Q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dBScqGbIJO6aqy1+jaZRdam2ZY4tI1f6cyR35xEk8bymIuswekT5c/XN13seedPXKGUBhSB3Fk9fX7j3vwCB9qR+WHCl70IjPeGi+zFdlz00nHnoH2ze8UYqeFYmPyQ/xJuhJCIJjL0iUzV73MXP2XevVOVMzqsJDVko6kYEyZENWBEb5RlR537fmNM1cD+HZ+vkhmUM96mxiOg5DPL3Y2iFY6Lqeo7/kyt5OYNsBlx9T26JHRDEcMGx8KiUxo9Tyc5i85zih2UO+cEmMAzGl75BAL610KiEefcU4kIgNeD0a6TpoKlzSmeZXYrKtwbFSwR0Wqn+EX7tz/3JX1bAtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IhOuKVLVID+bqAYR65aTbFqh8HSILzIL3gMoygKLL0I=;
 b=BD2rCCIeCTW968sQ90RuqbYpoG0134l5R1kBd8bXwA7GBXksUN9iSWjvcbIlwU3slU+J5R+irbCC4Oc+2PnpKgbJbUBGzwvxf4tp8BTfcttCXOQbEVQ5mORRkeCwATbpEn4Ob63sCkiQ8R0anJMu0w2hd6ZCA8SBJ6Ct/j6M+MglDFOnT3me9Q1vnp9zVfhCd7cjXrjsppOH2D43zuv6nrKGGmHuPzQxQ3UxvtBDD9zk+imCJbQuZQMcc5dOG+JJ08u9l4OsJsXl1dhwVZJuSdckiC4OfZiCx9Q8yc7Hesk8tXTlvK2WVxNJjSNMSq7cgF48P+A81CMaRDXxW9yQRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IhOuKVLVID+bqAYR65aTbFqh8HSILzIL3gMoygKLL0I=;
 b=B9w1p06QI7c2ReULc9T4LjyO3+5O8VCbqm8/FEnqVJ4s0Xltwh/tLnkmD6Jo/Ymi0ky9LCnlAGjB/uxiv252pjV7dhLhm8gcAgwkGcfzZYbM/8eijUm1Xl9eQdivT9YxO1aYUM25NfHe+M7AX+pMicYzIpKv2auPDNSy2rib5Lo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by PH8PR12MB7256.namprd12.prod.outlook.com (2603:10b6:510:223::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.13; Thu, 28 May
 2026 19:55:48 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.21.0071.011; Thu, 28 May 2026
 19:55:48 +0000
Message-ID: <3334a64a-9a5e-4ad5-94f3-01fef788df2e@amd.com>
Date: Thu, 28 May 2026 14:55:44 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/7] x86/msr: add wrmsrq_on_cpus helper
To: Dave Hansen <dave.hansen@intel.com>, Borislav Petkov <bp@alien8.de>
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
References: <cover.1779133590.git.ashish.kalra@amd.com>
 <c9fe5c2fef063f5006cc9bfa03eec824ac015db7.1779133590.git.ashish.kalra@amd.com>
 <20260527210603.GCahdcu8zvVjfKfGEL@fat_crate.local>
 <eea0497f-6930-43e3-947d-dae139e657ad@intel.com>
 <20260528004332.GDahePtGqVp2boiEJL@fat_crate.local>
 <2d164e19-5cc6-47ca-9150-f4d432dd10c4@amd.com>
 <c40dcb8c-5706-4c0f-ac85-c22957b9e192@intel.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <c40dcb8c-5706-4c0f-ac85-c22957b9e192@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0334.namprd03.prod.outlook.com
 (2603:10b6:610:11a::25) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|PH8PR12MB7256:EE_
X-MS-Office365-Filtering-Correlation-Id: 2debc339-3106-4104-b9f2-08debcf31cff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|18002099003|22082099003|4143699003|3023799007|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	ogy4UwgawSVT/IUtRHpWKjAS/2BJ3eY6pZ6f7hcO0QcVE00Com/rOdtZyL4C4CqNqDkEbrxfbkocJtBcdpQ6qBqr+edhw+EDjRQm+7yx+kKE+HXUgI+7WlVpbycPOfe9hnV/Rh9T3T49mD4g6lqn6SydB5s3udfrN+SjkkEJtLdRTWyA9wgBIOTleAIFMOeNqK4UydGW8AYBzeLg/j34ZabCCK+kcZXpyqYKCjER2gfC6Yq6Er5yhV1DjcvRSDbUjSzfZhObhTHGLvskyj96M0uUo0TA6eYRIBjW36hKmIIxTlxVrW9JA3WopnxKDNWags20enfcDrWNXGOnOLWEvcnI9oergRot0U5GX0pbMyz+/Iq8IhZAH0E/z9Uc831ItUb52LmgkG4K8nkYsW0LpoCks8gAuWRbAKaKoROR5EU2eCp6OwRFRSzBvpLLi/DcPmQ31rl11raoo1L+ZrAo8bEjTo0ad1li9GU/EeBRrqIU0OMKsFd7uMlvp0uDQ6GPNlrOdB9GZhS4lMccnqi7zSyjEzFwd/MSpbvYVRr3bhNLE7tOrOqbwoeuoVG6ZU5jmBbYaJ9w6GpbFEPu1OP6BIXFTWxwyaCPSXAmIXyHr7UdHhJP2k/syrGrg/DE5LaMPQCw/gUddnHn1WzplmJo3w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(18002099003)(22082099003)(4143699003)(3023799007)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aytmOG1vR0s3SE5hR3NHaXF3aFhKWGpySXFNbENKL0tidk5BZUVBNXNycWJ5?=
 =?utf-8?B?U2M0Tk9Xb3N4d0dTaW9nL3VVNUxMc3hERzNpR0lucXUyQWg5dWEzL21sNEdX?=
 =?utf-8?B?Ump0M1I0b0U1NDRRQkRoZjdHUDVIVERzVWVSeFlCYzhzY0dPY1M5YW9NL3h4?=
 =?utf-8?B?Y2VMb3Z5ZjVXdmErTHlmT3Q1dXlzaUZaNzNhd0ROdEhJeHJvQnpTUDJyNzR6?=
 =?utf-8?B?OFVPb2JqOXphOEVGR2V3bXM4Tnd2bS9uME1EY0hzNFhXOWVjWXcxVWdHbTFZ?=
 =?utf-8?B?RlhZSHFWZU40QUFwY0ZZVnIxMlIrdjFmK2plZ3h3YndHeXBqQll5M2txeHFa?=
 =?utf-8?B?djlKeTdQTnJXZS9PY2ZtNnhEN05ySXE4UUVoYnp4NW5GaGxlQWRYVHZsODBM?=
 =?utf-8?B?bnpCaGlNZVRVOW5WSm82SWtiNVF3ZnhGVHNVc0oxN1FoUEF4S29sclRYTDRN?=
 =?utf-8?B?aTUyQ05OVWVzazU3MlQ5SGZ5RSsvMFowQWY1VngzbENCTFVKT0F6ODNlTCtD?=
 =?utf-8?B?bWRrT2pWbThkWnFHdVJIbnFwSzhtbGp5Z0JtZHh3aWNUdmhqMklnZzJvQm1S?=
 =?utf-8?B?d3VKL1YyYWZFZ09FSE5MZ2pJUjFHQnZSN3FvNzdRUHdnZGtCVE05eVlYZGJl?=
 =?utf-8?B?UmRkRWhIZEd5S0YxRWpUMEhSVGJaYk5mQmovVkZBQ1BPQzVESG5yaTFsbUpl?=
 =?utf-8?B?TmtwWFpNWGtaRTFoeDJqakhXSnNZc0FKdFl5Y3lEK3M2WHhhRkpVR2ZvS1I1?=
 =?utf-8?B?VlU1dGozeWJBY2ZtR2RUa1VNb0Q2QkxFSlZlSUhlNWNKWGJyME43L1VGcmJw?=
 =?utf-8?B?Wi9sUUpDTjNuU1JaRG5paDBmVS8vV1FyQ2J6aFlsV1g0S0VPMjVoYVZJK1dD?=
 =?utf-8?B?U1hXV0hyNjdtN1VGOTJrRG1URGVVdVBPbk1MVkVXTVpmQnRqWmp2Q2xWbnNh?=
 =?utf-8?B?NTRlckZ1Nk0vTlZTZytXbGdoV1IwMzJJaVBkYmtrUVdNR20rcmwwd2N4b2dG?=
 =?utf-8?B?T29oNzVWVVBYaHB5UHBpR0xzeng0SURDbUx2N2w1VnpMakxadjRhTkxDWWpa?=
 =?utf-8?B?cHVPZFBpOGVQMXVFMk03S2tRQVMyd3B6b09uOWJVbERJVGVLL043dFJHZ3lw?=
 =?utf-8?B?cVRsK0hHRmFJQWg2OTQ1Z1NPcHBLbG85T01nWVFZR2lwWVZxcHRjWXJrNXR4?=
 =?utf-8?B?U3JoQk1rUTdTQVVZMitPUWdrbGVLV1FVVzJlT0hMMGVwdkVVbXMvWUl4Mi8w?=
 =?utf-8?B?QnZiZ1lQcmdzeXA0elJaR05iQVUyVnV0U050Z3hQRTBzMHE5a0JJVlg5MjVu?=
 =?utf-8?B?bFgzNURISDN3c0F2MlJlTjZIQlV3Z0Q2S0JYOVY0TFBHWDloUWhTdTFPdmlW?=
 =?utf-8?B?NERWUmlNbzJTNGlHa296ZkR1WlMyd1p0clJaOFg3WkVBd1lSSXJXK2UvSUNq?=
 =?utf-8?B?ajJkZ1JnRlp6UG5uaFJUZXRrMWpQY0U2WjZpTUVRaGhyWGJXOWxvQ29GSXFZ?=
 =?utf-8?B?ZklvRTdSYm9seW45MHg0RlZZU2I2dWQ5d0hwcU0xdGJmZkRyVUpyNHk5Rit6?=
 =?utf-8?B?Q1dOTmIzSUxZOFBaK1ZhS25kZzdHWnU2V2F6WTBOWUp0cUJBRDVqelVITVpN?=
 =?utf-8?B?WTA2QmpHbk9rZUxpWnF4NHVKTVE1N1hQd2N0R1F1WWFFWlJXN1RWYVF4NHhu?=
 =?utf-8?B?SStaVmNNZzVaZGxQSCt2ZjVLWW5mcld0WGJPN0U0eEJVSmlxUnJrQ3hiWUxj?=
 =?utf-8?B?YldqV1N2VnZ0dnBLQVQ1UWI3NEJnOFNTT0l2VktXQWdoWXNZVkZ0bEc3aXZI?=
 =?utf-8?B?QzRvb1lBVnhjUUh1TzhJTG0zN1paSkhaa2RSSkRkYi9xQzVlRU5oQjgyWmhG?=
 =?utf-8?B?S29seVhGbzM1dmxWMGR6bVV2VnVIamhnTEZTTWoxRnVjZmUyYzlEaXVuWkNI?=
 =?utf-8?B?Vld2QU9qdytYdElHaXZ2Z0MrUkNveTJNT1lWajVVQVlac0V3QnhwTXZSOEVo?=
 =?utf-8?B?VlBPTjJTTWUzN2V5RlN6eklJK21DeDJyNzhicXVCYkdhN25Yc0UxS3hDdGlJ?=
 =?utf-8?B?ek00NWRuNUE5VDU5ZUdUR3dIbkpnN1NjYm0zNkhVQTllcDk5WThSS1Z2amxu?=
 =?utf-8?B?RjhpWEZOY1F1Mmd3dXY4eUROZGMzNUZXUjBvSmJQVnJBK0x6OWg5dUZZM28z?=
 =?utf-8?B?NzdRbmprb2xsQ1hhd1NsTlhEa0tvZVN4MGlwem9ZSHdwTU9aWVFYekNsR2th?=
 =?utf-8?B?QXhvbnRpSkE0bis1SEhtWnljejZwRkhmWkRhYlpYN3NoL2NQL09xbHdmRXVD?=
 =?utf-8?Q?alRSY14k2nAr2JW7CI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2debc339-3106-4104-b9f2-08debcf31cff
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2026 19:55:48.4759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9nmAz3xydUwu/ekwX5jUAhKSUhiaTr5G06DRiV2QnxKDxC6ylSGBG6JEJqu03vGEtRJWRhzDuhOYoQCPSOH5fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7256

Hello Dave,

On 5/28/2026 2:50 PM, Dave Hansen wrote:
> On 5/28/26 12:37, Kalra, Ashish wrote:
>> A simple loop would be perfectly fine and avoids the need for the wrmsrq_on_cpus() helper entirely:
>>
>>   for_each_cpu(cpu, &rmpopt_cpumask)
>>       wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
> 
> I'm glad we're on the same page finally. I just hope we can get to this
> point more quickly next time. I started off with exactly this
> suggestion, but someone chimed in to the thread and said it was "slower":
> 
>> https://lore.kernel.org/lkml/6a50d050-f602-43fd-a44a-cecedd9823eb@amd.com/
> 

Yes, actually i should have made it explicitly clear that we need to do it in
parallel especially for issuing the RMPOPT instruction itself, as that is
in a performance critical path (and for that we are using on_each_cpu_mask()).

Thanks,
Ashish
