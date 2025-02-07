Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6AA195FE5;
	Fri,  7 Feb 2025 21:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738962590; cv=fail; b=fM+4Zrmg22TmrePxhPUBiq2XJH+UBcwPDVX7crHGBlk6yUVhr2AH7txb89Vvp7C1LHPJMdxORuXA7MzOJLUYC0rJXI/e4m+HRWog9cIl4rZ/QAM/X2QRvu0QzJvKbyHlq6+M6hy+s6HhTnKInY/TBRiROAWDWlxK274SxZOxc8s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738962590; c=relaxed/simple;
	bh=CI2KQY/8SR0SYL+5vzM+AU9pRjh1ZMgKLV6eYDvukXk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=X8P9aF9pdXOpi11zQMXo0R/5MzTHhqDZmqa1ksK7FVEmZntx9VA29NxAdMPf/mjaI1ZUL1WjFBMdj2QBY5gX/efzlbDsXRBhl280bKDqUCCyJgLCDYTGXxF90PzSUk4aU1i87mjzSFO2fmWpZfRkUKR5i/ZARkoqoax8ZIrvl/A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=J9101X0e; arc=fail smtp.client-ip=40.107.223.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="J9101X0e"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eAMR/NUM3RnXKXr2Sf01GR7HWy9buI5KLrUI+sfsJRGxnu7qlXq0hpev79hktvMJg4uN1eP4aCHwZPDsU3KRvxze0O6CKCkByJq7UtJHCS+HfimznAgnOnua6NsOayuiHMTIbWrMZ6kO/uQJkxjEqNqyO6O+LFInaPffOD6e4CF7O5Oi7+iGCXYHibOXZViIyUcqrEH2gfckJIHZw3OjFR6X7D15kucyBizdTFPKMFOUdOGYaXhUEaAsqeGFhxz95wwWDcC37kSw6ju2kbzQpeO4yJedpGpGlAYt+G2bkkZFjfNfI0IujiRC0AdKMfowYru1hQpURTpcgy19xPJFGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Akq66kzrn+48X+nq5WjnGbnO69WgBV2xoecme5PvNII=;
 b=PZ+J/pEtbwkW6ROx86r2y714USmfd3wqsMqANd4ecHHmzzdmcUU3KFIqCZ6JFWBdPPPbLhbmP4oIrDn4cCGPkADsFTVf4npu6w7IEyUsOMrMv0LuT077NxwraITPBa2QFDTrZfit1gV4BrLWME+VapcZ8tCdEV1nO/xEKFM89TNGFAp4QKgquwcLg7BdrW3j3mzrZtZUgKFynY0MH2Aumd9lCN5KZ3I6gmxM58h0RLeI3SjUowHBKk0Q2BV510oUfRvZ/p/eNSutOMgYrb+n8tHe/zD5CL0XADHoYIikDSBDTn6vD8oJa0kpy2Elv3rKxhwWMYyI7jfxEyI+hZGE/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Akq66kzrn+48X+nq5WjnGbnO69WgBV2xoecme5PvNII=;
 b=J9101X0ewpwQT8Cwj1sudW/fU8qkChCv/2TpeWB1St0ifvV90n2ehNFQQKKu9qgfOJnMRi4pivkch5Btz3z5IT1hgw5Stqn2Th75qPKNrkql4vqxLjJZS0j8e7IZlD56XPphdcj8Ocpgp8LcCSn5S1vrwOp23lBoQ8qNxwyLxog=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6)
 by DS7PR12MB6335.namprd12.prod.outlook.com (2603:10b6:8:94::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.10; Fri, 7 Feb
 2025 21:09:46 +0000
Received: from BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a]) by BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a%5]) with mapi id 15.20.8422.012; Fri, 7 Feb 2025
 21:09:46 +0000
Message-ID: <d48bc8ee-3762-16fd-8700-d96cf1f3f826@amd.com>
Date: Fri, 7 Feb 2025 15:09:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] crypto: ccp - Add support for PCI device 0x1134
Content-Language: en-US
To: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>,
 Mario Limonciello <Mario.Limonciello@amd.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Thomas Rijo-john <Rijo-john.Thomas@amd.com>,
 Rajib Mahapatra <Rajib.Mahapatra@amd.com>,
 Nimesh Easow <Nimesh.Easow@amd.com>
References: <8e2b6da988e7cb922010847bb07b5e9cf84bb563.1738879803.git.Devaraj.Rangasamy@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <8e2b6da988e7cb922010847bb07b5e9cf84bb563.1738879803.git.Devaraj.Rangasamy@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR02CA0007.namprd02.prod.outlook.com
 (2603:10b6:806:2cf::18) To BL1PR12MB5062.namprd12.prod.outlook.com
 (2603:10b6:208:313::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5062:EE_|DS7PR12MB6335:EE_
X-MS-Office365-Filtering-Correlation-Id: 94fe6333-ccce-40b5-3baf-08dd47bbc018
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MVV0ZXVHeUk2TDFKWSsxL1NRSUNQUTNuM291YzVyTlg5UXpXalFhRWNLcTYw?=
 =?utf-8?B?VEtnQTdOWUFmaHRpdlUwLzVQK1RJdXRMamlHOUhZbkU5SGw1TkZsMzNVK3hE?=
 =?utf-8?B?QmhmbjZVOC9FMHg0YXBoZjFJMnRkSGh3T29YR2lLeUFMTHhDVjJ1c0JjZHpW?=
 =?utf-8?B?R1NxZG15dEMxaUVEYjZWRThDSWhYbkxpT3o1VlN4MktTN0hRVm1mSVpqWTNO?=
 =?utf-8?B?WTY5UXJCRXZLRE80WHVmVmd5SkpGbm5TZFA4eE5MaC9uRmhwWmo2WHR6dWdO?=
 =?utf-8?B?ZDJoUFlSRmJVb2x5UGxQNjhrTDV2QjgzaWRCN2RTMWw2T05XcUVSNXMyU2V0?=
 =?utf-8?B?YTFuMGVzV1lZaUg2RlNOQ0xHTGpOWE1EUkpwRTdpWFpmZ2JNNHlaOTE4d0tQ?=
 =?utf-8?B?OEwvUWRCVnB1WTVJS29wbFZIc1pNNEdLUXFCbHNtQ04rNEl4WVdnUXVUOWFQ?=
 =?utf-8?B?dmpWU0RBSERhTWEzTTMycDFPc0F4aFFPRTJmVysyREluVUt1VWFhOVNINmlW?=
 =?utf-8?B?TVY0bzBXVUxOWGxaVzhxS2RNUXVmMzc2UVVINHVOVGVqaFpkMXVYNGdqbzNx?=
 =?utf-8?B?cDFRRmNwd1VPZXV3R2hqRGFLOWFXNVAxV0YzRENTQnQxUit3Tjgzc0ViNzNQ?=
 =?utf-8?B?RE5HVnhFam9MbnBBbmdBMkdRSEN2WUJjUm9qejNKZytPUktzakkxb2ZGSi9V?=
 =?utf-8?B?ZWR4b1ZnNzhtL2JhS0NtNGhRQnoxaHV1MEE3MmRGelZsME9FVFg4Nzg3ZXVo?=
 =?utf-8?B?cmdBMnJzalJHVkl1MXVYN2llbHFINVEybCtiT2dyR0xYSTRzVVl1WVFxMFFv?=
 =?utf-8?B?Vmo0VzBoZlN6VmlYRWxhQ0d5VWI3SnNGVEd0NGRkYjlyS1VhM3VPeUpGdWNB?=
 =?utf-8?B?SWNwN0VHTEJ5R3NNZUwrNFIxZStvcEYzZWRTcEMzdXZNTHpIM0pkZEJubndM?=
 =?utf-8?B?dUlwQ1BGdDl3NzRlQ05ReFlhQmFtMGZhVTJkaXR5Tm5BQjUzNVhKZmNBM1Y2?=
 =?utf-8?B?MGJ4QXFGK3pTcmpNQXRpNnRtdS9oNjFPYzRsMkd1Zk9MK3hPQnliK3YrZ2h6?=
 =?utf-8?B?RUl3MnFMN0tqVTdUbzV2N2dFbmxONEExV1hWS2NabVhhT2J2YXVvNWpYbHFR?=
 =?utf-8?B?YkUwUlhXMmVRTytUQVl1VmJYdnU0UTZSUkxFV3hJUjJMTVBoMVU4L1JYeGNI?=
 =?utf-8?B?bWVhSHFYbFN3eVNMblpRVm92eUo0ZUJ5aHNXSG9Cb3psMVd5WE5ELzJONGxV?=
 =?utf-8?B?OVNyOVIzSnZMSmZDbys3bTJ6S2tseTNXS0hDVWhyMFFyblJtK0EzaWpWWS9Y?=
 =?utf-8?B?YzUwd3dGVHRPSU1mSGh0dE56MmFCL2VRY3ZaWTgwYUtGQ1diUVdZcktpeG1p?=
 =?utf-8?B?Nlo2dENnbjhuK2tXelNTV1owQTVaRzduc0RFR0E4SFhFdWI0dFJ4dHYxZ1Jt?=
 =?utf-8?B?Q2xHbHk3Y29kUWJGR3NUYk1vWmJ3T1ZpU2lXVWZXY29MdWpIUGtvM0s1a1Zl?=
 =?utf-8?B?MkJNYkh0QTgyalFicWdvWVlvQ1BwOWY3WE9kdmJtL2pPU1ZCd1duMTFsWXVr?=
 =?utf-8?B?Z0c4KzlnTzIxWFRZemdVZE0wMFBtSHhCTWtEU1pOZjRRdUREM250akNMUVFZ?=
 =?utf-8?B?UC9hWGNieXl5UTNLc0JMMkRXNVQvbG9GMVREbEJ5MmhVbDlKSEJVY0dUN3BG?=
 =?utf-8?B?SVdwNUlaU3J6NlF5eFppUzRrWHFWTEZqNWN0bWhwbC8wNTdhdmhsTHJScDQ0?=
 =?utf-8?B?V1ZiSG5MclFmempCOUllTjdNTmVQdGRqazZQOUNjd1k3eTY2MlF3dklQSTdN?=
 =?utf-8?B?UGQ4bEZsT005UzBQdUFmcWYxODRtbC9zaUhTUzBKWnlDaTYvbUxRRlpYM0dU?=
 =?utf-8?Q?aEv+hfdJYuB95?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5062.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T2NGdzJNbWF6ekFMazRpMmlUMG1CK2VBZWhrWVRzbW8zTi9FUDJVNk1pWS9o?=
 =?utf-8?B?MVZzWnFUN0xmaHJaTUgrSjRlbEZMUjlBTnF1b2hWMjhTWjZsT0srT3BkZXhD?=
 =?utf-8?B?Sm1pdnBEdzlOaUFXU3dtQ1VoTEZHMXFCYWNpREJNeGhFMlhxL0FJa2h0clln?=
 =?utf-8?B?cGk5WU5kMWM1ZzdZZ3NSVHhrRW54QXF0T3Z0TTdidUc0OHhxVzBNU1pTTngr?=
 =?utf-8?B?RnRIMU9sQllENElBZG10d2YxbXBlMzAwOTdnOUgxQThZNHV1WlROck1zbzNC?=
 =?utf-8?B?dUZUcElzRDduMHRhWXYySm5ybWVNN3pIMFNzejl6Z29uQ0kwOHVFd1pBN0dx?=
 =?utf-8?B?NDM2akIzM1hYS0V5QnpkcTZUSnNUQWJ5ZlZrdzlENkVEbmZ3VlhjdE5FcjVL?=
 =?utf-8?B?T3lmc201QjU1Ylg5TlpxeFV5eWo4ckZINjhIeW5nWEN6OGRVQlZtbURMUjY5?=
 =?utf-8?B?SWFscUliRFc4OFE2R3RJTHR3NVhTTnBKdDRycXJPM0lZc1RSOXFQdEV0KzBV?=
 =?utf-8?B?MVE2UmZQdEVaZ204YWF1ZGVFSFJSMXJLekNGcG4vNUdjcGJpMndFVEtGZDVH?=
 =?utf-8?B?ZXN6ZTdWSFVLWmJRcTEvb2JTekdSQ0hnTTMzQVEyUFJkVjUveFRxSmpZRnVq?=
 =?utf-8?B?a1ZlMjNMODNaNTRJMUR1dzUxQkMrdENJWThxVzZ3NGx6ancyb2JnR1VDR0lv?=
 =?utf-8?B?VFExR2tMMTl5bXpRLzBlUG13bDJ3ZXNadzQzNC9EK2t4aDRKREluSEtUVjVu?=
 =?utf-8?B?cDBEbWNUTVVsWlVjbVR1QkM1b09QOWJNQmJZY0N5NmdhWTNxSEI2Mm4zNTZk?=
 =?utf-8?B?aURraXA4ZTRITURXRVFDRWFESUJkVHlIUWp5dnlEQ1pGdnBDOUFvMWhkc2dW?=
 =?utf-8?B?MTRHUHZuc1p2SzloQWcvdUc3S0o3bU9PZXZXVFNLVHVJQjNaNUNSSDVYMUdt?=
 =?utf-8?B?cHgrUWFNaWU3SU1mVFdlUWtGcmhUajJsK0NJbHFKSGJtRG52emlMNlFSWVBs?=
 =?utf-8?B?QUxFdjV5T1kvYUR5RkF1VlhQTjZ5U0xEeEl2L1VIZVRFNVNWUUYrUjBQaVNZ?=
 =?utf-8?B?MHNZVkNHTXNGaTlTY0hBQUtMZUQzSmhucFQzM3dQNUVXQ1hUU0J0SXVHQnl1?=
 =?utf-8?B?QTdqVkxUZ1U0ZjZYN2VlTVcrdy9VeHJScG1TS0tNb3FvdHBhRmVtR2FHMHc1?=
 =?utf-8?B?YlZUKzd5VnE0VkZsdWFsL0xjL1l5bUhxV1R0SUVYSThmWW5qWm1hbDZoTE15?=
 =?utf-8?B?citNRFNxT2VjN2hKcFZzcDZob24yS0MvTDBKTE1wVGVaWmh3dmlaQ0UwL1FZ?=
 =?utf-8?B?ZTdlRFA3ekpnM3F6U05hNUdmSmFOOU9PN1ZCaWFxQmlFcnFJUXN0ZGUwZm5I?=
 =?utf-8?B?OFNmUER3SXJvTDJlNHV0NTdoU29IemNKREgvMGlVMGxQSXFtMkpEaHBwS2hL?=
 =?utf-8?B?bStoSzFRTUpxbzdzU3ZUZ3NHTSt0UHQ1YlozRkJENlJnOCs2U0p4c1kzN3ZP?=
 =?utf-8?B?bmZMYTRPdHhLQUZPc2lLbktMa2hNVUJSR2ZzNEpqTDZHcHVVeFhIN2RkSTZL?=
 =?utf-8?B?TEg5clhWeUpnUVR4ZGpwMlA4MUFuZFBtYUp2eVpzVHRhTHk4L1NEbzROZlpq?=
 =?utf-8?B?UXhZWXpkRy9oL2tSZ3pPM250eWdXZXI3RHNobVhQR1V0N2Y3eDFQTGgzR3NM?=
 =?utf-8?B?ZWZoZFFscHhiVmZka2NHWXNXRDZ2anlXc1UwaEk3UU5pcmRVTXNFNjNKOTNz?=
 =?utf-8?B?Sk1LcXpDVmNGdmJIOFQvWjA0VE1IWlBmRTZyUE1zUGpPaGxOUXIrUk9vOTN5?=
 =?utf-8?B?TFdLSzJjRjkzSk0xUEJlRURxREVocExuWDFrR2I3OWI2ZUpCbkpTNVdNdFc3?=
 =?utf-8?B?c2c4bnp6cGtLSHcrckl3ZDhGSmtUMnlzRmV5RVp3MjhxSTRnbDF2d3Q2MUl3?=
 =?utf-8?B?RUIzczQ4SXZyT3R4WG41TGNhVUNZMWlqT2p6N3l2WmJ2aDFJN2xKZ0J4c0Vn?=
 =?utf-8?B?eG1YZXh5UnE1cE44aHllQ05kRWxZZWwraGdFRlFIZkRZV21GZ2h5OVAwNnBO?=
 =?utf-8?B?aUVaOHZWY0dGNTgrTGFMVGhmNmhKS1dKZ0ZNKzE5TFZWaDRnMVVCcDZOckxm?=
 =?utf-8?Q?78M6AaX7tbVYgGX03JgWnavws?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94fe6333-ccce-40b5-3baf-08dd47bbc018
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5062.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2025 21:09:46.5589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pkONdA4EAgCBtps9/FkfmvcXtud9Ll8gjMFzlWkWzvelQG2a0E7nY3v+aAk+VLIl4NZQ0ey30atgUYjftm0hzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6335

On 2/6/25 16:11, Devaraj Rangasamy wrote:
> PCI device 0x1134 shares same register features as PCI device 0x17E0.
> Hence reuse same data for the new PCI device ID 0x1134.
> 
> Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sp-pci.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
> index 248d98fd8c48..5357c4308da0 100644
> --- a/drivers/crypto/ccp/sp-pci.c
> +++ b/drivers/crypto/ccp/sp-pci.c
> @@ -529,6 +529,7 @@ static const struct pci_device_id sp_pci_table[] = {
>  	{ PCI_VDEVICE(AMD, 0x14CA), (kernel_ulong_t)&dev_vdata[5] },
>  	{ PCI_VDEVICE(AMD, 0x15C7), (kernel_ulong_t)&dev_vdata[6] },
>  	{ PCI_VDEVICE(AMD, 0x1649), (kernel_ulong_t)&dev_vdata[6] },
> +	{ PCI_VDEVICE(AMD, 0x1134), (kernel_ulong_t)&dev_vdata[7] },
>  	{ PCI_VDEVICE(AMD, 0x17E0), (kernel_ulong_t)&dev_vdata[7] },
>  	{ PCI_VDEVICE(AMD, 0x156E), (kernel_ulong_t)&dev_vdata[8] },
>  	/* Last entry must be zero */
> --
> 2.25.1
> 
