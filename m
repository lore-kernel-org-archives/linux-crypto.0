Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA0526D4CE;
	Mon, 23 Jun 2025 17:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750699071; cv=fail; b=FOn1adhptpMjp6dGMFA8pKiKiEd0eojDtb+vP4LEQQ3VGoFQCRYe+w6HcmdCHdyytH6Y7NQzflNpUG8JtKbHuJkLiAVkaL6+SCg6qR5zol1PVDtEy/iuRAVtmsLY7zWQ159M4edBPo8/t/WqlFzmz1IbVnREe3CCKrrKvkfrX7M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750699071; c=relaxed/simple;
	bh=3BaRcHC7quKGIN6ieZMZR/BxgclUYcG03tMWHj8+vJw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LkgysZgpTCiyQAhQmPmqZJVIBNQhYVodjIxAabWooDga0hTX0lMoqGtE14O6ZDGd7Hwj8ATKCr/PHyXR9PoRVTYk7vt5KUxV90k6ymX3mK6uYTjG3wLXHDUbH1P+L+V6wSXj6SCoaNEJDa/sByiccUQnP2LbgVrPQnlLyMlQd+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xJYIX94X; arc=fail smtp.client-ip=40.107.94.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xJYIX94X"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yghWfy8vRDO5QOqGGIXt/QCsnlHVBsSIsW9Tm9QRLYNjphzuCuHrIUsgjn0BDlr2RMj2F480rv29qrAWq7E13gv8zaMirXwzRe8tnE6btRB3EDYJMZ9he4EDUiC6JqcT3AuJr/6LMgXvSVSWQO9fAaE3ayfkcY0nUf/0f/GcasbtlwP+JbVqa6sIms1dMX8d3AKNGlKCZZiI79in2TyZwNw2RTDP5IAT77jfwWR5QJ/jzTXw8da5VpEYge8fUtOkUzjlT7eb4XJ9SDd9UqXPV2SS8DTFkcA9COdcYMksauO3/EWYH4RQ8ty2R1NzDgFTJAdEB+zwzBOVuer8rnX3jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LtIiVv0viyaoWIL5Lh2h3aUjn4+Oy4ERQPwjBLE11TA=;
 b=Aq1jufZNzUE+BmExZ3HoyCj/10frx7TA1r8oPgMgRPOn6r80yzLW1L5aW62H/se25f7WbQ+K/PJkJkuPXclVdJjmJ0DaCJ+OOgJT6DvGi+0X01SdhcjrVnPIjejUWVpedDohTv1Dfy5PDP0cn2BNz0DYUDxpcPc5xKJtJYDDNEyecSYe/u4qnc8TBD0uxmUhlTHhZ5WYdrI9yIDtx20S2oqUEzXg5j2i5XK6QTXJpkS7GRmSrIQw9vXSYBxDukR656IyXzcAvQs+/lBzAiz+qyC5EvqnBK+R8QznoguQuCPN5tFJh1hyYVMlRnimgSqYMmZfznvRpppgVBoUBsqPsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LtIiVv0viyaoWIL5Lh2h3aUjn4+Oy4ERQPwjBLE11TA=;
 b=xJYIX94XFLVs9alg67rJzpcvvLKuFctj2qi6ZpgUraARVtclzBqGrxs4OVm6CeR6EU1o7LepG79OdwWh/nOR3ckBe5VmAyS+ufZ+YlbtD46Ak11seJukWCrz0Xt9jpe2oguqBxS/Hidcr36QhhLrBe6ArvY+5Z0/MtdrwLXYZP8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by MW4PR12MB7335.namprd12.prod.outlook.com (2603:10b6:303:22b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.25; Mon, 23 Jun
 2025 17:17:46 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8857.019; Mon, 23 Jun 2025
 17:17:46 +0000
Message-ID: <d08e8494-851e-74b0-fdd8-ce2517dafc7a@amd.com>
Date: Mon, 23 Jun 2025 12:17:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] crypto: ccp - Fix crash when rebind ccp device for ccp.ko
Content-Language: en-US
To: Mengbiao Xiong <xisme1998@gmail.com>, herbert@gondor.apana.org.au,
 davem@davemloft.net
Cc: john.allen@amd.com, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250623062547.1256-1-xisme1998@gmail.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250623062547.1256-1-xisme1998@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0067.namprd04.prod.outlook.com
 (2603:10b6:806:121::12) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|MW4PR12MB7335:EE_
X-MS-Office365-Filtering-Correlation-Id: be56bab5-b0e0-4b8f-bee6-08ddb279df33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VmhlNzFQVGdGWjhEd0ZUSzRYQ3R3SW1KMjVESFRBb0R1d2tKajdmMnZkMVV4?=
 =?utf-8?B?bjZPaUJObnlTWkkrUGNpNHY1WGx0MkxobGdYS04xU3RpemRNaG5MQ1hSUWZh?=
 =?utf-8?B?dWdNaXdHYXZyZzczK3V3S2ZUMkFuWEVFY25TcThXY0dleml4QlNRNTVTdTFG?=
 =?utf-8?B?VzdYdkthUzl0eTVOamhhczZCQU1UMkMxOWVFbnE1dTk1aTA1YWFFZkVIQjNz?=
 =?utf-8?B?Z3h2YTdPdm1lYWpGOUdwcERJU1FzRzFhalFPQXhvL2NnVTZENmZLckkyc01q?=
 =?utf-8?B?M0J1SG5RM3p6RW9pTWhRYlBSRWp2UmQ2eksyVmxLQVNCZlJvSENoN3dXa2d0?=
 =?utf-8?B?cjlpVzRtUHQrRGZQTWp5dm9WeVlNNmY4VGZjUWxwVndGdXZ6NDBxeG9oMTdt?=
 =?utf-8?B?d0JzZ2ZIWmhmZ1M1WFlIanAyS1p2c2FqMXBMbW5lQytoMXo2K1VldkoxajZk?=
 =?utf-8?B?WE5rQWttRWVrZmtNaXFWUmFIbkdTV3hBZXVRcTRkeElJbktpSDJXS3RKYng3?=
 =?utf-8?B?ZFZoa3g3dktQRllRZjZLYVpHNGpNVlRsbXk3MG1QTWJPdksybGIxRTFNWnly?=
 =?utf-8?B?UGcvNmh2MUhlV2swblJnaXQ5M1BFYkpPL0hPZC9aY3FoWFg1ZVdxekxJNUly?=
 =?utf-8?B?T2lqUzUyMHhUTEJPbTFsekI3bDdXbVZaVmVHZERPOTJUQ2M5SGNpZms5d0c0?=
 =?utf-8?B?UnpUNWpMbUwxOVlRNUVraUxJSHhXR3cyZEcrVUxzMnlhR3QxTFJnemlTdUls?=
 =?utf-8?B?VzZrSW4zWVQ5TE5qbGU4L0YweW1LVWN1emFmUU9VbVI0SGJUaW5kb3p0MmJK?=
 =?utf-8?B?ZWdiaGVUYzA3S0RGOXJkMlN0ZTJOcS8xUUN0TlFEM2RPTnFkbDZoaVRzcWtS?=
 =?utf-8?B?ejAwcnE0MEU3VnY5c1NUQTZBMUlzY0Q5QXo5RGRINXdzcUJ5SWh4U05pZTNN?=
 =?utf-8?B?QmN5MjIwMDNKM0x6SU4yTEpSR1AvQnRnOTdrYVYvVDNBZDEySG1IT1Z3U2Q0?=
 =?utf-8?B?MnV5ZzB2NlZPdGdqcVRtZVFXRXJXdm41TzFHS2pTa3dPUDNzenpsSEVVUDQy?=
 =?utf-8?B?aWo3T050dGY3ZW1oNThNTVFURTkyOVV5VkVYbGdnYXBuOWQybWZ5dTVvN085?=
 =?utf-8?B?eGplZmYxeGFQL3FlV2hTYndOU1lxalZ4bDBYd2hvSlB1RmpCeEQ4N1psUjM0?=
 =?utf-8?B?R0tjZk5aeEZBeUlWWkVOa21ZQ294TmNteTYva3krMnB2RlNsN2s0alZ1cklS?=
 =?utf-8?B?dXc2RHREaHE4VHZ2OXRrU2taOEZFYThzbjg5b0J4L1ZHU0dpcGNGK3U3WFMy?=
 =?utf-8?B?Qk9RcGpBMCtTK0NTMGphWHptQXgwWnpJaktiY3hISWtIQWtYK3FFRUwyTzJR?=
 =?utf-8?B?YjEzSG1zUUhqK3B1dVh3NGt4VGJYY213L0dIV1FoV0t5ZWdkdEZEZDBXbWZm?=
 =?utf-8?B?dmlEUEk4SDliN2czQU5tRjNqc3V4RkNjZzJMd29zN05NV05nL1RTRW1ibzBV?=
 =?utf-8?B?cWVmbHNJM1lwUDBRWlRSem5vWW0yNlkybW5ydVJCU09QcE1jdFlST0EwVlZk?=
 =?utf-8?B?cmhpaTUrODRjdG5yQjBSU2VGOEN0RWxrYmxxQTM1UE42ai96Y01zWWpRaTdH?=
 =?utf-8?B?dFk5eXFlOWdRL3B4a2poTGxNM0Q3Zld1S3FPUU9XRUlLVzdaY25ncmd1dHEy?=
 =?utf-8?B?QldpSHlVeGw5ZWJsNU1DZldQUGp0dkdHM1R4MUJqcXFlQStHbHgwbGpyTTBC?=
 =?utf-8?B?L3c2Sy9FaTcxYk0xM3RGa0d2WFQ4MTZhYVY2MGlTVHpKTGtORDNPU25YUElY?=
 =?utf-8?B?VjVOUFVUaTFjb3dhQmRvcUdUdHJzaFRqek5YK3lnWGV0dC9ROGhkdW5tVkhD?=
 =?utf-8?B?cTR6WVA2RzNpbDBucktNcHFUMzN5eU55SksrZlc2RW11aFdMMXBtUlo2ZjEr?=
 =?utf-8?Q?J6addh/13xY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TWQ5dXpqTjRSWHdORUFOOU9qelNDaTNHaVNaalU0cFJldEU0UlU4eE1BNGdw?=
 =?utf-8?B?L0RBcDBXdTBpNm0wL2d2dmVMdmUyMzZPWE5Ga2JxMlhyUC8zOWRJcWc0K0pV?=
 =?utf-8?B?clE0d1BXNHV6dmFncEpZTVVTekc4K0x6VE1UUUhTbDYzSVNIaEZVTWZQZHJD?=
 =?utf-8?B?TU5abzBwMHo0a2s0VjJXNzRoRjJWSkltZWNFeFdUVGJrMWFTMlpJdVdWeFBQ?=
 =?utf-8?B?YnZ1d1VvY25rVmtHQjU5SEM0QWNyL3JNM1gxN2xaNm5EclBPa0dsK21hQVY1?=
 =?utf-8?B?em5mU1k4YUpCNTBmdWhLRmJpWW0rLzBNQmVSNE9ab1NkZVdCVHVzSGNUT1Bt?=
 =?utf-8?B?OTFHK01CdGc2TllXZjFkQ3dUNGFQMzZHS2RsejlZZWxtazJ0T3J5ZlBWbDhB?=
 =?utf-8?B?bjA0WldpdmN2T1BBcENtQlJ0aDJBZU9nZHJnb3lpYVVlcGFqeG1nNmlqYnhx?=
 =?utf-8?B?WW1CakxwOWxoSE5GcURLdTd0R3BWYlZXem1qOEY5RUlVYXBCNFR5bGhacFho?=
 =?utf-8?B?WVZnSXpxVmREZU5kOTlzcEN4Unh0V1VYWDBKUGZ2bHpoWHdDdmV4ZkpWM2cx?=
 =?utf-8?B?aVNMQk54ZDdBUTR6Qlpic0pmZ3NmY3pNNm9INWZDcXZueWpNNk5mVkdidzlq?=
 =?utf-8?B?RW41SWFLWTgxeUtlbnVTT29kalA0VmhuTERxVkFZVWdOZkk2aE03dkM5b0dM?=
 =?utf-8?B?SlR4UlNoY20yZ0Z1UzB3VjdpSTRMcW5rbzNSU2V1MEp1eHg1V0gwWk9xcmVa?=
 =?utf-8?B?c0JUN3JGSGJSRjBRZkRWWEJxUDZ0MElWWEZHQzh3UFpLRFdGekx6cm5Vdi8v?=
 =?utf-8?B?Y0xCRUh1RkdScWdia3Ewd0ZhSEFrVnFqTmw0S3NUcWhXUmJLRm55ZnE5UVN5?=
 =?utf-8?B?T0dIMHFyRURGYlg1eExadjAxK04wMkVpWktSR0lTV1VBTFo3aFFEbFd1WGdX?=
 =?utf-8?B?SDA4Q3B1N2Z5VitnbUhTNUNtY2FSKzI0OHV5VmpGTnNRY0Z4NDhGN3c0d0xj?=
 =?utf-8?B?bkhFNlF2MGc4ZlNKVzBrMThUQXIvUE9xNnhEMVlpeWRPdC9CVHFQVUtucTRl?=
 =?utf-8?B?Z0szVkV1YnJuY0pLU1dTbjZiQU1tUmxKMzByNTNyN0lyYjl6T0dqYWFEWmhW?=
 =?utf-8?B?TzdSS0lET04zKzNrVUVHd1FRSGo2ZlhaU2dlMDUyUkl6TU0zOWtpM1REUFl3?=
 =?utf-8?B?aFhwUGpxUERTQ0xWQ3pBNXdIRjFUYTdHdkpPWlZha1NuNkQ0NHg2MEFucTdY?=
 =?utf-8?B?T0FmMlA3UDQ2Mkc3S3krNUNEaFF2OHQ4TUR2T25hMnJRS3NNRCtKYW1icTVw?=
 =?utf-8?B?Ym0zdGVwNmRLNGRmc2R1bjFqbGZleEEzK21VR1IrSzNxMXVoU0xqWUNjSHhx?=
 =?utf-8?B?M042MHpXSENzOStyMHFqZTBTd015U095VkY3NEFWd2E0RE13Tnh5VjFXZjRn?=
 =?utf-8?B?U1hzR1NDSTdsMG9GMXdPYWx1TGNUaWRsa1RhRStOTU5OQTFPaTdzMHhGeDVX?=
 =?utf-8?B?bHJDZVFDT2lmSlBVWXFFT1FIc2JBRUdTVVc4NHowTFk5c1NBdzM4UU5nVndY?=
 =?utf-8?B?S0ZGT2w0a3FyMTFoZGFYdXJzd0dOeUVvemlBa201MDBETEJNTjZ6R2tuWjhX?=
 =?utf-8?B?cjhLemUrRWRXcjh6NkxFampZWm9pQTFCSzl4c0ZLTjdGdWhRUFZhcGlRbmZS?=
 =?utf-8?B?emhJcUhsL0tGRWF2K2FWdWhKcEFiRVQrbXQ5cVIrSU51MHUwUVM4cCt1cXlZ?=
 =?utf-8?B?YlNSekFXWWJxVjBKUWRGNGZEOGI0cU9XeXdicXJ5SnlYbXFyOVY0aDYycHR0?=
 =?utf-8?B?ZlJFNWtlZFoxV2dSK3N6MkQzNnhPZnlCNjhwNCsyMW5NcHNRVkxjTW10TG56?=
 =?utf-8?B?V3o3RE8rdnFPNGZLYU5ZRktna011UHBlU0crNThWY3hNODU3eGcrY210aEdF?=
 =?utf-8?B?cldZYm50ZjFzd1JROTlZZDVpRjV3WEptR0p3S21HSTdZT0QwL1poZk1aNmdr?=
 =?utf-8?B?Q1ZlbmNtQkRrbVRiajZ0ODBCK0kxM3ZjTDIyeFlZdGpYTDBvUUc4NXlKTDRn?=
 =?utf-8?B?a0pkaTJqMVBlQUZmaHY0bk41K2FOcmovR3lsMnplVUliSlMrcjVFQ2V0b0tK?=
 =?utf-8?Q?vGH0HKrjXUotq4hpU1c6mMwAZ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be56bab5-b0e0-4b8f-bee6-08ddb279df33
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2025 17:17:46.3729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hAIEiKnftC+azNBV8znD/TfyERGFsI3yxOGuOnNcc4y/mVkWeqWiM7Cz23aL6DNQ9mzgpYSsb2sd7NTHqFMnqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7335

On 6/23/25 01:25, Mengbiao Xiong wrote:
> When CONFIG_CRYPTO_DEV_CCP_DEBUGFS is enabled, rebinding
> the ccp device causes the following crash:
> 
> $ echo '0000:0a:00.2' > /sys/bus/pci/drivers/ccp/unbind
> $ echo '0000:0a:00.2' > /sys/bus/pci/drivers/ccp/bind
> 
> [  204.976930] BUG: kernel NULL pointer dereference, address: 0000000000000098
> [  204.978026] #PF: supervisor write access in kernel mode
> [  204.979126] #PF: error_code(0x0002) - not-present page
> [  204.980226] PGD 0 P4D 0
> [  204.981317] Oops: Oops: 0002 [#1] SMP NOPTI
> ...
> [  204.997852] Call Trace:
> [  204.999074]  <TASK>
> [  205.000297]  start_creating+0x9f/0x1c0
> [  205.001533]  debugfs_create_dir+0x1f/0x170
> [  205.002769]  ? srso_return_thunk+0x5/0x5f
> [  205.004000]  ccp5_debugfs_setup+0x87/0x170 [ccp]
> [  205.005241]  ccp5_init+0x8b2/0x960 [ccp]
> [  205.006469]  ccp_dev_init+0xd4/0x150 [ccp]
> [  205.007709]  sp_init+0x5f/0x80 [ccp]
> [  205.008942]  sp_pci_probe+0x283/0x2e0 [ccp]
> [  205.010165]  ? srso_return_thunk+0x5/0x5f
> [  205.011376]  local_pci_probe+0x4f/0xb0
> [  205.012584]  pci_device_probe+0xdb/0x230
> [  205.013810]  really_probe+0xed/0x380
> [  205.015024]  __driver_probe_device+0x7e/0x160
> [  205.016240]  device_driver_attach+0x2f/0x60
> [  205.017457]  bind_store+0x7c/0xb0
> [  205.018663]  drv_attr_store+0x28/0x40
> [  205.019868]  sysfs_kf_write+0x5f/0x70
> [  205.021065]  kernfs_fop_write_iter+0x145/0x1d0
> [  205.022267]  vfs_write+0x308/0x440
> [  205.023453]  ksys_write+0x6d/0xe0
> [  205.024616]  __x64_sys_write+0x1e/0x30
> [  205.025778]  x64_sys_call+0x16ba/0x2150
> [  205.026942]  do_syscall_64+0x56/0x1e0
> [  205.028108]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [  205.029276] RIP: 0033:0x7fbc36f10104
> [  205.030420] Code: 89 02 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 8d 05 e1 08 2e 00 8b 00 85 c0 75 13 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 54 f3 c3 66 90 41 54 55 49 89 d4 53 48 89 f5
> 
> This patch sets ccp_debugfs_dir to NULL after destroying it in
> ccp5_debugfs_destroy, allowing the directory dentry to be
> recreated when rebinding the ccp device.
> 
> Tested on AMD Ryzen 7 1700X.
> 
> Fixes: 3cdbe346ed3f ("crypto: ccp - Add debugfs entries for CCP information")
> Signed-off-by: Mengbiao Xiong <xisme1998@gmail.com>
> ---
>  drivers/crypto/ccp/ccp-debugfs.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/crypto/ccp/ccp-debugfs.c b/drivers/crypto/ccp/ccp-debugfs.c
> index a1055554b..0d432f3c4 100644
> --- a/drivers/crypto/ccp/ccp-debugfs.c
> +++ b/drivers/crypto/ccp/ccp-debugfs.c
> @@ -320,4 +320,5 @@ void ccp5_debugfs_setup(struct ccp_device *ccp)
>  void ccp5_debugfs_destroy(void)
>  {
>  	debugfs_remove_recursive(ccp_debugfs_dir);
> +	ccp_debugfs_dir = NULL;

Hmmm... it seems like this should be protected by the mutex similar to how
ccp5_debugfs_setup() is, right?

Maybe something like:

	mutex_lock(&ccp_debugfs_lock);
	if (ccp_debugfs_dir) {
		debugfs_remove_recursive(ccp_debugfs_dir);
		ccp_debugfs_dir = NULL;
	}
	mutex_unlock(&ccp_debugfs_lock);

That should also fix the issue, thoughts?

Thanks,
Tom

>  }
