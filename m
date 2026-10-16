Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1934A4843;
	Fri, 16 Oct 2026 12:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154753; cv=fail; b=FmLEHt9DiAjFCKc5bqGCrnEbMDPwOQ93hBMrTnV8tblGk4ipeLdC/GOwQUazUoj22vlCUiDBhA1MhHlNvA4fHLEHEdpl4lJ0hOMI6xcHyfJPWB2jcQ33nzaytLWxPZQWf00w0EJppq+rRaq21B7sCfkZZoPl7dQJYywWWkG1lFw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154753; c=relaxed/simple;
	bh=id1XHPnmhNbRL2J3dY73MCP04kxkLhJ6NwjPKg2WrXs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KSz5+DTg8r67erCISzCAzowfjUeYBj5ozhw0V1BApR8AzqQPBYXuBu9ap7fLJDKcwuK+bFHNQ5wW6WBNSpQDa85FHCBsxCQ2+ZV+ZRiIsV2JHoctHIt+9Rf+UVGLDIRq4cKbfpTfw4Uuv2dd8hJ++wJdABO/Gie50DCij8ZcFiE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=JLZmwUnT; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=A5/qIVj7; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="JLZmwUnT";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="A5/qIVj7"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GACtXX559831;
	Fri, 16 Oct 2026 07:45:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=vCHq+InZ8p6bDRhkvfnvEAa4i7X2vAXzwTY6dx/KN
	lA=; b=JLZmwUnTNk7Pg0GsVksYh3Q2+VjGZv6yzQAuoXc0ei9bLw9flE+j9ZZuK
	ZPmf4vSXlPJd5APEpI8RVnTrIWWK5X8HBLfa6B3ei13fdpXSjp/Vjjo5qxnOL1Cj
	CJsW9I6SYi7CZD5walM3Gobjdh8b1kIdHKZgVgnaFc77A0K64Tw5NCeAHEjkGyp7
	6Al1yPs98CiVQEwDZUKKnOQx+hhzYltJ51JUS5uBTPPcN/haZvF+z150skNhCQUs
	ISefers6xjS55smj/UNeqghurKIrKZ/ee9xO4WR1/FRmZ7dUJr/KLZVsjnZsosDP
	brBUDXSJrTBS9w4VLSj+4hyVxWouQ==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013004.outbound.protection.outlook.com [40.93.196.4])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hbhbd8sep-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 07:45:47 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r2JWesK6yj6mqdx1yZG4kj2l4lHPkywq/Wtu7mDSMvoHbPmtJkyBvMM0SCYJdmyj9jw5LQ28AIv9fzqgzkvQvF13ccKHX+u1uqAW2jKuApUZysEg3/3hJdijRy+42uRkNQNkRqxs2Kb341Wbh+kFO0eYpQE9991JEeRGwrvpiTARbFCGzmUkFj1O352Ar1ypwk3gSFlSRbneixAgLT3akIf0QI9FhOJ+lVAvgyzQashUrM1w1a/oHRdFUK/2TqedNqML7W5wAkslvkOC/SFfVRr+dq2Q1yxQpoioJlqVz4qKZqGFF5CdUMjOTEl9lh7Ax0fzCPPDOjFKQn6tIwkjpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vCHq+InZ8p6bDRhkvfnvEAa4i7X2vAXzwTY6dx/KNlA=;
 b=hIKLct0/nzSuoa5FEaiZXEaITrwNyyT33KtJXkcZQv0s+YhP5p+ZdTYWj0A/P80+XaRxzLCIuqe7MaVODLuDCb/scjQvOwWmc/zGWvPKrGEe2flowrKaw6HEZJSteIktaRpP493co3RaBsSjBM498cZfwXcR/5xbRU0yDGAtr/ClkWXdDOUinToQ1yF5S7Gn8BQOxlbIqQWRkLPQx70m5vUP+sKp73tR5QlzCQfWbBILhjgfygTdbcxl7Fb1rMHv4/43DIdw1wEr/5LsmQa6eJaroL0jk98hblB7Q42kqjZDfifPCsxLCkbX7SWZyXcu9pzqV5Eq3HSrCJUoKfRi1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vCHq+InZ8p6bDRhkvfnvEAa4i7X2vAXzwTY6dx/KNlA=;
 b=A5/qIVj7Kok54SQs52wkNK/lYOsuNfK9Ttl1uxbDx9FJUfG7bNYhbRT4aMGP0VZ0XZOqHlPxgfDuVdLtaXR85S6TbDhls+sdo7PNAo4q24wLJjzptdrhyX+6A9/fYfGTBh8YG6Uf2PaDR6wT1Gp0HkJUG69aciAGLKkq5zYsIlQ=
Received: from BN9PR03CA0139.namprd03.prod.outlook.com (2603:10b6:408:fe::24)
 by PH7PR10MB5877.namprd10.prod.outlook.com (2603:10b6:510:126::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.7; Fri, 16 Oct
 2026 12:45:44 +0000
Received: from BN2PEPF0000A98E.namprd04.prod.outlook.com
 (2603:10b6:408:fe:cafe::81) by BN9PR03CA0139.outlook.office365.com
 (2603:10b6:408:fe::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Fri, 16
 Oct 2026 12:45:44 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 BN2PEPF0000A98E.mail.protection.outlook.com (10.167.248.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 12:45:44 +0000
Received: from DLEE212.ent.ti.com (157.170.170.114) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 07:45:21 -0500
Received: from DLEE214.ent.ti.com (157.170.170.117) by DLEE212.ent.ti.com
 (157.170.170.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 07:45:21 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE214.ent.ti.com
 (157.170.170.117) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 16 Oct 2026 07:45:21 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 69GCjJ9B1587571;
	Fri, 16 Oct 2026 07:45:20 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v10 02/15] crypto: ti - Fix spinlock inconsistency in DTHEv2
Date: Fri, 16 Oct 2026 18:14:43 +0530
Message-ID: <20261016124456.1802080-3-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016124456.1802080-1-t-pratham@ti.com>
References: <20261016124456.1802080-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A98E:EE_|PH7PR10MB5877:EE_
X-MS-Office365-Filtering-Correlation-Id: f41d4d17-a100-437a-c9cf-08df2b8364d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|376014|82310400026|23010399003|56012099006|261009223027099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	wpSbkgUVXG2j7TLoUBqmLJZINLzivWtL3nQYVMMeH0Wz7mCRkLOXFNu0y3z55m+rxdnqFgjpsYWIq18gEdEAZ8s/W5KIS88o9smE0E8uEyrZHwU48toqX0+BIQ3HQ+Bv9oSqrNt5B1Q/ipsff09HZtzx3oF70vLBJ2OrzeKQXMo0sa0XLZSaPvrwG4erq+C+uMAXle8b9UYLlQh7HgMGjRU6HTP7zPNaDOllFeGh/2ZvT4QaMQkV7IDb+/nAZ95VdKkiWbI4s2mMYEyd/OafzxJdgOH6VbaeqOsy2IZdSnSEYIeTZFfhKt3BdKBkZSm8gQCK5fYqsMaZs7JtJS8wu6IjJ/8jkRDKPoYKBCVFNZRFX4FUeyDPwFIKIpsY979w1+p+ofCM4wO3vw65dWm3bEgsGiYKt9mZQvirbL5IL6otPJTHDq3qRAblAfwsPUuH3c9iwR8Ep1F5p+yy1BC5YEMRMNnFD5gkNnYiibq7EtJaoOIdC0KrdHFluK8UVeAFxUotgcmhtYNUmXF94rJtX3s9ANWPpH/jP2NSoKMRLuVlGD5JG0Wgfr1ZLULzZJvZtMUjcd/JpwbzGbfKSMi7JBqXxbWzKuiaeVKojVaqvmpyYByFrEnnxnHHLcxjsWoeCP/jo3yC61Pcor2GJjXYuEmxTiIJF4L2cweOBc1+WTBHqoqFac2iHTp4vhO1kQk94QsNFVk/yJ8pDXpmA0mvsg==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(376014)(82310400026)(23010399003)(56012099006)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+lVfCNsaAnfoJHL0w4KOMzCfyAMAcdGF1uIFcwk8WTcWtch+SjDVCuEI45z3XVP/xwjZSfx/Pk7b+Tr8gPFDE4ijz7Dx9rNXD165Eei3AG8GeyK+7mJ2sQJoLBibiMOzwNfV4USEg4z+iJQbwGgPWKQhFlVVkRcmt8bFobpoCrViP9lxPLGdh6592Q61Vw5ZJhcOfUFImd8QEbQUnwmz581TRbQbix3wcUk5KmAAGhAVRDdQp7cIJ+l4DfuvdA5rdYbyGGwmsel8h90cJwn18ZEodtaAe6SlNb0xJwbvnBbhef0sFKeaOXW3TBumcj04CNKgGUc2dIWZANWS/CJ1uXlHrRWMgtf0TXI2bgPyGlXSJTb951f9OKwwuU1E2my3FU+ORMeFiEM1PL6RElp49vw2j/7iYKTFQLjaTUx849Lo8XfCsGLDieSgJ2lGB+nM
X-Exchange-RoutingPolicyChecked:
	GxK2K8s2y/6pvsWVx1AtUbYzmaWPC4K6ZDT5am1IZ257UBF3cu7H25YJ3tFiS2HpbfjnhlRJ/0I7SUV7iY1N3U8nlTIYiDG8PvnFqthevZABd7ByifH2bdISEE9l4TVpaeUpwmQn6mRt/SeU3ohsyOeu1MFrhaZXxhq6Z6BmDy+K54/MFoAUbHhEOVOvZo6O5hS0elNHHSsSzAO6wTzePylRWv5DXv+0cnwjgrLBZMVcps++UFYajVfQzkajZb64LcsjtLIAq1KDxkF4cDkjjxJXJjPbUPtdVTpiqD93pF3d158POSC6gM5F5wNnA6pySyIw/snpBDSc/uXbxC8LkA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 12:45:44.0864
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f41d4d17-a100-437a-c9cf-08df2b8364d1
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000A98E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5877
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA1MCBTYWx0ZWRfX8G84oSAf8x2J
 BwHSoGr99IXhNFee92FKp0mXig46K131GuCYkPVX3SWKi3gelXyUar6LvIhcfXCBZcvD7hEVbca
 zBnGk74yLzIG9TZu1BXkAc4BHoGUE3o=
X-Proofpoint-ORIG-GUID: jSpI9sxl8_saTD3K_sxgdg8TOKCBLl-J
X-Authority-Analysis: v=2.4 cv=BooIUoX5 c=1 sm=1 tr=0 ts=6ad21c7c cx=c_pps
 a=pKtxidU6TXaQx3FGc3VI+g==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8 a=HiAi_RwYt-Wiez6k4EgA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA1MCBTYWx0ZWRfX+zyDlBYw1GvF
 RS1ndoz1W84dzxG1OFLJPn9mbG8xm/XdK1SpsseqCI+GDewIP1PyAAYRx3cMRuCHwp51agQN0HK
 nRpcVO/gpZ2c/cRHz+M9CjzvC/sGDuSGuRdeYdSjmS8f9IQGl4LRwSn0oMYWKb/zs/oVPWKhXKf
 Lijv0TxIpdXN1hsrOJe4uHowarNYkog1nfn5t4swFnIU/BWWpLethKv2XThI9fCyTKmgRPH23n/
 2mOHc25rFeEG/ugKZiAmsja+dUoKkCWtR7PJ5o/amdmQ/pkbsQIs5Gh5pFBio/Yv7wHRW1t7RGy
 fbP67jnBlShUC5GOO2mXRHb3K9CKs/euWeklDguhy59xDUMJUxzvlGdv+B7xxCY7/K5XLrbu0aL
 AxY7NuPpCnHRpZVlqojn+NBoP4hffvkJWmcdweS+HLFAQNrt1dqyOMVdgyEG5ue9zw0MI1WMm6w
 59izUk9ChR72hwKcQ5Q==
X-Proofpoint-GUID: jSpI9sxl8_saTD3K_sxgdg8TOKCBLl-J
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 phishscore=0 adultscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160050

Probe and remove functions use spin_(un)lock for acquiring the
dthe_dev_list.lock. But dthe_get_dev uses the bh variant. Change
spin_(un)lock to spin_(un)lock_bh to avoid potential deadlock when a
softIRQ process tries to acquire the already held lock.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-common.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index cb4b8b38a5ec8..8f8c4a93af616 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -154,9 +154,9 @@ static int dthe_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, dev_data);
 
-	spin_lock(&dthe_dev_list.lock);
+	spin_lock_bh(&dthe_dev_list.lock);
 	list_add(&dev_data->list, &dthe_dev_list.dev_list);
-	spin_unlock(&dthe_dev_list.lock);
+	spin_unlock_bh(&dthe_dev_list.lock);
 
 	ret = dthe_dma_init(dev_data);
 	if (ret)
@@ -189,9 +189,9 @@ static int dthe_probe(struct platform_device *pdev)
 	dma_release_channel(dev_data->dma_aes_tx);
 	dma_release_channel(dev_data->dma_sha_tx);
 probe_dma_err:
-	spin_lock(&dthe_dev_list.lock);
+	spin_lock_bh(&dthe_dev_list.lock);
 	list_del(&dev_data->list);
-	spin_unlock(&dthe_dev_list.lock);
+	spin_unlock_bh(&dthe_dev_list.lock);
 
 	return ret;
 }
@@ -200,9 +200,9 @@ static void dthe_remove(struct platform_device *pdev)
 {
 	struct dthe_data *dev_data = platform_get_drvdata(pdev);
 
-	spin_lock(&dthe_dev_list.lock);
+	spin_lock_bh(&dthe_dev_list.lock);
 	list_del(&dev_data->list);
-	spin_unlock(&dthe_dev_list.lock);
+	spin_unlock_bh(&dthe_dev_list.lock);
 
 	dthe_unregister_algs();
 
-- 
2.34.1

