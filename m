Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A306947CA78;
	Fri, 16 Oct 2026 11:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792151343; cv=fail; b=qAWFk7gX5SXPta8ucNxF6l1IqRxe2bFlFWE/cL1zK1y4Nf+lzpqL89TecZMMvj1usWaOTmzuQJOYlA1D5ogAa+8wVYTeb0s4lU/dK313Gt9tnmaQ/Yd5dCKdvrOWjrnnjMnr+p8qi+3YNJzygwYfPxGBslon/mETdsvlfICHFv0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792151343; c=relaxed/simple;
	bh=YC/A7S75qv+4+3WlQfVYWpfOLT28k6/ecphUxP7SPDk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s2HwHPe6oTPtAMkzFBsE7cFgKhaydNoOslvy2v5Tr7hYqTz4CNgGy9PgXw5zwQqx/1sZ5g4aWwEFhz6VfexDPM/irlwL1DaCGrnEiZMmZXZY7pfonoocAQ78gRuLWRdaG1iyzthqA77RK0hgTz6EzwGYBVdZhHxGacp463io7t4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=CuZZd9E9; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=CwaiKlYl; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="CuZZd9E9";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="CwaiKlYl"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GBNebo690134;
	Fri, 16 Oct 2026 06:48:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=a0HCdrHMm+MNm2XsTRsZj9zTrtiogIDOUdA/ag57+
	WQ=; b=CuZZd9E94n0SP4oC9sHXv2s4Gcoqp9O5sLzqpc6tBpSJACVPOkewzdIUD
	hi1xgJGQTUxKQHU2DOj9vnsN0WRNwkXvV/sRV0QRiFXB4RRqHbIbqUAJf622mhfa
	tDKUAiaTZWLd2jiQHLD+26ZXkaQMuUvnSVqjvs/pRT9N5+B71TbYLMjMoAlorioA
	MEMetOsLcpSBNmxhOv2D1uh6WBnBovJlEpMahNxsyYOUqvDsFpcYI2F8VZqfI0Z4
	J+uNPXzrJevBeK6GLV01m/x7xzquYCdjKYsMUlhoPhUOkAEn6bqJFjbVVbbOdH/x
	4h6A9v1kg9y5K4B/HJDZglkDTLf3A==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011025.outbound.protection.outlook.com [40.107.208.25])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hbhbd8guc-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 06:48:56 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nVarq1rQQPl1jpZkbxR6gz7qe7T5WBEyNU/TMsz6e+Ak4OXAMhIOU/yyoE5TInUcHLZn5zM7Z8eWA56PWNsVZUiGj+gbnlrfO+DSmQIby0sQbLriN+Gv+96t0kSqUI3Hv9ASuoX+aPDPYKb3IAnOAAVa/Oo1u4Am45MTsobDk630msSPaAfbXsJmKkLKZiCMA0HdLq/vAo9h/WRS46dASeQMpxZDNwJDjyxFjmVnB5QXjh21XbNUZmIcnLKtsVHpA7qyNeGmXGXJPfqrWVcWYktPRG2ROfBph2YaSEy/Y1BjbtSiSxRJiIMVfLppewA/2CZU3U3JzLib7cwm0yYzjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a0HCdrHMm+MNm2XsTRsZj9zTrtiogIDOUdA/ag57+WQ=;
 b=RJdrYZsMZj+CFrrIof9JhUKXlplOHl+mg1LK1oXDgJSmc6RS8bhKNbEZ4eBi9ZnQcbpawPC7cmqduB1mLkSVPx+ke24nOXfDcTruqXEK7/YL/diFbVWVYQyA254suDpXF+fL71ahTe8DPDyGrM++fPFeNlfjXhgO5AtVdJpCN1z8B/2qiYJHFQiQxpTMnnNqJaoyuz1K9O3J+02xbCOAW+Q/Spc21AtYTk48cpOIrApzpVA7uHUYh5EKqzw1SPLZ0zA5xvkiU/Vp/wkYZZfgPQJZoOq/cSK/wNtSQbycQ8c1AzxoH5wECR4tTI4lGmpRPY+x8zBgDSfLB1aFDl+Wpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a0HCdrHMm+MNm2XsTRsZj9zTrtiogIDOUdA/ag57+WQ=;
 b=CwaiKlYlToTsFgiAQ1GbfWV1l3dgBuiCYm7gfO0C8PJveR9amMOhOXCTcwwTgTXzVMRcTNO/IvvncVMKhErPKUnyykY70F3vYIwmY+MMbTh02eD4oOmL0aK3+LsxRCtd8q0Gu7mIzS+VzbmI/wiKAs26CJld/2GACm0KZv56Gg4=
Received: from BN0PR03CA0020.namprd03.prod.outlook.com (2603:10b6:408:e6::25)
 by CH0PR10MB4922.namprd10.prod.outlook.com (2603:10b6:610:c6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.7; Fri, 16 Oct
 2026 11:48:54 +0000
Received: from BN1PEPF00018074.namprd04.prod.outlook.com
 (2603:10b6:408:e6:cafe::40) by BN0PR03CA0020.outlook.office365.com
 (2603:10b6:408:e6::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Fri, 16
 Oct 2026 11:48:54 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BN1PEPF00018074.mail.protection.outlook.com (10.167.245.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 11:48:54 +0000
Received: from DLEE212.ent.ti.com (157.170.170.114) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 06:48:49 -0500
Received: from DLEE201.ent.ti.com (157.170.170.76) by DLEE212.ent.ti.com
 (157.170.170.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 06:48:48 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE201.ent.ti.com
 (157.170.170.76) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 16 Oct 2026 06:48:48 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 69GBmlqg1508822;
	Fri, 16 Oct 2026 06:48:48 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v9 10/15] crypto: ti - Terminate DMA on all error paths in AES to clear descriptors
Date: Fri, 16 Oct 2026 17:18:01 +0530
Message-ID: <20261016114806.1749515-11-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00018074:EE_|CH0PR10MB4922:EE_
X-MS-Office365-Filtering-Correlation-Id: a3616aad-75aa-4424-a0ef-08df2b7b7479
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|1800799024|23010399003|82310400026|261009223027099003|56012099006|18002099003|10067099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	qFJyt4I3drgc5CUlgO0N7vbzwEUOBznjRBGukg0qaLYbxqCZS/JJZdsgqncHeN0wx1zCc6DEo7l2UtH0KJuHt0xzF85iRp7+Xtw2EwC+Hf3bD+aAt6kQj85jyMqp3jnTD8imBFojxg4K9SelCjs1rfEsEUKmTqThFpZGjdr4wzLFNW6h3FuQhrZphR8rAk7MoOw7kyaqzJrIcBgspNiU0z88zst9WLqQaxZ3yBEI1aorcv5TrRHo3k+PR1ddsXZnODDrghqru1iIU3A+QFTCwZAhYC4Pywcm5ua2V4wFUaHi9SLbhjySchAOA85hNyUveOfZbfiyQLu19lPvIYjlp8uBPHXfDYYBJFURhFIAaaGxwxGh+8oGyhLKhZQBV5s98qL7VMD9xXZU9a3fu/yWlgynLg+D5Idq/uryfyMnYRmA/DEbgHJEt9YFJVJ65PgvVNDr6gd0WyOPT1gML9mOlnV9rIOc19vLI2oLojoKNn2aFkp+9s0zkv8Ay00iVb52dx9p7inxDUuK6GijMvQNKhlBcnadVA07CuLpF/dHPh1SJc+wyvmfo19iSosuF/CTbExC+ANCRuMQewE3f8kHkkyjlCa3tTCevOF8rxs/Z0CKgRz53OtC1GrVLjV1MZ3ysb/62yIA16U8y2DRXrujYaetByod32iMg9YUv0JMO4J+L5LxF/wdjqY3tJlJBdTDkYdjudVy4qjfsm1+PFBgeA==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(1800799024)(23010399003)(82310400026)(261009223027099003)(56012099006)(18002099003)(10067099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gueZi3FgFAUD3UwzNuGWmQ6xfErm/75+cpTXgLh46S/mAd/LZ1jGGd25hXsdplTU5EFAUai6Y7uiheSkmWvW+e5avb4eYNIG2UkZ2N7EFCBa9WcBAlWM4bnflUgFVgKPijPNtsBdlHchRm6VO/VCwQAgpAVSPqCMZCJ3i0R6HyZ+rr7cV5AtBgIaGSmdow4rrdwwXtWJXdFXL55IB2CNFj6PUk6up1blQwKkbN9aJWGgXYIEfdnbu5hcSDHMw+qKvyjCmap78lipRqiNyoAKJ27XDSBTPf0/UJuUiXMSTCrIP3gjh9cDgr5DL5byQnPOfCEnUoFYG1fqI7AP/VqXP7fr5xy+P1RQxYA9uNSMt1iLkrqsveyCXaPDSUd0xIdsl4dQ9zbOhiHc86UyGpsIkzyLGdMhQPQSLMLqNha2uB3zyubXR9oZ9V5zQGHTXj+J
X-Exchange-RoutingPolicyChecked:
	HQFSDJa8w2U6lC4xfwYLPzthQ58ye6fA2gKS8hIZJbw3gGu4wpDLs5nWbwX33Zlprv/5hEmLSFn4ybvvObfJe8QSA2D27TP5FAqby7p/zNcjZmktIbGl0UHxGM8dzxP8AMhJJPnEVpgC2ia6mVtiz7GnBpHLa7O1W4J3M/tLJBotOf0GtjlGYd/TAxgZrpw9UJeJLJ/Bwp3tvJm3iffWXUMP7dpo349XYgdAzjc0tEJQx9FhqhqnNLwCnXGM6PWPSriKyjI4U0RTCcYBwdJCO/W2WSmJW/ZqZjy1WQtmXWtCUaMPCNTSVIEKbDYFWP63OIjE1Hg+ih3EPTdUvZSbRQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 11:48:54.3888
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a3616aad-75aa-4424-a0ef-08df2b7b7479
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00018074.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4922
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA0NiBTYWx0ZWRfXwE0ZyKGDpwgG
 0AoH3s1qz9dqiIGIdW+XK4prPw2yc8bqohMDI/w8FRYRNneyY3C0c75gTXPAt+P7Uc/pcQvyNZc
 xeRdm/8TRwaz2pvl139XOhs0YIn/eRY=
X-Proofpoint-ORIG-GUID: OI3HPXrpYzVLHo2pts4W35k_n8YVWNmV
X-Authority-Analysis: v=2.4 cv=BooIUoX5 c=1 sm=1 tr=0 ts=6ad20f28 cx=c_pps
 a=C5fyF0bn1LKt8LWMWUNbGg==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8 a=T1XiGUNGXxSxoSVzcpQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA0NiBTYWx0ZWRfX9iPj6S2GmOvv
 LxJFSsbMWZGUZONaJujQdDFT6mStSd74qpV77JlmZhEUTWToPGrJnSIfQSjx/AtSRZR0Si0nMuF
 L7AN8BYaOClpmOTXf/oFjR3nuBOvfs7uyCjit9TBp4n9bOViKjdVvswp3ICo+4oInDwCrFetYFw
 7yEHx8l5yZe14Jh7Ny3k15S0ZLOa53JUFI9DJmlyArTAWZLESjmIBZzBJ7h/jg9XzNqt9ZoovCg
 VO7zwbdf1bRMuhE9mt/3psaf1PBDGehwheD5Jl1Jj2D5tx2aNqv3Gdd/x8anN4sXFh1c0r7Fca7
 hB1ru76Ibb4j4OHzq4gswqiEKrvCzOa/wwxDkeZEDwsg1+FQQwf8Qqt0RGK86vfnfK8C3GSKwqa
 FlWGj5RHaevKSpbDSCH1TjtoTpkDapLzKxErG+giOGcsyXdFf80GKvR0YPVNhS6tWRyVKjeOLED
 cI3Ano+L8QKghyeFdYw==
X-Proofpoint-GUID: OI3HPXrpYzVLHo2pts4W35k_n8YVWNmV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 phishscore=0 adultscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160046

dmaengine_prep_slave_sg() allocates a DMA descriptor which is freed on
either successful dmaengine_submit() or on dmaengine_terminate_sync().

The error paths after descriptor allocation was not clearing them,
leaving the descriptors orphaned and leaking memory in case of failure.
Add terminate calls in dthe_aes_run() to appropriately clean the DMA
descriptors.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index d75b074ca1e39..ccee60800a664 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -449,6 +449,8 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	if (!desc_out) {
 		dev_err(dev_data->dev, "OUT prep_slave_sg() failed\n");
 		ret = -EINVAL;
+		/* terminate to free the orphaned desc_in descriptor */
+		dmaengine_terminate_sync(dev_data->dma_aes_rx);
 		goto aes_prep_err;
 	}
 
-- 
2.34.1

