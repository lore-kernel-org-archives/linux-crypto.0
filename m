Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C5E4E0B8F;
	Fri, 18 Sep 2026 10:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789727007; cv=fail; b=sWVOiW9RqT2uAxkGA9HtGD8Ti1Naob7O9OleKT2uYiQGAzfsleCCm6FT9ZjCBtsmkIcGXl5nSgTC7uU+cpy7trAF/F9NCRFfiEabhpkyqV42DHiZkTbdJKJQ6+bTW9xinYg/LR6dKR3W09flmwxIiJ+VK7i0UYDAoN95Oo/SU/U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789727007; c=relaxed/simple;
	bh=jK1YlxGMKiGHZzHUizrPnjxGoWi3TQx+yaKmQrQGcxQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TR/OTdMufYswkulAeLr6gwSontAfrpJl009Gd4GUCFAjJR+KQl0qPiqliHs4djgCEAd9g7ZbZaqjah7UyiHUYNUoktVLTbHOUPMTrViogdADKEFA0Zpn1Qa7fvfA2/s2Sevj5VLB9wipYWtdLM7d8WBtvleDwaTT1fnV2QwkoXE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=jq7NlA83; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=WVKyiXRN; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="jq7NlA83";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="WVKyiXRN"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68I9eGv93768282;
	Fri, 18 Sep 2026 05:23:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=aQh92ADWyfMZtk0V8bD8JKalILCu/np0gxL+lUgXL
	Aw=; b=jq7NlA83Ggp7JNwO99P5dVzpkV/WeZmsq5Sk+QhIhwEyQjCa2Zv/eVTCW
	fY8JjQ/2KnLk+ThPYUm+O8d7do/CTA5LcnuJhYgdFSCsV0yqsGRRoVWtlrHQ8fWk
	XWRhB5FYqROv9lpGByOL423pSXM7BxD4fsnEGfcxV1tMQsTH4EmLe+qdLMFNukDW
	9OG/dynsQbpDr9GV4mWzNPX3oB2y3avnX51+PvOHvHeZsOUR7O0Ol8+EDOfYvOto
	gfYZ3tx1I5nPSiJuFqQVP2fyy/gI3OWTjONVCHjhJyYOUadpgv6UPX2ss4mk5hcz
	MEv/QWT81dwHPp4dKtGCNa+IUnEUw==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013038.outbound.protection.outlook.com [40.93.196.38])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gs16cgsjr-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 05:23:21 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fNPV3zbhFLrFKneIAfihI6C2UrqbEtCAHiA07MCqtlr41MKQ0YGbqTF2sD4Q6T/Bm9SmjZr8eQm4YRQ7JgeDFIp3m5IqiUubyAIsgTIBfHcW/66S+DWW0nmbSZZwUDpa7OP1vZ2aekt9kurd8gWCqnAj00JEyrkZcBbrB2JqpX48iGGHBl9c1T4DBjyJwOyu5vKOa85JIl/O8CZsLtsiX+B7YdtrB3Qq2OyNfwRVKLcj1MoY4aTkXtN61WMR7S1w1Qx52YYsrXQxSQNGWpk90VxQxt5/TnIJ9E8SDu9clIXQqFR936SMtHcy6xWRPr/yUnfyzWC5N2DU7w8sG4mo0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aQh92ADWyfMZtk0V8bD8JKalILCu/np0gxL+lUgXLAw=;
 b=MGfL9guXf0MmKpWbVu/FzE9QiqBYqx3O71GhOB4xdYghoVojVjgJUCMOb3Fiik4dWR0E8uEG3RMDZ8LBYQzTYmbGk2rzR23heiD25DvgoclEHCFg0w0g6GdpfaBecrWjC7oUFiU2f8yqOGgMAr4vYGqG6X7jk99ERSdb967GD33q1L1XqivhCGuN5QwluhavazGK9JZ7uTd+hSbkYDoIHbCpJvoSkBQYzHErYbAYWxTGRKnnYmxU72cIQBAUup7tZ/CP+GbKDD+aSl5TEAhI9pb04moKGg5JmeJ2mUJYrQiFxgDg70Jod31HVN1csmMQgPF0wMDPi1ZYRfojpVUhgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQh92ADWyfMZtk0V8bD8JKalILCu/np0gxL+lUgXLAw=;
 b=WVKyiXRN4vH4fP5EeD013W1gJ23/qLDmI/tikdcdX9oueuVfwmzVo+rJp8kSti3oEPF68K0uOz3Sx5eDPsnXQGFX9ucK79kxjj4jiUx09JQq1QhyibmPIe+gEahCetZcUK25ORlxIXdScCB270oXzCqQdVgrle4sPh6gGixZBz0=
Received: from CH3P221CA0001.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:1e7::11)
 by SA6PR10MB8111.namprd10.prod.outlook.com (2603:10b6:806:446::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Fri, 18 Sep
 2026 10:23:18 +0000
Received: from LV8PEPF00000060.namprd02.prod.outlook.com
 (2603:10b6:610:1e7:cafe::6d) by CH3P221CA0001.outlook.office365.com
 (2603:10b6:610:1e7::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.12 via Frontend Transport; Fri,
 18 Sep 2026 10:23:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 LV8PEPF00000060.mail.protection.outlook.com (10.167.245.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Fri, 18 Sep 2026 10:23:17 +0000
Received: from DLEE204.ent.ti.com (157.170.170.84) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:23:01 -0500
Received: from DLEE204.ent.ti.com (157.170.170.84) by DLEE204.ent.ti.com
 (157.170.170.84) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:23:00 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE204.ent.ti.com
 (157.170.170.84) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 18 Sep 2026 05:23:00 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68IAMxoW1534085;
	Fri, 18 Sep 2026 05:23:00 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 02/15] crypto: ti - Fix spinlock inconsistency in DTHEv2
Date: Fri, 18 Sep 2026 15:52:32 +0530
Message-ID: <20260918102245.2784000-3-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260918102245.2784000-1-t-pratham@ti.com>
References: <20260918102245.2784000-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: LV8PEPF00000060:EE_|SA6PR10MB8111:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ad6956f-532a-444e-ac00-08df156edb1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|36860700016|376014|1800799024|56012099006|10067099003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	qQOMr4EZtxFZGt2UXIfWI12vG0JLnEOCvyKA2SqSp1XU1R6MluNKJnbV+Rgyqs+p+H482vQQwmMs48UO7OVfp6ypDonUeJ+Zakt+D6UyaVMHtOplIAWSQt0abKu2M5wXJtPSzaFUu1oGhxv6bhFOXes9EVRmRuJ5QpCqJ+uegO0r4MvATKJHwWpp4g3R35FnDvioPrgGlBLw2a2CbYizaw02fOAM/MBTD/QcfS0c04shJlLJOuWRiMmPPuQJVTF88cTKnuQ+z65uA2Uqyr4pcPN8W1/P44Ncx9nz97lmcbHG7W0aBpR8nu42GBfFtId9XsYbwqUtSoBGJq5Z2erZSPnVIsfSg6+EYygbyfBA38AifMKkhGk/YyqY0lbHCfrn+pHuZrmeNWIoxdKlmDiihsv0+Gb773EV2oWtLfz7W3mJ5RXSBodryAzhjZJilEA1vTiwCL4U2U0dG47CK7mZSYtV+hp0cMthiceTJH95Mrpy5AEF4mDIvSmGpXGAqcw3GpthZzNWGZisUmLWTtHB6r++mde/g1Ysj2r1eSaIEg7LxhU5bLU//G1GNH4r6cf50S//3FfV5jWnEyy3xPCuS9r9E1Xuv9asCxDo6FAL6oIjH/gI0/aBArRPKXTFsNjiZ4fdjcHqg4svgtTrX7Zu4l4eBMpq8/6fErna6kEYC93ZBT3fA/lNda2dY6ITz3rBRMW6GVnY7OwesCOkUmmcew==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(36860700016)(376014)(1800799024)(56012099006)(10067099003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PvfmpBR2fGx3AwmN7xcC42JViLSYDWm2OP7eWSNu+fxlKaK7BUsFGFPvAJvCAZc6XHQtxtYVfL3X5PYwO6JaniXyQt823Gh3nUY97KPIm2x5/meV9JhNbhvDngxs8Qe1az1rdauWnS55K51yoiHsOI6K5ThgaCREJUBH45Ha9MrpFnGbowJV8Mdi7ux+cpxiPDwLnsH3kMlJ+W25OxAyiu2u/1fj8zXvYs9t8HN+rzzZ5DT8KE/jDdE1opaKFBLntt2LCQ8C1t7dwq484EgqbFLL1x1CHhG1ijmM7Fat2hyXsbMZ3R27EaC6WXEbo9NQfBYrmEEl90PKDyaP77Zc0SCG2Xf4ZdrchOs2mqZZHBUL11DOMrmS/FGaBIY0CdU0uraZWu8xg38ne0SXV0zW3aV+9VwXCddRtFQve36dRGXW/7zy8ZieBQdyJSaINK7D
X-Exchange-RoutingPolicyChecked:
	VVDvKxI/QRtZgdBd4DNetwPeXoSt8URr58JUV+qyhwlZIpvQ57F0q2dVsvhJKXOYtqUttAKcsxPgS0aI9rs+g37EkWdvis8xpExDtPHtpFEjE89q8AOqVuwTrhsXwIqBwj7Kywh5XXPZARGU9f/4Yvga+pcxT5ldlc/coC+3gumfdkTahpxJhIEwu27GoEmb9Et0Bj+bh2v4jKtXJq2UWzjHo0fcjdspVXnFVCXKkL5+Bx0K8UTrZ1Dgef+aDsMb16yLsvhXugMons952QMPrDdWctYq382+1V7sZeO+pXNwae2l2UhD0BaZRw70VmJ2A1IOl391dnYAje21VCrlUA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 10:23:17.5436
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ad6956f-532a-444e-ac00-08df156edb1e
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF00000060.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8111
X-Proofpoint-GUID: _SSGtMsrqGuVJ-vLkJaO0LyKn2qxUW0_
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfX3xizdHHGagq0
 LexnSDZW35lVorVcoFsedqb5rGA9ij3XUOIw24hk0gv/M44LrN4xOoax+34CgaJc2FcYB6H9i+S
 Sp8EQXyAHHVkDnqCZ1KauYkpEt8999s=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfX9mjUrDXoep8O
 6GQmzt91Ozl6PFVopap0BAp5Rdbhv56clxC+oKdAtc3XKUtxAHF5lCsZVbi6Dy0rwV/oaWxxCVG
 S9XGDK2RAiuRHVULSVWrsPxABzsPqYgN318H/00jrQQGU8WSleur+SQ9IwgDiurrc4/B+wToLqT
 PsS2IKVMMuVnJSo6epDlMOpEcBsGMUQkwNEg5vn6KWkw+caZija6jT89hhJl0FmUID0Me/78M15
 JlWLNwrHXpUIqpZO7MdsNZHsCwJ06DMRi31P+5dnwe6X92FV80XnbjEFKJVvlsQi+GUkO/Q8iin
 0lc5oUuqmYLW4GI6/UJhMPUL6DtG4ArmHEmCESj7VnpL8WVBRa7rfIBQnmXqpkrr/vlrt50HuUS
 AZueP5N0OiOD3ZeEDhWnyzdNA4egZnCFLFGJyufNJ7S/u1D1DarO6a67tVh0uAgi9QSR007o6fa
 3i5ZIKsfXdnzoAPFFUg==
X-Authority-Analysis: v=2.4 cv=cKh1IVeN c=1 sm=1 tr=0 ts=6aad1119 cx=c_pps
 a=iBoLJ+TzW6OYwHE2Vh/RVw==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8 a=HiAi_RwYt-Wiez6k4EgA:9
X-Proofpoint-ORIG-GUID: _SSGtMsrqGuVJ-vLkJaO0LyKn2qxUW0_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 spamscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609180144

Probe and remove functions use spin_(un)lock for acquiring the
dthe_dev_list.lock. But dthe_get_dev uses the bh variant. Change
spin_(un)lock to spin_(un)lock_bh to avoid potential deadlock when a
softIRQ process tries to acquire the already held lock.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-common.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index cc02449382673..f760d0b256728 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -155,9 +155,9 @@ static int dthe_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, dev_data);
 
-	spin_lock(&dthe_dev_list.lock);
+	spin_lock_bh(&dthe_dev_list.lock);
 	list_add(&dev_data->list, &dthe_dev_list.dev_list);
-	spin_unlock(&dthe_dev_list.lock);
+	spin_unlock_bh(&dthe_dev_list.lock);
 
 	ret = dthe_dma_init(dev_data);
 	if (ret)
@@ -201,9 +201,9 @@ static void dthe_remove(struct platform_device *pdev)
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

