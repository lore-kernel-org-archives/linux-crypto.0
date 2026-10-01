Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75CA2D322E;
	Thu,  1 Oct 2026 12:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790859585; cv=fail; b=C3300kddaW+pyyA1Hw4NtWCtoiuY5KW4Ggk1fd0XCOlVTBX2ZMLehdF19FGk+jafXn2oGPKplvfeoxk493yygQXXgTEVfZDlGvIb9bbbNPs2NJXWab/iTvPyV8jMw7QSIh9EAUqMhsIfOLjGwyQXveTlxxFwnAkTPiQ8xlmGv/s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790859585; c=relaxed/simple;
	bh=X2cIw6w0H8k6kVOjuHUhv+HIxTAdq12CbP9W73SH7BM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=tlYjTbmqH36aD/iu1/p+Rr/ig6T8WHV1iU3vU0x3G1GzvHlVTNQ5DbP86LQyVopqd3J5cCt0i6QJlRwdYh7kGE1uWx4DplZzQp637w0WIs9FwHLivteLLkrIRSPFnLqu2WjTaT1sc0PIyRU5F4jgsMrKTVPFb8Dcjn/dOLnsIOw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=H59VdKGg; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=CEqltTHm; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="H59VdKGg";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="CEqltTHm"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 69187Tod1207711;
	Thu, 1 Oct 2026 07:59:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=hPcpXVFmF4qoScCYsLgzRi1FOvtE4hFWhS0YPLBBH
	i8=; b=H59VdKGgJuRXuRE7l8YNNJM+WS/CYI5ToRDGnpqDyJwiVdoNrirm5WRUh
	R7hF6W5shdoJCWh6sAgkf+qeObVtUlaYvwxqC6McPBsiYi5MrmbljHZPW4tn3ar1
	p2CkZi4Ayl7kCcOw4JFGFr9+TccxegVl+Rceyy3ge9NkCH4BqECt5rZuesT0cvC0
	5EUQyBokllozt5jbHdiqbfPLocQGqaGTHJEa33Ls1Kil6caJ17BSB0CWQ36roaTB
	wm9zXorBhHV/gVFzr7nZ6Y+BiBXNvmgNE+UL+PsPCeFoupFWJdF40mTZP0DxXB+y
	WSufvgpfMm1WgXkBKtT+Z1rS9t9Vw==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010064.outbound.protection.outlook.com [52.101.46.64])
	by m0380145.ppops.net (PPS) with ESMTPS id 4h1kqyhfhr-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 01 Oct 2026 07:59:39 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=buTqKYZJamXKHSjc+ZGridSIiFE0b2D+Vx0byqKJ9OqPpumSDkc2nwuXUY6hd49gwfyMNFRjHaiCy7NuO2pD5RcSBfsdhIvEFCh4/g8V/TBexMOJTQd/yJG0iR3F1k98lwYdkvRB5KQA/f9tv11N9Vhbj3BLAuBGJLcR+0um3kjBuRJKQlTHAX1gCqqaxypdeuwwXrMuXVPOAUG7aHGpIqq24LoLJCZBqnaSYQ23twcbpe4edP1Ztj3xrewyeZuU+eH8xsLOGnkINFuzS+OWUvBLWKTw5rAUZcsFzGP3YKVC72kEF39LipAvG+xShAIt4iwHLWz1jNJd9JTJKk/PUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hPcpXVFmF4qoScCYsLgzRi1FOvtE4hFWhS0YPLBBHi8=;
 b=sothre8URkl12VhUTynmQBgfATWqwMtx/lYp69r9Se7OMlVdHuxton5DZ4OgBZ/enhva+m73ivzefaJbRbC8f+0fE1CwOD9MiM2fmptM5D7oqlb9uZbVNNeAoh1oXdNjURyCVICjdrVbJzsCoKo5XNOlmEv5rxk15QWtOrhU03eckdEKwmQGCkhxSOoa7e8WYP3YcATyl9F/i1RJhNR5sRGwaj9i747x5b2+aCavccaISRK+jZdY2xtNTHe/YIJ3nke33U23WkRJERntkfxPWym0pB2DPu2oc424d6hk0kRX23JZZcuv9HZYtV5YVPfD6mb/EpWILZFItLuqxwB37w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hPcpXVFmF4qoScCYsLgzRi1FOvtE4hFWhS0YPLBBHi8=;
 b=CEqltTHmETSIv87zMJROdNxz3NUidZw8wvnRfZ16+5F/QCUOFAas3K7v+qQ0nHgaGPLxI2prDRRMDPZKwhkBygbQsH5yaGHdNmo2JQrs+EkF/XetP6v6b3Fd5HaI3e/43OUdGEPvt98I55e+xV82prXDRgH+LTPyFYJ3tRVmNpw=
Received: from SA1P222CA0109.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c5::26)
 by DS0PR10MB998105.namprd10.prod.outlook.com (2603:10b6:8:391::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.19; Thu, 1 Oct
 2026 12:57:55 +0000
Received: from SA2PEPF00003F67.namprd04.prod.outlook.com
 (2603:10b6:806:3c5:cafe::7f) by SA1P222CA0109.outlook.office365.com
 (2603:10b6:806:3c5::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.18 via Frontend Transport; Thu, 1
 Oct 2026 12:57:55 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 SA2PEPF00003F67.mail.protection.outlook.com (10.167.248.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Thu, 1 Oct 2026 12:57:53 +0000
Received: from DFLE208.ent.ti.com (10.64.6.66) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 1 Oct
 2026 07:57:02 -0500
Received: from DFLE212.ent.ti.com (10.64.6.70) by DFLE208.ent.ti.com
 (10.64.6.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 1 Oct
 2026 07:57:02 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE212.ent.ti.com
 (10.64.6.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 1 Oct 2026 07:57:02 -0500
Received: from [10.24.53.205] (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 691Cuxji1011477;
	Thu, 1 Oct 2026 07:57:00 -0500
Message-ID: <afdd133f-3d70-4af2-a35e-cf0ff20e7218@ti.com>
Date: Thu, 1 Oct 2026 18:26:59 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 00/15] Fix several issues in DTHEv2 driver
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Sebin
 Francis" <sebin.francis@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer <vishalm@ti.com>
References: <20260930125859.1749849-1-t-pratham@ti.com>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <20260930125859.1749849-1-t-pratham@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F67:EE_|DS0PR10MB998105:EE_
X-MS-Office365-Filtering-Correlation-Id: cd7f4a50-559e-4643-352b-08df1fbb9b77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|36860700016|82310400026|1800799024|13003099007|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	eiuAEd6ereYP6++A8j19MIlpQOLpPa4g7+CxX1zaqo3wQlYyp0CFQubsbNiRZuGR7x1y920hx7XcaVSvnIVTaotFTIhVhE6gJ5768Q0yTUk+CyMmwC66Ch7A+ax/+g60maYZVE6iCf58RlLx3x30aaZHBrK49leCGs6O/NvaXoMEZ2SxlRCz/AY8cXwXa9vLD9TrXxkqw6NKn3CjuDaNvn2mN+GkCZDfhPMrfyBHC63qSLZ8jcm9UGA0YNYjVvY+9AwwQ9AZHtLl6HyUP4uSkCBBfPYHKBdcJF58INNSzHC/DZ2PvbZZh04+EehCpq84d6ISuwl1pFbfeCMZyee/7g6/6OL8bJNl3tNhXsbs2DRv8tFR0V24Y25Ucul/hEvfqbcZf1dY8Q0zKmeVertX626ZcyW3tkO5ggfhndk3W4bR/lC0XW16bHqo71EDC2RpqMXDLYxUWXR9gIQF2GkP8fGs8B2yShE/GSdH3R7QaHt4hcy+LhC5v8ivKt8phH0nVwBkBuPdWym93K1FxHU3uS64NogTr7NhsW6KoVyt0M4eTs2o0v3S8DKcbMqmoIjgfefahw6WTQCrB6TgeZiYs/KNh8GKbMNuYN1eQrhbwTGHb1CIEGkOfZbjXO+i4GTpmsd1zluJRydnhmrnDT5EQ4esYhOusb489Jlnm6Aw6gvtSmh9SAP/izDfu+AKF6BYheTevZKrzRHlkWwqJ2QLfQ==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(23010399003)(36860700016)(82310400026)(1800799024)(13003099007)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	x/WxKC9KnBlLMX23U0vMLlExbWZRZq9H8Jvzpn6WPW8NKePUVzq4Kq2u9mVB8b40bZsiI5lytxuJK0sJAW4SZyLWIYtsZ7mYYEzZNm6tesv4ikxomtyptbaHAAnNS4K9R5Px3a1nvM2lOh051Tlt2V+CtOwk5ppPombvgTOjymodEVtft0pLKhlko2iX/K+5oGKboUVXByI0OLmjcwD9VgOFDMsXSTDiw/jG1AYs1k+PzMTvS4M8tYdb5bv37T8k9XYzHT/TaakgtAvD7hgmCTcMPR2oPKI8Atarsy+31/Pdqpwd03gy9Kh+cVANrfCCD7QMu6nkckrDliPMlMxZMeHhsL9hRXFSaWEnAiYZBmG6rOVbn5q+GeuQuM/iNepNJg7e6hQInWkdtAkWs1e7UFMYQWG2wnjPlizhiG0XjGJkF8cJQs5PxUgugzHNF6oU
X-Exchange-RoutingPolicyChecked:
	VxavhmzFhfSNXfLCS+LAMhLfSw1XUV9LBIWoT3l8VU1RNtVK7TR45UeEjQPOltofqI6agYa/8ZfZQtKY+4YBIlpWOqDmbu7xiasQrf4spudsYi27IIgiKTJMNTB2KaCz+F6hF5kCA7GdrtqOAJ2/EPqK2BnyIvwQKRd+3P2kl2PGsOclUUxCc4cd0kd40rsbZm8Mx74NgcC8Mh5pUkaE8tD/K8or84JSX2DVnZhmlci0NBblQTkOzVqN8w+aS/hxmy8murWlCyACq8gyZnR/wOb1BSxsMuq31dEUbdGHivr27eusgGyxg5tcs5EpdGNLjHaIEln6rtZaVVSHTLzxzQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 12:57:53.6829
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd7f4a50-559e-4643-352b-08df1fbb9b77
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F67.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB998105
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDA1MSBTYWx0ZWRfXwHwvEtlMpPha
 JIDqmnifklhSKCJ1yyH62spEmmXKFo33xczyKr3ske8EF9SsCYs5jtxfpPOtrdOKbxAXxgQ5ZMv
 NB9Q7ZhycKhcTWEk2eYQ8bjFldIbt6g=
X-Authority-Analysis: v=2.4 cv=a6alZkSF c=1 sm=1 tr=0 ts=6abe593b cx=c_pps
 a=UPJ12yLMGL5ZZCNrBMA7tw==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=VwQbUJbxAAAA:8 a=sozttTNsAAAA:8
 a=rX7U_iCxW0pS0ICM3k8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDA1MSBTYWx0ZWRfX+WM11earfrIr
 BtnRTHdFtrSbJK9sYuOrTkRncNyap/OQ/RK+pIbC3b6zUv9f+GN6utlqIttQv7lQxoLkYIN8gJk
 vNUGNkPds5iWEUzBzYaZ6OM5d3I8E62vh94vcUjZxK74+ZQJ4G5kcZL+paSuWGQZPztU5yesImG
 ZBVw/hSUgnoiDD1qqQfF7AiylYCcmaW1Yn6+qh/z5QztGTfHvA1NfpEmaED0daobH9pTo3XEBvI
 Z8D1SslHybTgilFqq1UbdAMgqnyryohLTXoOb3L5xyoCQae7MlzlOs/4eXZiTOkcrQfJDYhAk3K
 3hRN2+5WcvzL1p48KEgTMGk1i8iBVHqjUhzD9oDMtyLXmL/SK3KQJyPf+c0l06nMXPnZelGljD3
 prpiAFLbuo948gThgkdnijbexfme8ItOTTMeqPeu1MxGRoWrnrpRLDCyTx39uh8RCxYXvTWe0UJ
 fEt4WkS6T629Zf3cr2w==
X-Proofpoint-ORIG-GUID: PBmeH-cYNiXfjvz4_zz0WGGPldGvrRcZ
X-Proofpoint-GUID: PBmeH-cYNiXfjvz4_zz0WGGPldGvrRcZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 spamscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2610010051

On 9/30/26 18:28, T Pratham wrote:
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

This has been superseeded by v8 which fixes the lone Sashiko comment left:
https://lore.kernel.org/all/20261001085245.2922974-1-t-pratham@ti.com/

Sashiko on v8 reports no regressions.

-- 
Regards
T Pratham <t-pratham@ti.com>
