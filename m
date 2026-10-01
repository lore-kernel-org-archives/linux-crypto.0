Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F9E3B42C5;
	Thu,  1 Oct 2026 08:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790844791; cv=fail; b=qZULSjeNe55jPXac6r+SeXITF8vFNkNYGm4t68DFN7ikuQr7IuluPehbU2ENnHREXbfUYIGB/8OEuOC8simo4oh+sUbtnO+1sXfhom/oxaFIpMuT8H5g3qoSXgFYU0m0SvGr/mKD6fibiGpdII+6m/9kWtfbYF9FiCAPgYS2/L4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790844791; c=relaxed/simple;
	bh=GR+qrnrjIRtaBAzReHzZ8r2pxiuFtvxoilH6uNxhHvs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PM/Sx7qMuKzEiUI5RESyRkzcdzE7ar6gC6qYYsinDjxAgaFw1uzrJkY1Uu3CMk8RaiJsCI1FpXnnIc+G2mlev1C2sxt5Mx/8dtNW4azAqAKWTZ6Dh3qGablXtMWca5bd6jbESrZV8e/raOVKHXytdTI2b+NgleKVcTTDojSqSa4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=LXTr80Nm; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=KM3PXbj7; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="LXTr80Nm";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="KM3PXbj7"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69171FHY793656;
	Thu, 1 Oct 2026 03:53:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=tvFqDckfZT85PyrkHGhKkwSp03EnO9FSYviBJkcVe
	7A=; b=LXTr80NmoFQuQM7u7tupZIB1klGTIV/Md1iSl+sbeltonoL2FGgrH50KJ
	aur+IAbNh0NJ3zEgSjRb3VGecS7GST6bdSQUQQ5wQ5z70Bx0e/xAe+ENGb24taN/
	/AgdX2dfyWX+am2lhjIqKM33e4FlAyqLrTJpHY2KdUMzcTidij23NcQdz39m48FG
	S45u1AA7xSyy438lJ4/HbCWdNFrEio453+AWQzIQeQXhvTmiExvOyIpXPynMRmKF
	3FPW9ZQ8iVIBHsL15TYSBYLHalV98+WrB/nwu1kEf+XybH9tVlpIpaSPAFAAt7MP
	eDARVIuztfCt/cWtwGToTiNkd74yQ==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013032.outbound.protection.outlook.com [40.93.196.32])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4h17djv68a-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 01 Oct 2026 03:53:03 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xeRrLvHdlNYbXwFzLiCCK/8pHUTAtOiShVy2CNIVj/DmKZrG3lviIw9cSXAglNTW+/zYuOUsyhVITEmISdNrkQu+3kl/uRqPAvdEpxKk65KpdeSJaEUJxwbLgpmGqpETry7PyhJY/WWupWr0xzQztvfvKPJr+l1IE039S3xCLnsS/2kR5weD1xg9gHR+5TwjBcznw5wOgqDxgIkm4zx0JucCGtBUwqk2Mn2LzTSOGFg86YaBrAy0SdI+0YjtDqsATBABfCKz9hS/hDJJ7Z0sNwVVadjssvyeWOJk4NoC4BYDW06v9NLgT4kJb4uf+luk8YPTFqsZ4KJZWBB5fm3J3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tvFqDckfZT85PyrkHGhKkwSp03EnO9FSYviBJkcVe7A=;
 b=w4SNbcHoecR0JEPbjehIL+3VZwJI82TGeoe5E1srLp5MQCMrLNUaDeI0fEGDm/V6O1CDvrtzuvRMIObwq01uMw2mvkDqQceXM+aHT3t3E2zBjx3GWc1iLJIMhSLvDdd/ksBwthM1AcBvIQcEppDU9/3zDizJiAC2TH9mPpbxIyxeXtwYcnXyazlKB01IbVOStjS6Y73tsLEoBfZ2BxBVphUGAaf5llgTpgQpjPwAm2VgBAi7ZZgaHXRclqV+H8BUagcWkolGLFtLr/X54iNR/yumYofhqMc/ycz8sBp5Yt2Jqe88I1NZioZ5BhJ6POSpYPMPKEngoMeMd1zPVSNrIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tvFqDckfZT85PyrkHGhKkwSp03EnO9FSYviBJkcVe7A=;
 b=KM3PXbj7OiRl7xiiUcLW4k0jIywRknFhCLCC7rmTmKUWiyCsRJHkVHAXwmsQcUDEBf1Z8KTkNDkyHlMIomPcZIKXva8IrZLXnJyUcblgH9TXuJCGmDlusXZ0cCcSTV8VLPJplctNnCvBCeTPUJkUa1P3lFgqoscwOtvOHBuFJVk=
Received: from MN2PR20CA0041.namprd20.prod.outlook.com (2603:10b6:208:235::10)
 by IA1PR10MB6807.namprd10.prod.outlook.com (2603:10b6:208:429::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Thu, 1 Oct
 2026 08:53:01 +0000
Received: from BN1PEPF0001806E.namprd04.prod.outlook.com
 (2603:10b6:208:235:cafe::ad) by MN2PR20CA0041.outlook.office365.com
 (2603:10b6:208:235::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Thu, 1
 Oct 2026 08:53:01 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BN1PEPF0001806E.mail.protection.outlook.com (10.167.245.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Thu, 1 Oct 2026 08:52:59 +0000
Received: from DLEE208.ent.ti.com (157.170.170.97) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 1 Oct
 2026 03:52:57 -0500
Received: from DLEE206.ent.ti.com (157.170.170.90) by DLEE208.ent.ti.com
 (157.170.170.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 1 Oct
 2026 03:52:57 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE206.ent.ti.com
 (157.170.170.90) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 1 Oct 2026 03:52:57 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6918qtHo1594798;
	Thu, 1 Oct 2026 03:52:56 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 03/15] crypto: ti - Fix potential memory corruption on highmem pages
Date: Thu, 1 Oct 2026 14:22:33 +0530
Message-ID: <20261001085245.2922974-4-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261001085245.2922974-1-t-pratham@ti.com>
References: <20261001085245.2922974-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0001806E:EE_|IA1PR10MB6807:EE_
X-MS-Office365-Filtering-Correlation-Id: 596077e7-60d6-4671-cf40-08df1f996558
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|1800799024|376014|82310400026|10067099003|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	G2o77GA73UlX2SxG4p97LsFqnJjThVm3T8xT1rM9RrHLZPALrsWtjvAASQPaAl2ymrgcGw1mJq4ZMm/c7I7nbyNdhLHQZZ79kajf0b3QbVbtQc5FHCO6M4DmGFQFrBysTN++Cmt6hNg2IWqlzFC66xDj6zAMxe6UwtzWuuUjhJzCiDggi8NQuf0Nze/SpxKF7FNfzZC7AKKZkhq00j7yzpNjCXKPeNgyPKwCPL2xlnw+Dp7zgCbkDCH/GMRlOea8Lg1zpM0GPbFWlFZeLVBeG5UsBzk3KKeAlQVBz2FdYJ9sdVJl/rFucP1CEyzxML7jZe6BYznk28j317fm+KOblyybu3m0qP3jzUnzqrQF+Dls3z3Uk2Uxr7UqcyYHcv1qLo3qhlUEb+P5FH5FBsaG7e2f5BuQk61BnALCeN02v1LpKtTczc4bAaasN2HY47u9snNMUarMixIMi7Qm/92dEq716j/iqlg5ZsAIaqusSMuNy9B2IFWpAmfrIpQEx/d7PwA1ihMURHPbr5wboKnQeInAmBsf3pAOD3aVTXyqHkAcxy8QHvZqNA5OVV9zsxd5uqP4JV2+y9qhfiVdKdyodk1qVmaRKVw27M+W8bC0qIIr7hgAKfBwRR8D6qKkZQtr44yDZafFoNlz5F6esUCKQGoGvtkO71v2cAQ0V230lNykviUrwDYQApi7SVxHuEy2z4EYY2r/7kwyh+5ikD7iUg==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(1800799024)(376014)(82310400026)(10067099003)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kqnhgtPnSsi2onLmq0Isc9vrNnXCL+Nt2itWrYbvVtyjdiklFKRWz5+36b0GMepSVL1Qxd9Wya8fXt1WMgMpAKF5IDPZQ9fzC+qc4qufk608I2SHvqQqxP4xpYg9vt7uE5xdiIBssJrpUNzwhyojrJd443zf9Pyvs3faMkPdnwAd52ynF1HmLOkaQyFF3CNt0Ov6hy/L6yEZ2WytXdWAsx/GR+xXJsN46EpIPP+TIllBT+qyMPpt3bOWaE7AjoLImRfepS99W2Bl9BeAnnkib4zzLm2Pn2AzCxK9auIWz735uX5p5g0MS/SqlPnnLF7s2QZRX0Ne/1H4ZArvOk6ZO/al/hmanLLpF6SLF+bWdu6m9eN94dlGX76tmuPhvrnLtnb5leT2OeXvpWFCJXKHSygvFlFH5yaTgJfjqf4C5eqjCKNwQU4MFfGbaAz/j6pi
X-Exchange-RoutingPolicyChecked:
	aEsZ0e9wcTq3SciGhSYwXv6+25SBbbyQ8D8i3nhrVdbjbD7JtGfBhbbVFoVhHt9BZX0kjn5EbEMsrMqyJBEX86uU0t3hXs25EK7504L5EFzmoaSCvZiPDfpmbH3AYXmDgC/gRRKinKlPSpiXhU/LLicokE5CnobPQ/CAqp3ekMKOLFOzr9AX2coeXol5TAIBbwDli2aHM1Ojwx/IvVdd8TBThBoJFenHCArBNddskJFEXuXIBscY2PfT2Pg0SQLk7pNg8p/SpwQExfNNWTmpqh8u45ule0V/loLQfTBpB79FYoe94kJK01EijPq78lfk2r7oMPrTZHRuhwDU+MRXdQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 08:52:59.9449
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 596077e7-60d6-4671-cf40-08df1f996558
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0001806E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6807
X-Proofpoint-GUID: Z_2w6LU5178VXX0Xk9J2elAQod0GkR2Q
X-Authority-Analysis: v=2.4 cv=aswnmiZV c=1 sm=1 tr=0 ts=6abe1f70 cx=c_pps
 a=kXeBnfu3JcJF6EwF0J+eVg==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8 a=IXP722aH8NCvtdUuCEcA:9
X-Proofpoint-ORIG-GUID: Z_2w6LU5178VXX0Xk9J2elAQod0GkR2Q
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDAzNSBTYWx0ZWRfX1lJYQq1x7BCO
 i2YfCFfJHqsd8niqlzngA5jjq0ZwLMenOokgjqldtiiW/AL2gQmnbgmX26VaZnYbXwvmhg0corG
 EFwBI/XKhM71DO6lAVp6UZSAF025Kmw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDAzNSBTYWx0ZWRfXzGRLNWN0t4dF
 9GTxkBJc4apid02plslFX4B4nbGARao0YA4MOuxfgRWHbf3ZQeCNahjdAwx1jdZSHhvQzTqvxGp
 PP8xdZIx5v4Bjkaj+LaCeoyWq1Y71Q8RTI447M5xZtFj1KLIyHXdspz3O+nJiXh5Wqo9f4Ekhfz
 SVDojkQxY29crF524RjO4NGctwdaft6ayUQ59J9atvWLTX2vUWfdpJTW0Yu22QmnAmsGuktiTAl
 IJpBF3ShF8xjXHPY7UwDs/a5QqSQSRrY8HE3HM7XBLXTg2PYu0F6CiU7bt6aHQyQTJO4GTxPSWi
 Ad0/mNVd0vJXMZ/OLryfIpyMEYpuE0706WH0MPLSUo0Tq2adYWGuerjL5AKS2UKkVXtWcrQvjq/
 PLCTUKHRMibLNPGOO3Vh/famdYrcyo2E/gSPhmhwLZP6qrdTSsPkmpQuSMbp/q2RlykSe0rjAbF
 qtIfH5+QODiY3tIokHA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 suspectscore=0 phishscore=0 priorityscore=1501
 bulkscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610010035

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
index 8f8c4a93af616..ca8bab4950d28 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -49,7 +49,7 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
 
 struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
 				 struct scatterlist *src,
-				 int buflen)
+				 unsigned int buflen)
 {
 	struct scatterlist *from_sg, *to_sg;
 	int sglen;
@@ -58,7 +58,7 @@ struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
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

