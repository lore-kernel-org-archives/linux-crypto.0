Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA4A4AC179;
	Fri, 16 Oct 2026 12:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154798; cv=fail; b=Mow1cyKN85bQK1hspiBRdM/8uGjpOfsAb8E3cwpWjYbHeENo+tE13ZIuHhuclLBw8U4rXh3aNZ73Fg9BHoksCDIXh4CZGXUdK4ItFVqs+5now1x8cr2CTI7Z13ZhDuwR5n2n9RBONZjbdD0kP+vplVvyk1MPWekboz939e3b0rQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154798; c=relaxed/simple;
	bh=Zd+YFyNQlDgh9XjZ8Jbmlxiyyyvl7EPV0mQcbY6y4h8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tjzlKQd76x6xeB37IcakCYyXi82hTGOAtp3P5CpPrjYcMARnNfdUjduJ2xkT3+KfpWQD4D4lbvewCgdk1ceBoA6ICEG1v0BtsyqL7YvEKuww5oZOUBhr5xKV2VbGwwD9u7oLeXtqSXRAj4VvdJdAlyhTlxa8QP4TG935RCIL8A0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=Y8Nq3F3D; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=XCdoZjaq; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="Y8Nq3F3D";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="XCdoZjaq"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GACtXg559831;
	Fri, 16 Oct 2026 07:46:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=0NmAorX5lMN6twOw6KKl2WtZgSmXV9LsQvUb9367J
	Q0=; b=Y8Nq3F3DjrVZLEL2v4ypuIxsD2mXWYqJzJogp0D10jUDLUbt/C+fYiP86
	7qJdJocipIu6SqJwXqdxdx58cX844/sYZ1OxV6N4icI0OLHj/G2jTOIhUsUnYoyR
	6nIHTaC3gqNVFuW5OpkhmoAK8T414vMef/luZxw2ocGckXn8UVByQvwmB7+BgoOE
	UvzJn5VdeIAIKo3yvjH80XEp5SBqhdmj276UuJTFd6ph82O/7slpQ6LJAyiilZqm
	XLRcNZTK3Id3v40xzjz744+YUC1d8pPWBugKIgbpyR+tzp8cgDFifmq0u1gyTuXD
	GDOSyHCYwr3RMHsLNtEMBhit5HLQQ==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012029.outbound.protection.outlook.com [40.107.200.29])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hbhbd8sjv-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 07:46:33 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EHumWz1yaHm4Ph3mvMihD7ibuw8q6TK6vSfNRKPpVU2DdY0UJEaCEkv+XU9Tz/gdswdCNWTPE3MIaSHUro2rNOB0Yg699A5EqpSgjORyPjtBmHaT9SBHsjqJXxe/XF8POiswoi8IlShy0Dg//ZyRuEHHwBoLfLRQRPmFTFMLi7UofIAnZOMnt+SBiGZF2vfLApT6iOBFZvixtrQr+07UVeVokC36mC41vlhqxcER1ShNig22uqh2SrV0aOCICdetG52/g/fn6KbI8aeniHtx3myD7qqMGEIyG/MLAQw3GjHApVlTdcxthrudYyT0gKErKNIOT8tdhAG/n8intrKQuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0NmAorX5lMN6twOw6KKl2WtZgSmXV9LsQvUb9367JQ0=;
 b=OBdhm8sIOWZ7mF0iqVntYGBcRtHrIDmWHG3EpkNDlNictHukE7vqpGkwCkMdTGOIAAGxSfCjIMMl9vM1wRZj5SOh2v0GkM4icyp/wQfaaoRn12zndlOOi9GT8wBiUaou4SZ4b1dh5JXpKNS4KbaCjnN6r8C3ywdTH12zHVdhXpLGwFZFJLAr0N1SP8TuSldwfYnXIKzGkABn7rW/SjZPZu6OOBAkOfq29OkgAtXBFWYbc/eMgXWp478Ip8zar6O+dOKH6dsoKI5/3LjVajERLsScvCjP3yg9YpsTItmC3TFnaILkc4O0VmlWswjqX6vw1xt5SP5DwZZ44e2yyR3unQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0NmAorX5lMN6twOw6KKl2WtZgSmXV9LsQvUb9367JQ0=;
 b=XCdoZjaqUXAgNj7Oh/XV3/E8DzogFzYGgrx92bOWjmYARMVyP1ccJO9EKNTnsNqTl4O1JO98bKNwVcKipMsbfPWUxse2L6nQjznOLfCNhgk75/MJv+DaCw8f+RLAIUJV10Ekv9tI5CMPO9zFTVtS4RjiPw4mRR+YjddM9Rrjx14=
Received: from BY5PR03CA0028.namprd03.prod.outlook.com (2603:10b6:a03:1e0::38)
 by SJ5PPF87E558B7D.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7b3) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.11; Fri, 16 Oct
 2026 12:46:30 +0000
Received: from CO1PEPF00018861.namprd02.prod.outlook.com
 (2603:10b6:a03:1e0:cafe::b) by BY5PR03CA0028.outlook.office365.com
 (2603:10b6:a03:1e0::38) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Fri, 16
 Oct 2026 12:46:30 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CO1PEPF00018861.mail.protection.outlook.com (10.167.249.250) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 12:46:28 +0000
Received: from DFLE204.ent.ti.com (10.64.6.62) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 07:45:44 -0500
Received: from DFLE205.ent.ti.com (10.64.6.63) by DFLE204.ent.ti.com
 (10.64.6.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 07:45:43 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE205.ent.ti.com
 (10.64.6.63) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 16 Oct 2026 07:45:43 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 69GCjgNx2531698;
	Fri, 16 Oct 2026 07:45:43 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v10 11/15] crypto: ti - Terminate DMA on all error paths in AEAD to clear descriptors
Date: Fri, 16 Oct 2026 18:14:52 +0530
Message-ID: <20261016124456.1802080-12-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF00018861:EE_|SJ5PPF87E558B7D:EE_
X-MS-Office365-Filtering-Correlation-Id: 64976664-0b71-45bf-57a4-08df2b837f44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|82310400026|1800799024|376014|10067099003|22082099003|18002099003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	4zMIjUxcG9hsSGvIQR3obKshqFqU4Gi9t/ZamP0L/7vhrkfveLkiPmZZXAd3ZhIACbNJWSkrbSkt7KjXznK27Q3N1JWImZ+uyYQMNw6gzkAMwQEK9UxXnx1cV7XPVCl/rz8tU9tLAU7Re77y8l/I2bcVVFR5bUt3kUg6uYarI4raIuRw8DCk8RjA7r/P/bd6Y9pg2RdgeCRwC9SD2Diw0XcXJT8vFqTFXKba7k2TirrvC8TuG/Suqki9mwoRafubpVPUUsd5SCrT8PO7/ShsyOk5f69weP1wPf0IhDXe40F2csagoPgpRHLVvIsoUcblY7xDoOCL9YU0OnCc1vGYg0H5BCtTVnxVS6Ey95269imdyJ9buDmpG75lRpYQzmVGfOmNWx+WuTTSvTgMFUyMvSp6weD5morC81ZF3KMMwbUy6Kn2GkKJH8xOH9j4Eu1XMj2KQD9jHzF09zm1CRFJEmJXVbKW1Nw4D3PnLBCNAKtB/Wc9YiM/DthVFCRKkZcuPL8PSf8E2/RiY4JVZHbnxAIscnVt7hsquK4wVdJaMA3NJPAK5f4iNEbAw4g5wo8PomWcFRCqbO4OXo1IySpX3SID6ssZW86AqYhFakwOHrYIaJnFBVDS/B7q/urbUqlkmt+VRq7j01+B7erGZ8CChkI4w6/axmoNT0ceB+0MLxPtSblzUxI8fFCciZNiRsH8yF/pli5vJpDKmszh7hfVtg==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(82310400026)(1800799024)(376014)(10067099003)(22082099003)(18002099003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	yGpwBXRh5Dj6m/d5Z+gkppNCvJX708l4b6O5hiFyAeOYtqu6pYWPQoW58ch/aZvknneVLF50AugkHuL31KHx3qt3jKjHnRwGrXf6IbkVMkLFhlj8VnbvBUf3IYlTLojTDgnlvlAdXeK+dSsGE5RwbXOYYWMUFtZHc4LSpFywVxVDMW4ZvcXvo6HIFBquLY7CsJlEbvxDt2h6eMeH+GOXsMUWw0yCMoUDlyxtKQmuJWzo/Vfb1sU5u4VdEpc5/KxKpJjhwwBssabewq0jfFmaEEkD8jiAjoNoYNcfBH82NIbrNUKBm8sPWwDfE9yft7kAzguxwFZqM40mO003yyBCfzqvXG+vMwI/jo3ULUI4rFfVAkPO3E2B8RwRzG2f/X5QTTo4kVhw6/xOYUkBZj2NfwJw75xTomYvkoS9aFaJbqCSaVooXzCV3mzsU+ha3KfT
X-Exchange-RoutingPolicyChecked:
	xgZeyAGq5EVUjr4v+kLALlO9NIdT6OPzj+KMtBRX1SV0shRAyHbVZyHboMOy/Jk6LvBJji/9pSKKVfKGR161TWBeKaP/1wW6x2rDnabTyaUvkg6mD5cM2HWhF/W8soiN9qKqWxTv+Ogd+ZhGPpVGs/2Mpaj7CxH7K+sUIDRPIzHCWp3/6g2j1mCAKqgrJ2FEc0LJi0JpJX0EH7qcvodwjp88Syjk3OGWU8u0HU0qa0Y8SKpdFGxXaIAWUDViSm81HRK58EDGPgVOeGMFDgzQI0WNrifsImQhSoIv/0l3R6Obgh1ZjMYMDMUsq0aWFFcRHwj3sc/xQzTMw77sWyivpA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 12:46:28.4544
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 64976664-0b71-45bf-57a4-08df2b837f44
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00018861.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF87E558B7D
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA1MCBTYWx0ZWRfX5Qx/Onjo9WHl
 1st/MLzrQyW1qffJINmjCyHv1i9FmQ+9K/iCprHbkp0a4mlW52w3yREB9xcFsCa4ZV1pCjQh9N+
 fr7okWTqRNXgnzSYGwMpTuz4PxjG6Yg=
X-Proofpoint-ORIG-GUID: rLH5-9hYzGEDB7LW9G-eWjdOMYdTUjnk
X-Authority-Analysis: v=2.4 cv=BooIUoX5 c=1 sm=1 tr=0 ts=6ad21ca9 cx=c_pps
 a=6BjqzLHNfcmCQygjyc7k5Q==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22
 a=sozttTNsAAAA:8 a=noPYQ3j_lezN9luSq70A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA1MCBTYWx0ZWRfX+DjlQD8J0NEw
 PjI+DT4AKYO4qVgc+ZgB3TiOgs1/Ltch5vXhuKTiZR8uOuBQAvurX9EEHEgk4Rjx4B2Yvm4VaGU
 YuzWLVKo8NSGD+eU9S7iTM1661h0T9Fmv78MLVtfJG58xJqiu0X/LEziBHWPLcfdxgj5gPMMezd
 CTgh1U8Y7NRqqLNdacZ6btC1aKGpELGUf/BY2/7s1LgvLBOrib1QYxTZ4Q9uwv3MReKbBcZ79+R
 e+sdsWFwoZzillFLm6Cb8/U9G0lt9dgdRpYc7DkEQWNlKEQE5fm1rs58LZbhNbhr5xxF3htLKRZ
 8DpVhfXhQSWAwKX+tvICn7g/Pq8FSMhRM8RZVTpToDPlu/OQLM4XalvQUjSDAWCvqWE3x6yq7HN
 3jPnW/lsoX0dnZacmxICC8mAdfwcgQlAVQGWFJNR1K58QXgXTixPi5+659lQsLueDV8HYfroMZq
 JoH6N9zgwa4t4Dr4uRA==
X-Proofpoint-GUID: rLH5-9hYzGEDB7LW9G-eWjdOMYdTUjnk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 phishscore=0 adultscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160050

dmaengine_prep_slave_sg() allocates a DMA descriptor which is freed on
either successful dmaengine_submit() or on dmaengine_terminate_sync().

The error paths after descriptor allocation was not clearing them,
leaving the descriptors orphaned and leaking memory in case of failure.
Add terminate calls in dthe_aead_run() to appropriately clean the DMA
descriptors.

Fixes: 37b902c603042 ("crypto: ti - Add support for AES-GCM in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index ccee60800a664..ea6e3b246ed1b 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -914,6 +914,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 
 	struct device *tx_dev, *rx_dev;
 	struct dma_async_tx_descriptor *desc_in, *desc_out, *desc_aad_out;
+	bool cleanup_tx_chan = false;
 
 	int ret;
 	int err;
@@ -1014,13 +1015,15 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		src_nents = sg_nents_for_len(src, cryptlen);
 		if (src_nents < 0) {
 			ret = src_nents;
-			goto aead_dma_prep_aad_err;
+			cleanup_tx_chan = (assoclen != 0);
+			goto aead_dma_map_src_err;
 		}
 		src_mapped_nents = dma_map_sg(tx_dev, src, src_nents, src_dir);
 		if (src_mapped_nents == 0) {
 			dev_err(dev_data->dev, "Failed to map ciphertext src for TX\n");
 			ret = -EINVAL;
-			goto aead_dma_prep_aad_err;
+			cleanup_tx_chan = (assoclen != 0);
+			goto aead_dma_map_src_err;
 		}
 
 		/* Prepare DMA descriptors for ciphertext TX */
@@ -1030,6 +1033,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		if (!desc_out) {
 			dev_err(dev_data->dev, "Ciphertext TX prep_slave_sg() failed\n");
 			ret = -EINVAL;
+			cleanup_tx_chan = (assoclen != 0);
 			goto aead_dma_prep_src_err;
 		}
 
@@ -1038,12 +1042,14 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 			dst_nents = sg_nents_for_len(dst, cryptlen);
 			if (dst_nents < 0) {
 				ret = dst_nents;
+				cleanup_tx_chan = true;
 				goto aead_dma_prep_src_err;
 			}
 			dst_mapped_nents = dma_map_sg(rx_dev, dst, dst_nents, dst_dir);
 			if (dst_mapped_nents == 0) {
 				dev_err(dev_data->dev, "Failed to map ciphertext dst for RX\n");
 				ret = -EINVAL;
+				cleanup_tx_chan = true;
 				goto aead_dma_prep_src_err;
 			}
 		} else {
@@ -1058,6 +1064,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		if (!desc_in) {
 			dev_err(dev_data->dev, "Ciphertext RX prep_slave_sg() failed\n");
 			ret = -EINVAL;
+			cleanup_tx_chan = true;
 			goto aead_dma_prep_dst_err;
 		}
 
@@ -1147,6 +1154,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 aead_dma_prep_src_err:
 	if (cryptlen != 0)
 		dma_unmap_sg(tx_dev, src, src_nents, src_dir);
+aead_dma_map_src_err:
+	/* Free any descriptor prepared on dma_aes_tx but never submitted */
+	if (cleanup_tx_chan)
+		dmaengine_terminate_sync(dev_data->dma_aes_tx);
 aead_dma_prep_aad_err:
 	if (assoclen != 0)
 		dma_unmap_sg(tx_dev, aad_sg, aad_nents, aad_dir);
-- 
2.34.1

