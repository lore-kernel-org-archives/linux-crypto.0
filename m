Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE2447ACCC;
	Tue, 15 Sep 2026 09:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466169; cv=fail; b=avATW1JHI+j1tc2cbfPD2qvrNTnWBB4nFy+7548iqG7uwiD1E3vUJBdqPg06SsdIwChuWLN0iyjAwXBkEgW3KFtZc6KL85y9IWi+IbM8ZEJpTBtuPpmZS+4v4KrD+i+KFmxhI/w9mTaV5NtMVkyrtZZWivXPyOPUYM6i76iMDq8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466169; c=relaxed/simple;
	bh=lMNWcW5nQ187Y8oArj4VdaO+eE7Y4ni8tV1JjNJLlG8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=P1AGwgRMNyyIRpXQaPQOGkP9lN0ZTQ5VlIp4RltdWJaokFLStLo/yHDW0wKYcfUKA3OaULLmbraqrdpZmo6TaCnQVwlkmqGpfZyZ9I88WkFSPWlluFqcsHAgM92Qwu05JKeNzSWITqLJbBLoHGZsN5mCPUE/YlLMfpT/80M9qbs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=oFVKkRgE; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=e7z6pg29; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="oFVKkRgE";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="e7z6pg29"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68F9fLV94098112;
	Tue, 15 Sep 2026 04:56:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=dEquf+rJBeu87KW+5hJcN5LV+z4T+kj8tW0rS4ZeV
	3o=; b=oFVKkRgE1/Z0nGit/Xh25E+zTvbOGajY5YETtYpoUnTrR6BdwbuiQBqBQ
	12fSOcG+yn4PWlTLZjySMxVVsBjQePKtUbgfWYMp57mnq/myGS28gqiICZ+LvwTQ
	y6Ij2zY7ZlDieYdR5r2EGGWeXW14tnHZ77digx4yhUc5YufnL8hDihICC5qQetrD
	IvEg66jqMfj3RBrqRjP/HCHtCZ8Z+fm5sx+YgpbVBZR99H65jyuUZvN4Ebv05p3r
	DSyLHLQvxUVpF3hAnKCdjNzUT0QeMwK3nS3bovgHUL0GYg4RKdrx0CoVjvGZCWGR
	9iFD+qsU3JQ30HRWXmn0coKSIPbLQ==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010068.outbound.protection.outlook.com [52.101.46.68])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gpvpjakeq-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 04:56:02 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LHNlm8rVrNfzGXCqAGc2iHdAYO0Sco+e8WahKl1ZRMk87P2QMiAQvng8uj3i1G1t7O/uPlbZhLvjM26YghSVqN0Mtf1CVIr4zj8U4wEr/GMax6QLU7Uj8DamATqpn2LUdhl5NfkpInQlBMikJHZ44ASblUXssRLhCCoWgUnXeH/96jPhMhdMwVQBcIFthO8YXOtbYS4KjFH79J92bOjNotX94dpUMCdggHDzkY4DAS7iPv1Hw7onu9lnNz/bhAkDKJ51oS1oNNFrgA4MzBp3LcLtezvVTbg2D+KVX97jKROw0g59N24UwbWVF5wpvob8bxz8P5+OF49QEkpeJONV9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dEquf+rJBeu87KW+5hJcN5LV+z4T+kj8tW0rS4ZeV3o=;
 b=uZbjUVooHpArg9dMydRxBtPLv6jC1DYqsIK4aUsZrbmpph+EQ1QsesEHtAyn+2AdiOvHQVDA3A54FrvIvvZAZrBgjiQ8cfdzJj0Gg/JpBDZ30hdW62W31F0MhDJ67S+w3rC4ipS/oPPrXni456akN/CUCEaswfqnX6Uisa3a1dEz82fRe4NJ3r2dwdton2oWQAp36NYWjSYuVbgtfr1juT/INOfsSh4aW7J0LyVtktSHTQKInO2ub6w7MXt3VgBHTSiw4pbcWcp1usEtSJeHmTVtI3VtZs8rj/euwAU2dgMvPG1zAtqJLMfW1/AUJFncL+519mOdDf2ls4mHS5ARyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dEquf+rJBeu87KW+5hJcN5LV+z4T+kj8tW0rS4ZeV3o=;
 b=e7z6pg29kB6XlapLDnXR+acA8aUzlQqtX6T4JHuMIf+dcdw9IzWtkUKFaMsfiKUXufu4io5lC9EBRJ8FQ7/BJVnFEQ0S4delxWuK/R9MzLOKL2IoyRdmCyB3D0DTlMzwG0fQhsobWBchBmvH05rH7cQDf90AvkqoM1PKsrfs3uc=
Received: from BN9PR03CA0061.namprd03.prod.outlook.com (2603:10b6:408:fc::6)
 by CH3PR10MB7808.namprd10.prod.outlook.com (2603:10b6:610:1ba::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 09:55:59 +0000
Received: from LV8PEPF00000068.namprd03.prod.outlook.com
 (2603:10b6:408:fc:cafe::58) by BN9PR03CA0061.outlook.office365.com
 (2603:10b6:408:fc::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.10 via Frontend Transport; Tue,
 15 Sep 2026 09:55:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 LV8PEPF00000068.mail.protection.outlook.com (10.167.248.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 09:55:59 +0000
Received: from DLEE213.ent.ti.com (157.170.170.116) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:55:52 -0500
Received: from DLEE202.ent.ti.com (157.170.170.77) by DLEE213.ent.ti.com
 (157.170.170.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:55:51 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE202.ent.ti.com
 (157.170.170.77) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 15 Sep 2026 04:55:51 -0500
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68F9tB813000901;
	Tue, 15 Sep 2026 04:55:48 -0500
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Tue, 15 Sep 2026 15:25:17 +0530
Subject: [PATCH 11/30] crypto: sa2ul - remove unused line
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-b4-upstream-sa2ul-cleanup-v1-11-57ab34e97162@ti.com>
References: <20260915-b4-upstream-sa2ul-cleanup-v1-0-57ab34e97162@ti.com>
In-Reply-To: <20260915-b4-upstream-sa2ul-cleanup-v1-0-57ab34e97162@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>, Keerthy <j-keerthy@ti.com>,
        Colin Ian King
	<colin.i.king@gmail.com>
CC: Andrew Davis <afd@ti.com>, Pratham T <t-pratham@ti.com>,
        "Kamlesh
 Gurudasani" <kamlesh@ti.com>, Udit Kumar <u-kumar1@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Manorit
 Chawdhry" <m-chawdhry@ti.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789466112; l=681;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=lMNWcW5nQ187Y8oArj4VdaO+eE7Y4ni8tV1JjNJLlG8=;
 b=0EwS4TDDXUeVjXxtEEJl+i8qJaiAptgtY6vPPF5zT5SJhEOBoX1vp08J9XmYXPze7OpEvbHIw
 a6WuCib7P1rAR56m4esY7eeeFBLvMDf+GlDfxQ5e6kU5YJV1yU6g/Zs
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PEPF00000068:EE_|CH3PR10MB7808:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bc41515-5fee-4567-f285-08df130f8b7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|23010399003|376014|22082099003|18002099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	xF+YKt2Y2QHGDCohKfzDdBVHoJftpfDtvJeX18re7UyrflVSsUI4gJMURqUgDfUo/4SOuM92csvNnIDnSaTyvK4yxI88YRY2RHmeZayKEowggDlX8r+Lj0+WkU91umUObL+UUmtsKV0RR2J1+EeMtguQGQ0ZFeYbnQE2H4CKhaeHHPBFVA43YdszgO81c/0scX8Eyjmy/fOfXB2FQ+QJW2vpSrkpPSJ/Irf1UCAlpSDDW2HSBlxqzO7PFxyeIaU76Yzzl7vOC/egvOKaWz9IBZ4DXOX+uuwlyH3mddcLhxCk1t8GBS2xdGkif9Mp/o3XU04RHd5KRomEBH2F8V659ktTDmx5QtUmMADzdl5B9DiRbpPU0otiBft3SL7RW9ppvaOoMg0QineIPbzB0vY4DagBAlUQnQyDnIr8ZNJV/fduMb5oxA90k23FliaE00DYzGNCRmEcK+H7n/CxdjGOg53zbjpUuCXgK/aljdiYFCvTytuOvi8lwwyeeV5apYBg7tJahk68i7IDMKz4LqzsSa1J7gtt8rkVwXY7h9jgYuma0hvCZCqEreM4rKR9Jwr+pERpukNuBQm1dIml3vXjptl4a38F/xKGGMo7Bv95K1Zd68qTC3a6ocbKcMySJ19EBz8fuKGMyDg1amS97+xLo9p/4tov1DFtd55xp4RYX2OqFxHwO33Wme5VxbCL8dCViszMVOEhePXV0ULyBhJ5mA==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(23010399003)(376014)(22082099003)(18002099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Y4lI8zd3lLltgyAFxk5IiYNlQuC7KM26maFjo/eCbbttlSZh09M7ZSZ9rfddNIJsP7mNaLUWdaWRjbYEXBWmOJBYgnx0BWI45YSnq6qhVt/RDEJeMXnd0paaHvB3mwu+SPD1WmBl5SFEStRuTahZYa/IfrJQT8xabQVlrZS3YZlf5F+T0XCP5Lbs5s9G1xjdGVkD3nMzQ6ZdHaGMvREXOlw4CKrfnJ3qHmVQeGp5K/UX5oneokcBFEVsP8wnkDu+R1A0KmMVfMBJLCQgi+zHz/Ex57eAROyOv+dropJgu5PhJ11rCB1tiNd/qd44YFc3/VAVERXsTETrh7PbYVdphTWsViN0eZYj90OMpYm32jiDmi1CoAQxZBw21Y5KOiIy4Sx7htGH77/Ow51QlYvEjKhoSuJaVIWvr3RqpSB+P4L3XQjCUQTyaaIksSZkQ1iQ
X-Exchange-RoutingPolicyChecked:
	qCuV2AVMnvLoDr2+i+G8Bmrxlp8S3F35Iz5CDeelgLHPVTx3gYiLlROQN2rOXrfalzx4rLktJztxDSP++AH1Q2U812Ww2eV41Wb9AZY/klyYi5LIeGDqVwCmtWk+JFvokru7XztCy4N0Y5+gkkd62pAcbFIAH1UqKZtx23XK+vjrdyQicVUO9ww05+x737Vz1zSo4d83l7Q8JGOsx1qmNW+U+7UdLFxOXwKIfewKa17spEL1O+YII8XsD0MGnkRGSpbA9KGQIFzpFpQKc05wKbeK0OoTyVrPiVYSJ3cwCPmUuBb6AUv2nsHBdwDIbLE3mfGuMXPvQshYWEn7Sbv+pw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 09:55:59.4353
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bc41515-5fee-4567-f285-08df130f8b7d
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF00000068.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7808
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX5te99zSv+XcU
 kxR5xZFmwJajR/i0zFTfv0863JoiuMJWCDwoDJR2G3IFhwdiikwXUXnAKNwrOjbhxZSDPbEnF/i
 LYbH3aDMQdUXhjoenaGigTGxuFFICg8=
X-Authority-Analysis: v=2.4 cv=KvnYSmWN c=1 sm=1 tr=0 ts=6aa91632 cx=c_pps
 a=bquUzJqYOqw1EpBvECFzMQ==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=s63m1ICgrNkA:10 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8
 a=mT09JPwF7r0fN5Lx0jUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: slDAvFJqfJiFPkJrS6XyP3Xbd5srcw-T
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX6dUHTHF5zEbr
 ZAslTR4sAbnPtzGrwkdatR2gbPxGBHptZmWX95xhqv3P2eGz4s55vxJ1B8GTypilH0lVQlf9EWa
 0FlvA2RvH4mACLtcox09jzwjx7ol6P8trhqs5f6aW8nNB99VEXdY8JBgqOxK+tPwwnzljcvBuSe
 n7qQNHZDug9CM3Z89PoEY1LM+Q82AAtuC7nPy3aqeq4YWBTYNnZ1YC1GefJc3U/QLdtzwBbQ3Hq
 txCUiS945MA+aRf5Of8zos2mWbeekQQkEYCyb7fs2t29iMg0SMSE0LKQCowdBakbBPqhccnFHZ1
 Q/Kh1+g/5w+mlYU6DFCLlodotmyWhPLUB9aY1r7v6Y2MNvEaCxuE80xwnfIisMqz58zfDfWNiA3
 su1BRiRUeb842yuMe1IkHypJUS4eiumDNLAylVqkB9PwPJtsGtu1QF9VhvvVJUTUVBt8WXMyRz7
 DGTGZPTuAcdR8/eysBw==
X-Proofpoint-GUID: slDAvFJqfJiFPkJrS6XyP3Xbd5srcw-T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150143

Remove an unused line from the driver.

Assisted-by: Sisyphus:claude-sonnet-4-6
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index f98d199729d0..c774447e7a5a 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1239,7 +1239,6 @@ static int sa_run(struct sa_req *req)
 				   sizeof(u32))), cmdl, sizeof(sa_ctx->epib),
 			   sa_ctx->epib);
 
-	ml = sa_ctx->cmdl_size + (SA_PSDATA_CTX_WORDS * sizeof(u32));
 	dmaengine_desc_set_metadata_len(tx_out, req->mdata_size);
 
 	dmaengine_submit(tx_out);

-- 
2.43.0

