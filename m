Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C6C45A297;
	Thu, 10 Sep 2026 10:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789036990; cv=fail; b=bF8BOfMJbK43KgOuST8TyS4PfwCdc9hdpSBjKXoixreiosNL49MCGeuGRdl35APaH5lWwSVSIncOoG8Vv2MA6PvbiMlnabl/Zju479cRvHbibO1uvY4TIfT+jVsVkQh8khFmhyBKe3QBLep55fTixQqRc9e9oESIEXVoZzz3Mbg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789036990; c=relaxed/simple;
	bh=SytUeFdB/MKaYKaubrhZRnRz1jmrcwLjp0R6X9UVqZU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G7iEUHVVHXnR1hKm/8scN3TIg+rXaiz7A5n8jxAlufX5YzRl5A3wB8/s5LJwfR2ZEkzNcYJFa8DNF8ksHmqtCfjzS3subtdinfPk7JCUYhuYFIXyQ9Vty89CXVENGmCsMCZDR8fb/PIXBIZmGH5ufndbBlr1bIq1ec3nmwkpWFU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=M1g/DWbp; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=AFFy41ZJ; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="M1g/DWbp";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="AFFy41ZJ"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68A8oH6T712619;
	Thu, 10 Sep 2026 05:43:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=ys2sjHHwD+AiPU99+X4BPnXwi+/C0iIWiOc5Chq+H
	GE=; b=M1g/DWbpJ+7bVBleuag8rhJLsfHLPIN0EnbvXYPGT9wwQA6fNM38uOdAZ
	TDcr/E++BswinrCBVpm+Q13J0f/9CpUcXv2C2E9z/FIPiYXWjfgU4xDBNSBVslFJ
	uosa9vCQKZ9+jtv535l19vWks4igNBdRU2wX7V3mjJS+Pp/2jTBjeXdRMkzHAKQM
	U9lT88ofNY8KnAoPldg6G0Rxa4q/C/hbPYo5VNhdzWtmAyZJDUVz9Xj+AswcYarD
	lVTKVGnB1FYDZ0dARWZIAZMZCcXnnr2GYScZr/KyQgN+taTN6KHlDjuRVTy2TXmC
	tIvcJ6cGkdg0kMu21FLsw6DxL7TSg==
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010014.outbound.protection.outlook.com [40.93.198.14])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gkcxgcnxd-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 05:43:05 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I/LLolDbd6KOXPO0GEF07tLcGwtYoLsfTzAp8DA2afmZ1j8Yqj4cjrvAlSHTf8vsXAZ+3d4VnP9OY74lVGdrh7scQaWRdUbfa7FiUSnKVgeZqxurdA+erOjM+SycZaLblt8Kom1TLEFOVJ9cckjZ40a6sij9t4Vm3JqARm//ju2d80p/MZwl06ra3b77dVHn7KuWb1vIu808YcUC332O09eV7PyjyhkjrjUQuS7ZoNCkRSNhynA3veW8VyabEtIma+0Nyt0AaVNJNHvSLpHjHZ5MEC+14l1PjqayNM/MPn+l9MhjuSoN7dqcRhS1BzeDJuZgxhGHxkAafzvqp8uueQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ys2sjHHwD+AiPU99+X4BPnXwi+/C0iIWiOc5Chq+HGE=;
 b=QbYDRbPuJ8LVRhQ+ewMWqnkszwvSmdpkhFtBa28co6WxVVsukLCYPfFFLWw/VVS8vsZgXktkPW+9RG9MAVSHRuAOIMgDG8l6H2zvs0oKon7OemujNQzWn6nw13F0FpDuZOD/84plUGBhgALVXxqWxrw9j6rwaZuaW8N9qqZFPjpLTtob3fcodlyWDIzBfOIAs4YNCh9TGiIpC9lXe9bXW1C5qdV4PekqRz7wVXorlmHZxOFc/FiGFuhrAkEJntEzZ/lK7B1E91924PfTEERbzmIINsAB1A4V52y9nLWgD9oOAj2xsk+8A1rUPascGi91aABc0NhJUld3JMvDLfv8Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ys2sjHHwD+AiPU99+X4BPnXwi+/C0iIWiOc5Chq+HGE=;
 b=AFFy41ZJzgcVbeI9EkCI9NnQWnh/OkhU7He0jULrK8qiOMKUINrjHBRkEsXzSx7mOYGa5sfuNyNRJ01Gkuywb6Ytfr8at8J6coPMQtrOEjj1jL+5AMD5JrKH+WCy2YweEACzqtwe4E4jEQgqQSwba58beEQd0UGAYJc/ju0XFFM=
Received: from BY1P220CA0021.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5c3::16)
 by IA1PR10MB7358.namprd10.prod.outlook.com (2603:10b6:208:3fa::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Thu, 10 Sep
 2026 10:43:02 +0000
Received: from SJ5PEPF000001EF.namprd05.prod.outlook.com
 (2603:10b6:a03:5c3:cafe::2) by BY1P220CA0021.outlook.office365.com
 (2603:10b6:a03:5c3::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.7 via Frontend Transport; Thu, 10
 Sep 2026 10:43:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 SJ5PEPF000001EF.mail.protection.outlook.com (10.167.242.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 10:43:00 +0000
Received: from DLEE213.ent.ti.com (157.170.170.116) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 05:42:35 -0500
Received: from DLEE211.ent.ti.com (157.170.170.113) by DLEE213.ent.ti.com
 (157.170.170.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 05:42:35 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE211.ent.ti.com
 (157.170.170.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 10 Sep 2026 05:42:35 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68AAgY902177590;
	Thu, 10 Sep 2026 05:42:34 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 03/12] crypto: ti - Fix potential memory corruption on highmem pages
Date: Thu, 10 Sep 2026 16:11:53 +0530
Message-ID: <20260910104202.1537226-4-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EF:EE_|IA1PR10MB7358:EE_
X-MS-Office365-Filtering-Correlation-Id: a0cf1929-16e3-4f72-a578-08df0f2848c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|23010399003|1800799024|82310400026|10067099003|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	dRFdBcI9bp3GVr9/FXVI8GwtYzsU9uMygghWSQTKKAlW7vPcZZE65zh+mY6+3fAWAkV9KtSq7HC1aRkw1MZF3drETnxhOzN9vqFViwPBV5RDR61lY7lH70pUkRd9nDHpnNDoyT3LiSsjnN4koh+XVwy/NukDEidAt/KokrbKjekks9WjVFCK1lXtWOBMttRmX8dzTH11y4Nbtyi8EXYBcpS+qFlRTawRFr53CRDRpqrqIZjuZhSaRGqyxgmi8xE85YWDz1YI0LfLeoQoyiv7VkEb9Om9a2gay/Dk46zuRdL69dAwYz9NMUuLRY0KYv1OchvuugWliNPQN4atms1x8WfZX0vbcPg0fyRCc9w1aI2W6OlPDR8sfIFVaDPfQKcnzuk52V8go35wGWWtvHOkaj/y0bFwGiBOebjCVOILwJHWJ48/Wzq8Y/cArzqW9Xe/zfMEaYA8ohJXDyELkxTs8hv1IdhFXqZ2FTosIZ5/xQOiijq9bxClwMUernhkQPMMOB9u0Hr6KyeICxqw6HThc6GTdTKXoP4fhN0l21YFHDQWGnamz/oIWIRcF4u2HYZ9UJx1JvETvfW/FSrLzAiyb4RQh07rBzPfanzJ2OGWUhYEroJp4tst/CHnEGRzcSq27X2kGGPmmkITWqX0nseaqwtcn8ho/NqV0KKFSKxbw5QkdqI5Iubmy4dlPGE7GtAIOvR5F/XgkwbNz4pqNftqCA==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(23010399003)(1800799024)(82310400026)(10067099003)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5QzD4NkXr7sgh0sP6MXpx59wD2pm6gqdO4J5kqtxiHdKH0/3X1bc6eRwLdkSvdbHdhlrkmN4tTqwN1ha1Sh6tVmCQij03XxxJa3GHbuudJ/HKInvxiuR+0uq/+3ogcsA/cgpGbhA9WJYEpFeznN7ctziQWsjBPiwKg36JOUGOQhIjcEdtYW9XEjmtLgSDiTtSuCXNitChXPNymxhInSROx9nTwc5HY+0o07bAZhhHwB7uLo6uIKQjVHlflsT3cuExBhgqepERZhQLLtgxry7Aq2THFRse7HK/qyqVpbylR+np3xVFx2G76P7gXY1Fn9j3C8dyUfvMd+FHD4CBe9cV/FHf+LTjz8IBd6KdJtiNb4FxqNYKDDSSB6ilvflUORKe4xOt2VCEoJOhpY1l1DL9qbsoWSWZOZ0MwbgV2AsSZEX5x3O8ZbWhF2d/Q5TUdjb
X-Exchange-RoutingPolicyChecked:
	v19fE/bwUaZYPD1e/UmuKorJbBruJkc9rE0KEE6LjHCFaOFS7/NCEp6Ps7fqNH354eHfl+RWamPmGq5sLRfrthbuawVd12i6NiIXZQCJD1IuYawm0ZLch2qY5cqd6QwyEEB40pA1FfeMh9Lx5fo6wPQ3jX07loo8JSKIlpakSCBo/nuhTOotmx0qeMD/gFZRyQ7gVL/gzIAmL5Ox22cPRJT37Ei7XgnQh1c3lSweo/UXVbVcZezRKxj/bRy/H8Hl3K4t0cL6DIqd7nzyO+4dSYSaBsnQkhRR4it4qiGJqC9WH82IhJ+gF+J3C1BNOUCK3CkFR8sIwRZmQx/U4KDY6A==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 10:43:00.2219
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0cf1929-16e3-4f72-a578-08df0f2848c0
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7358
X-Proofpoint-ORIG-GUID: YiUHgrHkLisqWOITHozOnBSbirpC3xY7
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDEyNCBTYWx0ZWRfXzEoz48UdjfIQ
 Jdx3cniwJ1JjW9Q4FCRDpPqHDfDlkeWDvhK4kvbI2JdijH9g4nLKJQlrzPfzy+joYZoUKifPBNg
 Jp+2aRQs4JaZ55zJCV8EZXrr+j8U7Z0=
X-Proofpoint-GUID: YiUHgrHkLisqWOITHozOnBSbirpC3xY7
X-Authority-Analysis: v=2.4 cv=MqbHeGae c=1 sm=1 tr=0 ts=6aa289b9 cx=c_pps
 a=CzkwbHv2eVnX1aWe+0O+5A==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=IXP722aH8NCvtdUuCEcA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDEyNCBTYWx0ZWRfX4l/7myDXCnfU
 SWFv9UKRt63l9KZOwZG/MKWOCZ/SFxlb/uOqKTBnMWp8bAFBoAvYjX3YLYnbvFHW8NrNskZpyLb
 9QAa7agLYIrK59LVWYAFQm4hJZhd9yAz+2kw9zNr1iOKK9mEE6EM4MaE+tG7cJ8iAKqIHuta868
 OBNSIc0uEGfpGFeEgBc9v6RVmic54e1KetSExazX6dWmNLxBtFTsTa21RuD57t2lnwmqohhqYFE
 vDY3yLl5XQWxrQ7e/4JjxlS+bcRB3xXhKFYd5sFB+Cc6niYODkUcdIRc85n/dGGz5Ban5LxB5lo
 nVJ2keDaGyRs71c+QkCXz4+MuRVaDCPSG9Usza0CuFkKOKRfsMklDMXyZicXEOLsU5p2X87mxRZ
 ehabYPaBaRHRAadoXPa3rzNq2fA1f68nP7XD91fOcu1C+S55ijDerhqKY5VRw1fWMVRASBBjqe+
 WfuXIc1ny29MkG82z8w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609100124

Change sg_set_buf to sg_set_page in DTHEv2 dthe_copy_sg function to
avoid using sg_virt() on scatterlists. For scatterlists containing a
highmem page, sg_virt() yields invalid or null adrdess, causing
potential memory corruption. While we are here, also change function
signature to change buflen from int to unsigned int.

Fixes: 35645ca63caa1 ("crypto: ti - Add support for AES-CTR in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-common.c | 4 ++--
 drivers/crypto/ti/dthev2-common.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index 4c6b72ba104ec..8628187a32e18 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -50,7 +50,7 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
 
 struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
 				 struct scatterlist *src,
-				 int buflen)
+				 unsigned int buflen)
 {
 	struct scatterlist *from_sg, *to_sg;
 	int sglen;
@@ -59,7 +59,7 @@ struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
 		sglen = from_sg->length;
 		if (sglen > buflen)
 			sglen = buflen;
-		sg_set_buf(to_sg, sg_virt(from_sg), sglen);
+		sg_set_page(to_sg, sg_page(from_sg), sglen, from_sg->offset);
 		from_sg = sg_next(from_sg);
 		to_sg = sg_next(to_sg);
 	}
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index d4a3b9c18bbc1..75d9a097650da 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -126,7 +126,7 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx);
  **/
 struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
 				 struct scatterlist *src,
-				 int buflen);
+				 unsigned int buflen);
 
 int dthe_register_aes_algs(void);
 void dthe_unregister_aes_algs(void);
-- 
2.34.1

