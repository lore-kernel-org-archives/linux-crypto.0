Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5E04BA9F8;
	Thu, 10 Sep 2026 17:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789063073; cv=fail; b=cHTn1869ysYOl3QBkv2hB9JEjLVNwsOKbs7OQwa61qmAYWE1NlwYb9qg4fNYsuRO7TnR5NkmIwBHp+HGUtmzpNlE2Uw/R//PZ6MYyM5fM7j7TjdQcwc+/UadTwDDo+tOP7f6bVhGq9nxjkNrTBY1rtGR4K4i0vP37ZJNlkVqJiw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789063073; c=relaxed/simple;
	bh=MmcuVvXYaMjero/AwfUHOm7TRDKEXBVAlucY5yNCKhc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YPtJV3d8o7NfHvkM3oaX0n9Gg+n/ogdCkWYMiCZmYuX4awQn7RyZXLG2zDgIR2EzyCoC3TBmlftQ1iGBW1Ne3Akc5wQZzNbad/0DvhPwJml8ya+OqmlHGPHTMtEyRsVxMQFeK+w6xRQLKyxf3E7z8pJr7nq1Y43ODGhyCZVd4nU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=XHEM3YNZ; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=PK6/14Bk; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="XHEM3YNZ";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="PK6/14Bk"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68AGGAtK3546582;
	Thu, 10 Sep 2026 12:57:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=PqnJREAsaDSaK59bXYGlEMRqdohLFwctOvTZ9KWYh
	A0=; b=XHEM3YNZyIZ2r6QtdFWUMq0oYPgNffv1+bdDFaxdxvQjm0Vw5YwzyAB9b
	hsY6CcMLTKqIF2Viw+pckCT4Ys8BxB9rpTqVSeeS/qtagXJfwqwcK4gdfVq82Hap
	ZYNI13F0fVsJu/I5wOosGpFBBtDqJMhvvvORuRrCOb+EYbO4G0A4DZqz3y4PrL0O
	+M3hKIQdkJhzQSrrmjVCnlbbr9m+dPODaf3BZEWZc17kLpwD3rK9LzvRuBX2Bnjg
	wkvB/KeS+154T6GN3brVzl31jU877bLQABxak5vsgY/TCy3KgXK4FBvpjBf60xqS
	m0hA/UCYzcUOFecHGj3GzxHzr43kw==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012058.outbound.protection.outlook.com [40.107.209.58])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gkyx20n8k-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 12:57:45 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gxdVVr5b6298ENv3q0/X+GQnlvyUyq5Ku0H1FeCpnDBcNy2tLpKxrqnai95CMeu8Rz3eaNrqqFp9vW6qDLxesp0rnUOTnedlLEyclHH9czx4D3e7fPOg+UNLfW3nNu7cBsiaSGB0VuMBxErXR6BXx73oJk0EjDCv6WcUxTKv4MX5Cbo8WL5eunRdxP+IyWU3GCuURepmJOgJodFqgsWHsIPuEdn5ek3jUvw/hQFhvqRPKLf3gmfgkTHkfSgpPBx7KBAIVnv8GJYjPsxtVKfDF7G17j3DoPkvXiUWnXJ4+fjtEvvVVFMImAWHL1niArgO1+H/stg1CTb81XYCNxIcZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PqnJREAsaDSaK59bXYGlEMRqdohLFwctOvTZ9KWYhA0=;
 b=t26boSjvdJ5c4KzhRPccdDrGaPdYINn8SoMmjfGozqMilCN3IUzfK3Dl6VhLuvM+9VCktHDF7++801rmZCDhRsO810ko1/AJfGv1mABOLZaqShRmtsQih1x96fzIL4rcZZtaMpplNtM4Nr8MbwN81oWtxOTRsM6qfTz6V8OEig668WguJV0vpbkw40J0wZFbZ0oo9ojvRhpHXkSzyyObtQcUIx0kyqysTB0a+c/Yj3ptlhQDZ2EOjqtfp7T4cm1L8dNwGIT61DqpD6YwkY/4m0F9VB7VjIhUf2zz1Qj1RISz3/G/5ODmaSjhOjSiWMCDWF+jqUoP+LlObaZwDZ2LLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PqnJREAsaDSaK59bXYGlEMRqdohLFwctOvTZ9KWYhA0=;
 b=PK6/14Bkbh7oH/hYO+tDIlJ34Ag+11e+8GGIVEDiwtgJ9e0dqHdpx4q84UNqH+CxlzP/vXfuq/TOYwijOuVol00ZSyNoJSk+Au5X2bUQjCQsUaQgdb9yu0Gd+yrpg5+7VLFxByj14uwvPqLJflWPc/GChwh8au78ybXbLzp5IPM=
Received: from BN9PR03CA0385.namprd03.prod.outlook.com (2603:10b6:408:f7::30)
 by DS6PR10MB997848.namprd10.prod.outlook.com (2603:10b6:8:464::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.4; Thu, 10 Sep
 2026 17:57:42 +0000
Received: from BL6PEPF0002256F.namprd02.prod.outlook.com
 (2603:10b6:408:f7:cafe::74) by BN9PR03CA0385.outlook.office365.com
 (2603:10b6:408:f7::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.7 via Frontend Transport; Thu, 10
 Sep 2026 17:57:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 BL6PEPF0002256F.mail.protection.outlook.com (10.167.249.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 17:57:41 +0000
Received: from DLEE212.ent.ti.com (157.170.170.114) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 12:57:11 -0500
Received: from DLEE205.ent.ti.com (157.170.170.85) by DLEE212.ent.ti.com
 (157.170.170.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 12:57:11 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE205.ent.ti.com
 (157.170.170.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 10 Sep 2026 12:57:11 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68AHvAgA2794066;
	Thu, 10 Sep 2026 12:57:10 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 15/15] crypto: ti - Change lengths in AEAD to u64 to avoid potential overflows
Date: Thu, 10 Sep 2026 23:26:19 +0530
Message-ID: <20260910175619.2122149-16-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0002256F:EE_|DS6PR10MB997848:EE_
X-MS-Office365-Filtering-Correlation-Id: f9841fd7-a1bb-407d-c06d-08df0f6502b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|1800799024|23010399003|82310400026|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	7QPHN1XG16i60Q/whxn1Eo1CbFI0xQ9ZeWPWmm7IZ/QWMEUFxGHWUAuwNF3lv51kd0gyqA37CPqDHBImN70sgTDM2+uxmLyH/CQ/uEJ7eT34wB3xqxiGuMqbcBl1X/RWxR1okwzqzB3nobIVs380cVb/JId/zDHX6ui86QopYwMg62/aDUfdi78a/poid6j72oE8IppkpK38li63i+cfK8cbvWC7MEdt2Rg1zSyNfgX1c4JdWhP7AzGBDEginuxyaEtOJisbBi+AMHF6oVofA58iLT6zaFqhR8FSsczI38vvMtWgIHIqXpyyAmKnCecUq53gMjBwEpsetxrQDFowZRhKvSoRZDLheYvNpzyVv+9ZwlwtUW0rvWnDJtDlUyChRQVRpp8gVbngvDXWw+IUnb13BEGBe6D6ht3QpPTrnIb8Ifw3IUhknI2l9nI8QKjQrK32CsXgv8+YfLM9e8cIVPMxLb4jK+usmYK7v7KQUBbXRzGknYkf9MblUMESPy+07+xWY9AhR9oHLhgcKtr3+KxtKNOti1083xgd8k7saYgEThNo25yYTQfXXZ3PVhp4k3LcbaBRcjlCcO3mHUDOp1z0hyhxgKaoSJ0O2w+Ro69CjM0mydsv4g99mY3JTXAn7R8mUYHh1ZMiivGsVA8uWjLA9NuAfsKwIq5u3XQYNdpiyDhmo+TDRA8nAkW/CrWdKMtRRDmXWpQ+Mf7rEm8gNg==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(1800799024)(23010399003)(82310400026)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ngJiMqnx3svndHgSU42oXljhsADieOPJfUsfG3pNPmR9kqjAYj0alj5rc1D1+2iYtaMRcVcT7ctPyJPu1MeuPxBny0W5buV64XOKZLPa7+jE34lEbzpL30VD33YsagNSNG2UsBjemoD41VaWspYtjg3NguagQbWsbXKlG13/kT+BfD3vOmIBhsSRsDBemdQ74waXw3Pc3ofzGD1qbL6h9aG5HkOBhWbxI8pIbmGHJcOfY+FeP1L3ZY8m0fChsQgiET0t3WKJ+lFNRKk7toKVkMa67+Lsih5WSqe6Ap1GB2RSJXAEeTwGEevVZviAWjVDHwXOx4XDfj+AHcuLPouvZjjQ3LHF98TZYJifdTtjhSrsDg7W8cJsOdjXO+uCPjymPeRDW5DZGpE+u9ye1sxoLuBz8vYuCDO2Acr7DJE5lb4sxwzoYAUGZrSGtlbvjkTN
X-Exchange-RoutingPolicyChecked:
	RlLXQ32wYsjbmckMlkRSYiVO3085PsO3uxXwFTBNQ4iOIUaw4RUnmsBo4NbVS/MphUfhb5jfTxQDVWxWaxksHvl/e++s0APzPGnYkbRmx3fMrBmEK2pHogdbpASeTm/PXDwGbhF1/P9xQW/q+3s2m5zBJ4kWXanErzhHjYRQnEmX4F+Gz1OCLWnqMpdvQlpydD+4V7fUSqfoiG3Ls5lgWt8JYGxuYrzQQHLFTPQjrRSwWqHs5O+dNrAFEzjhUUOgEzqd1Fk1dfaetIx0Dkw0xOXgu/iRx5bpeS/H5ivhQckfUDvf5F20PnWUggidogy26AwAojzjvCp/5m05oxaQrg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 17:57:41.9970
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9841fd7-a1bb-407d-c06d-08df0f6502b1
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0002256F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR10MB997848
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDIyMCBTYWx0ZWRfX7wMzl0S7bS7z
 Ro1QoPm8zWWw1snGN4+i85+vbL3qTZ+T4CzHlx1kzY5HvesSOw3yc+Vpj1d/cWEFwmdg80fO+p8
 cOXdCg1QjiU2cGn30+YfE15iPps51n4=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDIyMCBTYWx0ZWRfXzjlX6OhHhklp
 GhJHq6JC7hf85qr+p2a3ccObfRaxJzlOP6fnlh7Q6nNf1gpDqVqIMpKeQ+17uH8zX25r9Hn1yIO
 d9h5wT6foyQ+AsmexZOv5OdRUvARC+2Ezlid8C40ke4Z36Njk9aQT70VMV8v5abpUahYJpfnHYM
 cyYuAyFDDj+eZkmcHqiUgqF2oLIhksCwXCj/E5SCRtliTDTtatEF8Cv3+0mPGx6HmrC+HFI1oRa
 aMeKGv9cxY2KP2ywnzGiQof0hQcj5B6+P1giDkrAn63uRBpq326MW+iIdKybMcLb8gRha0WaKU5
 +8MJuMQtTcz/vTLIB+9/Gfb7PMTCINqc21VQqSKg0WUtk6ynacRd/Z18FYg/LVHkqycnwRP/jG0
 rk89qpzq80yZcnkbLZNjti/jpLjWWpbYT2T6khUMrMvHAZzXz1ERcr2nQIgHpj+yXmRJSFMCWO2
 hQ21A3EGaNwjtiS0ANQ==
X-Proofpoint-ORIG-GUID: 7BfQNJZarHTH7Y5uLDGDh14yhYIK4G9A
X-Proofpoint-GUID: 7BfQNJZarHTH7Y5uLDGDh14yhYIK4G9A
X-Authority-Analysis: v=2.4 cv=UJ5Ijyfy c=1 sm=1 tr=0 ts=6aa2ef99 cx=c_pps
 a=dnat/ZFdcaejr8kp+uhwWQ==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8 a=W2mYDkbPwZfAYNH1kz8A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_05,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 suspectscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100220

Change assoclen, cryptlen, authsize from unsigned int to u64 to avoid
overflow when they are added (in TAG offset and padding length
calculation)

Fixes: 37b902c603042 ("crypto: ti - Add support for AES-GCM in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 9b982ca4a7730..ca87aacc39c5d 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -756,6 +756,9 @@ static int dthe_aead_enc_get_tag(struct aead_request *req)
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
 	u32 tag[AES_BLOCK_WORDS];
+	u64 assoclen = req->assoclen;
+	u64 cryptlen = req->cryptlen;
+	u64 authsize = ctx->authsize;
 	int nents;
 	int ret;
 
@@ -763,12 +766,12 @@ static int dthe_aead_enc_get_tag(struct aead_request *req)
 	if (ret)
 		return ret;
 
-	nents = sg_nents_for_len(req->dst, req->cryptlen + req->assoclen + ctx->authsize);
+	nents = sg_nents_for_len(req->dst, cryptlen + assoclen + authsize);
 	if (nents < 0)
 		return nents;
 
-	sg_pcopy_from_buffer(req->dst, nents, tag, ctx->authsize,
-			     req->assoclen + req->cryptlen);
+	sg_pcopy_from_buffer(req->dst, nents, tag, authsize,
+			     assoclen + cryptlen);
 
 	return 0;
 }
@@ -779,6 +782,9 @@ static int dthe_aead_dec_verify_tag(struct aead_request *req)
 	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
 	u32 tag_out[AES_BLOCK_WORDS];
 	u32 tag_in[AES_BLOCK_WORDS];
+	u64 assoclen = req->assoclen;
+	u64 cryptlen = req->cryptlen;
+	u64 authsize = ctx->authsize;
 	int nents;
 	int ret;
 
@@ -786,14 +792,14 @@ static int dthe_aead_dec_verify_tag(struct aead_request *req)
 	if (ret)
 		return ret;
 
-	nents = sg_nents_for_len(req->src, req->assoclen + req->cryptlen);
+	nents = sg_nents_for_len(req->src, assoclen + cryptlen);
 	if (nents < 0)
 		return nents;
 
-	sg_pcopy_to_buffer(req->src, nents, tag_in, ctx->authsize,
-			   req->assoclen + req->cryptlen - ctx->authsize);
+	sg_pcopy_to_buffer(req->src, nents, tag_in, authsize,
+			   assoclen + cryptlen - authsize);
 
-	if (crypto_memneq(tag_in, tag_out, ctx->authsize))
+	if (crypto_memneq(tag_in, tag_out, authsize))
 		return -EBADMSG;
 	else
 		return 0;
@@ -887,10 +893,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
 	struct dthe_data *dev_data = rctx->dev_data;
 
-	unsigned int cryptlen = req->cryptlen;
-	unsigned int assoclen = req->assoclen;
-	unsigned int authsize = ctx->authsize;
-	unsigned int unpadded_cryptlen;
+	u64 cryptlen = req->cryptlen;
+	u64 assoclen = req->assoclen;
+	u64 authsize = ctx->authsize;
+	u64 unpadded_cryptlen;
 	struct scatterlist *src = NULL;
 	struct scatterlist *dst = NULL;
 	struct scatterlist *aad_sg = NULL;
-- 
2.34.1

