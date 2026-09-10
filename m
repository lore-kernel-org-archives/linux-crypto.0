Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E61A3DAAD5;
	Thu, 10 Sep 2026 10:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789036977; cv=fail; b=YTKgoc5Y8yNiUAzku/r75ZfGxrnYptn0jQnVW1RQSchtixYexRsLRQ1PeK0eLV7Xvj3g5DwPvpRO/sThF2QwWIdo2FrwosjmvpoqOkHWCKx67LJBtbYTOHFLoTMg1lz818BzOVJtxmDoc5vQmhYmnWUrRGhE3tfYaBicQ3XaDsw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789036977; c=relaxed/simple;
	bh=JhIYat1tDDHjynnYJrzFdJBgSwjr7d6SfSSJ0/IQWLo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LK5UW/lmhQfRUBj2yRcoyO/yflJE66Z/jNqAuNWMtFVqzEhY0THjaHTX5QZRgPiU65Nyc3nJaVRkaz4kZcsNg5rHK0wwV7Swg3KkSxpxhmj/BXp2rxIseHPy9WehgxlM+qb4/6kqzcljSxwcMrQFTJayDvm4+Mkpu3EYt9CR5Y0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=cItckjoe; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=a+2qtPZL; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="cItckjoe";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="a+2qtPZL"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68A8oH6O712619;
	Thu, 10 Sep 2026 05:42:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=L3d/uqtROV07wByGxF+hfQgPvMnzChdKYg2ED7CQC
	yU=; b=cItckjoeFr7wsQjE5xsUvGK8SdzVh8rPYWcweA0HVJroxuZn9YugjEn0w
	c4Krh9/kNOO+euI3tBDXS8dIG16CYW8MDjzCMH6v+ikY70OaJHrLzivxpEJVHDO5
	UtqmZiP4e8L5m7G8lIIAJ1nt4rPiZVe4tSU82yNhkcRTpq5nVddMbqEOK2x7i/Aj
	uYVIEb85S0ZJ4pDJQWDcgm83sNSZQ73+Hc7mf/iTUyoFCfmrdh0oCFAjYXO4iy9K
	EpXGStCJpD/RwJParkSkHYHYA8Ea+hiONbXOjk4XnrP3zUkgcWfJmZUD2QXsgnRF
	sYYxP76UPGNrNMPF/w7r5NX4f8ufg==
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011059.outbound.protection.outlook.com [52.101.52.59])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gkcxgcnwe-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 05:42:52 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tJqpMPCV8752kMky92KoQ9Fg45JaixUa6OcR304HuTYbsWCUFKPzB5dbq3muVx8AMNCEUnZu3KYEBlFjEZZuaIC46cl3dBaHksyJWiD56gYhDcQ4d404fHTtenkCa+uU/HKf2x5X411rL32CSt7ON7tpL+9Wd+fZdugyB+BTdpt3bja/NvwVXQCziOE67yoo8XJulzeLnzPzpcPjuoNlSoIBM10trwfWMW2xye5S2c/MXcBO4UdBlfxAgstmw/gzhAUvX35cD5GVkFHgFquRWRwSBPsJUk8Zo68aKg/zKTIjwoDTkBkUuliN4jMAWLPgtiYrEKAWag1ZzN5ekkgSpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L3d/uqtROV07wByGxF+hfQgPvMnzChdKYg2ED7CQCyU=;
 b=Aga8bfKwGp+9e3nN+8JhHhXHacjatOKGEt+qhAqlOzK1zAdd2OIQMUErj6YNRCKGFGTaYoiwGPgrGFXZV7VO9QaD3UzecKTkqCzBDwvaTcpO0DKHRNhmBPbrdGnBxw95nQGStMlK8IsMKDNMn9M+xo7Pr16n/70ZwnA9X6Wz6mz0VsuNmAATNbS3dmNeQYIA6TCH8XMivQFaNMOJ42a3a9Huuzxvdr39G5I16bSdpyiZdkLnq+kqrA8UTaVKtHKR2LSun1tklipHpdwiIOjquMK/a9++9QMpzlzy5XKCZXqmwKijsqijsNDO+fMtv3k+vfCxbkIEZBhBxqLoyTz2vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L3d/uqtROV07wByGxF+hfQgPvMnzChdKYg2ED7CQCyU=;
 b=a+2qtPZLz2Ywx7VAOK7D0n2dm9kffeiAduSn2c/Zn2JflrpkvUxHXS150mIIR6/LbZowg5nDdzntzobAq1BuHygNEVlO6U34ude1UrQ1iO1dzwRD4qhdChacw1NQl2ihvQWuc9/J1vHTHG3sbpTNfMV7tAFyJ3FvLNHwNn/0ksI=
Received: from SJ0PR03CA0104.namprd03.prod.outlook.com (2603:10b6:a03:333::19)
 by SABPR10MB997918.namprd10.prod.outlook.com (2603:10b6:806:50c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.4; Thu, 10 Sep
 2026 10:42:48 +0000
Received: from BY1PEPF000264B5.namprd02.prod.outlook.com
 (2603:10b6:a03:333:cafe::71) by SJ0PR03CA0104.outlook.office365.com
 (2603:10b6:a03:333::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.7 via Frontend Transport; Thu, 10
 Sep 2026 10:42:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 BY1PEPF000264B5.mail.protection.outlook.com (10.167.242.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 10:42:48 +0000
Received: from DLEE214.ent.ti.com (157.170.170.117) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 05:42:32 -0500
Received: from DLEE208.ent.ti.com (157.170.170.97) by DLEE214.ent.ti.com
 (157.170.170.117) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 05:42:32 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE208.ent.ti.com
 (157.170.170.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 10 Sep 2026 05:42:32 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68AAgVoZ3150113;
	Thu, 10 Sep 2026 05:42:31 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 02/12] crypto: ti - Fix spinlock inconsistency in DTHEv2
Date: Thu, 10 Sep 2026 16:11:52 +0530
Message-ID: <20260910104202.1537226-3-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF000264B5:EE_|SABPR10MB997918:EE_
X-MS-Office365-Filtering-Correlation-Id: 9308dc7a-087e-4741-b799-08df0f28417b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|82310400026|36860700016|376014|10067099003|6133799003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	L8mo6lDtslEngmJi8UzbK/EMOIqREC3rQm1YZeERA65RGhmp1oCUs7mwH894i00atEvIsJp46MU2+jWf7v6aLXOMybCUsowZIV4sZoV7J5CNhKb6dBnrHkJIKErDe0Zux8IlKAyrXzDbFyLOzNLgPTWlpTVbr6c5lD5R3AdaSE87QraAhyccV+63M1o6U3GsORvGZy4mH3AQr8RKdb98pK901S5qIfwcVYAVpbYr3DWA3BVy8Ch9XCuFMHJygqr4Fji7EjmErCpiP6tcfPemNPCwDwIW2Qv1pAbDOp4I8bxLCNatNk7LLfrnDDLYaXRJF80PtQnhmeJKMpJ9y3LWOuSURGjFpIP5ZW9WoPrjVCEnfzgrjQJpqmd69BuhcxPVXxGnP9UNxSYV/UWB0z17HoNgYI9psnbLHt6ekVlco75Z9NmvDE7RBA2RaFFI4yRMuS+XSb4W8TR1cgc/LGS8uRh+6wmZD/ETWgIkNewG3gTiEyjOCPbys+WCOYAPPfAYdm6xGRiqF3oO4i9w/Tz5lhJIcq45qy2mLA2FKI+8i7Ob5syIAaviRuQ/IAeu2zl7WK3J8jKhBUfJB3zK+pd4Ex5qekfxn7r4ZWK1ocCLESaW2cL0J2VTTc9VVSi5XQrFeSV+DKtSLCpl6wVK+rSZ1cKUYu0+uqknqH8sVGkjLvbJ47UsGhvbT2y142IzDSHc3/vEz93oi8p5/7Dj4dXZ2g==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(82310400026)(36860700016)(376014)(10067099003)(6133799003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	fX4eY9IC4hLU7u7daLqXJNd7jG/2zfmCTq3zw2WDcwEY3E3dTIXt7eRoRA4L1YI3RftBpcYkWiZgrfa5kVVw6T6PnkfhGyC/Mgoseus56cvwbHLblS9aS27wxbNgkMh5l1v/k0d9k4ks9Z+Fq/wfU6Oio0M3cUJGr21QWemzWk085oHW+zpoe2oFdfcyEUcM1PcDXVgngbnSgb5IErcMlIC5c8M2rBe1iwdH5+oPAuHFaS2gZNsb9x/7JY+uMsXrfk0LarVnB780wif7hjPHhvg69by7DFfkkq4EfWr2wmdkTy0fFwK7n4pjxO/bh2NBU8H1IIPTtDXXbxW03nznjDeP3d5BiA5RxrPfMzquAmn/WDz4679ZOAZ/rkrqon4pXxbv14HUOTQkf+laqtsypeWdBHtYxWn8m1MvkluSYPKDFwLMx0jIQtkRl+WxCPpt
X-Exchange-RoutingPolicyChecked:
	V+rRTdsucNmxSXvFNkScq/gaxYma6xBBPOymfXxD5q7jQ/o1U8260LASbKoWwZK72Ck34Rzaw4Lg2/3aLcdM/4SXNnsfkUVYvWL2Rgi1uYzT/vB1e+2HO6Mg5sCBGqMPJIR7NLQdKSIX+D+wxkx/5bDAxikQkiucWTXBCucI/S0ubJnneYcMHOleLaRF63PiEmEBGR9acrCg2cH6QRzZQwq1FXLI0ZuLBIALj5kN3a1Oyd76YsZBov6/E4LCOZdHjKobQyzGuvIeXGyWNdf1/5pC4jn9RL76ikUYFvJ0I1swe+thojiOhgzWhhZTvSnwPNLUok6YBVpIzimwD7u3GQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 10:42:48.0283
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9308dc7a-087e-4741-b799-08df0f28417b
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF000264B5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SABPR10MB997918
X-Proofpoint-ORIG-GUID: ho6VyGAnPAS1sjb2iWZwrJDPN94sngxb
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDEyNCBTYWx0ZWRfX4hMkbx0+gZd1
 K4+QFNT8oQVYJS/sg8Bg1wifz8kxI6o4h0W0SHIvlvpaQquHv1QF7Wx8qeVPTM6noXu13wq5Z+q
 egI6UkDVxP5GOFcDkIfXHNJzhqZUJX4=
X-Proofpoint-GUID: ho6VyGAnPAS1sjb2iWZwrJDPN94sngxb
X-Authority-Analysis: v=2.4 cv=MqbHeGae c=1 sm=1 tr=0 ts=6aa289ac cx=c_pps
 a=MNM/txilNqeExyaWs+jKwg==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=ki2JzQWVm1jR-OH3vWAA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDEyNCBTYWx0ZWRfX5gugI5iI8wWB
 gUJ3zo45cemZUzCelKk4s702iASlFv6UnbacOyX58v8Uiyv2tucbI+4lVTIpVe97Jsbh4XXm+rm
 8CbsBUjsvht1NeFKaxqVMnQRSRS8rIW6+9sMlL9082gKEiojLfeXjBvMv0J8K5Or2uyvsOOeDFd
 hI/lL/B1mCrLm3IAM6tcNRGx5F6qj94/Px+I9Jph1hT/WH8Ptnxzp7hNDgBEa6NTqNCvt6/sc61
 fpWjeaomGSUHmh6ttrPS97O9oGU4Tlv6C1+XYIH2UgEa/XQYXOr4H1+c+eWxY4E2B2Mz0sRh34y
 z2U4B4szJbvjpIkVUF8JfSKhhfL3pJfLLfR9Ievk4zsC+yyy9hNbXthrLJu4AjyRO/TKYoPVWi6
 PDDebpDJo4114nuI4mS8C8yUklwPYycczjhm8J4AHVPVlKe/d8ncKQeTcWLWdcUo2pjqcdq89L1
 6FIViArWEayZvfOftRA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609100124

Probe and remove functions use spin_(un)lock for acquiring the
dthe_dev_list.lock. But dthe_get_dev uses the bh variant. Change
spin_(un)lock_bh to spin_(un)lock to avoid potential deadlock when a
softIRQ process tries to acquire the already held lock.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index cc02449382673..4c6b72ba104ec 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -39,11 +39,11 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
 	if (ctx->dev_data)
 		return ctx->dev_data;
 
-	spin_lock_bh(&dthe_dev_list.lock);
+	spin_lock(&dthe_dev_list.lock);
 	dev_data = list_first_entry_or_null(&dthe_dev_list.dev_list, struct dthe_data, list);
 	if (dev_data)
 		list_move_tail(&dev_data->list, &dthe_dev_list.dev_list);
-	spin_unlock_bh(&dthe_dev_list.lock);
+	spin_unlock(&dthe_dev_list.lock);
 
 	return dev_data;
 }
-- 
2.34.1

