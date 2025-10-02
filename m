Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010063.outbound.protection.outlook.com [52.101.61.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AF027B34F;
	Thu,  2 Oct 2025 19:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759432717; cv=fail; b=jicaQbisJC6EfOkSAu/v68Bfd1iamAZ8eh+FHqnVgqBSuj+d55idr5jIFZDM6pNAbukttMsNRMfralZb3PBNZ1JFCqhcZopwH3U3Y9/LhCPCVl33khGrnc1rHbK/sOPceW9e6vF7O3CDdj/jmT9VI9whT5wrvDvRxTPcJVSUwSw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759432717; c=relaxed/simple;
	bh=G2j80iixT3PxaAYM7c46ECIw4qaCJPKHI/wndVWcuEE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uLhynBjUAMIq2Rw8qd0PDIQZvCgTfk5YR4kGKsnsZyIj02WlDG8dWrRQ/8qj8KR+FGYRpsHsyZPAaxE9PwNyDAplcolzoW6uxYbIeCLGOCQy3OHT8e/qx1ThV8D9PTSrDsZNk89I2dJGkbkTZUAQXk+ZVWlPSN3v9tQXHRwo2TA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BpzZjJRC; arc=fail smtp.client-ip=52.101.61.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BpzZjJRC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HMSe7IovuI4ESrJrpf1hG0xIcdACRujSJ7YW1tGbhvUA4/y/qll6c5c4Gc8r908G+cujSuPFyOBhm+CpapG4lzbE9xVSJcZ60S1l1X8nx720gOTG8bmBrbOmO9n7NRQY/41kzRKPHNZB44lykr5oPhf1L5MWbx6wkap8nLVpdxhPoxJUxOOF2Jn+fgvCtc/Mp4b436qIoLNna4BNfkq4q3iH1XD5PPR8WiUZncA0NrYR2KYTshfJXMs+UUWaSaC+MvpWZm/y+gJGwWzi7IsHoJJDo3d5Kf0K/m/jclLv7IyKAILr64z2YFiCQWH8OUsneNhknNGJNPHKWZWyQJlSMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PuUksQfFrrnvnF6O5drmG5qA84vZuoEyOvWqJsOdU8s=;
 b=TsKni+s1dt9AGOlBZfr6L3/H1T7/1sUaD4JHeHXjn5FQhPzyFy4pY7Fy7tx8Z9QYjeq6KTGoq5uXu4eCeaxs8LLKD0FI7houDuscCOMi4v5T/pPa5Wh/AnlAbFOXipm6BTUI4W5EXHvCYihGc8vg9fc5mFGDUr9IbxJfIWDgzLAooi+I9z31TuT73bG0ec0uuKfNN2+SmHCCl265rIRzctCT/nvj6I0Nss6ZFv0mcL2c+G/F/6HFyo7uHSlUT55vEOttgakojzfN6W7XASUxri6to8FS/3D7wrPjPT16ePZ5NvKnTq6hzFdiOduyOAMyAl1Ko4Ng+49H2gsa/gzTyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PuUksQfFrrnvnF6O5drmG5qA84vZuoEyOvWqJsOdU8s=;
 b=BpzZjJRCWh+K2s0OsjvLfdnFBebmXM8455HSCj6zc2iXMUKA3oBBCcSOdH8hOsgG5BGPTrFVLEmRovCqX5RYEWm9TnH2jcAk2f0FuGHa3lk78dkB5PZrtdfFjJ3bLU9K5C12o2ROTc0WVCYbuTdh6vjn6+ve6FQLynMsTNvrZaA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6)
 by SJ0PR12MB6854.namprd12.prod.outlook.com (2603:10b6:a03:47c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.16; Thu, 2 Oct
 2025 19:18:26 +0000
Received: from BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a]) by BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a%4]) with mapi id 15.20.9160.015; Thu, 2 Oct 2025
 19:18:26 +0000
Message-ID: <1f662c38-ccf9-af04-a558-a99e153ada48@amd.com>
Date: Thu, 2 Oct 2025 14:18:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] ccp/hsti: Fix bogus sizeof in psp_populate_hsti
Content-Language: en-US
To: Teddy Astie <teddy.astie@vates.tech>, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
References: <5743ec02c374ce52d1b406d41e9e240d049ee7e2.1759427927.git.teddy.astie@vates.tech>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <5743ec02c374ce52d1b406d41e9e240d049ee7e2.1759427927.git.teddy.astie@vates.tech>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0172.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::27) To BL1PR12MB5062.namprd12.prod.outlook.com
 (2603:10b6:208:313::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5062:EE_|SJ0PR12MB6854:EE_
X-MS-Office365-Filtering-Correlation-Id: 01e60a32-d3a9-4dd6-49de-08de01e87651
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SE9Sc05IZGU5ZGpEYWtIbzZCUStseHhIMnpaRzhQQXNFWkxUN1FsQlFnNjBX?=
 =?utf-8?B?VDY3WVBzT0NxSDFPbk9ycEV1V0FleVVPeDQvdHludDdFMUFQU2pZbXR6Y2Fr?=
 =?utf-8?B?V3hUVVBUZDZEYkVlazUzMHg2YzF3V2JaWjVINGk0RGkrOVNEQ25zQW9HTXZr?=
 =?utf-8?B?ajFtajlVbGtVYzAxV2FqeTJvczR4cldydWw3aUFTK0RWRjlQN244S1lwVjRW?=
 =?utf-8?B?S1hRRTVRWGlVMVJQUUNDWWdhdkZSRHFhTEdsWWtzeGphd01VVTNUQWZTMTQ1?=
 =?utf-8?B?ZGx1czMvbHdrdFIvRnV3MWVsN292Mzk4NHR4cWU4NWd1RGhncjFiMkt3ZmVm?=
 =?utf-8?B?d01uQk12a0doVmNLME54NlZYRS81Q3hDNUR3NS9qMVp5UkQyeEo1T3VZVEJ2?=
 =?utf-8?B?QndIQkxBbkQrVUZvVjZqSHMxMnVJZ2hGN2NOR0p4eXlvS2srRDBpU0lWOVRI?=
 =?utf-8?B?UVFUaGJzZ0JXVitnUURHRGFkQzJQdnBnUGx2V3B4LzAyT1NFWjJOSUlxdVFi?=
 =?utf-8?B?dEZJNU1DK2dIK1RaekViSW5pV2FadVQxbWdENG1iQUxrN0RpM1BVKzlpWk1C?=
 =?utf-8?B?YjJ5N2E5dkRDZ21tdjBkOUQ2dGo3Z0tGZkpsWXlUZTBVR0RiN2RCNkUzVito?=
 =?utf-8?B?ZFo2dllJSm50ZTFlQ1NjdnVtS2RTYjQ4TE15MFdhWWVRdlFqd0NWTFk5UUhv?=
 =?utf-8?B?ZVU5MExIcnpoRlQ0aFhmSG9wUm9MUUxqOVdnOUQ5aWZkYlErZUIyYUxGVjBD?=
 =?utf-8?B?bkRIRnNrMVI1V0doV0M3Vm1WRDZhUXVtZkFFbklJSUYyVWNSbUJkZFhNUE03?=
 =?utf-8?B?UUUxS1BacGl0UE9lRUphUi81M05Dd3EvWVdyVUZqM2FLbXBNTW1VRVo1UTRI?=
 =?utf-8?B?Y0FhYVZiN0VkUTd1L1BpRzZXbGlMa2Qwa1hFTnV5UWF5RjBhaE9vODBYVG9x?=
 =?utf-8?B?cWVmVUdob1BQUUZqY3JTSm43eW0zZVZYeXIxTkpuNW5tWVRmSzZFUE9qR3pI?=
 =?utf-8?B?ZUJ6SG43OTg5a21sNkFGRWNDUERYL1YzNSthdEtDOU1HZ1lrd0d4bU5ZUmhJ?=
 =?utf-8?B?Vjc4V0VoUHZ2dnpkZjE0S2dxYWFWSmRsN1FuMUlYSEVTeVlmbmZRcFp0NFUv?=
 =?utf-8?B?bGZmbkFla2dBRTQ1MFlTVTk3UFpHMGhVR0tpWkxmRndna0FQMmtTZ3ZBdzln?=
 =?utf-8?B?eWZ5ekVSWWZBUzQrNDBBODYxalAwdzA5eXZkaWxDRktEOU9PWnpGaFlVMXRn?=
 =?utf-8?B?R0k5aFVUU28zYXZFUUpGRXd3ODlxZ3AxeEdhWDhlODg1Y2hSM1RidnIreHdn?=
 =?utf-8?B?L21RdllydVhlYkJiTDh2Y1RRYWo3RUprdDZBY2VGYjNtN1FuZGlGQlU5MDVy?=
 =?utf-8?B?Q2g0WGNXRnhZY1MzU0E4eGdWaEJTS2p5WDVya25JdEJhcCtrSXZVVE1ydnMw?=
 =?utf-8?B?SjhMQURxRXljMCtzOE5kUHVHQTVvL2JBMzQwUzAvZ1JIZlhnZk9kVG9kcWF5?=
 =?utf-8?B?clRyajZZQ2R4NjNWNDJ1dkhKNE4xVHJLUkhrc3VvUkZKUkptZVM1MDBJZkt2?=
 =?utf-8?B?OTN6S3YrQTJsL3B1b0Z3eVB1SDkyQ2VkUzF3bHMrZU5zTllNUXpkaGxwUlB3?=
 =?utf-8?B?TjVOb2RWRTR1SmczNjZHQ3h1b21PajJhMWRyc3JhVUNGSTlGLzdFZUpSNFFk?=
 =?utf-8?B?VlIwZUlSd3piZm5sOVhvbWlOTldjVllyYWlpaVVleDJ3aDY4SzlmNGd2bWIv?=
 =?utf-8?B?eUhBNk9RWjduTTRkUmJrOXlEVFkvaUZlT2p2ejRBb255bkQzNzlLOERETXd5?=
 =?utf-8?B?dDFIY1N6c1NoRjFGelhjYTFWK04xclFHSW0yRTZNM3I3UmtDdXY5S0hScnFq?=
 =?utf-8?B?emNDK2dRQmx1VFk1emlRdHFzYU1jaVIzQmRPRjEweXZLWFpxVGVPRVdncE9q?=
 =?utf-8?Q?BEMDtXALQYirp3KisrsF5zLMCip/CaOZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5062.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OUQ0c3hEVkJ1emFXL0dNRFZLRkxTT0Fua0M0VWhBQ2VMUms0MTQ0SXQyeG5i?=
 =?utf-8?B?WW5PWFBxMVNoNDZIZjdmeng2NXFOQTVyU1c1M0ROY0JCOGdNejNXdWo2SGpR?=
 =?utf-8?B?TDYyNWNEUWd2VWUyWE9YNkY3dUc2WXhta0Z5K3ExcmxnVTl3bEZMdktvcTZ3?=
 =?utf-8?B?M09FeUhCZE9Nb2lPN05mS2hQbUQyN2RTQlpGR1NaUFRTSllBTnQ2aW9LdHZo?=
 =?utf-8?B?Y0xSM1pGd0RZNXFseFNtSEtaeGM1MVRpRDZqazYwckxoR2R2RUJnYXo0Wnky?=
 =?utf-8?B?MjN2QUl6Ykl5S3FyalJ1S2p1OEUyUVo1NDZnYjVtd3UybktUdXRWdjhPdVFz?=
 =?utf-8?B?WTRPRWJkYkxOY3pyWlBYTHBQenB3Zk5lMno3WWtKQUFvUWFKWXR6eTJEcTFQ?=
 =?utf-8?B?dXd0YXQ1Q3l2SE5IMWlxUHlpT2ZRb1FDbW5ZRW5PNFlmaEZVbFhSNEw5ejV5?=
 =?utf-8?B?UWl1Z2REUzQ3TXAzS3Z2WlM4YndYamNyczFjbjN3bHNhcURtR2dEeUNoNjdH?=
 =?utf-8?B?L0NEK21KT2FvY0VYQjc3MThZZlNVSDMycWxMai9vV2E1a3d6WkR3OEVtR1lx?=
 =?utf-8?B?anhBdXJlVmtzNFhHdko2dmYwNGZlTFk2VHhaSjllQURmOUpuMUlOUlZyVW5D?=
 =?utf-8?B?WHlvNzFBUDdHSkg4UFgvdmpqNmt1RUtrMW1tWlhvekRDbGE0d3NPWUMzVXYv?=
 =?utf-8?B?YXIwSE02T3IwSHkveFEydUJsSUZmem5wRGY0Z1VuTU5ySzh4RVZrLytMc0cy?=
 =?utf-8?B?NSsrTTEvZGUrMW5sSkxUSld2Y2c3Ujd0L0ZGeWdvbjAzc2hSNTNaNlVBdWY1?=
 =?utf-8?B?NmZ1djRaTG8ySjExU1Z3bzZPc0lhdnFDUlRuM2VPVDU0RHJkSVVnbjFJMFVu?=
 =?utf-8?B?dEJPODdsQk9ZUkxtUmJXZExoaWR0SDhsZHAvL0JhQ2VwK3p3UUl6RWdYaHBI?=
 =?utf-8?B?T1RVN2pMYk9hYlRjcENEdnphM2N5SnVYT2xPMVRMcXhPWUJwMEo5SnBDRUhT?=
 =?utf-8?B?OVMwNVNLLy9kRndjcFFVaWpTa1E5cENGRzNXVjFldXZWYVRyS3h0Sll6a2lN?=
 =?utf-8?B?SHpLekV4bEJKZWhveXJCcHlyendESkxPTFF0T1psakVGUGl5R0lBWmU0NCs0?=
 =?utf-8?B?N2JWdHFkSzhvWDNrNU5HbjNJN2cxZkRrMjhQV2VmZmc3WTI2bkJmbXV5Z3Ro?=
 =?utf-8?B?enBlaXJuU3BDS1ZkeE85VTdJWVhUbkIrZWNlTkFYTE9BYWx3OXArK21nY2dx?=
 =?utf-8?B?R2RTUTdXSTEva2pub1laaFNZd2RKcDhqc000WERrOWNUZTZpajBrTkxKa1VZ?=
 =?utf-8?B?MVZyR1V3WThmWEswL3NxRi9FVXM5MDNKNTQ3bUtDSUs3MVlvK3V4RkdCVlhp?=
 =?utf-8?B?NjNuaDVWQUtVc2N0SVhUYTU4cEs3b2UySVc0WHdYc055ejVYZUxyT09qWnpr?=
 =?utf-8?B?ZUxESC9MS0dXV2EvRzBROUN6NHgrcHBpNC9CaUJkT1AreTNMTTZSN0FnOTFY?=
 =?utf-8?B?ckk0OCtKb3piTVh3RUtKRW1DVU1OSVZNOG01RDZiOVFaZHR6ZnMxajBiYW9Y?=
 =?utf-8?B?OHVUaVZ6bjk5Z1ZzeHkwNE9NUUVRQ1dlaStNQ3JGSHBYZTRlRU1QR2R4aTZi?=
 =?utf-8?B?U29lYkpsTGlrZ2xuakRKcXRRSGFlZXl6bVRueURTUTFOQmF6WEprV0FleTl0?=
 =?utf-8?B?L1Fhck00RW5jd0s5R0NCVHltWU41TWo3bll5MUdIS2pON01kaHVhWUQ0R1RO?=
 =?utf-8?B?SVQ0aUNreitRUWJRZWtjRW51dXpLbTZIZHBZa3RTUDZNYXlnUmlGUlA4SDdN?=
 =?utf-8?B?ZndOc0Y3dE1oVWZqYkp1RVphY0d2VDQ4ZGNkSGtqdDlMaXYyVkl3dDlJYXFt?=
 =?utf-8?B?c1JLbi9sSlJFTU1ZeUNJVkYzRkMxalpCaGpPSjJtR0ZGbDAvSE5mNjNBYnU0?=
 =?utf-8?B?SklONEhYU0VXeGNrNmY5R3k3VTZhMWhVUE9oeGNYUFJMZ0ZjSm5nYWZsQmRQ?=
 =?utf-8?B?aTVjQm5PWkVXODRsZ0szR01qS2s1NkRyMHhWTEcvbVhZaTlqNHA1YktQSFBs?=
 =?utf-8?B?SlRMWWluTUs4dElCUnd4cFRrUEpoOEhIRStwR0FSTXQwcld6TmVmczMrdkYx?=
 =?utf-8?Q?dK/zxAHlyVHkuLFSQ2HeDqHxE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01e60a32-d3a9-4dd6-49de-08de01e87651
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5062.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2025 19:18:26.5530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ePq3mpTXcL52Q33zi7v1Xyij0F0x/epxzsioNkiCSws2qUOrDhUOV9flfQTQJi1xMucaw/WBNLeH5rjZCe4SKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6854

On 10/2/25 13:04, Teddy Astie wrote:
> Payload is actually struct hsti_request and not a pointer which
> makes the considered payload size smaller than it should be.
> 
> Signed-off-by: Teddy Astie <teddy.astie@vates.tech>
> Fixes: 82f9327f774c ("crypto: ccp - Add support for getting security attributes on some older systems")
> ---
> CC: Mario Limonciello <mario.limonciello@amd.com>
> CC: Tom Lendacky <thomas.lendacky@amd.com>
> CC: John Allen <john.allen@amd.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: "David S. Miller" <davem@davemloft.net>

Already fixed by 2b0dc40ac6ca ("crypto: ccp - Fix incorrect payload size
calculation in psp_poulate_hsti()")

Thanks,
Tom

> ---
>  drivers/crypto/ccp/hsti.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/hsti.c b/drivers/crypto/ccp/hsti.c
> index 1b39a4fb55c0..0e6b73b55dbf 100644
> --- a/drivers/crypto/ccp/hsti.c
> +++ b/drivers/crypto/ccp/hsti.c
> @@ -88,7 +88,7 @@ static int psp_poulate_hsti(struct psp_device *psp)
>  	if (!req)
>  		return -ENOMEM;
>  
> -	req->header.payload_size = sizeof(req);
> +	req->header.payload_size = sizeof(*req);
>  
>  	ret = psp_send_platform_access_msg(PSP_CMD_HSTI_QUERY, (struct psp_request *)req);
>  	if (ret)
