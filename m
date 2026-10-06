Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011022.outbound.protection.outlook.com [52.101.62.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E015F4195C8;
	Tue,  6 Oct 2026 17:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791309359; cv=fail; b=iToUBj0QRS3stBvDjqwlR0dSyvMAim+ICsXd9PHVnxpyF3APeK3J9kKfvJ0IUbWJPgSmB7R5mWKRISSxuYuaPPCFDi8f/XIAnzpFwNGmf/ZTzirB05KYvk7KrncdKyVYhgOQssLDeGLmAUv8JwSRKwjahLGv1Kx73h3/QqFNko8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791309359; c=relaxed/simple;
	bh=DGVM0wB/U3MoC8BfBwcUl4Eg13l9oOphog5vv0HwKf8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uOetRuuEgDiah3HBF4HIKSlbHxyLjuohi9m7lkbEAErhaQHIF5h44TkZT/1uh5eUezF/EVhderLGy6SLCO6nvgimbFLAmDZZ+CAxwgt3CF/Uy2R3fmT/wZQfEC265C5SENfY73YlP2ArgfC0Y4KB4FwAsNyYuN52NdNqCVjKAx8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=C1htZyGS; arc=fail smtp.client-ip=52.101.62.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="C1htZyGS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YpezVsisKt2Vtzza2Tojcj3w8rKG1sPrU2wGF1MLoxA4mwdxDdpzJ5mbEWshTvXZ5mpo3riqd22g1PAFOjT5Xs8DbI0GuoNHQsCZlmEkWHlG7qj+qMSfzqLS8ovQRmbLqHb7379AQ6NlJVLT9B8Q1MAxsFtlGezkW4b/n91guUUAU2qg6vEeUqPrAKMnXvgMw8ALK/3wcjMKtEdZH0tvki5Da7KwGPQiKaLiMiTLa3vK2heai1JohpOtJ93ikTKIPn9NeAM371TmF6Z8nKNe3Yqv5HCnRprkTO7/TJ2/hs2W6VenLDy2ECGRFlgcjVwdBQB1argrEY/hhSv1BAQCVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RYtDv3J7iiAynkkZkkPxwLz0YQQDnLn+l5VGy3+ran4=;
 b=pX2ymgLZIF3WuHVyCx4MeHHsHDS61vnA3Py3EVr+dQrXmmyJh+LIRPDeF5LizK5vA7tAu8HJcGFwGp+w2/97uSWZl4Q8EToW5p9kD12K7tKX+ICvvmjuKXOr3fo8E4iQbNcT+6QAaMR4NhIZp1uYf9Ew8l5kjRr8uE7WIuEKkDNqQGWZ/8qJCD8b+OXS502mpn7DFhDAsw+qGMIPtjYZtP/b2/kj07S55STVIaDMlFkrM9VWFU4lHZg8k2thL8kNdeoBLJa76jjtAQErxtULji0cW5Kixkh2dFuHaKJylhuSDsMKcp9ObFgrHv/aHgIU9P+ZNdps77w70S65S4LZAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RYtDv3J7iiAynkkZkkPxwLz0YQQDnLn+l5VGy3+ran4=;
 b=C1htZyGSXCMOy0ld11jgbdgrBRBbDgDE0/awfYKIqMqgu37TiY34WnBrACn6cdnNbxQNjwtHDeP915dhm25TNukoPSe71E13e6/eL8ShcXybQE82RmVWCwfisXVfFbpBlYyXuptGrk9+EvRKI0y/1zyTJgKGRNsTsEQHL7CMcUs=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SJ1PR12MB6217.namprd12.prod.outlook.com (2603:10b6:a03:458::6)
 by PH7PR12MB7454.namprd12.prod.outlook.com (2603:10b6:510:20d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 6 Oct
 2026 17:55:51 +0000
Received: from SJ1PR12MB6217.namprd12.prod.outlook.com
 ([fe80::bdbb:19b0:4f1b:44e5]) by SJ1PR12MB6217.namprd12.prod.outlook.com
 ([fe80::bdbb:19b0:4f1b:44e5%6]) with mapi id 15.21.0451.022; Tue, 6 Oct 2026
 17:55:51 +0000
Message-ID: <c3384e1e-6fa4-4b3b-aaa5-a325bffcd10d@amd.com>
Date: Tue, 6 Oct 2026 12:55:48 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v3 7/7] crypto/ccp: Implement SNP Download Firmware EX
To: Tom Lendacky <thomas.lendacky@amd.com>, mcgrof@kernel.org,
 russ.weight@linux.dev, dakr@kernel.org, ashish.kalra@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 gregkh@linuxfoundation.org, rafael@kernel.org, chao.gao@intel.com,
 aik@amd.com, tycho@kernel.org, nikunj@amd.com, michael.roth@amd.com,
 shansinha@google.com
References: <cover.1791212077.git.prsampat@amd.com>
 <c03c5a47f3972486fdb144bf8c6f50ab3375da2f.1791212077.git.prsampat@amd.com>
 <4639287b-0fe6-4aaa-9720-c7f264019d06@amd.com>
 <028cdf37-2272-4d7f-a8dd-bd011a55774d@amd.com>
 <66568327-9b4b-474d-bd48-667ec3bee6c8@amd.com>
Content-Language: en-US
From: "Pratik R. Sampat" <prsampat@amd.com>
In-Reply-To: <66568327-9b4b-474d-bd48-667ec3bee6c8@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH5PR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:610:1f1::15) To SJ1PR12MB6217.namprd12.prod.outlook.com
 (2603:10b6:a03:458::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6217:EE_|PH7PR12MB7454:EE_
X-MS-Office365-Filtering-Correlation-Id: 52bcdfa0-958e-4d4d-396c-08df23d30f2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|7416014|11063799006|6133799003|10067099003|56012099006|22082099003|18002099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	dbjon7u2vbcbONb9N8Fo5vgVzv7CC2upf4wVbKxbYlbIxoCJ9/d3tLzuBhJS+Hs4OucxAZxPeV7hOBysEHTWzohU13jSUzNlE3tjaCxEoKQgFcZepJUGp76ep2j48Ir+vrTptVDYxQwoZ5tyipyCXcatjlXmoj4pj/GB212nX4BlSqcFPEZR0GFEYpJwO7y9tcA8LipGi1oVseWQ/iyR5+YFKi1msGrFy0FNRDrzk6LRPXAa3Pru8JmjrN6doDJX+KwmCAVoeeshW/UPhSOB5OfA7JixL8s7DeEdOS2HY5wtHN9XWWYbMPIAHhIscKxToyXBsXjkzqiDTh6BpKe+TCjV6j28uWaeLG5muWjaI9OPvlnskCUehqr1VD7H7OgwC4R/gzm9qH1wbt/FyGSFjNkLuGeSLfgqUIyJ/+Pc9/VznOpnfPriYqd8hYrvw0DHm6heH4Mz9zx47Sr7fsw83/K8RzSHdAOX/3XxA/lIO8Bphp8XMHhCqsMXP6vZpaew/2yTbVn9feTYqClP7cA2KusCupHCtpib9CnuQEbcHHXeya8Bb2o4q1JsCFYM2OTiYn+5efzCYHKHdnApORvYxFQbJDVK7LHfQrj1ZJHiYhfykYv2BBJ8FbQ9Z/ks0HrfyiMYapVQFyifP4SFt/18bTdcoBjoIVOLfyCuXKL8l48=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6217.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(7416014)(11063799006)(6133799003)(10067099003)(56012099006)(22082099003)(18002099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?elk5MzFkK29wN1Y4QkRJQkV1dStXcmIwMU9jcmVVbUZRaXdIUnVUeXlzMG92?=
 =?utf-8?B?dTZXYlQzdVNVeGNRUjdlekJ6ZDEwS3gvZDJkU2w2TE01bDA1bVoyOXNKc1ZE?=
 =?utf-8?B?RXZzb1F2cHJrd1RvT0FEQWpyempmVXJiS1o3MnZGMXBvYzFwV1g4VUNzbWYv?=
 =?utf-8?B?YWFyVHEvNXJtY3lXUlZKckJPcituSjRtb2dLQ0YwNnh1T0wyQk91MFhLRDFE?=
 =?utf-8?B?NGRpaDZsYlErcDQ4czBDWnRzbnRIMStBZ1BHVW11Yy9ZK2R2TStydmJQcjZG?=
 =?utf-8?B?Vk5MN2E4Q3ZLeHBPeFVJcU5FYXlhTlZreGQ2cHFmZGpGYldkeTRqZ0hUb1VW?=
 =?utf-8?B?NjE0UlhYaWRvNW85TzlFSXZ1K2NFTk9EaXNrYzExVENvSVZTczlHTisxYlMr?=
 =?utf-8?B?cGU1aTRqek1PZm00MlVPR2ZWcEx6UmFYQWhUZnZXV01UNUs2TXNBeVpJTTd4?=
 =?utf-8?B?dFlKZWRBc3NFeFVmS2xoT3Q0aVhSMmduNWR5eHBaamV6cDROMzdVVUdKdGJP?=
 =?utf-8?B?NFpsSnh2THh4czlrL2ZPS3A1NVhEQjloNjB0OHlLRkQ4bjkxeVFSWEVDTFgz?=
 =?utf-8?B?WFA0TlJ6MmFnUHBPd011MEZad3pobVF3RWw3RG1aY3VuUHZpYzlOTElNdGJP?=
 =?utf-8?B?MkdPRzU1TmhHSXZpU0JDTFZIdVFkc0hsQ1RJNml5UEdpREtwdUl5d1pNRWlN?=
 =?utf-8?B?emxCSlRTV1JzYlVOWTJicllNMnp0Vkg4MytIRm50MlMyeW5NVC9jTTdCV1lC?=
 =?utf-8?B?SkdNT0c1a2Q5eVhhaWs4R2htVmdYK3Q4em95QkFXYTVhQ0ZmZUtTVmlBV3Fa?=
 =?utf-8?B?eS9BOHhLT0JqUkVUY285bVZVdWJzNjZsQmVEMGZDei9POHpMbi9PdVlwMHI3?=
 =?utf-8?B?R2JkOEFrL2IxSXZzZnNNRVhZaENoTEVQQ0hIM0djYWZrWDRVWC8yRkt5MUw1?=
 =?utf-8?B?azdrNUZ1VjVhZStFSjBMOEVFOC9DUngyWG5JNURqV3UzcnpkZWgvZnlvZFVM?=
 =?utf-8?B?UGJXYzhBcXhmTnRTcWtQOEs2UXo2Qk9GbEdJbGRWVWszT3QwOVlDMTREK0hQ?=
 =?utf-8?B?UThlYkdTcFRpa0duZWVRTU11anZNSkN3V1pBeTNaSG5rdTUrdnRPRlMwcCs5?=
 =?utf-8?B?RnoxUkF0ek9GMjZxSjlZZ1YvQ2NYdkhSakhBdkovV0JpSzA5SSsyNkcvK1E5?=
 =?utf-8?B?Z2pNcDJVWXRqa1JKSldyb2lSRnRFeWQ3YVROelQvNVhBbmI5ZVdyL01sR1pF?=
 =?utf-8?B?aWpXb2UyZ3h6WlB4TW5meXZVeFJuenZXL3RJR2pER24zOVcxWjFpcGF6N1Bx?=
 =?utf-8?B?TjQxZjVEZFJnQjZaa2MwVFZMaDRndG5GNzFNUDF4WjZ2QzROZUZnNVh4SjQy?=
 =?utf-8?B?Sy9tRDFnTU1hSlRiUHNhUjJMd0libkxXWlJmeTJnemtGbFJCZFkwNEFJWUY2?=
 =?utf-8?B?Nng4dWhYRW15WW1UV3ppNE5tYlZnVG5NY1VZM3l1R0twbkpFQlFmeFVvSnht?=
 =?utf-8?B?bWZHQnRPQXRLc1JWRnQ1cEtBTEUyMWZ1cG9ROU1xSmJqbTg4bzhVSHo4YVYz?=
 =?utf-8?B?QlV6NUl4OUlSdnFjbm1sQzlIZVNPN0NmMlovRkFxc2FkcG52KzRoZFhFOXhJ?=
 =?utf-8?B?S2VPcjlXUCt3NHNnV2d2RFN3OVNqL2pPT1hNakhJNThhWFdPZWUzOXRRck1h?=
 =?utf-8?B?dXdlQXNRYnBWQldYSTEzUm55L3ExOVFNQlllVzQ5VUV0eDZBNEtlRW1QSWZ1?=
 =?utf-8?B?a3dCVkJna0svR29TUEtaSG9hd3IzZWwyeHRaeVhBdjRwdnA2OC9nd1R1YkNX?=
 =?utf-8?B?M05nYXNrb0Z2N0VWc3UvcmFYYzFzUSswVWJwYnlPajJUbVRMdnVpS1F1OTdF?=
 =?utf-8?B?Tk9Jc3ZzZWNVQzBoRi83N3plbEVwbjFUZ0R1dG5yTEoxRWl4NXZuNVJSakRw?=
 =?utf-8?B?YVVwM2diQ0EvLzl4TVAydzcxK1I3Q2JKMXArNXUxb0h0eU4rdGxxUTl5Mk5o?=
 =?utf-8?B?TnViZmloREYvRFBrNTlYdzg5UzlUM2VVOERMRU1OWllMYkZySVZwMk5YdmRq?=
 =?utf-8?B?dUtkZFVYbHNMUDRYMDJ0STVCN1FNUU5QQ0gvK080bEtWcm9zTEF4NytMU01M?=
 =?utf-8?B?VFVLNmlaeENJRGhSaTNSdThEaFQya2daazIzVHVERGF6OVpxZ0FFMWluOTZl?=
 =?utf-8?B?MzFFZEdoWTdNWmlKQ241L05CRk5ydDVJaGY0amtJeUVKSFBhT0p5ODNwVUFC?=
 =?utf-8?B?UFdBVXFIZmpqd3Y4RWZwdW9rOG1WUVR5alh0MW56b1NHM01hVmVnUWdYeUFP?=
 =?utf-8?Q?9xvWSwIaxHa4w2PfA4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52bcdfa0-958e-4d4d-396c-08df23d30f2f
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6217.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2026 17:55:51.1745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QSo0gw79WUW6eRz2U1Dr3Xpjv8mhE0h/ObyNLxBLvT4oi/2KqKRMnKLTyNL/sYfRFY0sB7KlQbltYSmX29l9ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7454



On 10/6/26 12:32 PM, Tom Lendacky wrote:
> On 10/6/26 11:41, Pratik R. Sampat wrote:
>> Hi Tom,
>>
>> Thanks for the review!
>>
>> On 10/6/26 11:10 AM, Tom Lendacky wrote:
>>> On 10/5/26 11:15, Pratik R. Sampat wrote:
>>>> Implement SNP live firmware update using the DOWNLOAD_FIRMWARE_EX
>>>> command.
>>>>
>>>> DOWNLOAD_FIRMWARE_EX requires the legacy SEV platform to be UNINIT. If
>>>> it is WORKING then legacy guests are running and the update is refused
>>>> as busy. If it is INIT, shut it down, release the buffers the firmware
>>>> owns across that shutdown, run the update, and bring the platform back
>>>> up afterwards. SNP is never taken down, so SNP guests are unaffected.
>>>>
>>>> To test run the following with your sbin file in FW:
>>>>
>>>> echo 1 > /sys/class/firmware/sev/loading
>>>> cat <firmware.sbin> > /sys/class/firmware/sev/data
>>>> echo 0 > /sys/class/firmware/sev/loading
>>>>
>>>> The COMMIT bit is left clear, so the image is only loaded provisionally
>>>> and the admin decides when to make it permanent with ioctl(/dev/sev,
>>>> SNP_COMMIT). To roll back, do not commit and upload the previous image
>>>> the same way.
>>>>
>>>> Co-developed-by: Tycho Andersen (AMD) <tycho@kernel.org>
>>>> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
>>>> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
> 
>>>>  #ifdef CONFIG_FW_UPLOAD
>>>> +/* Largest image the firmware accepts, anything above is rejected */
>>>
>>> I may have missed it, but I don't see anything in the SNP ABI spec that
>>> says the limit is 512K. If that doesn't have a limit how did we arrive
>>> at 512K?
>>>
>>
>> The ABI spec doesn't mention it, but the firmware had this limit hard-coded.
>> This can potentially change without notice to the ABI. However, I did want a
>> sanity check in the OS and that's why had it in.
>>
>> I can drop it and let the firmware fail if the image is too large.
> 
> The memory holding the firmware on the call to the ASP has to be
> contiguous, so you're likely to fail on the alloc_pages() if the image
> is too large. Up to you if you want to keep it.

Sure.

>>
>>>> +#define SEV_FW_IMAGE_MAX_SIZE	SZ_512K
>>>> +
> 
>>>> +
>>>> +	__sev_release_firmware_buffers(false);
>>>
>>> Do the buffers have to be released? If so, why? I think you can keep the
>>> allocations. During platform initialization the buffers will be
>>> detected. Is there a shutdown path where they might not get freed?
>>>
>>
>> Shantanu hit this on Milan with an earlier version of the series that kept the
>> buffers across the update [1]. After DOWNLOAD_FIRMWARE_EX the new firmware
>> rejected INIT_EX with SEV_RET_INVALID_PAGE_STATE (0x1A), because sev_es_tmr and
>> sev_init_ex_buffer were still in the firmware state left over from the previous
>> image's INIT. Freeing them, and letting re-init allocate fresh ones, fixed it,
>> which is where this call came from.
>>
>> However, a fresh allocation with SNP initialized just goes through
>> rmp_mark_pages_firmware(), so my understanding of what the new firmware needs
>> is the reclaim -> make shared -> mark firmware cycle, not necessarily new
>> memory.
>>
>> Freeing seemed like the easiest option, but if you prefer, just cycling them
>> back should be able to achieve the same effect, I believe.
>>
>> [1] https://lore.kernel.org/all/20260831204757.436751-1-shansinha@google.com/
> 
> Sounds like some good info to have as a comment above the call then.
> 

Will do!

Thanks,
--Pratik

> Thanks,
> Tom
> 

