Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930CF2BF3F4
	for <linux-crypto@vger.kernel.org>; Wed, 25 Feb 2026 21:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772055241; cv=fail; b=uzlOpeRxpzd5x3KPEnZIoOJpd4VgYM0SkigqOtM3SuTND9FXOi1F5+qIDZRQYAye2bmC/wbvabb1R9rtwSwAZY8gImNqnTEd3AG7m3GbOHT+wXz1z4TURSl670SdWE1aCBdilIntyuoPRJqGH4mAwVOfGXsF4bCrXI2vN4U6dW4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772055241; c=relaxed/simple;
	bh=bR+tw8Hr9Jc9ksapFtcbzVpdW6iUfB74309KJppRXSI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=j2+dY+kBcxpoy7ZM+RbqSJo+w8bvQgEp6hzD/7HpZ3JOWhrEeXuQ2lxiHtGt2nK0z7UfXyXboLTLOdt+OhwoUmiRIoyWa8fqstCFAnG/GhfQAC/hz9Nfi4n9kB9Xhs2X3ifL6FynoK0W0ETnC3aOXI8URP+Z5PWTuTjea1Mac34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=r71li1YT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RsvFD8Y7; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="r71li1YT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RsvFD8Y7"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PIWn9G359637;
	Wed, 25 Feb 2026 21:33:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ipuWvg2NjFzjJIEHk8
	sT25tnrRWziAHIVJwPMp9Bv3Y=; b=r71li1YTqhQvrJ27yXVv0fU+Y26JhQvRSh
	z4fRSCyh6ouEx5yvDMn/viQ9x/N9G7Q+cQl9ExgGbBjFP/qDss+yhWjv+8laXxB3
	ajVAsSgsKo6PgFfCiRDQxEQjhXfnKj4oCJBYQrS2+/ketY/UGooRbooDcdomhFJT
	vr7KiUSxCzKDbUhQYHW3KB2cWISCDVIahlCtpnobfZVXGgNS+nfhJU6KMW4C0bUR
	SNa7u6H683tn0AMz5mLxTt9Nd/AoMSF/amFJmyIdW4enBGJN+IgcD+oWuzG5l7Wn
	iFrHlA6+NEjEWyQn/v/pbrp5tainfsrf79wiGycMXvDk6FvyWdmQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3m7y5t6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 21:33:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PKVoAU012381;
	Wed, 25 Feb 2026 21:33:42 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012071.outbound.protection.outlook.com [40.93.195.71])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35fwh2k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 21:33:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ulp2DHrqZ8QQcRN+SD0/YRZrfwmppC1fpEL+7anPrGC1++H7c2bWkmxm0eJU4HMA1QjZYQGew/W3YwB8AOfYcX4Zq8kA53mCvsRqrndR3ZEDLny/0U3LAhg2bA0RxFMvgvPVj6+A1VYPepPJvjHFZfvFWqM+Nzdi99wT2ZkreUdegpJCkQKigXAV1E/RqTOHdNhD6BxtG6zF+unp1RwPZ3fYexnVeCFbWYKANGJXb6G6jMcjhQ3o98c4b4utPgcbNL+CcoSIOAMQBJ+PJcfPbpGh95Osqql0JjJf5N7ngO2S5FOtpEMuheiptmM+H8HnItkf5ncYC67Futgn3ZLNtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ipuWvg2NjFzjJIEHk8sT25tnrRWziAHIVJwPMp9Bv3Y=;
 b=eyaTbNwXu4kcSbu/iYL7yH2FsDN4iCyC/T/O/LEwvUVZ4vOfmX0oAUmjVqhjiM0Bzj1zqhilhf29iRZxsPCC3K1KIT6CqbeZUMvaaAGoX3GVJ8clDv90v7XQRYChZOBK5+d3bpUZ9BbTunRlWqHVD70zBwCPfdOwu3PDoe0cIFbye+mbjR246Wvqw4xjSG4uCr4mu7JiQxMlk8d4nhYmJk9i3ivqKplVYqsQ4hu1F+OBwC7iRn+NWm8/7I7gnTjmTOdH8E6xabJ7s2pnd0kJCliDXpmQK6mP/wQcIWwBB3XMZ3bBru3OL7HJ51LvNiK0yPgRPaI9jFpAYu2Oh1ojSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipuWvg2NjFzjJIEHk8sT25tnrRWziAHIVJwPMp9Bv3Y=;
 b=RsvFD8Y7UcDx05SzoP/JhUqBcvggHspiaP6SAFdEm8FULdVjx+NLsICwRde/JCiuDcpMmx3SMBLvgapv5NDTd32hjnlje7ADN2RzK6nD85A7YDN5GHQBEufz8lW3G4BQ3Y/f82sanFG6abPtgEEeyZU0OjPF/rroO7H+eNE97t0=
Received: from CY8PR10MB7265.namprd10.prod.outlook.com (2603:10b6:930:79::6)
 by SA6PR10MB8039.namprd10.prod.outlook.com (2603:10b6:806:446::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Wed, 25 Feb
 2026 21:33:38 +0000
Received: from CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::854c:c282:c889:45a2]) by CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::854c:c282:c889:45a2%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 21:33:38 +0000
Date: Wed, 25 Feb 2026 16:33:31 -0500
From: Daniel Jordan <daniel.m.jordan@oracle.com>
To: Chuyi Zhou <zhouchuyi@bytedance.com>
Cc: herbert@gondor.apana.org.au, steffen.klassert@secunet.com,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] padata: Remove cpu online check from cpu add and removal
Message-ID: <aZ9p7Z8XxBFzSvFo@dmjordan-vm.corpdevsubnet.oravirtteamphx.oraclevcn.com>
References: <20260210153922.3435735-1-zhouchuyi@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260210153922.3435735-1-zhouchuyi@bytedance.com>
X-ClientProxiedBy: SJ0PR03CA0370.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::15) To CY8PR10MB7265.namprd10.prod.outlook.com
 (2603:10b6:930:79::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7265:EE_|SA6PR10MB8039:EE_
X-MS-Office365-Filtering-Correlation-Id: febb7663-4690-4763-dda5-08de74b589ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	wRYmwsarDkzEVrvT9sYH+tSC30qd3ipdnu1KY8Uc7t74hbdt8457RdN9XpgeucguJ26vf6Hvwqw4H1tb473FgJd72BYIK3CRcJLkNZSWkIhRXw/uWAQ683uY8rB+6yLy0dQ4NYQORpmta69RbqKGuoCCtFV7IYMkp0JdcUFOqQ2bCpQB/+SXhTerVYQHW7jc9sMt2ZyqCwAogV+tKMp7NpatuFbhfUL1Dfnuem9s5KrJAprzR9A5IvoMQA3B8TJakCpVhz94VTu1569DoRyR/ZvGFRhrHxLIP7AoW53tTHavPQTM6y4VjXFf+zs46QGFuFNdoUOWhOgQcNzx8Sq80V2kOuNN+6wXj1zktq0wOqtoRoLb2HDBqrLz2LIJbYP1LpjpOqqWUSyQU7qz0vEpFogmv/nAIp9M9yNBmlrZIYvsrNGqpgGHWCHp7sgB+xHm7fGEhRMkX5JXO+33Ab6JIeExNDGX7cjF0eIQMpE0BPeBVn18IxO1hTOKZjTux3K3kXz9/IsvS488tNc//SdD5RitmzDvRFCWm1a2k+3A8jilp1odOKcSniOnG3rnpNA3kpUva1b1241pkdpdGesLhvGf5IvXhZ4XbdEqy2nQhDQMT46STE/TXcyg7fHbryXteW7awFsvjU3EHA8sD6iJE7K2pV6wVk8U2YGBYC/xzxrsvpJhtIRSIqSH2tIu2ksET+TQlEuzR/hOiO+mhRNLtXuZy+yvUW+KgDbrJguyT1A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7265.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zMdJZQy49Q+4Gj4Dqvhfmk1Wl5R/brDTJi4+xS3YI8kQzJBpR0DHkzLzpCTK?=
 =?us-ascii?Q?o2lG9QoJtTkkcdVcfWxx0HftNFdQ+1yGqE1VZF6G3IuqLubVefLLHMFRCrEL?=
 =?us-ascii?Q?89U2u0R4Fce586d80Eu7AO5jJ5tDtO6JNUBLFJiU33ALI0O26Cv5WreR5ABt?=
 =?us-ascii?Q?gddHCDADmte/JezhP6cL/zgnjpG7qD8BH++f53wSsL1rcTR1E2afGShSGj+G?=
 =?us-ascii?Q?Rdh6kq59aroUqgyweCcTUBJM4aDUgVignFowpZn77BYdjdcuarswc2JHsxK+?=
 =?us-ascii?Q?VVM5ScVrmRFO48eWT1ZAuNPIglzXWQKGI7gVnE/LBOIDK2FyoK0ItmSqE6Ma?=
 =?us-ascii?Q?DOuP11pl0PiEv/s4JOn7+F1CIiPlHogIYpkejafrpLmGgh9ydjLlDtwO+iVL?=
 =?us-ascii?Q?xNWnyfqQ8TqAFUT8V4+APTC3IgbuA3ZBJ8YrOfhTf0wo9Q2bLkKRmSvy/ysq?=
 =?us-ascii?Q?0Lv/yl9WND+pYhEHGkaLsYEvZuTZvrTIbZPuwWcohySr0OIbc3o4zuTjMgXj?=
 =?us-ascii?Q?Ut2Lw6gyA0mZ9RFcEJaVQ0h2dgDKv3opRjZ56/f5mLSdrOi0RKGyV3SfR3Aa?=
 =?us-ascii?Q?AGeF6vEpgvo1rTDH2lUG1O2MHHVZfNT9D45kEuYeNmAiLpCbWV+XZsSfNBV3?=
 =?us-ascii?Q?Tg/dKUiuKfM/7HHTy+G4dKAh7+wS6bSL/0+K9Hfs/W74syyV+OwQiFcY4ong?=
 =?us-ascii?Q?kAc031XXYk3kNA15vjPWX6brx5BiPcVp9aZ7y6n4sid7zw+kuDR8BepMtQ/1?=
 =?us-ascii?Q?kSvWgiVDu+Tdy6DqMgedEBv3a6Bzpl8Dyj7EMRrmre+3pZE+roA2onCgvJXH?=
 =?us-ascii?Q?5vheXAEDZqoP4KwW1v3oqggVKVo+qFdn6RC28zQNbujkSwngwN6trwXtqYOU?=
 =?us-ascii?Q?1v1Qdoas3KBVPdE/pGhRMU41BxxHLQKpfwbrOVPIhVMdjx0lMlEQ4Mvq5vvk?=
 =?us-ascii?Q?1OS+yHItxpp7MkKwNQ09mB5b3N2KFMWlytYPNle/a2JDTD7q01K7HwaadrK1?=
 =?us-ascii?Q?b9w4UJMXbb7DB9OcvO2ghSCQCEZb/hqL4jptHlFSz+7QkQ2CYIuku2IDqSIJ?=
 =?us-ascii?Q?taQ1ZzuAy9OdO7qIAcdqfMlNas6DADV7JOiC+a62PGe/XOuktFWXviyfIOja?=
 =?us-ascii?Q?aB94E1RkhIg748Y/53CE8nTsnf5VmEvpfhOyg2xEO47SUagR/vGykM+O+lBw?=
 =?us-ascii?Q?moejPita3EWBy0+S5zTMwnQsZcLhqTKFhfUKpFSHcOuF1L2dp4PixhZcpFzQ?=
 =?us-ascii?Q?Foyb1VRDrR+mG1J8CNQDvotXJCFDirAqdcGByzDvW78y6D4C+Y/bbYc9EgYG?=
 =?us-ascii?Q?lEH9pMY+q+bpfqAlWjp0/N2qVKXm56Hnoti+XQEkBvw8J0BBgfjmoewcoSym?=
 =?us-ascii?Q?fdmDPXIMsiyfzvRGlaMTaGwd7PIqI7V5aNwQAW9NOelGSMGlZWAU7Wn2wFNJ?=
 =?us-ascii?Q?VjplwwoqRbk6D0NwQrYXe+dNe/hyHd9VoTizbCs8Iff6UHLQjjGcAkO7jeho?=
 =?us-ascii?Q?irSyxAv6UYdix/tvZT4WGHfvGGsvqHqAMze4LpSdsHPzg22b2xDwy+jf4zNa?=
 =?us-ascii?Q?rCa8gfBNz84P64J2/v1kA+J5ttnuXyls3VMsP3wPSziy1oekzXx/Oozhilcq?=
 =?us-ascii?Q?w+YuujaMIzRI9LHNs5mzeWa6PKOZOAhmssqd61VpFwjuGSABPKP7HGM+JNwQ?=
 =?us-ascii?Q?QeC7dgqATA7YPD4W8yJgUxjV1IKyjEbts4VAlk57ZH3un0uazHO//5zqqYeR?=
 =?us-ascii?Q?SD/hvPxLrAyRsYQYBUHmdanLtw+YN2A=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	G8MASqLdWtqCufUmz7uI8buHu4MRkGekAdwbbdz7tWb6K2JHeqF/VcazsVVpCGGO6Qhg2b2b3P6dXc53QtcMyM5uLUTAgXLe9F9Z5nCg5foZfZYoFMpU7A6sfgmxuNcv49+xkgA4BSfU6OTw99NZssQjH+O6tOTfUJkUO+3I72x7wokl4LgzAHDy76dWaU1Ng9hQZ65aacSz3kzveZyyrgFy1zb5QI4WDA8u4Vwppv2+RpdE9zx/4zRpdSgUtuO9YKg4LpXJPNwBIcaVHwk7kU2i+kMYrBaT3xTUJkIHq5ZFV5ywpM1PIpxW1fODGAy6djRQScojnYwnZ7alEEWHfbu2QDMgfEHoJOAyRuAXaIlVeG1+kBjQNK4qjWDIB8NuDIzHncgfRKFL+tWzM5YBKiITdq1od6IH/KicXKOCO9uqBKMud6BleB/B+T8oe0QEwC2O7KWKU3nHgmXXZweiVCe2GDTQrs8QT2X1VD/A7FNkgegS3B8LtZpPG5IRd2mPWI98d4xmDNU2J/48j4p5BEayb6N9gJvRaDu8Mex0w+wbiNw84DIfCwL9qunxqZT8VKlWaJ5u5yzd7OkndVjPkTCTcTz696hjky+2SUgBUlA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: febb7663-4690-4763-dda5-08de74b589ee
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7265.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 21:33:38.7634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mxXYosQgc+Mr1MezHic22A8mkNlhFHBHi0YVj5meATdg5/Xco5u6EUv3mlx696XNRbfCmTNfwd+WDWbFOVwo8nZ5/PId51S93jk0x5GnHVc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8039
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_03,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2602250206
X-Authority-Analysis: v=2.4 cv=O5U0fR9W c=1 sm=1 tr=0 ts=699f6ab8 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=968KyxNXAAAA:8
 a=yPCof4ZbAAAA:8 a=EkYJzpYldhSUlZTq4YkA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:13810
X-Proofpoint-GUID: pw58W-88zierjqiBgOqDCXu_GNFzzbQU
X-Proofpoint-ORIG-GUID: pw58W-88zierjqiBgOqDCXu_GNFzzbQU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDIwNiBTYWx0ZWRfX+i79UFaRQYDY
 7dgW1k7fuYZziV1Gq9WiZ5/tZyyFYZoGdjJU8vBiwMKhwpuDmfO/cGxhewA5Y3/qr8R99ZS+wmT
 rT5Hk2pUENnsKZvX+neptcQ0fTxRAWox9w5hNFCflaqLonUqgE7HqVJ7OT5Of11mVELruLJ/aNY
 z7sFZW3F7mZZjk5RFXYanY7Q5oHOwOBV+xFQ0Yzx13AOUMCDdzSlN2bbB1+IA7K79tcPp6UDcKD
 85EGHRCT+wJbJekS0zJfNBSUa6VTEV748oFks/gjHCdnHV8FKgrjgJ5AhrH+P42bChoRuIy/c7R
 fPM4IJDHwV990VNC7IX5p366y1tE/fhMoDwF0/ckVmrAMUED3PvFQQJCQoOoMEmokmpoNGIMcPz
 00wafSVULM3+ZZXfoh+HGHkBXsYq70B7yBmJ/eLmHuTXWrTc+tNUV/9LVT5rYiPNcjIpBfLP8PL
 A4KByHNbqdyW8FPKfccNgoMY06lmdemHaHHUosso=

On Tue, Feb 10, 2026 at 11:39:22PM +0800, Chuyi Zhou wrote:
> During the CPU offline process, the dying CPU is cleared from the
> cpu_online_mask in takedown_cpu(). After this step, various CPUHP_*_DEAD
> callbacks are executed to perform cleanup jobs for the dead CPU, so this
> cpu online check in padata_cpu_dead() is unnecessary.
> 
> Similarly, when executing padata_cpu_online() during the
> CPUHP_AP_ONLINE_DYN phase, the CPU has already been set in the
> cpu_online_mask, the action even occurs earlier than the
> CPUHP_AP_ONLINE_IDLE stage.
> 
> Remove this unnecessary cpu online check in __padata_add_cpu() and
> __padata_remove_cpu().
> 
> Signed-off-by: Chuyi Zhou <zhouchuyi@bytedance.com>

Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
