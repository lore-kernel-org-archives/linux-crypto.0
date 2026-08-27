Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08222C031E;
	Thu, 27 Aug 2026 13:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787837071; cv=fail; b=OhQLjYEuoxm2RbXFw+Y1ZD4g5SJyrg9A4FULFoBQ+XJd9brOZ/UinIy37N/nmYjzVoPRd3KdzzVRVqdDEt5AHGQWdNcPJX9RBTG41BDAKOL5QgDAlLd77nJhc3/1RiuV/9J52+AEsQkOw+93OeA2J29U7AnAggRANJzsJvHf9a8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787837071; c=relaxed/simple;
	bh=JhIYat1tDDHjynnYJrzFdJBgSwjr7d6SfSSJ0/IQWLo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gm1V6L18CquNUSKA/7uc6JNMjNOckpm2bWNmqLin1tvpb8FUsA6f76IRO7/ASEPSEcpy4uT6sW94mQ0E5IOSVi249rrRx/aOPHz9xPxI7p6hnv9bSBssAcG7fGoDOy8RVmJhYTWlSeJsWBp+iqGDCThm0AsCXOZFHlU+qKT7E24=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=FNMl5OSP; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=VQovZvdC; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="FNMl5OSP";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="VQovZvdC"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 67RCA9R02915293;
	Thu, 27 Aug 2026 08:24:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=L3d/uqtROV07wByGxF+hfQgPvMnzChdKYg2ED7CQC
	yU=; b=FNMl5OSPp7DMC20VfDUi2xlLzYJ9FKHf+tf4h6YYy6msMqyPIcXkxrdBH
	iEEGpsyWy0aOw7caFYk62HVIEAyDJeRcjf2Ouj5qwmxn5uhG6/jElHejQfBjwRYZ
	65Zd1Bl0nMkn0v9UkEHkzSWBlMBgNEWUP/YG/rXqjPhSmrBo0+STt+CayRMy1F+G
	+RJlGI0tz3BmO5CdSVjusf5RHbCh380NUVu2FHg6lJIkX7uiMuAT7gjKBR1MgiPA
	yCRNJWEv1RZ9mOWQXF1B783FczNwMHP9mt+KBh97brDvdIxrO13i6UYY5Lgdhyu7
	JJsmrFx4xCgnCnXEs4lCGwAQnzkSg==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013045.outbound.protection.outlook.com [40.107.201.45])
	by m0380145.ppops.net (PPS) with ESMTPS id 4gahg39dcs-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 27 Aug 2026 08:24:23 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cy8YkwuA8eQ4p7izLte6o+AOPcAw/awkzb4JqM8+W4a0G4h9Peq/ZdlH60Nx1peu+Rto3h4Kj/rD4oAk39T1Xd2qjCArc7HE8xD1iRkmaMJX+TlXgtw/CT2EY5iAlT6d69xzzvIcJc0CYd+G+vI74mwqu4LQWxQ0FpHoMZ3AuUve6Ffip0KwV2SMw7RvqPGNdjK5GVQHj8blYUhxD5DTER9413HoG8yzImUvrY4FaY+gNrdApBeM0GIsxMa4/aAOL6ofQ4EuEmvMGGyEJGTtZa0UVuGjMOnzsiAmKZH7RLTKxTMj+Ho6BLzyWKikzT9NF/TLoGk8f4GuAOsTHo0EFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L3d/uqtROV07wByGxF+hfQgPvMnzChdKYg2ED7CQCyU=;
 b=u4OqXkoIqxqJD06XMuXEEBTZJu4ueDAWTMne8q3MlSIMrCf9R4rn2dCSpnbUmhUnZW6ig0JirKZKGHSokOxnqAMUCXDHIJFDGiCDZ6xlQ5WteGlXJUu7D5H1REQO57jZIpsOStwfF+hYsd1W6dnSVyT/5shxiV6gB+w0wYpDE1R1Z78DbGymTI48Xlc9qqgCXqeQUv2ogjzZFsWWmytcuCZ+RCtKqwprVE9YItDXVevmJbaztoKIt0c4kPV8kTbjuvCFrUsQesMx2itn7KKaXcOL7R538Sq/YCuhVEeyFouR814oOTxbgXQmTi2wW4TIpoQ/vgGHhqI5htAIezNwQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L3d/uqtROV07wByGxF+hfQgPvMnzChdKYg2ED7CQCyU=;
 b=VQovZvdCLpuu6e/6qKQzj9nZG+RuNkwhpYzQ0UeI6MNDb2qLqSFsOjHMB8uhFOqKGr4b0pdbPqUae75dlqbr4sUq3aGuQlQRHLKAAt44jfjJO3zWIjr5ScRnV++ETObHrMYsY7OdJqpAXDtoBNr6fbw9iZpzwSz9duyQlULWgo8=
Received: from CH0PR03CA0205.namprd03.prod.outlook.com (2603:10b6:610:e4::30)
 by CO6PR10MB5651.namprd10.prod.outlook.com (2603:10b6:303:14e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.10; Thu, 27 Aug
 2026 13:24:18 +0000
Received: from CH1PEPF0000AD82.namprd04.prod.outlook.com
 (2603:10b6:610:e4:cafe::99) by CH0PR03CA0205.outlook.office365.com
 (2603:10b6:610:e4::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.10 via Frontend Transport; Thu,
 27 Aug 2026 13:24:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CH1PEPF0000AD82.mail.protection.outlook.com (10.167.244.91) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.3 via Frontend Transport; Thu, 27 Aug 2026 13:24:16 +0000
Received: from DFLE201.ent.ti.com (10.64.6.59) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 08:23:36 -0500
Received: from DFLE209.ent.ti.com (10.64.6.67) by DFLE201.ent.ti.com
 (10.64.6.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 08:23:36 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE209.ent.ti.com
 (10.64.6.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 27 Aug 2026 08:23:36 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 67RDNY5X894060;
	Thu, 27 Aug 2026 08:23:35 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/7] crypto: ti - Fix potential deadlock bug in DTHEv2
Date: Thu, 27 Aug 2026 18:53:13 +0530
Message-ID: <20260827132318.613876-3-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260827132318.613876-1-t-pratham@ti.com>
References: <20260827132318.613876-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD82:EE_|CO6PR10MB5651:EE_
X-MS-Office365-Filtering-Correlation-Id: e7086b54-b287-46ea-20e5-08df043e7e2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|376014|23010399003|82310400026|6133799003|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	+AbizqspExR+mBEuPdZ/VeEyE7NtkmmyF/Kk+Gep5Rw/Tt3cnZvG40wH1ugC35F+LH20EV6iXz+Z9wLf/mtc0VJpjAigJq+jU4IhJXuv4EyiR2FHsKwoqBKej1i80yMZOq3Y4UX71cEvvFu3ajNyI2xioDivnWbkQ0qqhO4bbD85N/ad1DhUGuU7wLAkYYmcDxioTUDiKbkA9Kn99CRxVE/tWhTZ7cnYsCT3bk2htVpNJL7DcHLOEoheMwGs9XoXUA2tPpFGVfbHIAiSzLmraGg+rTFZVYsorHC5W1P0EJO2rRcczbaTSwMzXYrTQ7HlxMmoYStFn0npsn6ygH9l1W3Ky1FUe1B5RC6hCI+sRm6uSxw6Ais4Bj35GNG7a4RTyeqTy7PCw6CmCnYQgI974x+3crEZbPyon9m4/pWDAGXSqx9cSzSWW7nggok2p3Z5+6caAk8PYhGh0oXQmFT9Qf0k9qtg8ulBgFuW79ShUmUidPJK7KEW8zz2/5U0OAEplQ5WUO4TrZtAsX4ls5WSfZ3bzylcrEszOsOMEnwDGm964Ir5Mb/R9Xj7RbZ4TRKmXw73bbl4/Yq3F6ACir8h/wlXzRXrUBtEMipHnook8cakeuqssKpJc6DRhpAyDOK5Kh5aeOpI8PNkxh8/TbUrwqM24T/zx2cQVWM8DMhOIrH+u+Mk220b4et3S88MvqjgXcWQ8Q74Sa7014csbMriew==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(376014)(23010399003)(82310400026)(6133799003)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nPBu6DGRKsHwDdq8rxYuaDNUPKQBXl6YWfr9XprZD5EVIUHHPlwKsxyxavm2pjCWL5UQeJQc8XgcOx487rF1Wo6+RBS8PM1KP2U5Jx9/X+II4Amb/4oYFM8iyieJR2m+sgFXmBSWPVwVLmTnl6pPB9jHVZFqVFs0qZLK+rjQhctHH4LcP2SspGR2FfphMloV/lp/1CN2Ojny/YT5niIX5LJGDo0za9XFYAyXLb/d24Iq2dmtRRZbnPU//P+TXOBN/fenFdsZpL4nyGs3z+B265ouRq9Idst5ad4QxXJ+pVlB85pPbu2/ptVHV0pOpLAhryXXZA2uhewlbKwEVM21Kj8tlRYlipx/TTIKl8w63WmtFWk6NYr4NuzHNLs8dCg6P4aoZHJzhyhGCLeXKEezCyVgemF0/TSwrSaIvJTzuenJNy2BOp97IDwo/OkdUxXq
X-Exchange-RoutingPolicyChecked:
	EZhAtSrXX+EjAOxPH55LTSMB9DMRzdlGGGjW5ivpiN8bWlKFfvzHmxI2EawqQeboM9Nx0tQUALChzAVj4cuMeFJZbsoBr9h1u1CdqYr2z0uKL1OVQNfcoCyUsvOo3K7KeFWoOJDouL8QNTBKAlP+MeirkUzfAVqQ+t1SEtBWh2fEyAtrDgrrf3Gf1E90YLAZnIJB/+k2LUc9h7RTtBq2TQilzzPHg/xPcK0w7TNjv3/h+nsHe8eVjLW/KJSFi1lKSTnb6CilMLDGyPLCCwzezOVRMQ9PMS7HO53toQ4ncfbjbeQG7+XBEKGFaYyOEcyf60RvZEKpl3ymisfUvrEnqQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 13:24:16.0389
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e7086b54-b287-46ea-20e5-08df043e7e2d
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD82.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5651
X-Proofpoint-GUID: iCwOr4ky15AlI4YSSh1jJ9hBKYkntTgW
X-Authority-Analysis: v=2.4 cv=M4597Sws c=1 sm=1 tr=0 ts=6a903a87 cx=c_pps
 a=IhFJ2QRitvxj7yHj5jvJkw==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=Sv0fKeRqtYgA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22
 a=sozttTNsAAAA:8 a=ki2JzQWVm1jR-OH3vWAA:9
X-Proofpoint-ORIG-GUID: iCwOr4ky15AlI4YSSh1jJ9hBKYkntTgW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDExMiBTYWx0ZWRfXzJQ1/WEUJjDQ
 C1Rk5IxE1VMY3rMkxUO71io2LCtKZ5UVB4d8fepSbzrr2/KFbYsHVKVrpwkDOUG7wBgAOsX/Bhf
 2tS3jGK1994g3zCdAb5ks7ev48hveF7ML/38xykTjYgy+5OYoaZnLkmcp78oorVy31BchYmAOwA
 ZDx9l54PLpRMhbcgX77TC4f8as5R1ZaZlYrFoHybKH+s0CliOB8TS3cC1UO402qLw+mxsHdocCZ
 tukqhroupLvHulEg6zo92sdTnJNLoqskrSnbBiiaeRA/zDBoFgPmvw2Azd4d5BAfg9EoqcSLeOD
 i0v+8DyAA403+yRqo4jeeFxYNQk5fDLHK1UWfm1xKs5r3is95lxGkBbUTy2nZ4gjY4SrM8FPpM8
 /FTa6PwioDgXdPbi+gEaQpfQXLN6JR9MmPuR05JfFFpvaSvihKRuw2Jxo+125AjXztLCd9x3v8o
 bTPkOHlSi6RxIimJAuA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDExMiBTYWx0ZWRfXye7klpOUFaX+
 gZWUQQyhyLwL1zPv47RkfP0L6RvQY83tC5+7jUlOudENUvkgUP4N1mwMm2enCqmP/oRztAom/c0
 9okbsZGvk1wrJh+TzjgpQkCUz4FYCS4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_05,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 impostorscore=0 spamscore=0 clxscore=1015
 bulkscore=0 priorityscore=1501 phishscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608270112

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

