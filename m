Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B29577E48;
	Thu, 10 Sep 2026 17:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789063069; cv=fail; b=D0BiOzynnnzDVp9s7cSki09DNhr2nmXp2shtjqNmPFGcNR/lvikoNLAVXRCYD2r/PQ7JUwN2piFaBOmb9/oACE2lfo4EE9KFEMcQoCrSQE8SfOyGwW/CzJWAW/4p+YtO1k/FtgdunU/clXcWy3lb4/14I8mg/7g1ZjBhGGCXspU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789063069; c=relaxed/simple;
	bh=JhIYat1tDDHjynnYJrzFdJBgSwjr7d6SfSSJ0/IQWLo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l5OVmT6XpRW1Nuy9qtAs5GUfzggNWL3gw3FwsXjuv0FX2fockELbyHXiCzjno5aQ7DHiqjTC2XjRVct1pJV7vvV0t4AZZcOP5CarLeGPjdK8TJQ7Kj3EaBD30RYrw460tXG+sH5y0wEzLw8wAYD1wQo+4hZrqWfc+YT849ybgHM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=B0CZDQ8/; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=F0DEw5Uo; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="B0CZDQ8/";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="F0DEw5Uo"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68AF69GC3468075;
	Thu, 10 Sep 2026 12:57:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=L3d/uqtROV07wByGxF+hfQgPvMnzChdKYg2ED7CQC
	yU=; b=B0CZDQ8/ifurHJGOhqiQAUthHZ7NLXstxX3JVS251x7BVOdoPlDsVSlTP
	T/y0ZBTPhnXY206JZA3erWyFQQuPzD5Od1k8VwjQS8e9S5sOfg5+Qcgr3rMBXedQ
	xokUj2lLvZbn40sdTUNtmBtmi038QyxKqRGoyRQDrzshJ72FE0Hci708XBzQusjC
	pLAmPgWWYIdgQQSmAVxok6hqbtnDVWlpiuNX1N4bgljN+T08Y7e7nUhUBhV4hpty
	9jpPtEeIafTiR3k9JerHcgU8XPxSPb9IBGngXMsSVGi9F283g7/jzLZM9ZFsAUOb
	fN3wkFJCFTyzoe+X3huC8vgqtCkIA==
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011053.outbound.protection.outlook.com [52.101.52.53])
	by m0380145.ppops.net (PPS) with ESMTPS id 4gkstvb432-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 12:57:38 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xSZ4wE5jXtRoL6KDAj2iHLJSwObqYYQOmZBIZVnDwyIICa5ac0DfRcF6kXSgtIqJXJ5Ry/CyfKGIBPyWcNhSnjXp0+F445rtXOQLgfxNn/bZdUoPVuDKoKio3odKFd/RqMi5eRlOB5syrhMi7pDzk5Fd8oDpymMqffP5tIu2EMZl2sOcWzO8wqhh8diD/+NMAebNyI5zWN+yTEEmYG7/HvqsoH6D3WfRfLMmIMduXimeYRxx4E/Q5isqfGSTKqHaUDIuXkghIb9rOe4mm4TbtrA0o+qoe/m5aqZ19clriHVO7qgPc4i/pVbKURnTHXwyVCaHnh4apRNEsdDxNN0oPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L3d/uqtROV07wByGxF+hfQgPvMnzChdKYg2ED7CQCyU=;
 b=hG5Xe080RpFg2ALQNoWfK2tBtfDK/pSrvBxhDmYpKGRyaW3gF/bfchs6ZxT0n1PpdHo1b8YDTiFr8OT4bjRMlhKcb1/GFzEtM5U8UVy3sKc18dPAEg5Vw36SQL20uQ0xjxYT/5NDQguVTBEKroiEdrlVCZXcF6pJ/b3l4qHDqdCbTcoKgIJbNLNs+V0srO6DZViQwQUAhsamSMSIhgLxOSOrNomrkjK+J9F3Oh+7JLBu1pwtaXl09uWOEI0zjpF6t5xGQbFGJWHpmJafEPyWBix1AB2H79R3mHx4B5KrghZCFcrDA884ZR2WrJWelWwjetevxidXQ2fFE94bdru/EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L3d/uqtROV07wByGxF+hfQgPvMnzChdKYg2ED7CQCyU=;
 b=F0DEw5UonukBMjQ/X9PhrXCxsY+NuyJOWyGUioSFYWOi2lOPmc1NzuMGgis1nrPKMJoC+ArhlXZKkiqwsx0a3KohowrgnxYQ0W8dPVZ/ZeO5DddcdjVZk1Q1pAvQM20AB6oneQQ35mr66fLAyZrY6Uy68llzPzg8ZDMQUX3Ime0=
Received: from MW4PR03CA0017.namprd03.prod.outlook.com (2603:10b6:303:8f::22)
 by CHAPR10MB997720.namprd10.prod.outlook.com (2603:10b6:610:2f7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.5; Thu, 10 Sep
 2026 17:57:34 +0000
Received: from CO1PEPF00012E84.namprd03.prod.outlook.com
 (2603:10b6:303:8f:cafe::66) by MW4PR03CA0017.outlook.office365.com
 (2603:10b6:303:8f::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Thu,
 10 Sep 2026 17:57:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 CO1PEPF00012E84.mail.protection.outlook.com (10.167.249.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 17:57:32 +0000
Received: from DFLE211.ent.ti.com (10.64.6.69) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 12:56:39 -0500
Received: from DFLE211.ent.ti.com (10.64.6.69) by DFLE211.ent.ti.com
 (10.64.6.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 12:56:39 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE211.ent.ti.com
 (10.64.6.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 10 Sep 2026 12:56:39 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68AHucWY3763605;
	Thu, 10 Sep 2026 12:56:39 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 02/15] crypto: ti - Fix spinlock inconsistency in DTHEv2
Date: Thu, 10 Sep 2026 23:26:06 +0530
Message-ID: <20260910175619.2122149-3-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260910175619.2122149-1-t-pratham@ti.com>
References: <20260910175619.2122149-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E84:EE_|CHAPR10MB997720:EE_
X-MS-Office365-Filtering-Correlation-Id: dd8207b8-603b-4567-be18-08df0f64fcf0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|1800799024|376014|10067099003|6133799003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	n1AgkO5ap/e4xBVsppuFoVL835SBx0boKxBzw8nuiKjX51dge1k09qJ1rH55UIdqylarhsuEG+AAWt0QE4HaogYP6uOxZFLhg/BHjNX0fc0skIL4jMDxDgnmXkU1PfQIDAtlpmowJ4xVFZ/JXTxGv8mT96DpG/b3HYPiZcTTRse/4bCczaBKs5R8t9DpESYBRULVnwF5JmM5Pz7XnNtqK8VHkiFFiUufFW0ML+6BcHHwr6BcZXFtJb+m3Qc5h8AvmBiH36QyF4+bge5wrpIvwV+qBmiFpqhosbgunUE618gWCZU3ELN0pNV5jmxPkGnAHRNGxE8NXSX6aWz8NjlxPXyVIIkwSKc2n/zLrJJox474szX0pyKTpe/zkPEvRnqG0j9bigEWjOwyApu12Ae0wkZS3gy7QG0idAhaa0ykdLB1FiiFrYs+KfbSQU2r+fS5+R9KN0j/RsCiIwhTa6cTBbKRWgnDlGCaaPCGEXlYd/XfiDU92+1baU9bWppt83b3oV7FGN5+1CnusoJME0oQidrX5y5xHJshqNSI503n0B1RMEkYr29CBN4J0y1bSiYfMWi2Gg1irrK7AXzpc/uhvhtl73iXMl9hgOhCI0/prTqmERh8zlvYFLAlMspRE3I8+rlxeUslw/wtFWQ3BpHylROleqFGaXTr/EDHblPkwHjmFYbrU8i0dWQtflPpv3zjK6gRnoah/7KlDR3PQeuFeA==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(1800799024)(376014)(10067099003)(6133799003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+ZU7H2IBRgiTJhB6JdqdndVciuOHzwhmCX6q9sm+ve5M7YpuQTrMwvq04mtVmYnBPXkDRL4qj0V+KtNFR5fq2zuMqbntFw18wP3uOZaj0/xwKmVeWjOslU4yl5SOfyfOyfuiHR3eT8dJSqdfXwIeywMLelukHXSXq1Vtk6w22XBrJC9C54tOprmpHf04rqYOYQmoU1ylbNZa88cOKdEn9BItwuYOVZCODQU0MPctDdpK1o8TSPeW/p4vgELD6ayEuVBiWa3Fp7ATStTnP1zv9A+esxoimPiBYRe6WDv48JOuZ2MMxrRzjHB3aTItk4qzXWqSd69JHKZ0LUH2gGlgqon7Yk3OKNH6CqWsBevtnTTIzmrRoJo9mI7Dd9ke3ieVakm+Ziz9Rr4vpPT3oSlfzn5CdgiMARukt4pFOK61SxzE4rT/Mns0sqbIHsKe1ENp
X-Exchange-RoutingPolicyChecked:
	pwXPU5L6YciTCjpc6gq5fncbiMy7OY9973SOOR/KIsChBZqfi0XfF2Xbm7uDcr9lifO+VrDvr1SLEyC/Tkv0deGqf4VVQlPymF2r/bzBUf9UmrXAZlGdN3HcaHeDSst8IG5DNZ3KBiIchQesolBgShfRiyrRjaXrQkH3wFZhBS9SUPH9noMKQTnzw1RQtJqMHjyya0tbkuVsn+lCJZK3k2i+aQh8TeA0NhuFzxkhE++FWYhDOH1N5Cve+D7+Ncn0J6v0orHCWIvWgzy3xWFSiM4eGEOsnWUsZMVzmEFsK4iddDUruvdkGkpaiqzi7ph4Jn6t59TWb6bO5Y49nOoKYQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 17:57:32.3321
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd8207b8-603b-4567-be18-08df0f64fcf0
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E84.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CHAPR10MB997720
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDIyMCBTYWx0ZWRfX78K/ZooPGL5t
 ERLJe6a7aejtIuhyBaGY9zHvfR2o5Y7+maxtDtF0s2us2A1qTXdIyCcR2pFNjNwzZUCJfhskoRD
 Bm11qAiVuIHNR+DVYMPOuCLsMPiBUHQ=
X-Proofpoint-GUID: AFunQlaYZ8Q3zlSuo6hoZzErjsF2d0QA
X-Authority-Analysis: v=2.4 cv=VvG2kO2n c=1 sm=1 tr=0 ts=6aa2ef92 cx=c_pps
 a=H9d2Io+6O/etw3jU54J+0Q==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22
 a=sozttTNsAAAA:8 a=ki2JzQWVm1jR-OH3vWAA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDIyMCBTYWx0ZWRfX1Gm4lpJF3czL
 jp/CamWzQ4PpwF7aY3mc2PsmmUMDj7Nza4oOFME4MM+TWQ4bCqt+g2Z4tv3myffh5VK0ZltfSgc
 nG3EhiCRWknfvR4Ax/+7pK71/ht8WlDhAMU7X0oe2Js69eV9JbCLWNhRo+Tth188X0Py5pOUIGl
 JRPE6/KoNOC0bWomRKSt0EiSv9XDSNJTzfRNuENZ3yPyR+1w+oibYogxGS86NjnXmrZfuFrvA63
 oLg39S5bsP7s8sSfCXcETuFQasRC4b7t06QrLP0/Qnoeglbw0eoE8zYdznVVUrBY01V5OieR5GE
 YT+xIqPrYKCAvN0snu5rdTh1U1tNIoZT0ZINCIBTysa/EhpcgQbozftJw0Etx4aNy7advToaCtl
 XJtXNNL4wYkVXGlRtX5EHScbEXRa9NuGgvV8sFwVggFrWGJexDL8nx62R6pHmcW7vdDUONvl6qZ
 /pkcNvhUHuFekRTHG7w==
X-Proofpoint-ORIG-GUID: AFunQlaYZ8Q3zlSuo6hoZzErjsF2d0QA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_05,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 spamscore=0 phishscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100220

Probe and remove functions use spin_(un)lock for acquiring the
dthe_dev_list.lock. But dthe_get_dev uses the bh variant. Change
spin_(un)lock_bh to spin_(un)lock to avoid potential deadlock when a
softIRQ process tries to acquire the already held lock.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index cc02449382673..4c6b72ba104ec 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -39,11 +39,11 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
 	if (ctx->dev_data)
 		return ctx->dev_data;
 
-	spin_lock_bh(&dthe_dev_list.lock);
+	spin_lock(&dthe_dev_list.lock);
 	dev_data = list_first_entry_or_null(&dthe_dev_list.dev_list, struct dthe_data, list);
 	if (dev_data)
 		list_move_tail(&dev_data->list, &dthe_dev_list.dev_list);
-	spin_unlock_bh(&dthe_dev_list.lock);
+	spin_unlock(&dthe_dev_list.lock);
 
 	return dev_data;
 }
-- 
2.34.1

