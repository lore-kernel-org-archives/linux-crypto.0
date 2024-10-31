Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2047.outbound.protection.outlook.com [40.107.92.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA331953A2;
	Thu, 31 Oct 2024 10:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730371413; cv=fail; b=r5CBwhySpT4G18cIJFARFMeV7pPvDQdJdjKNat7kQrHk9psgCRH14/+4GNTkohEHEqJhIqqszcsmsBkDQLnUZQgPK1BveUnPvvrdDkty8uP6ZZHl8r3f1oPH7/45wLiTG78o+ks9KBbADawjhzTXoIhjM+WuB3o6JrEsRR5C+JM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730371413; c=relaxed/simple;
	bh=i0EvdpHOaLRlXf0HZ3py1SxI+EVl6vO6gtNCXpO8DjA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GLOw0ma07WlLn9miHZZlNIdFJpXkApm81nRoQn5BS5cp5XPWX3tvCXAx8Bt11q/H/dN7yUhS91ZiaFLHA5yYxjwDjN7pXzIFvTsMrqQ+bTS1BFfTp1wUu9Es5fXPfVDRfA/4kZASTJmaVCrWrp5qV1S/esYzPJ2XChhsWtwbmHA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=b1jL/UUN; arc=fail smtp.client-ip=40.107.92.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="b1jL/UUN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bFcHVYR9LqwsCb8zSHM+UDj2trUr4BwjtKbmvXu5SCN0YfjUvIAVnqc8Iyj1uSDXlYi8XuGadJ1yByKTdJODt4yPQ7i1tmhXNjRHPmqzN9LLXXusdLnifKNrNFbNJH0zkGctJwtkE7Q7AFY8xOedbV4iuHcsLJR+62r9VJFYebkqoZgRZAscNtdXDmpiBWCEH5cQ+Npp7fHa1EEVtfzF17rPL5xZZHGV8VPgVYLkgEEa8kszVFv0O3TE36ObaANJuFzDB+KU9XfiKBU94Rnk4Yn8M8WWP9ZUnAa0+9JQI99eFuvr0W4nqITY1rdcF/0XGtUEiIu84d1D7cPeB5JTlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fp2cv2uQ0PKxA+63IndvHqdnHYNy145zcuZ/eb8tZRg=;
 b=cseidniwIAni3ZKOv7xHphVb3FDNZ5Om0HscgI6CPpBHrv+EEqyQbtbXAtDl1zyBGqIe46ENGEmEsD0lnXzZVJHotMJeHDUfiV4qYqJsl9TVFzpxpCR6vvF78Bm0c64Q1LhW3yYmL1Fpqp7rAe6Je28xG4UfYs3wZ+mvN2yVxpv0wy1eFVsz2mblYGaRUHD4dgjxw38pvqY2KHP2euF46OShtHRacnyA7qKqYNZxzhg2mWhAV7j9LcdPXcSOl/mMPsAAYqSI8Uvit+A0PD8FYEGay3EuCdgDCzXothDAXOZO68NbTIOOrICyK7aP815hZ3SuWlj1NhBGFDowSTPAvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fp2cv2uQ0PKxA+63IndvHqdnHYNy145zcuZ/eb8tZRg=;
 b=b1jL/UUNclwbm+GNf5c8F5qHgecduitjwDH5wFEGsIY7tBtsRmszLR/bP/CsC5t0QGYU8PTy+TORu9Mtz7UsQLx0zKqME9anikYgEkJgi9NccVcjZujQHeo5ko8qxZwizxigLT+3/HI2Etphh/MFfBNcGzuKGGnmz5DeS3mdPpY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SJ2PR12MB8689.namprd12.prod.outlook.com (2603:10b6:a03:53d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.19; Thu, 31 Oct
 2024 10:43:24 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%4]) with mapi id 15.20.8114.015; Thu, 31 Oct 2024
 10:43:24 +0000
Message-ID: <615aaa5e-c635-471a-965a-1af4d20d4915@amd.com>
Date: Thu, 31 Oct 2024 05:43:13 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] crypto: ccp: Add SNP firmware hotload support
Content-Language: en-US
To: Dionna Glaze <dionnaglaze@google.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: Michael Roth <michael.roth@amd.com>, "Borislav Petkov (AMD)"
 <bp@alien8.de>, linux-crypto@vger.kernel.org
References: <20241029183907.3536683-1-dionnaglaze@google.com>
 <20241029183907.3536683-4-dionnaglaze@google.com>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <20241029183907.3536683-4-dionnaglaze@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGXP274CA0024.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::36)
 To BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SJ2PR12MB8689:EE_
X-MS-Office365-Filtering-Correlation-Id: a75bca5c-a107-4f1d-e94c-08dcf998d863
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UzFvdGR5Vk9TN21BQ0tGWEVReTFvK1AwTnVBRTlxbVQ4OHJEc0luMTVqblFN?=
 =?utf-8?B?UjBVek5USDF5NElNTmQzTnp3dG5MSHFhNnBMTFR4S1JreGFpaFphbjRac3Fq?=
 =?utf-8?B?QnU4T00zanlVZWhDN0VORXh1a3BlbkRmbjVkeUZZaS9tM0FDSlAveCs3R1l2?=
 =?utf-8?B?eHlxRzQ2RWpWTk16VC9INFRIS0Y1c3NnMFNHZTZCODljaXVSQWhsU2lOZXY4?=
 =?utf-8?B?Z242SGFRV2FNV25WT3J6UmIyT3A1K1dXR0RuUWJ6b3R2YXFEckV3Z3JtcEIz?=
 =?utf-8?B?Y3Z4YkpIaTFqLzNkdE1JZHZlTDZvaU1hYmlkcERYTnB3TDZnSHhkOGZIODB6?=
 =?utf-8?B?SXFJZ2MrQjN1ejBzRVk3cnVicVpmYmJDeEZBeFRkU09sTWhLNi9LVTJGNzNz?=
 =?utf-8?B?K0tDMzFNaXVBdEZzdkZzQ2JveEFidjFpSGV4M0JzVEpTci84OUFkcU9mclFV?=
 =?utf-8?B?S0lnTW5scGV1aEU4RW5SVytqcmttMXIrZDZZOG9BMHBKNzA3WU5WYi9WQXJp?=
 =?utf-8?B?ZVMwM0Q5REQ1TlhVSzVaZmFiamRCZDM2MlQxSm0zbnVPdjhZMzVCZHJXTFY1?=
 =?utf-8?B?WWQxMFUxTWtJbldiNG5zRW5YUktKdG9CUktTS21wV3JyQ0ZDeFFSeEpnQmJo?=
 =?utf-8?B?MVNNdDByWEE2czM2amZmUXYzeW9iR3Q2cS9rZFpJdGoxSHhNeExrY3FHUHpJ?=
 =?utf-8?B?Vml2bUlzVHdRVEo3QmprOTRGMEFoK2RUbEo3NzRsUEgzcUFYTjVVVU11MVlu?=
 =?utf-8?B?V2lOdUFPTlFQc0I5d29QdXhTb0VUMHNHQzBhcnMvV1ZRVE14dlZHZkg5aFhY?=
 =?utf-8?B?amxxWFQ0Mk1abks5aTdRSkRPdHhnS0tSdWdsOHFadDlGeTZlNC9rQVBYbGho?=
 =?utf-8?B?eTc1bDBoMDlCUklhRnVUVnBIUURKNDdXMW5BaEsrM2Uza1lKQkxEczIwY3R5?=
 =?utf-8?B?ZWdKSVorc1kvek5GejgrcHhVNkpGUmZsN2V5YkYydVhTcTRwS2E0ZWdVTGRz?=
 =?utf-8?B?MWtEOTJUeFJDZnRzeTJ3c3BPL09GclpvRWhmM3ZkZGY3Sy9QaGVSMHlleU9p?=
 =?utf-8?B?SXpQTFE3NHJoRU5mYzVsby9lcXpxYi90R29Sd0p3YWQ2ekRPSVIwUWdZbUdx?=
 =?utf-8?B?WjZRV2JFNkNpcmxReEI2NkYxTjdLZ3FhUTlOWVVGSTVoZytidUp2ZGZEUjlx?=
 =?utf-8?B?dXpNaC9qVkpTOHUxckJLd2toMGFtcUpNTks1bnNZem8yRi9NZ3dCb0xlQm9G?=
 =?utf-8?B?NlJUKzBOalgrZzlaTDBMbkpZdTN4clhoODFLUG9iUndXMGp3OTJ4ZTZrWk0x?=
 =?utf-8?B?b09yQTNUVnAwenEzc0JmY3F6aFpVRHJHajZnclBGSXZESzVuRnZWdGMrUGF6?=
 =?utf-8?B?QUJ1WnVBWkMwdXp0bEhWMTYySStOZUVmS3dRdnIwblppZmw3Sno0NUF0L1BG?=
 =?utf-8?B?QnQ3andwM0NoSTVmbHdrelFueWorcUx3ZDZPdnc0MFdIRjU5c1A2OGVuajJF?=
 =?utf-8?B?SVNoZHVNVC92ZnFoeXdBZGs1c2tCSVF4bnNrRnk2cmd1YzlDd3FJcjVWZHNU?=
 =?utf-8?B?TlJBeVArSFFReGw1cjdCN0VvejZkR1BtNWRGcFJLN2lhU1labVZTdnZBQVZD?=
 =?utf-8?B?VW84MmxnNlZJMjRtWCtTTUV4a3hoUzZJdGRWalZEWmFyU2IzZStzOXBqUlVo?=
 =?utf-8?B?YTlkNGEyd1FFZzk5clN6Mlg2QXYzdDV0aVNqcWhWY1lFVlgzV0FPbHZUOXdj?=
 =?utf-8?Q?E6hPhUZ9EIMRMG78TZzjQsEnzi/7IPnEABpnAdC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WG02RVQ1c0lDQ2xkeDhldkhESGs0VjYxbFV6WHdORXJQMElNOW5DMHBVYUly?=
 =?utf-8?B?bUkza21aQ3U3Uk1nMWRLU3RRRGNqdWdOSzh4RDZnTlJIaDBNYUd2R3VyVDJ0?=
 =?utf-8?B?QWlsMjJnT1ppblcxMEZlZk5XbUdEWUNiaG5kQklOWnJCK040QVVsdXVPc04r?=
 =?utf-8?B?RTNNRFQ3Y1FDaG9ZYnpjWGpZNThkemM5ZDJKa1Y4RlBwNEdyVkovZEcrSndh?=
 =?utf-8?B?VkFkR1NJQWRmWTdZOFhCd1pSdDlWYnJlT0UyZjFhVnlvVnVERFp5aDd5a0k0?=
 =?utf-8?B?bHJ0aExIb0FOdFFSTkExdHlKMkFvdmRodjFvYmQ0VStzbDJERHk0dEx6N3dS?=
 =?utf-8?B?d0Q2T2FadzdkNHhuZGhobEptQVRWM3ZENWJDR1NxbW9VSVdjYlZHK3dpb2pp?=
 =?utf-8?B?Q0piYkx6ZjJKM2FvVk51M21ObUZLbHFLUWlqRmxmR3Z1bmcyaWp2WGFrcFBQ?=
 =?utf-8?B?VXo4R1ZsNWtxUVBSd3NUV3FqTGdSdVVaM3JMWFBZZ0UvWkJLSWJEeUlBWjFR?=
 =?utf-8?B?SFNZRlkyYjdQQUFnbDlpL2gwd1BTU05lYmQ2V1Mrdng4UzBJM3hUdkZGenhV?=
 =?utf-8?B?STU3N0J3L3daKzQxUXI4b0pHNzFwaWJEelU0RGtRYkdoa3VLNVpkcnVxeUI3?=
 =?utf-8?B?OEVvMmVPUUhYQ3Y1V0gwQ2RTVzF6UE42YjJxanVtZzlvb2dWZWNpUDJuQlBs?=
 =?utf-8?B?ZlZpUzlBdEhmeFFHa0dPQzI5VW9kRVFCZTdvdXAxa1RiR3R2azl4SThZRXZv?=
 =?utf-8?B?VEpqVmVxdUUzazY3T1M0OVplcmpqWTZZNFV5SUQ0RE1OZTFuODVZUTlnMFFi?=
 =?utf-8?B?czNvZTBZc2Zpd3ZBRnhHcXpVOHFGUUw4UUYzWVcreUJ1RGsydklkL0JXWUtn?=
 =?utf-8?B?Vytzb3NCSFF4QnU5WlBOVkxPS2RuREU0dGd3M0N6eDlTUFIvQVREOVhFWDhS?=
 =?utf-8?B?b29PM3VmcEx5c3FxdVVKOVd5ZjVJZE1xL1NFR0VHaFJHWE1VaURsL3VsNnhR?=
 =?utf-8?B?TS80Ly9vK3B6c2NMSGk4KzdYRXhWRWlzcU4yclI1S1Rib2E4L3RBZks0WjNw?=
 =?utf-8?B?Mnl3STlYYTJoOStBY0p3T0hsdUs0NGhkMDl4SnFNV1dTRTdwWmQyWDN5Y3Iv?=
 =?utf-8?B?NHpmNXBvR2RDVHhLU1pDekhnd1k3WWhEdzN2OVMzL1BOSDlEQUJXWVMwM0oy?=
 =?utf-8?B?ZDI4U2xFUlFQdTR6Smpwa2JJbk04UWY1YnQ5MmZkYm9Td2ZLbEk3d0R1ekZ3?=
 =?utf-8?B?a3BPV2htZnZHNHpQTG9uTVREV1Npa3pUY21Iclpra3lVazY1VVdsMnlPOCs0?=
 =?utf-8?B?R1ZiOWM2SlUrNnY5dExvUkdaYkhDVjd5eHJibkJ2WW5qeGZxL1M4elBOOEU5?=
 =?utf-8?B?NzI5eXZDdFIwdG9IaHJxSWtVUnp1RGpLaXFvSVdzNUQwRkFZSVAwekVkV3hO?=
 =?utf-8?B?MjM5TEZtNHBOS1BhRHFmZjNCcXVKUjdQYUp4NW9hVW9LY0FUWkQwdGFkNlF3?=
 =?utf-8?B?SnRuMEV2WVJxblo1NUhLQlBVRTE2S0lJU2l4R0NvSWtHYU5SblZyVHNweHR4?=
 =?utf-8?B?SmwwL2cwajVFd1N1Q1BIc1RYZCt5aEp2V3Y3SVl4Z1lQWk9pOS84QkhVTlN2?=
 =?utf-8?B?TEUxMlB1ejltY1pqV1ZUdHVPN1hsQ0wxUDVBclZOWFNVL2pXZnYrQjRjS2hi?=
 =?utf-8?B?TGlCN2NiNU1yRFBYT1RvN3hYaWtQMi9YOHM1NzhpNVJZRjhPZ0t4WGQxL1g1?=
 =?utf-8?B?NU9GSzFOOFJTbHVlR2lTa2dlMU5acTkzcTVWN3VEemlERGZmUnZPS0RjZ1N3?=
 =?utf-8?B?RjhrZkNVUHRQcHlQWDJ5K3lCU2JVY0NjT0t4bEVxTVpDalRkbkFlY0pPNkY0?=
 =?utf-8?B?NnowWTdQa004MG5MbXIyNDZBQnFNbGNMSU8wN3dxWVg1NjlUaTZzTDNuUjEv?=
 =?utf-8?B?aGtmc2wya2hVbmVYdUk0aklKWVAxa3pwUFExeXBuUmZXeFpJTERVaTR6UU53?=
 =?utf-8?B?NnNPbDNDYnA5dkhEV2xFYmV3TGh5UzUrZGJwelBzeXltdkhrNjlEbDkvR1ZM?=
 =?utf-8?B?Ukx0U3ZmWVRqZnlNZ3hLcEJlT2dnTk9PTkJrbFpsR2s2eXg3c1p3OHNHYzJq?=
 =?utf-8?Q?dnHexJ+YHw1qXfTdFz8f6KpMz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a75bca5c-a107-4f1d-e94c-08dcf998d863
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 10:43:24.4120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NqfRLjp3mzK5LsJWlgwW9d2vEWAcJiAbfWwj4AsBBfXvtqgU+XOxJZk59Bh+SgAcSVcRrB3d+RIWz5vAg2DaXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8689



On 10/29/2024 1:39 PM, Dionna Glaze wrote:
> uapi changes: The status values added are defined in AMD's SEV-SNP API
> documentation as new error modes for the DOWNLOAD_FIRMWARE_EX command.
> 
> On init, the ccp device will make /sys/class/firmware/amd/loading etc
> firmware upload API attributes available to late-load a SEV-SNP firmware
> binary.
> 
> The firmware upload api errors reported are actionable in the following
> ways:
> * FW_UPLOAD_ERR_HW_ERROR: the machine is in an unstable state and must
>   be reset.
> * FW_UPLOAD_ERR_RW_ERROR: the firmware update went bad but can be
>   recovered by hotloading the previous firmware version.
>   Also used in the case that the kernel used the API wrong (bug).
> * FW_UPLOAD_ERR_FW_INVALID: user error with the data provided, but no
>   instability is expected and no recovery actions are needed.
> * FW_UPLOAD_ERR_BUSY: upload attempted at a bad time either due to
>   overload or the machine is in the wrong platform state.
> 
> snp_asid_to_gctx_page_map:
> The SEV-SNP API documents that before a firmware is committed, all
> active GCTX pages should be updated with SNP_GUEST_STATUS to ensure
> their data structure remaiins consistent for the new firmware version.
s/remaiins/remains

Also probably provide a link to SEV-SNP API document here, 
referring section 3.3 Firmware Updates and section 4.1.1 Live Update

> There can only be cpuid_edx(0x8000001f)-1 many SEV-SNP asids in use at
> one time, so this map associates asid to gctx in order to track which
> addresses are active gctx pages that need updating. When an asid and
> gctx page are decommissioned, the page is removed from tracking for
> update-purposes.
> Given that GCTX page creation and binding through the SNP_ACTIVATE
> command are separate, the creation operation also tracks pages that are
> yet to be bound to an asid.
> 
> synthetic_restore_required:
> Instead of tracking the status of whether an individual GCTX is safe for
> use in a firmware command, force all following commands to fail with an
> error that is indicative of needing a firmware rollback.
> 
> A sev_platform_init call when only SEV-SNP VMs are expected should set
> supports_download_firmware_ex to delay legacy initialization actions.
> The firmware can only be hotloaded when legacy initialization has not
> happened.

Again, probably refer to SEV-SNP API document here, section 3.3, 
DOWNLOAD_FIRMWARE_EX command is usable when the SNP firmware is in 
either the UNINIT or INIT states, but SEV-legacy firmware must be in the UNINIT state

> 
> To test:
> 1. Build the kernel enabling SEV-SNP as normal and add CONFIG_FW_UPLOAD=y.
> 2. Add the following to your kernel_cmdline: ccp.psp_init_on_probe=0.
> 3.Get an AMD SEV-SNP firmware sbin appropriate to your Epyc chip model at
> https://www.amd.com/en/developer/sev.html and extract to get a .sbin
> file.
> 4. Run the following with your sbinfile in FW:
> 
> echo 1 > /sys/class/firmware/snp_dlfw_ex/loading
> cat "${FW?}" > /sys/class/firmware/snp_dlfw_ex/data
> echo 0 > /sys/class/firmware/snp_dlfw_ex/loading
> 
> 5. Verify changes.
> There is no easy sysfs interface to SNP_PLATFORM_STATUS,
 
Do note, we call sev_get_api_version() to issue SEV_PLATFORM_STATUS
before and after DOWNLOAD_FIRMWARE_EX which will indicate if the 
SEV firmware was updated. 

> you'll need an
> application to run the ioctl and interpret the results. A before and
> after should show different CURRENT_TCB, build, minor, major values
> if you were running an earlier firmware that hotloaded.
> 
> CC: Ashish Kalra <ashish.kalra@amd.com>
> CC: Tom Lendacky <thomas.lendacky@amd.com>
> CC: John Allen <john.allen@amd.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Michael Roth <michael.roth@amd.com>
> CC: "Borislav Petkov (AMD)" <bp@alien8.de>
> 
> Co-authored-by: Ashish Kalra <ashish.kalra@amd.com>
> Change-Id: Id28f9e80ea6eae565503493f874cca685c2b7f1b
> Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
> ---
>  drivers/crypto/ccp/Kconfig   |   2 +
>  drivers/crypto/ccp/sev-dev.c | 398 ++++++++++++++++++++++++++++++++++-
>  drivers/crypto/ccp/sev-dev.h |  14 ++
>  include/linux/psp-sev.h      |  28 +++
>  include/uapi/linux/psp-sev.h |   5 +
>  5 files changed, 439 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
> index f394e45e11ab4..cd9b667640e7c 100644
> --- a/drivers/crypto/ccp/Kconfig
> +++ b/drivers/crypto/ccp/Kconfig
> @@ -39,6 +39,8 @@ config CRYPTO_DEV_SP_PSP
>  	bool "Platform Security Processor (PSP) device"
>  	default y
>  	depends on CRYPTO_DEV_CCP_DD && X86_64 && AMD_IOMMU
> +	select FW_LOADER
> +        select FW_UPLOAD
>  	help
>  	 Provide support for the AMD Platform Security Processor (PSP).
>  	 The PSP is a dedicated processor that provides support for key
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 9810edbb272d2..20232308b1b61 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -223,6 +223,7 @@ static int sev_cmd_buffer_len(int cmd)
>  	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
>  	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
>  	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
> +	case SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX:	return sizeof(struct sev_data_download_firmware_ex);
>  	default:				return 0;
>  	}
>  
> @@ -829,6 +830,7 @@ static int snp_reclaim_cmd_buf(int cmd, void *cmd_buf)
>  	return 0;
>  }
>  
> +static void snp_cmd_bookkeeping_locked(int cmd, struct sev_device *sev, void *data);
>  static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>  {
>  	struct cmd_buf_desc desc_list[CMD_BUF_DESC_MAX] = {0};
> @@ -852,6 +854,15 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>  	if (WARN_ON_ONCE(!data != !buf_len))
>  		return -EINVAL;
>  
> +	/* The firmware does not coordinate all GCTX page updates. Force an
> +	 * error to ensure that no new VM can be started and no active VM makes
> +	 * progress on guest requests until the firmware is rolled back.
> +	 */
> +	if (sev->synthetic_restore_required) {
> +		*psp_ret = SEV_RET_RESTORE_REQUIRED;
> +		return -EBUSY;
> +	}
> +
>  	/*
>  	 * Copy the incoming data to driver's scratch buffer as __pa() will not
>  	 * work for some memory, e.g. vmalloc'd addresses, and @data may not be
> @@ -982,6 +993,9 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>  	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
>  			     buf_len, false);
>  
> +	if (!ret)
> +		snp_cmd_bookkeeping_locked(cmd, sev, data);
> +
>  	return ret;
>  }
>  
> @@ -1082,6 +1096,7 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>  	return 0;
>  }
>  
> +static int sev_snp_platform_init_firmware_upload(struct sev_device *sev);
>  static int __sev_snp_init_locked(int *error)
>  {
>  	struct psp_device *psp = psp_master;
> @@ -1179,6 +1194,8 @@ static int __sev_snp_init_locked(int *error)
>  
>  	sev_es_tmr_size = SNP_TMR_SIZE;
>  
> +	rc = sev_snp_platform_init_firmware_upload(sev);
> +
>  	return rc;
>  }
>  
> @@ -1326,6 +1343,13 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
>  	if (args->probe && !psp_init_on_probe)
>  		return 0;
>  
> +	/*
> +	 * Defer legacy SEV/SEV-ES support if legacy VMs are not being launched
> +	 * and module psp_init_on_probe parameter is false.
> +	 */
> +	if (args->supports_download_firmware_ex && !psp_init_on_probe)
> +		return 0;
> +
>  	return __sev_platform_init_locked(&args->error);
>  }
>  
> @@ -1592,14 +1616,8 @@ static int sev_update_firmware(struct device *dev)
>  		return -1;
>  	}
>  
> -	/*
> -	 * SEV FW expects the physical address given to it to be 32
> -	 * byte aligned. Memory allocated has structure placed at the
> -	 * beginning followed by the firmware being passed to the SEV
> -	 * FW. Allocate enough memory for data structure + alignment
> -	 * padding + SEV FW.
> -	 */
> -	data_size = ALIGN(sizeof(struct sev_data_download_firmware), 32);
> +	data_size = ALIGN(sizeof(struct sev_data_download_firmware),
> +			  SEV_FW_ALIGNMENT);
>  
>  	order = get_order(firmware->size + data_size);
>  	p = alloc_pages(GFP_KERNEL, order);
> @@ -2224,6 +2242,366 @@ static int sev_misc_init(struct sev_device *sev)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_FW_UPLOAD
> +
> +static enum fw_upload_err snp_dlfw_ex_prepare(struct fw_upload *fw_upload,
> +                                             const u8 *data, u32 size)
> +{
> +        return FW_UPLOAD_ERR_NONE;
> +}
> +
> +static enum fw_upload_err snp_dlfw_ex_poll_complete(struct fw_upload *fw_upload)
> +{
> +        return FW_UPLOAD_ERR_NONE;
> +}
> +
> +/*
> + * This may be called asynchronously with an on-going update.  All other
> + * functions are called sequentially in a single thread. To avoid contention on
> + * register accesses, only update the cancel_request flag. Other functions will
> + * check this flag and handle the cancel request synchronously.
> + */
> +static void snp_dlfw_ex_cancel(struct fw_upload *fw_upload)
> +{
> +	struct sev_device *sev = psp_master->sev_data;
> +
> +        mutex_lock(&sev->fw_lock);
> +        sev->fw_cancel = true;
> +        mutex_unlock(&sev->fw_lock);
> +}
> +
> +static enum fw_upload_err snp_dlfw_ex_err_translate(struct sev_device *sev, int psp_ret)
> +{
> +	dev_dbg(sev->dev, "Failed to update SEV firmware: %#x\n", psp_ret);
> +	/*
> +	 * Operation error:
> +	 *   HW_ERROR: Critical error. Machine needs repairs now.
> +	 *   RW_ERROR: Severe error. Roll back to the prior version to recover.
> +	 * User error:
> +	 *   FW_INVALID: Bad input for this interface.
> +	 *   BUSY: Wrong machine state to run download_firmware_ex.
> +	 */
> +	switch (psp_ret) {
> +	case SEV_RET_RESTORE_REQUIRED:
> +		dev_warn(sev->dev, "Firmware updated but unusable\n");
> +		dev_warn(sev->dev, "Need to do manual firmware rollback!!!\n");
> +		return FW_UPLOAD_ERR_RW_ERROR;
> +	case SEV_RET_SHUTDOWN_REQUIRED:
> +		/* No state changes made. Not a hardware error. */
> +		dev_warn(sev->dev, "Firmware image cannot be live updated\n");
> +		return FW_UPLOAD_ERR_FW_INVALID;
> +	case SEV_RET_BAD_VERSION:
> +		/* No state changes made. Not a hardware error. */
> +		dev_warn(sev->dev, "Firmware image is not well formed\n");
> +		return FW_UPLOAD_ERR_FW_INVALID;
> +		/* SEV-specific errors that can still happen. */
> +	case SEV_RET_BAD_SIGNATURE:
> +		/* No state changes made. Not a hardware error. */
> +		dev_warn(sev->dev, "Firmware image signature is bad\n");
> +		return FW_UPLOAD_ERR_FW_INVALID;
> +	case SEV_RET_INVALID_PLATFORM_STATE:
> +		/* Calling at the wrong time. Not a hardware error. */
> +		dev_warn(sev->dev, "Firmware not updated as SEV in INIT state\n");
> +		return FW_UPLOAD_ERR_BUSY;
> +	case SEV_RET_HWSEV_RET_UNSAFE:
> +		dev_err(sev->dev, "Firmware is unstable. Reset your machine!!!\n");
> +		return FW_UPLOAD_ERR_HW_ERROR;
> +		/* Kernel bug cases. */
> +	case SEV_RET_INVALID_PARAM:
> +		dev_err(sev->dev, "Download-firmware-EX invalid parameter\n");
> +		return FW_UPLOAD_ERR_RW_ERROR;
> +	case SEV_RET_INVALID_ADDRESS:
> +		dev_err(sev->dev, "Download-firmware-EX invalid address\n");
> +		return FW_UPLOAD_ERR_RW_ERROR;
> +	default:
> +		dev_err(sev->dev, "Unhandled download_firmware_ex err %d\n", psp_ret);
> +		return FW_UPLOAD_ERR_HW_ERROR;
> +	}
> +}
> +
> +static enum fw_upload_err snp_dlfw_ex_write(struct fw_upload *fwl, const u8 *data,
> +                                       u32 offset, u32 size, u32 *written)
> +{
> +	struct sev_data_download_firmware_ex *data_ex;
> +	struct sev_data_snp_guest_status status_data;
> +	struct sev_device *sev = fwl->dd_handle;
> +	void *snp_guest_status, *fw_dest;
> +	u8 api_major, api_minor, build;
> +	int ret, error, order;
> +	struct page *p;
> +	u64 data_size;
> +	bool cancel;
> +
> +	if (!sev)
> +		return FW_UPLOAD_ERR_HW_ERROR;
> +
> +	mutex_lock(&sev->fw_lock);
> +	cancel = sev->fw_cancel;
> +	mutex_unlock(&sev->fw_lock);
> +
> +	if (cancel)
> +		return FW_UPLOAD_ERR_CANCELED;
> +
> +	/*
> +	 * SEV firmware update is a one-shot update operation, the write()
> +	 * callback to be invoked multiple times for the same update is
> +	 * unexpected.
> +	 */
> +	if (offset)
> +		return FW_UPLOAD_ERR_INVALID_SIZE;
> +
> +	if (sev_get_api_version())
> +		return FW_UPLOAD_ERR_HW_ERROR;
> +
> +	api_major = sev->api_major;
> +	api_minor = sev->api_minor;
> +	build     = sev->build;
> +
> +	data_size = ALIGN(sizeof(struct sev_data_download_firmware_ex),
> +			  SEV_FW_ALIGNMENT);
> +
> +	order = get_order(size + data_size);
> +	p = alloc_pages(GFP_KERNEL, order);
> +	if (!p) {
> +		ret = FW_UPLOAD_ERR_INVALID_SIZE;
> +		goto fw_err;
> +	}
> +
> +	/*
> +	 * Copy firmware data to a kernel allocated contiguous
> +	 * memory region.
> +	 */
> +	data_ex = page_address(p);
> +	fw_dest = page_address(p) + data_size;
> +	memcpy(fw_dest, data, size);
> +
> +	data_ex->address = __psp_pa(fw_dest);
> +	data_ex->len = size;
> +	data_ex->cmdlen = sizeof(struct sev_data_download_firmware_ex);
> +
> +	/*
> +	 * SNP_COMMIT should be issued explicitly to commit the updated
> +	 * firmware after guest context pages have been updated.
> +	 */
> +
> +	ret = sev_do_cmd(SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX, data_ex, &error);
> +
> +	if (ret) {
> +		ret = snp_dlfw_ex_err_translate(sev, error);
> +		goto free_err;
> +	}
> +
> +	__free_pages(p, order);
> +
> +	/* Need to do a DF_FLUSH after live firmware update */
> +	wbinvd_on_all_cpus();
> +	ret = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, &error);
> +	if (ret) {
> +		dev_dbg(sev->dev, "DF_FLUSH error %d\n", error);
> +		ret = FW_UPLOAD_ERR_HW_ERROR;
> +		goto free_err;

goto fw_err;

> +	}
> +
> +	sev_get_api_version();
> +
> +	/*
> +	 * Force an update of guest context pages after SEV firmware
> +	 * live update by issuing SNP_GUEST_STATUS on all guest
> +	 * context pages.
> +	 */
> +	snp_guest_status = sev_fw_alloc(PAGE_SIZE);
> +	if (!snp_guest_status) {
> +		ret = FW_UPLOAD_ERR_INVALID_SIZE;
> +		goto free_err;

same here, goto fw_err; 

> +	}
> +
> +	/*
> +	 * After the last bound asid-to-gctx page is snp_unbound_gctx_end-many
> +	 * unbound gctx pages that also need updating.
> +	 */
> +	for (int i = 1; i <= sev->last_snp_asid + sev->snp_unbound_gctx_end; i++) {
> +		if (sev->snp_asid_to_gctx_pages_map[i]) {
> +			status_data.gctx_paddr = sev->snp_asid_to_gctx_pages_map[i];
> +			status_data.address = __psp_pa(snp_guest_status);
> +			ret = sev_do_cmd(SEV_CMD_SNP_GUEST_STATUS, &status_data, &error);
> +			if (ret) {
> +				/*
> +				 * Handle race with SNP VM being destroyed/decommissoned,
> +				 * if guest context page invalid error is returned,
> +				 * assume guest has been destroyed.
> +				 */
> +				if (error == SEV_RET_INVALID_GUEST)
> +					continue;
> +				sev->synthetic_restore_required = true;
> +				dev_err(sev->dev, "Failed to update SNP GCTX after firmware update, %#x\n", error);
> +				dev_err(sev->dev, "Need to do manual SNP firmware rollback!!!\n");
> +				snp_free_firmware_page(snp_guest_status);
> +				ret = FW_UPLOAD_ERR_RW_ERROR;
> +				goto free_err;

same here, goto fw_err;

Thanks,
Ashish

> +			}
> +		}
> +	}
> +	snp_free_firmware_page(snp_guest_status);
> +
> +	if (api_major != sev->api_major || api_minor != sev->api_minor ||
> +	    build != sev->build) {
> +		dev_info(sev->dev, "SEV firmware updated from %d.%d.%d to %d.%d.%d\n",
> +			 api_major, api_minor, build,
> +			 sev->api_major, sev->api_minor, sev->build);
> +	} else {
> +		dev_info(sev->dev, "SEV firmware same as old %d.%d.%d\n",
> +			 api_major, api_minor, build);
> +	}
> +
> +	*written = size;
> +	return FW_UPLOAD_ERR_NONE;
> +
> +free_err:
> +	__free_pages(p, order);
> +fw_err:
> +	return ret;
> +}
> +
> +static const struct fw_upload_ops snp_dlfw_ex_ops = {
> +        .prepare = snp_dlfw_ex_prepare,
> +        .write = snp_dlfw_ex_write,
> +        .poll_complete = snp_dlfw_ex_poll_complete,
> +        .cancel = snp_dlfw_ex_cancel,
> +};
> +
> +static void sev_snp_dev_init_firmware_upload(struct sev_device *sev)
> +{
> +	struct fw_upload *fwl;
> +
> +	fwl = firmware_upload_register(THIS_MODULE, sev->dev, "snp_dlfw_ex", &snp_dlfw_ex_ops, sev);
> +
> +	if (IS_ERR(fwl))
> +		dev_err(sev->dev, "SEV firmware upload failed to initialize, err %ld\n", PTR_ERR(fwl));
> +
> +	sev->fwl = fwl;
> +	mutex_init(&sev->fw_lock);
> +}
> +
> +static void sev_snp_destroy_firmware_upload(struct sev_device *sev)
> +{
> +	firmware_upload_unregister(sev->fwl);
> +}
> +
> +/*
> + * After a gctx is created, it is used by snp_launch_start before getting
> + * bound to an asid. The launch protocol allocates an asid before creating a
> + * matching gctx page, so there should never be more unbound gctx pages than
> + * there are possible SNP asids.
> + *
> + * The unbound gctx pages must be updated after executing DOWNLOAD_FIRMWARE_EX
> + * and before committing the firmware.
> + */
> +static void snp_gctx_create_track_locked(struct sev_device *sev, void *data)
> +{
> +	struct sev_data_snp_addr *gctx_create = data;
> +
> +	/* This condition should never happen, but is needed for memory safety. */
> +	if (sev->snp_unbound_gctx_end >= sev->last_snp_asid) {
> +		dev_warn(sev->dev, "Too many unbound SNP GCTX pages to track\n");
> +		return;
> +	}
> +
> +	sev->snp_unbound_gctx_pages[sev->snp_unbound_gctx_end] = gctx_create->address;
> +	sev->snp_unbound_gctx_end++;
> +}
> +
> +/*
> + * PREREQUISITE: The snp_activate command was successful, meaning the asid
> + * is in the acceptable range 1..sev->last_snp_asid.
> + *
> + * The gctx_paddr must be in the unbound gctx buffer.
> + */
> +static void snp_activate_track_locked(struct sev_device *sev, void *data)
> +{
> +	struct sev_data_snp_activate *data_activate = data;
> +
> +	sev->snp_asid_to_gctx_pages_map[data_activate->asid] = data_activate->gctx_paddr;
> +
> +	for (int i = 0; i < sev->snp_unbound_gctx_end; i++) {
> +		if (sev->snp_unbound_gctx_pages[i] == data_activate->gctx_paddr) {
> +			/*
> +			 * Swap the last unbound gctx page with the now-bound
> +			 * gctx page to shrink the buffer.
> +			 */
> +			sev->snp_unbound_gctx_end--;
> +			sev->snp_unbound_gctx_pages[i] = sev->snp_unbound_gctx_pages[sev->snp_unbound_gctx_end];
> +			sev->snp_unbound_gctx_pages[sev->snp_unbound_gctx_end] = 0;
> +			break;
> +		}
> +	}
> +}
> +
> +static void snp_decommission_track_locked(struct sev_device *sev, void *data)
> +{
> +	struct sev_data_snp_addr *data_decommission = data;
> +
> +	for (int i = 1; i <= sev->last_snp_asid; i++) {
> +		if (sev->snp_asid_to_gctx_pages_map[i] == data_decommission->address) {
> +			sev->snp_asid_to_gctx_pages_map[i] = 0;
> +			break;
> +		}
> +	}
> +}
> +
> +static void snp_cmd_bookkeeping_locked(int cmd, struct sev_device *sev, void *data)
> +{
> +	if (!sev->snp_asid_to_gctx_pages_map)
> +		return;
> +
> +	switch (cmd)
> +	{
> +	case SEV_CMD_SNP_GCTX_CREATE:
> +		snp_gctx_create_track_locked(sev, data);
> +		break;
> +	case SEV_CMD_SNP_ACTIVATE:
> +		snp_activate_track_locked(sev, data);
> +		break;
> +	case SEV_CMD_SNP_DECOMMISSION:
> +		snp_decommission_track_locked(sev, data);
> +		break;
> +	default:
> +		;
> +	}
> +}
> +
> +static int sev_snp_platform_init_firmware_upload(struct sev_device *sev)
> +{
> +	u32 max_snp_asid;
> +
> +	/*
> +	 * cpuid_edx(0x8000001f) is the minimum SEV ASID, hence the exclusive
> +	 * maximum SEV-SNP ASID. Save the inclusive maximum to avoid confusing
> +	 * logic elsewhere.
> +	 */
> +	max_snp_asid = cpuid_edx(0x8000001f);
> +	sev->last_snp_asid = max_snp_asid - 1;
> +	if (sev->last_snp_asid) {
> +		sev->snp_asid_to_gctx_pages_map = devm_kmalloc_array(
> +			sev->dev, max_snp_asid * 2, sizeof(u64), GFP_KERNEL | __GFP_ZERO);
> +		sev->snp_unbound_gctx_pages = &sev->snp_asid_to_gctx_pages_map[max_snp_asid];
> +		if (!sev->snp_asid_to_gctx_pages_map) {
> +			kfree(snp_range_list);
> +			dev_err(sev->dev,
> +				"SEV-SNP: snp_asid_to_gctx_pages_map memory allocation failed\n");
> +			return -ENOMEM;
> +		}
> +	}
> +	return 0;
> +}
> +
> +#else
> +
> +static int sev_snp_platform_init_firmware_upload(struct sev_device *sev) { return 0; }
> +static void sev_snp_dev_init_firmware_upload(struct sev_device *sev) { }
> +static void sev_snp_destroy_firmware_upload(struct sev_device *sev) { }
> +static void snp_cmd_bookkeeping_locked(int cmd, struct sev_device *sev, void *data) { }
> +#endif
> +
>  int sev_dev_init(struct psp_device *psp)
>  {
>  	struct device *dev = psp->dev;
> @@ -2265,6 +2643,8 @@ int sev_dev_init(struct psp_device *psp)
>  	if (ret)
>  		goto e_irq;
>  
> +	sev_snp_dev_init_firmware_upload(sev);
> +
>  	dev_notice(dev, "sev enabled\n");
>  
>  	return 0;
> @@ -2343,6 +2723,8 @@ void sev_dev_destroy(struct psp_device *psp)
>  		kref_put(&misc_dev->refcount, sev_exit);
>  
>  	psp_clear_sev_irq_handler(psp);
> +
> +	sev_snp_destroy_firmware_upload(sev);
>  }
>  
>  static int snp_shutdown_on_panic(struct notifier_block *nb,
> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> index 3e4e5574e88a3..d6280688675d9 100644
> --- a/drivers/crypto/ccp/sev-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -57,6 +57,20 @@ struct sev_device {
>  	bool cmd_buf_backup_active;
>  
>  	bool snp_initialized;
> +
> +#ifdef CONFIG_FW_UPLOAD
> +	/* Lock to protect fw_cancel */
> +	struct mutex fw_lock;
> +	struct fw_upload *fwl;
> +	bool fw_cancel;
> +
> +	/* Firmware update management. */
> +	u32 last_snp_asid;
> +	bool synthetic_restore_required;
> +	u64 *snp_asid_to_gctx_pages_map;
> +	u64 *snp_unbound_gctx_pages;
> +	u32 snp_unbound_gctx_end;
> +#endif /* CONFIG_FW_UPLOAD */
>  };
>  
>  int sev_dev_init(struct psp_device *psp);
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 903ddfea85850..61ed2f8179946 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -16,6 +16,15 @@
>  
>  #define SEV_FW_BLOB_MAX_SIZE	0x4000	/* 16KB */
>  
> +/*
> + * SEV FW expects the physical address given to it to be 32
> + * byte aligned. Memory allocated has structure placed at the
> + * beginning followed by the firmware being passed to the SEV
> + * FW. Allocate enough memory for data structure + alignment
> + * padding + SEV FW.
> + */
> +#define SEV_FW_ALIGNMENT	32
> +
>  /**
>   * SEV platform state
>   */
> @@ -185,6 +194,22 @@ struct sev_data_download_firmware {
>  	u32 len;				/* In */
>  } __packed;
>  
> +/**
> + * struct sev_data_download_firmware_ex - DOWNLOAD_FIRMWARE_EX command parameters
> + *
> + * @length: length of this command buffer
> + * @address: physical address of firmware image
> + * @len: len of the firmware image
> + * @commit: automatically commit the newly installed image
> + */
> +struct sev_data_download_firmware_ex {
> +	u32 cmdlen;				/* In */
> +	u32 reserved;				/* in */
> +	u64 address;				/* In */
> +	u32 len;				/* In */
> +	u32 commit:1; 				/* In */
> +} __packed;
> +
>  /**
>   * struct sev_data_get_id - GET_ID command parameters
>   *
> @@ -797,10 +822,13 @@ struct sev_data_snp_shutdown_ex {
>   * @probe: True if this is being called as part of CCP module probe, which
>   *  will defer SEV_INIT/SEV_INIT_EX firmware initialization until needed
>   *  unless psp_init_on_probe module param is set
> + * @supports_download_firmware_ex: True if legacy SEV/SEV-ES guests are not
> + *  being launched via KVM
>   */
>  struct sev_platform_init_args {
>  	int error;
>  	bool probe;
> +	bool supports_download_firmware_ex;
>  };
>  
>  /**
> diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
> index 832c15d9155bd..936464d4f282a 100644
> --- a/include/uapi/linux/psp-sev.h
> +++ b/include/uapi/linux/psp-sev.h
> @@ -80,6 +80,11 @@ typedef enum {
>  	SEV_RET_INVALID_PAGE_OWNER,
>  	SEV_RET_INVALID_PAGE_AEAD_OFLOW,
>  	SEV_RET_RMP_INIT_REQUIRED,
> +	SEV_RET_BAD_SVN,
> +	SEV_RET_BAD_VERSION,
> +	SEV_RET_SHUTDOWN_REQUIRED,
> +	SEV_RET_UPDATE_FAILED,
> +	SEV_RET_RESTORE_REQUIRED,
>  	SEV_RET_MAX,
>  } sev_ret_code;
>  
