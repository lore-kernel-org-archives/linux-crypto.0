Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5AD4E3238;
	Fri, 18 Sep 2026 10:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789727023; cv=fail; b=JJRrw0050KK+aOCJDcDEo9kKbEinIm9fRqjVlH74PdLh01oIT1hR2u4T5EaCvB2pBOiupOISVBxC1akFJFYMFp+K0RWzLgV9rFhqDDHCcDQweXOSsxKELuSPKdMqQEZdekzz+FXbciXwkh51Ori0igpUzH133DqsGdbYcLbm9Q0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789727023; c=relaxed/simple;
	bh=xb+vL0JDbiPKN7Wt2F5InRrdoz1YYUcDoCoOu4uU4Hg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hc9LRdBHVR+N2E1fMFQNRhXhmtFxt0GsETHUnLqVkw2Oln/ZyKl1mZGk0Momc5PtAj1yvHPRijZaVd9hPikf/uLpa0c0FDwUt4bV9mNr/44o5KitPXlmv4BZa8aYLzy46ylwt3EXHv21jyiMHXdRwkK3dnFnjYty11KfWEgA9MU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=ZtOU8dJX; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=tPW37S1M; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="ZtOU8dJX";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="tPW37S1M"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68I9dCgp033226;
	Fri, 18 Sep 2026 05:23:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=9AAog4xG5I3fqrRUyrRYVntKwYPVthg9NlLstka6J
	8o=; b=ZtOU8dJXcMbzedWshgQ2fCjBU8SCZeZGvFYJMegTgkJVmPwnX6KBHLRao
	KT/VryVp2WcoBZWC4MVfW8U9occzIylt3z83mcIHRPQocvg3Vu0z5Dq9+bL5KPB+
	g2YWSD0iWZnLT5JcS0cv7WkwOjgf9bzzAYaWwHbvXKMxJUA1iNZ8ia/cg8x4nk3d
	nq7yIslG4M/I2dkq8zaDv4kZuVexTtFTFhaDFliwgv1317E2BmWfSkPzstZGdE27
	USPJGRsbFP0hMlU4zFbQC3jKeIXIl2NdTyuVCI18Bl419+ZBWQyIELCW/b2yqL+i
	LdGWVT8HCUgakoOuDlEQZ+q1qhfZA==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012013.outbound.protection.outlook.com [40.107.209.13])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gs0k3912g-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 05:23:39 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sMEuXxCPtss6uCRVlLjNlRI0lwiN+Wr3NsO/y/we3D4+F5YT/sbeMIyMxZo3DFY6L62mUDk5G8OQMmsUNrkz9lWcwqZTP4yBOka9hpti8w2kkYB7QHfruupABd5J5QR+/7V54iY5semfAbidZ0foo8kHGdnhdhoe3WO3qxoo4ue/UfadAxKoLrJ+Inh9A12eoExINPfbB+Ew+rq4DCFj1fAXDl0+6UvtpiCAZMnWCbu8+WAq2JIVnX6aOntcCcF9asXmu36Br5z7WdGYu6dAMD86wYl7dZ8KEWhrM7HO9jLid4nEgw9cdiTACPdyXEGMNFuXLKeuiBp/5XiQkECbxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9AAog4xG5I3fqrRUyrRYVntKwYPVthg9NlLstka6J8o=;
 b=GY3m4ePsxAeCFOO7riDt8V8Aa2u1nrUlmtqly5Ze1W4U2f5PS8iQcErJ7xGeJxzNDHO6zZ45/URzo5fOS5xuHkCInfumv+mz2kPiGhEjZhsrIeLA3Zdl6CV5+jwBqhrKJutKZxRem6f6kGyO/liO1UTSNnKRgYs6wPcZBf8X5Lv8sXH6G68V2n7vX/lw4bZlkJNGiNygOvxrua+Lp2+U7Sezz+unwBbI1lIUNprCtaxNzfFzmWzZ5PAa0GeOMpYVWXb5gOBAIwc0ugoMpW57+vTl4+rRmOsIfE3teeEM9w8E2Oe2zNwfplVZwYgT0zDr6M7i7rIY5iemnLMnyCl9sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9AAog4xG5I3fqrRUyrRYVntKwYPVthg9NlLstka6J8o=;
 b=tPW37S1MCHKiL+u66Hm5r8I90UUwN9a26NzPm9VmXWt6J7okcn/X920mdbmdRu5ULiVG5v10KtQ4UGAQUWaIPbcVSl5enH38xAH32Cn1vGTKRzBM2NxnuBI+bQDS9ORzWEBW86EGk/0yDVMLXLoz3JuyZhJBmzB51M5io4DnwIU=
Received: from BN0PR04CA0063.namprd04.prod.outlook.com (2603:10b6:408:ea::8)
 by CH0PR10MB4938.namprd10.prod.outlook.com (2603:10b6:610:c4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.5; Fri, 18 Sep
 2026 10:23:36 +0000
Received: from BL6PEPF0002256E.namprd02.prod.outlook.com
 (2603:10b6:408:ea:cafe::a0) by BN0PR04CA0063.outlook.office365.com
 (2603:10b6:408:ea::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.13 via Frontend Transport; Fri,
 18 Sep 2026 10:23:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BL6PEPF0002256E.mail.protection.outlook.com (10.167.249.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Fri, 18 Sep 2026 10:23:35 +0000
Received: from DLEE211.ent.ti.com (157.170.170.113) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:23:11 -0500
Received: from DLEE204.ent.ti.com (157.170.170.84) by DLEE211.ent.ti.com
 (157.170.170.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:23:11 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE204.ent.ti.com
 (157.170.170.84) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 18 Sep 2026 05:23:11 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68IANAun600392;
	Fri, 18 Sep 2026 05:23:11 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 06/15] crypto: ti - Align buffers to cacheline for DMA
Date: Fri, 18 Sep 2026 15:52:36 +0530
Message-ID: <20260918102245.2784000-7-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0002256E:EE_|CH0PR10MB4938:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dbd496b-070e-40ba-8526-08df156ee58f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|23010399003|376014|82310400026|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	GR8GfIWfDy1PNZyt/SWhdzqeNaBeTZ8pVdKE2FdHY1yxzpz14eKLCVqoEKtGMeScVxQZtkL1dXtCaG60BT5c5gV+94mX2uHZimzNoh+NuJACA/m5Zy6D/Pi3G7abETyM5+tTAxHEnB22r+GzHvCfCCL4VTs9K5Wt+lCVMaFbhlGero6HDbMPb2Ipk8O+b0ko3+aixpDJPsV2Eg7vAGxSjnsa4VDoGG+q1+ds14IxtKKmjKyQIt6XaiCO9uc6UVvywwfGVCwUWl1mrek7afbVuyc0RWPCl9CpZjSaqepPuIsAigYCPf7tv3o/4IGptIPWcYVao87mtMJ45KhPkQcpjS3E2rHsF/a78UfaC6oStHQx06dPatSWWSUJ7/2H5N35oJ6K0LPKYwwrh4/qMj8EwwNUxDjzXphsxyj2NbKeU5n10WGXesCYxMvEBg+DSUBn/glTVhc2JZQ66k2dmVITM5rCumI4NZEQepFbtc721Dbfd2Lu7HAcbgPUwIeL09J9A2KgDApfR0u5JoyYhGtBvuaJLdwpCDp4D4NZFzen7ljgxZGgxkVKzyuxxtx95XlH+Cd/Uhyf/zbaARmFUE3TCV6jOnIKurvY//c9vl3cKsPbfBDW7QhwktlB+L9Evs2EJJHTITnwCn4yXU7wuA3trqiuZWKiqFnmn2V9Enrmn0Mry4bwIDUrL3TF5S0ERoDG
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(23010399003)(376014)(82310400026)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	az9UGFqzT2Ql+XrtJyGQh9GX58PR0hez7Up+yNUuwkOnWzCvFk9Ga6NqSx7cYr+jfCW8/CzrjwDhdakk7VDP2x/HaXcxvXtoS+l9vpQvRV//weP1hL7QUlS5tufmP40I0l8xqs6UuGcCgX2alX/2DU/4tj6jGWiREEsF+2XCfiZ65FOqZoDi6+fCgOSXa+uB77QKFLcboZnrI47YQspYLw5EwN/0wPB/6+KelEjCaOKEg8GmNFhi6qfb8rEdaenMH2yq9GRJM5GmPIbzvFBngA2hL6ugaEiinCM3XpmLaaoEMGOSxnSZzabwP1W/N5bLFAi1gI4OJTI7GTY9Z1i8d/bYXJFZ/GEbNtali3NdaV5Qun+eHK2ewdY8TxFPGPfqzQ0i1ecubaLKGjHiIsU80Ns0vKjgTeeIkWg/1Xe9Frr5lyE7BwVFbmdE7d8tzzUW
X-Exchange-RoutingPolicyChecked:
	byRXBcvhhdwWAM0GWbMpXwgGLZtMm9o0IQdRxBIDGClYHoyXyzUV6R1FLjce2oFHdneq2382qhhFQHU5O2JY2/BWvQSo2rNv0nboabkrbX942GNFRjFKoj+gIqTT3SUfA0OoqVt3LQWQUEq5S5hVz0MiOnViFNkrtIjWH0FaCg9LIh7ZtG0hLwcPNJf8Q0jIziVnvZ5+fOvGfn2R3pULHAcCUpZ1dhHega12WwPCqRrdwG59AncahIOj7zWoyzmvZ8Lr53fSSlz4eYF7I6a5hzCA9B1DKNGSBZsfyqgw76wDn9Bf0qxLFMCX3BVPV+k8SgvGgemQ7dfy48RFzBwsxQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 10:23:35.0582
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dbd496b-070e-40ba-8526-08df156ee58f
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0002256E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4938
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfX0IfJ7EQdeNl1
 GSFRE0ymt1A0JUXYl9OHp2QvT0/ptkGjxnnYsBD9n48gYAF5Yg4N4VYQbjH1yCf4NN2Sq9CgjUx
 KdU2ZmBYhIlPmuD/LCsA5Z6jupWlSnY=
X-Authority-Analysis: v=2.4 cv=K6S3jCWI c=1 sm=1 tr=0 ts=6aad112b cx=c_pps
 a=XYUUcOYeOu1iXYjTrsocvA==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8 a=8TpikKgA1nL99BGwQjsA:9
 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfX2wMX0c/bfVb2
 2vInhY/+UmI/x5h8NJsNrWiTO6+WMvJqna5zv8XDBnDpSYAgc8EMuOysmE/gOrkQ95YFgmjnsjt
 SeUDdmK17mz0SnHwiKZC+V/jyIGjhuhEtRJmCQbp+ADnp8bKnzem8K4XKd0OWoYd4X/3CX64ugw
 B4QPJymUwxShcrUZqZqpbsCKqmQdkbyOTrH3JkC8K/nPr9eYopg3Oz/JLMUX26lCrA2dY/jziwt
 cvl3HYpKihkIwyRRqbOzgrDAEr058+UtSrB1K1W3qYQ2ZK8u6GdVjMpDfI/ZlWUwXOUOIdQXaHA
 5LQAEh6Kk6+TscP+uzNZtjiDPdT0kP1SU6wjMNr3HSz3eGQe8Fd4UX/QupvJDWInkMVjhVylY8o
 v3lYba55UG+kSk9x8SAwN3vTrrY4hgTXu1GLJV9dDBWdSm40lY4Xj+U+hlnxiVx3OHEyEJJb6sa
 rS0V1PsacF6cVYKmf6Q==
X-Proofpoint-GUID: SAeUOh7HgEd-KihydcDgLYgTip5R6aYi
X-Proofpoint-ORIG-GUID: SAeUOh7HgEd-KihydcDgLYgTip5R6aYi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 phishscore=0 clxscore=1015 spamscore=0 impostorscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609180144

Align padding buffer which are DMA mapped to cache line to avoid any
potential cache coherence problem.

Fixes: 35645ca63caa1 ("crypto: ti - Add support for AES-CTR in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-common.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index a827817e8119a..cfb50255a5dce 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -114,7 +114,9 @@ struct dthe_tfm_ctx {
  */
 struct dthe_aes_req_ctx {
 	int enc;
+	__dma_from_device_group_begin();
 	u8 padding[2 * AES_BLOCK_SIZE];
+	__dma_from_device_group_end();
 	struct completion aes_compl;
 	struct dthe_data *dev_data;
 };
-- 
2.34.1

