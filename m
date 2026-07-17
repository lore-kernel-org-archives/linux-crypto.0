Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773FA384235;
	Fri, 17 Jul 2026 20:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784320504; cv=fail; b=WFue6XpOfxpptfr+oyhWS6yQ8NpAnGM4Xc3sYURUgXqVS8vj2wcIrqd7OJeso+/QkCLOHG9bHxPh6Rirci/NXJfK3MJwed7T5an16f5F+13cp396GyaQ6Fxcpjfb/ZOEBn7lh1tofrNVtG1NQnfLNqqPnMah0A5G5Wnw2AvLBAg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784320504; c=relaxed/simple;
	bh=gd2vllg+8BaQhnn/HzXprP9/izj7gv//XyFYR9oebkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iFFif9Rxn7wpLu36R9pihb4DW6NSiKsYeDOvc55p1rM1fh4D+CSu5Bf6WG6Y6MQnWqPIIC+tnUoJdTUxb0Z13CcgIgVOIv2EsgYvp2FcQre83A7ch2eNoaMGlZWnE7ZODhJOIR1H0so6k/9WxyOiuQHfloTNHWb0PTkQL2v/S1g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=orC9sHLl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZUtK6KsG; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="orC9sHLl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZUtK6KsG"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HKN0IU3956119;
	Fri, 17 Jul 2026 20:34:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=xpJRq8wPCrq5Ybszvl
	cHbAuijncHSzQZ2IQDaIFnfDY=; b=orC9sHLlFix/NUoFsmwzSmjZndKZGSugPN
	1U7HAARwpUaDYMt4hFAE4BMZiEZD5ya1fTqq6Wcm9CxeRe9lqONsxNGn6Ali8vUk
	sIjSnjgIeC9vH1+Ja9taUZMVTWQHdBIKNDaBfES1YBK9jE+ZW6xQB0tGwrXhph9j
	Zp3xbIFhB+6asHsNlOTB0/sAdj+3JORCGtmeLrpwJ7Hk9BcMTMIa+kNJ3q9V0wBX
	va57br8Y0OwGqxIdJBa2UtP4Pyquhuxsd1Xq1r9lR4zf1xfIfC9zB3UzJdONI7t7
	FfXEuZ2uonNpRI+0ks4wyghYelndZE8lwWoma+eneexB5512B6nA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbepnb1u0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jul 2026 20:34:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66HKXYsl030838;
	Fri, 17 Jul 2026 20:34:56 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012018.outbound.protection.outlook.com [52.101.53.18])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9ng9ft-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 17 Jul 2026 20:34:56 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sszsw3AWsrMj9ZwB2mTc1x1GPAr8FdhS5b8IGbjUbIdabstmIGPFwsVclJnECmnjNBpPCrPcRiuRDmh+t5mFqlRrzAi8ag5oDXaRkiHqSr6KyOiTNdcaA0WPVK7/89rNYaGBOtqIXyJh/5QlljtZhHLfiLrSYoexRYpKivfbPsY0kUYcC19nf/9OPLTZjJjkUUAqv5wP9F7lnbEpsu0FODdxPg18BUFXhxR4vdhSWcY2XQ1/eYhrpViufq79RJGxslWoFdydroPqD6S8hIakowzzTFcwidrnI/J5s4A8vV/YsfuYJrdaUl28SGzTVdg9ZFikaLxbDQNZvnSk7ojD9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xpJRq8wPCrq5YbszvlcHbAuijncHSzQZ2IQDaIFnfDY=;
 b=ryejfVF3AoyNcpRnZnBHl/FcrmhqYZ1xYhCbyOzcib5pTeoA3dw1Y7x91HU+IH84GUH1dvMx3vjS+1LxmHJzZrynNAnoioIJi5mnmjztJdYItzGYChhsIF7W0Z5Za3A+TZI4sWM9M+Nk6trA0HhRbN+sUPvZd3xcGdqiL97C5OsqtiHsHI6U9v/0QitTOPmAKMpHZ6syOOBnqUCna983Y67hmpk9xc6XSWvuZCcRR2n0POlwNlfaYggipHeIkP1BjW9xtBdFSTPHHdndME6YgCLml858k4dHKQ++6rY/PO8Qd837QS36Gn+w+N1KQ8S7UCjsB0BLicixkZ1h4KQRoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xpJRq8wPCrq5YbszvlcHbAuijncHSzQZ2IQDaIFnfDY=;
 b=ZUtK6KsGPBds1cHexwoXZoHoeD2iCkVj32ft3IetBeTRZH5wsjvL0IKkU79NUSQhhpvyBRQWlPcuTMQzrYuAtYzQ0LPegR8Xttr2NTNvK49evP75knbPEf4kSukZeBRyIOqoeqvSPyP+t8fkEEgtenXMfcQPC1iwVXR26mIJ0Es=
Received: from CY8PR10MB7265.namprd10.prod.outlook.com (2603:10b6:930:79::6)
 by PH7PR10MB6649.namprd10.prod.outlook.com (2603:10b6:510:208::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Fri, 17 Jul
 2026 20:34:52 +0000
Received: from CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::854c:c282:c889:45a2]) by CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::854c:c282:c889:45a2%3]) with mapi id 15.21.0223.008; Fri, 17 Jul 2026
 20:34:52 +0000
Date: Fri, 17 Jul 2026 16:34:49 -0400
From: Daniel Jordan <daniel.m.jordan@oracle.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 1/2] padata: Mark remaining code as __init and data as
 __initdata
Message-ID: <alqRlctkmnR_3_Xd@dmjordan-vm1.corpdevsubnet.oravirtteamphx.oraclevcn.com>
References: <20260717171831.27994-1-ebiggers@kernel.org>
 <20260717171831.27994-2-ebiggers@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717171831.27994-2-ebiggers@kernel.org>
X-ClientProxiedBy: SJ0PR03CA0179.namprd03.prod.outlook.com
 (2603:10b6:a03:338::34) To CY8PR10MB7265.namprd10.prod.outlook.com
 (2603:10b6:930:79::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7265:EE_|PH7PR10MB6649:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e57671f-3878-4b81-25f4-08dee442daa3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|4143699003|22082099003|56012099006|18002099003|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	qhT8bTSnbjPhzNLaepXZPJBPxaXu9jZsHPuUCwQEVFDM61gchr56M2VP4k6l12ZxDsmHyrgAWZBVrpUfZ9Er+FZTxPPOhK0RZP0lZwnh+IVWtxJMjiYDE/hay6DTxBK9Ye+uUDpf/ntauNlUowF1cfPUxzvKipreVMoqbiuLyFXdvkviO7FMQn3FY3dw2fpfgF/ZOW1IWLnLBDBg4EQXBY9P2tQ3ioBNgrZgSoEoxn6uJv503zfssZHn0HwC2UTMWVVjA6cMqd6lm9qsxpnbDJZqliSOe/0yYE5pvdoW7JQIb73u4vRGFmbhAUzwGL+y2k4gJOoXEUEWyCMiBp4U9s/zRx6UIR7Gj92riQHjAkLp9/vvVar4MZyP5tKxLIscYbQmFnBJTFGJGhIA4EUkId+7j4j097XRnorqJNh34ozk8hdaLLO5EE7Ze9I8ogfOobYuSBZPGSkkvhlDenPdZkC1/Oy7fesIclC7RPFtg4ZrcbhUI4ZAPvoVfynojxJaaXWrlEC8/pzPkAMQlP+JK6YF8d9S1TcyOlMgr1E6Ao+clndsgXwwrPDP9uQJszd90BCBHQO3TbUpta/3uny65B6e95QzEfqV/39JqnyjYqO7JPvc9nh8xoadovHdpgZHAnUOHoKxVoy7JA2Ey2GkDzJeHmq7VS48hw6ohRXgryo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7265.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(4143699003)(22082099003)(56012099006)(18002099003)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T5o6h6tDJNiOf6pUOjOP2gQd3cL761YTafRX56ZEVUY5tTZbkIaG+qgEVz6L?=
 =?us-ascii?Q?thibbaou7RYCs5cXP0seSckGEqEwUK9NIIQDZQgM6AiH8CwCThgIOQtGepOF?=
 =?us-ascii?Q?w9DQbvYLT/Ol4S4WijpekNqJs/Xfft+njJ/G5x+dnSiMdqt0QBShKBA68jCW?=
 =?us-ascii?Q?yjsazFedjmlc1+t19QLYnALccocHQZ4XHERja5MyLy4pcHSdLNtoMMlzkMU5?=
 =?us-ascii?Q?leMLkc/2eIjKQAbFbr3Z9HfSBaoTr5Wv+8QZDM2/p12t7GFo6E/jzCJEFYid?=
 =?us-ascii?Q?iY4aOArbYajyhHglf5K6AeTQrT39D7zsMIQ8bhTv0o76+Qu+H0vTIjch5e1h?=
 =?us-ascii?Q?i0gKsK3zbUc+xo776RcrCqDvs3rf+pXxuc6T5Z6mMvdOs8iIkWAK7sLAZer9?=
 =?us-ascii?Q?L84+fggn5YvaZOO6CHVSlzq5kleCul0qsE3QxxEMKqnvKMgvbsv6R5aoXmSF?=
 =?us-ascii?Q?Sj9vkORhK7+H8QaraJqDOc6PzLw9LD0Q59xJsgu5UNDYJXLtAWcpIUO6aV1F?=
 =?us-ascii?Q?2JiwdG38QUPHwCcXXi1p2zi5JEYNs9oRYpKFl4uvyeT3RoXbsiw3qNWsgdHz?=
 =?us-ascii?Q?Lsx9T/rPAqhx0s5sOniX5D3bOYsbGf/TZUBqE0NaCBs5IeVw/dFpueSCCZVq?=
 =?us-ascii?Q?K/lTRogNkZDfOdBAKYccXza3N074dLESU33BqApPvvFQPFLXZuw0I4vL91KW?=
 =?us-ascii?Q?hpERwO8IqVIcFfDUB97WV99xvAczNX6hY3XE1EdU2Mhda/So3hNkcRvBFLz4?=
 =?us-ascii?Q?VtLJlecb05F1wfWK1hi4wZRPGiTvPTtK/rS/A9lsZdhvj2noLIviQ05PVD2e?=
 =?us-ascii?Q?revtFzY5oFJaZA+pTvQDRsD1oSeBRlLxgl476ouKPsFVclo0MjNYMCIdPRGk?=
 =?us-ascii?Q?bkChhNeglYT25rY6uFMKOz2jRcVfVeRljf2RAf23W/BNcUuLqkxGIl3e3bqi?=
 =?us-ascii?Q?huopQ6E4PSSu/w1Iw3ZDw4Sn74Q+PbfvMQg366BA3q9Q6m6eji2+CTC55g5H?=
 =?us-ascii?Q?3tBOx7rQ0Qug+nquN1nDsXTyO4IljiWxThAPnaDxFDpCGWlLycaCyljyc8cc?=
 =?us-ascii?Q?TNqLfOFNGK9C3+iZVfhe9J7CrWjLlQB2R8UXxDM2th4otIYUa9se8bbIQrXe?=
 =?us-ascii?Q?XT1rt0tuBdLMqxG702Ol10RGne1ahVjMxEYRZn+UMP8LiPYwPSBVp9DVsx5j?=
 =?us-ascii?Q?0GaZz0WnQBpf33ajbPObgMJAlTTkyhTfDmv04r69dVsYWtizfHsw1Xv6MHFM?=
 =?us-ascii?Q?7IInEZuKpa3hmGKJBnAGrpBYevhVKND5QB97ixgtlkymhYyUyTGKrShGz5bh?=
 =?us-ascii?Q?aZr64n6pmJbdU7Zvyy0NavN7Bm0Wk9VtUiA50XflpxqPzeQE8nI9M77YG+ST?=
 =?us-ascii?Q?M8TrLAU6s2zaLlik5nLndcsDSlWxs412/9DRt7oalYeRKWbi90EI5NvcUpUS?=
 =?us-ascii?Q?qx2DC9PZ7sgGTC0ywCROwSyz0l/je5L75qxXtLlWectCzujvuWbHV3PB0l81?=
 =?us-ascii?Q?ZUFwobqR4Evtf4dO5tVC/HZVCD5NzCdGTpPaPa9cz1eQ0EnQuSiUKc+GrDfA?=
 =?us-ascii?Q?ugqcTPtxA0fz9zd5c/QKQKqQ2lZNsP5o0wONmJPmE9M7LpY9ZD+gVU6CIaRx?=
 =?us-ascii?Q?2STaxchlQDExgZ5RheRI4VGYuxkRD4bdX1ypG+uPZrg1kHf91VQdP2FuVK12?=
 =?us-ascii?Q?0aejcjiv+SOix3k2ljyfLQlq0Nbzeukir70wInGP6bwVHlAoqubqQIftLHGo?=
 =?us-ascii?Q?AK0KpIPHqGXErR6tvDSCStN7yZCryOQ=3D?=
X-Exchange-RoutingPolicyChecked:
	FQeTdECX77U7HuEQR6wVlckw+r37arLvBtnzPewi8x9i0wwwvBJSah3583HXoRv7d8hEytgr/YeQ7/Q9GHhgZhG2Zo0d63X/6UPnZDhPcZUbHNVr3MBqMS+28fT3EJroBhE42FPTrox3BfRk0gpTONaKJPBRiMyTXdK+l/0wSeuYaAGCpNtO8EUSyu4wZczFMOLsPDQOZzMl+FEyCQo6h11Zee+RGfMTj/nf1Eys8d8PKbSVSRTL9fQpCAYYbQoykpStIbLTBXwzuU001uqMh5quZq7Vi7kUH+G1j/O2DY3HvsUMQtLFiJZlj5dKU2JT7okJBNq4TN+CkiHUHp/U/w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2V14TBUurio/SMzHmUGJIKk4mErgg2uTMUdG0wGB/UKILOhMwI3GBKC8qM60v3zuNZCIwUTChy2gjZ89K0NN+9GF0IGYARfneaa+sEpPLSjrtsWdggkMQ06RgNkuwAicCqJz/YJC6bmin4QN84IjXGquFt7GHRUvkQC+5Z6Drq6cDsE/5PWpuyYd+keqcc+uqG8n7KOpmnRf+V5KFsHQeInERsbQk93vDAdiOmFD2edRKPV59Xy/y4ZM0Y5fMxFTToLFfKfU17AinJKLYX61CUgkSf3qjOMK9BbUpu74mtc7G4gysmCezjW7rMMaMfNkrYTc+L/FFigQ6u1SueEOT4P2bE2xmR676k30POCvSmKbH1sxHmXg/awJibo7PxQi86nsQzPCNwx9cAeFIxxge1HPRPOjdPpW5uYEFSPB4sLiNRTVQCov0bp57EmnWs4A40cjBXD3xehd+4Akl1DyIZcNgXXvWZT1oEwMdFadG5oRZDBTV2V33s5kFO/nlyO8kdpV32lNAHSB3sw43hVihOIsMkkraaPglIYPbDiknlqqJGcEhSoNdXqpOqLKtRAJniOxwo2889Mny4wvDTC6jWNP0B/QKI/BhFRoAWh7s1M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e57671f-3878-4b81-25f4-08dee442daa3
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7265.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 20:34:52.1415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IjuI+8b5oLKuF01QejgY9NlI8Mn7wELdtINyJLjHcIxSGtFppuUCUrF/nol3+RZkSRJROI4J7XSfqpSwm6FJ0P3uvax6JLZCd3eyblMbGFY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6649
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_06,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607170211
X-Proofpoint-GUID: ZK5u48s8dD8G3VPwu1zTgKR8-c6rKE_F
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDIxMSBTYWx0ZWRfX08Dk6grf5hLr
 06ofk+yBrRoxjWA87sKJiK+JMBtB+0WC9Qj8AO43j2eECQzIuZyrivmTyXck7v90GVFZfahaKt5
 JnNLbBJqBNMO8VqvoN9KBonlsXHFMWw/eGoJBFmdwZ9JH7FkSTlINwfwusKs6W8Y0eVgNLhI6wZ
 eAMWShG2KfWUazLt1XXLmnUL42vipOMdWCnCHGWwsYVDQvEf36fTjE32eliMa8/9jDDOysn9AYG
 tKZ4Jw9nQjayDobNLI+ExYjKk5i1Om644yLRyip1NEijzq9YZkbdws/fUOCgTb3TDjgqToYw3/9
 lovumac7yApbC1eXkOUS6/6xLbTBLipj9sNpIxnrK0Klggl7zY3/q4uiiWMAGvXFZOn1rRQL5Zf
 efZ4sWgpORPA2y1K9r9fkeGl7/JIqpK3Yf8I6AErjQnZv73Ngf7r0TQftHnQtHKjwjacU+7om6Z
 iZ3Ntw6M75Nco1eQeGLoCtgceI+2c6limdn0WPs0=
X-Authority-Analysis: v=2.4 cv=bJom5v+Z c=1 sm=1 tr=0 ts=6a5a91f1 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=GuVlPslG535Nj8KBPMcA:9 a=CjuIK1q_8ugA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12218
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDIxMSBTYWx0ZWRfX0LpQeZE80Zxl
 /4IY8YBwfPt19MjIaSr6SF3JLH4D1eepVOKzHfzB58T2n8rl8ewsleE4zGTxEpkN0dIvzheWI/6
 zXDBsa0q3b0XsgQSpCUZFrQeRr8J7p464d/xd6AAvjp5KtWMrE7b
X-Proofpoint-ORIG-GUID: ZK5u48s8dD8G3VPwu1zTgKR8-c6rKE_F

On Fri, Jul 17, 2026 at 10:18:30AM -0700, Eric Biggers wrote:
> Since the serialized job support was removed from padata, the remaining
> code is used only by the multithreaded job support, whose public
> functions are __init.
> 
> Therefore, also mark the internal functions as __init and the internal
> data as __initdata.
> 
> This makes them be discarded after the kernel boots.  It also eliminates
> the need to mark padata_work_init() as __ref.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
