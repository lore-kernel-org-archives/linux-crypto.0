Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7565418A6C0;
	Tue,  7 Jan 2025 19:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736276545; cv=fail; b=EpXmM2sKfjYDldZJe0IoZEvTk6oFY2jwrFn92zetie6jSdUJXs455oH8usj5GFeMwWBNzLdSy3aDLCGBPNKLsLV0+IqBR7qmUkUPNOUQcutPvUJz9uS558dV09gqcYCp6ogZScl/Vyy0xL59Us6Zfz4ocR7M+gAqz8xVRKskQc8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736276545; c=relaxed/simple;
	bh=Lb3PcWySVEYd/7zl+DwRNt/9gzKJMhZSqtH3h60gPX0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VnfELCdcuzljt2SJDTLYo1FDOiULA0wg8gd2bh4Z7HHUSghra4JZPlLe3ITfq19yUwXtQd0lrJNdBL8+Z1swp2K+6680vg+qLTNJqO8emO03exgwpall7gHD597peXqvaMrbAoBHRQ9dI7CKdPu1UXkKFqg5zRIckWTkdnLaKUg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Qr3WYuhT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NTWcGyxv; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Qr3WYuhT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NTWcGyxv"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 507HMoum008126;
	Tue, 7 Jan 2025 19:02:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=JLkg64McYK0d3zHFcK
	9a+gZio9zvbJFuiHckqAWPCJE=; b=Qr3WYuhTlQ+xP1ehuKk147FU3u9fUVDeBP
	0OluKFalMbqShxEkmER64/EHmPFs6aytK+HbGaeSRQA+qQHxBRZPTa0elNt94Hkd
	FOlIyPvZu/axxb0noE5IbhIVhXypQmATRNL6+R5IbJYIr36/hwoF876p9HS5/itG
	4yTbycwnQZcIBUg5LUc7M+gPGifpXgdhaW3B11zJvNPtdP/OD/EcBX6p4gIWl/11
	rZ5vSdy6cj6QCBQBT+PC7l69zgTgHOMrvn7PGimzSEAr8Wu5H/x5QN9j1UyBaodZ
	W6WOdS02XX2ZKSjSF9JvaWZhsXmhOjDHJiNYeGdOB74iXwMLefkw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xus2df7r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Jan 2025 19:02:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 507HGpi2026242;
	Tue, 7 Jan 2025 19:02:16 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xue946jg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Jan 2025 19:02:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=grUgUGsk4Zd2Or+kjNsdFqGb6SYQYzr9Z03jNsSqVgwKnZZhsV3K39grZ/0CM3ameatlDOEW5SDMruASJbis5024+R9npvuYRoqqRw3u/tGfsCIdlVcKZTM0PsiT1tPiRpTKUODpC5vs/ci3UiVTrxG0u7JANQu9NAhwwoHCA+X+yVI8BKGHe/26NeTSnP31eMoMXvqIvSIA2YpbEOipaBsY9N6kD4rcNI83S+bLevUh9EadAogs5jb8bz6TXd9txwQdiUBtzFMgg9t+ABlHdgqy2UhjcIJeuuUSfOIUhqVUlq0jUhDGjATjmft4OADpXwuxW2FndF01AR9ZVym1gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JLkg64McYK0d3zHFcK9a+gZio9zvbJFuiHckqAWPCJE=;
 b=kS/yMhJVD2izmWf3d4eVmckfD5Cwb9rHAv1L/geXPliYhrEdfTJizybPTTAb+mhUJSWEAGeDQvRGqMHZUozkaBTH+e5L2vI4J52HcggQq6C5jCHgGr/RZzKrr2QVTXA3HU5SlZ00/GCwI+87bZ4nz/8yiheaorwmAy6besYb/zHg+SBXjyMxGg8FSyusx1fA2EJva8zEzJsao8RClzFvPCaVbPDeJ2xR6nElUuu0ubUb5Y3r8xIJlAqkWo9pXFsIqjx2+eSGOkQiDCq1bxzYg1gkzNGaELe++X64yJZk7fDSHsY0yy1Tj3MXP3Il4Uv0dlHB25QkOMLpXQqzKKSmbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JLkg64McYK0d3zHFcK9a+gZio9zvbJFuiHckqAWPCJE=;
 b=NTWcGyxvcbjzM/9MfT9e24Hs/L2SNHKvSndESeLie0hUuHY1FLVcXqrC2PZwt8QgwgaVn6uW3KBocTadactdNzwgS7bRAoLGRH61CuKSB4U0UGewNSRXPBl8pcycI5y4o3x0jUu++BMKbi5CyUKhlcSUEipZIZJc+TJ828nv+48=
Received: from DS0PR10MB7270.namprd10.prod.outlook.com (2603:10b6:8:f4::13) by
 IA3PR10MB8042.namprd10.prod.outlook.com (2603:10b6:208:50c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.18; Tue, 7 Jan
 2025 19:02:10 +0000
Received: from DS0PR10MB7270.namprd10.prod.outlook.com
 ([fe80::1858:f1f7:dcfc:a96b]) by DS0PR10MB7270.namprd10.prod.outlook.com
 ([fe80::1858:f1f7:dcfc:a96b%3]) with mapi id 15.20.8335.010; Tue, 7 Jan 2025
 19:02:09 +0000
Date: Tue, 7 Jan 2025 14:02:06 -0500
From: Daniel Jordan <daniel.m.jordan@oracle.com>
To: Yury Norov <yury.norov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH 08/14] padata: switch padata_find_next() to using
 cpumask_next_wrap()
Message-ID: <flqpev4l6babygi3qwh23pahjvawpm2i5xdff6xh3k6v4qhqtm@uxsdrs62usju>
References: <20241228184949.31582-1-yury.norov@gmail.com>
 <20241228184949.31582-9-yury.norov@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241228184949.31582-9-yury.norov@gmail.com>
X-ClientProxiedBy: BL1P223CA0005.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::10) To DS0PR10MB7270.namprd10.prod.outlook.com
 (2603:10b6:8:f4::13)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7270:EE_|IA3PR10MB8042:EE_
X-MS-Office365-Filtering-Correlation-Id: 762de52a-7ecc-4036-11cb-08dd2f4dc942
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?W8nt4rm9sbgVzWDhLBt9LrKuUsT7sYsqQ4MoJfPTIBKq6XKsRJc99sHp8411?=
 =?us-ascii?Q?5wAdCh/ECJR9zDeRfW1P+zIuj8gQ0Jq5HYPEbW3WfihgwXdXU0GBF/9mMPOS?=
 =?us-ascii?Q?4XaXDsKUHCfh9W+W5pcz8iVv+4jMZIMQicVG6/dPrh56/OsTQ8o41UlUWz1i?=
 =?us-ascii?Q?RTW7ABLHqqYfBNV1qbzdL6/ICJK+27QHG9Z9wVAIkrMFAqqaW1u+wUQ6VZtA?=
 =?us-ascii?Q?qJHIs+nHy4MeL633DNYxlbPMGY+GytemdSJWy+mLr6qqFeDyMWulx1cSRGgt?=
 =?us-ascii?Q?PEvp+uPwgOAF/HQRZfa+Gxy3MbztJfCPgG4jXYWqVHMZPtyb/17sNZ1yFhUE?=
 =?us-ascii?Q?vWCBCSptd+lkGcv8nRYVjXa6DcFdX6KcC5dhMGQGxVpi7Ai2XVKzRPSTEx/w?=
 =?us-ascii?Q?eWbu+uWnfDnBXur1m2WQEuvvIqhKtQuRm8h/JeXwl9taDHw6pd82gWoEmJ+N?=
 =?us-ascii?Q?IhJaC+R92YLNsPOLT8kTg0rvODsJj74HttqH3xSN36Lf7q/GPHBPwPC7uZd8?=
 =?us-ascii?Q?dRhKg/6vMgDxJpHDyURNhuanMaP/8GqQlDH3yDrBUrvwglo2nIrvfvyPWLg/?=
 =?us-ascii?Q?rc528agJbmh96RPfMkq1HvbNT5nYpRrbGPEgXJdOMhjC2kflhE5bfY61cx+l?=
 =?us-ascii?Q?Gv8m5wTkAH2q1GOPF5AuueAQt3BdmYy3HiWX9CALKUZlO/WfSJ9UXyIedQ2c?=
 =?us-ascii?Q?dHsRzUDehG0NERrVWQTU56n6qHf/5m0yIjMXxS2n+E9dVFY9EwLtIVRvz54k?=
 =?us-ascii?Q?t17jNt2oUfhDnB0LZJw+wk28f99p+75c8/MyeZ3VkCMmkRsetj1ixuBBgyKN?=
 =?us-ascii?Q?jCoP1szdIZNy8uQZbLo2l0wcdV5ffInkHVH/cf+GOn+R+xm6yZ/EBJCY4LqW?=
 =?us-ascii?Q?jcnR5Tj8mZEjL0L7bamKLb2k7QW03vQxo44mfWavRbTeffs8vh8B9PKVHTYv?=
 =?us-ascii?Q?dTUKOL4XZqjXSVu4Zrctmsm3n5mN0OA+hxEpGY5goiNbxlCa3cpeL43nnZ6/?=
 =?us-ascii?Q?JF2L2BsvtMmoAikxCetq2P8Qlf/pycOE9xE45SIjqHAgS5JrKFbejUiGPgNi?=
 =?us-ascii?Q?yl9HYsV+2tYw+MkZEL9fRt0zBui/lUan7Wd5bgI8LVRFnBFt/kST/z2AxT1e?=
 =?us-ascii?Q?P7rdVmHY3Giqk6NTkyPPvkX7ImNntY+1TXGHmYEfvoH49CplkC2SA4QycPiw?=
 =?us-ascii?Q?3f4fdjs0Q3can/WbN7dcTC+b3lRdgIryFIdXZCx8/hdecVlUD3z9cU+/Sb/n?=
 =?us-ascii?Q?WaLyFSmc0h0dVFuVjg+Cr45ua35UMZEiI5zUqhAtoumJbRNvN4ccdsG+zq+l?=
 =?us-ascii?Q?boDNI6+TMV25/lgFlprtxHIAXPTxfl6psCqOrMn+3U+BTaoBeFTq33HQglYl?=
 =?us-ascii?Q?zH1Lv+v6VW3FeI8PakYtb/9QkEvl?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7270.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?l42mCr3ih9uIncPRwIQ/Eq41Gnd+13Rt8YDPKwIsfH6+eGYdLH/YaBgMcquV?=
 =?us-ascii?Q?YOAng6Zz2J24eu8Nz7h+DBkZjfaE1cIjMH0G3RYZv922lj8bzUbL2q9zp3cn?=
 =?us-ascii?Q?PZv1Hzz2P94ts46Rj0x2JZPkVHqYcLZRwONwyhQrm5ASoRJ+PrD7ZhKxFMR+?=
 =?us-ascii?Q?iB1eEWZJWj+dS8JUCMWuHkQdNjt/NBWpo0UAxxcpljzorNkNsBHaAoHDEV4W?=
 =?us-ascii?Q?cIH2lzYr40tHA1bE6twhKbHPEd3HRxbVR4+DOAMGgeqx0eJq6FelcB+KltEQ?=
 =?us-ascii?Q?nffhvUUuNvH80FaDh2G7OqghPnDJoIcMQRDleJ8G1N9R8/u+pggeqYmlG/GO?=
 =?us-ascii?Q?r3JFvj+EIFobXXZAtsoIVpZ64LSp1EO75+fP1rHnVO5hArqzTWPo9XuBVegY?=
 =?us-ascii?Q?zvjiyEoO/KWjv5TcrEuSxI6FsWujNyXADQxjd1/zNwiDeCNnMCN/cZp9LZOr?=
 =?us-ascii?Q?1T1CJWoWV8DSFIJc1ysKSr9yYhvOV0V1IIyAvh24etoTdjZLlS5j8ttUeOYD?=
 =?us-ascii?Q?/DbH58XEu2Mqmym/R64lhzqeq1phCPLjvoKwHeSl1Vp1P5Y0mGf5xXBx/SBL?=
 =?us-ascii?Q?xtA/5YlKF+729fV/gzFkPGgMP8vfLWTuKzMZMLIJzZ98tICId9pDZH0/+B9m?=
 =?us-ascii?Q?bikziu0KcoY2Tkg8E9P8jAU9XJGI5sFOHHztDI/tQ+aftIoUNa7exv6Cw1uj?=
 =?us-ascii?Q?k/QVmWtLlov02H1ZQLm0VNhRVyjTIpIdgE3tTBXDdt/zewFt11ArAKFIChOR?=
 =?us-ascii?Q?gX9YynFBc8c+qT22rXAqYoTuYC9ZtGiNGvqe49nZkgJ56UlpwQQNPp1kcVeV?=
 =?us-ascii?Q?ozM1jSAkUZIT1fg4BaxBvmpz4BoTIMd1XWva/Ym/llj8c2xHGE50I3TveoOi?=
 =?us-ascii?Q?/8gBXehnj1LHlunOQJP512eTNnzd4bgi0Xp/yNO6B6Fa2olBa3Korkzi4mbX?=
 =?us-ascii?Q?nCun4i86SLTyThA3o2o3iubPQXcMDzoke3jLXNxc+gCeGKQ9u53MG0qSttgO?=
 =?us-ascii?Q?ZvEUdchJ0p3LSWYIjg6p9pReY8YRL6eSUNFOxm4D3MIACKbLLlGE8bC8hAsd?=
 =?us-ascii?Q?IgxnIOaSYcfAEBKpmiDlKSUDCiCWgIiq8FBHq/jz6roefAoTy1Wlz5AOykZD?=
 =?us-ascii?Q?SXfxfok5fIF2KrKw98uN/xa/G8eFISkd8I34LFi023A9SBk6sPIemlok3L9k?=
 =?us-ascii?Q?xnZ+AvzNiHIn5qP+Y3Vv0Tw4DE/zAMRwcA9wbb0ei+meXsNwAGYdL/m21muQ?=
 =?us-ascii?Q?2VigrJpc1fBcVjABXh466mS/ASmITOEJCrnIqHSO/eVYl6B/6LB8/fzaNOo+?=
 =?us-ascii?Q?+3DJoxHCWZcnOmyC9RxLznnzac4GSxyyyameqo758NfJxfkZJH9JRxFGPSE/?=
 =?us-ascii?Q?f/yUAWqVJwf2HWGQoKYVbVSCiN8+E7gi5UvNm49B/tLrZm7eZmYARaocY25Q?=
 =?us-ascii?Q?GrhWsguVdcVIcPQ/Kq6ywf1mRd5arvBc6ju7jCIKFjI8LrQTaop2LXfeWqC5?=
 =?us-ascii?Q?Yk2rjikdNyVG2syy26Xk6yd1d+eshN4cMEp05dnoP940kMyXw0M084/Rin0V?=
 =?us-ascii?Q?LDervuVh+mLVkRLdJBvMf5Zz1Cy2kk0qrlRbGbBocqLcSlNUnXC1Y0btXT+j?=
 =?us-ascii?Q?WA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	h3jXDccBFG/EiT6U+uL6IUcGS4cefWZqQPQjWFJ5WcSffnnieHR3/iR1gNbXcFISE6lGwhcGsexZsPdeVUzmaZNYSDxocrIqqiD46AFP9rlpexVKxXsdVAoqKkN1BgLTprqHWdJx93j6QWa2BNLS9RDjWqJactm5BtXbZZEg/Lp5nSjmqgTHOfL4VZqyRv04RKU6wpYDk8opqSOX/mt7JJGSzMEWmN9hrNT25KaHdoEDZw/gZmYaeWpoEly7/GJ8uuU73f8dxvsmOYylpp2rP935wx9estbo3elBYc4mxIWZDEBYJYSA0tMB0x87XI4MLrv0sYKf51nPPv/aV06rvBKTaIkJ05eZiAqPPBOqUF5QkJv+PMoDO4xUxiRU2TxjkERc3m35OmJ+yqnX1PxjBJa8RRDqnoRQFrJWjWRVhbsUerSGfRc4NyBB4OuHpAo6VQUWrF5inM7mwbDgCHcv2efTNrTumPd5kWnYFFRJWkKyO15y63Yrqq+N/tzT0vJry351/H8cumWMOT4vkrSmlVZ8k1tKNjq/f9DqNLfrjFvv6h9DsLMOyrEH1TuiB18XKg1HJlTUJVpmoKUO6j/7FMbO27NAp87NpiNyc+foeKg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 762de52a-7ecc-4036-11cb-08dd2f4dc942
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7270.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 19:02:09.3794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z4419Z7ilq9iMp/jZrSCDsOIEqCI7uPgM1M88zycCCwxWlQ2mJYApyYe3ZIOO2XPa/u7RbEAwWtJ82K+qefgQ0kdW7rwep43MxWWhs8yrPU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8042
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-07_05,2025-01-06_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501070155
X-Proofpoint-ORIG-GUID: nvKeQ1sFpMRE0aVC5CqxmQXt5aBoc0KF
X-Proofpoint-GUID: nvKeQ1sFpMRE0aVC5CqxmQXt5aBoc0KF

On Sat, Dec 28, 2024 at 10:49:40AM -0800, Yury Norov wrote:
> Calling cpumask_next_wrap_old() with starting CPU == -1 effectively means
> the request to find next CPU, wrapping around if needed.
> 
> cpumask_next_wrap() is the proper replacement for that.
> 
> Signed-off-by: Yury Norov <yury.norov@gmail.com>

Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
