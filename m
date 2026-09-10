Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5775E4FB9C9;
	Thu, 10 Sep 2026 17:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789063051; cv=fail; b=eg8mUPoYOtQhp+0tAw7ihVnG1IInjJ6poVKJSymvpVShmfM85dA4lfkklslria+52UT9nvalEA1aYYbIa4w1qFjJ0afS53011WSDdqdPvoRbVKMT4OoEwLxhYCng+o3uEONRPIUoVQ/2OJs8f13HXGBTPU9mx7sK+uGmbswWwb0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789063051; c=relaxed/simple;
	bh=6RV17K+dOkVeshFmshHqF6sMCwCc25grQ5kOysr9CGI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=twGmz7VV2MxDdKzjMSKXvIT0pzKKn5RvYodhAI+kdGp1LgTmoRm7c5ulPkC4EIELp+C4aU9K+VlFk1X3FOJUKvvA12TzTFikOVyAP6akU3K58voCli1qajDOy2aKglfdqYP/NmO5UoOHtUVPfApMx3rPxj5dbmOopP28hUrrGkI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=hMvPBnPQ; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=AngVP2Xt; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="hMvPBnPQ";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="AngVP2Xt"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68AGEdts3808502;
	Thu, 10 Sep 2026 12:57:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=3Hbdg4pI7uZrAjMnu5fvtSkbjxE49GEKGFuOUs0rp
	ss=; b=hMvPBnPQTwdgSqcKrmYez3zm4xciBgj3o32+dyoxf7k09oZhAaeF0XcfN
	5WxbCdI2FM4+rQ0GsPP+oEuNjBTPJc0e0Hh+TMymyQgSV4stj83PM+tAzyWn2VKD
	UBN0A50nKJWYvv+0X9gwDVbRB4zvj+Yl7K5fZXYbOfV21RtD1pyRA1Bfr2/fPXk1
	W9qVlS7Zx+ER3YeWItmoQ5PEiclPwsvTJ1d+r/ypijMVPQGundQdg7t5XK9bE4hY
	DeL5NSzVorFdyZkGo57xmAzTuZfZE25rz/HrhggItPpdEotDithIquWyBHGO2E06
	1QQUnG/xP6d35sOvnd0RZd1SOfUVw==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011004.outbound.protection.outlook.com [40.93.194.4])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gkyw9gp2r-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 12:57:21 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IG/zyOa+t1llQ/R4+ip7EH7RESsNxPqbbKFRVqAn47bfAeKIUO8zURMuplqB1BnAsBAnV8zVF5s3WO0XIsdaJQPDiYOsAjVReFHwmX5y2Qe9qhtVvT2hIJtMMXOobNSo9VHwfH4xIZ7SU4ElaIbTovdg2nQbdc0aG8qFsfTfiReCFw90WtUDLUFp4VUBZiu/2CqfaJSIdJ1onMZOTKBuXi6K15X0sIDWtdrHwVfHKiuzKywu1FIJeGtFUWSQqvkkmnPtHIc2YFXQSyFhO8ZtYHccJX+viDml16E31JmN6x6rz07oqbP6rsxBlxOQi9rG5uyrwuozal7FL733XXKSHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Hbdg4pI7uZrAjMnu5fvtSkbjxE49GEKGFuOUs0rpss=;
 b=HQfLjuP3cSILITVfirdSXs4FyxMMarP4BmoFzV5do+xksDiOzVVgisNBSMGkURdvafjHROxREat4Kr2Nm+FubBhNdjsMavGbevRCQjFyY48GtD1nExvFOfDnhyv4NZbcUPsyfVJFACoVhIZr75ydETX0nmGQmpWN8TX1GSYvN20SuXLY1cTErotV5q0ya/ZTHrbpHxqZDqsyTbk2n8sT86N5qCUPc8STqV0ne46DlXC/mePK1l6Fn8hRqnXRULS59VyZT6drqe768KNROfIFZepQDOA6B75FNlHIZV/0Neebcm8DXH2NecmLG7e6qJpn7QU1t+2ry5S2NXzY7HcaVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Hbdg4pI7uZrAjMnu5fvtSkbjxE49GEKGFuOUs0rpss=;
 b=AngVP2XtX8JCMlzVItGRcrbjjHU5SScl9brKqdUp9IkP7skPfhx85tKQK5Gk5oW05ETAYaJuwEln/NxWiEnvKv28sA4yzLs+Knp0vI35/J4pPMsL49f6qdScFeIlzRVwzMl6iKHxBWFadGJt4wgv+W3yQdpkwD2zataZ9uRVQSA=
Received: from BN9PR03CA0378.namprd03.prod.outlook.com (2603:10b6:408:f7::23)
 by DM3PPFE51A5CB22.namprd10.prod.outlook.com (2603:10b6:f:fc00::c51) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.4; Thu, 10 Sep
 2026 17:57:17 +0000
Received: from BL6PEPF0002256F.namprd02.prod.outlook.com
 (2603:10b6:408:f7:cafe::5) by BN9PR03CA0378.outlook.office365.com
 (2603:10b6:408:f7::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.8 via Frontend Transport; Thu, 10
 Sep 2026 17:57:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 BL6PEPF0002256F.mail.protection.outlook.com (10.167.249.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 17:57:15 +0000
Received: from DLEE210.ent.ti.com (157.170.170.112) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 12:56:59 -0500
Received: from DLEE209.ent.ti.com (157.170.170.98) by DLEE210.ent.ti.com
 (157.170.170.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 12:56:59 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE209.ent.ti.com
 (157.170.170.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 10 Sep 2026 12:56:59 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68AHuwnb2793839;
	Thu, 10 Sep 2026 12:56:59 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 10/15] crypto: ti - Terminate DMA on all error paths in AES to clear descriptors
Date: Thu, 10 Sep 2026 23:26:14 +0530
Message-ID: <20260910175619.2122149-11-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0002256F:EE_|DM3PPFE51A5CB22:EE_
X-MS-Office365-Filtering-Correlation-Id: a72205f3-de05-43ef-7f2a-08df0f64f2df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|376014|1800799024|10067099003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	UVuhsGJjEBenpUbw1lj/cfk0HEOrzKmyl1swWWzYT6k2pjNzz2v8bVEFTEC7oFXa2aeVUvDK3fbTYBatSFZM5oB0FwQw9+fTT7is0bCtwgVvUKvyPb+47B7eqrbzVyNkQChuIZ8JRad9UNYog+TaFZQOWSlup8dlQVg3W+SKpQju3csP45Lix9xFvhnIdR+bYASm8odqiJnh2yZEq8sKKDzwrNboefGtRiOm8kTt9th9Ly2mSafvejQFr0K7Tilr7VpdoS+h5LpBHy8McrwSBfP+dO0GrZg8a5OX21uJVxrZknbR7Td0V9oNkIDOw344Tch8PfawvwPcvORRO/FpRKxD8i3jVxfe9pSbr+jrmkaVyrhX50ifKutVhS7M7FsFC/jqvycJLNNa/0RcrR4RAJuKiul6AVIJQut2JhMVgWCpO4IMa4AN9effuZBmnL2muQuq7iJyxC9yALG7kbHzJ+LS6VUXme3tLTDWwMbQyB7i8B32UUm1QBybnQ6aq+I43kJO2PT418zYGSZYBQAXCXHNnu7oN4dGAie0g8hPCTY6baVscSltuBuy5zDCRVskzXd/ojFmiMGHTyMtOWsaailxi6imvLVKyJa4NE70rFaFTyXGP61Dap2LI9AAXDpInoLp4D6QO4DT8qb+5UBgFJHlr4LM3ak9h9HVG43ptyMRwsgoREbF2TDdYDlwzMHSxmB0u6oH2BiN0BP0pDUPFg==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(376014)(1800799024)(10067099003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	60lPRVnxSp61W2jexiG8O1VJnmLNCAU3MUmhnjGaMv6OByXWi6b7LeLQE8gASxMUmFTid7zDAbS9835qNNDRvtrdPsMfIppwFqscSgMlQ9bCEl8Auk9EWidHb/uOczYmykp3xKUgfBIlZuoVP6CIQUoGU4E2dpZQyFWxrN0TYsgZVNPjtfuxn16wokOMVbc8aqnd4VzZLQw7bOVZzN/DfRXZB4mPejxt5muQd4ExEBmOVMqcnnGrT1bTdZmpwygbTunegsEwg5PAQt5jQ0Q3xthgLlpEa2XnCSsQkxIwU6UPULqSXDVmldr8RPra2WWsZxXsTef1LTrIeIE0xj0nnA0HbccW2Zy+WyXsyw0IjrWijzC9a0pN4ZUe4CM1+POfWz3/deeGFOXDE6itQxf4uD3ldNIIoYOQG6nHBc1uUlystT0xsujTsXjdbJT4yh6P
X-Exchange-RoutingPolicyChecked:
	BHz2A1XbIVbiGTFu0gfTdz2hkDSfjhmdzlwfA4RN6FVFft/m0cshR8xLaCrErHSFV9ucfZ7enfKM8ppL13ElBB44AJTC6d6kTBEoWQHY+OU2yiHfzCOunkEBRXv5iw3AiG/LG7g4Kd871mhRE/fxMKCU4co/qCo4sT/QYka+K8seXLTc72jKwfHmoIKbUAGQDwoMw/ejs3E3Oc4VTKBPncRfFL+jrNbIdS/1VNwO+bPnxeTYhHWGsJvLjWfEb8yuGfaj3vss7zmznMANCuQAAS+xjRpf9ZeMVbRy9Hwr+bxw6iUC8SZtG43J8unb7N3OBj6DdVLoodQKdh91AMguzA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 17:57:15.4543
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a72205f3-de05-43ef-7f2a-08df0f64f2df
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0002256F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFE51A5CB22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDIyMCBTYWx0ZWRfX0Yad8a1XoQLj
 qi3f5F1KoVIR0k5v3qcAgQYWBgiqpEF89rinv6nY9TBcPSgKb3EkMz6viYCn6rXgwAiCHEEtq9d
 VxvGLigxVCIAqpRKQjcOnGHl2S2324o=
X-Authority-Analysis: v=2.4 cv=ON6yTiaB c=1 sm=1 tr=0 ts=6aa2ef81 cx=c_pps
 a=FYRcjPsbj8Vbl0y3HSZiwA==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8 a=T1XiGUNGXxSxoSVzcpQA:9
X-Proofpoint-GUID: PO_xsGJ8KpVBmPMvvk-PlrWfeSe_iCNQ
X-Proofpoint-ORIG-GUID: PO_xsGJ8KpVBmPMvvk-PlrWfeSe_iCNQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDIyMCBTYWx0ZWRfX7Z/vxtQHMQkj
 +pfkXIyz6ZSMWLZrSFfdNXY2YAzG94vvRjY8b6UFqpW66Oe4sR6lE5BGPoZ/Kzq0llT10Nw5RC5
 FbrS6gYo6ledMTxuCnf+jHFPWbx7V847SQBNBAt2KGlMQdyVbzetGflZvVT7cZUFp+H5/NydXNm
 AGLfdjMguE6v/1P/nmVbQy7KlguwT+pXG6T5xDr20vU1lzcFmNIHG8qeqGWb2WYIC7MeSM2rBGB
 ujPgxXXklf+0fqBhXkQPYfvFDTyYEAKpYQY6fzrNvkSRHFSNHPPhfDgirSRyRucx25QhyTbq24V
 5mOJQR4hpvm0R3qgF1CPGTmp2JpBsLd+ZzuoRLX3/2RbaP0Wf38h6xyeTbRX6u40BXCzd1MrcRs
 qA2i63zQSCq/jQGyU+vUymq5/NDHC5+st4h6CCWM4Kj945R+BmF6jFC85oVF20M9IkAbuZ7MJ8N
 6RXYOE6IX+Yzy0wk4Kw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_05,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609100220

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
index 65a53fcf80467..10073bbeca113 100644
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

