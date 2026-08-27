Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F192F7AD2;
	Thu, 27 Aug 2026 11:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787830101; cv=fail; b=EW82YP5wyqdBwzBS9YFKoRizVPepiwPjw0pTmgT2Kf0PSKaRDsJNgeiA8gOCf8baFFeYJIUt4+qx0Y67+2sS7n1JNaLe4oEvQnHlXNsbnJ8aDF366KPf3LKlL+CIxQs0RXA6hAvDmfwY1GRp0zszUqQsHcFlEErSBTCbdPBhCtE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787830101; c=relaxed/simple;
	bh=E9M5G4C7CuZJfPUYQaZtmPBV7FZT99o7LTMfCyk08Cw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KxNjEEBVCTCd2jkkfgMTM3mKeNEqPNUzF3y8S2R/aZJAb6pDiKlV41L6hEwHdT5eT7tpgUJiyp+J3rQYOmVqtcbC7DJfpulXt08fXeDwi84RvRgzR26EIGqAIcKk9GPkgVLWeABtWQ3pgISux7bsOEEu4j4C1JbSLDAyP0r7Spw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=FRqfw8Fm; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=OLZPgzdk; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="FRqfw8Fm";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="OLZPgzdk"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 67R9H0AR2589840;
	Thu, 27 Aug 2026 06:28:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=8zsdoGRkicSDrIfSGBh+1HU7R3Q59oeH1iXebpbP9
	c8=; b=FRqfw8FmfhKTC6fTpGP3YQjU2rVw4VwDTjm/QrEzWCc5JaInoJ0tXjFHF
	jnWrs8xwBOjYa03yCEPb/WehZhuYco9BAmxM73ZLhb84oBk7XdZ26sHJ73DSARc8
	Y7PnBE0s+qrnlxfy//yen4SrMtktYxwIyvGLT5AdNczOJ3tr+e2HtBbghOR9xzyn
	tizCVC36Uar0+TTuRBXqRrEzfPvT79HSFWNo/kzqDmaepPlkguEiJPIhUOXogMKy
	BeEPE5CAR0hvdjVooKidyAwCm8ohGb0rjrvugHab1YzqJ/dwJTPAAR8R/f2qWWQX
	RlNIw5GmlYDKlHYWB81y03BYxTdgg==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013015.outbound.protection.outlook.com [40.107.201.15])
	by m0380145.ppops.net (PPS) with ESMTPS id 4gahg38v3x-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 27 Aug 2026 06:28:15 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gkpgqG4q6nlinwKAiNIX+Me+5FYf00ohfZ0BM6r/1K9Y5LNRLQ65Y/hSRqAQ8ckB5rYt3jqe7pzL9YAV5oWP327Bux4+l1Kgc6Bz9m5/6E2jTWx///8LkurPbELImnYf0Q6kR9vUsl1rTuqTCNivZsiehOZLh0NwdoV2NUX5DLK+xoHj3LyByHrsVRjRZ6VbWLf/Kp53m5f6phevfeHEhFOBVs3CJOrtmv64R0R1GGMDP/IQbQj4X0uOLAZoeDFtCVRvswqA2udB7X1m8qdkeizAOtNWWMW+Q899gnt1ii1+TCllBolRvDWtf8IXZbnEZw0X9dFYquPlranoJ1+7pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8zsdoGRkicSDrIfSGBh+1HU7R3Q59oeH1iXebpbP9c8=;
 b=p2ZN0wdrCch18GA+RluzZfun5X3BVsaoDf5L6k/eiYAB5M9NuQt/i734Cub3SqFcrr0UmnHdF1xnu2vgL3hbL6jZGFIU0DQNiIj4QV7N31zsRznZJsRqWc+HJld9zUtsaf0GxmdkcRlmHLRpshtjgiYp1Dev28Q6qmFUX0P6qVVWY18Wk8BsJg1mD+8hA5D+Ek6IiNj679IVfXpvJpTA7fwf1/gBeh1hF3ZNXey82FvQ7ZH249Ua4nlamuRgbFiHpSpO4dKRqM+Wfmjw6kUtR5B0ed1FKZsUXFPSjTI+aaD6JebKDVV40ipBRLqIFZWhU5AN61v2F7iNiA1qz/UwCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zsdoGRkicSDrIfSGBh+1HU7R3Q59oeH1iXebpbP9c8=;
 b=OLZPgzdkPGjAAU8iNBW8HztElIzDee3raJy8cu0XPgKLWF96GWAJ1IMO2ELPBPqadeZxlxFno+n0xLynvWbdl/1ivxo8A3v/i8Se/An0NHRWSqJHW0K7NCHftA7TShcAHsUghTPJ5/kE1gaICSL+N/7O2HlPTUY4BI7N/4WEhno=
Received: from PH7P222CA0027.NAMP222.PROD.OUTLOOK.COM (2603:10b6:510:33a::10)
 by CO1PR10MB4769.namprd10.prod.outlook.com (2603:10b6:303:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.7; Thu, 27 Aug
 2026 11:28:09 +0000
Received: from MW1PEPF0001615D.namprd21.prod.outlook.com
 (2603:10b6:510:33a:cafe::9) by PH7P222CA0027.outlook.office365.com
 (2603:10b6:510:33a::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.10 via Frontend Transport; Thu,
 27 Aug 2026 11:28:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 MW1PEPF0001615D.mail.protection.outlook.com (10.167.249.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.0 via Frontend Transport; Thu, 27 Aug 2026 11:28:07 +0000
Received: from DFLE200.ent.ti.com (10.64.6.58) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 06:27:35 -0500
Received: from DFLE203.ent.ti.com (10.64.6.61) by DFLE200.ent.ti.com
 (10.64.6.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 06:27:34 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE203.ent.ti.com
 (10.64.6.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 27 Aug 2026 06:27:34 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 67RBRXlI1767893;
	Thu, 27 Aug 2026 06:27:34 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
Subject: [PATCH v6 1/2] crypto: ti - Add support for SHA224/256/384/512 in DTHEv2 driver
Date: Thu, 27 Aug 2026 16:56:51 +0530
Message-ID: <20260827112653.530273-2-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260827112653.530273-1-t-pratham@ti.com>
References: <20260827112653.530273-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: MW1PEPF0001615D:EE_|CO1PR10MB4769:EE_
X-MS-Office365-Filtering-Correlation-Id: b780f6f7-21ed-4d27-fa08-08df042e448e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|36860700016|376014|82310400026|56012099006|10067099003|3023799007|22082099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	qwYCo57Pna5yiCYVJKyQDocs9YM4Blzs+ORF67GOh7GvrHaRWUyWlamP9+M903iSflPMkF4+UXP9SSjf86kqwGGQl0BKk+xP0rtDx1HPon2XGDFxHkqZCQc72iRIDSpr5AGKTC7kRjYlkSWJ/kbo5F93auu9YSaDKiFCo3sZvN2Cxoz9Rnwhu3SNmibGoUIbjt4eUMcMXPAObDxrJjbeUCUhGFxEBCJwL1MHHJBvZUm+jXD7PR4LjHMnivjWlS1vjVzsWnSl4S+Y4L/x2c3ilTJRX31X1mYGThKxsYBzmxUPXIvMMkQtZ/o2MZv1CSVmPd1Ygo336BI87RVmH3gdcPvRC4Fa9d7TvUtfO9WCLhYlcbTj+CgW5OsU+GXbTvAOBANLY/lEfC+0by1lWEmSZSVOS3Jp9DO8PjPmMGgkpPDeHcIPUXzvItdIWnfbSnTPAAfoCKPfuACSHH+7HBuyZcV4lhwGywGIDPrqaCdKtHeUxmJ0jhRYeFw6obX/QAIuK/KLGfsr+4BLx9ZqmO6ft6n2xyjizZHHejWRyzayZw9K0p1VLeNheQEdA2SftZFENmN+2Kd4GFo+1MiuyqHhF60o5eSqg5JRe4y2cOYGZlenX0cJxAv26NyeGAYanMoar6Zdum/PmInLhDgHZn5eqw==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(36860700016)(376014)(82310400026)(56012099006)(10067099003)(3023799007)(22082099003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nMuJGrU6KgJg/PmFagXiVWpY4bXE0j3+fSuCZo6D2OYkoHCICKPP0LzxSPd55uzxc0GMz4NOtvITfoQzZMOI/NVbeD+tdMBPZN/t0CeKOeoKZn8BknI89RiC5CgFkgUr8MEv15xmiLAf+zNadBIkERNczhu+hiU1neyJZOSor1ikuINkSMM/tP09q2VHH2wslKd1POVn09f+CCo12tkQsN7j6RxrqP1OXJf/t8ZuzqusFKzwfy4gZQ1AZymHommNU/Oc7VqVS4Q6mvSJBTklJIWc/Q5X7C4v9lYoJ/x9DOa1pWiMaXOcN+3HRMwHMTMpJIV/Yijjdb5RkTMD1nL2YQa6DlYXCkdmhIywEadeou/PihY0FJpfTI5wikeRn/41sEM8v31FLQkKv+Z9+CUg+Xf7NQjEkel3XwNK1aGjCfuRUUUnjEEy3BW/pEBsGe9J
X-Exchange-RoutingPolicyChecked:
	tofmKNb47M8RHcD0B4MJhq9Df/t2Fg5RLddBfuRY+TMlE53iHaPyzPTjNDVg7i3NDraWMYZCBG0n9sCZeYyumcuu7QFGkTWGPzNipRHfl0tjrqO+/BzNKCtYvjfHRn4jqR4qIcfNHY5AAP20DsIat0PKpPKnr4r+Ncs4HxLUc2hGqj4RHM9JTVEE8qz+RwTFlQNxeidBtL+zVcciHbCmhwcRXiNm03rIqGvQrfDzLy8aegV8XmU2SR48F0wUfXUKzDyTmut4QXoDBZ8xyollnaT/TZN8gLVLT7p97hXy5RlDh7qRL+Ayw6ZYeVSNDlGHlA/uV97hv1yru3D0bjtcOg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 11:28:07.3827
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b780f6f7-21ed-4d27-fa08-08df042e448e
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MW1PEPF0001615D.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4769
X-Proofpoint-GUID: 0IaIq3WHN1nk4HZIpvDTlhKi9dTVKE-i
X-Authority-Analysis: v=2.4 cv=M4597Sws c=1 sm=1 tr=0 ts=6a901f50 cx=c_pps
 a=ar5COM9M0msGq9wDbiNjNQ==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=Sv0fKeRqtYgA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22
 a=sozttTNsAAAA:8 a=q9VKDJ3XZ0bnZHqd0L8A:9
X-Proofpoint-ORIG-GUID: 0IaIq3WHN1nk4HZIpvDTlhKi9dTVKE-i
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDA5NSBTYWx0ZWRfX5MtX6ee6wBOE
 3nZamZfm2DbZ9HCAK7OuUrBC7ArCWzqT7A/0lQkYubBeirK22sy6gJkYwQEHuV+YcBXj+V62sA/
 bthZnMLirtpx3KjNzlCN+0wWkjOCWzNEIIi4tAjI0eILGarZRF+nIjXs17RkVrgvCgSybBxdTFr
 X6UMTxaBvUzYGPXOF5aqJpCmbelyCo+3wNwsuH0OUTJGCQDakcRggCljNRRM+q3Y6Vry5n7KQ2l
 ie/D6jTgW1FIjzK/3a9LzXIgHwHKVhj9ZxD4HVO9JyUWB1fZ9CaXjkkRy0ngfNzlFDdtk/oz77V
 jXjFtROxVF7m3AeJtzijSyfCb5tbBNSifdeYkUlZqZJlEorpr26uC/40cacPsJuUccmN8u446n8
 RAQAeSM2Jh+bmiSb/ef9EOfc9chY/BUz0ZxamJWyZvJVjRc+UNUe+kumUNJVqV0fpoqhT26V3kH
 CLJqEGOYMf8Bg02hm3w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDA5NSBTYWx0ZWRfXx9c+N85efJYR
 LOJIqgjgr3ZA4du3mwWOJJ5rDIze0GXcRjpkvOuXjLu0Y9xG6QMaF1R1FYp7NRLti7ye5h0f6vr
 4NU+i7W62CKhnyDKWKVpOa9s+RUiqoM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_04,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 impostorscore=0 spamscore=0 clxscore=1015
 bulkscore=0 priorityscore=1501 phishscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608270095

Add support for SHA224, SHA256, SHA384, SHA512 algorithms in the Hashing
Engine of the DTHEv2 hardware cryptographic engine.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/Kconfig         |   2 +
 drivers/crypto/ti/Makefile        |   2 +-
 drivers/crypto/ti/dthev2-aes.c    |  10 +-
 drivers/crypto/ti/dthev2-common.c |  43 +-
 drivers/crypto/ti/dthev2-common.h |  52 ++-
 drivers/crypto/ti/dthev2-hash.c   | 722 ++++++++++++++++++++++++++++++
 6 files changed, 814 insertions(+), 17 deletions(-)
 create mode 100644 drivers/crypto/ti/dthev2-hash.c

diff --git a/drivers/crypto/ti/Kconfig b/drivers/crypto/ti/Kconfig
index 1a3a571ac8cef..90af2c7cb1c55 100644
--- a/drivers/crypto/ti/Kconfig
+++ b/drivers/crypto/ti/Kconfig
@@ -10,6 +10,8 @@ config CRYPTO_DEV_TI_DTHEV2
 	select CRYPTO_XTS
 	select CRYPTO_GCM
 	select CRYPTO_CCM
+	select CRYPTO_SHA256
+	select CRYPTO_SHA512
 	select SG_SPLIT
 	help
 	  This enables support for the TI DTHE V2 hw cryptography engine
diff --git a/drivers/crypto/ti/Makefile b/drivers/crypto/ti/Makefile
index b883078f203d7..a90bc97a52321 100644
--- a/drivers/crypto/ti/Makefile
+++ b/drivers/crypto/ti/Makefile
@@ -1,3 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_CRYPTO_DEV_TI_DTHEV2) += dthev2.o
-dthev2-objs := dthev2-common.o dthev2-aes.o
+dthev2-objs := dthev2-common.o dthev2-aes.o dthev2-hash.o
diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 3769fd7da8d0f..dd63cb27ed6d5 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -21,7 +21,6 @@
 #include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
 #include <linux/io.h>
-#include <linux/iopoll.h>
 #include <linux/scatterlist.h>
 
 /* Registers */
@@ -105,7 +104,6 @@ enum aes_ctrl_mode_masks {
 #define DTHE_AES_GCM_AAD_MAXLEN			(BIT_ULL(32) - 1)
 #define DTHE_AES_CCM_AAD_MAXLEN			(BIT(16) - BIT(8))
 #define DTHE_AES_CCM_CRYPT_MAXLEN		(BIT_ULL(61) - 1)
-#define POLL_TIMEOUT_INTERVAL			HZ
 
 static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
 {
@@ -508,7 +506,7 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 		ret = dthe_aes_do_fallback(req);
 
 	local_bh_disable();
-	crypto_finalize_skcipher_request(dev_data->engine, req, ret);
+	crypto_finalize_skcipher_request(engine, req, ret);
 	local_bh_enable();
 	return 0;
 }
@@ -543,7 +541,7 @@ static int dthe_aes_crypt(struct skcipher_request *req)
 		return 0;
 	}
 
-	engine = dev_data->engine;
+	engine = dev_data->aes_engine;
 	return crypto_transfer_skcipher_request_to_engine(engine, req);
 }
 
@@ -713,7 +711,7 @@ static int dthe_aead_read_tag(struct dthe_tfm_ctx *ctx, u32 *tag)
 
 	ret = readl_relaxed_poll_timeout(aes_base_reg + DTHE_P_AES_CTRL, val,
 					 (val & DTHE_AES_CTRL_SAVED_CTX_READY),
-					 0, POLL_TIMEOUT_INTERVAL);
+					 0, DTHE_POLL_TIMEOUT_INTERVAL);
 	if (ret)
 		return ret;
 
@@ -1184,7 +1182,7 @@ static int dthe_aead_crypt(struct aead_request *req)
 	    (ctx->aes_mode == DTHE_AES_CCM && !is_zero_ctr))
 		return dthe_aead_do_fallback(req);
 
-	engine = dev_data->engine;
+	engine = dev_data->aes_engine;
 	return crypto_transfer_aead_request_to_engine(engine, req);
 }
 
diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index 3844faf5fec1f..3eab3ef6c37cf 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -108,6 +108,11 @@ static int dthe_dma_init(struct dthe_data *dev_data)
 		goto err_dma_sha_tx;
 	}
 
+	/*
+	 * Do AES Rx and Tx channel config here because it is invariant of AES mode
+	 * SHA Tx channel config is done before DMA transfer depending on hashing algorithm
+	 */
+
 	memzero_explicit(&cfg, sizeof(cfg));
 
 	cfg.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
@@ -142,11 +147,21 @@ static int dthe_dma_init(struct dthe_data *dev_data)
 
 static int dthe_register_algs(void)
 {
-	return dthe_register_aes_algs();
+	int ret = 0;
+
+	ret = dthe_register_hash_algs();
+	if (ret)
+		return ret;
+	ret = dthe_register_aes_algs();
+	if (ret)
+		dthe_unregister_hash_algs();
+
+	return ret;
 }
 
 static void dthe_unregister_algs(void)
 {
+	dthe_unregister_hash_algs();
 	dthe_unregister_aes_algs();
 }
 
@@ -175,15 +190,26 @@ static int dthe_probe(struct platform_device *pdev)
 	if (ret)
 		goto probe_dma_err;
 
-	dev_data->engine = crypto_engine_alloc_init(dev, 1);
-	if (!dev_data->engine) {
+	dev_data->aes_engine = crypto_engine_alloc_init(dev, 1);
+	if (!dev_data->aes_engine) {
 		ret = -ENOMEM;
 		goto probe_engine_err;
 	}
+	dev_data->hash_engine = crypto_engine_alloc_init(dev, 1);
+	if (!dev_data->hash_engine) {
+		ret = -ENOMEM;
+		goto probe_hash_engine_err;
+	}
+
+	ret = crypto_engine_start(dev_data->aes_engine);
+	if (ret) {
+		dev_err(dev, "Failed to start crypto engine for AES\n");
+		goto probe_engine_start_err;
+	}
 
-	ret = crypto_engine_start(dev_data->engine);
+	ret = crypto_engine_start(dev_data->hash_engine);
 	if (ret) {
-		dev_err(dev, "Failed to start crypto engine\n");
+		dev_err(dev, "Failed to start crypto engine for hash\n");
 		goto probe_engine_start_err;
 	}
 
@@ -196,7 +222,9 @@ static int dthe_probe(struct platform_device *pdev)
 	return 0;
 
 probe_engine_start_err:
-	crypto_engine_exit(dev_data->engine);
+	crypto_engine_exit(dev_data->hash_engine);
+probe_hash_engine_err:
+	crypto_engine_exit(dev_data->aes_engine);
 probe_engine_err:
 	dma_release_channel(dev_data->dma_aes_rx);
 	dma_release_channel(dev_data->dma_aes_tx);
@@ -227,7 +255,8 @@ static void dthe_remove(struct platform_device *pdev)
 	list_del(&dev_data->list);
 	spin_unlock(&dthe_dev_list.lock);
 
-	crypto_engine_exit(dev_data->engine);
+	crypto_engine_exit(dev_data->aes_engine);
+	crypto_engine_exit(dev_data->hash_engine);
 
 	dma_release_channel(dev_data->dma_aes_rx);
 	dma_release_channel(dev_data->dma_aes_tx);
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index 8eb27812b8cdf..97ba76340ffad 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -17,6 +17,7 @@
 #include <crypto/internal/aead.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/sha2.h>
 
 #include <linux/atomic.h>
 #include <linux/delay.h>
@@ -24,16 +25,28 @@
 #include <linux/dmapool.h>
 #include <linux/dma-mapping.h>
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/scatterlist.h>
 
 #define DTHE_REG_SIZE		4
 #define DTHE_DMA_TIMEOUT_MS	2000
+#define DTHE_POLL_TIMEOUT_INTERVAL	HZ
 /*
  * Size of largest possible key (of all algorithms) to be stored in dthe_tfm_ctx
  * This is currently the keysize of XTS-AES-256 which is 512 bits (64 bytes)
  */
 #define DTHE_MAX_KEYSIZE	(AES_MAX_KEY_SIZE * 2)
 
+enum dthe_hash_alg_sel {
+	DTHE_HASH_MD5		= 0,
+	DTHE_HASH_SHA1		= BIT(1),
+	DTHE_HASH_SHA224	= BIT(2),
+	DTHE_HASH_SHA256	= BIT(1) | BIT(2),
+	DTHE_HASH_SHA384	= BIT(0),
+	DTHE_HASH_SHA512	= BIT(0) | BIT(1),
+	DTHE_HASH_ERR		= BIT(0) | BIT(1) | BIT(2),
+};
+
 enum dthe_aes_mode {
 	DTHE_AES_ECB = 0,
 	DTHE_AES_CBC,
@@ -50,7 +63,8 @@ enum dthe_aes_mode {
  * @dev: Device pointer
  * @regs: Base address of the register space
  * @list: list node for dev
- * @engine: Crypto engine instance
+ * @aes_engine: Crypto engine instance for AES Engine
+ * @hash_engine: Crypto engine instance for Hashing Engine
  * @dma_aes_rx: AES Rx DMA Channel
  * @dma_aes_tx: AES Tx DMA Channel
  * @dma_sha_tx: SHA Tx DMA Channel
@@ -60,7 +74,8 @@ struct dthe_data {
 	struct device *dev;
 	void __iomem *regs;
 	struct list_head list;
-	struct crypto_engine *engine;
+	struct crypto_engine *aes_engine;
+	struct crypto_engine *hash_engine;
 
 	struct dma_chan *dma_aes_rx;
 	struct dma_chan *dma_aes_tx;
@@ -87,6 +102,8 @@ struct dthe_list {
  * @authsize: Authentication size for modes with authentication
  * @key: AES key
  * @aes_mode: AES mode
+ * @hash_mode: Hashing Engine mode
+ * @phash_size: partial hash size of the hash algorithm selected
  * @aead_fb: Fallback crypto aead handle
  * @skcipher_fb: Fallback crypto skcipher handle for AES-XTS mode
  */
@@ -95,7 +112,11 @@ struct dthe_tfm_ctx {
 	unsigned int keylen;
 	unsigned int authsize;
 	u32 key[DTHE_MAX_KEYSIZE / sizeof(u32)];
-	enum dthe_aes_mode aes_mode;
+	union {
+		enum dthe_aes_mode aes_mode;
+		enum dthe_hash_alg_sel hash_mode;
+	};
+	unsigned int phash_size;
 	union {
 		struct crypto_sync_aead *aead_fb;
 		struct crypto_sync_skcipher *skcipher_fb;
@@ -114,6 +135,28 @@ struct dthe_aes_req_ctx {
 	struct completion aes_compl;
 };
 
+/**
+ * struct dthe_hash_req_ctx - Hashing engine ctx struct
+ * @phash: buffer to store a partial hash from a previous operation
+ * @digestcnt: stores the digest count from a previous operation; currently hardware only provides
+ *             a single 32-bit value even for SHA384/512
+ * @padding: padding buffer for handling unaligned data
+ * @data: buffer to store one block of data to defer operations for non-zero final.
+ * @flags: bitfield of flags for internal use.
+ *         bit 0: Current operation (update/finup)
+ *         bit 1: If phash is available from a previous operation
+ *         bit 2: If data is buffered from a previous operation
+ * @hash_compl: Completion variable for use in manual completion in case of DMA callback failure
+ */
+struct dthe_hash_req_ctx {
+	u32 phash[SHA512_DIGEST_SIZE / sizeof(u32)];
+	u64 digestcnt[2];
+	u8 padding[SHA512_BLOCK_SIZE];
+	u8 data[SHA512_BLOCK_SIZE];
+	u8 flags;
+	struct completion hash_compl;
+};
+
 /* Struct definitions end */
 
 struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx);
@@ -136,4 +179,7 @@ struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
 int dthe_register_aes_algs(void);
 void dthe_unregister_aes_algs(void);
 
+int dthe_register_hash_algs(void);
+void dthe_unregister_hash_algs(void);
+
 #endif
diff --git a/drivers/crypto/ti/dthev2-hash.c b/drivers/crypto/ti/dthev2-hash.c
new file mode 100644
index 0000000000000..ca0c04d40c769
--- /dev/null
+++ b/drivers/crypto/ti/dthev2-hash.c
@@ -0,0 +1,722 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * K3 DTHE V2 crypto accelerator driver
+ *
+ * Copyright (C) Texas Instruments 2025 - https://www.ti.com
+ * Author: T Pratham <t-pratham@ti.com>
+ */
+
+#include <crypto/algapi.h>
+#include <crypto/hash.h>
+#include <crypto/internal/hash.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/sha2.h>
+
+#include "dthev2-common.h"
+
+#include <linux/bitfield.h>
+#include <linux/delay.h>
+#include <linux/dmaengine.h>
+#include <linux/dma-mapping.h>
+#include <linux/io.h>
+#include <linux/scatterlist.h>
+
+/* Registers */
+
+#define DTHE_P_HASH_BASE		0x5000
+#define DTHE_P_HASH512_IDIGEST_A	0x0240
+#define DTHE_P_HASH512_DIGEST_COUNT	0x0280
+#define DTHE_P_HASH512_MODE		0x0284
+#define DTHE_P_HASH512_LENGTH		0x0288
+#define DTHE_P_HASH512_DATA_IN_START	0x0080
+#define DTHE_P_HASH512_DATA_IN_END	0x00FC
+
+#define DTHE_P_HASH_SYSCONFIG		0x0110
+#define DTHE_P_HASH_IRQSTATUS		0x0118
+#define DTHE_P_HASH_IRQENABLE		0x011C
+
+/* Register write values and macros */
+#define DTHE_HASH_SYSCONFIG_INT_EN		BIT(2)
+#define DTHE_HASH_SYSCONFIG_DMA_EN		BIT(3)
+#define DTHE_HASH_IRQENABLE_EN_ALL		GENMASK(3, 0)
+#define DTHE_HASH_IRQSTATUS_OP_READY		BIT(0)
+#define DTHE_HASH_IRQSTATUS_IP_READY		BIT(1)
+#define DTHE_HASH_IRQSTATUS_PH_READY		BIT(2)
+#define DTHE_HASH_IRQSTATUS_CTX_READY		BIT(3)
+
+#define DTHE_HASH_MODE_USE_ALG_CONST		BIT(3)
+#define DTHE_HASH_MODE_CLOSE_HASH		BIT(4)
+
+/* rctx flag bitfields */
+#define DTHE_HASH_FLAG_OP		BIT(0)
+#define DTHE_HASH_FLAG_PHASH_AVAIL	BIT(1)
+#define DTHE_HASH_FLAG_IS_DATA_HELD	BIT(2)
+
+enum dthe_hash_op {
+	DTHE_HASH_OP_UPDATE = 0,
+	DTHE_HASH_OP_FINUP  = 1,
+};
+
+static inline bool dthe_hash_has_flag(struct dthe_hash_req_ctx *rctx, u8 flag)
+{
+	return rctx->flags & flag;
+}
+
+static inline void dthe_hash_flag_set(struct dthe_hash_req_ctx *rctx, u8 flag)
+{
+	rctx->flags |= flag;
+}
+
+static inline void dthe_hash_flag_clear(struct dthe_hash_req_ctx *rctx, u8 flag)
+{
+	rctx->flags &= ~flag;
+}
+
+static inline bool dthe_hash_flag_is_op(struct dthe_hash_req_ctx *rctx, enum dthe_hash_op op)
+{
+	return FIELD_GET(DTHE_HASH_FLAG_OP, rctx->flags) == op;
+}
+
+static inline void dthe_hash_flag_set_op(struct dthe_hash_req_ctx *rctx, enum dthe_hash_op op)
+{
+	FIELD_MODIFY(DTHE_HASH_FLAG_OP, &rctx->flags, op);
+}
+
+static void dthe_hash_write_zero_message(enum dthe_hash_alg_sel mode, void *dst)
+{
+	switch (mode) {
+	case DTHE_HASH_SHA512:
+		memcpy(dst, sha512_zero_message_hash, SHA512_DIGEST_SIZE);
+		break;
+	case DTHE_HASH_SHA384:
+		memcpy(dst, sha384_zero_message_hash, SHA384_DIGEST_SIZE);
+		break;
+	case DTHE_HASH_SHA256:
+		memcpy(dst, sha256_zero_message_hash, SHA256_DIGEST_SIZE);
+		break;
+	case DTHE_HASH_SHA224:
+		memcpy(dst, sha224_zero_message_hash, SHA224_DIGEST_SIZE);
+		break;
+	default:
+		break;
+	}
+}
+
+static enum dthe_hash_alg_sel dthe_hash_get_hash_mode(struct crypto_ahash *tfm)
+{
+	unsigned int ds = crypto_ahash_digestsize(tfm);
+	enum dthe_hash_alg_sel hash_mode;
+
+	/*
+	 * Currently, all hash algorithms supported by DTHEv2 have unique digest sizes.
+	 * So we can do this. Otherwise, we would have to get the algorithm from the
+	 * alg_name and do a strcmp.
+	 */
+	switch (ds) {
+	case SHA512_DIGEST_SIZE:
+		hash_mode = DTHE_HASH_SHA512;
+		break;
+	case SHA384_DIGEST_SIZE:
+		hash_mode = DTHE_HASH_SHA384;
+		break;
+	case SHA256_DIGEST_SIZE:
+		hash_mode = DTHE_HASH_SHA256;
+		break;
+	case SHA224_DIGEST_SIZE:
+		hash_mode = DTHE_HASH_SHA224;
+		break;
+	default:
+		hash_mode = DTHE_HASH_ERR;
+		break;
+	}
+
+	return hash_mode;
+}
+
+static unsigned int dthe_hash_get_phash_size(struct dthe_tfm_ctx *ctx)
+{
+	unsigned int phash_size = 0;
+
+	switch (ctx->hash_mode) {
+	case DTHE_HASH_SHA512:
+	case DTHE_HASH_SHA384:
+		phash_size = SHA512_DIGEST_SIZE;
+		break;
+	case DTHE_HASH_SHA256:
+	case DTHE_HASH_SHA224:
+		phash_size = SHA256_DIGEST_SIZE;
+		break;
+	default:
+		break;
+	}
+
+	return phash_size;
+}
+
+static int dthe_hash_init_tfm(struct crypto_ahash *tfm)
+{
+	struct dthe_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+
+	if (!dev_data)
+		return -ENODEV;
+
+	ctx->dev_data = dev_data;
+
+	ctx->hash_mode = dthe_hash_get_hash_mode(tfm);
+	if (ctx->hash_mode == DTHE_HASH_ERR) {
+		dthe_put_dev(ctx);
+		return -EINVAL;
+	}
+
+	ctx->phash_size = dthe_hash_get_phash_size(ctx);
+
+	return 0;
+}
+
+static void dthe_hash_exit_tfm(struct crypto_ahash *tfm)
+{
+	struct dthe_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
+
+	dthe_put_dev(ctx);
+}
+
+static int dthe_hash_config_dma_chan(struct dma_chan *chan, struct crypto_ahash *tfm)
+{
+	struct dma_slave_config cfg;
+	int bs = crypto_ahash_blocksize(tfm);
+
+	memzero_explicit(&cfg, sizeof(cfg));
+
+	cfg.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	cfg.dst_maxburst = bs / 4;
+
+	return dmaengine_slave_config(chan, &cfg);
+}
+
+static void dthe_hash_dma_in_callback(void *data)
+{
+	struct ahash_request *req = (struct ahash_request *)data;
+	struct dthe_hash_req_ctx *rctx = ahash_request_ctx(req);
+
+	complete(&rctx->hash_compl);
+}
+
+static int dthe_hash_dma_start(struct ahash_request *req, struct scatterlist *src,
+			       int src_nents, size_t len)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct dthe_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct dthe_hash_req_ctx *rctx = ahash_request_ctx(req);
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct device *tx_dev;
+	struct dma_async_tx_descriptor *desc_out;
+	int mapped_nents;
+	enum dma_data_direction src_dir = DMA_TO_DEVICE;
+	u32 hash_mode;
+	int ds = crypto_ahash_digestsize(tfm);
+	int ret = 0;
+	u32 *dst;
+	u32 dst_len;
+	u32 _status;
+	void __iomem *sha_base_reg = dev_data->regs + DTHE_P_HASH_BASE;
+
+	u32 hash_sysconfig_val = DTHE_HASH_SYSCONFIG_INT_EN | DTHE_HASH_SYSCONFIG_DMA_EN;
+	u32 hash_irqenable_val = DTHE_HASH_IRQENABLE_EN_ALL;
+
+	writel_relaxed(hash_sysconfig_val, sha_base_reg + DTHE_P_HASH_SYSCONFIG);
+	writel_relaxed(hash_irqenable_val, sha_base_reg + DTHE_P_HASH_IRQENABLE);
+
+	/* Config SHA DMA channel as per SHA mode */
+	ret = dthe_hash_config_dma_chan(dev_data->dma_sha_tx, tfm);
+	if (ret) {
+		dev_err(dev_data->dev, "Can't configure sha_tx dmaengine slave: %d\n", ret);
+		goto hash_err;
+	}
+
+	tx_dev = dmaengine_get_dma_device(dev_data->dma_sha_tx);
+	if (!tx_dev) {
+		ret = -ENODEV;
+		goto hash_err;
+	}
+
+	mapped_nents = dma_map_sg(tx_dev, src, src_nents, src_dir);
+	if (mapped_nents == 0) {
+		ret = -EINVAL;
+		goto hash_err;
+	}
+
+	desc_out = dmaengine_prep_slave_sg(dev_data->dma_sha_tx, src, mapped_nents,
+					   DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!desc_out) {
+		dev_err(dev_data->dev, "OUT prep_slave_sg() failed\n");
+		ret = -EINVAL;
+		goto hash_prep_err;
+	}
+
+	desc_out->callback = dthe_hash_dma_in_callback;
+	desc_out->callback_param = req;
+
+	init_completion(&rctx->hash_compl);
+
+	hash_mode = ctx->hash_mode;
+
+	if (dthe_hash_flag_is_op(rctx, DTHE_HASH_OP_FINUP))
+		hash_mode |= DTHE_HASH_MODE_CLOSE_HASH;
+
+	if (dthe_hash_has_flag(rctx, DTHE_HASH_FLAG_PHASH_AVAIL)) {
+		for (int i = 0; i < ctx->phash_size / sizeof(u32); ++i)
+			writel_relaxed(rctx->phash[i],
+				       sha_base_reg +
+				       DTHE_P_HASH512_IDIGEST_A +
+				       (DTHE_REG_SIZE * i));
+
+		writel_relaxed(rctx->digestcnt[0],
+			       sha_base_reg + DTHE_P_HASH512_DIGEST_COUNT);
+	} else {
+		hash_mode |= DTHE_HASH_MODE_USE_ALG_CONST;
+	}
+
+	writel_relaxed(hash_mode, sha_base_reg + DTHE_P_HASH512_MODE);
+	writel_relaxed(len, sha_base_reg + DTHE_P_HASH512_LENGTH);
+
+	dmaengine_submit(desc_out);
+
+	dma_async_issue_pending(dev_data->dma_sha_tx);
+
+	ret = wait_for_completion_timeout(&rctx->hash_compl,
+					  msecs_to_jiffies(DTHE_DMA_TIMEOUT_MS));
+	if (!ret) {
+		dmaengine_terminate_sync(dev_data->dma_sha_tx);
+		ret = -ETIMEDOUT;
+	} else {
+		ret = 0;
+	}
+
+	/* Poll output ready status register */
+	if (!ret)
+		ret = readl_relaxed_poll_timeout(sha_base_reg + DTHE_P_HASH_IRQSTATUS, _status,
+						 (_status & DTHE_HASH_IRQSTATUS_OP_READY),
+						 0, DTHE_POLL_TIMEOUT_INTERVAL);
+
+	/**
+	 * We need to read the output registers even in case of failure (ret != 0) to clear
+	 * them properly for future operations. But the function returning a non-zero value
+	 * should indicate that something went wrong and the result value should not be used.
+	 */
+	if (dthe_hash_flag_is_op(rctx, DTHE_HASH_OP_UPDATE)) {
+		/* If coming from update, we need to read the phash and store it for future */
+		dst = rctx->phash;
+		dst_len = ctx->phash_size / sizeof(u32);
+	} else {
+		/* If coming from finup or final, we need to read the final digest */
+		dst = (u32 *)req->result;
+		dst_len = ds / sizeof(u32);
+	}
+
+	for (int i = 0; i < dst_len; ++i)
+		put_unaligned(readl_relaxed(sha_base_reg +
+					    DTHE_P_HASH512_IDIGEST_A +
+					    (DTHE_REG_SIZE * i)),
+			      &dst[i]);
+
+	rctx->digestcnt[0] = readl_relaxed(sha_base_reg + DTHE_P_HASH512_DIGEST_COUNT);
+	dthe_hash_flag_set(rctx, DTHE_HASH_FLAG_PHASH_AVAIL);
+
+hash_prep_err:
+	dma_unmap_sg(tx_dev, src, src_nents, src_dir);
+hash_err:
+	return ret;
+}
+
+static int dthe_hash_run(struct crypto_engine *engine, void *areq)
+{
+	struct ahash_request *req = container_of(areq, struct ahash_request, base);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct dthe_hash_req_ctx *rctx = ahash_request_ctx(req);
+
+	struct scatterlist *src, *sg;
+	int src_nents = 0;
+	unsigned int bs = crypto_ahash_blocksize(tfm);
+	unsigned int tot_len = req->nbytes;
+	unsigned int len_to_process;
+	unsigned int len_to_buffer;
+	unsigned int len_to_send;
+	unsigned int pad_len = 0;
+	bool is_data_held = dthe_hash_has_flag(rctx, DTHE_HASH_FLAG_IS_DATA_HELD);
+	u8 *pad_buf = rctx->padding;
+	int ret = 0;
+
+	if (dthe_hash_flag_is_op(rctx, DTHE_HASH_OP_UPDATE)) {
+		len_to_process = tot_len - (tot_len % bs);
+		len_to_buffer = tot_len % bs;
+
+		if (len_to_process == 0) {
+			ret = len_to_buffer;
+			goto hash_buf_all;
+		}
+
+		/*
+		 * Additionally hold back a trailing block in req ctx, so
+		 * that hardware has data to do CLOSE_HASH in finup.
+		 * Consume any block held from a previous round first.
+		 */
+		len_to_process -= bs;
+		len_to_send = len_to_process + (is_data_held ? bs : 0);
+
+		if (len_to_send == 0) {
+			memcpy_from_sglist(rctx->data, req->src, 0, bs);
+			dthe_hash_flag_set(rctx, DTHE_HASH_FLAG_IS_DATA_HELD);
+			ret = len_to_buffer;
+			goto hash_buf_all;
+		}
+	} else {
+		len_to_process = tot_len;
+		len_to_send = len_to_process + (is_data_held ? bs : 0);
+		len_to_buffer = 0;
+	}
+
+	src_nents = sg_nents_for_len(req->src, len_to_process);
+	if (is_data_held)
+		src_nents++;
+
+	/*
+	 * Certain DMA restrictions forced us to send data in multiples of BLOCK_SIZE
+	 * bytes. So, add a padding 0s at the end of src scatterlist if data is not a
+	 * multiple of block_size bytes (Can only happen in final or finup). The extra
+	 * data is ignored by the DTHE hardware.
+	 */
+	if (len_to_send % bs) {
+		pad_len = bs - (len_to_send % bs);
+		src_nents++;
+	}
+
+	src = kcalloc(src_nents, sizeof(*src), GFP_KERNEL);
+	if (!src) {
+		ret = -ENOMEM;
+		goto hash_buf_all;
+	}
+
+	sg_init_table(src, src_nents);
+	sg = src;
+	if (is_data_held) {
+		sg_set_buf(sg, rctx->data, bs);
+		sg = sg_next(sg);
+	}
+	sg = dthe_copy_sg(sg, req->src, len_to_process);
+	if (pad_len > 0) {
+		memset(pad_buf, 0, pad_len);
+		sg_set_buf(sg, pad_buf, pad_len);
+	}
+
+	ret = dthe_hash_dma_start(req, src, src_nents, len_to_send);
+	if (!ret) {
+		if (dthe_hash_flag_is_op(rctx, DTHE_HASH_OP_UPDATE)) {
+			memcpy_from_sglist(rctx->data, req->src, len_to_process, bs);
+			dthe_hash_flag_set(rctx, DTHE_HASH_FLAG_IS_DATA_HELD);
+		}
+		ret = len_to_buffer;
+	}
+
+	kfree(src);
+
+hash_buf_all:
+	local_bh_disable();
+	crypto_finalize_hash_request(engine, req, ret);
+	local_bh_enable();
+	return 0;
+}
+
+static int dthe_hash_init(struct ahash_request *req)
+{
+	struct dthe_hash_req_ctx *rctx = ahash_request_ctx(req);
+
+	rctx->flags = 0;
+	rctx->digestcnt[0] = 0;
+	rctx->digestcnt[1] = 0;
+	memzero_explicit(rctx->data, sizeof(rctx->data));
+
+	return 0;
+}
+
+static int dthe_hash_update(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct dthe_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct dthe_hash_req_ctx *rctx = ahash_request_ctx(req);
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct crypto_engine *engine = dev_data->hash_engine;
+
+	if (req->nbytes == 0)
+		return 0;
+
+	dthe_hash_flag_set_op(rctx, DTHE_HASH_OP_UPDATE);
+
+	return crypto_transfer_hash_request_to_engine(engine, req);
+}
+
+static int dthe_hash_final(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct dthe_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct dthe_hash_req_ctx *rctx = ahash_request_ctx(req);
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct crypto_engine *engine = dev_data->hash_engine;
+
+	/**
+	 * We are always buffering data in update, except when nbytes = 0.
+	 * So, either we get the buffered data here (nbytes > 0), or there is
+	 * a full block held back from a previous update (IS_DATA_HELD), or it
+	 * is the case that we got a zero message to begin with.
+	 */
+	if (req->nbytes > 0 || dthe_hash_has_flag(rctx, DTHE_HASH_FLAG_IS_DATA_HELD)) {
+		dthe_hash_flag_set_op(rctx, DTHE_HASH_OP_FINUP);
+
+		return crypto_transfer_hash_request_to_engine(engine, req);
+	}
+
+	dthe_hash_write_zero_message(ctx->hash_mode, req->result);
+
+	return 0;
+}
+
+static int dthe_hash_finup(struct ahash_request *req)
+{
+	/* With AHASH_ALG_BLOCK_ONLY, final becomes same as finup. */
+	return dthe_hash_final(req);
+}
+
+static int dthe_hash_digest(struct ahash_request *req)
+{
+	dthe_hash_init(req);
+	return dthe_hash_finup(req);
+}
+
+static const u32 sha224_init_state[SHA256_DIGEST_SIZE / sizeof(u32)] = {
+	SHA224_H0, SHA224_H1, SHA224_H2, SHA224_H3,
+	SHA224_H4, SHA224_H5, SHA224_H6, SHA224_H7
+};
+
+static const u32 sha256_init_state[SHA256_DIGEST_SIZE / sizeof(u32)] = {
+	SHA256_H0, SHA256_H1, SHA256_H2, SHA256_H3,
+	SHA256_H4, SHA256_H5, SHA256_H6, SHA256_H7
+};
+
+static const u64 sha384_init_state[SHA512_DIGEST_SIZE / sizeof(u64)] = {
+	SHA384_H0, SHA384_H1, SHA384_H2, SHA384_H3,
+	SHA384_H4, SHA384_H5, SHA384_H6, SHA384_H7
+};
+
+static const u64 sha512_init_state[SHA512_DIGEST_SIZE / sizeof(u64)] = {
+	SHA512_H0, SHA512_H1, SHA512_H2, SHA512_H3,
+	SHA512_H4, SHA512_H5, SHA512_H6, SHA512_H7
+};
+
+static const void *dthe_hash_get_init_state(struct dthe_tfm_ctx *ctx)
+{
+	switch (ctx->hash_mode) {
+	case DTHE_HASH_SHA224:
+		return sha224_init_state;
+	case DTHE_HASH_SHA256:
+		return sha256_init_state;
+	case DTHE_HASH_SHA384:
+		return sha384_init_state;
+	case DTHE_HASH_SHA512:
+		return sha512_init_state;
+	default:
+		return NULL;
+	}
+}
+
+static int dthe_hash_export(struct ahash_request *req, void *out)
+{
+	struct dthe_hash_req_ctx *rctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct dthe_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
+	unsigned int bs = crypto_ahash_blocksize(tfm);
+	union {
+		u8 *u8;
+		u64 *u64;
+	} p = { .u8 = out };
+
+	if (dthe_hash_has_flag(rctx, DTHE_HASH_FLAG_PHASH_AVAIL))
+		memcpy(out, rctx->phash, ctx->phash_size);
+	else
+		memcpy(out, dthe_hash_get_init_state(ctx), ctx->phash_size);
+
+	p.u8 += ctx->phash_size;
+	put_unaligned(rctx->digestcnt[0], p.u64++);
+	if (ctx->phash_size >= SHA512_DIGEST_SIZE)
+		put_unaligned(rctx->digestcnt[1], p.u64++);
+
+	memcpy(p.u8, rctx->data, bs);
+	p.u8 += bs;
+	put_unaligned(rctx->flags, p.u8++);
+
+	return 0;
+}
+
+static int dthe_hash_import(struct ahash_request *req, const void *in)
+{
+	struct dthe_hash_req_ctx *rctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct dthe_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
+	unsigned int bs = crypto_ahash_blocksize(tfm);
+	union {
+		const u8 *u8;
+		const u64 *u64;
+	} p = { .u8 = in };
+
+	memcpy(rctx->phash, in, ctx->phash_size);
+	p.u8 += ctx->phash_size;
+	rctx->digestcnt[0] = get_unaligned(p.u64++);
+	if (ctx->phash_size >= SHA512_DIGEST_SIZE)
+		rctx->digestcnt[1] = get_unaligned(p.u64++);
+
+	memcpy(rctx->data, p.u8, bs);
+	p.u8 += bs;
+	rctx->flags = get_unaligned(p.u8++);
+
+	return 0;
+}
+
+static struct ahash_engine_alg hash_algs[] = {
+	{
+		.base.init_tfm	= dthe_hash_init_tfm,
+		.base.exit_tfm	= dthe_hash_exit_tfm,
+		.base.init	= dthe_hash_init,
+		.base.update	= dthe_hash_update,
+		.base.final	= dthe_hash_final,
+		.base.finup	= dthe_hash_finup,
+		.base.digest	= dthe_hash_digest,
+		.base.export	= dthe_hash_export,
+		.base.import	= dthe_hash_import,
+		.base.halg	= {
+			.digestsize = SHA512_DIGEST_SIZE,
+			.statesize = sizeof(struct dthe_hash_req_ctx),
+			.base = {
+				.cra_name	 = "sha512",
+				.cra_driver_name = "sha512-dthev2",
+				.cra_priority	 = 299,
+				.cra_flags	 = CRYPTO_ALG_TYPE_AHASH |
+						   CRYPTO_ALG_ASYNC |
+						   CRYPTO_ALG_OPTIONAL_KEY |
+						   CRYPTO_ALG_KERN_DRIVER_ONLY |
+						   CRYPTO_ALG_ALLOCATES_MEMORY |
+						   CRYPTO_AHASH_ALG_BLOCK_ONLY |
+						   CRYPTO_AHASH_ALG_NO_EXPORT_CORE,
+				.cra_blocksize	 = SHA512_BLOCK_SIZE,
+				.cra_ctxsize	 = sizeof(struct dthe_tfm_ctx),
+				.cra_reqsize	 = sizeof(struct dthe_hash_req_ctx),
+				.cra_module	 = THIS_MODULE,
+			}
+		},
+		.op.do_one_request = dthe_hash_run,
+	},
+	{
+		.base.init_tfm	= dthe_hash_init_tfm,
+		.base.exit_tfm	= dthe_hash_exit_tfm,
+		.base.init	= dthe_hash_init,
+		.base.update	= dthe_hash_update,
+		.base.final	= dthe_hash_final,
+		.base.finup	= dthe_hash_finup,
+		.base.digest	= dthe_hash_digest,
+		.base.export	= dthe_hash_export,
+		.base.import	= dthe_hash_import,
+		.base.halg	= {
+			.digestsize = SHA384_DIGEST_SIZE,
+			.statesize = sizeof(struct dthe_hash_req_ctx),
+			.base = {
+				.cra_name	 = "sha384",
+				.cra_driver_name = "sha384-dthev2",
+				.cra_priority	 = 299,
+				.cra_flags	 = CRYPTO_ALG_TYPE_AHASH |
+						   CRYPTO_ALG_ASYNC |
+						   CRYPTO_ALG_OPTIONAL_KEY |
+						   CRYPTO_ALG_KERN_DRIVER_ONLY |
+						   CRYPTO_ALG_ALLOCATES_MEMORY |
+						   CRYPTO_AHASH_ALG_BLOCK_ONLY |
+						   CRYPTO_AHASH_ALG_NO_EXPORT_CORE,
+				.cra_blocksize	 = SHA384_BLOCK_SIZE,
+				.cra_ctxsize	 = sizeof(struct dthe_tfm_ctx),
+				.cra_reqsize	 = sizeof(struct dthe_hash_req_ctx),
+				.cra_module	 = THIS_MODULE,
+			}
+		},
+		.op.do_one_request = dthe_hash_run,
+	},
+	{
+		.base.init_tfm	= dthe_hash_init_tfm,
+		.base.exit_tfm	= dthe_hash_exit_tfm,
+		.base.init	= dthe_hash_init,
+		.base.update	= dthe_hash_update,
+		.base.final	= dthe_hash_final,
+		.base.finup	= dthe_hash_finup,
+		.base.digest	= dthe_hash_digest,
+		.base.export	= dthe_hash_export,
+		.base.import	= dthe_hash_import,
+		.base.halg	= {
+			.digestsize = SHA256_DIGEST_SIZE,
+			.statesize = sizeof(struct dthe_hash_req_ctx),
+			.base = {
+				.cra_name	 = "sha256",
+				.cra_driver_name = "sha256-dthev2",
+				.cra_priority	 = 299,
+				.cra_flags	 = CRYPTO_ALG_TYPE_AHASH |
+						   CRYPTO_ALG_ASYNC |
+						   CRYPTO_ALG_OPTIONAL_KEY |
+						   CRYPTO_ALG_KERN_DRIVER_ONLY |
+						   CRYPTO_ALG_ALLOCATES_MEMORY |
+						   CRYPTO_AHASH_ALG_BLOCK_ONLY |
+						   CRYPTO_AHASH_ALG_NO_EXPORT_CORE,
+				.cra_blocksize	 = SHA256_BLOCK_SIZE,
+				.cra_ctxsize	 = sizeof(struct dthe_tfm_ctx),
+				.cra_reqsize	 = sizeof(struct dthe_hash_req_ctx),
+				.cra_module	 = THIS_MODULE,
+			}
+		},
+		.op.do_one_request = dthe_hash_run,
+	},
+	{
+		.base.init_tfm	= dthe_hash_init_tfm,
+		.base.exit_tfm	= dthe_hash_exit_tfm,
+		.base.init	= dthe_hash_init,
+		.base.update	= dthe_hash_update,
+		.base.final	= dthe_hash_final,
+		.base.finup	= dthe_hash_finup,
+		.base.digest	= dthe_hash_digest,
+		.base.export	= dthe_hash_export,
+		.base.import	= dthe_hash_import,
+		.base.halg	= {
+			.digestsize = SHA224_DIGEST_SIZE,
+			.statesize = sizeof(struct dthe_hash_req_ctx),
+			.base = {
+				.cra_name	 = "sha224",
+				.cra_driver_name = "sha224-dthev2",
+				.cra_priority	 = 299,
+				.cra_flags	 = CRYPTO_ALG_TYPE_AHASH |
+						   CRYPTO_ALG_ASYNC |
+						   CRYPTO_ALG_OPTIONAL_KEY |
+						   CRYPTO_ALG_KERN_DRIVER_ONLY |
+						   CRYPTO_ALG_ALLOCATES_MEMORY |
+						   CRYPTO_AHASH_ALG_BLOCK_ONLY |
+						   CRYPTO_AHASH_ALG_NO_EXPORT_CORE,
+				.cra_blocksize	 = SHA224_BLOCK_SIZE,
+				.cra_ctxsize	 = sizeof(struct dthe_tfm_ctx),
+				.cra_reqsize	 = sizeof(struct dthe_hash_req_ctx),
+				.cra_module	 = THIS_MODULE,
+			}
+		},
+		.op.do_one_request = dthe_hash_run,
+	},
+};
+
+int dthe_register_hash_algs(void)
+{
+	return crypto_engine_register_ahashes(hash_algs, ARRAY_SIZE(hash_algs));
+}
+
+void dthe_unregister_hash_algs(void)
+{
+	crypto_engine_unregister_ahashes(hash_algs, ARRAY_SIZE(hash_algs));
+}
-- 
2.34.1

