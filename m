Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012070.outbound.protection.outlook.com [40.107.200.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855973A4F23;
	Mon, 11 May 2026 16:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778516503; cv=fail; b=KMCIopNi/lnq9A7lGZt4VU3Pj4rP392Cod6CrT4v1kFXi06rfY5F1wSA1wlnzs3+pfbDMowD+JIC3pgbCzAE1BYWZ7OxEWgD8y1fy1xzgXDSrodPbRs9ClzOdiQskQ0GSKFVIXolCs7/KbocaIeuBzv8uBpLMF5/9SxJaJeXxjg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778516503; c=relaxed/simple;
	bh=bu1PPpeA7lOrx0/hShAg+tro/12QRrkuTeZEK8dtavo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sH9F8HI38bBo7jDSRCMuBCyY0guc7hZHhAQZu3xBIs0XCZo7sBAOfJ1YWuaHIjyvlx4fhce/rKQ00ZEasegyBrb2QiKP6WYfUj9AkwKhP0bTEDQXwwovNIW8wOM85mMnWYmPoTDr/RIojUNqpFA0egL4g6mA3t4YMKH7H2thXHE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JlS5hn6A; arc=fail smtp.client-ip=40.107.200.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JlS5hn6A"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s1RzTJkv0Qpb69Q12O3Atb6rs1AfOYHpCnEXUMTg/OXdCFGkKFTgRvladyubl73xI8h1VtxELkDCjvWdKm4nOyM0uVhK1LgfCLjo1Mg41GW13DXS+WI5AcqQwMTFyBozcwP6smvpgj+5KB2q/huyQYW9SudhvwCDzJDGrmb2Galdwnlu46fi33FVm/of4Eu846KYhshi3euUZxubXDmPOztcYCv5Y9NVzHA4jy0DWnsiNqTt+/d1GZRsWz7cuAgUw+fOjMim9EMAgVpjGYzGVzJRGHFm69hx2gzDyeTs1WfzTBnKeLdaKwR5ohcf4B8R0/RXvnUspnI2zIc8/cpJNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=auzcUesPUCu9+YEZM+Aawl2/quXXP2KQX6FETGZC3yc=;
 b=cMr9wlk0JqwG8jS6VuewD5mNAXs2Xt/sy2BjLLdjOs1x//tK6U/8ln/DnSJFg/lQa+P/+xjyIwCawkRl1qgktVoq4ixGxpGh5tPr6D/a1XrnW9/minQJSsVqVmiJGXNIdV+8BmNhrzzpJUoG+Qkxa9oXer0iTkIiMHYrxxZuIg1ELTHuURi0ADm9ysL9qPPFL10qHvo/W/gwDT7H/GUvoDKJcjhhurt2WQ4/NQSq/idMzAwqJNSbtf3uhNVt/d6qZTbg1/LsZYgKGZHKmINYfuHH+mACjTbPLL8S9KEAL6wNT89YCvXwDd3OykhQA6Vq/st902KDrLk3sxrqm7LUEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=auzcUesPUCu9+YEZM+Aawl2/quXXP2KQX6FETGZC3yc=;
 b=JlS5hn6AuVJdM3ZMImIMWky+rZV2jBY4T5MS8n1EXTYD1Ts74kmAcHMQS6+LFd5KbTOf04w0QRclrwaqK0zTj9CnpFUhYl/aeUrFxmKXEpE155X9oF6k13ssTmPyOfG3OVSoDALWMaajBhG4zedYJQZ4SGoDjta3yLP+jCk0dPE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB8660.namprd12.prod.outlook.com (2603:10b6:610:177::5)
 by CH3PR12MB9282.namprd12.prod.outlook.com (2603:10b6:610:1cb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.23; Mon, 11 May
 2026 16:21:39 +0000
Received: from CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::87aa:52e5:4b72:d5f3]) by CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::87aa:52e5:4b72:d5f3%6]) with mapi id 15.20.9891.016; Mon, 11 May 2026
 16:21:38 +0000
Message-ID: <a15e8eaf-c0fd-44ea-ac5d-9a6bc8b97312@amd.com>
Date: Mon, 11 May 2026 12:21:35 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2] crypto/ccp: Introduce SNP_VERIFY_MITIGATION command
To: Tycho Andersen <tycho@kernel.org>
Cc: ashish.kalra@amd.com, thomas.lendacky@amd.com, john.allen@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, aik@amd.com,
 nikunj@amd.com, michael.roth@amd.com
References: <20260501152051.17469-1-prsampat@amd.com>
 <afitM-Ub50JsTCHz@tycho.pizza> <673592c4-8eca-4b84-9f60-7020327d1afd@amd.com>
 <agHl3ow90IdKTS72@tycho.pizza>
Content-Language: en-US
From: "Pratik R. Sampat" <prsampat@amd.com>
In-Reply-To: <agHl3ow90IdKTS72@tycho.pizza>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR10CA0012.namprd10.prod.outlook.com
 (2603:10b6:610:4c::22) To CH3PR12MB8660.namprd12.prod.outlook.com
 (2603:10b6:610:177::5)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8660:EE_|CH3PR12MB9282:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bcc654a-8137-46b5-d72f-08deaf7960d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|18002099003|22082099003|11063799003|56012099003|3023799003;
X-Microsoft-Antispam-Message-Info:
	pjhqbHeFe+sRs5Xu0H50VXRao81fydW9Eqeg7GbTTW+O9gXEiF2nEYsBdNmbPpr3F3dX79Qf14I9a9zzuJubyOFKHuPKrtvk7AisbqkCZthlo7RxuRxbO0SFBSVro4cm5V/8uHBzmmEykUIlukVUFHUm203Hxbsueltw3ilpszaMc1aehXeRk3tXh/rnvZJH2ZorlGV9wlhWjOT6UwUBfyn4FiyhJ3DHS79In+Z32MzI1Bmf/gpP5QXVQD+WbAvfoqmruTb4USqsSqTPCAOL1J8MPAIhewZNelcropXlYcuEL4EFkDX+l8C1+a8K9KXf3h7OcSqP1gybBi/jlh5fF/RdZDt3CqsTF7LyNouoQu1I2SQvJP+Z6AOZhQeuYmfysC5PLKJBfzxgzxA8vfDeaF5a8iEnQ4e7dQGwB2E6B5bJx3uuC5hTZWnHNYagguujFlrtFUCY2lS+FrUgMPK1fKYyILIc9ZBOFBt5ZM/Vwq2CtnuNVDmwBkFE4O8qxZ7QZ4xXZXQZMlpdmh1lJ4lMwKDO1Q59iDja58FrvfetnywPWdqEVCtnS9/MNUpHRqyKZxWbkzJuBa+ROFw7vlvCJjx9bjvk0aihAz0VOQNakjV/G7yNKxmdhF+Q2y9+XTgX4AmxNrh3lTN6vkbqwAZZfLEKgrEiFBfpgRvuyFTNR0GKfEx8yhkyS9vwUHqY3rYq
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8660.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(18002099003)(22082099003)(11063799003)(56012099003)(3023799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V25BN29CMHdEdU9PVHZpVWVWUnA2OHNheEV6TWl1VERlMXFtZGdpVVlHczdi?=
 =?utf-8?B?b1FsRnNTc0V0VWhLUkw4NUhJdHRPR1dPaExvZUg0WVB6SXdjMUkvTzFucWYv?=
 =?utf-8?B?L1ZTZ2MxNzBmakJvT1VIaXhBaUVpVGhjOVVoNXM1WEJyTjNzSi84bkRaWjhO?=
 =?utf-8?B?K0FES3dhSUxxamZCa3dkdER1T3FaMVJOeDlzYTRkY3ltSE5SWmh1RGpmVmts?=
 =?utf-8?B?ci9xaWRwUTdHMlRSQ3RJRFd0Z3pWd3FoUXZxRlhaVUVadTg4YnFUUnZVd0tv?=
 =?utf-8?B?KzlCTUxVbGV1c3BaSk5FVVFDUW1VVU9jM2dXSEZab2x2UHA1TU13TjRHb3dq?=
 =?utf-8?B?NCtVVmNxWHVUbU9HWTlOa0VreTFuWDk2NmtzMm9NTEZOckdHY1hCT0poUTI3?=
 =?utf-8?B?N0ZWVWRnbkxWdCswaDc4M3hnLzZiQ05SZFVrYkZjNXJ5RElkV1JWcU1Qc1NU?=
 =?utf-8?B?MTNxNDBQbTQwckswbG1xUkRJZnNtWmNTYmJ6eVBrd0dMNzdSMU5BTTRUWTFW?=
 =?utf-8?B?d0lpVytpNjZRZzdPVlViVXJkSVJoaUk0aUFqQ2MxK3NUNUI2aWpYVE9XZUls?=
 =?utf-8?B?U2RKL1JZeWlScm5BVlowQXVXSzQ2TjdlYjg0TnJIRDZOVFRUQ0VvQzJRTGh0?=
 =?utf-8?B?SG4rYndGWlNmQndZdFhMN1hSbXZJZy9qcDVvMWtNN0NwakttZWJiV0pKL2hF?=
 =?utf-8?B?U0ZCNFlMV0hKWUREbjJYeUk1dmpReTlOMUtBY3BsQzVOQkpuNURONUg4TkQy?=
 =?utf-8?B?ZWpEdjFYVWlSNDVneWMzczZsd3RuYVYwWnFKdkYvRnNTMmpONndPTHppUWQ1?=
 =?utf-8?B?NTlLQ28wUitPQ1laZDZ5Wk1hdThQQXB1bXpEMzd5M1lPeURFSk55OXNCWjEy?=
 =?utf-8?B?d3RaSyt6MWgwdlViNVN4d013TW50YTJhQU9BNWNwU2M4MkFPSHpGcGtEeVRo?=
 =?utf-8?B?WnZubmVzYmQ1TW51WHNPR1YxQ0F3a3UvY2pJaVpXY0VBM1FWcy9NemFUbzRM?=
 =?utf-8?B?dzg5b0xzWjVicDFhN2lGUHJXZEY5VFVvaVVFdjdLVGZaSEFWcS9wMS9kRDI5?=
 =?utf-8?B?ajJ1d1RYZVYySWlweTJMOWxub2Y4NVFFMWI3a2JkSzE5ME4yY055Mm5wbmFL?=
 =?utf-8?B?a0FyQWcxVzdNRGwyeDdRS3Q4cE56R3ZUVEZsdC9WRlNEYUY0Z0s4aC9jd0pF?=
 =?utf-8?B?T3pNSWh0WktjOXJ3VnRla2dEdHRYY1BKZG5lZDRnejVWRXVFSTRZQnc4ZUNk?=
 =?utf-8?B?UTNPUE41eVg4MVlDNTRkeUw5aEh6R2l1Wm9relIrcUhPU0tla3hXVlBGT3Z5?=
 =?utf-8?B?T1FlM1ZKby96RkE2L3Bkc0dibVd4dVVwNjE4dFF0L2gyQkR0YVc4aFRwb0dy?=
 =?utf-8?B?M3lMUUxSdHRuTXNzRmlkRFZpQVFNTXZQMG41Y0IyNnBaRDhhaGhiUVRPNEov?=
 =?utf-8?B?bVlnemtFOWtLeGhmTi9EeWE5N1BYdDR4dVZqM2dpS2RReWVzWFRVR1EzYnY3?=
 =?utf-8?B?L0ticy9OTDFST2NrUzJZNkZhbW9PS0p5TDVGL3dNaGV2aWh3UFJyOWJRZzhS?=
 =?utf-8?B?NnorU3JsTDlaRFJic29vN0lOdU9UV0N1eS96UHl2NXpBVU53elhHdHFORzZE?=
 =?utf-8?B?Z25OT1U0Yzl6RHBKOEJDcnhmUzM3YXdaN2twU1h3WlN3eVE0ZHpBdStTVFFp?=
 =?utf-8?B?NXBhM0JvZHdDWmJyMElpbFRRSi91eGlaWFdNMVcxWTRxTEZyd2pTSVpoUVNo?=
 =?utf-8?B?anF5WHR0LzdZNWtZYnpUUUxLNldlZXpzNURzZTQrb0htRmN5Vk5FbElURzFX?=
 =?utf-8?B?ckpJQmZ4WkdWNm5pRnRZLzY2TnZNTVVyM1JOTzFxNVM2NTZkTk9zdGxqOFZ6?=
 =?utf-8?B?MnNhWE5Vdk95eU4xd3lDMDdWRjhFS3lDeFdtQ1hQSzUwbEdDRXo0Y3NINnkx?=
 =?utf-8?B?bUl1U1lPTzloQnc1dTZSdWplb1NhQnUyc0FoMDM4YmJvalZjdXpKZzVqdzhP?=
 =?utf-8?B?aE02S3Y0eElSelM5V0lkNEVmSEhsSE1wdnZSNUVLY21RbGZhcUdseFozdDFR?=
 =?utf-8?B?eVdaOGJYa0JyWloyaFM4Rk01UEx2cEhVMEtVS2U0SG1SMUVIV3FiaUNEOGxB?=
 =?utf-8?B?cXdPeGxKZ0s5Mklqa1JKV3VUVWZ6M1F2cm1WcGpSRy9Tbi9xMWRLUFRSaGhk?=
 =?utf-8?B?cnJZaG1rdkYvOUlMS01EckphNjhZRjhoMVhZWTQwQnduK1VqbWsrQk02SjJK?=
 =?utf-8?B?ckJCTUdLT00ydXZUd3RDbFRXUldXYzJMWGE3RFJtT1c0WVFBNE9nbG04cDBh?=
 =?utf-8?Q?SZEijFrG+iT+INNf29?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bcc654a-8137-46b5-d72f-08deaf7960d4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8660.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2026 16:21:38.6467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BeHPsMQeE82o6LfzIlqkikIM9+eG0xLGBQOYBGLG0h1QvQlvMdQqsdqLnNwPB9IMJmgKH9bC10IBX42poO2ZJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9282



On 5/11/26 10:25 AM, Tycho Andersen wrote:
> On Fri, May 08, 2026 at 05:10:52PM -0400, Pratik R. Sampat wrote:
>> Hi Tycho,
>>
>> Missed this one in my mailbox. Thanks for the review!
>>
>> On 5/4/26 10:32 AM, Tycho Andersen wrote:
>>> On Fri, May 01, 2026 at 11:20:51AM -0400, Pratik R. Sampat wrote:
>>>>   - failed_status (read-only): firmware-reported failure status from the
>>>>     last operation, as returned alongside the status vectors
>>>
>>> "from the last operation" is not quite right here, it looks like it
>>> re-runs the STATUS command and reports that error?
>>
>> That is correct. It runs the STATUS command and reports the status of the
>> verification operation. Probably better to phrase it as the "last verification
>> operation" instead?
> 
> Hmm, I'm not sure what you mean here. The FW spec 1.58 table 132 says:
> 
>     Command to request the firmware to return information regarding the
>     currently supported (available) mitigations, and then the verified
>     (processed and completed) mitigations. If DST_PADDR_EN is set,
>     DST_PADDR will be populated with the SNP_VERIFY_MITIGATION_DST_PADDR
>     structure.
> 
> so I don't think it has anything to do with the last VERIFY operation?
> 

Right, I had missed that. Table 133 says failure_status is the status of the
verification operation. It also looks like calling STATUS repopulates
SNP_VERIFY_MITIGATION_DST_PADDR anyway.

I am not keen on caching the result either though. For simplicity, we could just
drop the failed_status interface, log failure_status with pr_[err|warn](), and
return -EIO?

> The spec is a bit messy here, though. Table 131 mentions a
> MIT_REQ_CHECK operation, which I assume should really be _STATUS. It
> describes what the output VECTOR should be for VERIFY in table 131,
> but not what it is for STATUS. Table 132 suggests the output VECTOR is
> the list of supported mitigations, which matches what I was seeing
> when I played with this.
> 

That is a good catch! We should get that changed in spec.

--Pratik
