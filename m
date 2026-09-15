Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13514718D3;
	Tue, 15 Sep 2026 09:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466154; cv=fail; b=coYaEl8chkP2lUxes/hBbUe8f6Tois9aLDuIjjEwuuk0HAMYFspBwMnq3n++fh0yzecCD92osVMMbgaq9PfLcw9/LxIyf17NAFATLcCvZRu0NTNc8le4CYwM8RzNgf5TsGSujpxWS6dAl3wjixtvpzZRT9eALPPcsnFKawXvwiU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466154; c=relaxed/simple;
	bh=t9opaBmY+K9yLqyOMEfwgkFj58cJL30E+3tEIdYlplg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=FV+cxVROj4RxxMVReTOmCPcCAHYuHSN0lN3TVy5o6tBbmZ5IvUI01cFoxFvmWLSdc8AvcVIPMy+VCuiwB3jPhnsKeItw9C+gA9mpFfRiWXsbNWJk5m1h6ftQWM/Fj/wMR1a0ywZ7ho7X0DCjFN77jjMStxXaKPqFjiSDaFZMrV8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=laej/6lE; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=szS3yupA; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="laej/6lE";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="szS3yupA"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68F9ejvr1480564;
	Tue, 15 Sep 2026 04:55:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=5Q6nE3RKr7fV+rXdtjdum+akrQZbv7f9wnaenV28O
	94=; b=laej/6lE2Wixwc1BYPNLlad11dVMG3MJYVo+2eotm6XI0t4qVXQCxJJu5
	EQJGyHRaK/j2OPK9qUx2VEVUJKa3ME4P9Sl14/rSlVlwD7z42iEaZISvgVv5wodL
	kcEpbuJMPbFvccEjCws6XVL6bd8+hnM+xnlwQUllK2NLx6GoqufipeVC9a0SCQrX
	beRwhAA47kfnjZWTZEqiG8j16T2LE24gWWytCx9ONMYLfGVJ6KT5XptbbUuASNcm
	yNBdYto/HD63wdDmtGEq6RBkzao8nSg9/5/xwGLALrualPYmNsfUcy42Q1Qi4Tu4
	oLycmB/sCx1P4QQDYKvc/ePvTPRzw==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010032.outbound.protection.outlook.com [52.101.46.32])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gpvpa2hx4-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 04:55:45 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TRqkMOsPpWYOS0W5pNyfwuCj0i4EpNc18p7CFAY1upU6URtdK+EjZVQItIC8H//MQvfhnw3xK+QMYncfwwYwgrohh5c1qN/foSRIdQr0ggSoFDxYPsoLKyUOoYpIh2q00Ywn8/Suz1QdN5T2HnSERyjCi0FVCIgQ5rMqX3f7gaVEJ/LXQUZcvj8IsllmB3YcOAiznw1ESrUzwUbt4TV/bDqNhDzp0x0JgGi9Z4rjnriGbNRVe1A+CLFmWwPsf0kAoHqRCMqJgnKflWWp2DZ/kdSSOPw/BLBD/bYw8E5rfuVCKwYSUOSA2eBLKWs5eP4XxGeqQm1joNfZNdR5azVvEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Q6nE3RKr7fV+rXdtjdum+akrQZbv7f9wnaenV28O94=;
 b=wBrku5itQRHKlM3JmNPE/48VFf6v+78mgv+jsdtNqTdaVFt45JvsKM36VX1cdF/hjaoePTsUcTDfOGoUykgYWvosAZyhICfl6mgdTJGvEXg7UveFqo9kDRZnbDjuJOkHtu6CxVVNiknBQXVcINhsYRT/wZ5SN54yqPlsjSygpk2KB0KgbLdBnSTZSaIZxCzbdNhrqpKe0cQvuS5HnlLgYTJT7LKCFciQMNf3YfTnoVPkcBcQwoHWqWMnSzDP0Yo5l6ryEccuuVcqnYkfQgLsqFultybAxqtmU4lJ3dml8SjzlnmIzahZBklZrO5K8Rx6wRNlH6pBq5gPiLlFiRa2uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Q6nE3RKr7fV+rXdtjdum+akrQZbv7f9wnaenV28O94=;
 b=szS3yupA7dvLYPs/e14cMNXYYH9QLm9VyPMxmlyVNvQUEykBCX3GgHt864PT6qqkRrumkeICEetsEBRwDlsMsOkXrdj9C4p1ED2VkwAH/NesWVp4szE3Mf/mh1brHSvT599P3vQaHbxmhm5IiPBksBG1BAP4TXMn7M5Q1I3+Yq0=
Received: from BN9PR03CA0543.namprd03.prod.outlook.com (2603:10b6:408:138::8)
 by DS0PR10MB8030.namprd10.prod.outlook.com (2603:10b6:8:1f7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.8; Tue, 15 Sep
 2026 09:55:42 +0000
Received: from LV8PEPF0000006B.namprd03.prod.outlook.com
 (2603:10b6:408:138:cafe::6e) by BN9PR03CA0543.outlook.office365.com
 (2603:10b6:408:138::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Tue, 15
 Sep 2026 09:55:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 LV8PEPF0000006B.mail.protection.outlook.com (10.167.248.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 09:55:42 +0000
Received: from DLEE201.ent.ti.com (157.170.170.76) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:55:28 -0500
Received: from DLEE213.ent.ti.com (157.170.170.116) by DLEE201.ent.ti.com
 (157.170.170.76) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:55:28 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE213.ent.ti.com
 (157.170.170.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 15 Sep 2026 04:55:28 -0500
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68F9tB7s3000901;
	Tue, 15 Sep 2026 04:55:25 -0500
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Tue, 15 Sep 2026 15:25:10 +0530
Subject: [PATCH 04/30] crypto: sa2ul - remove unused fields from
 sa_cmdl_cfg
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-b4-upstream-sa2ul-cleanup-v1-4-57ab34e97162@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789466112; l=1630;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=t9opaBmY+K9yLqyOMEfwgkFj58cJL30E+3tEIdYlplg=;
 b=Y2ZbrZHG9/y9e8siK/JQO2lH/q6WnpaMiC2Hr+A0WN1d2dnUkA1jtAW9L1Rc3T00BFZgNe/pk
 YrdnSkVpMp1BK++yIINFuixY5+JW7/7l26wJ2N7k1+8YF1rfkPT5JOn
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PEPF0000006B:EE_|DS0PR10MB8030:EE_
X-MS-Office365-Filtering-Correlation-Id: 027cee5c-4561-4aa2-c9e6-08df130f8172
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700016|82310400026|23010399003|6133799003|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	VeD53SXtEg64t00VtRvLGsh66CCucKvHajhf7ab9UgtKR9mf3lLfyKC1+vy1L7GYcIsE5r7RZtqn6zU2drUHTV7rSLL7tujREmri7ZVnVbZPORlbgAJreGt7FA25iAUKNMet2GLVfPFd/wh+pSx/tWw55yhqcgadkWmI6M+cwIPg7tEpn4lPUN8AkVZXbMnkwwlt2g78QA12X0PvjPqbKJlzQZxZ1sjEC9RkzOHfXCDd/9SqOt0QZoDZKuDzvy4lGsaGs8Ky/Z/c7zJk63vmMB5JeiN1PkhHCdb0WGm4WUz3c3m24U2aDgd+OAMR7SNVmUItp3mbKfjfQX9dQTH8xvHn2MHhjdP45TVGlSNEvC5uBLo/1blwKaE0bGubJA5L2viWv+8M68+9AATyYOLqwkppZjXxUnAR4xR6MsLY5QeHXgHkUAbCWNY/WKD7OLtm9aGsP8SYE9GNs4j3eZ52FdVGUIjSVNdvqjaJuCCj3WYby6g+PkHOWqiSpDsjXiIzPn09McTj3BOYqSTsiUw4tmDc2QgpNRlzcqdqAusYDRHTle5JdJorydTVy+dcODSgev3BfE8B0DvBiO/jlVslJBb0lvjlr/+UOGIVchy85odp34Sl050XpPvyJyT0e+fHfRIZAQGNjje9rhJfsDc1NgRRU0lXPnZ+La/7izS1KPgbvenn8RtlWJsEOicuJzvtJt7GYaxl/oJwNgxgmwIKxQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700016)(82310400026)(23010399003)(6133799003)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	6AEHPWR13TdepA9olYPMirQhba3kGMd9ONCRmtoOvFwmJik5YNJ0us/UDHQ2vriqdXFAiruuA5tRgpQEezAnUJTb+OvTVDDNLY1DG1Q58L6+zhzUWoxRQoEFv1NdZf+yx7PpyP/+ET1oyydax4XL1MwWGjiwfwJZlqXOUQ3LeTHA3cPDTKJRKjJcsPVTN5KYoXJ8CKDFJztIZQ5Kem2oDwAlLcMHEVH1IaxnitsRZLI3gQsAQw9su3WTGx4hig4SLbavDGOk2QT3Ol+mdSN/0nkG0hS56NQ8jeNZxdLM9mXzksBuqRKh8NaDCIRcIkO73HmdDMVmhBQI2lVqNta1mpfua+1xoD0gC0qnhaZkFTop9PmGzsQfP+i9lrnt246vArmK8Bs8ULqvGY06MpSBgufiPFyqerpeZUCdwemw7h3q2YwjSYnIjwKaDU6NyREp
X-Exchange-RoutingPolicyChecked:
	QUH1bZnStCuwQ0va4Eqw6nljxapZlHtRCR/cXiPf/FWNHL4QSpwHEP3naw5DvLzpuHIWQodUhi5z+GBvbbe3p3Y5sNHR+tqCqekhPkPeNDv+djRcgtKCsVRGwCkJIQi5UfK2b3tqyvOSDsYqSVVOLeSRVXm5+2h4r3WvooH9h44wsEIuK0bvesHv0OSh1r5LZE+Z97JeXytbWS0RiTN8yVNPUeT30V7vEVzTYfL36h6P77gHYJh+kdbvDbFA99113TQ1pZgbV0YU1KdxS9GnCOI5L/uomIWAUpzZ3Eo72fLwPBcSBKmYn8iFB5AMOxhlFCRnAfe7rHQE5/ZzX6eDRA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 09:55:42.5872
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 027cee5c-4561-4aa2-c9e6-08df130f8172
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF0000006B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8030
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX9yi0YUH5ZJUs
 auh/rvhGIM6MWeBklML42zGQS0fllkNIgWXYVK7Zfx1dECULVLN5wRzdfs8gaBEQ98VJUnjE7+c
 dMbqTQ0nclYUOPwahg5X186vhX3Qu4kgFA0D0WjImtyLnaTTudwhQ5VwFReP5GQkYGPxJc/LW4y
 fjOf2VITR8ScUxyaNUj2tCe6HmChkrEFgNPcEPGEVqdRyYdN8M27KEAsYqoMQmVcQWO/5BLGyH9
 2b+YaaKMdjp7aYDvrU4dcW07xaZpqFT7RHmsdX5VcEV/eD0HmIgyZLLwQFvLNRciuDlWzKSAkAE
 eEpfGQ738ugQubtsTcB2a9YNzLqYgVNM532/MoLDBcQBLVCUYh8Me2Wicqr2uuOeNZ8J+vbDxZy
 UiSbjUUthrnMGxtMECe7qR7ygsGn7vLHxPb78rsNq10vcVZ7yvY3pn2TMffRW1J4hga5gwFNgkg
 c5v2Ze31aWmO/LBsGEQ==
X-Proofpoint-ORIG-GUID: uM33ziilSjzKk7z2olrJ3MJjtAGDX3sE
X-Authority-Analysis: v=2.4 cv=U7cHnuru c=1 sm=1 tr=0 ts=6aa91621 cx=c_pps
 a=aSTqfDprWv2neSIyXEkWYQ==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=s63m1ICgrNkA:10 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8
 a=IihQRFl1KD1MKXbbWYkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: uM33ziilSjzKk7z2olrJ3MJjtAGDX3sE
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX7ZPBdC7G1JdC
 P3va7qqtXerJOtzc9GAvw6LiFyC0VyI59B+1x1GWr8E7PvoUsw3S57ToBRjytC50TBbCWriCjIw
 92U4IBppJYMHnzgiYptAA3WTSyuEOz0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 clxscore=1011 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150143

These are assigned but never used. Remove them.

Assisted-by: Sisyphus:claude-sonnet-4-6
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 3297a25d9d9d..e49cb741074f 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -95,16 +95,12 @@ static struct device *sa_k3_dev;
  * @enc_eng_id: Encryption Engine ID supported by the SA hardware
  * @auth_eng_id: Authentication Engine ID
  * @iv_size: Initialization Vector size
- * @akey: Authentication key
- * @akey_len: Authentication key length
  * @enc: True, if this is an encode request
  */
 struct sa_cmdl_cfg {
 	u8 enc_eng_id;
 	u8 auth_eng_id;
 	u8 iv_size;
-	const u8 *akey;
-	u16 akey_len;
 	bool enc;
 };
 
@@ -1423,8 +1419,6 @@ static int sa_sha_setup(struct sa_tfm_ctx *ctx, struct  algo_data *ad)
 	cfg.enc_eng_id = ad->enc_eng.eng_id;
 	cfg.auth_eng_id = ad->auth_eng.eng_id;
 	cfg.iv_size = 0;
-	cfg.akey = NULL;
-	cfg.akey_len = 0;
 
 	ctx->dev_data = dev_get_drvdata(sa_k3_dev);
 	/* Setup Encryption Security Context & Command label template */
@@ -1764,8 +1758,6 @@ static int sa_aead_setkey(struct crypto_aead *authenc,
 	cfg.enc_eng_id = ad->enc_eng.eng_id;
 	cfg.auth_eng_id = ad->auth_eng.eng_id;
 	cfg.iv_size = crypto_aead_ivsize(authenc);
-	cfg.akey = keys.authkey;
-	cfg.akey_len = keys.authkeylen;
 
 	/* Setup Encryption Security Context & Command label template */
 	if (sa_init_sc(&ctx->enc, ctx->dev_data->match_data, keys.enckey,

-- 
2.43.0

