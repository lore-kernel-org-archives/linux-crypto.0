Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3276A4F85D1;
	Wed, 30 Sep 2026 13:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790773470; cv=fail; b=GG0YO1uG20X8xksOveM2vRhAQjbIsXhqn5UKhpiZc8vTFbZog3eAwWrzGzCfYpvDZxRsOAYvqWefqxYTgxUWgU6qYz8IGJR6d8UQ2FqAA+8ifGM3WvySbd2SS14Gm/HLMH1UA3lOKSB1lGPkPgdlIICF4VjIR54DSFvpF+AOAnQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790773470; c=relaxed/simple;
	bh=ndwIygiGssDoz5q/ueg07gfaYiLfaaO8MLV274FTOVQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=sqL8zkW3Sx3gPAGBXP5VCrJyBrllaO3X3bOE4tvOY7agZ2CMDP81pR6ScixqPrDzdzSm4odNIa5w74n2zl2iVvriFGwx0TmYPdg2dyTe8MC9DE8VCIbFC/lc9/f6GZO0ug5jjkDjBh8/xce3p8qRAzd2NexepK9oJNiOQEo9oTc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=oMX2DFzE; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=iCbwkNfE; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="oMX2DFzE";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="iCbwkNfE"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68UB5v3B3214059;
	Wed, 30 Sep 2026 08:04:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=ZVcTeE6m/y53kUFmifhnWrtEOUK+oXArPdjthkrLB
	aw=; b=oMX2DFzEwB/PpJQJu5GrDPbKu1wbegbyc+fDC5pBgE6DrsNbCEmLRUhRs
	LrY4Or+IHeTE8TQSFC61XgHHXzLzWNrUs19fo3Q2hNfG3obH8w6f/S4BOThYGROc
	6S1axjPA8NjRB/QUNc1o0Ag/BuVeEDVbYsVxseG7tSBDErbG8xglZIhbCFmMaYaq
	lYjKtYsjKbOQf26WHGVCqDZF7kQiVvfPPa+kS1SNOSLD+CtoikyUKvZl7VRyqu10
	GGGTsPqLf3Bl2nvwJcqY2v+q+eKvMIdj/VX9Bs8zxD29QQLSY4z0IOx6jhUXn+wH
	+osXQQ1AiaPSW0KFoYZ/Wcvk6jBvw==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012003.outbound.protection.outlook.com [52.101.43.3])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4h0ydv96xx-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 08:04:12 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nIwqFJMm3/yg8wgWL96Yq3SB373kD8XTHLYRnsLh1IJ5+wY4kSzUIjAm63e//oIzWYDfE4wzVz02WgFgRXhwQrTp2g+/rwjCOF4678RbP0J0ugJ5+X++TNMwuAMw4LCuX6bVMadNSig1tPGuOWdPMuvoGiru2LRhzHMm8P9o6/fvCTd11YcianEXBNJazIYvSvHax9wythmXx1o2ea0eq1eOqkXBdUGO+HgfAI11PsRfl8TQ+swE43/CGCqhQTG6oR4K1POiKQe/3/XkaNSpgsfTGjtw5e+S1N5sY+J7j3ywMxlTZiYjcDXIjwrMy1u6HHMyb6JvpaiT/HNfbcjPqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZVcTeE6m/y53kUFmifhnWrtEOUK+oXArPdjthkrLBaw=;
 b=vZI445l/ZLqzKGRkCSXm+Aa0x7bn9Ur4Nsq31dkoTijg1LUcyia58k8nBBvUfjebWRwr/ftYyPfnGAqVsn0KQN4Wgu6Gjzib449M2eRiYxMogm+0zJ2Bv9cUgBodjq4LngQhu6eMhJz8xjNVSZzX7r5rcm6bMjKWiKaaG6JbvFyCxk1/Kn7nopKtFRL3iSlRqyzVZ51RInvFd4lx2Z+VaouLiw020aDwLPnqJ/zHayGcp/H6b5Yw1mWaiaaP0Gfkz6e7+v5La/59MyZ7xKB2+kSMpodZuPmK1v0Iv22+MDFwMjcNKZXoVq1wfreG4Cdusdbn8peQeG3QTpsU7WeNog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZVcTeE6m/y53kUFmifhnWrtEOUK+oXArPdjthkrLBaw=;
 b=iCbwkNfE5Xbu8TbKMoT64LS8udNlZTKUrIHK0PljyAtWn6N+Kpq9neezUKScSmT099Y/pkRenq8upPJUU1myeutgtO1Vmm8ZpcbGJ+pTXEYB8PddikzTFQx64/msNzeMC+SfihTVY4VJH4TIVnWIqIovmJDrotwM6U1Q+5lz9T0=
Received: from BN0PR04CA0001.namprd04.prod.outlook.com (2603:10b6:408:ee::6)
 by IA1PR10MB5971.namprd10.prod.outlook.com (2603:10b6:208:3ed::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.14; Wed, 30 Sep
 2026 13:04:09 +0000
Received: from BN7PEPF000000A6.namprd05.prod.outlook.com
 (2603:10b6:408:ee:cafe::5c) by BN0PR04CA0001.outlook.office365.com
 (2603:10b6:408:ee::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.14 via Frontend Transport; Wed,
 30 Sep 2026 13:04:09 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 BN7PEPF000000A6.mail.protection.outlook.com (10.167.245.230) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 13:04:07 +0000
Received: from DFLE202.ent.ti.com (10.64.6.60) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 08:03:20 -0500
Received: from DFLE203.ent.ti.com (10.64.6.61) by DFLE202.ent.ti.com
 (10.64.6.60) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 08:03:20 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE203.ent.ti.com
 (10.64.6.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 30 Sep 2026 08:03:20 -0500
Received: from [10.24.53.205] (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68UD3Hhb3163157;
	Wed, 30 Sep 2026 08:03:18 -0500
Message-ID: <d181cdef-09dd-4d6c-8f51-cd560bcf05af@ti.com>
Date: Wed, 30 Sep 2026 18:33:17 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/15] Fix several issues in DTHEv2 driver
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Sebin
 Francis" <sebin.francis@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer <vishalm@ti.com>
References: <20260930112533.1593952-1-t-pratham@ti.com>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <20260930112533.1593952-1-t-pratham@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN7PEPF000000A6:EE_|IA1PR10MB5971:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b4dbc59-ecec-4f5d-06d7-08df1ef34fb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|1800799024|376014|36860700016|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	9zOv26bxUGgWrw0umGCYvmNezIZgB7oS4eb+B9g7xzId/7HsZwIG5AxquedPPZb8rKqtfGS2sQ89K0MSCx88mzxGD4BZeBWoZ0or3Me6MGrnj8O7Ph7ZtzWO1wu8m+EJK6hO17WhJHOHUtO3DhvciQd54c7fSE5cA1qXIfk5GSPMcqk1J8LCZZH0CM8xmaSawAYBg8W3+kyNrFSd3wYPvmPQPZJbLQTLfDhaJVWIdUN25u1F4z+0CgRsG+7ZLYed5FhHd7jaAGfEc9kte0doDHFuZf46iCpzJ2zpgJMJM3997sHyDBLlj5dg3JyZWxxiFEIyErdrW3l1jPaQE6EIBhFvWAlkzyxGmuDt9RO+5h01ztZp9CLwxySrG83+mcyDCbhChggvYOcumkJUDwfDWMS/hddglmjZBZXr/HZihvgOdvV+U3JMkTLzhmnX4YiHl/7Mc5IzldMs+KaJCSioAWOrylfze8631DgkpKNnTqtlNTz4iYHlNTDd74vWhhxT+ZYmZ9YSKwe9MWoRDByrxOsOS6stafICOpvSpgTAmvFvV5xOLdT9gtJEqMEpnOzRouBpepLrBq9bpn+MRiiQypOLswo3E2jNTv7KWXyBFd288XHSypiglBAxLdainSub3JFjinAJoZzUnxlE/9y/s56z1RJG9spRyR9QrXe8ID528giUySQoViQwRWetKH0c/VLmKV26nCXIRGU0JPQPTg==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(1800799024)(376014)(36860700016)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dax+MV2XoNIhAm2Ij9GwGxhiGsYPbLxNM4EhJj1+XtdC2kirqiH9/aeDinxq3ZgZe22GMnmZwIy6mzbE4/BzJ/hZAAk9jKJwI93T4Ou+FxIA0OQp59VDyEax//N+2EVkNiUaqTgUwKhM3MEb5wmpY0ttYmFVrii8QFD0tGx2aBT6izGH0tqGSkoCn1wZHpDlIVndcmqRBZnXGiG6gI3ZuSKiVTfo/MvYdFT1o2SFshN1Q4WboS0VopomuXhNzOF5gCdgMDh8fi90mvwP0d97IjvIzfEDNDjuYJBDW6fzmm3O5G1/nhb/uCsfu/ojGlyyiXLOGIk8hRcjty8e9DN2USsM04e1xNZPwMj5InTCvLyMqwpsDhiBQunBdmU5ETUUZy5k0hDsMpf/Yyf/b43ExmquK5RmT3geCU3FEL1dADO1PzFc3mJt4TFPqV9HtYJV
X-Exchange-RoutingPolicyChecked:
	VLjwIA4da7jzXDQ35nHm03dYJOy8EMS7yRDY6xDsVBB4CDakkcTcea2OB5q5xO7D4LVko+3pJIdSu0eYe2ylyy7yGc+qgMzk2hU/WyYGDtCAu3bueXRbSMNBHse5eFEDO5iVIWlvlwSQpaxzRhBniW/HuBM2tmlWyicnQlys6pR7st64NHM0sQEh2BHRdfWv26OoOgqt6Yq7s2hgUNQPvlti9P+b1jsWtku0nx+813UJUyBeQISCIdOlbEpNEbGr6tQpmf7zUkZBe3UeuTIjfPeyLBhb8f+iH6eYDAW+Z8B0g2gAHM2DZPYWVarIwoznGM5fla1J06snfobvWG7SjA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 13:04:07.2087
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b4dbc59-ecec-4f5d-06d7-08df1ef34fb7
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF000000A6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5971
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfX4dHD8C+ujo0x
 u8GAkmqqdGShUM7KYO/ctJbaqAUCejD1NM0byCcDm4uZgHNTviu4ggxxzBd+bwdGS0ksWj2HHFS
 AFZMaBSIX+JEdpM5Cc8byo1OCuPG2Gw=
X-Proofpoint-GUID: 7oicbx1J13Hdrp-m5A27i-J6AUfKTaEF
X-Authority-Analysis: v=2.4 cv=TegDJhQh c=1 sm=1 tr=0 ts=6abd08cc cx=c_pps
 a=ayBBURk7jZ4GzqZFlR2IhQ==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8 a=A0WTEL4GiMLLo0qe230A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 7oicbx1J13Hdrp-m5A27i-J6AUfKTaEF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfX70OMWWsn87An
 SjftM8mTCVYKOAOmIapXwRjecgMLS8UCwfieYkci42YHuI6KKhq1xuYpfdCPCXQIhe9z/mixCsw
 UEB1yRRsWBZpaxg2+Ozeg3zC8NMpQImxyIZcULPsUBDjHG1TWm65x+7NUPjK9qLBmT0Rtkc7JUR
 /zu/htfnmAKMg8nStoBIudNKGruOh8pDZWVPGaWjgvBXzdbrdqm6uEBaD2hwF9VMkcW4i6UJktj
 4dkm4WwuSGNUPpuuEeq8+rzeHpuHAhC4nvDCM4bpv8gyNYPXDZ2p7zkuo2agwKXqHI8DzGxrQ2c
 9D5Ek0AR00aNdN1XtkBG56XFzufQ4fsgjc2MgpjqozXT6RoSZMUxCGr78qHKbUKNbs6T6cMaTGJ
 h45eJeuCVOfL80UcF4wXddtRojZNZLsxLbyekAAABoeDw2x5oTiF/pGFisWdxN1YFGW662fEx7w
 Sv5FhTEWqInbjwhM/Sg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300051

On 9/30/26 16:55, T Pratham wrote:
> This series fixes a handful of independent and mostly benign till now
> issues in the DTHEv2 driver which were flagged by bots and AI agents.
> Except for the fifth patch in this series which was found in an
> internal testing.
> 
> The Sashiko review on DTHEv2 hashing driver patch series v5 pointed out
> some pre-existing issues which needed to be fixed [1].
> 
> One of the issues had already been flagged by kernel test bot and a fix
> sent on the list by Mert [2].
> 
> I included this patch in this series with minor edits. Then the Sashiko
> review page for [2] had more comments [3]
> 
> Overall this resulted in a bunch of fixes patches which would have
> deviated the DTHEv2 hashing driver series had they been included with
> it. So I clubbed them together in a new patch series which is this.
> 
> Signed-off-by: T Pratham <t-pratham@ti.com>
> ---
Superseeded with v7 containing one minor change (addressing Sashiko
comments)

-- 
Regards
T Pratham <t-pratham@ti.com>
