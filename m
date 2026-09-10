Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF4B45C6E5;
	Thu, 10 Sep 2026 10:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789037007; cv=fail; b=oUPOhwmipy5UB1bBYYkjEPah950QVgoL/dvoDVcOqFsP/j+BtyTku2cFFVNdtSCqQa4NpSjl3+x6HE/HL5V5uSpSVQ4Ie0mupvrsM+jLYuNehekN7GaeEBv0iDhxBVw67G7kCvOAEE4Vw3RcBIGhzkg9hZ2pILy1Gr2UeGG4cxs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789037007; c=relaxed/simple;
	bh=6RV17K+dOkVeshFmshHqF6sMCwCc25grQ5kOysr9CGI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YzdWX/ocmShztTRErw7S+NMHH6YXd+b3IHiRUFq00WpyHDNpLQNfTBUKxBUIHlVKz4TjG6o/dL5o79xbwC5rP6XSsLFK+Izq0t2YJhZ5X/5K70zuXI3BZvXxFqxPDnGzABCXh/0Fd21d6bP7fmsVkju9T93219C/zyQgilAhKd0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=qv6u5+ep; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=eqR7DMHq; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="qv6u5+ep";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="eqR7DMHq"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68A8oUKR2934041;
	Thu, 10 Sep 2026 05:43:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=3Hbdg4pI7uZrAjMnu5fvtSkbjxE49GEKGFuOUs0rp
	ss=; b=qv6u5+ephxOKtr5p/H7JZ5opSzEfGDfbFjaeXCYNlXQv0q+pmkwfoctu1
	w7X0TjmkTKD1zweANQmy+etts6qBKPl3xbkWkzTcu0e8Pue+wwJJkzKwFXa22dFf
	nAPav9rV1kW+Zw+hxSAFHcs4KWVORXyClXzPHaigLiqPE3Ul5ZHxvPaX2raLWrht
	wigvBnYGtbM/p6Jpm/sbukOhDmdiztIXh9PbHoJwOPdstIWFjfied1UL85kJZP8z
	pxffZehCXXmtXqk58SPiJShf1FjE6JZCMllOJEWQGfPuYj4h9GVSG9OaeCmcdIdO
	IuCliWm3rlziBF7ZPECzwrV5arFJQ==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013003.outbound.protection.outlook.com [40.93.196.3])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gkcxg4xk3-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 05:43:17 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nV7kgUd/iPe/FIqeOeE8zhcMuXhMsJ3DJ4BEOtcejizCDhR9DRdYtOYfCyL05TyrJGNrZveL4co8pO4y1SccRguv/Hs7wrbDherbzaN+12S97SsQFr8a0Y5LfNk7uhLa44izauEhHiKPUjQcdBZpGB45DEBcCefY4UNzgO1dE1+RGUReuw2zteWPDyT/m/zCjAbyO+G9ExZ4GlrXkyP1J+pMYWgZ7A81MtE0lacv8P/vG0euhSaeU+qWtuHfsD4TkOhr7d+xG3ni0OZFihswKltfeBD+Flzh5WCIDxh6+OG9qrRk8dUQZaJLIBHnyaLGyj7SzqaWjKL0AOeBu+Kd8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Hbdg4pI7uZrAjMnu5fvtSkbjxE49GEKGFuOUs0rpss=;
 b=LsR31ruXYNPFabbs/7Nr165H7UDMDqzO21nEUlGUuSmuth0zDy+BesJUP169HJNo0uAV6c+qFKX//vaeDtBiYDlZonpo9fkSGfKentlYHJeubBez4myCFff88zFGZ68vOu/cUAvecnkGgd4jUfaeVxC2Chg0En8kZC+TP8FMpLceaF0l9ml5VuxYi5+tKBSb5FCaON413d6xb7kwEHju3/DNEu7S2hJy0WhkSxxqjnMcMTb+QhLRYqUl87sqsbYKcoKyolyMNSe9sboYtJ5VFnRYKgyhuSdk/LHduCWmLy/IEyWR8xuAAP8001u7gO64rW1NkPESR0DTIZwJdxuOGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Hbdg4pI7uZrAjMnu5fvtSkbjxE49GEKGFuOUs0rpss=;
 b=eqR7DMHqNyvINN+dByxK8V3pRwt9qaiHev7T16Gve+kU6UY9vIC/7MlmmtuJDMK0FdB/vTWIBRV5cyFhKfnEp7IHXKhEabwG1dJNXQv9IGi7ZXxHoiw8WNazcyiXXB2UokNgHmapaXVlq3agM0dQ7SL5CEbiV9aefW8JiXr+/rw=
Received: from BY1P220CA0022.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5c3::14)
 by BL3PR10MB6212.namprd10.prod.outlook.com (2603:10b6:208:38c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Thu, 10 Sep
 2026 10:43:15 +0000
Received: from SJ5PEPF000001EF.namprd05.prod.outlook.com
 (2603:10b6:a03:5c3:cafe::61) by BY1P220CA0022.outlook.office365.com
 (2603:10b6:a03:5c3::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.7 via Frontend Transport; Thu, 10
 Sep 2026 10:43:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 SJ5PEPF000001EF.mail.protection.outlook.com (10.167.242.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 10:43:14 +0000
Received: from DLEE210.ent.ti.com (157.170.170.112) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 05:42:59 -0500
Received: from DLEE205.ent.ti.com (157.170.170.85) by DLEE210.ent.ti.com
 (157.170.170.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 05:42:59 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE205.ent.ti.com
 (157.170.170.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 10 Sep 2026 05:42:59 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68AAgwTK2178195;
	Thu, 10 Sep 2026 05:42:59 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 10/12] crypto: ti - Terminate DMA on all error paths in AES to clear descriptors
Date: Thu, 10 Sep 2026 16:12:00 +0530
Message-ID: <20260910104202.1537226-11-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260910104202.1537226-1-t-pratham@ti.com>
References: <20260910104202.1537226-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EF:EE_|BL3PR10MB6212:EE_
X-MS-Office365-Filtering-Correlation-Id: 18d785f8-6895-49b7-7616-08df0f285179
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|1800799024|36860700016|376014|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	VSSdZp1mm+jPlVbTQuNd9xRGhZ5m2YjLH30aXoWEsf7Zzn+jLEVBYopRWbHUpDy5PXPrIRg77fruW77MAN6/ZVcePV+JBgJv/IQ8IPo2cqinAcMPeTDotO4wPnxl4HKT0Cmg5NJ6GFg1evagSxkvc4dMkoVVdZqC9WNkI6jpP7qxb5dOu18Cm702o6QzOFDrum2YiGldgZswuFxf80yyUKuHcuer0jF8OJUOLJ7wOCj7ZBZpNk7SoqhTNfHW+esE1a5Jf1U2ay4gAY4L7203CuJa6FHei7YZGB3k5VrygZvbWRKFqp4LC5mVmXKNBroEoUhGKpMzpqKYbYhIH9DuGmKpvY9DXgd886TAhijslwkBSpCbGlGtBzuEiDSef406D06XNaUGis1ovq2HBdFseKlXpKLdK6/AYYiW1Z0uclZB5YEYljPy7de31CpmsNtRm9/UiQEvptvHOEN5W3NpJASf0wSjUVpwJ/NlNwNPPG8jtgtIc6TK5s9CSiyKsIWaRw2czqCE0EJdnbCq7DlLuW6O0YsUTmHqJCdCArVBXy/hWtKQc/euxSEsaTKaMgOU4Y3uc8RZkk+yd69DZjzfJjLyY2GYM3ErIq+rbXe8e7grsLBR/iuXDNPFY37he14r7+Pm7ayXXqb+SC31fDzAULmGTF3TfKBjy/C+7IZQPz3wy/7upNh7c0eaNcK92j+aWFmRPER3qjON2FqO8Y3R6w==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(1800799024)(36860700016)(376014)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ja4DpMowgpwUzrL4CzcKR8alPhC4b3TTrsePgr7IR440C5Y6LyltMBVMjozVzxcxDDHlwme4sC41kGwvGESFyT+Jnvx2fMfchOd77eZazk2NMVkruwROIfmSRERM1OU6pKuG+tzJw804gXcYscJDz80H8+qHPuccQCkHtv9fo4xZYnZMa3FKPaQ9XIfVCr1JAb9RBEdbdVS8cynJbpcB0n/G0B2JjxLSEqNShxclTFruLlAUv4EmKc1XAuTOJaJMcj4+d24oEFgLVfMmXDqVVfyrzZ0b/pl3nK1bINCYXa42AkqGituigP5NFRy6NvuHrfiMr99dxCJfw+06SzZwXI/yCW7t/orn75C12vsCLKjwcf+4m2MCYP28HaxQ3Bjvz37+QunNfv6U6pNGH3ja3EOCB4xDkAMd72FQAnl7DzY8uNkFj63YP6A834SMZfzD
X-Exchange-RoutingPolicyChecked:
	OMRMzlBx9eqnGl/i/isglZsBlaprLFawRoA2sOngGf9oAFGYMSk5Q3niH+5oItBjY4IZk0GXhE7yCo/ccN/6gwVo/xvXfb4gX6MTuEywsrVHaSkO89jGBbUMlF84vrmTFzvjBMutDA/Ogl7fD6q96ewzL+cINHzFz4sRNgEc7qg4eTKPxNEiy34keVxlLbFkBiJ0c3eh1JLR0yR6MbzHeY9eGXIPK+X4aTdytEI10rk2YUAmCkyp8Dj+JpHk0gqaGdncONFe/9SvQuHsVM2+Bgt+o+QtznE3XBj+j8zFpkQQxFSIWYvWA3QTS4OcnFm8TaOSAHuTJUdukQeyubymug==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 10:43:14.8531
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18d785f8-6895-49b7-7616-08df0f285179
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6212
X-Authority-Analysis: v=2.4 cv=MpPHeGae c=1 sm=1 tr=0 ts=6aa289c5 cx=c_pps
 a=rjhVvYU/dOM9ArBm263f9w==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8 a=T1XiGUNGXxSxoSVzcpQA:9
X-Proofpoint-ORIG-GUID: qArhscTXmZLvO5Z9icu40gjFOLzqi2Wd
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDEyNCBTYWx0ZWRfX6zxSVKi+CkCH
 z/CtaZFj1ZWPFqzPYDtG4btRPmN9BprGiLMerSAXdjobH13VroE1v5XLbO2QPGzMCFplSgxcZ3w
 e/18KGpZFAtzjcknhWt1bSpG0lqVIiY=
X-Proofpoint-GUID: qArhscTXmZLvO5Z9icu40gjFOLzqi2Wd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDEyNCBTYWx0ZWRfXy1AhFu4+6a1M
 SMlgQDkiERrKdTy3in9LKC9VVIDyIvYDq1cy/FCBPU5kiF1fS4aAVbkEpJo2QR6SOm31ZpySe60
 1dqft5cHZcinSPR1y0JM6Y8IcjASNb9lHPWjfKjtZ5B1h5KCi3fi655Yn3w8iCMBr+/fMPk3piW
 7nVJymtrHhmn3CGxsqiTXtyp1ClL7Yx9VdprLIuqgNiDCHPI25Yp/TpXEfHys5LKzYEbFvsL/FW
 Ni+E5dLQu+P95zMRzUPnFBRz/y9JbYPsD+FH2hk/7jViUd3EBbBQh6RSI7i0Sz6QDqAevNzOkth
 AGHLsrZS4Y/rDiDmWxmqXX5HA3Rjh3xyBKJ6vXO9fWiX4zBYB1XBQRU5YgxB/W7rQvfvoHh4AqC
 cXSmrAklMdIUzxEpHnB+Ot0Pz1CbeH+YHep26q2AAWDnTQNi0bMVFdMgIqB6yfP7sFHYiJANii7
 IEbrVhIeE74pV+UFS7g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 suspectscore=0
 malwarescore=0 impostorscore=0 phishscore=0 clxscore=1015 spamscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609100124

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

