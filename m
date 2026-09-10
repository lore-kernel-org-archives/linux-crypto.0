Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF6452ED5D;
	Thu, 10 Sep 2026 17:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789063052; cv=fail; b=E4zTqs58iWlFF9spU5MGa9ufHt30xKlRQB10qiCXmqeMedF+mFfxE9VsctLgPU69ZFQGV2yV7yWcR+QLhKbJpyMCJo+H80hLKZQdA87DPnJtDWqQtjolW6BouqKNoaxKD2KLot+Reih2PEF6g0PNJjpv/10JGo7nBsYN3SiiJ6Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789063052; c=relaxed/simple;
	bh=R+px/vXG/QquYBQAhfu3XrhE5s08y0VpsRxFnyyLHp4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ui0C5ZVcAMAdkseEz3eMRAIJcxYV7n4pM44l4nV5bi2htk6mapsquFI6CIGGDcKwJso7Fu2wCwfbU9Hgr8QSeq4mACBTlmnGA1y4O/FQx/n/KrWwiQXWwXa45liw7XG35wEJg8FGMY3VDHofUQ5gEkgvbJmVHRXYl39V18hmLFQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=NSRdBhP/; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=IBReRvo5; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="NSRdBhP/";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="IBReRvo5"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68AGEZbk3808438;
	Thu, 10 Sep 2026 12:57:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint-05-2026; bh=b4Dy2XwmrexTR
	tdGomEkwq0oQxxW+vKKFrOJujDqOwQ=; b=NSRdBhP/Uy+JWrc0qfzZVaBkSqd4U
	u0dXZAUDnHLORqDcYu796h5Vb5IhjKzx9hKS1BTapByYEwID0J50a9PaO9nFekjF
	5xg58MKlSF1HPMGt3Agfi06apVlJHm1vZRmZRrY+NVahzLXvVRn4WHMdbKSjXeHB
	sO8F8XbBikZ8hfV9iZEcIxk5zBDsGcdYr8iKJyNQOTTs6xWVJ14etVIWcstiDcwv
	sWiu0HTq1305hIDfyYfkbx8kUp6lVsdZuaN8fijbelzCPsQwnQiiClDWI+oYEx8p
	FTdyXQQx9yKcPOBriwGqzN1vmSMmDBoiP+bsqrxpFzDvDlCjdeK+fc78w==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013068.outbound.protection.outlook.com [40.93.201.68])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gkyw9gp2a-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 12:57:17 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NOYOUNTy8SAebnrD0oxJ3QXodKtBj0Ykrnmf2NQLAMUyudzsnhKHis6TuxxVQrEB7PQmMfIwWtF5V5ZxK9q1Xtnbwy6W3IlGNhhiWGaYioliEejzxMJrTH66SaXEs73qG+4nkUAHUqsR5vIOMokkwZ98qCZf5gFRC420hECCI8eoKGgKlANdsBx5idvovms57q1tt+SZMuyHbPTRQYAZQs+wonpJsRwvRdoKwT4zE3rDw7BBrH65z2ci493L0Pi1odARp0z+wCQZK1iIWMdsutNwe787yQSOcpZ7rtMkVpQvtfPeGlGFfosraxAC+smQL/jjS8GFr+bB3ZonnjwrzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b4Dy2XwmrexTRtdGomEkwq0oQxxW+vKKFrOJujDqOwQ=;
 b=epUKGK7jvS+LQqLuXc1y4gu2NZuhbZwyA0q5Aq3vBq/UW7sV+/tCtOLuwTtOFsFMa6vJFEo8OI6DbXeDaIzkrdqPAV/ki4IDH0nJQatTceNuNlzNuPuMPVf+t9cAH70QIX1v5nDcBpvZAsg45pEyTt0BFt5daq7XcESzrXxcEMmeWdhg/QaluWoFpWHSjNxIVl9TPdDQEx1fyhHI/ZGl34TfLPRjE0I1naC1d4t14P+72RNexqft8+Efuo2MM/s8C2dVI+n+REPRQv8z3NyzDr94wpKwHxMTjB7WfrhwjZw00a8NYZb/ICC/F9KKMtmgdecUQSQ4TuC9FGWKpWsDaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b4Dy2XwmrexTRtdGomEkwq0oQxxW+vKKFrOJujDqOwQ=;
 b=IBReRvo5tVeTXdFdhUISsV2PvnKkESLRbOcSDYZT9s8DyB4CqKIGxO0p+Kojz+ojHajPwU3jFE2G2IavtZSzZxhZC1yWz/SUjVq6P9tJeHq+ufCNCTaS4Mu1Xu2cJa4OVep/TAcryc8UcEVBIiFzeiVaT9nTGI0N/acL3X1CdI8=
Received: from CH0P220CA0013.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:ef::9) by
 MN2PR10MB4269.namprd10.prod.outlook.com (2603:10b6:208:1d1::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.4; Thu, 10 Sep 2026 17:57:14 +0000
Received: from CH1PEPF0000AD7E.namprd04.prod.outlook.com
 (2603:10b6:610:ef:cafe::24) by CH0P220CA0013.outlook.office365.com
 (2603:10b6:610:ef::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 17:57:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CH1PEPF0000AD7E.mail.protection.outlook.com (10.167.244.87) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 17:57:13 +0000
Received: from DFLE212.ent.ti.com (10.64.6.70) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 12:56:32 -0500
Received: from DFLE209.ent.ti.com (10.64.6.67) by DFLE212.ent.ti.com
 (10.64.6.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 12:56:32 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE209.ent.ti.com
 (10.64.6.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 10 Sep 2026 12:56:32 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68AHuVsH2793515;
	Thu, 10 Sep 2026 12:56:32 -0500
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sebin Francis <sebin.francis@ti.com>,
        "Manorit Chawdhry" <m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, "Praneeth Bajjuri" <praneeth@ti.com>
Subject: [PATCH v4 00/15] Fix several issues in DTHEv2 driver
Date: Thu, 10 Sep 2026 23:26:04 +0530
Message-ID: <20260910175619.2122149-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7E:EE_|MN2PR10MB4269:EE_
X-MS-Office365-Filtering-Correlation-Id: 3476ae55-8aa4-4abb-5122-08df0f64f189
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|82310400026|23010399003|376014|10067099003|18002099003|56012099006|13003099007;
X-Microsoft-Antispam-Message-Info:
	AKjNMJA19O5nNHOpr1bF/xmob7Xf5i/CgMboDePl1GhRwcXsO9M54XEpIwbNMmttMX0iexvbCZ3X5WGo3mcNWdIctFTt07KRoBdJe5kkg9fk4ByJdhuJAAFje218BC+E9TdBh1UTsUJN8cQw2NGj+unACWSOpzD+nKnzC0WrXWlrLehxhMngMKJVt3b26oGKdn90pkLoPq4MEvYkBS/P4qhb9e6RvRZ1SpdT8FZuHBrtap1LgLi6zE4O1NzUkiuV/aM0oDOF3T5yUWYCyVIeNn5yoyPC88vC3wNiLZCnjfeAnEFL1ZnxBm7xBhAUBxEYPDqqK/LE9Oige2XQQywBjtB0MZkFvgVne33iruWiPa50Lxc8eFR/Ldv87kmSYS7v4JzU4qQu0lBh9tlLyPY/pRQZJO9Z9Aq2ja4y0iaamX7p6kCRWyIr5sGGyhq4241I9dprIpCdk99RnVbehch5jSdPIeFvQey9tl/x5bBsC5oXBFPSS0bP06TPRgzqiezrjrgteC/PvXRWu1eA/s4a6mkGT8RFyKO+/bvL/2Fm7h7IDkrfPhnBqa3lU7vTk4umt8EXaqszR8OlUBSrSGLUpfUEdWfZY2S2BIU643PFIH7Xrbeq0xc1GaVI5c8RBMHLGjAkrWXdlSTc1z0Gy5qBEQ==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(82310400026)(23010399003)(376014)(10067099003)(18002099003)(56012099006)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ESZMlATlb0drOZBNFoeQ35X7+f2eGThonIDODs/0W4OkUZwRCD0t6ic1BAkC+qJ1tSKSr0OA622OR/QQQtI5wSHCzSSsFS956EWyX9NoS1bVG3ViUsZQcKQvYoW99BWev3BeVgSs2mkywjO+7kURx8R0d65bmlSWImue81L7RQRrGiSBU7so+Ufh/mBRLO/LiIUKyO40BmyVzPdWjANZLPmVJAIQS4MYYRFTL4YjPkAaOgqFCBVxrQWKeJAb2G92kbuit1yH9NIgoEZyQwFypmeQ2X1376TFAL1SSti6I1UX0TIHNtuJULQUtxTp+cBCdi+d+qxRjV2dEZRikVgY2/HNqZi8XZMHbAPl1j2zom89HvNISgYMbFQgQPgStcYDSTvk78gbjofh1XZz0M2wFVchXK72bRt5vRItbuyx2GN+sZlwafdEy99R45Iiv2Ml
X-Exchange-RoutingPolicyChecked:
	HVKt6LaoPPYBiutwlFfoCji7i2VQud508DUgV4pWSVFCH7DGIqrdL+7+pfbKdFTo1nxzKqNWHpv6aQCY8Y4t74QPeHCbga0avMxiVbSKBGnnLRnMB8vnsPexZzVUU/j3Bsid4olhSnNw3iwXQg+5R7d4f4Q4HcPvGAtVX6318DlGE7oS+rBx85YRtvAGhqr0DaWOVni85mRepuFhbz/9FAW9+Y6bJuF8npQ2Oth/KdlntG9k/8aHG4pP7iA0vfjBG7o3K52FdVPrk2vdnjNF4dbjRWhvkNXOVZz4q+Wf80ZEqAY49zL+Oic3+R3yc0uUcVTm7AM/iUpA9wiZ510wcw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 17:57:13.2432
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3476ae55-8aa4-4abb-5122-08df0f64f189
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4269
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDIyMCBTYWx0ZWRfXxvlgGtRq7yvB
 N1q4hjGnxozwJy+v6pVf8c0YqHUfBBPv/deNeMXKSjtZQWOWUqs5Gh3YxCvo7m1UYEr93bNATLx
 tvx1Mo6NZUyXVmHnhtSbvYO/KJxXa+w=
X-Authority-Analysis: v=2.4 cv=ON6yTiaB c=1 sm=1 tr=0 ts=6aa2ef7d cx=c_pps
 a=THEAVZb93WkyejmpPpFvRg==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22
 a=c92rfblmAAAA:8 a=sozttTNsAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=anyz7pXEI2FM5XLJWiMA:9 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-GUID: mkjluWt7sx0WD3J8XSqU2GJxvtVINTvt
X-Proofpoint-ORIG-GUID: mkjluWt7sx0WD3J8XSqU2GJxvtVINTvt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDIyMCBTYWx0ZWRfX7e64N8W2ab8g
 fwEUP4PSAKkoY+WJ1BEuC4elM5Qm9/+IIhLH19g4Fo3M57v0JAj1l0OOQyRZ/jM+ubshPgJlrJM
 1iiJEd1MAFzG2t8/NX+TabxVGzzacjQi3KUPRWW2HDofcMALWN353wrt2qD065Xr+r30kVt5i4L
 K63psVVcV39kQBV1xH5F57tl+e18rsusbpgyAXSXMTjJq22sYLkNxr04MQvKwbS1HXO7f6hQKXY
 zsxf6CE1x4cW5sgjQtFEkjupy5uwO08PgUCxpttf06XxHKwlhV+Bd8ANEm5YO6YvZrbEi2L6NBO
 NfvBBMysGTSf7DnWXkGGjBJ7c/LNGHvpxKO+8scdxYnPpORNNK0sYzXn4cQlAxr4fKsQZguM0/l
 LxV8ClEEPLTtN87ZYk3bN4AKzsZIeRUFt4az0ht7vOFzsApliqGGFBS8d9+Csb8VXQ94DGExBlU
 D0cPc0gtfPentWokb7Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_05,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609100220

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
[1]: 
https://sashiko.dev/#/patchset/20260807110501.975130-1-t-pratham%40ti.com
[2]:
https://lore.kernel.org/all/20260613085858.32580-1-mertsftl@gmail.com/
[3]:
https://sashiko.dev/#/patchset/20260613085858.32580-1-mertsftl%40gmail.com

Changelog:
v4:
 - Fixes based on Sashiko comments
v3:
 - Fixes based on Sashiko comments
 - Some reordering of patches
v2:
 - Fixes based on Sashiko comments

Link to previous versions:
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

 drivers/crypto/ti/dthev2-aes.c    | 324 +++++++++++++++++++-----------
 drivers/crypto/ti/dthev2-common.c |  48 ++++-
 drivers/crypto/ti/dthev2-common.h |  58 +++++-
 3 files changed, 297 insertions(+), 133 deletions(-)

-- 
2.34.1

