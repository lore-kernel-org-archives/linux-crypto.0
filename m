Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2074.outbound.protection.outlook.com [40.107.237.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907D174040;
	Tue, 18 Feb 2025 01:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739841910; cv=fail; b=I+Reg3BMsMOmwifzMG62GILKCVpf+Lr275al9FQBogtW1dq15aSd1Il++OLPetien2EBEKQ/JcRi9kDyTrIGccZ3cITD9SinKq69Z55mk43esXQyjusj2ZuCjEpsxE9yJpERdDLGzaOkgW5dB9JBhtUIjAsZX0e/mgFabj2QMNw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739841910; c=relaxed/simple;
	bh=nSxiT1JAz30xraf19+zTkD1FWVw99z/kIYdB6OJ/9Ms=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uemnSgE9quxNHbgCGK9Xx8GjgM0kKRIUCaDhqwFT/6RQiJS78ZmaJGz87yNUVMZimnQ44ivU1oz3AAHWSoSMSDJpVKRdyLnVPzqGKxGe25q0GorhLSBHpZZflD3V+ZxlqGMcZ1sf59ruiCy8ZDMAqc1o4r7sYtyvc+eLBT9upc4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LLPCvqQl; arc=fail smtp.client-ip=40.107.237.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LLPCvqQl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kdw+TeqkLKVJDGH4zTm88WV1SfZIj98ix5BMsMLKnS6Pm4r58wcYqaXgdgiVEM7vJSHg/SBqB4yWzXcwPpmcVt9Y8v8/I01fw+3PCrG9MsxNrNMLae4jdv0S4CZ46ukGeTPTc1YqVWWi6kdzdseTBOfnu8q7hH8AsuownsUeGxEMaiTn4VPP3jxlRpt/OD8yO82brsQFfCPzMWduFwDAWBiTmaZz9LDTn49HYlaZn85bMdJOWkTmybWwCzbO89vnJjCbWe99WhSkCS9HYwmBa+tvpYeePAAl1jf8aBjWpl1Q3FkrcXk44XcrpQ0pkYPh9vu6FmddRge/ZhA9NPsg0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EVBPSdcZvQhID6iKv3ZMJkVdyUj7Nt44N6gkP3nbdl0=;
 b=sHjNx3Y4KsQ0JPzfOhW0TjYEVezSDkY3F0k1ic4YHOHfw8LoSQCQq+pJ7YFs0qA3SJrc6D0iAmcngH9boDV5PbHckrN1ZfAbzSzv8qWTZ16BVJrgnvxGG//kSvPwnbBO+Bgrc5igRXP+51qUo933JnWu8PT2upaeHI6UFlpoG3gONnQjFMuEWA5XokrTPH1Y0kERKXc5j0q3KrazI6GIFqX9fNYQm/WZmRDOQOwRdUg0OFCYnbRhS2XfyqHdadvQQJy2ApxCu9MrtCFy6aqkNgimVgRl0ba/L6AH5xgODmYCeWjFZ/Uy8so6FZEXf+/2Z0GhdfQ0s7Q/XSWazLWkQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EVBPSdcZvQhID6iKv3ZMJkVdyUj7Nt44N6gkP3nbdl0=;
 b=LLPCvqQlf+gw49XV0ykBit7macu4FBhxwQZbTLnzO9fMttmrgPTxl3rEX61BbIRRGdA/BLjTGvnZLErICB6enXyMRczhSsrhvGt8MPxBW0evoQUZM0PID8htiTazsLp+NqtgQqY4ffIy/iY1io5KPl6NUWWyz6OIrTKsYr/y6so=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by DM6PR12MB4388.namprd12.prod.outlook.com (2603:10b6:5:2a9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.20; Tue, 18 Feb
 2025 01:25:04 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8445.016; Tue, 18 Feb 2025
 01:25:04 +0000
Message-ID: <a0d4b2ab-c20f-444a-a1ca-d0cccfe862fd@amd.com>
Date: Tue, 18 Feb 2025 12:24:58 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH] KVM: SVM: snp_alloc_firmware_pages: memory leak
Content-Language: en-US
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ashish Kalra <ashish.kalra@amd.com>
References: <20250214035932.3414337-1-aik@amd.com>
 <8050badb-8671-400f-8bb6-04255c761ba0@amd.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <8050badb-8671-400f-8bb6-04255c761ba0@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEWPR01CA0021.ausprd01.prod.outlook.com
 (2603:10c6:220:1e4::16) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|DM6PR12MB4388:EE_
X-MS-Office365-Filtering-Correlation-Id: 1237cb95-5442-4a84-a6d7-08dd4fbb1275
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YUU5RWthVmtHSzFaYmMyMytWNVN5UHlZRk9JY3F0K2YvbFFycFBPZUljV1d3?=
 =?utf-8?B?K0pQU0k0RXdLNStHSXprOXdzNkh5d25STEw2UW92Rm5KUWFZQy82YnZSL2h1?=
 =?utf-8?B?QUhRTXI0MmlKU0xJZFJBUWU5SjR0b2dVL1MvUXBlVDNDUjFwb0x3SlpDWkVU?=
 =?utf-8?B?SmNicFY4Nm1MUmxoR2ZNdHFwNXdlbUVzaTMzL1NkUUxRK2phMXppOTRtSEtK?=
 =?utf-8?B?ZWtQcU9FeDRYOTgyR2xoUUhheWFMdjNtVGMvaysxM0E1NXIvQTR6Y29lV3ZJ?=
 =?utf-8?B?cGVnb0dFSzJ5a1RpU1dOUDBVS2FmcEZlSkplY1kxdFNTRTFra0lpWVJaM2pl?=
 =?utf-8?B?TFFPUXFqTHhHOElabXZyVXk4SGVmNzNtcnpUSy9MN3pkVkxPeU1RYmxTbERm?=
 =?utf-8?B?K2lxRStQbS9SVlh2aHBHNTdScHFielkxa1lLc3NxME43K3dnUUoralBtcFF2?=
 =?utf-8?B?VFEwYkR3SnBvdEtvdkRiSlFPNGM2dXZrUTB3YkRwVHd6OUJrbjdGQVZHdEoz?=
 =?utf-8?B?d3ozS3R2TDVoT0E4QXJoUjhIbDM0cFI5dTFuUU1EVmN0R2UvS1ZTRFp4OXp0?=
 =?utf-8?B?TmpLenVEUlgrdWVtQk1RN1hPV0N5VVZERUhXQ1MweDFId2R0bFpTMkI0V0M3?=
 =?utf-8?B?cVIyMjR3NVErMk1ZYzkxVlBHWFVjQ202dUpVODJXUUVJQlE5bUFmMzJNVW1l?=
 =?utf-8?B?bEhyRlU2QStCSFdvWElqUW5panRNS0V4YmYveTVBVFFSTEo5bUk5VUFKTDla?=
 =?utf-8?B?MUdWK1M1ZzhKUzViVzJhM0krTzYyeHFsSEk1VTlrMHVIUkNwdXBjYmI5VHU2?=
 =?utf-8?B?QzlCZUcvbjI1TXpxQkFvb2NrSE0rc0FMbmRPaTBNTjZ3c3psSFVQZkdqemc2?=
 =?utf-8?B?RWFLOXJud1lkeDJxL29UMGhCWFh1TnlSb1poMmYvSnZVbGNUM1JBbUxXZkxt?=
 =?utf-8?B?WklIOGNhdU1sZGNtVFFIajlHZjFkSEl5T09LcHJYaE5rRFBsK1dZWmJ6cEUz?=
 =?utf-8?B?cXFqTTVUODNDRWxaM3A1QzBkZFA0bG1tRm41S2xld3NUNTVGbnZ4MTQwOGk4?=
 =?utf-8?B?Y2hJZFJIWC9WTFh4SzN2MFBkT0RkM1VjYTcxbWZ0ajdkWFdqdFVZMTlmMGpw?=
 =?utf-8?B?UGtDZzYwcUJQZ3pNakovNE8vZkltK3dUajZsU1ZYZk42SEhEUzE3K0RpTmgy?=
 =?utf-8?B?cktldXZIVm4vKzFlcG5UUU1MT1JuNXBUbk1oUzdpb054bytZMDMvazVBYXkx?=
 =?utf-8?B?ME9BN2lIVWVZTnllVHRrWDZaRXFVemlFbFZQUUdCMGR4N0RFMktUWWpLV2p1?=
 =?utf-8?B?Q2JpZ0J1bmlUam1NeElMejdwUDNZcEowWk82NllMZVpSSWNvZVFaaDV0Qyto?=
 =?utf-8?B?ck11VDZOK09XL2tNSHZmYkNacXRrOFJDckMyUjNDZFcyRHRNVEhyWGd6ME9p?=
 =?utf-8?B?Rk1wNEYwZkZ5amVmNlozc3JVZFFybkt2TVdUVHNVNnhsTGRVYWMyZ0ZobnZu?=
 =?utf-8?B?VEpFZm9COUlycWszTFh3a21LbkdQZk1ZdWRkRktybHhHR0pwMnhzOUhnaTVs?=
 =?utf-8?B?NUM2TWtQa1IxWXl1U3BnVW0yRE8xeWpHc21nV3hEZGkrZW8yb2VuTVlGMWFl?=
 =?utf-8?B?RytCVlltenV4d2R3eHNsUlNqd0hoM0h3bUV0S2dZdDVGbFh5dlA5VnJwZXkv?=
 =?utf-8?B?NjNIYkJ5bmZBTzFqZURSNXZxOEhpVUFhMzlzN1RrT1Zsa0NkWEVaZ1k1OXh4?=
 =?utf-8?B?QS9mUlVhd0dZU2UxQURrNWdJT2hUcXVtb1BVNlhsbk9sS0hTTkRaNnFJckpw?=
 =?utf-8?B?NXF6dnkxejRvTDhEdUZ3cTJFb1dFbUYxSGN6VVpGWkt3QnZjTkhEdFZONFhK?=
 =?utf-8?Q?Z/DLuo1DY30KG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VUJWOTFoM3VCRWNHaVFOVmVXbnJDdUUzOXFDWG9hL2FFWDhHYXRQdzVncWR1?=
 =?utf-8?B?bUI1ZWV4eVhhdjZBeTE5VkJacmhpczA0amNUMHFOTi9Zdy9OY20rZ0RRY1o5?=
 =?utf-8?B?OG5YUFR0cXBYZHppWEUrSzgyZnNxa1F5KzVxOEE1U3hGb3hpVnNpdmFvN2RW?=
 =?utf-8?B?eWlENUcrM1lES2wybnp6RkJGa3A5Qk1xQTRWMWJNNTRmdWRDU1ZObm9PR0tr?=
 =?utf-8?B?YlpoaDUrZzJzc3pPZGNKbzhYcjNrV1ZTUlRqY09Pckc5aHZobGFVMEdZWXRE?=
 =?utf-8?B?MmVnVkJvdllUMDhWNGpyc1cyOWU0Ynl5YytCd3Rsb1pYTDE4akVnaHZOSTVV?=
 =?utf-8?B?dDVVczZqc3VNdWRjcU1CbXo2azBWamlPb3l1K0JhRjJoUkErUnBzYU4rcGN0?=
 =?utf-8?B?emdrbW9WSE16dlF5OEp6U2Jid2JJRlAxaWpaTU9GeDBGbCtJSHhLSHVQdjdj?=
 =?utf-8?B?R2hpWmY1emNBcnlxU3Q5R3NWdVJpYXRjb09qQW9nK3RNYktHTlZiNWFBQnVT?=
 =?utf-8?B?QkRwMnJGUmdHZEVEUmtZTTMzV2c2MVQwWTNZQXRrSVRSYjl5bzlIdHlpMVh5?=
 =?utf-8?B?RGZuRkNYQ3BLRTN6SlZuWWJxN1J3Um8vK1hZMTd3T2ZYcjBMQzBHR1dGTk9r?=
 =?utf-8?B?b1JaQzFFcUp1dWJoZnZ2bUhPYXBGcktoMGdxQ1ZvQjdBdFl2dlA1Qk51eGhs?=
 =?utf-8?B?K1dRM21BWG96bE14K3Vac3k0ckJ3dzZVMk1iemx6UEVlbjNBbnB4N3g2UkYx?=
 =?utf-8?B?QW9YNlk2SUg0UWREaGtIYS9MMCtlSi9aL1pZeTZFdEtsdUlqblU2MmhKWDY3?=
 =?utf-8?B?b252b3ptcys1WEFJOW0zU01FUk5ERitjNGZNVkIzQ0MxTDlTUVZxN1RUTDQv?=
 =?utf-8?B?RHFsQUpnK2dxd0FRSHpLelVROEVRcHNjb1UvQURDRUNIUTUzZ0VtYW9kUnNz?=
 =?utf-8?B?NjFGcHpxaVpxanBSQ1FpZS85eC9ocmZlNWo1endQK1BqMmlaSUorMnNnWGVj?=
 =?utf-8?B?ckRta2NMaEZmeFNmYW93ZWVLN010VEdxRGUyVyszcFYrSi9pWlZEYzBOeXV4?=
 =?utf-8?B?WG5BZENBd3lZRi9Ca0I2YVRnYm84TmRrWFpiQjZ3UnFPQ1VSRjZSdGJKdlBC?=
 =?utf-8?B?eDllN1dKWVZpTExpNTAyNU1SZ0RKdHViNFlwUHhNdlI5L21KYmVndWgxQ2Uv?=
 =?utf-8?B?YjBOcmw3MnQ1dGxYcmpmc1FNUVgvUG5Sa0g3TkkwN3lKRjhPZ29aVjQvVDla?=
 =?utf-8?B?TjhmNXgwZStQekRadStXNlFydGZuNEhCZGVQN3pmZXJ5ZzRWMXdoZndEaUIv?=
 =?utf-8?B?bnROeXNoYkt4dHRPRWRDNXdOTGFrRk1nbDBMd2dkamV2ZFVPZU02VmI4OFNX?=
 =?utf-8?B?Rnk0VGNPd09DcHlsUUMvenp0dHM3WCtUK0xXaGtyNkpsOG5SSW5WMDZjWkNT?=
 =?utf-8?B?QmEya3RacUdkRjRDV2RNck5iUHQzaEcvby9mZjhlQzZPajhtVndMYXl3TjNm?=
 =?utf-8?B?YkVZMW9IZlpJVC9sdXVuZW5nZC9va29PY3pEUm5ZUHJscW9zeEE2TVVXU2Ni?=
 =?utf-8?B?MXl6VTEyZjJTaEJOTEhoN2kyREJCdGNkQzJaNHFhUGxqN0FIcGxMMEFUYnNv?=
 =?utf-8?B?eUpleGh0STJsTDFXOVN6Sit6OXY4ek9iMWRnQkRvRUF2S24wamdIcXlZYWtl?=
 =?utf-8?B?cFhjSk9xbUdaSW5zbEh5VVdxUld4T0U5b0NINzFLZXNneVdEMFBVUGJOL3dz?=
 =?utf-8?B?TThxVThiK1V5OVlTcE1NK0lQeUxDdDlZazBieURUamZtVk02Y3MrY25VZFR3?=
 =?utf-8?B?NmdkemRQTCt1bmFtU2hrUzFiczgwSkNidmIwUG0rU05sWXFoVXpTQ1NiWVRW?=
 =?utf-8?B?NGU0TXhDWDI2YzZBTFg2a1V1aDcveW1ubEF4ZzJvSUpNa3o4TVRzOXNkMTlj?=
 =?utf-8?B?U1o1cnNSQ2NxTm5nTWZYZ2JPZ2FHUzN1WlpuM2dqN1F1K2xJQ2xtNndJcmQw?=
 =?utf-8?B?NDZUa2lhM0hva0FOSURMNmwrZVFLSyszNWFDU3pXYmVFdzk3eVFwV0xJanFa?=
 =?utf-8?B?R3ZSMVd5RjIxU3M1bDBCM1lpLzNvU3pCRHpOaXVsUk1RVFI0aTdKWjNkRkpx?=
 =?utf-8?Q?OqV27Mo5Jn9vhaqbpwMg//khz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1237cb95-5442-4a84-a6d7-08dd4fbb1275
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 01:25:04.6887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ynrv7dEfQNJT5YcpU3XqR5jG+OhqgHHkMF3d8fzl42I1AD+28RDaYH+v9C8zWzODZ7QwUrEeQ3A9VkzJ7Et1hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4388



On 15/2/25 01:53, Tom Lendacky wrote:
> On 2/13/25 21:59, Alexey Kardashevskiy wrote:
>> Failure to rmpupdate leads to page(s) leak, fix that.
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>> ---
>>   drivers/crypto/ccp/sev-dev.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 2e87ca0e292a..0b5f8ab657c5 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -443,8 +443,10 @@ static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order)
>>   		return page;
>>   
>>   	paddr = __pa((unsigned long)page_address(page));
>> -	if (rmp_mark_pages_firmware(paddr, npages, false))
>> +	if (rmp_mark_pages_firmware(paddr, npages, false)) {
>> +		__free_pages(page, order);
> 
> I'm not sure we can do this. On error, rmp_mark_pages_firmware() attempts
> to cleanup and restore any pages that were marked firmware. But
> snp_reclaim_pages() will leak pages that it can't restore and we don't
> pass back any info to the caller of rmp_mark_pages_firmware() to let it
> know what pages are truly available to free.

oh right. But there is snp_leaked_pages_list which 
__snp_alloc_firmware_pages() could look at.

Or just replace __free_pages() above with:

snp_leak_pages(__page_to_pfn(page), 1 << order)

so memory leak leaves traces in dmesg, at least?


> 
> Thanks,
> Tom
> 
>>   		return NULL;
>> +	}
>>   
>>   	return page;
>>   }

-- 
Alexey

