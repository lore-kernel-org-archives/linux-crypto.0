Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935B44AE102;
	Thu,  1 Oct 2026 08:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790844794; cv=fail; b=Q308qccxh/AfuT0HlDDNpBqt3Fi5PU46oOYSpN+EPPuYO7ITQ+CbPwdcyRNApsg3PHJBHHATlLdG36R2McCGkVANIGPOerIkcY7IA2UMWs2KJ4riimAWt7gZW+5wBwo32684aEYiT1NQYma2evQ8tEiynmp6VTUq6wXqwI+WX30=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790844794; c=relaxed/simple;
	bh=rjRAWo0IROhIkjrOrMK7NCzoiga13Y2LvACriDFp9iY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=en5sPyEZfG/BPRWMebzzprPK8yd41Qr07JVB7ByJrG9KuYBKzxNG2yF7ApdUYycuxri9/myWC1+VDrz2QzwjJAEGKq4Z6O+hQST3dmZkXRtoZSqeO9RjgZEcj5lqacTF/k6JZqEG2T0qF2ER0+YMp/dizMxkMvPJ/UoXcbON/Ug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=VR5D8aMV; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=NKeO1jqi; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="VR5D8aMV";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="NKeO1jqi"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69171Gir793664;
	Thu, 1 Oct 2026 03:53:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint-05-2026; bh=rT3lLIkcxwM+c
	iuPFwQUM9ivFiV2yieIny8etFcgjBc=; b=VR5D8aMVtDAdTFUwZbXXw5RGNI4SE
	q7lORd4mOheOhiW4sOMPNxVNIfOgxiieRAWlocdJwx5IWwhzuRSrJat1i9mtHO3N
	7s5zGlZTsBVWWZegS4io4HeGX79/QqQ7CpM56xsSAFf+hbOwXYqkiHJWggOi45Q+
	D3B+2X9uCRAKttH5kYtjHNgV4BZ++lnzTi/vUXXZ595T9iDQirO4G+QaCYxPewVT
	GI3FgxoJjra4H391A1rKDdwaAO1sHL6Mdh/gh1WSfGGsRbX+2DbqbDtox46dZ6eB
	1CFo5TT0imIlQKBtBEP1R997aT7UbA3ztwkyMtIquS6hGa4upFi/1iVFQ==
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011016.outbound.protection.outlook.com [52.101.57.16])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4h17djv696-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 01 Oct 2026 03:53:08 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kVyUP4cuMwlsPuqmRHwJMOJ4NDGGXKw47K36J/AFjGYcs4DW4fq7vl/NR9hd+U+tiKS2lueM3FtcegALBCTg+UUVNr9Je/VhUBbIMMdKiJx7qUsCtPdQw1QCn3iZyNb994HxKBhsTP8BuUZ6WPoScNLlykLQy8hmJTBqXvriK5OVmm0Z1lO2CUofVMzU5NgiqHKb6UhqvhTkNixh8b/Glf4pwW3seXoR+tPSYEhjLRAlbsBJuzGQWCuXQK5btUbrX+ydxA01X41TvtDfTqXelXAF3FGmG7Wj0YG9HEd65+5P6VkfAneeoNRsOo8vkIVEie7gmcQFunWVhWMnCy/uyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rT3lLIkcxwM+ciuPFwQUM9ivFiV2yieIny8etFcgjBc=;
 b=A8pSlP2972mPQ9UpkpFsdTHzB0qRnFuQBXzHp3yPaHNkwqVW7L52VTj1Qej3oUyGt8XhkRH2ZD/5klucDq5ruI1vqHzZfI9uYSpiJYibYuX018rp1zm8ek2BFmAS8jChtTNDSFiImc2h0PUZ19q/D8QnS11UpyFWvPfxlxLnuy1zLJUuh4GQ7x9KF26b+VvqMMw5spGgWfeY3lb2UXyk29CrY5Ypfgiiyu9tvg0gL7gevAyRnFWlFEGBS49sh7fLFxZT2Ed27+Fv7sceviay2VRh43hTt43vlyPOPL9sOd1lzEvsYY7SnNwX7RPExw1Qz2Kw8Dk+asmGoW4bw2gsLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rT3lLIkcxwM+ciuPFwQUM9ivFiV2yieIny8etFcgjBc=;
 b=NKeO1jqiTyLNTvkWj35Y/acjUiLSt6+h4qoIsQ0SdUUbySls7C801YwO8Li8FiR/pA8sQK/i/e5EBIVWL4Wk9spCI5YC8bP5dzI5U0cJB8TisvYCZhFnCC8R7dyXsSuXS+HEBcMcZ2r2N3BrmbYvokA7MGf5ApEn149Z1f/Z/FY=
Received: from BN1PR13CA0023.namprd13.prod.outlook.com (2603:10b6:408:e2::28)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.9; Thu, 1 Oct 2026
 08:53:05 +0000
Received: from BN1PEPF0000467F.namprd03.prod.outlook.com
 (2603:10b6:408:e2:cafe::70) by BN1PR13CA0023.outlook.office365.com
 (2603:10b6:408:e2::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.17 via Frontend Transport; Thu, 1
 Oct 2026 08:53:05 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 BN1PEPF0000467F.mail.protection.outlook.com (10.167.243.84) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Thu, 1 Oct 2026 08:53:04 +0000
Received: from DLEE212.ent.ti.com (157.170.170.114) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 1 Oct
 2026 03:52:49 -0500
Received: from DLEE215.ent.ti.com (157.170.170.118) by DLEE212.ent.ti.com
 (157.170.170.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 1 Oct
 2026 03:52:49 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE215.ent.ti.com
 (157.170.170.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 1 Oct 2026 03:52:49 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6918qmfL647809;
	Thu, 1 Oct 2026 03:52:49 -0500
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sebin Francis <sebin.francis@ti.com>,
        "Manorit Chawdhry" <m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, "Vishal Mahaveer" <vishalm@ti.com>
Subject: [PATCH v8 00/15] Fix several issues in DTHEv2 driver
Date: Thu, 1 Oct 2026 14:22:30 +0530
Message-ID: <20261001085245.2922974-1-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF0000467F:EE_|PH0PR10MB4616:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c93a24f-6b63-42ee-92ce-08df1f9967e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|23010399003|1800799024|18002099003|13003099007|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	7LjCrqH6PMdDt/A2GV98cRltLbGPafxpmWTfaq9RNh+vS4WSs1twEXEPhWg4M9m63ZwsPXcxyvK6wU4DTAxzJNDUXubqgtAnREKo9QUEw2WQsKF5/WId+mUdCutta3wsLIwSpjySz/FOJ7cbJYFys/LDwYpUVRFzjQsDOfQjFJl9cu1K+8KOrnz7UhNEU0OxLwo2Jw5ZJb8DzwMx5BL9QtTsNuQFdhCvnnhyiKO50Ng6Jpkj7froaO+JkOtudcNTumIKMBMZFhMkc0eV/2JI2Kkc1IJxMPSPlZXoOlvmIGaSTVT+W6KDkN0iLGgHaiSmKb96xrzsnusHG6FSTysFvP/3TblNhAvVLYgy4orgrm+G3nwn+oI8BTZ1CZJgsN+yCSLLumOVMcNX58/hPiAUNnprGXLbVVeeMyVxj4EBeP37k/Uu7MV5xK2vhMPnkrR9h4juWEzbBwBVUkeOZWQTkSLMb3+C6S/gMqhFSvAAnMMG7PzDD7NUZgOxMG/PhuLHfUZ4jQWa9zDd93Ia7qCTpiaBpn79So5FnYyNHLMfQ0FMhEZc1vUsWGbDoJTqI2118Eok1Wc9e3Eia7aj9vn6cP2r6SzgJrCCw3GYjSz0onJVpn346W/i/G1MURr0SbkekDfom0+SMcAATN5O52JEBg==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(23010399003)(1800799024)(18002099003)(13003099007)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+T7jWccWRL7M6ChvVlFbS0bS2vOhAxDPv73sgJvbt2NKBzjxN+NuClFOOxSrG8T8LaECcKNc8fOMM8csEkQfps/sySZalzPjDeo+8IhfsNLK3eFhgQyg/5o0Y50gfBnxH2skmpLM4xdCIOnAeI8L3oxWICKMGFHO3HiwFWZ9+EIYjI9Puq+JnVMeyhnRkdzsF0xCvsTrNPXg8Bg9H3DxRFELx41ALIx0MADfW3V5/oAZG6JuGphbUq6vAbb72tewUmJWrsM74OGc9vPRsf2dObzlExW7M7mq/pTMzt2REHx5ilupMELK9Z71rRujyOt/rsaDywpd6wYIy0iFTNG7JtAYVGBM63b4Uo+rDQ7lXwkBGBYGXDyt4pR+fNJu9J+oG8lLwZRXGoLV6XEEREe/mzc3yWPYOrRQGsKLiHUNImuUEZQLbH7dely0+4em+G32
X-Exchange-RoutingPolicyChecked:
	aWUKANpwEQiT5CHfhDd5TNbgzXLnntI6sV4arEvPsAFBshdF1b8zy1PH2g959X2SyTbwpZDMWMoJlAJiwLVYXNhmrUGiRQtN+hpycSnmPepi2mnqMnFajOWU2PZq6Y3SBFWTZdvN1fTwfGLGJRTCCNAS3T/71uxmw7raKA4pFle3BnCr5hHH0iygsY/yZdTE9moTUA019lZSdESyX/p/ZZMBFnT+xjk+jW+Vc6X6G+t/EsCe88x4Q16GsPx9XZMx/YllqQBwboLSf422GLBPBccDkHR5dqLc8f2UA9zzc1c/G9j+kmxlYQUZV4n8IfwzVlzrETnZSQwtJql1LBXoLg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 08:53:04.2180
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c93a24f-6b63-42ee-92ce-08df1f9967e3
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000467F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-Proofpoint-GUID: fHumm0d8IqRTgXpXJa8mQc6B03_-tYCI
X-Authority-Analysis: v=2.4 cv=aswnmiZV c=1 sm=1 tr=0 ts=6abe1f74 cx=c_pps
 a=TofqhMGnQVwdh0HkHXulOg==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=c92rfblmAAAA:8 a=sozttTNsAAAA:8 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=UxwojoEslEplIN4H4qAA:9 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-ORIG-GUID: fHumm0d8IqRTgXpXJa8mQc6B03_-tYCI
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDAzNSBTYWx0ZWRfX75XdALJwDriq
 J5RWUS8cg5TqZSo2vgK6iDxlf4Ttc5vH6Xg8hMqIFlbKNwFtvggm461b7s6vEpUOoc3tWpumAwE
 P+5WUVGtPFxvmfKDJRyHWm9kvMzEvmA=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDAzNSBTYWx0ZWRfX28iou3UJBMKH
 34kl9peQflQQ2JCrQcB96I4ls9+QE2p2aoOE7YM+87BQa1646KsxGoRJtRcYjnSaa4jhcO9DQOF
 KK+w6tdcNYeFeEgW/MCAoDtf2QZ7M9MLU4ZhZOo1BYLciODk1Bp8SVTttZjJ+HqLGCukNybSAD8
 5bUfkcWD3DVJx8Rhlboqa69VY56P19BjptZzM5t1D+xFAaxFk6H9Vl2KhqdUV64O33UdlcAJ6eN
 NPscFdBemX4BRIFyhfmkNotcnr+MTqpjeNdJ0BFmhhD/TNlAWDf6njGGJShhXV0On5/cl0Bv7Ol
 pPjpVD3Yo3HpzmbljprvtKw+JQhlt7omKX0aZN/RkInhI7pwUx3eEd9YE9O3UrbvN7rj1gGvhcM
 JFXufbqywoz7s+q+pfARJHC/JXcxE7jAkEZpoVBpIBzfrmzlqrJVKDrUBbey9v/3SqP5/SjzfVV
 QOBUS1PiO8DKN43mKAw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 suspectscore=0 phishscore=0 priorityscore=1501
 bulkscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610010035

This series fixes a handful of independent and mostly benign till now
issues in the DTHEv2 driver which were flagged by bots and AI agents.
Except for the fifth patch in this series which was found in an
internal testing.

The Sashiko review on DTHEv2 hashing driver patch series v5 pointed out
some pre-existing issues which needed to be fixed [1].

One of the issues had already been flagged by kernel test bot and a fix
sent on the list by Mert [2].

I included this patch in this series with minor edits. Then the Sashiko
review page for [2] had more comments [3]

Overall this resulted in a bunch of fixes patches which would have
deviated the DTHEv2 hashing driver series had they been included with
it. So I clubbed them together in a new patch series which is this.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
Links:
[1]: https://sashiko.dev/#/patchset/20260807110501.975130-1-t-pratham%40ti.com
[2]: https://lore.kernel.org/all/20260613085858.32580-1-mertsftl@gmail.com/
[3]: https://sashiko.dev/#/patchset/20260613085858.32580-1-mertsftl%40gmail.com

Changelog:
v8:
 - Minor fix based on Sashiko comment (corrected spinlock)
v7:
 - Fixes based on Sashiko comments (added locking around
   dthe_put_drvdata)
v6:
 - Fixes based on Sashiko comments (waitqueue -> completion; DMA
   alignment for cache coherency)
v5:
 - Fix spinlock inconsistency patch
v4:
 - Fixes based on Sashiko comments
v3:
 - Fixes based on Sashiko comments
 - Some reordering of patches
v2:
 - Fixes based on Sashiko comments

Link to previous versions:
v7: https://lore.kernel.org/all/20260930125859.1749849-1-t-pratham@ti.com/
v6: https://lore.kernel.org/all/20260930112533.1593952-1-t-pratham@ti.com/
v5: https://lore.kernel.org/all/20260918102245.2784000-1-t-pratham@ti.com/
v4: https://lore.kernel.org/all/20260910175619.2122149-1-t-pratham@ti.com/
v3: https://lore.kernel.org/all/20260910104202.1537226-1-t-pratham@ti.com/
v2: https://lore.kernel.org/all/20260827132318.613876-1-t-pratham@ti.com/
v1: https://lore.kernel.org/all/20260827105711.527182-1-t-pratham@ti.com/
---


Mert Seftali (1):
  crypto: ti - Use list_first_entry_or_null() in dthe_get_dev()

T Pratham (14):
  crypto: ti - Fix spinlock inconsistency in DTHEv2
  crypto: ti - Fix potential memory corruption on highmem pages
  crypto: ti - Fix use-after-free of dev_data on DTHEv2 driver removal
  crypto: ti - Trim scatterlists to correct length in AES
  crypto: ti - Align buffers to cacheline for DMA
  crypto: ti - Separate padding buffer for src and dst
  crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AES
  crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AEAD
  crypto: ti - Terminate DMA on all error paths in AES to clear
    descriptors
  crypto: ti - Terminate DMA on all error paths in AEAD to clear
    descriptors
  crypto: ti - Do AEAD software fallback on only ENOMEM
  crypto: ti - Correct AEAD tag operations against dma cache
    invalidation
  crypto: ti - Change lengths in AES to u64 to avoid potential overflows
  crypto: ti - Change lengths in AEAD to u64 to avoid potential
    overflows

 drivers/crypto/ti/dthev2-aes.c    | 368 +++++++++++++++++++-----------
 drivers/crypto/ti/dthev2-common.c |  61 +++--
 drivers/crypto/ti/dthev2-common.h |  67 +++++-
 3 files changed, 340 insertions(+), 156 deletions(-)

-- 
2.34.1

