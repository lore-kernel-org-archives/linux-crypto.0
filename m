Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011054.outbound.protection.outlook.com [52.101.52.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20073F3268;
	Thu, 23 Jul 2026 20:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784839168; cv=fail; b=lCRq6fBNegTTt8Qw8tbvIzXr+13AvlYSOQthNAO7VP1I5vqEjuToZJ214Bb9pkRDjrkrTG2jX60VNBXuy8I5lChmW1ECb5PrnNX6YQVZLkmGzmrd5NncuUo+YQdlB080jO+1PLcrRFRztfLZR/EvqUT5ehfoztOvQ5Aq2L0atNc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784839168; c=relaxed/simple;
	bh=hClNZZZVkwZVoZRW7FrXmN+515sZFc97od/DlhQmj6U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Q5KRX4nY1MeUvfpckzJHuXNNklHKT7UYE92qCkc2oZbIQTmASgIRUsvSf+9NSWJqssqqDraaItsstxoQXtEvDzX991I4kzydGb3PQ4FVnj2uUj5KI1MTUCa3u5/I4A8bahZzoyFs8TP6BeaDHrnzdP0Dvi+eOIu1Z5qF8vfUQ+Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TbqoT0z2; arc=fail smtp.client-ip=52.101.52.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TbqoT0z2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sGC3/zJ3rTp5dx+zf2wwYabMZzFJijQnvUlcwXFpXaZHTs4YG9Bovy5paNDfh25o18u7Xr05O0E9irE/pvVYQ3U/h5rFJn4j8MnjKLBTCOGS1emITRo8VP4aYxLrdy3ExLZDbfXgd9P2TD3a7VMb19rwGiwDA6zFIh7PUx9JAoldcZJbjPSZQAeZxqUYjnB0Jh0SLnPRB354WmAs7MY6BjFONcNlbpJHXR8t42I1PwhMbJB4gBngA/ngbNnXRNf/qGL/52cIpxcLacdn6i499w+zXLhD8wc6jbpMG4zJqsrWgxjNLovN0AW5WuIw1R9Qkk2pVJN9w1F2/Xoib29pDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TCdqTrbASff07g5rZnVdpAfTefaRbhEStLAKVF5LVJU=;
 b=WCBzARa+xLBG7BAtincewvI+vxY4jSL+s676LOZnPRXJJZXJeeS5xPwoYh6gjSrslXfv4ucQ/BdswDFE8x7/U5ZAUyYL0fLKGDQb6esM/B7h3GXasG0OQCP4MUkoJB5bvxKMcpsgSmmbjdybhJ0SRPYmMJQ20srynje123drkTtHwPSnHp1GsAnOMVNRVpxDNJOV9ximKirgjXE8Wb6md2FXfGWyhnCv78ZKjGWWmZLAORAgAlHHtth7fB+9fIjSYYH54YprbDiBP/cxtBmY+X3IevFZth3+ugYiM2kc5DtlvMB4rn8FbUuoFkABkK2NF8GO+D5CXKG4HNlZ6jHp8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TCdqTrbASff07g5rZnVdpAfTefaRbhEStLAKVF5LVJU=;
 b=TbqoT0z2biKyzpk6eSaOL/TuP6oT39MLa0czbBj0+NkMN03KBheDkx1YeYBAkmOr+iUTOA9dKgakLHfRLAbrWwuE4xDJPhRzpYVzKoJIw8hNEnouY8U7FK52Hp0Two1ML2WCoZQ0DX8AJz3bOettxa5/0uxN/PD2hukbHg0gvq8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by PH8PR12MB7327.namprd12.prod.outlook.com (2603:10b6:510:215::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 20:39:15 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 20:39:15 +0000
Message-ID: <b1a5e1c9-481d-4c70-a058-de4718618891@amd.com>
Date: Thu, 23 Jul 2026 15:39:10 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 3/6] x86/sev: Disable CPU hotplug while SNP is active
To: Borislav Petkov <bp@alien8.de>
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
References: <cover.1782841284.git.ashish.kalra@amd.com>
 <205a5259f9fd353dc0ca6b00565c8175a96768c7.1782841284.git.ashish.kalra@amd.com>
 <20260723185323.GAamJjI2HoM1gZmExw@fat_crate.local>
 <404433af-b908-4849-a8b6-1c1ee9d33d8e@amd.com>
 <20260723200003.GEamJyw2W1nMPAUdHc@fat_crate.local>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <20260723200003.GEamJyw2W1nMPAUdHc@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR08CA0002.namprd08.prod.outlook.com
 (2603:10b6:610:5a::12) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|PH8PR12MB7327:EE_
X-MS-Office365-Filtering-Correlation-Id: fb6ae976-054e-4c82-4abe-08dee8fa75a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|11063799006|56012099006|4143699003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	sQ5xD2HhujF4AssUW9fQ3u/v41P+jv7u5nTvStQnXtrdxcXB79OUXr7hZOKBG9kzFnzSBTlFT66Zsw+OxXpiYTAyHJ9TnoG6EwqGrrY2LgramnSmDgR481UBu21odVattxVhc+Rg+UasFtLDyijhvAUYwKQBGsspz9/UVlqGP8HM2tmf5nx6Es+Y7SZ0/bp8AMO6HI6XxtdU0I7AfgcNKmN0XYjcVw25X7NLPw2KpS0hy9jVc4fXIn95i6PwDqHCj1oHCFJ9DXCDXAAQmu8flp+cWF91OocdKHv500DMHIgWzc5lZ5Dvjekhcm+OPa7PnPetwCT5xHEeBb4L03Q20bTYd9Gxa+oNpKLjdG7fzAmllNmISoDARU/YIwMlIRxv+Ip+ye3UyLfymlSnmv1oOV3/6Avqt5//tq+8QfEeqltKYpFC34HpB0S9e96OmRGKDizMLL74fPEPgz6K/bufjpOwIVfPhEdDGWFJdjJdimZ1qJFQcgdCEkpllg0vZrctKPgfIIGWPWM5u0+Fl6QQ3GwlBEQFqj7OGKI2vTBJ+N6m006o1FBKPeI9Ertwk5OR2+FB7+RLZYDrkXZ0tjGwuxgl1K4DRzhOwhwC+MrbWho3/hQOJwhsKIX5fo/fUcXoeaynpYHU+tdZSVLwidR4FTJB0HnExI7AJ1TlZkfD2d4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(11063799006)(56012099006)(4143699003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cENpUHA2WVplVkJiRmhQWGxSQjBjeDAxWERsak9FUE43a0R2QXIyQlVxL0V5?=
 =?utf-8?B?ekNLQWtQdHNYKzNTQzJNL2Mrc1MzRHZHSEFtMU9qRDZoa3o1NmhsclNTQXIr?=
 =?utf-8?B?Z256WEszSy9ESmJlUm43SEM3L0M0SUZKTkg1WVJxVUxhSis2bzNET2ZhUC8x?=
 =?utf-8?B?d2g5dDZSYmdaRWlkdlQ5MkxVeXlsWjBvZzNlc0NJaUF0STRINGx2K0h1NVA5?=
 =?utf-8?B?ZllKZUNURTJSeXd3eGNJdEZYSGNtMW00U2Z0Z2tITXUxT0FVR0R4R2l3NEhM?=
 =?utf-8?B?T09PYzdOelNlMW1iNW8zS3B2TGRxNHJ0T2hFLy9SQXJXOHpFcUoxWVFYSExP?=
 =?utf-8?B?dUJ2VkhlQXBUWUg2ZTh2R1J4SVBYdm9vYUc0S29BSTgrMzRCK3NIK3U4VUo1?=
 =?utf-8?B?MGxYcGNWYlBoYUhIVTVoVmxjSmMvcXRTYy9OMmlMdkR0SktjczlhT3Y2Vmgz?=
 =?utf-8?B?eUt4QjdFM0VmbXBBaHZ2T21xc2U2YWErZFQ5ekc0ZGxnaVRNTGRLQm9BV0I2?=
 =?utf-8?B?ZVRuMERzWm40eFd4SFV0aWVhOHNIcndEMFlvZlZnUTBZZTg2NjVFUDhSQmt2?=
 =?utf-8?B?L3luaUN2SGJKcmFTejZOTVNTM3lGaVRCUmtoZUg0MkVvUHd0QncraGtMWWYr?=
 =?utf-8?B?ckJQcXhROERkOFZiUUJVZ05tUzhRcGd3bXFiaUJMQy9lNEN4MVJzWFdSNWdY?=
 =?utf-8?B?UkJMVnR1NFVxd05PYWNBSVFyeHVXRmltck1hN0FrZXNrRHYyT0g3czd0SnE4?=
 =?utf-8?B?T0ZJVDA0OUwzd3N5ZG5Pb3lacXhRYWpTN3N1T0JBYnU3TFA4NGw3T3A1dGhE?=
 =?utf-8?B?MlQ3YytaZ1BNb0VqYlQrT0lJNnlPd0lBQ2xFUUVTczIxYVRzdzUyNVlwTkNq?=
 =?utf-8?B?aWFRSDkyK3FWQWZ4TE9tUForTi8yd05xUlpMNlRtcG9XL0ZUMTlLcUduczA2?=
 =?utf-8?B?cXFKTnM0aTB3TmVoQUVWYTlVWElkbmZVWHhkYWRLQ1pUVU9zbFdTVFRkTUtl?=
 =?utf-8?B?WmRJZ3pXdndET3hvTVZtRVFGdEozajFKZzlUUGFWV0pKZ28wMHlPem5BYjNG?=
 =?utf-8?B?ME95V0srVWJRTU5nZllZSzYvbFd1bE9GSDdmcllYeDAwRTB3OENML2lHUmx0?=
 =?utf-8?B?ZzlaQUs1VDNLVHY2L1J0bm1nMDVNelNEOVNrL2hsd3VJUU5SajhYak03ZkdD?=
 =?utf-8?B?N05FSHNnMm9pSngxcFRxRTZaWUFQck5sKzJwWWdBeHJRcTByVGFpYlhGN1Ni?=
 =?utf-8?B?WDRadTRBengyaEVGazFYN3AzMjNFcDczbEkzODltYk80bXZOOVhsSW5STkEv?=
 =?utf-8?B?NUNIbk8yOWpmRVhuS1pyeHhpakNua1RHdjEwMWhMQ0hOT0ZjSE5KQm1CMjVO?=
 =?utf-8?B?b3Roa2hES1lEU0VhZWVmVU9tQnRBSlNSc1hkZWtZZ3l0aFBHa2IwTWEzdW5I?=
 =?utf-8?B?ck1ONVY5TWF6TVlaQ2lVcFNwTWhYT25BQ1VHTkVHbmNtWkVtZUxLa2RoR1Zm?=
 =?utf-8?B?RENzenh4YWhpRjZVMmFwUUVCYmNqM2cwOW5FS3REaytTOUkwMkdES3FKR1pM?=
 =?utf-8?B?R0tmQTg0Q1U1YW8zQXR6K1ltaU5oT3JXQ050NjRGemR0YU5oc2hCcnhZRHdz?=
 =?utf-8?B?WFlrTFhFZmtUTlhETC9LU0VWbDRyYXl2VklYTmRvNVN6cjM1NEFQdDgyRERI?=
 =?utf-8?B?QmRsQ1NtcThXK3RKaUY1V3p2WmhsZURhbW9kQzF0REFSYVdGN3Zac3dpSGxw?=
 =?utf-8?B?ZXJaWEY2YktCdVN6UktuRXA4WFlxKzkrSmRQVDRGUXBhRytsQ1EwU3hvY3A0?=
 =?utf-8?B?bWh3cFlDeng2N2dEYnplTG5qcnBjZ3VUL0xyK016dTlzMnFVbUZsQUlrNGI4?=
 =?utf-8?B?R0sydlkya0RqRFEveEFqZ2Evc1JiSXFaWUFTTDJXNFVYK0ErNGd5MGhTSkhO?=
 =?utf-8?B?bFZkbzIzRmsyRUZOeng3QjRxdTVUV05kTVhzZkdsU3JJenVGQlNJWW5OWkNo?=
 =?utf-8?B?bHVabmVPMFZ0UnhmSVFRY1NwRHRFRm42dXYzRSsvWi9laDFqYWd3Zi81andZ?=
 =?utf-8?B?cG1XOU1wMnBBM3cxdDBaeEw4UEtDcnIzL2hiQkszK1BQbThLZUdOOXB0d3Zz?=
 =?utf-8?B?b0RVUitPKy9KNVVmTTlLVzBhRE45NG0vMVlCWVI0cWJ5dXcrNmIyRzlhWE9I?=
 =?utf-8?B?MFBsbmk5NDR3Vkg1L0h1dkJaRFBNLzRoZHJRbHRkU3lNbEQ1WHU0dXJBVkdp?=
 =?utf-8?B?amJESmhoRW41eDNKaGw0Y0FjbmR6WTZTZFdSYlI0ZERXcEwyUFpQcWJTWnRY?=
 =?utf-8?Q?GsNCYn2jHUQdcyfQUO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb6ae976-054e-4c82-4abe-08dee8fa75a3
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 20:39:15.3172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wRywd88D6x1m9iXjyeWnRaH0S2Ay8o8JOyRIQhaKeSS4XgRchjMldZEomM1qfOtLfHF7+eql1v/D7UFu5RQyMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7327


On 7/23/2026 3:00 PM, Borislav Petkov wrote:
> On Thu, Jul 23, 2026 at 02:44:47PM -0500, Kalra, Ashish wrote:
>> Actually, i will have to remove cpus_read_lock()/unlock() across the whole
>> patch series and also in the original code.
> 
> You need to do that in the same patch which adds the hotplug disable so that
> there's no hole in hotplug handling when bisecting.
> 
> Make sure to explain why you're doing that in the commit message.
> 
> Thx.
> 

This is the list of the consolidated changes:

Patch 2:  "Initialize RMPOPT configuration MSRs":
  - Renamed rmpopt_cleanup() to snp_cleanup_rmpopt() to match snp_setup_rmpopt().
  - Simplified the 2 TB RMPOPT_BASE comment.
  - Replaced the misleading primary-thread comment with "…only one thread per core needs to set up the RMPOPT_BASE MSR. All
  primary threads are online, otherwise SNP would not have been enabled."

 
Patch 3:  "Disable CPU hotplug while SNP is active":
  - Used your commit message.
  - Since CPU hotplug is disabled while SNP is active, the online mask is stable, so I dropped the redundant
  cpus_read_lock()/cpus_read_unlock() in snp_prepare() and the cpus_read_lock() in snp_setup_rmpopt()/snp_cleanup_rmpopt() —
  all in this same patch so there's no hole in hotplug handling when bisecting, and explained why in the commit message.
  - Dropped the superfluous "SnpEn was never set" comment and rewrote the snp_shutdown() re-enable comment.

The RMPOPT scan in rmpopt_work_handler() (added in 4/6) is likewise lock-free — it runs only while SNP is active, i.e.
after the hotplug-disable patch, so it never needed cpus_read_lock() in the first place.

Thanks,
Ashish
