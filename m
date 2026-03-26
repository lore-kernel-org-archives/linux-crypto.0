Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011059.outbound.protection.outlook.com [52.101.57.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCEF23183C;
	Thu, 26 Mar 2026 02:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774490571; cv=fail; b=rhasp1FvKvmYpB427tLzsh0WXIVU0VkfYAxoU2BlSAyeD9CW6LbTkIEzAXtMyMNZBZqVnE+4ng0RnFiol6sdj2Qud3CqufgdAc2B8xkFlH0CyEdlBkvlFzgPsnEqcOY0TF/GnGW6vh5OSqgw/oRmiDwvVs2xeJzro0HvBLrnMsA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774490571; c=relaxed/simple;
	bh=vjBd8eVsv/a0XcueZS6uOPUDeu6Pt8LAPBANfUBorvA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nAY0N+slxE6OnevS8lIETjPlo7oLu8kFIdwY6rp+f5E9bC86mWmF/8TLr7FVkzYPmVKeQTWL1MaCxutbfhX3zf0gMw+K3Aptn0rpgCNAS+o01A3IKiZZuDs5ZZVeqEvTCAfQbrVryjKk2poe5oghM9gCplxgbRk9MigXl9RqwOg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lQP3SOS2; arc=fail smtp.client-ip=52.101.57.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lQP3SOS2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uzVg/uo8zsc7JHRHrOZQTajz45xiSeqU/b3uUSa7dcwxpMzqtdMjEl21u/hLvNp9sYksOZluTohaORj65Krl9RLjhMB5GDqBPfZf0xWl+fqLXrb+beFPuLA70vB5WKSy7OeGAjO2RlKCYgkIy2Ry16/I/3pvHmJ7JfQi9mKS/QlIRBdYEXJ2agPyDgjKFQxnc+ea9zBsHy0IJVKAlcd4MqFP+QqcL1G0EHcu+5AGaf/CYl6qvJnIx207qMjT67ZbfVHjM0k+mt3YZ05PlWIT1CBkp66jCB/oeLxF5W87pfIgHnFCWwllvv3LunYcmIakQMSlbb5pkQmO+Ovj0oqV8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=viOKRrxdBPN9QmFmRZ9/AiuUTzYUY82GAJ1vu3EgMdc=;
 b=KQYdcKwd0kMzKIL8BPdXOsKDalh+lF+0y5EsHwnVWeOleeyL06dqhb3CPhgD/qlEWdOKOChGbOPnkytfvs7Ijz2DPamVzJ+mIQHS1jXEBGCOVPb3vlwcK1dXzV0GgpgPNEtZRXC//rs1gIkwjF22c3TuTrlxwYdMH1cAevB+epsUKa117zoG32ZcQN9S80AeOefoeGp5VafjJT9MEeURsOKjMaRRZ4c0eSL+8WMfsmjNVNtLsrKXPQANyM4I6OBDtKtF5/hD7IhLSRgqz1cnTHFlvr7qlCzeaWf4+Ztcc/MWUaSziaBKDnjgtEf3Z5yquIJ7crzU7rvNo7gbta7fAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=viOKRrxdBPN9QmFmRZ9/AiuUTzYUY82GAJ1vu3EgMdc=;
 b=lQP3SOS2wcQOM2pK0IxKJwByOm+Q9stCWTo9vuxSAka1/CBYZ1I57CqUY6QCp7OPEYDUpIe4mUIpvg1l4NR97vdaWe32baxcrwaiFs6k2bKb0ngtHpVlsbVHpYbrG+R5SVieBEuxAzmGHxtFU8bXPGCHoqZZwLjiwrQI8v4aHmY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by DM4PR12MB6351.namprd12.prod.outlook.com (2603:10b6:8:a2::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.20; Thu, 26 Mar 2026 02:02:46 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356%5]) with mapi id 15.20.9745.019; Thu, 26 Mar 2026
 02:02:46 +0000
Message-ID: <4698d9ba-7030-4447-89c0-c992b776377b@amd.com>
Date: Wed, 25 Mar 2026 21:02:39 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/7] x86/sev: add support for RMPOPT instruction
To: Andrew Cooper <andrew.cooper3@citrix.com>, dave.hansen@intel.com
Cc: KPrateek.Nayak@amd.com, Michael.Roth@amd.com, Nathan.Fontenot@amd.com,
 Tycho.Andersen@amd.com, aik@amd.com, ardb@kernel.org, babu.moger@amd.com,
 bp@alien8.de, darwi@linutronix.de, dave.hansen@linux.intel.com,
 davem@davemloft.net, dyoung@redhat.com, herbert@gondor.apana.org.au,
 hpa@zytor.com, jackyli@google.com, jacobhxu@google.com, john.allen@amd.com,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 mingo@redhat.com, nikunj@amd.com, pawan.kumar.gupta@linux.intel.com,
 pbonzini@redhat.com, peterz@infradead.org, pgonda@google.com,
 rientjes@google.com, seanjc@google.com, tglx@kernel.org,
 thomas.lendacky@amd.com, x86@kernel.org, xin@zytor.com
References: <a1701ab4-d80f-496c-bdb3-5d94d2d2f673@intel.com>
 <4ec520a1-68c7-4833-9e8f-edc610e5fdfa@citrix.com>
 <48f11469-6435-4f3c-ab67-705ad730b042@amd.com>
 <dc8d4117-3089-48bb-8911-b4d64481fc44@citrix.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <dc8d4117-3089-48bb-8911-b4d64481fc44@citrix.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR13CA0058.namprd13.prod.outlook.com
 (2603:10b6:610:b2::33) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|DM4PR12MB6351:EE_
X-MS-Office365-Filtering-Correlation-Id: ce25ab9d-e549-41c4-501b-08de8adbc5d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	lmObOfD+SfyQYDXd3gX2BiGkU2mNNP1dHz/mAnE5aPnSv2R36g+MppxnQ/E2ZTVk3JlEpBxFKq12dXHeRrPUka0xib3y6z4wFN+T7iHOE2+5C9uBEMu8cNqzZ5M4jnmTpoY6weIb7PX4gUuWnwUtX/8izgnxnBS5V3Iq3GGhqfN+z6Y/JD44xzisGHMCQI2fIo6Go4D+qMuYY4hxPf84KYpItLKIvBzfuy3utHzlvis9wFOeXVp6OKI4FNQpHJqmKCl4U7Q2fc2Fk+f2T3/auAI1IgW2Dlkqam/eRShnVTDtK8/+XpjUzGhzWPilJfP6aGAU1ehrJNQqVnhVdB05/qR6g7caL97ZpvQI1vq+7wTHwo05r3T+5p9p8yC7jpCnJ3p7HGpz9JV+MZdIY0e8Rk1XI5w/iVMg/aRizFfY+SQuBluTV8XxWUL+hrwxeatzqdEYWVbbOoTe8IazsCaCWdQt2xXW9sE7K19+77ddw8/Q+e7ol6zd6rUoITVX3YaykrWpQuvZy396ZzDN1KyQ5RlwVIQ0ZiCxGVEaS8bU5eakbM36GxxpRt+c6fqzAjWxeCGiE1jK7jdXqxhJo4coO/dJasZfT4S9uLlk0jpHVpQJjCZwf6Cbl7GdDOsZ3yfLlCEXYCXqipZEoZxthSLYzNKs5takD516ehztALj6ZslT2ShSfduqekOqtC3yPO29EJmZ6/2PBNZrt0N1wN/zzgTMVKfcYDsxI30J4BLUphY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U1R5QmliOTBCZlNscWNoQ2pzV3BFT1JMaWk5Sm80T1BDK0lhRnpkdXd3bU9N?=
 =?utf-8?B?Z3JjRjRxa1cyOXRnekJXSVdScDhFYzVFUCtCSmxsWDJZbkNxL095SDNyd0J6?=
 =?utf-8?B?T0VHYnpIWlJZZVJVUWUyUXdqQlkrWlZ5L0hKVi9oQktzclVNeFRWTG9DRUxJ?=
 =?utf-8?B?RGZOVS9PRVN2ZEhacWs1Ykc4K0dOcjNDaiszbzVCZmNsM2Zlem9jeENTd3ds?=
 =?utf-8?B?K1FQdkIrUllpVzhPb0hQdmV5UXJFMUcrQWZ6SERkckxpem1MZjRUK0NldzRs?=
 =?utf-8?B?c3daTEZhbHA2VkFrMFVRVkNxZnlsenUyTW5xMm9HM0cwcUlJcDFrMUxFRmVW?=
 =?utf-8?B?UkR1ODVzTWdlVGdPZWNSSld6Z1hhNmNoaVNNMzZLWWRQRGJOT0p5VVZyWDdN?=
 =?utf-8?B?K2pLYnhxTVVQd2xlTHVlVGRyZFpjVHZ1Q0syK00yQ25DdG5DTThvNTRscThx?=
 =?utf-8?B?TFo1QUVSTmFFTnZ2dmMrdnR6TFRtQklPeE9CMWJpM0Y4L2ZhcUdwR243RjlF?=
 =?utf-8?B?bWZCL1MrVmQ5WXdPT25TaDA2QjVYR2Z4RzJMUXphcm5ManVsTUt5a0pBVDZW?=
 =?utf-8?B?bUZrTHdiQWkveDJFR1MveUROd3BXeUo3dVNLWGRRcFFRS2hGN2RYOWUrcXRW?=
 =?utf-8?B?d2M2c2NyODRHV0ZabWJJVitqK1lKMWh6TnZBZTdIL2VKNXpjQjk2eTNpamlk?=
 =?utf-8?B?VmYrVDZnWDdVTDZPMC9sakJROTVqU0ZtOElvdjFsd1lOUVVrT2RyaFJLMkJP?=
 =?utf-8?B?OHEvYmlwNStYb3BNbnRXVXhESjAxUEQ4QXFJdlc1a3gwRHorU2orcFZjcmxv?=
 =?utf-8?B?Q0hGd3FGTTNBUC9XN2RZUW1VMFBZYTN5cUZzS0xGc0tBcUw4aW1tUm9OZ1Ey?=
 =?utf-8?B?WTJ0NWZVYVZzZWpxTytsTVdRQnVZd0hJTDNsZGdOcEFUQ0M4M3lnTGZJeFdy?=
 =?utf-8?B?SUt2dzFJZ3ZzN1pjd2RWdncwZXlRamlTd1Zqc0N4Vkt6cElXb3JxVkhXR0FS?=
 =?utf-8?B?djRWV00vRklzbnpLNzExYnlIbmEydXRyMDFDNmtvMStGMXhzYTh6MlBjN1Va?=
 =?utf-8?B?YTlza2RJQmEySERQcGxLVnhYRStqUUJjNVR0QkhaUm83L2hwdHNyWUs1MWRs?=
 =?utf-8?B?R3dTVm85ek53L2RrdHNRcGhKQisyS0RidDAxdzBsa0JmZ0RHKzhqNzYxR01l?=
 =?utf-8?B?ZHRPS3p4YklFd1pUMDJ1ell4M0hHZGJ4eDRXS3BqUTQ4S1RMTys3cFVaMzRu?=
 =?utf-8?B?ekdMUXVsYjlqdXJiVW5DN3R3ZForNGhEY3E3QjY3V2F6SmkxL1hCYVJrakdr?=
 =?utf-8?B?OHl4Y2hnWi8wcStHV1ZqaFBMbDM3bkgwaGcyREdmNVFwMTBpY3FIUkdOQ1Q5?=
 =?utf-8?B?d1ZqUjVJb01zOGtDMGduRlFNcXA3UTVRaUJQUm5rRVZwS0RjQm5KSmIyRmJ3?=
 =?utf-8?B?UmdOTmtEWG9rUDQ1UnZNbHErMVY4UzhDNmlNWlE2d1V1VUsvZmZ4cU9qWXd5?=
 =?utf-8?B?K1pNdWU5VUtiblRlaDI3bXZlQXNtMUVTZjRSRjhSRW5qd1lFNzY2UHpGbFBC?=
 =?utf-8?B?WitYdkFmT2d6RjBlNDNUME03SFFmUTFuVU00S0NQK012a0FtWjNrbTgrTFN6?=
 =?utf-8?B?R3hmaVRVTWxVdkluUVR0TjBlS0w0S3NhMm5BR3poQjNBRDIwT3ZHeG4xbUpi?=
 =?utf-8?B?OWFqYWRVQmxsN3AxbjhOODhpUURhVE1vR0JaYkREUFdKU001TVpmZlBlVWpF?=
 =?utf-8?B?RVB2M1Rnd1ladDRkeDk4Q3BOQzg4bjRKSWlZWHJEcHhBOExmb21zU29xMXdm?=
 =?utf-8?B?aWUxK0NEL2hxam1LUHorZFliTVZsSk1XYVQybnViSDJtb201ZmJxSHY2c01I?=
 =?utf-8?B?Wm1UbDFMMTlhaEE1cG0rRm9qejRYZHpqVjkxRHpIOVJXRG1maG10MGNFSDh2?=
 =?utf-8?B?a1VZYXVsbzVXelJ4NEM2bzhYbEJoYnlmSnRXRVM4SVdFT2VsaXdUTExKRC9h?=
 =?utf-8?B?VW5zOHBkUzJuczV2L290UWxHR3c1bTYxZ2RxUEJ0d1U1dkp3SnFWL3c5bmlw?=
 =?utf-8?B?WWJPWkpzdHQwbS9pWnRYK3FqZUZ3NER6UEdrVC9JekZ3VHN5dC9GL1YzQkhO?=
 =?utf-8?B?RmNoRVVFcmI5UHY1R1U2RjJjTzByNDY1RldMSWRlenZXeGd3UU9Xa01DZUxq?=
 =?utf-8?B?bHlMSTV4K0ROU09LZlRJOXJsUi9POTdXVXFvcXNwcTU0eHVtYXVmN0gvR0Q4?=
 =?utf-8?B?aTBvNWUyM0o5YU9jYlNsRDZxdEZYdENRSllJVlZtMm9WVzd2QjNYSHNYc2Qx?=
 =?utf-8?B?cENSajJEdnBHc2RkMi9USjNoZ3hES2R0U20yK25CSFZSZVJ5WnExZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce25ab9d-e549-41c4-501b-08de8adbc5d2
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2026 02:02:45.8863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +PLGVXDS51lPpKRCd8puKb0GIzxBVj9tM0+yVv7yjRXHBa3Gmc//L7O7Ec9rHRyk0GPCWQ8ZuLgseGGjO71RvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6351


On 3/25/2026 7:40 PM, Andrew Cooper wrote:
> On 25/03/2026 9:53 pm, Kalra, Ashish wrote:
>> On 3/4/2026 9:56 AM, Andrew Cooper wrote:
>>> It should be:
>>>
>>> static inline bool __rmpopt(unsigned long addr, unsigned int fn)
>>> {
>>>     bool res;
>>>
>>>     asm volatile (".byte 0xf2, 0x0f, 0x01, 0xfc"
>>>                  : "=ccc" (res)
>>>                  : "a" (addr), "c" (fn));
>>>
>>>     return res;
>>> }
>>>
>> The above constraints to use on_each_cpu_mask() is forcing the use of:
>>
>> void rmpopt(void *val)
> 
> No.  You don't break your thin wrapper in order to force it into a
> wrong-shaped hole.
> 
> You need something like this:
> 
> void do_rmpopt_optimise(void *val)
> {
>     unsigned long addr = *(unsigned long *)val;
> 
>     WARN_ON_ONCE(__rmpopt(addr, OPTIMISE));
> }
> 
> to invoke the wrapper safely from the IPI.  That will at obvious when
> something wrong occurs.

This wrapper i can/will use, but doing a WARN_ON_ONCE() is probably avoidable as 
there will be ranges where RMPOPT will always fail, such as while checking 
the RMP table entries itself, so there is a good chance that we will always trigger
the WARN_ON_ONCE() on the memory range containing the RMP table.

Thanks,
Ashish

> 
> ~Andrew
