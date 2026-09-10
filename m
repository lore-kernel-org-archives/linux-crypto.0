Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE93C563FCB;
	Thu, 10 Sep 2026 17:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789063071; cv=fail; b=jpED5hPBxlK3yklgmb/smU5koSsqaUIuk6UbTUgB+Spw3XTy3pie1EPplwwpy/GOwJWZEV45wVGGU9G3ubxONuKys21xeAN2c37G/ajJ6+ilQ4/2hdVqp737ijhiZNsE0c4rPHA+y7zZ6mcmjFo/sHB+4M3KjIjzVVrd33VQo/0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789063071; c=relaxed/simple;
	bh=14+lpbbjuBYbleZZptnnErmVsbsXKn0WAKM8jdF9Cmo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=isknBHDXe1V2Mb1sA57/yextXKa1u9CaGJ1HpY7VfBBzWA3LAVC+rzvzJmfdzSVZdqwaMB7X5+ItvP3LC5JcneGeSpshHPUQdHUuGYbJR/ivM8cTo32t0vryDm3Tqspdsyc9Ifqg5JUEhut+n7+mMDF3AtHDGHLdBP7towaEqKI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=f/PI7YrV; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=C+OoXgET; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="f/PI7YrV";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="C+OoXgET"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68AF66BC3467971;
	Thu, 10 Sep 2026 12:57:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=WCBqois36VGrEk3wC02QqgtiaiTky+9IMvxqB6ixU
	u4=; b=f/PI7YrVpAy6mp6qqt7yn99IbYsNyQgIQ4Nwwm7kVuPRyYLv9dd1hHZTQ
	5VZEa5nRx0zGbXtIDecyUwOXGkPS0L45zP/L5xGbc8bRMMvBeiNkD6LAHd3K8pQZ
	i8q3cAuokiv3g9NTMV+S016Z6q+/MKSDLzTBHKeh780HB3QMQwKom5QS697FUCUs
	pOf02rBBrkobfK538FTYD0w2pfsQqfHn5CO5eKYY3Y5tyfRm29YjMc+cE4Apjtxc
	wztOJBYezmpOipRfliPwMMpqxlqoAjegWsmSFHgHyDpsnC6X2zoVVhyUWXN0/WEO
	VX303dH0HNSoyZm1CyTXlRwyfD30A==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012016.outbound.protection.outlook.com [52.101.43.16])
	by m0380145.ppops.net (PPS) with ESMTPS id 4gkstvb43r-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 12:57:43 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W86vvwD4WS9V6ao0SX0hTfz4CVh3tkyeTP+6LO723Cqxm2EzamgJkWvXoBlb8jhtHGOkl1oyGVFEMRGxJl9q9EJRKgcMRWTFOgPHLR6tv6LatC/PfbMgC9Lk2pCD0W2rK3ZRRnvd47JFz742ZhPZbBMIsHjo1/0hLnuDMU2x6wwpxLt/ALsY6VCOPbunJiTV/+tCgWO8BOycWzha1kkqzUf2bT+GxNW5ZaAuZjGThSZHw1uy/hsNXGbaEkd49gVrYWhvkB7xdft5TPWxaQC5eeFKcgJIsWxTKlQ+VfkKJrNrUs7cXFXcvJ7eX/JjjUYbTMYudWl5CtP2Nn0BD2nvWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WCBqois36VGrEk3wC02QqgtiaiTky+9IMvxqB6ixUu4=;
 b=Qh3NkC6xoKVDV+wxricbbkYBU+i3p8m1CSMj3tiAOw1VtE8KXrouJBHC61wtqoyZoKqVIgB1bxTa0cUJkMwJdVQER5Ih5e0avDGD2Ibv/sLqyzMt9onFsx26SpwJI9hCBGIOF0I2zeB3aP8htvSN1wyNWbgwWfhItLYHbTAz+pyuS6iGsNN+Rlt0LTWyP0zCl6C4T357+wlLz2wKbm/WBQOaBeAekjvZovDcjO6uRWmX3sWRjCTa8j7t3xQfd2hPWVFS5QWQHN2r2nyhhkNqZ2GGRN+Azumilmdq+I20us/9wudAEif6MY2UqqSzqoNIGODTblLqguwmRiTuJTsk5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WCBqois36VGrEk3wC02QqgtiaiTky+9IMvxqB6ixUu4=;
 b=C+OoXgETASwjcAay1f3hb2h/ao61XD5HINtGR/ZDFzYhL3LxCQZ+vlII8DQ6qJTfWGrxRLyGqTX/0K5FSf2zYVOobZF8s+o8e1H9rpsYlQPGvlf0uEhcYf+4hVwgH7QhrSX5CLO3HOoIxbVvGZ7ArWsG1WWS7ZloXHZPqhiymCM=
Received: from SJ0PR05CA0049.namprd05.prod.outlook.com (2603:10b6:a03:33f::24)
 by DSVPR10MB997870.namprd10.prod.outlook.com (2603:10b6:8:45d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Thu, 10 Sep
 2026 17:57:40 +0000
Received: from CO1PEPF00012E7E.namprd03.prod.outlook.com
 (2603:10b6:a03:33f:cafe::9c) by SJ0PR05CA0049.outlook.office365.com
 (2603:10b6:a03:33f::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.5 via Frontend Transport; Thu, 10
 Sep 2026 17:57:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 CO1PEPF00012E7E.mail.protection.outlook.com (10.167.249.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 17:57:38 +0000
Received: from DFLE200.ent.ti.com (10.64.6.58) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 12:56:47 -0500
Received: from DFLE215.ent.ti.com (10.64.6.73) by DFLE200.ent.ti.com
 (10.64.6.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 12:56:47 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE215.ent.ti.com
 (10.64.6.73) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 10 Sep 2026 12:56:47 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68AHukgl3763714;
	Thu, 10 Sep 2026 12:56:47 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        Kamlesh Gurudasani <kamlesh@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 05/15] crypto: ti - Trim scatterlists to correct length in AES
Date: Thu, 10 Sep 2026 23:26:09 +0530
Message-ID: <20260910175619.2122149-6-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E7E:EE_|DSVPR10MB997870:EE_
X-MS-Office365-Filtering-Correlation-Id: af480631-b1a0-46aa-3894-08df0f6500cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|23010399003|1800799024|6133799003|18002099003|22082099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	dO+Us9Pv0YvZ9rIAtu8BJ6qey9xGHoS75cdma/V+OxaeP2T8G/Af9CYModCgK+5EWLwEWAkvj3tzhX5EG1/f+lrCLjrU0HROks7j+YsH0OvjOzZrTpWfyAfAe/o60OOwEyN8lEagAXxDfZSGybwutZNEm1OdCfLFyAkj3ekXLMdxnDhx7pO11BsESEx4ZiysH2wOYuWIVGsW3iEUAYV2GwnCKYMUrU9SFdk6m55Pb5i83c6WkquF9/9FXju9UkKR2LUJZys/qbOGiSk7a2GEXc+yKzOstER+j9oac3eDmqYfy09dEKuHCFObkZejtoE31vw2euGemEdnrL3e1Yx7GfI7gcWZrOZ3kAKCCSV8RAdsbhXd/IFclLPhDYLjFpmSf8qr1dSBlo/ocBy7sqLnvX/2FIhWYHddUMho/y7R/mwXCUVacJYRPpiPe+9c0VhfVDQ1pEs9NCHmrqgylVa0a9OZOUKFlRjbqJk8o9OMZPWVhOWrfZiZLvR2gckThh2+ChaOL7av9J/c+KgzWPQ7wslDePT29Tl+q3UpX9GpKyJsMfY6TrtuiTqCcpgNd6x/hWnOwwfHeiDq/soP9eXdIVMUYm0DmUFiiuL453njZzL2uswU6SXrdBOs779kQCMbkkx3PbXI3t3Lwmp1uQjvImllpW1xyYo30ft6+yFASAoA5d4ddKLjGD1b52BmlN6nU1Yfne8LgcBsA5q2a6UCAw==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(23010399003)(1800799024)(6133799003)(18002099003)(22082099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	hdeBNwtnHwcrDLEA287U4vQc+QzmoRT1/6mZ/4A7lW+DPhgo0gkK5xqJ5rH8dsrTjnA5YXI3h7b00HNnhzF01y2XKIvtdRTaIuBWkGWwzKjUFM2J+VUVD1JlKnCmJLqfjB0//Cp2hr6dc4Mditv7TsgV0+p8nIIjP7WFhnONKMsQxHkQMb3/h5ceJuK3zkN7wEzpeRBrGOCm+H6gWOtmhWUO6npZVL0R8/OOqMyZ1M20RrKmYjOlVNkni/B3/gVWvBlO0KUo2/BZwDiXkl2LiuRGHTFOqzjRSx5UtHXH/BODCm07PZSnBur0w+OyJS5TrUo3N00WMlFt32EB64q+TkYiaqlqyCZyAZpizGxrnP4DZWG5wLycAPoV8qADvSIrAWEWO7nGO6d0rdNNg39N9GRs0ouZjjIwWZ4vhAA+tOudA3+NwS4LZq0MWRHqeFEB
X-Exchange-RoutingPolicyChecked:
	IMXHoH4ky/xB84A0DBdQDBSERZvVt/MRkglnReT2jvGxHG8lIOc/xepvVqecO6u33MsOeXAEy+8gCYjI6lBPFF8G6ixXZCKmjprtwke8lEce5aaYBM87t8WNEE58GpNhxQh0KH0fiEOdAB9cnGgxbWURPPJENBlKyRYIXoq7VCFcRBSRF5wgIHBxlU+9mojw/Mg1H/09r6BnMZQby6y/r3RGE7dFtfl31u3CRpW6rh0y8WloKmjJrASNk52S6dYBq7+olCxcrOo29UZHdQwBrFFM1z7pPOdPqVj7QOFtqL/bQZTWowEHQwg8i2j1FF9nPYN48jUTd+GjU1gmPcoBEw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 17:57:38.7991
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af480631-b1a0-46aa-3894-08df0f6500cb
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E7E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR10MB997870
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDIyMCBTYWx0ZWRfX0ryCCpyjUCrB
 3xKTLDF9oamX3cf77RfyslJ/oG+XTcgtw3vhyUOv3Zp9PQcNEvVoQ7Qb09fyfWAm4pb5kDJJQaw
 iz54dNyCFBhj2jJO3KObMPJnQBXCNFg=
X-Proofpoint-GUID: 8Dz_EtTuXboa0traO00SfDTYtXiwFkTg
X-Authority-Analysis: v=2.4 cv=VvG2kO2n c=1 sm=1 tr=0 ts=6aa2ef97 cx=c_pps
 a=wX+iSCk909IGAd/hxyKeOw==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22
 a=sozttTNsAAAA:8 a=Tpn98H0sjD_mw3BxSIoA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDIyMCBTYWx0ZWRfX7YEtGUwxadMF
 /Xm92eg+GufHI2l8WCCThCmpegkz2RLBi3HG8NJi2zFyBDoN6dcb4rA9//lrD/H5L42xs8U7Xac
 DJ6O7GsmFBdc9UWNmIgg8RYf/V55pJbr5N9CT3uSKfhhn/kb4W8iMMpo9Y9rljVW/rg/t5rtNbR
 2NwYNSo+5jI9ZRAqZW5AAmrC7lS64ug7DezXJCwwlYil04EexWHKkF/k2vwzf21VFdf8Szbjzlz
 KRjEFSOVG2WBy4RkvvYPeJ+a10F9Gqmr1aE+sQgvl8EiekFZ7aZFZovCqQjAYOsiTiPeYjwI0f9
 47UQeNzg4oISSd6qzcXue9Px37w4MuKpt/kTUvI/X7almyLktYaZ5t3MQcs82FE7VreUEvwwcJN
 PFT50K0iCcRNN1M1dH4Rh9BUh88kRIdjHvopCqJRWHur+QjdOfNWmO6TkM9dFpntwbWQn/56g2l
 w9248C/aBwgo4IEFVxQ==
X-Proofpoint-ORIG-GUID: 8Dz_EtTuXboa0traO00SfDTYtXiwFkTg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_05,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 spamscore=0 phishscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100220

AES functions were using src and dst scatterlists directly provided by
the request. This is problematic as it is not guaranteed that the input
scatterlist is exactly the length reqired. This problem was seen in
IPSec use case when the kernel provides the scatterlist which contains
space for plaintext/ciphertext and TAG.

The problem comes when the scatterlist is mapped and sent via DMA. The
K3 UDMA sends/waits for the amount of data equal to the length of
scatterlist mapped. So when the last mapped nent contains some extra
length, the DMA keeps waiting for the extra data and eventually times
out and crashes.

Mitigate this by copying the nents to a local scatterlist, copying only
exactly cryptlen of data. Note that this does not copy the whole data,
but rather only the scatterlist mapping. So it is not as penalising on
performance.

Fixes: 52f641bc63a4 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
Reviewed-by: Kamlesh Gurudasani <kamlesh@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 145 ++++++++++++++++-----------------
 1 file changed, 69 insertions(+), 76 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 6a8fbe67ef6cd..be7ec62ab2513 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -108,19 +108,6 @@ enum aes_ctrl_mode_masks {
 #define POLL_TIMEOUT_INTERVAL			HZ
 
 static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
-{
-	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	ctx->dev = dthe_get_dev();
-	if (!dev)
-		return -ENODEV;
-
-	ctx->keylen = 0;
-
-	return 0;
-}
-
-static int dthe_cipher_init_tfm_fallback(struct crypto_skcipher *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 	const char *alg_name = crypto_tfm_alg_name(crypto_skcipher_tfm(tfm));
@@ -154,19 +141,24 @@ static int dthe_aes_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
-		return -EINVAL;
-
 	ctx->keylen = keylen;
 	memcpy(ctx->key, key, keylen);
 
-	return 0;
+	crypto_sync_skcipher_clear_flags(ctx->skcipher_fb, CRYPTO_TFM_REQ_MASK);
+	crypto_sync_skcipher_set_flags(ctx->skcipher_fb,
+				       crypto_skcipher_get_flags(tfm) &
+				       CRYPTO_TFM_REQ_MASK);
+
+	return crypto_sync_skcipher_setkey(ctx->skcipher_fb, key, keylen);
 }
 
 static int dthe_aes_ecb_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 
+	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
+		return -EINVAL;
+
 	ctx->aes_mode = DTHE_AES_ECB;
 
 	return dthe_aes_setkey(tfm, key, keylen);
@@ -176,6 +168,9 @@ static int dthe_aes_cbc_setkey(struct crypto_skcipher *tfm, const u8 *key, unsig
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 
+	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
+		return -EINVAL;
+
 	ctx->aes_mode = DTHE_AES_CBC;
 
 	return dthe_aes_setkey(tfm, key, keylen);
@@ -184,24 +179,19 @@ static int dthe_aes_cbc_setkey(struct crypto_skcipher *tfm, const u8 *key, unsig
 static int dthe_aes_ctr_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
-	int ret = dthe_aes_setkey(tfm, key, keylen);
 
-	if (ret)
-		return ret;
+	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
+		return -EINVAL;
 
 	ctx->aes_mode = DTHE_AES_CTR;
 
-	crypto_sync_skcipher_clear_flags(ctx->skcipher_fb, CRYPTO_TFM_REQ_MASK);
-	crypto_sync_skcipher_set_flags(ctx->skcipher_fb,
-				       crypto_skcipher_get_flags(tfm) &
-				       CRYPTO_TFM_REQ_MASK);
-
-	return crypto_sync_skcipher_setkey(ctx->skcipher_fb, key, keylen);
+	return dthe_aes_setkey(tfm, key, keylen);
 }
 
 static int dthe_aes_xts_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int ret;
 
 	if (keylen != 2 * AES_KEYSIZE_128 &&
 	    keylen != 2 * AES_KEYSIZE_192 &&
@@ -209,15 +199,12 @@ static int dthe_aes_xts_setkey(struct crypto_skcipher *tfm, const u8 *key, unsig
 		return -EINVAL;
 
 	ctx->aes_mode = DTHE_AES_XTS;
-	ctx->keylen = keylen / 2;
-	memcpy(ctx->key, key, keylen);
-
-	crypto_sync_skcipher_clear_flags(ctx->skcipher_fb, CRYPTO_TFM_REQ_MASK);
-	crypto_sync_skcipher_set_flags(ctx->skcipher_fb,
-				       crypto_skcipher_get_flags(tfm) &
-				       CRYPTO_TFM_REQ_MASK);
+	ret = dthe_aes_setkey(tfm, key, keylen);
+	if (ret)
+		return ret;
 
-	return crypto_sync_skcipher_setkey(ctx->skcipher_fb, key, keylen);
+	ctx->keylen = keylen / 2;
+	return 0;
 }
 
 static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
@@ -340,8 +327,10 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	struct dthe_data *dev_data = rctx->dev_data;
 
 	unsigned int len = req->cryptlen;
+	unsigned int pad_len = 0;
 	struct scatterlist *src = req->src;
 	struct scatterlist *dst = req->dst;
+	struct scatterlist *sg;
 
 	int src_nents = sg_nents_for_len(src, len);
 	int dst_nents = sg_nents_for_len(dst, len);
@@ -384,38 +373,38 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	 * We need to handle the padding in the driver.
 	 */
 	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE) {
-		unsigned int pad_size = AES_BLOCK_SIZE - (req->cryptlen % AES_BLOCK_SIZE);
-		u8 *pad_buf = rctx->padding;
-		struct scatterlist *sg;
-
-		len += pad_size;
+		pad_len = AES_BLOCK_SIZE - (req->cryptlen % AES_BLOCK_SIZE);
+		len += pad_len;
 		src_nents++;
 		dst_nents++;
+	}
 
-		src = kmalloc_array(src_nents, sizeof(*src), GFP_ATOMIC);
-		if (!src) {
-			ret = -ENOMEM;
-			goto aes_ctr_src_alloc_err;
-		}
-
-		sg_init_table(src, src_nents);
-		sg = dthe_copy_sg(src, req->src, req->cryptlen);
-		memzero_explicit(pad_buf, AES_BLOCK_SIZE);
-		sg_set_buf(sg, pad_buf, pad_size);
+	src = kmalloc_array(src_nents, sizeof(*src), GFP_ATOMIC);
+	if (!src) {
+		ret = -ENOMEM;
+		goto aes_src_alloc_err;
+	}
 
-		if (diff_dst) {
-			dst = kmalloc_array(dst_nents, sizeof(*dst), GFP_ATOMIC);
-			if (!dst) {
-				ret = -ENOMEM;
-				goto aes_ctr_dst_alloc_err;
-			}
+	sg_init_table(src, src_nents);
+	sg = dthe_copy_sg(src, req->src, req->cryptlen);
+	if (pad_len > 0) {
+		memzero_explicit(rctx->padding, AES_BLOCK_SIZE);
+		sg_set_buf(sg, rctx->padding, pad_len);
+	}
 
-			sg_init_table(dst, dst_nents);
-			sg = dthe_copy_sg(dst, req->dst, req->cryptlen);
-			sg_set_buf(sg, pad_buf, pad_size);
-		} else {
-			dst = src;
+	if (diff_dst) {
+		dst = kmalloc_array(dst_nents, sizeof(*dst), GFP_ATOMIC);
+		if (!dst) {
+			ret = -ENOMEM;
+			goto aes_dst_alloc_err;
 		}
+
+		sg_init_table(dst, dst_nents);
+		sg = dthe_copy_sg(dst, req->dst, req->cryptlen);
+		if (pad_len > 0)
+			sg_set_buf(sg, rctx->padding, pad_len);
+	} else {
+		dst = src;
 	}
 
 	tx_dev = dmaengine_get_dma_device(dev_data->dma_aes_tx);
@@ -502,19 +491,19 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	dma_unmap_sg(tx_dev, src, src_nents, src_dir);
 
 aes_map_src_err:
-	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE) {
+	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE)
 		memzero_explicit(rctx->padding, AES_BLOCK_SIZE);
-		if (diff_dst)
-			kfree(dst);
-aes_ctr_dst_alloc_err:
-		kfree(src);
-aes_ctr_src_alloc_err:
-		/*
-		 * Fallback to software if ENOMEM
-		 */
-		if (ret == -ENOMEM)
-			ret = dthe_aes_do_fallback(req);
-	}
+	if (diff_dst)
+		kfree(dst);
+
+aes_dst_alloc_err:
+	kfree(src);
+aes_src_alloc_err:
+	/*
+	 * Fallback to software if ENOMEM
+	 */
+	if (ret == -ENOMEM)
+		ret = dthe_aes_do_fallback(req);
 
 	local_bh_disable();
 	crypto_finalize_skcipher_request(dev_data->engine, req, ret);
@@ -1240,6 +1229,7 @@ static int dthe_aead_decrypt(struct aead_request *req)
 static struct skcipher_engine_alg cipher_algs[] = {
 	{
 		.base.init			= dthe_cipher_init_tfm,
+		.base.exit			= dthe_cipher_exit_tfm,
 		.base.setkey			= dthe_aes_ecb_setkey,
 		.base.encrypt			= dthe_aes_encrypt,
 		.base.decrypt			= dthe_aes_decrypt,
@@ -1251,7 +1241,8 @@ static struct skcipher_engine_alg cipher_algs[] = {
 			.cra_priority		= 299,
 			.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
 						  CRYPTO_ALG_ASYNC |
-						  CRYPTO_ALG_KERN_DRIVER_ONLY,
+						  CRYPTO_ALG_KERN_DRIVER_ONLY |
+						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_alignmask		= AES_BLOCK_SIZE - 1,
 			.cra_blocksize		= AES_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
@@ -1262,6 +1253,7 @@ static struct skcipher_engine_alg cipher_algs[] = {
 	}, /* ECB AES */
 	{
 		.base.init			= dthe_cipher_init_tfm,
+		.base.exit			= dthe_cipher_exit_tfm,
 		.base.setkey			= dthe_aes_cbc_setkey,
 		.base.encrypt			= dthe_aes_encrypt,
 		.base.decrypt			= dthe_aes_decrypt,
@@ -1274,7 +1266,8 @@ static struct skcipher_engine_alg cipher_algs[] = {
 			.cra_priority		= 299,
 			.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
 						  CRYPTO_ALG_ASYNC |
-						  CRYPTO_ALG_KERN_DRIVER_ONLY,
+						  CRYPTO_ALG_KERN_DRIVER_ONLY |
+						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_alignmask		= AES_BLOCK_SIZE - 1,
 			.cra_blocksize		= AES_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
@@ -1284,7 +1277,7 @@ static struct skcipher_engine_alg cipher_algs[] = {
 		.op.do_one_request = dthe_aes_run,
 	}, /* CBC AES */
 	{
-		.base.init			= dthe_cipher_init_tfm_fallback,
+		.base.init			= dthe_cipher_init_tfm,
 		.base.exit			= dthe_cipher_exit_tfm,
 		.base.setkey			= dthe_aes_ctr_setkey,
 		.base.encrypt			= dthe_aes_encrypt,
@@ -1309,7 +1302,7 @@ static struct skcipher_engine_alg cipher_algs[] = {
 		.op.do_one_request = dthe_aes_run,
 	}, /* CTR AES */
 	{
-		.base.init			= dthe_cipher_init_tfm_fallback,
+		.base.init			= dthe_cipher_init_tfm,
 		.base.exit			= dthe_cipher_exit_tfm,
 		.base.setkey			= dthe_aes_xts_setkey,
 		.base.encrypt			= dthe_aes_encrypt,
-- 
2.34.1

