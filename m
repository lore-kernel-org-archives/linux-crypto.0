Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2512B1FBBD2;
	Mon, 13 Jan 2025 16:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736787493; cv=fail; b=n7XAs1Tqy2/aoa55ql9pAPB3GLD0e0Cc3T+02WSo3WgxBU8y9HjrcAMzC0HFeenwrrSrCgIr+EcWkGcgDdCo7yGfL3MJLBu5LjFLIe6P8e8Zd7UeTYpE5A3NzdmLE9LfAjtJ2R0V6BTi3m+kw/0igIgAyVZBqvTu/fIVwtJgBNg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736787493; c=relaxed/simple;
	bh=MdbRXHRKQu+KdAQiygeBgiHscaKNWzrZ34TS/683VyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lMmn20XnbUneS7MHKjZLuoeyuhK96V+aDpUlT3Ohnlhfc/n0x3QzT8UELzvKYr4P+fEKUk3KiCUcBWqERRi7y3nq9acRYVNA5i2+4ZUlnMfkkti8wUPdHgzxsLTncgNBCaQjZywf+6SqnzVQObhwFibG42zMWEcxaBlcoKYyXnQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nbYyiZy/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QbaaeLSs; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nbYyiZy/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QbaaeLSs"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50DGtoeW016126;
	Mon, 13 Jan 2025 16:57:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=SsZNuqbbbFBY2eElCV
	9I6z9fe8SLNuxtVs1FRyXECKE=; b=nbYyiZy/CQ1iNHhDeEi1Z9mWlI1Zxxlb75
	gudQ/1pZbfmeTglKcUu0HV2UctiVwAKGzS5LfN1DrC3c3uAM8euNAzBRpMSe611D
	K0lx0M84RP/OiK5WIad5IH3+pYmUCnUai94a+wVNhbMz2pMEGbEupyr4pd034Bp9
	uuL1MGNJhccou9KoPuIORCMjkQjA4IZOs1+zu7pvxn5qIIkqgO93uokOfARreVeW
	LJ9XmK4636MUOdm1/taz8X/pAswmxqEFtuuxTvgBvzzGxwRBXH3DOdDKMwypwIfz
	vc2/O/ApWQ+MVVhMbsp6BoWqrQ0gP++At5THvSiaBvey7CtM/mMg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 443gh8ux7y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jan 2025 16:57:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50DGMmbl036256;
	Mon, 13 Jan 2025 16:57:53 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 443f37pyg8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jan 2025 16:57:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v0qw4s43MIlNN21QBBoOq/3asNlV3MSrLgOCQ6Q/4DozW19gmeSGeQF6/HqHQZHg26+IyUm0IaTJStuLpWiilINMV8+C7VHpUp3SwD60HgEiW1ObKIGhn9+60mh2VfMPP7jsufQR6REiKfEZdLd4kMqipBjOxDcfdwH9il/FhIMMOfo+m9BqXa8CSg3qAEbWywt7+m94NbErhAdVL5PfoBooatZ+M3u1Xs1n73z2upR5IEd2FqlfkwbwYTrL5gY36WqcmVVUreFejgoBs794Jb7Qd4T3HTH+yLSBYt0cftvnFPs04HpXvKylrL80AEoeLgbE04ntOwvgUES7biS5og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SsZNuqbbbFBY2eElCV9I6z9fe8SLNuxtVs1FRyXECKE=;
 b=llu4FouSO7ZWi07hIAg5NNmVFSRiamEZ6On++dT61VCF7uW+Yw9RFmBIZsAinOeXf5WfCxxvs9+SLz8fCB7I06jIaxj9vKDkBfgIgsmG0AhfAbzSgfj6ZquHMXEQwHUNB7dFA3PiXIwdLckgyiQYpDy8McypwasgQnfFsx+G0ukFpJQ8QRTEbXa8ySEurfwAyOTrG07FOKNcuoGSNeNwAGesjcGcrimx012ynji01ciQIvzfx9cUxcKf3ryBqbN1dU7BNcXzSoEuN0C4NrOGqvek4A7OG9roW9TwXyWph+ZycPbDOohHUEjL0QZueejdIIKx6gKsgLOgvRH4bLZHHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SsZNuqbbbFBY2eElCV9I6z9fe8SLNuxtVs1FRyXECKE=;
 b=QbaaeLSse09pSfsEnwgDSfIZDFAN22mmdgdDDUnpq9zMKZHGJ875B5WXuz8AklPdR+cbiZ4sWGzmYVtv2B91gG7D7nk7U8CcYavGlgRVfrJOMJGkaeCZbNQG13Z9JgCJ74nYwWnrzjlEUF65gEO3MABq2m2py1dvjsplADMLNcg=
Received: from CY8PR10MB7265.namprd10.prod.outlook.com (2603:10b6:930:79::6)
 by CH0PR10MB4988.namprd10.prod.outlook.com (2603:10b6:610:c8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Mon, 13 Jan
 2025 16:57:51 +0000
Received: from CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc]) by CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc%4]) with mapi id 15.20.8335.017; Mon, 13 Jan 2025
 16:57:51 +0000
Date: Mon, 13 Jan 2025 11:57:48 -0500
From: Daniel Jordan <daniel.m.jordan@oracle.com>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: steffen.klassert@secunet.com, herbert@gondor.apana.org.au, nstange@suse.de,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        chenridong@huawei.com, wangweiyang2@huawei.com
Subject: Re: [PATCH v2 2/3] padata: fix UAF in padata_reorder
Message-ID: <ktpl3s4ogjjj6gfpsk6kv7ta7bdsxg6d5abdvehcm565kl5ihj@ownbjs7u3ylx>
References: <20250110061639.1280907-1-chenridong@huaweicloud.com>
 <20250110061639.1280907-3-chenridong@huaweicloud.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250110061639.1280907-3-chenridong@huaweicloud.com>
X-ClientProxiedBy: MN2PR19CA0030.namprd19.prod.outlook.com
 (2603:10b6:208:178::43) To CY8PR10MB7265.namprd10.prod.outlook.com
 (2603:10b6:930:79::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7265:EE_|CH0PR10MB4988:EE_
X-MS-Office365-Filtering-Correlation-Id: 5af694e5-03ef-4734-9334-08dd33f36a88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WVQo1uVO1ABAyUOritVVhxuKvBvUZOynOxITpQo7PbDRrv3sE+mZhQGcoFgF?=
 =?us-ascii?Q?VYqghNFhRVR+tZo1BCnG07ajYkqqIz1wWMN5hG/cqX0itGugcUy4vlUeJqJ7?=
 =?us-ascii?Q?KcmyX8adinlFkxagYZfyvtjc68900Bj5Pm5FyeB6wVSYymIaKdFBfucEhvEv?=
 =?us-ascii?Q?DEZ+Zb382IyyQBfCK5sD/yBkCQlvu2jJeFK863APj+T4/prqmIO78NoIllKF?=
 =?us-ascii?Q?4G0la1FsoaFgAAHzRg/0QvznDIVdsly8bMIDyrXQUt61qy/sKwrEEcbgaORv?=
 =?us-ascii?Q?+nV86uX+tpLA7JFQ0d4MYJvab3BEtH8X5SAilmeMAi2w/2N9k+9Tk2IbsabG?=
 =?us-ascii?Q?xufao1RxPrlIgknGXk10SamiHvGEUaANHfcw6s8PK5p7zMS9qlYiCq/7C4mB?=
 =?us-ascii?Q?L6WLZXk8WsZ9zKipdBoMMDqze9atB0xf3KZwpnhaaTfGFxM6+F7Ikv0l6EMg?=
 =?us-ascii?Q?mHzDVl/17a96hI8Oz/sfAHbP6MBTruZNe6wFN+RpNUKoQlwjUMiaB9YXwe9t?=
 =?us-ascii?Q?0NkzYaeqY7Oxb/fbGivocSrsozJ0fnDTJW7IWGV558y6H0LBjKYoc+Lzj5PU?=
 =?us-ascii?Q?PLxmq+HGoC2lhd0INxv9IJYOwYt80uyxFstmth2khVAf/N8TJtAeObFjq/uX?=
 =?us-ascii?Q?7nLADf/nd2o7gckOaGpDFeExUXbXYuHzljNYCwf8vGbISG7OCaQKF3jlPyQ5?=
 =?us-ascii?Q?SdZG/1yOZYBnhW/qcZjjW8ZVXkBeVVI+3K++6hWvX8O35NhBBOKhgyBd+YWj?=
 =?us-ascii?Q?w5UMvmJSmvKnt7ZVxVcalNkdjtgd6OHzwbP4HTUFPv3HfNWdHInVyRjhD55v?=
 =?us-ascii?Q?oFRxbJZ3yluxDxtS0+4zaEj4TaJBonDGDMya+5oWBH4cTAV8rmtDfDckGeJK?=
 =?us-ascii?Q?NArIFKmJ98NQIHiuWWqYxvvkNkTCkhN/h1oQ5aU/WbCyPolwFKKXmy0YbxRT?=
 =?us-ascii?Q?C3I4NNjyEvqDrw7AJtnvAdlbP74rY5oJlyBagyLICfBTi9C7wbyi3DzoOxAD?=
 =?us-ascii?Q?yKQ4LPBUoGJz1ztSKp45GB220sxrFs0DrsaI0ZZbnmIpm5TeW537BUN3UyE0?=
 =?us-ascii?Q?CYqbzGqCt68lUv6WQCi/L+IQ+SJV3qt7K5RtCafP/2fTs19IMwPJvyOaLpE7?=
 =?us-ascii?Q?vAthL48CV91InsQfofnbL6nynw36gOFxaQgFyGOLqEa+wFKf6hn5Yrc/qXnx?=
 =?us-ascii?Q?5Ui3hIYUJ9HMT0FeNPRy/j2tHQTWgI5dgDV4vcG6mjd2rQlYr0K2G+nniDCw?=
 =?us-ascii?Q?oh4HM9bP6pjGDCQITHhF1Pz/ODeXJlqkl4YcXaJ++SQOQ4vkrJuwbh6nGLoY?=
 =?us-ascii?Q?/9z3MQ0vBWTTwxTpv0F9DOoj/Mrm0cusDC1pfUwl+ByJNA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7265.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wPYIyKCa4Pc3JCRff1Ov5K9IChNRk/xQcjbjS/z9z5m/dIbiyVg2u5PQIFx9?=
 =?us-ascii?Q?me8pDEH6jZgojsk9LVYjLq9A41WNoXkLgSJ2rVYLf3YX1ntqWo8KqvaDyXTo?=
 =?us-ascii?Q?1ovj8OEMs8tjMVpzmGusolDQ9EFG031jevQey2sTA8FlVKnQL/vuq/U8O0jw?=
 =?us-ascii?Q?M4ypTAlRw7fGLlKQ8WHcAp/VNTw17Pt0aFR55E4z5XO/ysUjkpyCL3DBdgoV?=
 =?us-ascii?Q?GeyeHFmqHzbUjP52fZfVWTs9dTphPjcNuTOpS8YyUSD+eDAQYbbv1C3ZuqnY?=
 =?us-ascii?Q?QeZ30BmpgCuhy65SMMivdSTXJLN3+kCDxK97lrj1lvm5x8d8hDLpoBE0usuu?=
 =?us-ascii?Q?JEThoVv+YLcwedDCUz35to5rUuXByAoJkXZTg4hx2qVF5epFAgeUzPL52dLj?=
 =?us-ascii?Q?Y263Z6DQIRH5qHKsUMoax+EiXJZlA2MURQuFuxinSfqmtAuPkpo31a8qKatO?=
 =?us-ascii?Q?sGOd94ZemVMp32PVOKd1ncRMb3gj3kZ4h6ZlkkAQ2mSJ7bP2VNkdfX6OKMQ/?=
 =?us-ascii?Q?bKKxpJdU9g6lW99A+MqPuQTAq8rQhR6wl5o9XyAwEfb1G96k3Xox6ndLNI7q?=
 =?us-ascii?Q?Fufc3K10+W6nm8dO+jol6lv/cGN72fWIE6xuxu5YrwxVrfnTc9uDM7boz/M5?=
 =?us-ascii?Q?gz2Mc2pcD/ac3ldECXks1l+RLxaXMYxP0X8FweTl8ppBDjhqolQoQyKLlmli?=
 =?us-ascii?Q?gOXKDpPxzPMKnUnnD0odWjECcHP2zlY8uVFBUEYA79PjnVSq6LEUxJXbmtG9?=
 =?us-ascii?Q?E4UjxoOIH2VLowtOZ3U6ZQslvcL9OyIY0oIOjixnG1S/Kv93sStpOK/fxKgv?=
 =?us-ascii?Q?VftXEgwn0gzRgRKoYLLNfiGKmRcnqmocvfUpsB7OSK4+nmU4Zk7LUMofAnsV?=
 =?us-ascii?Q?Jy2Z5Bl07Bd1suZOXNSZbKgfy7ukpJAwmaFBNk16hM7ZYYleEsqlO8BuJczl?=
 =?us-ascii?Q?nTQiXTu1Wg2oCtou1vfJYtziGyROCEOrY9KPSs79G7ZzYU1YFQEPWHVkS8WC?=
 =?us-ascii?Q?gf39wJxedhVdq9Bzg3rh1xwF9Oz32wsOXB/GToujO5LVxBXfKm6Ik/5KBoQE?=
 =?us-ascii?Q?0LNWDd5yiLuz/TqLdj40z5AoHl0X+ILcvbalqbL/qpx2+7xAlht5Gb73DZvy?=
 =?us-ascii?Q?buGMYVox6siownSh4gw9elRHvStElQI6yyRFnaTPOwg/XR4P2RpprAKsIj4a?=
 =?us-ascii?Q?NWEUz/c7Jkcr/N5qswmTtqwbxDLpQpJwcBvva73kW6oenEXQPyTSInI7cW0w?=
 =?us-ascii?Q?g07E6/ygNFvArhikKxTN4hXZ/EgS3l4l+T3EPX0afr0buvbWEategw2MMagt?=
 =?us-ascii?Q?0ZVCJgt3M6INOCL0o2nTalU9agknE3ppmMjjnQdJ1PKTYFZcYptGL436SuCY?=
 =?us-ascii?Q?UGdbFpqhBZyhsePLZ01U8CmkswyIFFrnW/0fULfTB7LpPeLdGIUdeWJ0aXP0?=
 =?us-ascii?Q?ShZ9ghFhViMOU611c7Z7iUrLoKexc9/eqe7gQO2Gc7twK3cGU4TXh4Z8iavl?=
 =?us-ascii?Q?4ibWPr5v0INVu+KiX+rbk4AxRmDQbYgPcjl5s08SeW2MJYStqb/m0XE3FUEF?=
 =?us-ascii?Q?oe8KjwkM8r94ou4mx5+Ds7fs+Qu9WmdJ/Hsv5X86umVKWUiGjt0wmxtZ2dpV?=
 =?us-ascii?Q?LA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	W4k7J7x+NTTEqurLyIFakNcvjfbJDf6RrCouS5K/LkHSF1Y29OUQ3EZoZkUtlSH6n6/2xh2iiiREryez5XZMpvzFZbif31h/Zaz7qE2yEj86nkb34XV5rSzLZF1YRm2K4o/8aEgc3f1+rLI+96mNebKUyJTE/FBTG/cX2gWS6W9UjnoKachCFbaAEB5PieIuj5fZHhbYxofQ/V8Gb6KdwFAiCwyCF1Y5F2ah9wx3+TFdiDdgZIm/MftuVRD3KZ1vDXN5bC2honmREh1zrW3iQCLYSFjhjlsqagnHr8ui1lc+Iwx+r/WaIB2T91HJMo3DHwU38ueqJd8L4881lTiu8lzj1WFZ1LmdOYzjEHAky+2Vxe1DpJ0b3fnLX5Bp6JvlYdLQkgqsV+9o0eu8w6oL03CCa6xUoQvROU0vaf2wHrDmHKmw2tSzRBq2dv5z7qmEzLQdyn+M8y3kJBw4oi9XKCKW/7RW5wo2m5AoPFaIv2m5CpbTwx5oVM2X5j4HI3MFJEonIqwtwyLAu4AqIBTeCu+aZshR1+ZzfHJbFrLXe2dbs9zsz8FVpWtO/3T8DUeEDMsGWaqG6z5Z82DWj8yuhMCgImkXwcW8AA5Owq6aacE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5af694e5-03ef-4734-9334-08dd33f36a88
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7265.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2025 16:57:51.5146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +UTDJ00NUTysALSTop7lTjl0F9QDOTMX094sDALb5ep78H4i2Y/4CO4TVZUx1BPXo4Hssd+1qLnkZd+cLWBIn+CRhiS9eS1Ot62JDokFwTs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4988
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-13_06,2025-01-13_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501130138
X-Proofpoint-GUID: 5qh7u6z7PTzmnDcd5mjsE6VzEtF-nyp7
X-Proofpoint-ORIG-GUID: 5qh7u6z7PTzmnDcd5mjsE6VzEtF-nyp7

On Fri, Jan 10, 2025 at 06:16:38AM +0000, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> A bug was found when run ltp test:
> 
> BUG: KASAN: slab-use-after-free in padata_find_next+0x29/0x1a0
> Read of size 4 at addr ffff88bbfe003524 by task kworker/u113:2/3039206
> 
> CPU: 0 PID: 3039206 Comm: kworker/u113:2 Kdump: loaded Not tainted 6.6.0+
> Workqueue: pdecrypt_parallel padata_parallel_worker
> Call Trace:
> <TASK>
> dump_stack_lvl+0x32/0x50
> print_address_description.constprop.0+0x6b/0x3d0
> print_report+0xdd/0x2c0
> kasan_report+0xa5/0xd0
> padata_find_next+0x29/0x1a0
> padata_reorder+0x131/0x220
> padata_parallel_worker+0x3d/0xc0
> process_one_work+0x2ec/0x5a0
> 
> If 'mdelay(10)' is added before calling 'padata_find_next' in the
> 'padata_reorder' function, this issue could be reproduced easily with
> ltp test (pcrypt_aead01).
> 
> This can be explained as bellow:
> 
> pcrypt_aead_encrypt
> ...
> padata_do_parallel
> refcount_inc(&pd->refcnt); // add refcnt
> ...
> padata_do_serial
> padata_reorder // pd
> while (1) {
> padata_find_next(pd, true); // using pd
> queue_work_on
> ...
> padata_serial_worker				crypto_del_alg
> padata_put_pd_cnt // sub refcnt
> 						padata_free_shell
> 						padata_put_pd(ps->pd);
> 						// pd is freed
> // loop again, but pd is freed
> // call padata_find_next, UAF
> }
> 
> In the padata_reorder function, when it loops in 'while', if the alg is
> deleted, the refcnt may be decreased to 0 before entering
> 'padata_find_next', which leads to UAF.
> 
> As mentioned in [1], do_serial is supposed to be called with BHs disabled
> and always happen under RCU protection, to address this issue, add
> synchronize_rcu() in 'padata_free_shell' wait for all _do_serial calls
> to finish.
> 
> [1] https://lore.kernel.org/all/20221028160401.cccypv4euxikusiq@parnassus.localdomain/
> [2] https://lore.kernel.org/linux-kernel/jfjz5d7zwbytztackem7ibzalm5lnxldi2eofeiczqmqs2m7o6@fq426cwnjtkm/
> Fixes: b128a3040935 ("padata: allocate workqueue internally")
> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> Signed-off-by: Qu Zicheng <quzicheng@huawei.com>

Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
