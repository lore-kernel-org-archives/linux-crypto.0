Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012064.outbound.protection.outlook.com [40.93.195.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9203F1885A5;
	Sat, 22 Nov 2025 03:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763782539; cv=fail; b=ZnLivptbJPLzhhdwwTt1wAtFg5Mh9eDqGhRGvJ8hQE8xL/bctf839jAxEh3MZKUudKGDjFyBZIxpkSpmjb8vssj8wtEj36+LCSqAZX/3WPc5ipL2taYCL3mWHtrBhIb1Ld1XNBionrvW3fXVqzLNBvpwWxabm8dElmlhSl4wvpI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763782539; c=relaxed/simple;
	bh=2pCSYffIMh92yjQDZjcGHcIEjUhV/H6dESPnhfCTO3w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ImlPsrdbLMrE8E/bSaLmxiP28bZeT8IsTGFxajHozvRvHT8yKSVvVgBotoWQSpRG5icfATnA0UyfSGRbwak1K4CpGuga6OxaG6G7hjofpUCtIXjU3edkYtDE5hbsnYaZj5rr4a0/AoZWjCF4pVEiw+Sikwe5beTJD3yLzhdCYm4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OQZs81sT; arc=fail smtp.client-ip=40.93.195.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OQZs81sT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J8UlLUj360TvqHbm7AXEbHLBOF4+tYKMGp2tUOwsDManfIeLYdm7wUlcdJMdif8Nv1UdTA1U+K46CuiGdazy1scsT7MFihYTVdF2emEdiIB3yJYxRS+AhF/AVaXLFsoMptz4RPe7OMGSAoVq1hkkJ8QkJNa/KDau1ZlEhvCeHuANKeyv27wiDvav8xRaI5yhBLG7A2dO7M8Af5+DGxmchmU/5paBt9AMtF9vk5fLtehBr+rNK8w31dDzjpgk2F9gNENWKNJ9n9gs6jPCWcLl4PMoNYRb19jEK3B62NmCFpPHfTXOvP/gf2Ou/0LUdShJvPLpsbX5pye8ydGhlmbR2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dnpyfTH4xBHFQa15Aek+yTRQYjmG9xx4YiIiplcYkLM=;
 b=o/SEpmwYxmsg/FrsAK7bjOaJUeY+nW0LoBAe1gT9vjs0zMyHoFj6LIvVOzlzqvG+5Pm6FJdyc6reJQeKRfXKI2b2r/d//DYnMZyqz1Rbm9iwzBwWEZtBnlUnCO+JbLNPfF1C/BcMki0sh+lmELr1l8MJ4yHx4igmFAgskD8a1WNYpVh10CiObZkiw4Swzh/ifBvlg7cKsB2vLEFRay+1FfI8SRZPyUfV+cXXRZhcohNt8/wN9oaUV9SP8BDI4wjNQtXCWNTCFI8LHYG4Cql433gAWEE8UyfVzjQ073Vqgi9SltXWcbUTEidlZzjgYUal0fLp+NL4/2WcywyiBtXIgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dnpyfTH4xBHFQa15Aek+yTRQYjmG9xx4YiIiplcYkLM=;
 b=OQZs81sT0yw5lF6dOoEYs+8IvQZaoSCOOAzlmu1KkVzWR7SwU9FUsAseLGGrgIn4Rx1dMY0FIuXlEz1tp7x/gvyZ0EEWiKNcGEhHXuP8nO6ScqB2gqwcgLeyqh0uWq8AXpDiYdXwVbJ5ZwCv6VqV141w6NS6YN8Lz3m7KF4IIRo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by CY8PR12MB7289.namprd12.prod.outlook.com (2603:10b6:930:56::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.14; Sat, 22 Nov
 2025 03:35:31 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%4]) with mapi id 15.20.9343.011; Sat, 22 Nov 2025
 03:35:31 +0000
Message-ID: <b56046b5-1fa2-404f-b99f-353ec8567621@amd.com>
Date: Sat, 22 Nov 2025 14:35:03 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH kernel v2 0/5] PCI/TSM: Enabling core infrastructure on
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Ashish Kalra
 <ashish.kalra@amd.com>, Joerg Roedel <joro@8bytes.org>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 "Borislav Petkov (AMD)" <bp@alien8.de>, Kim Phillips <kim.phillips@amd.com>,
 Jerry Snitselaar <jsnitsel@redhat.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Gao Shiyuan <gaoshiyuan@baidu.com>,
 Sean Christopherson <seanjc@google.com>, Nikunj A Dadhania <nikunj@amd.com>,
 Michael Roth <michael.roth@amd.com>, Amit Shah <amit.shah@amd.com>,
 Peter Gonda <pgonda@google.com>, iommu@lists.linux.dev,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 Dan Williams <dan.j.williams@intel.com>
References: <20251121080629.444992-1-aik@amd.com>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20251121080629.444992-1-aik@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P282CA0016.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:202::12) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|CY8PR12MB7289:EE_
X-MS-Office365-Filtering-Correlation-Id: fd3b65b6-1283-4669-78a0-08de29782f99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?KzVKWFdtR3hpZWZNeGhSR0hkQjVkWHRscEg3bUZrU2p0VWlNT2wySDUwMW11?=
 =?utf-8?B?V3pvY3FsSjFpeWdJNXNqNlJMNHZQT3d1dEFjb0N6UFBFTjF0bmRKZTFZcm9I?=
 =?utf-8?B?M1hGR1pLKzhucEsxcFRCbU9HVUN4VXl3WHpoY1MzdmdlU3NIcGU0UVhTZlhL?=
 =?utf-8?B?NFBtNno1UHBhaWFvUmQreUVYaVpySmRHVzJ1YVBRMW9RcjUzZHFiZ2QvcTdK?=
 =?utf-8?B?VGZBNVZ5cHBkbjREQnE3VlBkd25US0lZUDlwNU9SRWxpa0FJUGVnREJxUTJI?=
 =?utf-8?B?RUF2d1VQbGdWNlpONjA1RmFTQ09LTktuQ1N6dmJQZFowZm0wcktlMDN6UC9Z?=
 =?utf-8?B?V05yaDRRLzA1S0JpVXI2YllMczRrbkNHaHBhQUVrVE50S3NnUUtGWUZ1aUhB?=
 =?utf-8?B?UnpTVGdVaDVPcGxzODR1RXlYd1Fia3ZNdFlrc3ZHTDdSbkxCOVdvU213MGJ1?=
 =?utf-8?B?WGVVZEVxMXVJWVBmeGErUnBQTU5jeGEyUUplbFRETlpVYWVXdmFtM3BWZHFu?=
 =?utf-8?B?NWxKWDY4SDhvd3hRcHcraVREVXZ6WW91N24xcDB2M25zSzRZbnV4YnZoZVJ0?=
 =?utf-8?B?V0JrekZ5ZVBUaThDbDZjSVh2QUFGeE9VdTh6TmtMK2x6a1JaREd2bVdvVFZi?=
 =?utf-8?B?NXB1VEFjUFg5VmhKNEoxcTNhN2lwMWE4TmNnTWZGTlZoeFBjbmw4cUZQbmJ5?=
 =?utf-8?B?QTVLQzVrT2ZYb0FuWk1nQVZUREtEa3dYdHNzTXozTktrbXlIaXFoQjZyNHdH?=
 =?utf-8?B?eWd5MlBJdGRRR2dVUERoRlFaL04yTkZ4ZzdhbjE5MmxiWGQrRmFvL3JBaXlO?=
 =?utf-8?B?Wnc4aEt4NGFpVVIwTlNUdzNKdHBZMW1GV1hPNGF3YW1DcUxCV3JLbmNxYVdY?=
 =?utf-8?B?WUtBanlRYmJnVVpXQksvWUJ1eTJHZ0ZiVFRHeGE2OGdwUXdhd3FsVW1IZ25y?=
 =?utf-8?B?ZGQ2NnBaUXNHdFZWM2VaSjhsL2ZmTGYwMlNjOXhtR0hwRER5N2M2cjJ4T0lY?=
 =?utf-8?B?R21nUWVVRzlGVmFmT3NSNzZ5bEVCSE5WRU5XZDVOWk90T3RhSWdseENETVRQ?=
 =?utf-8?B?QSt6Sk9QVWUrWlV4L0tYNEEzTS8yb2QvUU0rWlYxME8zc2JCMkpBQzZYSGVz?=
 =?utf-8?B?SWEwb3dMUnRjSWlnR3ZVNHh4ZjhJRTR6aHZUTEg3YXV5S2NyR2FLRjZqVlZY?=
 =?utf-8?B?L0tyTUdNY09YZVBBNE9sTDFFOHJjWTJxUWdweEtkUnJ1OTVmL2dvRExhWUE5?=
 =?utf-8?B?dTlLK3p2N2c5c05vU2xvUjhQR1VFdFpNaEU0MlRqWlNtbjEyckRQeXBEVVBm?=
 =?utf-8?B?YW5TcFJaRjBOZ09PYVpuVzI1dW1RMit0SzJKeVlCejE5TTl0UU9zTkUrZkJT?=
 =?utf-8?B?Vk9Yb1VHbjdhVzkzeENmeXREMWZ1VnpsZ2ZEeUtsQUpOZ0pzcjU3cmRrMnRX?=
 =?utf-8?B?SCs2bGJKdjJKdHRTd2NONHEvNFM2cmQrZjY3N3I3aEhxWmN5Ly9xWTVmdWky?=
 =?utf-8?B?ckJDZGhaWUVnMzhqZjlGdzZUODRoSFRhdkxpdnNGTjRiRmJYdW5WaVUzTktr?=
 =?utf-8?B?RmNra1FzZnA3QTduZlRMQWtWa2JHUmlTSWNyNVl5d3BIaEIwLzhxVmZTV1M3?=
 =?utf-8?B?RUVwRmtZMkI1aGJLczFLOGdmTFkyRWNqc1V3Y04zcG5WcDdNbCtnQnhuNndP?=
 =?utf-8?B?YzVjS2F0Z09uUmRzNC9mbms1RWpMN0kxWDlSS0Fha05LLzhMWXhldTVsSXJL?=
 =?utf-8?B?b3NmWDJzVjlic2U0R3NWbmc5Uk5GQUJWTFlVanpubnV1b3JoM2RXMU92aWNU?=
 =?utf-8?B?Vm9hdSsxVGVOU085MXNQclVrZzIwT1NaWlh4TnRQUXFxUW8wVWJGakpxRHZR?=
 =?utf-8?B?SmNkcUJJNEh5VVM2WVBtWDBmMjFLN251MlVnaFRwazBhR21yUFkyRmkvNWxo?=
 =?utf-8?B?SXFCNUxReXJwZDIzSUkyOU53WkNHTHZmZW5HN1RiMzhzZlI5aG5OVTVtcnRV?=
 =?utf-8?B?cjV5RHk4cDFBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eTJHNWkzK2l4MWFEQ056bWk4cThFTmNpcVE1bDJNQ3FTdmJicm9tUjNRSnhN?=
 =?utf-8?B?RUtrbXMrR0VwK3hSQVBhblBOSkk5NVRoMTM1S0xWOFBTS0JiOWdQeUpEQStn?=
 =?utf-8?B?YXpmT00rWWdiVExoNTJmclF0VFB0UktEM0IzWFF1Y3pQSzJVRUttSW1zb05o?=
 =?utf-8?B?NXljYmMzcytmV2xoWHRVUFlpcUtMSE1GaWN0VEhiYXZTaE9JTjZYWlBSWmNl?=
 =?utf-8?B?cXcveGMxbDkwNzdyRzljYzVPQXNBTzd5WVE2WVBTQTNieFNwUnBtMmlvM2tO?=
 =?utf-8?B?by9RTmtSUUsxak5GUjNUZitNNktrQ2VLOGNJQlRmaTlqaC8yZkVQcTFRUmFT?=
 =?utf-8?B?bWtrMHN5cWJBMWQrTzBwZFNiUnFHWVlMK0VXeExlNGZiTHczSEEwTlNOTUk5?=
 =?utf-8?B?cDFka2Rzd1pONEtzNm8vR2I1OEt0bzJTbEgzNWRlQ3Y3ZnJNeFhCaVJKeVRE?=
 =?utf-8?B?YnJ0dGtwVS9QbjhkRW5mTTZ5SE9rWVVQRFhtcWlaaWVrTVJkc0svemVyeEto?=
 =?utf-8?B?R25VNytxZVMybG1sVXU1R04wL08rYjcxa0hZMmFoNC94dFU1VDNLQy9IbUxh?=
 =?utf-8?B?MDhseTZQZno1UmNzSTk0U1BwMjBsNGRqMUVQTEYvUnRpWGJyY0VnWlo1K1FG?=
 =?utf-8?B?QUZxM0V4OGpnc3NKVjBPUkdUTC9PYk54cHk4M2xoWjNLUjFMaHovVHJOY3VZ?=
 =?utf-8?B?bHVnMFVVOW5VRmlJMnZRcUxoMFhydzk1Mkx6elB2SGt2L2ZHM2VXVHdUNHRG?=
 =?utf-8?B?Q1FYWG5jYnUvZ1o3R2g1QVJra3AxWnlrd052NWx6STFWSXA0VWdyVy9YaEd2?=
 =?utf-8?B?Ym1TV0EyNkVkVXYrcmYveThTc2krN2tQZ3ZkRUtZMHpHMW8rcTZDNFhhK2J0?=
 =?utf-8?B?N3M2QnhHTitya3pLcm92dWY1RVpNME1JaGIyTGx1MTlnNEd6djA5aCsxbElJ?=
 =?utf-8?B?dzdnNThsVllGUS80ZGw0T0VlL1ZzQ0dzMlFoek1RTVI5T2dESktaMlJmZW9w?=
 =?utf-8?B?dmRMWDhNZlY4Y09RanlZa2JicUYyL0lsb0FpQUF6YS9ETzY4NE5UZGRiUVI1?=
 =?utf-8?B?Q2R4aHFVM1QxZHY2VEZ2UHpQaUZFNDNzcFpoaXFtYzV1Wk1XK3lHd2tsdnhM?=
 =?utf-8?B?SVZRSythb2NJc09tWXVzS3A2c2l0NW0xMXFTb2QvSkpXRmhlY2dxVWppeTlm?=
 =?utf-8?B?clQvZjJJUDdoeWsrYlFOcGhsNUd4YnUxNTk2Zmo1NmlEcERFWnMyVGdxeGt2?=
 =?utf-8?B?alZGRXNDM1FGbjNMUDhUb0VMc3NyQUE2WnlNVWVjd2Y5UHFPUXNnNnNJWHNz?=
 =?utf-8?B?NkJJbUpBRm9lci9jcTZMU3pLNHk0YkF5bldHdDV1Y0gzNUdvdUpoMmpKa3FY?=
 =?utf-8?B?dmhIMlJPbm5zaTNtajFJZ1BKWVBjQzRrbzJ6VnhRNFlwRUJ4dllIQUQ5ajd2?=
 =?utf-8?B?by9CdEpBVHR3NzFmbk03aXJjR1NMTnVUNnF5d3Z5a0Z4QmRiOWoySW5UYnlr?=
 =?utf-8?B?UWtpQXJ0S2NxbHJXTUxOY1BJOHJ1S3N3TjBlZjloamNGU08zK0V3WTNWNmYv?=
 =?utf-8?B?VWlGNzBIVWtOblZKQzc3UnZYbVI5RTB1djlzTjN0NGliQ3B4KzVpaUI5NHE0?=
 =?utf-8?B?TktDQlFiWTd3ZldrZ09BUVo3ZkFVYUtWSWpjc2ZCQ0ZHdEtBZ1pJUDFEZXNH?=
 =?utf-8?B?Q0hLOUNXeW1yZ0ZuQmhOSG1hbG9lQ0hVcTE1MEVTMVNzNDlKOXltVFkwVW5B?=
 =?utf-8?B?WHNnVG5BZW9oc1hEZzZTanN4eVpHRy9WWXM3SFM3Y2IzbUpMMkxuWU9PaXJH?=
 =?utf-8?B?eTJlYjNBMlp0L3BmK1hFdzhIZmwxMi9DQ1RjOHl6VFdSQnkvTzZNb2lWc251?=
 =?utf-8?B?OUlDNFZuNmZMWkpoY3Ewa25kQXV0d0lpSTFqT2dJb0dQYWVBNEpsYVA0UHN5?=
 =?utf-8?B?elJmb29uMzE1T1g5NDE1NHdYY2J6bjhqemxvdWVJVkhSV1pUVmpDd1JGcVJH?=
 =?utf-8?B?T3BhV0xFay9udmR5dFdGSlI0WWtpL0F6dUhMTFJVdkRBaU5CVkJFeHQ3ZlAv?=
 =?utf-8?B?bmJRaG53OXo2cUt1bU1nRS9tWGZTQ09zd1V6THVLcm1iMlIrTlBabm5NbTVX?=
 =?utf-8?Q?0B8HHxIbic4m7WVNqsE3pVAtJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd3b65b6-1283-4669-78a0-08de29782f99
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2025 03:35:31.2055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2jmS3Mo4juAPZiAJ7gEqh7Kh6ORSgeiTrR3q7vDouOj1s+kjJPLqwaHW6AzY6KMQ5/YCPKLfDc3VPma8Nibv0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7289

I should have cc'ed linux-coco@lists.linux.dev. And vim ate "AMD" from the subject line. Should I repost now? Thanks,


On 21/11/25 19:06, Alexey Kardashevskiy wrote:
> Here are some patches to begin enabling SEV-TIO on AMD.
> 
> SEV-TIO allows guests to establish trust in a device that supports TEE
> Device Interface Security Protocol (TDISP, defined in PCIe r6.0+) and
> then interact with the device via private memory.
> 
> In order to streamline upstreaming process, a common TSM infrastructure
> is being developed in collaboration with Intel+ARM+RiscV. There is
> Documentation/driver-api/pci/tsm.rst with proposed phases:
> 1. IDE: encrypt PCI, host only
> 2. TDISP: lock + accept flow, host and guest, interface report
> 3. Enable secure MMIO + DMA: IOMMUFD, KVM changes
> 4. Device attestation: certificates, measurements
> 
> This is phase1 == IDE only.
> 
> SEV TIO spec:
> https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/specifications/58271.pdf
> 
> Acronyms:
> TEE - Trusted Execution Environments, a concept of managing trust
> between the host and devices
> TSM - TEE Security Manager (TSM), an entity which ensures security on
> the host
> PSP - AMD platform secure processor (also "ASP", "AMD-SP"), acts as TSM
> on AMD.
> SEV TIO - the TIO protocol implemented by the PSP and used by the host
> GHCB - guest/host communication block - a protocol for guest-to-host
> communication via a shared page
> TDISP - TEE Device Interface Security Protocol (PCIe).
> 
> 
> Flow:
> - Boot host OS, load CCP which registers itself as a TSM
> - PCI TSM creates sysfs nodes under "tsm" subdirectory in for all
>    TDISP-capable devices
> - Enable IDE via "echo tsm0 >
>      /sys/bus/pci/devices/0000:e1:00.0/tsm/connect"
> - observe "secure" in stream states in "lspci" for the rootport and endpoint
> 
> 
> This is pushed out to
> https://github.com/AMDESE/linux-kvm/commits/tsm-staging
> 
> The full "WIP" trees and configs are here:
> https://github.com/AMDESE/AMDSEV/blob/tsm/stable-commits
> 
> 
> The previous conversation is here:
> https://lore.kernel.org/r/20251111063819.4098701-1-aik@amd.com
> https://lore.kernel.org/r/20250218111017.491719-1-aik@amd.com
> 
> This is based on sha1
> f7ae6d4ec652 Dan Williams "PCI/TSM: Add 'dsm' and 'bound' attributes for dependent functions".
> 
> Please comment. Thanks.
> 
> 
> 
> Alexey Kardashevskiy (5):
>    ccp: Make snp_reclaim_pages and __sev_do_cmd_locked public
>    psp-sev: Assign numbers to all status codes and add new
>    iommu/amd: Report SEV-TIO support
>    crypto: ccp: Enable SEV-TIO feature in the PSP when supported
>    crypto/ccp: Implement SEV-TIO PCIe IDE (phase1)
> 
>   drivers/crypto/ccp/Kconfig          |   1 +
>   drivers/crypto/ccp/Makefile         |   8 +
>   drivers/crypto/ccp/sev-dev-tio.h    | 142 ++++
>   drivers/crypto/ccp/sev-dev.h        |   9 +
>   drivers/iommu/amd/amd_iommu_types.h |   1 +
>   include/linux/amd-iommu.h           |   2 +
>   include/linux/psp-sev.h             |  17 +-
>   include/uapi/linux/psp-sev.h        |  66 +-
>   drivers/crypto/ccp/sev-dev-tio.c    | 863 ++++++++++++++++++++
>   drivers/crypto/ccp/sev-dev-tsm.c    | 405 +++++++++
>   drivers/crypto/ccp/sev-dev.c        |  69 +-
>   drivers/iommu/amd/init.c            |   9 +
>   12 files changed, 1556 insertions(+), 36 deletions(-)
>   create mode 100644 drivers/crypto/ccp/sev-dev-tio.h
>   create mode 100644 drivers/crypto/ccp/sev-dev-tio.c
>   create mode 100644 drivers/crypto/ccp/sev-dev-tsm.c
> 

-- 
Alexey

