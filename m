Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D154E415F1F;
	Fri, 16 Oct 2026 11:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792151333; cv=fail; b=Hjx+z9vbAHkmYRDiDuqijhcetAkptxSvh3NiSUWhe6K4cQ6NTzG7GeLEllVOfExysloPQ9nYUXYvfXvxugHmWGNirlRd8HeqBH1uDKrw3mk9DKcLvva1b+uDdKmZWqAfv+lMEwWkcUswYTUTfF6rxiPR3bFp0E0WqKcV9Gf/HIk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792151333; c=relaxed/simple;
	bh=id1XHPnmhNbRL2J3dY73MCP04kxkLhJ6NwjPKg2WrXs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CfXzlkH2g8+pQg6Qs3k4KUrxKZ4dOdlzIbq/P7Ze3XuwDSl4iJHplauS2qe99Kt/flOujL7fmUTrPSBgwO/588YoYUqbCDYdBgI2f7D6IPJQ95ZZoKpe59hAwt+vtyPENeujVIcVVIJSWwOkGFPyeaDv+2WYVro2UkzNNUpBZo8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=f0gJWlsb; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=DOWFxXYe; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="f0gJWlsb";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="DOWFxXYe"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 69GBOQbq492119;
	Fri, 16 Oct 2026 06:48:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=vCHq+InZ8p6bDRhkvfnvEAa4i7X2vAXzwTY6dx/KN
	lA=; b=f0gJWlsbLTzNHroU7ZRDh6XarcQqzY/3/K5yRTXx2FC5ak/K+R1k7AJPs
	l5dwBRiqWMBtm3z3s1ff0IABuS5/FMIfPUUgh1Yj0TRqIXFCEbDgsp1yJtMubFbJ
	F+WVPG2I/VukEn9DPnSOCenfLKhoGdmWJCMDzBi3JRgMXVIs7o6Nm+L0t9+5mzQF
	QoJwmEJ4EB+WWhZtLm69NugwJclhS4hss6SQNX4QIpIpYGvCPiTkgGDs1nNwYPuM
	IsuLG7d3GqjEjmDX8jobxTm0SUue8SX4bRuXEoGuwwLDBjCT5k0/vniAXqMILfc7
	UsJQc3KBTAbQKN5k7Dp/mLVPjoZ+w==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013065.outbound.protection.outlook.com [40.107.201.65])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hbk12g3jx-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 06:48:48 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KkOQVZMjuI7oMpKz0rNUuadjqGwbUCZbkgd0zj7pLKpB96SYh4oq8SwBjqTsi3+9Uz8HADOoX+dw9ShQTM/4yYluBMOkAG5XCzdVhsOhKYba6r3WiaA7HxTI41wuLzw5EsPaLUDCLdH6zk6TNUf6orbKmIX+NGOMlD62Q011BEHqCJrMNL3ITHlm3WsaFjVNobo4z+Ms72CDU0e9WlNRGrdYhh76icp3uY2lgbDMUoYkjUC1tRN7E9IxrG456CDbHhRqAh9DjeMF0ZknczzoenIP6PA+WYbXA8mRzKMasSPIpbtDeSOLpMg85yd3wn/7EHUb1JrSM9uK7ggbAJxjRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vCHq+InZ8p6bDRhkvfnvEAa4i7X2vAXzwTY6dx/KNlA=;
 b=aOfqkgN2+SrK9GrRpyx2RCjgJS2r1tCB2BgIKUxuXKDgH10+MF8sfcZWDh1GS/kHijs7PB25v80xMBjMgw7gyIQzScvP8qcgEYnhmetf8sBOZWhkJWswen4c8ZwNXXXTrdTT8O9kxTs7ZREtvzaGFdQHfNCC6ACuix7bvoRjsq+GgCFt+duoW5FAmBM3YN8/g2AtOSantsASWCQxfMGIK1dE0C5/OAtOCuKFteOX/CV9NjqljUZ75gqRja6WS+bouyH2VT8tT023YTttnPJa6WHj7VWsKsSdWzBuRgG1YAzL/D69u0S/ZXRX0fJuuoi8MDczAg+OB7mm+wKPicNTEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vCHq+InZ8p6bDRhkvfnvEAa4i7X2vAXzwTY6dx/KNlA=;
 b=DOWFxXYejZQr+S3A8n3bkndanX3Nqatp1Ia1azahlYZ3OA/G2UVMZ6ERxwh8e5FZR/y78cUvd9cSRUlsHgJHJAgxiL1fnkniHn+NBErRMgwpkdvZ7a5qAKvX6Sbo33aEDiRGdu//LEfSCkiBpVnx8olxTDBq5ybM8pGj39X8lL8=
Received: from BN0PR03CA0004.namprd03.prod.outlook.com (2603:10b6:408:e6::9)
 by PH7PR10MB6674.namprd10.prod.outlook.com (2603:10b6:510:20c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.7; Fri, 16 Oct
 2026 11:48:45 +0000
Received: from BN1PEPF00018074.namprd04.prod.outlook.com
 (2603:10b6:408:e6:cafe::5b) by BN0PR03CA0004.outlook.office365.com
 (2603:10b6:408:e6::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Fri, 16
 Oct 2026 11:48:45 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BN1PEPF00018074.mail.protection.outlook.com (10.167.245.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 11:48:44 +0000
Received: from DLEE203.ent.ti.com (157.170.170.78) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 06:48:28 -0500
Received: from DLEE202.ent.ti.com (157.170.170.77) by DLEE203.ent.ti.com
 (157.170.170.78) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 06:48:28 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE202.ent.ti.com
 (157.170.170.77) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 16 Oct 2026 06:48:28 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 69GBmRNJ2451405;
	Fri, 16 Oct 2026 06:48:28 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v9 02/15] crypto: ti - Fix spinlock inconsistency in DTHEv2
Date: Fri, 16 Oct 2026 17:17:53 +0530
Message-ID: <20261016114806.1749515-3-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016114806.1749515-1-t-pratham@ti.com>
References: <20261016114806.1749515-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00018074:EE_|PH7PR10MB6674:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f19050b-8185-493d-4142-08df2b7b6eab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700016|82310400026|23010399003|56012099006|261009223027099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	3O9Mk3Ioa4gMP6/e8ghvyDkEzqs5DM3Qg2aYhMo6qrjHDba7exj45h1o6OMroAEBrjLLV08DBeAAGdwXfAXjDmKc4w+uv0yevODZY104akjKp8dQWWGPNwG6xUdAnFzzqiMNuXWR3zxEuYCiKhjMKU288uuofW3TEi/SW3mD8IOEPC4DCcguo6HyiBflJncseI3MchoOZYm3P0ZcVduLisFDl/dRgxLwO3f1He3GL0AIhSpopwmihC/PmDwYEivK+YDHPV51WrePE+LOLJ1hzTTVdcAMWCjVI8/A62P3TK02QoFp7epnmnUn6joXjawC1iUir9bXWi8X8kTE+xt8d7bzOzu3MBT7V63uQx8qNdl0qdb1EmajLdaNl+eEKr8ko31h6i6xicBI+QeXFK6so4CbABc9IlsWBZL5RhXwGa7B8P34+LowITTI7nwJDx8jWe9EUHigaL54fjyOalr1Dfr/m7Q4aXt2qIkt+2DsYNo0DIyq2r1Za9ttqWV8FBltYaobC9KCapy7bTZmAXjZdq5SQJfrS4VmlhXsevCvJf7b6c4QxLlwtVFAdWhQt3cYMaJsx15iiKp67NYrlxmaaHhRpY6gklndJjYz3eo8iVGhAdslRcpAcyiK2d7be8srnmheD6F2WoWJ7IJ9054+HD9XpdK7ltZSIhppV4y42iKvyhh++GlK9LRXzl6PRq1euTnxBp3sO+wBP6RqzavgAw==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700016)(82310400026)(23010399003)(56012099006)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DFYdj91y09X9hKW437eAiwG1PUcf9Atel8vtbaHT8V8neZn+izhSmjel5eSlUqAduoT56el4IHRCDhqzRoz3uu28iVbf+7zjuJBJf+xS+LMHo3tUA5s5Wpufp1Rh1Z9i5U0ksHSu9khQRR107BBNO4KPx9xu6ZX3/qU7SdCm53vAqJykTL46MInwHgvYuqzLJZfyQG4aJ1u2z9PJb7pohjzk29uA4mN7JR3vYm0/2/j1zNIyfa5F6XWB/+a+flwDLaNXH6+M3W07VhypeQVyCeoPrIcYUyqVH6x+4wz2XMQ0mYGLOH/T8RDUrHVPJQNx1cc5KU3BIrtc7dSa0jss7/JWG+Zceggdn7kIDKl2asq4iWQRVffKFzsiL6DEb/YSRr+qY6OL+UitKpetwxEgQjx9siNQf8dkQ0wKO7FwOdCshOgLjjdDtko3CKLAyA4t
X-Exchange-RoutingPolicyChecked:
	BZrM0QEcFOjvnzdouPi0Ub1ihRXD8/ctQQs7InuTFSJSMHdVJmaPAebYcl29KWZ6HjfBJJ2v74ZfIMxmFs6YTkqUQWmN4cMY8TCmFLvt0pWn4g5XHWQXvJF8M0pi5V+yl/XK1vynoAJwX0DWOHmJmI6aP9qPa6LWcp5uOBEjNc4ka3+8jSEjZwEmAcxaBGaOYXoPvmnxvGvGUub8vDCjhlHL0C//fVNz4CijeD+nuMNzmOMz86IGiQ4cmFLUh3BdFO9tf5uXJU2nlTDutDDo5y89fM/iNdytLmOWBis4d2cmrWtLUDP2x5WkZHBfY8RN0N8QDkZSageZfXk6e1/ygQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 11:48:44.6487
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f19050b-8185-493d-4142-08df2b7b6eab
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00018074.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6674
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA0NiBTYWx0ZWRfX7JGJhlMYdDnR
 yhhlzVVtG6E4XEXnteobDThEEk7e0prIDV9I2HoLnREwbBxq/lKewmWU90U9iF/ZP3WYLJ5avMf
 kYORT0mPpNbTphnMYCs9m+DmbY0GYg+Bp99MppBjHT0Tk6YB8v0jccYc+J8eGTXjtrmmva0qhPB
 3pWHTkEpf9KEj93E/casA+Wtz6Pbw0PPqwqrLqt77yaeM9cL3/8loxMpeYb7/1uOF/DD6lEZ8qO
 pPGQcffcuV6nje6TnDu+ivq4jTlQWk3OJR0lQn+vXJLYH0Y5z71x6zgfApIl70fFg619ooFClbw
 ZHtVSAAQKWs1FUv7cgRdtmeIh7W2zvUvfrWVkwlD/fPq/zx5DageZ7xPfL6nNfxHIxXZx6yPoDD
 fVAIa5D8vAxAM/dk3tJ2vMkluFxn1Sw371a7ZUKcg5FgIuuMXs75S5lAyVFUA6eQ+j7lxkPWT0i
 z5W90jY2xP52tQMm1SQ==
X-Proofpoint-GUID: BRc5XK9jIv8J2IB12BQKypPU8weKRhaq
X-Proofpoint-ORIG-GUID: BRc5XK9jIv8J2IB12BQKypPU8weKRhaq
X-Authority-Analysis: v=2.4 cv=fspJ914f c=1 sm=1 tr=0 ts=6ad20f20 cx=c_pps
 a=GhmtI3pHzNGJg3++3mR9yA==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8 a=HiAi_RwYt-Wiez6k4EgA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA0NiBTYWx0ZWRfX6jB5nY4x2FTX
 1ZhHeDbpyB5hg0+7fUKSv1AXAuW34YNBVviybz2TbWWVk0UaeySpCv5wT3NAx0fOU4teHf8qm5g
 DdUVsaDkYwy08VC0vD5rKMrOVvbbOBM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 suspectscore=0
 spamscore=0 phishscore=0 impostorscore=0 bulkscore=0 adultscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610160046

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

