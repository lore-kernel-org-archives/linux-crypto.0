Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9027536828B;
	Thu, 25 Jun 2026 09:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782378192; cv=fail; b=XYq8cLOkCJMR4PU8uj5aaX3qsMp8NHLIcZCdQBXWokXok0Exu6a2yc9VSCgp/mDRyHXGNluX8sA6i0FFaTGVuHgZFp+vqgcnyZjk3RLSSRtSsZKden2OK1pbvZtKtaV+hNmHYNucgBw0uW4n9oj+J2TuUFVNUlWvSXDsq/jvB1Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782378192; c=relaxed/simple;
	bh=icpwfub6aTL9jQBTfS0AwOVz/yveuy/K0Ha/FDhD+r0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DpMQ0k7hVESoxfeFu+F7Sehel3UFyZBmJr0mwIaDPQGd63vkZSccVW/MN9AyAWeXqat0SP2rC1FqsTZNjbHYYryBCzK1vjBDgWWXOsPmAfprHy9G+ih8l+t4+W1FY+UEVbYQ2llproTbddmUj6p4xVeGo6wLEizdSYCsSDApo80=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GXdev0Pk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RXYx4aVh; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GXdev0Pk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RXYx4aVh"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65P5qOsb2527731;
	Thu, 25 Jun 2026 09:02:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=SXoQA9Zg76CGFyU7LuOuxC/PT9V3VBp20Smgf10tMuM=; b=
	GXdev0Pkhs1gN19hgRh5PTpc7wea/x/C5A+GMacDyeTL3T0zbY2I8/bAUvlBddd6
	OwpBsZevayW341amPzCpgyXLja99hEg3R2XU1HjUrcRhiHoJk8Oz2SXuFEuUFoQc
	C4UC66oss3+A0FiPlY2bi8e2asi4krMrJUWAU0vz6Hds9qB4yYQxPitFiL3Dktm/
	tWpd2HAPJwaq4NiFE27/3KlB3v8g/m1GH4IsrFsGBoqQLf9ja9LpSntJFdyCWufb
	YxNcaVuqr1EqY20/eVZC0tcueevun/9ejxFGbspPa+Um+ick4Zn5UK+92U8dehTx
	qqUAluL1gQoiEUz7+werfg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ewh9c6sqb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Jun 2026 09:02:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65P8wNVJ016859;
	Thu, 25 Jun 2026 09:02:35 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012056.outbound.protection.outlook.com [40.107.200.56])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ewhaehukd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Jun 2026 09:02:35 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bl4/78/cv84LKNLwDmmR+WuNX19jiP5eM/Gv6PYbmHQQFVQdGYW22faw0MedaeTtCoSkhiVix9/ke3EKDgpAq4N8GXQGC/FlLFFasSlPRvk1gqt05+6tisA+yc2gF+hsPoU7I1doWuOu8STRSc5tyxC0CLrL+UJek+ZsLHrJWOt849YQLgtVR4wEb9TJ30JijlsDBkBL9rgFrDFfKJhe7qu4SzXe2Mj8Oa0rBndtrmLpMmSjEzjwK4UK+Pv48SvpfdEtGTo7jLr2QqdeLKo35SspTdSa9ec+GObz5HBPvJJOOVCWjZkBvNwoB5z6XEUDNG0qw661LeUlX5gYejpqIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SXoQA9Zg76CGFyU7LuOuxC/PT9V3VBp20Smgf10tMuM=;
 b=keIRVNzaTo/lAPMctGFj1RXfhiy7Rp0TCd51IGwwx7+tzwK3mI79XXF+nwDIpYc3vAlz8fZ1tMQEsdPbntszlq1XTCPET7BZvfY06a0Lv8LwGE0jGn/a/T3G8AsAgwD929v5xc1dtK7/8caLWQ8P13QxlKQ0vVRG4y6qwW6ulw3nZ776gwYOqUJDROLHCoP6sWbV4pxu3QtHbTnkuIwjOEAEaywQkQQCJjOuAmRQg8rcal70dY7kg7tmmRNioB6b8woNd4meMxX7O+egeBJao08aEiaFJhw5sgCxqowkmSISQdi2o6KQS/aTjGP4LTfz52TTghQv55++X7javLEE8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SXoQA9Zg76CGFyU7LuOuxC/PT9V3VBp20Smgf10tMuM=;
 b=RXYx4aVh4C4mCqY/jWPaxWaLT54Q8ZNgV6xzhRXl2M/r/Xtsc0KPwwhoJcR1lxEfCHixcNL/ZQkkyX8ZY7jsNblE7QioDCeAMCzPOpDMLnZ5rhKMktX5fsno9wGkpfCBTM99wun95ryU04yIuM5vqnyRhCjYndyr/ddV1T8sNNI=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by IA3PR10MB8681.namprd10.prod.outlook.com
 (2603:10b6:208:577::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.12; Thu, 25 Jun
 2026 09:02:32 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.21.0159.015; Thu, 25 Jun 2026
 09:02:31 +0000
Message-ID: <965a37dd-f698-46b6-9623-1099a13f7e60@oracle.com>
Date: Thu, 25 Jun 2026 10:02:27 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/21] nvme-auth: common: use crypto library in
 nvme_auth_derive_tls_psk()
To: Eric Biggers <ebiggers@kernel.org>, linux-nvme@lists.infradead.org,
        Chaitanya Kulkarni <kch@nvidia.com>, Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <20260302075959.338638-1-ebiggers@kernel.org>
 <20260302075959.338638-13-ebiggers@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260302075959.338638-13-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0199.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ad::7) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|IA3PR10MB8681:EE_
X-MS-Office365-Filtering-Correlation-Id: 2add81b8-9120-40f2-e8de-08ded2987d55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	pVZBLkrDhFqhxLs13jCxY7eXuq68UisZl3VLQE2q+8mmIOZpCaOVPMz4YWPtWEtxsRdyyXShIIyRTuBZKr8EoHtrwKky3xIxUftTMpKx0KxcYRacnh6UuxH9+vmOj2PmVEbN2QQ2EdGiKiXZh+0mW6WY44ZvgYbul50nJAXe05CV4c6wBcLaymg2TvAncZO0ccsTAPgrmAecEsgR4pEhWPja1SAKfkXPh1nv9OHhCndkBc/KeYXpE6AdeaJqKQERnPqOBQmwTYQYmLJo0LS/9h7cOtBrKYiPEaOdpftQ+/5VDYYyktBGnJuDGPr6ZdwEm+RxyqEKipYsWdBaxe0O8FDmzQvRwF2v8bc/Tf7rmkMcvjlyW092+hlkWPiCO0qGgVB+EUHh5MTf4oHVbrWNEcFcCS2w368O5IO95qs+NNssNbO7mthz1MYdAZJTHilgO4wqkXj1FHTpi7gKH+zLG1YWwxTdGJDb4HAQkUQxxr4wdmZ15XpepdMbhFWa8fPhSqvxYg9tYrR+a89v81XQGRaUv2OOjkCjP7JdPATP4mUqayKbgN2btSM9HcxTw2TsdCJ8nin5a2oKVTdPGu0/NpOVCL6+JeBwMHAYk0LCPDhF9f2dYDbXcPh+wDntqBUBWzB6/Sm3G9T2B5biXVBHIm4ArnBNPMtGTJgAP2KvujQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M0pUS2taMmo0OUhrTUFxQ3NDU083RjBxZUZNNGZoY2dHUERQZCtDeGRXaGVS?=
 =?utf-8?B?bW52OEpmc2lKSHl4SUFtM1NCNVdWWitsai9OZzFaVmJpekJ2ZzBrb3ZkZWdp?=
 =?utf-8?B?N1JyVE1PM25OMHlLOTJKNzlCTjd5QUIxTHo3Mi9JTzVIbFowcTlrRTFGR1Vn?=
 =?utf-8?B?VEZwc1E0NnB1U3ROMU9UeStBeFdqMW9WTHFLb2pDNGwwRFEveHJyY1VRMmF4?=
 =?utf-8?B?aGJuUWdxOUVBYk91VzRGZHVRVC9HeUNWRWpsVW9WelZtaUdCZ3NwMTdjcU04?=
 =?utf-8?B?c1BvRyticXkyRG5oZlErY3ZvRytpWmdOOU5YWWpkSTQrWk9PU0Z2RUF5U29D?=
 =?utf-8?B?Y1luWnUzOVhkRk03SnM1eGpXcnlCbE1icmhvOXNhakMrbm9uZEVkQkduZFN2?=
 =?utf-8?B?NXFFQlcwQS9KRndvaFVCZElRemFxdWxJL2xYRVhSQUQrVXVKQW9qcEcweEpr?=
 =?utf-8?B?eTcvWDlVWndKSXpHenkxWUMyU2xLT3VpcDdQKzBYc1NOZXh0N0c3djVnREZM?=
 =?utf-8?B?dm1DbFdsNDdxN2tmVzBkbjR5MlV6aG52T0FtUmhGdFk0UEZCa1BSdWVramZj?=
 =?utf-8?B?b1k5bXdzUGFqTGFLdFhsUjhydFZOOUFMdHRVVXk3OU1hK2RtVUtQS1ZrNlNE?=
 =?utf-8?B?Yk1FOGNhTHRiMHFsYmMzempZeXZKckZZOFNFUit1T04yazZqb0VuVkpJTk92?=
 =?utf-8?B?R28vNVNQUmhpc2s1bU5qZk5YRVI4c3VFVkhLclZLRzNKOHJTVytKQjhhb2Ez?=
 =?utf-8?B?RDM3S0VMN0hXMVhib25wc2lwY1BsblFaMGJ0ZUM0M1NvVlpVeEpVSys3Q25Y?=
 =?utf-8?B?Mm5lbEZBMVBzK3cwSUliRW4rK0diT29SdUNNakJVK1ZrMWRjNk1KMnVEaU4r?=
 =?utf-8?B?QS9kamVsTVdvR3BWT3lKOUNRMjRxT1pmd1JmWUFxK0QvY1VaWktmVU1LeDlI?=
 =?utf-8?B?b2U5WkZsYlZxUDZ3TFhNYzFJbFZDTS9MNUlzaWx1b0Y2d1FZdlNWcjFXS3Vs?=
 =?utf-8?B?bDFEWkxYMURFTjYxdWJzTVZLbHNxWFFaMk1ObkgvMzk4c1dVU3B1SUhxR2R0?=
 =?utf-8?B?eUpXNzlQa2pONU02MjZ6V3lhK2JyWkRFQmVjbU12SHlZbHk1bnVQcEp4WlY3?=
 =?utf-8?B?UmdLTHZxRUg0WHFSM01ZV050QXZhcUlnZlZVT2ovYWl2aDFzSnNFRHNlRmUy?=
 =?utf-8?B?SVFmVit1aG1uNkdIT2ZkNlBUaVdZTVlWblhYM1IwTGg2Zm84TTBDMjdVeXVD?=
 =?utf-8?B?dzhJMHFleVh4S0FSem9FNXA4VnQrN0tuSEl2dS9IMkhHUm5laGVzcFFMcGVo?=
 =?utf-8?B?MjVKbkc4cktXcjlSUE80UDdmYlJyQlc3MEVleUNmdXZlaVFOMXNkVFdJQkdF?=
 =?utf-8?B?amJ3a2RkUWszV21IRUpmbTJHU3M0UzNIWWJhQ2hSL3ZadlNOTFFqSVNFWkI4?=
 =?utf-8?B?cWhweUNwSUE0NVJsUGI3Zy9aVjZ6cVRMdG1sSlNyd2VYTG5WZEI2SEFpSStB?=
 =?utf-8?B?Sk9tNHAxWmQ4QlhubUF1MDRDQXBXTnU2MitsNkp4Q2lUa0ltY3grb25ycEdh?=
 =?utf-8?B?S2k2Rm1IeENRdnNNMExBNGphekJxVzFIZTBXZzVrMy9mR2Ftdld0eHBxUHhn?=
 =?utf-8?B?R0lIS0dZdWF2WXdoams2a1Z6UE55SnBBMithY3lLR25Hcmh3bm9SRnlySjNP?=
 =?utf-8?B?ZlNZU0Vxa2h3VDRVd3JES3c4OW9aWHM1OUNCSmVNbGlNcmJtMnVwYWJDSjNT?=
 =?utf-8?B?d0MrYytYdTArbE9pRThjR0hEZUxjRDNaQVJ6d1JnZXpVU1EwU2Q0SERNUDY1?=
 =?utf-8?B?QmszZVpyWFdUMFptOXpPa2E4VldGZ0s5SkwzMmJsd1JrczJ1Vm5wbmRsQkhs?=
 =?utf-8?B?bXYwSGMvaThlOEM1dllzb2lSOUZtY3pQaHc2cnZTM0lDSzUzNjNEZHR5MWJh?=
 =?utf-8?B?cWQzaklrVjFmNm93VUVFY1N0ZjJscHgrTnhaT3lvZ0xoeVRmMTdlZHBnQ0ow?=
 =?utf-8?B?WldDS3JTRXlCRVJDTkxEZGhqTVdVOGI5bXJ5MjdpZ01GeDRCWEhLN1JMUTJI?=
 =?utf-8?B?SzhqdXNSTzI0UEExLzVNSGdZaEFHNHE1a0JsVmI1Y3pIVXRINlNWYjhlZ0xj?=
 =?utf-8?B?VjBWL3NQODhhM2RDVk9mZ0crN1dxSjQ2UXVrd0NzMEZscmRZeWlScnJxTVZT?=
 =?utf-8?B?N3lXd0RhVU9zSGR2REkzOFljRTlIcTI2dndSN0tqQUUxTnhFc09QcS94dWh5?=
 =?utf-8?B?NGJsQTJFandZVzJFTnBnUFdpK3V0NEliUGZHVlgwaHRTZnZXS3JTdU5BYVRy?=
 =?utf-8?B?blgzV29qR2tCb09vUFYzN1J3NEdiWWJOSXF3bHlybDJpZXI4TE5pUT09?=
X-Exchange-RoutingPolicyChecked:
	ZOhUKuYZNWjCAWSbtDqvubeDc6URjeBWR2tJc8EYUE1wPZTWHBs+ganOoC0QXE9zp0nYmDZ8z7LdLx8+PFYyNUvTXbBgDgmvoS1AGJeu6bjrhWBW4VwkaDBmt0mKPJb9yhulEqQPZ07XCFEIYgOtwvCj2hb7yxTT6hacIVUaKjmMJ7pVDl+8Hxu6SoqLjaJ5qsVeGOh4KF74lZeg2bCpQxZDEoAYRhmiy83ZwDLOPo2EQOnPLAD9yxIDQB0b5Vt4eehzSTMs0sXoGdt5TXIp3rYZmskY098UwRcPqJdKK9GyiJErkkaQa6mt5lPNElxM2/linod00NEVF50t+IrHUw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HV36jSJMMBywAynAYsdmkvgihi328w2COKc1s0laviomwng3LUvi8gzX/6kK9XQTpVJPJaHpuUePAJXmp1Kxmy/R2+yzNzTRewt7msuSl9IhEzRC5eDwcJPmws4Yf2Sqm01JcrvJPOAJqdpc0ft5BadSM4QU73OBUYg5VootFgRIgeU3NSnx3HaqB3CX0hud5/E3XIHuaJxey7+3i8jelIyrsevup3N8NQ/mtJ/wKEWQergA/AKZ0ag9hHf0tJzgcuULPpjrvX2znFtFddInt4kGyVLUkp8kSjp9m8D74LDWLrIIVt4l/V5nw7DPRBH2gYyxXmyc4NxB6by0OyQ1tVJqmIJe4OuhFsMGzdUjXFmWUflZ8c5fNQmoIbtV9IUrApeG0lcrjg8i/+szYuixp60cp+oooshaQ8Q7om0PKEgUePgPpW/mi/nZK8rjZxGSuvmJz9hroIN2ZkPJDrXkrlIQnUA8OxEmOyWaeBpJ9eXjKlnA/MO4eWdM0fVWUUo857cIMZSoCyn+ZwsOZ/36584I1/s+SuHBsgCyGuBKhJCOZkxKQsLytPxrIMVTpDAkjA+st0C56bzalIPG9NwB5VQIy7azTFM2eo5G5uORgQw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2add81b8-9120-40f2-e8de-08ded2987d55
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2026 09:02:31.7501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fgrr2jbhmQuYHtwOXeGpY7+5a9g8m9M97llvvAg1tAkvTgIKGZR/v6rOhgZnD5hk6aYpNVT46JFLHpv0gGR0wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8681
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-25_01,2026-06-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 phishscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2606250077
X-Proofpoint-GUID: TaVVzw08-mjgf_kNpZ2z2KRZ3SV36jCH
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI1MDA3NyBTYWx0ZWRfXz5NGKM4eVCVK
 WcI3XaBgiX1pXWwgw58Z2GmNNr+MUxtrfXJdLoT7D0bcUSaLPudB9+dt2eJQ4G/SfoCoF6aTW8D
 nip7BpaisaVPjczNQ++SLszvHY+X4a6/WlaG3OWOT9BKHed3DHgY
X-Proofpoint-ORIG-GUID: TaVVzw08-mjgf_kNpZ2z2KRZ3SV36jCH
X-Authority-Analysis: v=2.4 cv=Rd+gzVtv c=1 sm=1 tr=0 ts=6a3ceeac cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=zl8U2xEmWc79uJA1gpwA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI1MDA3NyBTYWx0ZWRfX6a5EmjFBbmN3
 2wn6A6cYXCVDEBPLEaKLnZfEO/1isXIqMk4GiRL2oV1x8EqDXgwcvIWxYloL5KHrRcZu1QrpZSl
 tJ8MaXDzsw5+lkTTZIobv0C2Zj72CZjLttGjkoUdaHuazcz8tBx7vCUGB7Z/2l6DrOLn1Nym+dK
 Miuh7jr24lNzg7oafTP9s2YvGnCZyDsuobDNijlZoYwxGJsZ1FsVQixDF8hgOK3LdqdC63FbRBx
 0EAQH5DXCxZOYDb50HzH1KIKy1lZHy1t/RFNa/171aGZVkUKplaQFh1FBWCOSQfr7Z8eY3bls2F
 pnctSfqpfZ9t842u1+rGeAjl0JYFRJ4oGcQj1WUQl7b31GgTDOx9VdNSvqTsOpYDmsxywmZH0UX
 Xk+sS15f9N4klr2YFYW/L9sJUGaS5QMvYxd4oePlKhE9GFXuQT+vxDziz9w+433KPsfd9TeKKOb
 RW1NzkWXoDLzUZ8wvuQ==

On 02/03/2026 07:59, Eric Biggers wrote:
>   int nvme_auth_derive_tls_psk(int hmac_id, const u8 *psk, size_t psk_len,
>   			     const char *psk_digest, u8 **ret_psk)
>   {
> -	struct crypto_shash *hmac_tfm;
> -	const char *hmac_name;
> -	const char *label = "nvme-tls-psk";
>   	static const u8 default_salt[NVME_AUTH_MAX_DIGEST_SIZE];
> -	size_t prk_len;
> -	const char *ctx;
> -	u8 *prk, *tls_key;
> +	static const char label[] = "tls13 nvme-tls-psk";
> +	const size_t label_len = sizeof(label) - 1;
> +	u8 prk[NVME_AUTH_MAX_DIGEST_SIZE];
> +	size_t hash_len, ctx_len;
> +	u8 *hmac_data = NULL, *tls_key;
> +	size_t i;
>   	int ret;
>   
> -	hmac_name = nvme_auth_hmac_name(hmac_id);
> -	if (!hmac_name) {
> +	hash_len = nvme_auth_hmac_hash_len(hmac_id);
> +	if (hash_len == 0) {
>   		pr_warn("%s: invalid hash algorithm %d\n",

...

> +	i = 0;
> +	hmac_data[i++] = hash_len >> 8;
> +	hmac_data[i++] = hash_len;
> +
> +	/* label */
> +	static_assert(label_len <= 255);

JFYI, this is generating a C=1 warning for me:

   CHECK   drivers/nvme/common/auth.c
drivers/nvme/common/auth.c:746:9: error: bad constant expression

The following fixes/avoids it:

/* label */
-       static_assert(label_len <= 255);
+       static_assert(sizeof(label) - 1 <= 255);

Even though label_len is declared as const, label_len <= 255 is not a 
constant expression.
