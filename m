Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2040.outbound.protection.outlook.com [40.107.93.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7227B1B95B;
	Mon, 11 Nov 2024 17:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731345238; cv=fail; b=B9JV4K5tTWUQGzcrPpW9QZOaUUfoO/WCeqgmz3LRLbdZhs4wgwvhYt7kWKN6IOYrhO2AjsHC2XJSJ9qXNL9v7ol5Uho7Y/1V4LP/4JWN8NYeNoAc/tjkEH2vSNFwI8mqey/tIHygw7Tfq3E/wf7OTs4+O8ryBnavBeI101owulc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731345238; c=relaxed/simple;
	bh=Hq7jb5qG1yDy8sUEEaFnIZcPBIY7w67iV6FcnEc9V3Q=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=D9378kqlEt0q9MbOwPIIaN2TnSkTZjVIsm8O49wy5/PaFFEtJ0yTuX6gK46k/pQLWUfDpGNYzTcgqiGn9dA3JdtMl2IURwgSGxrFZh6Wgq+If0QHaYgHUnCgM4Tb4gETtRznIiGrgimwo6KdSAqDTNW3hGEQWkLumTEcVAcdZrs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GnOcGjuE; arc=fail smtp.client-ip=40.107.93.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GnOcGjuE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oxlHQGtJi3qQjz9Q/qZsnQIzrk7hU1fQu8iAXGXKht3MTqIc5uVaO1b5qLKs/dag8rstZyPEK3mGBBSbLzdLogthSc6JCTM60oOMOvUq0sndY4R3/vacxryVQCPEcWsrhSk7M3UBRhAw+lJzEdhY5MvDikZPurGjA++q9hr/4FqfZC8SpAFMmbRzX8pLAZykVE4FRACYTa/d4hszY2YVQK6PS30MUx/KICQSAAskRUf0NkZbf/gTYInokfd6KvuGf4gwWbZW9omhD+Njf9PpN+nES8tC5yOtCdyZ0bndZdOVT49J5Gv7NtNctCyH7PDDJ0o1beuaojJUHxKd9uBs/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j5i+qviQCLpr7O6qUlVV7a8ApFitu3Kp60TKWTC9jsA=;
 b=f6ULMD/a+Wr+AiHK9E2tmSJUrHLxNxiG0jfj5Rj02MAy9Ol4O/7VE8lBHdM/fQ+I7Yua1lyIHCKNwnzudGE2dzwiBv9e4LAWeb7uD6vb+T8WWbMgCzW1dwQl+DVYGtykPyXrfnzsyN2HMZPtQt2U2yPRUwLtW5NrLLumZfvxbsHVBH9BywHXvIVzi9OuqHRxuKiRHJDhG1imj1nn43h1TFa+jHQiYHZ8PgqvUwixwNK/L/XDe0BzilIXjoQnccQgWh0IYAHxRl/+afg0y8wKqAui5JRcQlX0pqJ35eoXta9l76zP5RizvgWuPlEylxWdaa3xF+Sp0zGm+gNTdW2hkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j5i+qviQCLpr7O6qUlVV7a8ApFitu3Kp60TKWTC9jsA=;
 b=GnOcGjuE5y2K8Xe//kg6hx8NIoG0HhN8Y30MohiFjsNHLQFrLnqVsglDQdEPIbWut8GkkrBDsWaExqlVmbK+75mJf6SKtmPmxGAJJg2gCy9VVVp2VpmJe7mXCcQDdFmE5xK0O3b06UfA6VRdbU2tvNHZ00SyE6gAQR02vsaJgx8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB7307.namprd12.prod.outlook.com (2603:10b6:510:20b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.25; Mon, 11 Nov
 2024 17:13:51 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8137.027; Mon, 11 Nov 2024
 17:13:51 +0000
Message-ID: <d2f7d2cd-9019-47d0-a4a9-01918cda32c3@amd.com>
Date: Mon, 11 Nov 2024 11:13:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Dionna Amalie Glaze <dionnaglaze@google.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
 Ashish Kalra <ashish.kalra@amd.com>, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, linux-coco@lists.linux.dev,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Michael Roth <michael.roth@amd.com>, Luis Chamberlain <mcgrof@kernel.org>,
 Russ Weight <russ.weight@linux.dev>, Danilo Krummrich <dakr@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Tianfei zhang <tianfei.zhang@intel.com>, Alexey Kardashevskiy <aik@amd.com>,
 linux-crypto@vger.kernel.org
References: <20241107232457.4059785-1-dionnaglaze@google.com>
 <20241107232457.4059785-6-dionnaglaze@google.com>
 <71db9119-a667-96c1-7aaa-4f0241f203ea@amd.com>
 <CAAH4kHaVDTokOR9BBbinXkw=Hk3ztYoiZOK_77JahmQ64vjK_g@mail.gmail.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v5 05/10] crypto: ccp: Add GCTX API to track ASID
 assignment
In-Reply-To: <CAAH4kHaVDTokOR9BBbinXkw=Hk3ztYoiZOK_77JahmQ64vjK_g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR08CA0028.namprd08.prod.outlook.com
 (2603:10b6:805:66::41) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB7307:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f5cb723-b26c-4d1b-499b-08dd027436ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SlJlOWdjL3pMaTFraDdzb0FBOUMwVEFMbHIxRW1uOWplL0lYWlovS2FNUlFh?=
 =?utf-8?B?MXpWWmc5VjZxYUozV3Y0VWc4L2Fqd1dYU3FkakFXUnE0STNmYk56UXlrODhw?=
 =?utf-8?B?R2QzNFhYbWhCK3NRRFZyUmRzTm4vWWlRWFNONVFkeERwczlqUEVYZ2QrWFlU?=
 =?utf-8?B?NVZMS1E2d2l1QzZPSVVKZWZMalQyOTM2ZFdmUnFKbSthTVMwa1J5YlJIcE5w?=
 =?utf-8?B?UFE2L1R4VTR2MU5BK0JmMlpBaER4aElFVXByVzMvbDk3Z3FQM2lPRTc4dmov?=
 =?utf-8?B?Rk15THIxaTRON3Y5WDRSOVhEWTNYTkVITWxudFhyWXp0Uy9xL1ZwRHBFYjU2?=
 =?utf-8?B?TWQvVmZZUSs1TitDbTJ6MXJQeWhLSVpjQVpjNGtkMXpBV2M1UDhrZHF1cGlM?=
 =?utf-8?B?bDdOSWFjcFJUQTNnTm05SHUvQUJwRDljS0Jtd0UxTGExMCs1QTBKdkNHa2d0?=
 =?utf-8?B?MUhNRzd4VFhXMzlVRE4zMGNhdDYzUjBISWQwZy9FTkpPTFp6Yi95UlpVSXFK?=
 =?utf-8?B?ZFdHcktKZ1FlYXd5cEc2SFE1b0k4dU5uQWE3SUpXcDd1SDFnSW9oa2d2ZElH?=
 =?utf-8?B?WWtEWllTWGsrdE52UDEvM0dxSjUwTXB0amxiWmZNSzlrUUR1RUFPdnFGdHJT?=
 =?utf-8?B?TCt2S3RQd2pnMkJOZ2NPQlpjenUwSlVmZTMwbUtBeEFhc2NJbWlSNXRkWVgx?=
 =?utf-8?B?dVVQL0hwQ3VLb2RwM01DQzRHNFJ1ajdYR3NFejkxWnNhSTIyL3RBMDc0THhM?=
 =?utf-8?B?cUErTVpMbDMwbkZIZmNVcGI4eGt1c0xnRi9JYjM0VGwxZWlFM2lKM3ZWQjgz?=
 =?utf-8?B?Vnpxc1Q5MkhIcGlYUTdVWVhHbUYvZm5UOXJwN1JwdmYvUmZyK2hvVCtIU0lZ?=
 =?utf-8?B?eHRib3hESE9QbjNyUHlvQVBNYXU2c0I1dnYyZVJpZ1puOVE1eTNCOFdRb2VZ?=
 =?utf-8?B?aXVjY0cyZ1crQlNwWmdnS1NzejYraGJnM2hWcGxxQUI4UjBKK0R1SG9jU1gx?=
 =?utf-8?B?MURPUDAweERUSTc2RCtKRGdlekl6QnlyMFJUY3NPSDBBUHdXaVFjbXlNSEJm?=
 =?utf-8?B?YW82cnhGdlVXUVhDL09SSjRuVmd5NHZrM09FWmNUTmNFQUxpWGcxei9pbTVo?=
 =?utf-8?B?bjJXcXFvU1VBK0xLQ0xLSXdGeTdsQUFXK2lCdW02KytCSHVsb2JEZGJJK3Mw?=
 =?utf-8?B?SXJWNHJQb2lUWTA0V1pPQmRET1hVTkw0blhaenZsV1pnTU56WWFibHQ0SVlP?=
 =?utf-8?B?SndYMDUwTi9kcWxzM3FnbHczaGp6MTNsR1RpNkl1ODhRclhncnhMWXlYRFdC?=
 =?utf-8?B?cVhEYTlCcG9YNFZsNS91UXdUN2RRQi9Rd3hFVEZaa2E3aUxmVm5xNkRLZGRZ?=
 =?utf-8?B?b29nU1dFWmh4ZkVBWU4vai9iL1EyWXdrMkFtbGxid3N4YmFMNGJYYmpjdmlV?=
 =?utf-8?B?M0RRYjdxNzNjTi81dGszWDIrMmtQak01ajJvMWU0SFoxZHNrajJqOVhMVU9Q?=
 =?utf-8?B?ZlU1V2VqU0d6ZEpoeTVUOU5DN2x2eGVGUVJLRzNWTGpIdjMvY1lHaXMxY2FR?=
 =?utf-8?B?dGFiYzhpRlFsaWcrMmNPWEJMcGRXYnFRMFRad3c5K20xOFRvVWhHalAyRjNZ?=
 =?utf-8?B?dTNVelJHR21vWS9nOHFiaWhTT0lEVkd0SU1TbDY3bGF2MVVPdXhkNzVVNnRr?=
 =?utf-8?B?VmxoT1FaZm1hVWVpMzhEMG8zREtyL2JpR2R1S00wOExseHEzcGxhN1Nuc3Jj?=
 =?utf-8?Q?R/psw9OuoCdrid3AhCoJNT6Ccj5Y7b31Vy3TS9z?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q0VOVmxudFpRYXJkQzdLVS83SVhhNFBjK2RrR0lrWmljekZXallpaFFNdHBw?=
 =?utf-8?B?YTZiTy8yTEx6VUovOFp3ckwvcFJ3NnRGU3Bnd200OGdSaWRwWGI5VmRQb296?=
 =?utf-8?B?VTRiNlA1UlFXTjlxWWNoenpmVzkxWmx3QXY0WHAyUitGeEVlbVMrVmRpMzgx?=
 =?utf-8?B?SnBXb2gvOTkwM3l5MHJQNTN4Zzl2dkZJT2NKWEQzOGxVak9SVVVjWlpSWHd6?=
 =?utf-8?B?SjRFT3hJakZ5aXVtaXNaSzNvc0pMRVdBMWV1WVRWektxYWV1NS9DWjNpdWlq?=
 =?utf-8?B?a01qS3ZRa01Mb0dPeDlrOVFCbW41bGp5ZDhzb0FuRWxQU1g3aXEreTJPa2FC?=
 =?utf-8?B?cTNaODNWd3RvZE0xeDQ1c2VxODFrVHo4N2lLWUljdTFPMittdzVyMWZiRVcv?=
 =?utf-8?B?Z2NQdDlKaGREUnNvbm5xeW42TU04QWFMZUdBa3JCSHVHbW1MUlo3bUpxaTM4?=
 =?utf-8?B?RkJ4MkhKMS9SbUs0N1FiTVQwREpUTlFWTDFoTEpjRmE2dC9jMys3MVd0djU5?=
 =?utf-8?B?cGgwSmJRb2JtcnMxYzJDTHJLMkhqdUtDY0NzY1h1RHVBeVJScURWUllGK1dx?=
 =?utf-8?B?UmhPdXVrdjdPTzJLRjFOc1JQU2pGSnY0Z2QwcDNvSUx5b1dFaDhrNXBHcVRa?=
 =?utf-8?B?SDNxbjNJNzlXT0RIZTZzdEViNDkzTk9PbFVMdlFnRzI0MlBaZllZV2M4NFhK?=
 =?utf-8?B?b2FLNmtuSTMwajJJZTRmWVZDbDRZWWt5bWhQZk9VanZnU1phZkpEMHN2c2Rx?=
 =?utf-8?B?SnhHSU9lbHU5cFNQdkhIZlBCMGpjZ2tQcEZyQlpqVGhUM3lTVWRJa0k2c2Zq?=
 =?utf-8?B?ZkRJODFOMitMcStKQVpORnNSTTVVam95THg1b3NkSFV1aDhBQTZoVlhzNTVB?=
 =?utf-8?B?MTFOTFZHcEgyaElCYnB1Q20zT3dwNXZKZXlRc2dyR3ZSbXNqMnRzZUFKTTc3?=
 =?utf-8?B?YlY3dWp4ZmlQalFpUFV3b251OWliZUI3YkZpa3BvWlQ1QVdseXpxQ3BSODV6?=
 =?utf-8?B?dGN3S251b1JpeW9lL1V1QmU0SzlEaE4vN2ZWOU85OUh3UDNCYWhZY1pHQUgz?=
 =?utf-8?B?cjl6VjlDMWtreDk4cWpqVnAyR1U2Y2JYYTBEOUxWVHBwdVNnMFc4NWVMVzFy?=
 =?utf-8?B?Zm50WHJ1Q1A4VEpnc004Y3lueU8vMEQ1enExaGE0bk9IbmZST0ZHOUx2Vy9Z?=
 =?utf-8?B?dWxBU0ZVUGhnYW9zOXhQenhuL2YxRXUyQWF3d0RUMDJERzJvdXlBRHBLWkZH?=
 =?utf-8?B?clNMMi9QR1Ywem9XVE5nZUN6UjdkWTBVaGptQ2RjbVBmTlpUTTQ4WU5MeHM3?=
 =?utf-8?B?M1BhTm9sVnJlUG9BK1Y3VEtZT29yMTV0ZDQ2M0ZnMkZaMSt2T203emg2T2RT?=
 =?utf-8?B?aVdQV2ZSaTlXYjFBdU9IYkJrQnd6K0s3dUZBOGZud0NuZVlaR05XKzdEVGJW?=
 =?utf-8?B?OE1FWElJSENoTW04RHBMY0xXWTVGbXFzQ2d2cUo3WituWWFWTFMxY0J0SVJh?=
 =?utf-8?B?OUJtVTNMVDlWd1lFQUV6VGVJd0lLTzBNdjhhZDlmUXZPNExLMy9wUXphQ0xi?=
 =?utf-8?B?bTM5TFRFWjFrOXRtdVRMMWZIMkF6WUNMVm96YkdQZlhqb2hvYy9PRTg3ODNF?=
 =?utf-8?B?M3lXOUo2eVhTbmlyZTUraytZdEFiT2VUdGRsV3pHMGd4cmFXci9PVGxyRmlp?=
 =?utf-8?B?UWdBU3JrdXBQQWtwS2ZHTDFmRlcxMmY3d0FjNUZjazd3S3h4V0lxdjdmMk9L?=
 =?utf-8?B?Q3lsQVVqdTYzK2RYOGFsOHR0eHNzT2I3QjRRa1IxTEYzRitPVDFrSVhza2Qv?=
 =?utf-8?B?elplMzFLL2NXOGw2cmczb3FHQ2VYeU05RWo5eG1OUitrMDl3M1FJSG45aUE5?=
 =?utf-8?B?QWdrd2Q2aURHY1dHWlAyV011VGM3OHJCUFR0R0VCRVFub040Skc5akdOOHc1?=
 =?utf-8?B?VmxES1VBOUxqUEwzYnQ0ZFVrSXhreGhPeU1wOGF2ZWZlSERPNDB0Sm1PMGUz?=
 =?utf-8?B?MVpxMUdaS1NYZTdmNCt3SWVPc1dEUDJ5STJmc1R6NzdqN0dxeTcvTlVMZFNm?=
 =?utf-8?B?VlowZmp5RkVuaXlTNm1hSWtxdTR1bEU2ZHhYOFVnZ0FqR0tjSVdwejRHZlZF?=
 =?utf-8?Q?hp3ccnVuL8xwPUnvBLzzW/89h?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f5cb723-b26c-4d1b-499b-08dd027436ca
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 17:13:51.6911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8dIUtpnv9kSuyiHuk5D5oXjvzIaxxZW3hDcJCWWFSRoQMKLPz4FZPxTo+vmA9BHBzaIlAC4VATXndQ4Ex/TBLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7307

On 11/8/24 16:13, Dionna Amalie Glaze wrote:
> On Fri, Nov 8, 2024 at 9:24 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>
>> On 11/7/24 17:24, Dionna Glaze wrote:
>>> In preparation for SEV firmware hotloading support, introduce a new way
>>> to create, activate, and decommission GCTX pages such that ccp is has
>>
>> s/is has/has/
>>
>>> all GCTX pages available to update as needed.
>>>
>>> Compliance with SEV-SNP API section 3.3 Firmware Updates and 4.1.1
>>> Live Update: before a firmware is committed, all active GCTX pages
>>> should be updated with SNP_GUEST_STATUS to ensure their data structure
>>> remains consistent for the new firmware version.
>>> There can only be CPUID 0x8000001f_EDX-1 many SEV-SNP asids in use at
>>> one time, so this map associates asid to gctx in order to track which
>>> addresses are active gctx pages that need updating. When an asid and
>>> gctx page are decommissioned, the page is removed from tracking for
>>> update-purposes.
>>
>> You should be consistent with capitalization of gctx and also capitalize ASID.
>>
>>>
>>> CC: Sean Christopherson <seanjc@google.com>
>>> CC: Paolo Bonzini <pbonzini@redhat.com>
>>> CC: Thomas Gleixner <tglx@linutronix.de>
>>> CC: Ingo Molnar <mingo@redhat.com>
>>> CC: Borislav Petkov <bp@alien8.de>
>>> CC: Dave Hansen <dave.hansen@linux.intel.com>
>>> CC: Ashish Kalra <ashish.kalra@amd.com>
>>> CC: Tom Lendacky <thomas.lendacky@amd.com>
>>> CC: John Allen <john.allen@amd.com>
>>> CC: Herbert Xu <herbert@gondor.apana.org.au>
>>> CC: "David S. Miller" <davem@davemloft.net>
>>> CC: Michael Roth <michael.roth@amd.com>
>>> CC: Luis Chamberlain <mcgrof@kernel.org>
>>> CC: Russ Weight <russ.weight@linux.dev>
>>> CC: Danilo Krummrich <dakr@redhat.com>
>>> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> CC: "Rafael J. Wysocki" <rafael@kernel.org>
>>> CC: Tianfei zhang <tianfei.zhang@intel.com>
>>> CC: Alexey Kardashevskiy <aik@amd.com>
>>>
>>> Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
>>> ---
>>>  drivers/crypto/ccp/sev-dev.c | 107 +++++++++++++++++++++++++++++++++++
>>>  drivers/crypto/ccp/sev-dev.h |   8 +++
>>>  include/linux/psp-sev.h      |  52 +++++++++++++++++
>>>  3 files changed, 167 insertions(+)
>>>
>>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>>> index af018afd9cd7f..036e8d5054fcc 100644
>>> --- a/drivers/crypto/ccp/sev-dev.c
>>> +++ b/drivers/crypto/ccp/sev-dev.c

>>
>> But, I don't think that SEV_CMD_SNP_ACTIVATE needs to be here since it
>> doesn't change anything related to the sev_asid_data struct. KVM has the
>> guest context and can issue the commands similar to the other commands KVM
>> issues that use the guest context. So this function can be removed and
>> still performed in KVM.
> 
> My intention for adding it was for safety, not raw capability.
> Is it not safer to ensure that the GCTX used for activation is the one
> that is tracked?
> 

I'm not sure... all the code is really doing at this moment is tracking
guest context pages so that you can update them on firmware changes. Any
misuse of the context page and ASIDs can happen today in KVM so I'm not
sure it matters. And any duplicate ASID usage is recognized when
creating the guest context page.

I guess we can keep it here, though.

>>> +     cpuid(0x8000001f, &eax, &ebx, &sev_max_asid, &sev_min_asid);
>>> +     if (!sev_max_asid)
>>> +             return -ENODEV;
>>> +
>>> +     nr_asids = sev_max_asid + 1;
>>
>> Can we get rid of sev_max_asid and then just use nr_asids or sev_asids in
>> the cpuid() call and adjust by 1 after the above check.
>>
> I'm not sure I know what you mean.

You only need one of either nr_asids or sev_max_asid. So you could do:

	cpuid(0x8000001f, &eax, &ebx, &sev_max_asid, &sev_min_asid);
	if (!sev_max_asid)
		return -ENODEV;

	/* Bump SEV ASIDs count to allow for simple array checking */
	sev_max_asid++;

Then you can get rid of nr_asids and just use sev_max_asid in the
appropriate places and manner.

Thanks,
Tom

>>> +     sev_es_max_asid = sev_min_asid - 1;
>>> +
>>> +     sev_asid_data = kcalloc(nr_asids, sizeof(*sev_asid_data), GFP_KERNEL);
>>
