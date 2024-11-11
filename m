Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B884C1BD9D1;
	Mon, 11 Nov 2024 21:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731361706; cv=fail; b=S1uRzjghla/R9fLsUykBT9OHpgooiEBzlv+FHeeZdWxl9an5Jaw1c/iZrCETGKvpN33ZL+92QC/GBIWWLbLG7hZWeLNagvk1IHqWfV4M6ZHmi2whBZf1djzrUa9hAgqxHQU4TShmsJFDdbypC2p43Ft+pv1QaVWXxgx1DbF76sw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731361706; c=relaxed/simple;
	bh=kLj6Ik85s0l9HlhSSzEMTI2dLEdvjnFY9OKZXFnAsS8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ezizTMnEmZWmT0OcQKs3zY2CHqqUZkONoxS9iBoj5UUNe28vOEvwttzF2KYUgonV9st6eRQgfkSgw0tznts20Ble+e+HSEesA2Xz+LFFsZQqQH6wCv+cULneB9w5hhMOdgUfOQrMpV+mhVERZE7gjvku60EbxkFYxQB07eSa/VE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=r7DLaB2x; arc=fail smtp.client-ip=40.107.243.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="r7DLaB2x"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SbP3wnGgW0eVg3fsnwpvQJ1MyaiE0jfUclxo5FhaYDqixpcLQoxXrU7PQuUg+SzSbiGrQVXX0svR/KsEVf5oG+JmrR3dRsMVvoYLGvxevNjW2pShQoWSwyNlizv0s9APjzEN68KyTB+fpnxqf1XXJCJu2jUEluH+a783RkkWIzm8WuDBMh9+y6HyyzsbtMKz1r+M1youSD79Vnk1rfmZpKH34oU+jmLGB4/HBjDyHeJvBh3U3ltSD0sj5vmZAGVT28DJnUUnJD31153RJzr9GZDy6Ew3qvJK9XesgRhrpUoWiJghJeILo8yKPSbdiw2kdREfvWTdcxGTNT2ArWrEWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HjLWQigAULcfQ1UoZYrGaac3XU+mhrMh33GPO8V7sOc=;
 b=EYBoVbVPIo0vPaVqcP1m6XfMRtkvemvhKA9PImRXcYEt85zMlOc6GUOb+ZRi9Rq84gek9bA/CkIyD7mSDu8SfPzeAMSOnKrCpUdbD7SN7kfXxErAi7oRUsE7KQO9oEcQ38zlk3LU+6RvepdnUxu4CkRwiHGTX/U01g23EgrLLeXK1x2twZT18NcTah1LzTU2b8iPxzbvhuozyzuVGVT8REOpoTrjHl1Jg9zt4QOjjDcD3+p4huznevlDUDZgSLp/zQmYQpxhZq+aOf0kan6QgAfJ0XFlOHXwELJPdoZx3paVRQwEfVDwTy1VoowzoPpqF5LCfeX7W0peGgB0Kik06Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HjLWQigAULcfQ1UoZYrGaac3XU+mhrMh33GPO8V7sOc=;
 b=r7DLaB2x4ERgy+mZJsQfhtwlWMbr/ULYGv/0aQiRL+T5ltApjrnwYcn0ge3/g8AfR0hQvEV7iMmf98si/Aeji4JoY9OBxAo+5PNcCno7zPBRO3dOOI+zYbW7DM7vO9qsXYtv7ohoJnjEeVA2itXYxxQS4h019Zoujcgn+Ea5sO4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by LV3PR12MB9331.namprd12.prod.outlook.com (2603:10b6:408:219::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.25; Mon, 11 Nov
 2024 21:48:21 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%4]) with mapi id 15.20.8137.027; Mon, 11 Nov 2024
 21:48:21 +0000
Message-ID: <cf76773f-da7d-4eec-9782-8555bf88c907@amd.com>
Date: Mon, 11 Nov 2024 15:48:08 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/10] crypto: ccp: Add GCTX API to track ASID
 assignment
Content-Language: en-US
To: Dionna Amalie Glaze <dionnaglaze@google.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
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
 <1719bdda-d901-4ff1-858d-f4ec0efddd90@amd.com>
 <CAAH4kHZWnbYRYJ6yCqemOtcVNjpn=Bpzr-Oe3O+XzAgNtph7mA@mail.gmail.com>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <CAAH4kHZWnbYRYJ6yCqemOtcVNjpn=Bpzr-Oe3O+XzAgNtph7mA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0063.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:99::23) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|LV3PR12MB9331:EE_
X-MS-Office365-Filtering-Correlation-Id: 7beea34e-4d74-4f4c-939f-08dd029a8f6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R1NydnF6SHJhemFJcGtOS2N6Z0tpbTRRRWdQUTI2MUR5MzgraVBZMVl4eHpq?=
 =?utf-8?B?bjJ2M1g0V0l3M3gxWGdYbzZFSGg1WGtWMjgxbGpEWG5OVlVRVEVFSjU0VDRi?=
 =?utf-8?B?SWNncUJEYmJYL1llMGNBVUdhN2xqUlc4NEs2SSs1TThyZVpMQmZ3NWFULzdw?=
 =?utf-8?B?ZFNYcVRNV1FlMWwxVlgyN0xpdmg5NHl6M0Q0UXZBeWd3RkdCUGRacVVMT1Bm?=
 =?utf-8?B?K1dLaHFEayt1ai9EUHE5UkZoSjNWZ1dQS2hLWGlXU0ZBVjNBZlFubVRIK1pW?=
 =?utf-8?B?SjFmbGExd3VucGZuLzRZVzd2UTYwS003MjZvQUpETkpaY2FKdU1kNThDTE9X?=
 =?utf-8?B?YlZkTzZJc085MHl2Q1ZzRFFmcnZtWS9sSFFkSU5HbCt4UExiblJzQWNtWnJO?=
 =?utf-8?B?L2pjb3ZGU3lUdDZ4WVRWQlNkVm5BeUxVc1RLam1mTHZoKzA4VWU0dVBPVmxY?=
 =?utf-8?B?Ukh4Vm9MN2NhUVI5NXhzemNvQnZySnhjR1ROM0lkVUhMeWp4QllaWE1wZWRH?=
 =?utf-8?B?SUFhd2wwYXJyTnN5YmttZk51S2xHdVd2dzV5bnltWGNUVVhrbTdYdWF4SmhV?=
 =?utf-8?B?dG1Gd05IeHo5bXFGNjNFTEl6TUZNaGkzMTJEL0lES3lpRmJjUjduTEtORXcr?=
 =?utf-8?B?MExIVHpCQzVkalNpblJDWG9wWVZMZ3R2Q2NIekx4VWtZVWZkajJ0K1p1bDhh?=
 =?utf-8?B?WE81VEd2ZXovK0NVWGc0ZWNGMjQraGQxbkxSbFowWlQvVkk1SUpIYk12Y3ox?=
 =?utf-8?B?bjFSYWxtRmRMbkVRWUJISnJ5d2RVYjBmbW5keDBLNDJXNHF5WHhMS01Rc1la?=
 =?utf-8?B?WUUyZkFVcHNsblhES0RxUVVSTDczTlMwZjE3eFJrQmF6VGY0c0NleXRHaUNx?=
 =?utf-8?B?MmxhQ2pCR3cwWm9BL3VWQ2ZjakJvdS9zSmFEQkVIWmxMb3QwK3BLVm5mYjdX?=
 =?utf-8?B?eWsvd04rNlNncStvU09na3RQT1VWQlhvT0tXV0NwdVZheXZEWnpYMTlHRGlo?=
 =?utf-8?B?Q29vN2grYzVjdmk3S284aXNJT0Y1VUxHU3pBbit1NFZUTnl6VllzZUhBbFdJ?=
 =?utf-8?B?QWVBK0dLN3l6blowQ3NIenIwbFBoRnpqcEZqbG5HalBtRU9FRU9VMUk0bWVq?=
 =?utf-8?B?WVVyMW5DcHhENGpEd3ZHbEpqV211dm40NlZnVVZiYjVCRVVsVWlTMUZtMWda?=
 =?utf-8?B?b2d4UWpwSy9Dbm41Z2ZGWDY0cFo5alVPMHI2Z3ZWVTlCdmFuWVdXOG82NTJ3?=
 =?utf-8?B?MUswT21BZkRuakxBZ2NkSjZNMFViZ2d4b0xLcHYvakdDSllmelhsZndQRVpZ?=
 =?utf-8?B?a2xHQ0ZZMkJZWk1lcHZtd01oSmNxL2lxODE2bVQxVzlhQkNESnRTV1VaU2NQ?=
 =?utf-8?B?TjFmK0Nud01PUDZPUVk1L1NyaHpBMFBjdXMwandFblRQUWFXejlYZno0a3lj?=
 =?utf-8?B?dlkyMFRlOEdrbHFOWGFaVTlLdjEwbnFyN0FFaFd0V0lqL085TDdXamFtRXVk?=
 =?utf-8?B?OFFpaytvalhSQUJjSmtUb21RYXZqQlMxVmY2cmhRRFFzbHRWWTVERmZ6UC9C?=
 =?utf-8?B?MTNJMjdKb2lTdnlua3dGUDVNOUxEMWRkeEVScEo0dkZ5SWM2QlI4VjNtY0N4?=
 =?utf-8?B?OUpDd2kvNWMzTXgrQWhQR0RyZTVxakdDalg1aWt3YkdTVkRzdENuaU9uQ2dp?=
 =?utf-8?B?b3RqYTFpazlnT0VhQThNU1dGcHVlWkQvdXZKcjU4SElIRGlKdDhpWjRldGhZ?=
 =?utf-8?Q?2HD20X8zkyVgxIdkSctrnQ+804HJFdA+8xndaci?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aDByZzRwdHhJQkRoYlBVUXRMVEMxSVVWUUNwT0RiV1hPb1VkVUxTbVdJaW5H?=
 =?utf-8?B?dWRySVRBT3JoZXJQUFRBVW5IajZaVjgwWWlseGZEK1pkeHNoMzhwem1XYi9U?=
 =?utf-8?B?TXBNeXE2TlQyTkU2V1lFQmhjb2tHbXlIWlRGY2xqeUNrRzlBL1RoTHFmeXdT?=
 =?utf-8?B?d0g1Y3NBY3lwc0ZpNmRNZ3htUnlnWVV1aytkNUFXZXppWDdPa0Z0NXZES3E2?=
 =?utf-8?B?eVA0bnNtY0NTVXVIUmNoUmQ1QkRoR295Vm85RTRXQ1hLUWtnemhDQW82dFUz?=
 =?utf-8?B?QUYxRmpPT29EWUhjYXVKUXBEQXpCYUhCaU1xcGFHUUUyamk2dlZRZ1JGOUZS?=
 =?utf-8?B?a3BMdUhVTTFPd0xqQm1ldXpwOU5wWFBZOThiUGgvT0xEMHAyY1hJazJGQ3Fj?=
 =?utf-8?B?QVBQL1FnR3dVbXl3OGV6cDhmbTVDUjkxMXRhM1UwRWlQOEdiRS9MRDlxc2Zo?=
 =?utf-8?B?WDlqMVhOaGxoWmtZYjFEWVdIV0NBemplZXJ3b0c0OCtCeFZRd3pNdW5VL1lV?=
 =?utf-8?B?dFRuYXA0RXB2S0ZwRWdzZzQ5OW1zVnl4b2cwR2tTOXNFVWNNRmpsRGtWOWZD?=
 =?utf-8?B?NDdsQ2RrOUI3Nk9KOWFyMlJTY21JUFFRWGpYQ0g2SlRXaWlHSUY5Rk1xL014?=
 =?utf-8?B?RkpyTXNkMWE1SFhEWGN3aEhSTTZnaCs3TXN5S0gvbE92Z3oyQkhaV3dJcklr?=
 =?utf-8?B?WFh4bS9pNk1BMmRrR2t2Tk1nUnJpMk9NUkhoY3MzampCZXlkNWlaSGh3Ymdt?=
 =?utf-8?B?T2xVYlJmRjRhZGdqNFIvV3V2N2tuWTN2bU5GbkgzbkdkN3pRUVJmV3pqdUZ4?=
 =?utf-8?B?V2tSY3JaNWJVZWt6QzBMbGRNZmd5dnhmZ1k2ckd4MFJnanl4NUtmZ3MyVlQ2?=
 =?utf-8?B?ajNDcHBobXhDTXRhbTNhdjdTYTcwa3h5S0lVRlc5YXJnLzBtVGxLcXBXaHNW?=
 =?utf-8?B?UFI2WjFhd3ArTG84dFJiRGN2azF1a3BVbnE1V1V3MjVIcCtqcmptdzFQbVpt?=
 =?utf-8?B?WlZvTVdyVFVVU3F0ZE5RZ3J3V0daam96U2ZlLzY5TDRibGNtZ1JGcmtYQ0xB?=
 =?utf-8?B?VkludkttQXF3Vzc0UjBqQ25UcG5RT3o1MWVTMm1DOTVreGovamVnNExWNEU4?=
 =?utf-8?B?RVR3SVFMUWI2bjNndnlYUDUzamw4d0lkOUpDUkttZkx4STNyeG9Id0cxZDdJ?=
 =?utf-8?B?U1dZcjE1OWc4ZVhBREhRNWV0WEhlUUJBN3hUdWZWMlJCQ2RpQStTZUdCSktj?=
 =?utf-8?B?dk5OZnB6QUZOaXQzMGExOWtSTDlkQW8yN1plckcwb2tCalEwMFAzSzM5NFVM?=
 =?utf-8?B?eGlseVVyVEZ6L0ViRDNyQzlqTlZPOVZYVWoyUkY1dUhSMzU3d2VEWkdQWjVF?=
 =?utf-8?B?Sys3Qlo0MUFsL0tkcy85YnBXK21NYWR3bWpaKzJkelRTdk9aOVlsMlMxdDFr?=
 =?utf-8?B?REFuN2Q2N2J3QlRUVVRDZ21manZDa2dqQVp6Ukh1Z0JCYnBoR3NTcldrL1NP?=
 =?utf-8?B?UklWQm42WUFDeUJSQ05IUzdaY1NHUlNYUzV4UDNRTE82TFlTSC9UbnZWS0Js?=
 =?utf-8?B?SUhEVFUvcndvLzUrZDZZTGN0S0xwYnhWeWxxbFhkSmhpUEZzUFBhckVIQjdt?=
 =?utf-8?B?aWllWnJJYVJpZ3UvQUV2VjNMMDdUL1ROaFpmSVpmaE15UmRMVXBsWVJxeWFu?=
 =?utf-8?B?SFR1U05FWE0zRndqYzZxWENoNTdObG9FMkR2QXF1cUNSTnpJUUk4Zm5VTnph?=
 =?utf-8?B?RzNsWnIzM21EZklKajBpcUNzczFnb1BYRzZVY3Fha1FScDdnZ1k4U0szUG1p?=
 =?utf-8?B?UEN6NFkyMWdFRXB4c2JxUHE5U0FFRGFIN04vVkQvNXllZHFCME1ramt6Q0l4?=
 =?utf-8?B?TnluQnh3OW5tLzc3R2ZwQVp1ZFRxTk9iWDc3Y21PSjI1TEFPVVU3KzhDWFpC?=
 =?utf-8?B?aTdxcGdzQjFDWWIxWHJWSlNkRU8xOVJQaGFWdGpwdTBLWTlBRTBaY2JJUkMr?=
 =?utf-8?B?YUhCRjVoSnUzU2t1aWhVbGJRL0l0eHBkcFNVTFZrOWp6d3VJcTJ0amtqdzFu?=
 =?utf-8?B?QkVVSUJPQXQ4N0tqQ2FIUGdFQStPUjFERjBQeVVBT0s4NHZZdHdYU1lVSG91?=
 =?utf-8?Q?e+z25YfCq8pd8VdusBc+VaHr8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7beea34e-4d74-4f4c-939f-08dd029a8f6d
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 21:48:21.4278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n4lLhsayhIef24fg7L9JC+eibr136p8B6laaua5hPYxicOQd0QCDluRIGSEw0tmkqZAhg8CZao4SA/i26KD3bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9331



On 11/11/2024 3:35 PM, Dionna Amalie Glaze wrote:
> On Mon, Nov 11, 2024 at 1:16 PM Kalra, Ashish <ashish.kalra@amd.com> wrote:
>>
>>
>>
>> On 11/7/2024 5:24 PM, Dionna Glaze wrote:
>>> In preparation for SEV firmware hotloading support, introduce a new way
>>> to create, activate, and decommission GCTX pages such that ccp is has
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
>>> @@ -109,6 +109,10 @@ static void *sev_init_ex_buffer;
>>>   */
>>>  static struct sev_data_range_list *snp_range_list;
>>>
>>> +/* SEV ASID data tracks resources associated with an ASID to safely manage operations. */
>>> +struct sev_asid_data *sev_asid_data;
>>> +u32 nr_asids, sev_min_asid, sev_max_asid, sev_es_max_asid;
>>
>> This looks to be duplication of ASID management variables and support in KVM.
>>
> 
> Agreed, though there will be duplication until all of the replacement
> is ready and KVM can swap over.
> 
>> Probably this stuff needs to be merged with the ASID refactoring work being done to
>> move all SEV/SNP ASID allocation/management stuff to CCP from KVM.
>>
> 
> Who's doing that work? I'm not clear on timelines either.

I am currently working on this refactoring work.

> If it's
> currently underway, do you see a rebase on this patch set as
> particularly challenging?

No i don't think it will be difficult to rebase the refactoring work 
with respect to this patchset.

Thanks,
Ashish

> I wouldn't want to block hotloading support until it's all ready.
> 
>>> +
>>>  static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
>>>  {
>>>       struct sev_device *sev = psp_master->sev_data;
>>> @@ -1093,6 +1097,81 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>>>       return 0;
>>>  }
>>>
>>> +void *sev_snp_create_context(int asid, int *psp_ret)
>>> +{
>>> +     struct sev_data_snp_addr data = {};
>>> +     void *context;
>>> +     int rc;
>>> +
>>> +     if (!sev_asid_data)
>>> +             return ERR_PTR(-ENODEV);
>>> +
>>> +     /* Can't create a context for a used ASID. */
>>> +     if (sev_asid_data[asid].snp_context)
>>> +             return ERR_PTR(-EBUSY);
>>> +
>>> +     /* Allocate memory for context page */
>>> +     context = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
>>> +     if (!context)
>>> +             return ERR_PTR(-ENOMEM);
>>> +
>>> +     data.address = __psp_pa(context);
>>> +     rc = sev_do_cmd(SEV_CMD_SNP_GCTX_CREATE, &data, psp_ret);
>>> +     if (rc) {
>>> +             pr_warn("Failed to create SEV-SNP context, rc %d fw_error %d",
>>> +                     rc, *psp_ret);
>>> +             snp_free_firmware_page(context);
>>> +             return ERR_PTR(-EIO);
>>> +     }
>>> +
>>> +     sev_asid_data[asid].snp_context = context;
>>> +
>>> +     return context;
>>> +}
>>> +
>>> +int sev_snp_activate_asid(int asid, int *psp_ret)
>>> +{
>>> +     struct sev_data_snp_activate data = {0};
>>> +     void *context;
>>> +
>>> +     if (!sev_asid_data)
>>> +             return -ENODEV;
>>> +
>>> +     context = sev_asid_data[asid].snp_context;
>>> +     if (!context)
>>> +             return -EINVAL;
>>> +
>>> +     data.gctx_paddr = __psp_pa(context);
>>> +     data.asid = asid;
>>> +     return sev_do_cmd(SEV_CMD_SNP_ACTIVATE, &data, psp_ret);
>>> +}
>>> +
>>> +int sev_snp_guest_decommission(int asid, int *psp_ret)
>>> +{
>>> +     struct sev_data_snp_addr addr = {};
>>> +     struct sev_asid_data *data = &sev_asid_data[asid];
>>> +     int ret;
>>> +
>>> +     if (!sev_asid_data)
>>> +             return -ENODEV;
>>> +
>>> +     /* If context is not created then do nothing */
>>> +     if (!data->snp_context)
>>> +             return 0;
>>> +
>>> +     /* Do the decommision, which will unbind the ASID from the SNP context */
>>> +     addr.address = __sme_pa(data->snp_context);
>>> +     ret = sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, &addr, NULL);
>>> +
>>> +     if (WARN_ONCE(ret, "Failed to release guest context, ret %d", ret))
>>> +             return ret;
>>> +
>>> +     snp_free_firmware_page(data->snp_context);
>>> +     data->snp_context = NULL;
>>> +
>>> +     return 0;
>>> +}
>>> +
>>>  static int __sev_snp_init_locked(int *error)
>>>  {
>>>       struct psp_device *psp = psp_master;
>>> @@ -1306,6 +1385,27 @@ static int __sev_platform_init_locked(int *error)
>>>       return 0;
>>>  }
>>>
>>> +static int __sev_asid_data_init(void)
>>> +{
>>> +     u32 eax, ebx;
>>> +
>>> +     if (sev_asid_data)
>>> +             return 0;
>>> +
>>> +     cpuid(0x8000001f, &eax, &ebx, &sev_max_asid, &sev_min_asid);
>>> +     if (!sev_max_asid)
>>> +             return -ENODEV;
>>> +
>>> +     nr_asids = sev_max_asid + 1;
>>> +     sev_es_max_asid = sev_min_asid - 1;
>>> +
>>> +     sev_asid_data = kcalloc(nr_asids, sizeof(*sev_asid_data), GFP_KERNEL);
>>> +     if (!sev_asid_data)
>>> +             return -ENOMEM;
>>> +
>>> +     return 0;
>>> +}
>>
>> Again, looks to be duplicating ASID setup code in sev_hardware_setup() (in KVM),
>> maybe all this should be part of the ASID refactoring work to move all SEV/SNP
>> ASID code to CCP from KVM module, that should then really streamline all ASID/GCTX
>> tracking.
>>
>> Thanks,
>> Ashish
>>
>>> +
>>>  static int _sev_platform_init_locked(struct sev_platform_init_args *args)
>>>  {
>>>       struct sev_device *sev;
>>> @@ -1319,6 +1419,10 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
>>>       if (sev->state == SEV_STATE_INIT)
>>>               return 0;
>>>
>>> +     rc = __sev_asid_data_init();
>>> +     if (rc)
>>> +             return rc;
>>> +
>>>       /*
>>>        * Legacy guests cannot be running while SNP_INIT(_EX) is executing,
>>>        * so perform SEV-SNP initialization at probe time.
>>> @@ -2329,6 +2433,9 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic)
>>>               snp_range_list = NULL;
>>>       }
>>>
>>> +     kfree(sev_asid_data);
>>> +     sev_asid_data = NULL;
>>> +
>>>       __sev_snp_shutdown_locked(&error, panic);
>>>  }
>>>
>>> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
>>> index 3e4e5574e88a3..7d0fdfdda30b6 100644
>>> --- a/drivers/crypto/ccp/sev-dev.h
>>> +++ b/drivers/crypto/ccp/sev-dev.h
>>> @@ -65,4 +65,12 @@ void sev_dev_destroy(struct psp_device *psp);
>>>  void sev_pci_init(void);
>>>  void sev_pci_exit(void);
>>>
>>> +struct sev_asid_data {
>>> +     void *snp_context;
>>> +};
>>> +
>>> +/* Extern to be shared with firmware_upload API implementation if configured. */
>>> +extern struct sev_asid_data *sev_asid_data;
>>> +extern u32 nr_asids, sev_min_asid, sev_max_asid, sev_es_max_asid;
>>> +
>>>  #endif /* __SEV_DEV_H */
>>> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
>>> index 903ddfea85850..ac36b5ddf717d 100644
>>> --- a/include/linux/psp-sev.h
>>> +++ b/include/linux/psp-sev.h
>>> @@ -942,6 +942,58 @@ int sev_guest_decommission(struct sev_data_decommission *data, int *error);
>>>   */
>>>  int sev_do_cmd(int cmd, void *data, int *psp_ret);
>>>
>>> +/**
>>> + * sev_snp_create_context - allocates an SNP context firmware page
>>> + *
>>> + * Associates the created context with the ASID that an activation
>>> + * call after SNP_LAUNCH_START will commit. The association is needed
>>> + * to track active guest context pages to refresh during firmware hotload.
>>> + *
>>> + * @asid:    The ASID allocated to the caller that will be used in a subsequent SNP_ACTIVATE.
>>> + * @psp_ret: sev command return code.
>>> + *
>>> + * Returns:
>>> + * A pointer to the SNP context page, or an ERR_PTR of
>>> + * -%ENODEV    if the PSP device is not available
>>> + * -%ENOTSUPP  if PSP device does not support SEV
>>> + * -%ETIMEDOUT if the SEV command timed out
>>> + * -%EIO       if PSP device returned a non-zero return code
>>> + */
>>> +void *sev_snp_create_context(int asid, int *psp_ret);
>>> +
>>> +/**
>>> + * sev_snp_activate_asid - issues SNP_ACTIVATE for the ASID and associated guest context page.
>>> + *
>>> + * @asid:    The ASID to activate.
>>> + * @psp_ret: sev command return code.
>>> + *
>>> + * Returns:
>>> + * 0 if the SEV device successfully processed the command
>>> + * -%ENODEV    if the PSP device is not available
>>> + * -%ENOTSUPP  if PSP device does not support SEV
>>> + * -%ETIMEDOUT if the SEV command timed out
>>> + * -%EIO       if PSP device returned a non-zero return code
>>> + */
>>> +int sev_snp_activate_asid(int asid, int *psp_ret);
>>> +
>>> +/**
>>> + * sev_snp_guest_decommission - issues SNP_DECOMMISSION for an ASID's guest context page, and frees
>>> + * it.
>>> + *
>>> + * The caller must ensure mutual exclusion with any process that may deactivate ASIDs.
>>> + *
>>> + * @asid:    The ASID to activate.
>>> + * @psp_ret: sev command return code.
>>> + *
>>> + * Returns:
>>> + * 0 if the SEV device successfully processed the command
>>> + * -%ENODEV    if the PSP device is not available
>>> + * -%ENOTSUPP  if PSP device does not support SEV
>>> + * -%ETIMEDOUT if the SEV command timed out
>>> + * -%EIO       if PSP device returned a non-zero return code
>>> + */
>>> +int sev_snp_guest_decommission(int asid, int *psp_ret);
>>> +
>>>  void *psp_copy_user_blob(u64 uaddr, u32 len);
>>>  void *snp_alloc_firmware_page(gfp_t mask);
>>>  void snp_free_firmware_page(void *addr);
> 
> 
> 
