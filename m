Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2053.outbound.protection.outlook.com [40.107.223.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE1035972
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 13:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744033516; cv=fail; b=glDYz3qJcBfH6Ov71YWt2JqBZcvpbNGDuz/+kGTYAm2qmIq331SJhW0gLSwn6buL4JFulLBvum9bcIUmZ20gn+3ccTQ6X8WvyLjiETCS6z0BpTGzb3TsfyBO9PKvdaLdYuX/ITV4NpzWzw3xe42x++KDlKEQQh4OIpUKw4lA1cw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744033516; c=relaxed/simple;
	bh=tPe7L+fb23X2KdpNCO7N2QhbZolaWIo7LdNuEUuKlKQ=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UQI5E+mhHICudGuAaDssrT6zDKPX92J44H8t+50VfEZsVs1UWLU7c/0ltSAiXk4LG8+y7WU8hMiWDZvQY1+zyZfN8VL9iBBpOgafzoP1o8PdR6rkNcwrDr0+xqEevLULLcm2OgJiyVLhuvMjpdzHCiDEy3bO7RPubc/VmiiDJNQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tPvAhdfT; arc=fail smtp.client-ip=40.107.223.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tPvAhdfT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xoAm/S/cBAjBoxL4WD6QY0JjxMxMEZRNDMwFV8pUmhtNaLB2GiUtG2UosMYW3EmJtjeFejQY95f9RYvgrqCpoWwHS5M5U+lP9G5V1f0N23RuYx3CvpJ07pMsM4iaClyx3wzsVVkI3Crz0vQtBZz1f2J1tC4281oJQ0nej/2T9nMl82zl63mnknMDzJvSodoNweF+Vx6zbu0FaIxD6cl8B7W9l7/lXg3LlnXqw5cESfG/yWipqsukerjznCRYTlw2/JsTvf4gv9T10vN5XUXI5SwEMkCZvIW6ZsdRVOSkyYeyf3wp63a4G/AixnBBNHqfclgsNWeA4zwXjMUVkURouQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CVsBQZhadqf6iMo7nxIpjqsEEduNaB9krTlI41K7Oys=;
 b=awaM3z75NyOhEWxHvFm527rrjONFFzeZtlj53eol6M82qS9NNmg9fCm2EeaPS7hqC1mTABI+Bch/LjEJQUbdiJ+JwwqrF8oblN22Jn+Y211RUXRnHeB5/8UHA2/eL1XPXdBjod5GTbFei47OWo3vX/wmMmWkX1huGcmdbP5jFhYwvXG1jmzSUHQSMSlT99U/jkraSkC4oMLIZG0bv7+hghl48TAcEIcJjTywOETdwk2V/UT+UeBjeXmuW+OsVPtm7vPq8JMnT8bEXKOL8v+4MDmT/CHvF2FitHYW7rXi0eojBCBlUqZXgRUuPkqFpzj3cNec3GfsqlfocLa1f73XIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CVsBQZhadqf6iMo7nxIpjqsEEduNaB9krTlI41K7Oys=;
 b=tPvAhdfTQzSz6Y+UYrHTgLKtN5Rmfy4ARZFCB8GiRZ3smvOzTZqze9p3Cx1eByr9jCqjtI7orAKnGSbDDlHFNFRfnrrLsoe3bXJdAxZms67iuarvQpw4Ts7cU9xYVxssApXoy3CPXiNRmAhKK7ZtsLIBDDiOkfrnWmxNHNuqHXw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by MW5PR12MB5684.namprd12.prod.outlook.com (2603:10b6:303:1a1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.31; Mon, 7 Apr
 2025 13:45:11 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8606.029; Mon, 7 Apr 2025
 13:45:10 +0000
Message-ID: <6a3e37ae-ca53-00ac-d164-0b7827d4eec5@amd.com>
Date: Mon, 7 Apr 2025 08:45:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] crypto: ccp - Silence may-be-uninitialized warning in
 sev_ioctl_do_pdh_export
To: Herbert Xu <herbert@gondor.apana.org.au>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Ashish Kalra <ashish.kalra@amd.com>
References: <Z_NbUk4BkRLmdY5p@gondor.apana.org.au>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <Z_NbUk4BkRLmdY5p@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR16CA0058.namprd16.prod.outlook.com
 (2603:10b6:805:ca::35) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|MW5PR12MB5684:EE_
X-MS-Office365-Filtering-Correlation-Id: 1404f3a9-3bc0-4d1b-00f5-08dd75da6a7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MXpJL1I0WWF1MXczRCtRUEIvZVg2OG5EZXFDQ2xKMzgzcW5aTFVRTXBFVzkw?=
 =?utf-8?B?RExldzRvS3JQSzBjMDZ0dmdNbHVGL1dERXJDZ1dMZ2RldDBpWlh5OENzRnVM?=
 =?utf-8?B?bHdhaXJrK3NGU0ZTTzNoeXYrcGh6NUZHem9IRVNIWlFBMWt1MHk4NFJWQnZC?=
 =?utf-8?B?SlJGaUYvNGRYUDh6b2lZYXZhOTZxZzV1aVRBOXQ0R1gzYlk4WlordEdCRndk?=
 =?utf-8?B?YS90L0ltcE1pbzR1aUl4akxxQ25UWW4xOUwyVVY3QWNCVEhMaENzemg2Sy9R?=
 =?utf-8?B?cU1PNHN2WTNIdlN4dCtldWpPMjg2OUR6QnZaK25VQmljMTJ4YjR2cmdqN3Vt?=
 =?utf-8?B?RkROZlRYS3d2enc2V3ZOek9xSWxvWkxBZmhXK0FGL21oMTlBdk5uVCtldC80?=
 =?utf-8?B?U3U2TDljK1dnMUE2clh1R2Q5bDJQREJlclJQWVhpVmNQVDJ3dENRcGE4bk8x?=
 =?utf-8?B?VjZIVzAvRjVFQTF6V0tLbnBCUW5tVHBodlFKY1c4VWNLd0VWRVZDYUtTZlhN?=
 =?utf-8?B?UjNJeFBFdmV1MW50cE91OElxN3E5K2UvNjlhMHFFd2ZyMTJla0xNejNxQ0wv?=
 =?utf-8?B?VG9TZGYvekpHREdUNTNmY0tNdFJ0RGhtRDZXVXF3YWUxdjYvUm1ESnhUYjVk?=
 =?utf-8?B?UXFUVmFFaU9ISzFPdWhmK3RoU0VsakgvbG1XTzg1OVNpd2M0bUllbGpvK0Fu?=
 =?utf-8?B?Z0lJMUtHWDFjMk9iZUN0NzR1Mjh0bVZ6STRqa1hMVllWSGtUWHhVQndsNG9X?=
 =?utf-8?B?NnRvaVRzaWlzQkw5OTBIYVgxdktBNGhGREQ2L01xWTRVdDI1N3NLbkFWRnZo?=
 =?utf-8?B?RytnblVXajgwd2gvdDJWczNmQ0VBTEFYeHRuRkpvcVRucWxwVU0zOTB1Z2tS?=
 =?utf-8?B?VDBKOEFkbVBEYWlOSzQwSldrZEVzODZtdmJJNEhXZzZkVW00S3BqYmc1c2Nt?=
 =?utf-8?B?NkVSd1VSb01qR2hvTnhFMHZRTWZpeVQreVRCM3AraVkrR0xOQXFlVHdQVjFr?=
 =?utf-8?B?S3MxZEk4bmFsM1I1MTA3ZGZsZTN3L001UHZOVk4wdzVac21RM1JZT3lIZkwx?=
 =?utf-8?B?dEJQcVpFS3dWMzk4b3E2UVhDSXFkUnJqZHhvanRhS2lkZkkrOFJjMnRqL2Vz?=
 =?utf-8?B?dFhEdDNaMzluNnFPQkJFcnk3eHBsbllTUUczVG1PR1RVQkFWRHNRbnpTUlBU?=
 =?utf-8?B?YzdzYTExTzJMQU1UVFpqU2VJb2lVdkxZU0dtekRPVjhPb2xXQVZBck5oQ2ZS?=
 =?utf-8?B?MHdsNGhETzRNWjBCSkltQTFtd05ZZWZERWJVc1dyczRaaWRqL3JFQWphNWIr?=
 =?utf-8?B?MXdJa1NUQTUwdGFUK1FnQk5ZS3pibGsvQjdOVWRVZGJTZHlEWlZRblJ6c2Jy?=
 =?utf-8?B?UUx2WWx1bjMxeVFMcVgrdGJIbzRxQXovK05DVHloN0pGZzZGOUcxVlV5TTNR?=
 =?utf-8?B?akp1aUVrVWU3aEhESkNvdi8yb1VGZTR4T3lFVlJEN0NHV280S3lTbHBYT3pk?=
 =?utf-8?B?eG1MZU1lWWpuemtWZ2FKREk4UE03eTk0c25zZWMyOTJoNjNkUDAwc3JsMFVS?=
 =?utf-8?B?WEh3N2hnRndHdktyU2RWUk4wMksrektXWjh0c1ZKcEVRTURiWTFqb3dJcFlB?=
 =?utf-8?B?TkhQcmIzbUozNHFLQ1lKL0tHUlBrcWxQanZLcUw0NkQ5dkoybEtvODRyektH?=
 =?utf-8?B?dGlyVkV5eHFCTGdHZk5lMmovSjFwR1RVdnA4SllvYVM1Y3ZGSjZyL0FyLzZl?=
 =?utf-8?B?Z1F5bG1kNGwzOGNUVW84cDAwK3RESzdFYjRqUGR0ams1TncvZmdxWDJZNXdS?=
 =?utf-8?B?d01NMmtOdFJUWVJUV01WT0s5L0tXQVhwSzJoUGdQTGw1SWlvdHpwbVRYcUlX?=
 =?utf-8?Q?+BLYGuJcLCmcJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SmRyNFFlbkJJMlY5ajcrWGN1WkFmeGtHb3EwR01vcklUbW1pdjdwMEdwdmtM?=
 =?utf-8?B?a2hwR2NYT096VlBGQ3FyeFhLTmtGc1NlV040UGVUMEpDalhSSkh6Wit0Sk03?=
 =?utf-8?B?OWZzOFNBakY1ZFd2eElUQk5RNzQwZFVpd2ZpdmNiTUZJOWVzZHlaYk9xTlZy?=
 =?utf-8?B?UkpiUFdVQVRTMG80SGs4V0ZTKytBeWhpMExxZHVYaUppcDFicUhNbisxQXc0?=
 =?utf-8?B?MmhQWlplcGN1YmJ1ckRSODB2OXZ5Z0ZkTFlSaHRwSUVneC9oc3NHYWdpTU5M?=
 =?utf-8?B?eEtTTG5oSjAzTFlTTnFNbStxc2NYRTVkVkwyUHU2YTBPQjJKdTBzby9ZL2Z0?=
 =?utf-8?B?Q1BQclVUTjdMOHdWZFVuSU85YjFiZ0tEWFcrY001NGg1Y1NSbnFCVVBHR05Q?=
 =?utf-8?B?N1dsczJMV0tOaGFCY201UUlHUXE0TVV2UE5uOTVGVjZGQkpBU3ZiZXIrYWVV?=
 =?utf-8?B?K2xNQld6bVVxWjZJOUQ5cTY5Qm95OXZOc0VRaTBvN1ZLMTZ2MzdvdGtMMWR0?=
 =?utf-8?B?WUdJSXczYlg2aExTT3QrdS9wbWswbFh0TERkRXRaajhRc0RLQ1IvZEkvYlRw?=
 =?utf-8?B?TGlQRXdhK3ZsMnlBc0NXRktrY0xNcy9ZakRuU0VJdXJSblZDcS9zTjJLWW15?=
 =?utf-8?B?YzZrSVNhZ0hPRFh6Q0hjQjJhd0piMEFrREoxbDFaZzlHQTFxZzJubE9Tc0FV?=
 =?utf-8?B?S1cxdGVndFY3bGExSTl2Y0FCL2lWZlZ4Rm8wdmdzNmp6eDFxUElFWXNPd0VO?=
 =?utf-8?B?VE5OS29KcDBRUGdKWFNRNTVwT1lJVDVLSVArSjByK3FZaUdDODh5bHdyN2V1?=
 =?utf-8?B?ZGFFTC9ZUlM4cUZBUmwzUFlIUjE4Wm55Z2FCeDQ4cUwvYlNUSDRkWFhLbG1Z?=
 =?utf-8?B?ZjQ0QlRVTWtrQVNVekNKS0ozMzJxRC82KzdkQWtvZnB6RnVRbENRT1FZNy8r?=
 =?utf-8?B?cUN1NmhEVk5UcE9yVmszdjJvZXZZV1BuNytuSVE0ZWsxV0VWSlp4ZXkxZVVJ?=
 =?utf-8?B?SWNHMXZNbGIycnl0ZURlMVBmWVZtNXVLZFdZd0RBbnlQMkpKcytqRkxSL1ZE?=
 =?utf-8?B?T3hXTmZiRndkQWZ1emRsc0pjdnROdVExM1A3N0JqWHhlSDcxUUdBRktXMCtZ?=
 =?utf-8?B?b1hES0QvWGN2UHptUnM0ME8yTFQrbVRRcWEwemRnTCtkUkgxVFU3Wit4QTgw?=
 =?utf-8?B?VURvOE9temNCeDQ5T3dqVXNLVko1RlBneExZdmN0cURzdURRaW5WMDc1eVRM?=
 =?utf-8?B?bStnRzNKSGxKdmVNUW9RNVp6bjJrZ3QrTjJHYkx1dnJQT3BGcWhsRXFGVEdk?=
 =?utf-8?B?VlZTU2dvMWFZcVhGUUZUOFc1akV6cEthdFlUZ01SN2FtZDJKNUdjZlI0OTZs?=
 =?utf-8?B?bDhCVTNwZFRMQzRBRDkwTTRXUzlkY3hZaXVUeUNyVEtTTmxnTlBSRGxJcWpJ?=
 =?utf-8?B?Wjg1T0M3bElnOHhtdTR2UkhXU05FN2txVy9KNlBsaVJBd2VGZGZlUGRwS0FF?=
 =?utf-8?B?RVNVUDFqbkV3akZqL0ZEeFJoNjBVNzFhd0FEbm5Bdm5FRWpkRXBnVzRUK3g3?=
 =?utf-8?B?VlBkSGUrRERPdGpmNjl6dHY4amlycWZKekowdTdJZHhQdHlpNnBKcXdwTDJM?=
 =?utf-8?B?RHVYd29lNC9xQ2s0MjVMZkVPRlJISkdpSGExdWlZR0lZc1pITFMwdm5jUXFM?=
 =?utf-8?B?SmJKQnV5ZWtKeGdwWFFIdzlGcmxRNlg3Wm81aDltcXhlY3VkOUlBMjRuY0ti?=
 =?utf-8?B?WUZJWWszMW04ZlN4MGFMNkNFdDNnS1lXbTM5Mm1CUFlwUGFKK1Q4NUlvNFli?=
 =?utf-8?B?NlRRUmZ3WEFiZ2IycFdjdmQ3TjZmc1JaUENHZTFjS2pwY1lmeEU2QzZvWEFB?=
 =?utf-8?B?eitkZnBZYXVFMXI0OEdHZ1EzOHh4OFA2R0xXWllGdmhXd2NUYzJ4QUJ4aFg3?=
 =?utf-8?B?UVhqSW5uOEZ2SW04L1FieXRIdWoveE0xT1NJak1iTkhZWFZKbEFCVUlobDNx?=
 =?utf-8?B?OWtZVUxVVFhBNVMwaDd3d3lTSUR2VUpQaGRQOFYzaXQ0RGs0TllMcEZWTnlT?=
 =?utf-8?B?ai9sNzNBSDYzOU5XcnlFYXdURVlORGNNTEI0NjZNRXpUcVAxVnM5TmNBSmVU?=
 =?utf-8?Q?+rgmC89t9EOlWFdrwBOAJxtfX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1404f3a9-3bc0-4d1b-00f5-08dd75da6a7a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2025 13:45:10.7942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E+rDihu3YpDhbf3v/NegBA2KVAdonFKJtWLHY6hByAgpQY8THpREE0PZvpUPEUlZ6KZriqkKZikhCiFzKo0/3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5684

On 4/6/25 23:57, Herbert Xu wrote:
> The recent reordering of code in sev_ioctl_do_pdh_export triggered
> a false-positive may-be-uninitialized warning from gcc:
> 
> In file included from ../include/linux/sched/task.h:13,
>                  from ../include/linux/sched/signal.h:9,
>                  from ../include/linux/rcuwait.h:6,
>                  from ../include/linux/percpu-rwsem.h:7,
>                  from ../include/linux/fs.h:34,
>                  from ../include/linux/compat.h:17,
>                  from ../arch/x86/include/asm/ia32.h:7,
>                  from ../arch/x86/include/asm/elf.h:10,
>                  from ../include/linux/elf.h:6,
>                  from ../include/linux/module.h:19,
>                  from ../drivers/crypto/ccp/sev-dev.c:11:
> In function ‘copy_to_user’,
>     inlined from ‘sev_ioctl_do_pdh_export’ at ../drivers/crypto/ccp/sev-dev.c:2036:7,
>     inlined from ‘sev_ioctl’ at ../drivers/crypto/ccp/sev-dev.c:2249:9:
> ../include/linux/uaccess.h:225:16: warning: ‘input_cert_chain_address’ may be used uninitialized [-Wmaybe-uninitialized]
>   225 |         return _copy_to_user(to, from, n);
>       |                ^~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/crypto/ccp/sev-dev.c: In function ‘sev_ioctl’:
> ../drivers/crypto/ccp/sev-dev.c:1961:22: note: ‘input_cert_chain_address’ was declared here
>  1961 |         void __user *input_cert_chain_address;
>       |                      ^~~~~~~~~~~~~~~~~~~~~~~~
> 
> Silence it by moving the initialisation of the variables in question
> prior to the NULL check.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 671347702ae7..c9ab4bd38d68 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1968,15 +1968,15 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  
>  	memset(&data, 0, sizeof(data));
>  
> +	input_pdh_cert_address = (void __user *)input.pdh_cert_address;
> +	input_cert_chain_address = (void __user *)input.cert_chain_address;
> +
>  	/* Userspace wants to query the certificate length. */
>  	if (!input.pdh_cert_address ||
>  	    !input.pdh_cert_len ||
>  	    !input.cert_chain_address)
>  		goto cmd;
>  
> -	input_pdh_cert_address = (void __user *)input.pdh_cert_address;
> -	input_cert_chain_address = (void __user *)input.cert_chain_address;
> -
>  	/* Allocate a physically contiguous buffer to store the PDH blob. */
>  	if (input.pdh_cert_len > SEV_FW_BLOB_MAX_SIZE)
>  		return -EFAULT;
