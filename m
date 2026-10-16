Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A670447D92F;
	Fri, 16 Oct 2026 11:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792151358; cv=fail; b=UqkoOErVTX0cWhsFjMdkl+79fcSCCL0mWgHX8bSQ7qXCc0K7Yw57MYzhLQmmukqB7E9d2vJcBNTfS3q3RX7zb4WwavjfugfL6tWUZPID76sbgjHTKY1xDC1Z68cipJIAsI71NyvY5VflLd+OLrqo5vSSae6oi32THxNQn12Qgus=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792151358; c=relaxed/simple;
	bh=oEievuPIK77sfBoMZW0FxLpzHM0QEpV0zn6Xmu5kz+g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mGlzUSnYcDyl9MBvptA0VjrGZuOj41N6nCGLbMqUuHO5ABDiC34+2wSu/qesiUKrGPNtHPJduG9UrdiyTnmjU9egdfFw3MEdz+M60BN0UBoiZlvzESoSA9yYeFg4+en2yUTig5Fzpy5lHSzLJk4WiGX/CSazRllZ/aRP4TWdbeg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=AeqHdUJ/; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=KHQQpi+l; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="AeqHdUJ/";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="KHQQpi+l"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GACxpM4171196;
	Fri, 16 Oct 2026 06:49:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=te8/Mzw9RHyzNtoGLCjV7WKPoR3c0V5g+TIMjgC9i
	nM=; b=AeqHdUJ/KOO0P7gN1zcaA7sunGoDoyMTk1JifHZ2bax/z6bySEPvT+8ku
	cLo796SYwJBzY1mocuMnivD3KE9eUFoFUF7spZvB4pw6LgxHTFSpwdI8WjQtrUXR
	BJP3JBqU55dLrciOkfRGoe6qVNYjTO0Z+ZJ5dIGWiFgPM7pzcJaQgDL5ikeZYRG3
	hnwBTxsHAEcYgv5mchpXU7ItUxQ+xO5Y0xDQj8GlKbCDgT/mYelacj/LU+5nR4ua
	jgH0F9/4JeKkSMnzZoi0xwXcYBpXnIH9xZ7CUHfDcBD110W12gQXoIC34rv4btr+
	MKw85Rco+J5LtCQ9qCpBFo/k2xuCw==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012012.outbound.protection.outlook.com [40.107.200.12])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hbhanrjpf-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 06:49:13 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tB/MS3jrfpfY5Ep3ugFWdaOVIpfRtz72eR2X+3+WtFcDQxg3SYj4M600DqKcvo9956Yxq0p2KQlC42OVlHmjJwRVmpADNi9y5+cr14W0CF+cDaxQeGhFS+q4GTryHnB5wuWYpEeh2XWVxHetozWgq3MQ3NrNgqcnVZeiZY4u1ZoQyazS8VSrFHVXeSaLwOyQGJzSQ1Wg3oDAHowDCqw4hG+J5AdhxEocv97u9+LTvHXrN3/XVt9EZ+bhUE91wC/Z5MfZFIu3s9bBfbUMUiVEV0y5oUd7sOQYOUDW50vzEslNZI4hyOKAS22w0QOmLRbf4+9p9HWFjwOiv/74horqJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=te8/Mzw9RHyzNtoGLCjV7WKPoR3c0V5g+TIMjgC9inM=;
 b=oYlc2ghFNhanLjv8unXDvP+oEtdBXAV4rnMUmNPFLDATK1HTYA8frZYlZ+eY0VJ5q3cLaLwdisP33kA8QL7W1hq4wE1ustSciGsnKxx/Xfkq+uqash0W0Fdj/DpNXiwjL4BVihPCOcTYH0W6xXQ006IsOPd7xlckuGL2mWzvS8AUgRLXq27BjkS3VY4zdYmSg6xkSzosO+Ybb4jg/0gdDEgBod+qIMvZBujXauck18RYo0J89BsM1W0ZhNxnM1R1HTDLW76AWlsUKFyruJHYJ6WcHyRxEMmicdVa2McsLrMP302D8jYUzks3Jecwy34lqPlwRkeo52t01QNoG/EOXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=te8/Mzw9RHyzNtoGLCjV7WKPoR3c0V5g+TIMjgC9inM=;
 b=KHQQpi+l+6LaSg87nDoYgqsj4ac0FnTW4vTZ2y8T6iQnv56dHfacLJriotKYeIVzFaw/8gKWNT5qPCY95Yp9E0IkRkcbqQAUcadgCRHk14rfV1k+XPKhtF57RFQxpnIOOJUwn4MpETJcffPUU8dDASsI+L5vOjogXvv4CWYnpXw=
Received: from BL1PR13CA0300.namprd13.prod.outlook.com (2603:10b6:208:2bc::35)
 by PH3PPFE6F9E2E1D.namprd10.prod.outlook.com (2603:10b6:518:1::7d4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.8; Fri, 16 Oct
 2026 11:49:09 +0000
Received: from IA0PEPF00000042.namprd04.prod.outlook.com
 (2603:10b6:208:2bc:cafe::41) by BL1PR13CA0300.outlook.office365.com
 (2603:10b6:208:2bc::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Fri, 16
 Oct 2026 11:49:09 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 IA0PEPF00000042.mail.protection.outlook.com (10.167.249.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 11:49:08 +0000
Received: from DFLE212.ent.ti.com (10.64.6.70) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 06:48:44 -0500
Received: from DFLE207.ent.ti.com (10.64.6.65) by DFLE212.ent.ti.com
 (10.64.6.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 06:48:44 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE207.ent.ti.com
 (10.64.6.65) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 16 Oct 2026 06:48:44 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 69GBmh8c2451617;
	Fri, 16 Oct 2026 06:48:43 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v9 08/15] crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AES
Date: Fri, 16 Oct 2026 17:17:59 +0530
Message-ID: <20261016114806.1749515-9-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: IA0PEPF00000042:EE_|PH3PPFE6F9E2E1D:EE_
X-MS-Office365-Filtering-Correlation-Id: feef936e-76b1-47b9-dce4-08df2b7b7cb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|23010399003|376014|1800799024|18002099003|10067099003|22082099003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	1vzFqk2Coluap98BZAJUmAnRSzJNqnvrpS42Ipc0MTOPW6kyOGHrmXOWh0Sz7r0RS61JmM116t5JiPVWkpK5YFdacKqNuMVNj1TU82KFOAN9/dTHfwby0YWOsOiGnR5sL0Q6N/koZY/jJOeSZWGjw9CDEjY5PRVrYSdu0jXjVELgdMHjJtBtUEQeKXg/OmLLYTjRTPocU+WUPaf775d0fjI66ihKIRYLiTlUvc30DHMjI0og+xoGAAwQWEmb+ewEa16MiRzdEZT22zl5GNF1kgsgUlTs6DmLdBDoe6OLWP6xMJCIiQ3Wf7EM2sJV4wqyYNFcCFZVmjUHwM1cLEvIho1POPwtSt6TJR8UMdaH6cx3YKORnkDcZQvgCkftno5CK2X5bQVY5lUV2odHzDp1Rs/eYzJV0zCdnbD6Gz9qpvCIcK8XjgAtM5aeBzv6XYXMsPuJ4PKUjQ0c5gwK99BmbeEseAGanzqBlf5M8hPf86clU0NAA6k8J1EYMthbM1eUy8yYRC5vuTL0ujH3uWk7Kaa/fR8fwC6sMH7FsFGCiOH32j8LzRD85C3nkv7pkqLdV3EmfJ148SDk/PVx1dNzUVpduSxf9fpcDYTRcUvQNWyvMy6/mT0XbLbrnHCqUKPKWfiQu6bfv+ixjnpnRR9dG0m24mkaWjPhLrgI7ihaa3ZQmC/Wkf0Gw9Xyz7hKXBypMqWDspmPj/5KigvORRprvQ==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(23010399003)(376014)(1800799024)(18002099003)(10067099003)(22082099003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	6UJfdRm82pHGOPmuHmX2Jn7evUnhH7qlUSUtJwaYxyDnRXAV1Y2fF+JAuwX1Ys0pm0zg6oFEP6vAhZpQUdCeoxu9bVTZvplvfMbedTva8XF8/FDs9Lq3jq8yKdgSPbMQBNKtZBuMbJRq4kFjmsGG4Ht8dAyIm+LyQ11aSE8G11is/8bn1RoW9EZBni5QAPvXbYtoqD6g+S2MOs35TbTfDWwKGuNZysqvqBJltipbkMINQZldXMEtZGYqTpGCHTr4K2zOvKRu6a4Q5BozKuAoFahD6V9ESWLRHgW+tiC7m3k80QaIDvSH2o0PVQ5zM/yVmFadWv0DFAO8xTURbF00BG9LWFbR3I5J3NyxemNDcw96IOxssJFYFePZeyqQ+tv+TKo9WgSPzBtK3gbi/lfl8/oEWbZC7AWtF8nHT9aQPPNUAM/9tgIvjINeftU+vQRR
X-Exchange-RoutingPolicyChecked:
	1jU0ifaQQdf6M9TmQwnSAiu3svIvnHketvwv6mx5N76affX2uoA7MPflgKd5ahgBWk+KKplVSI5j7Gm9palL3VLs7TEijXO5bNPx8ajUB+s0Iw+J50bY4vikZeAgr+p1CVTSmkJSxRz3KeYYdjdwSwkb3BLu/n4rionwqOi5HsVrnTCdEn72KXuPJuk5LYmGx1FZseBGT/0wHpCTPqF4IKAo/pTC+gb+f1Agye9kaF3k1ddSJ22h45vjLAAKMF3AgOnKro0BYXS0Vh+gz50EuLQkR6NHxc4pKP5JW5bhbl10z2baFrPb9BbY1zqN/+LcjGH6K6AbWXN5dptWkP1JqA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 11:49:08.1588
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: feef936e-76b1-47b9-dce4-08df2b7b7cb0
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	IA0PEPF00000042.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFE6F9E2E1D
X-Proofpoint-ORIG-GUID: RhaE9frFdmAgebHxD4H1ublKoRQ0krAf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA0NiBTYWx0ZWRfX2ynOai2JLVqd
 VzwS28etfqzFHzaF5mV9BOY43Mqes8VzFjWB5w5gBEScRhmU+nnSjVnGNj8mGXwrup7bJnbOrzx
 1Oea7l3gMOechbJ71sCcScjUn3tszllewi+lHrVkXu8AmprS1+ypoUtQvVZj0lmDsZ6TzEdwg7A
 1KkL6ayJXUN1hWZVgELLI6qEvDWsfsStLL+OubVWQEdSK1Opgkya1mNyhRbXem52hXi5NgYqK0H
 2rgWdfhThMAAXJwJ3gn/WsK73vGLWr198pd7iA91A02MGxJp9C8gm9abJ6iGTDspkzoegrZaREZ
 FsEhKMY3GvlyAnTnetu4VUGJ7mh1YWKhjMFxIcQCx8XqSBs9gVtJ1eFiS/EjphqqEmD6VZeIPUk
 1Li7ZxeSdwoCGigAzvVVLKpdpDgR5uqaZ9KOxa74NyFdn/OQjHw93VMPWAup1Goum/pJDX/iaEO
 9ilSER0Ux9TevvDboDA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA0NiBTYWx0ZWRfX0U15HtEla46p
 /YZfjcRWPdUmu741jP2DWe8U85mtvrv9zYazY+pbWJQHI+kD6u3ElzRaZSOfMHniqlDHN7Vl7Fh
 8kU40QcstsHJz9yfR2GhrMpprZdL8wY=
X-Authority-Analysis: v=2.4 cv=NvhE4MdJ c=1 sm=1 tr=0 ts=6ad20f39 cx=c_pps
 a=dctP2Ni10a9Sh7weZd+SyQ==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=jwouBfj2j3NM8CExmVVE:22
 a=sozttTNsAAAA:8 a=wrH6CD59uMa574BPOq8A:9
X-Proofpoint-GUID: RhaE9frFdmAgebHxD4H1ublKoRQ0krAf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 spamscore=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 phishscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610160046

sg_nents_for_len() returns -EINVAL if the supplied scatterlist is
shorter than the requested length.

Add explicit checks after each sg_nents_for_len() call in DTHEv2 AES
driver.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 83d964e884086..0447144b77ffe 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -354,6 +354,11 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	u32 aes_irqenable_val = readl_relaxed(aes_base_reg + DTHE_P_AES_IRQENABLE);
 	u32 aes_sysconfig_val = readl_relaxed(aes_base_reg + DTHE_P_AES_SYSCONFIG);
 
+	if (src_nents < 0 || dst_nents < 0) {
+		ret = -EINVAL;
+		goto aes_inval_nent_err;
+	}
+
 	aes_sysconfig_val |= DTHE_AES_SYSCONFIG_DMA_DATA_IN_OUT_EN;
 	writel_relaxed(aes_sysconfig_val, aes_base_reg + DTHE_P_AES_SYSCONFIG);
 
@@ -512,6 +517,7 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	if (ret == -ENOMEM)
 		ret = dthe_aes_do_fallback(req);
 
+aes_inval_nent_err:
 	local_bh_disable();
 	crypto_finalize_skcipher_request(dev_data->engine, req, ret);
 	local_bh_enable();
-- 
2.34.1

