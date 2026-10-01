Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9744AA591;
	Thu,  1 Oct 2026 08:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790844809; cv=fail; b=VXlq1sh6VMoUKnHe2x6YunlzDtY8OjRqnCiR93srzogmfrMwgky/yTqiWODhpSxcRxAWYNhfSc1jDtiGv1HJGL1J9n4IUNp1dxERuX3STt6+x18836Je3irOCaJoh8Ii5gfBZZHMzyYbFprmxY9IgJrG+J8MVOqf0is85HGU2SA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790844809; c=relaxed/simple;
	bh=xVSQS6p4jUtic3JSFUxPRRv00zrfweSXDgPsiIvTgNc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uql7pQa/5iG1lit+5blLt/uqnNm+hWOareLcMkqLnIO63UcZLmV/AS6P5Kc+r2vHlBI/ellfZT6LvBYHjnDZT8szGA4AChTdS+rblnUqYsJzJF8qTd7mJqdPwHs7jZ0E0g7RFSzWwmaXQYHZW9Oq2UGpnGxm8KnMVpyTYyT+1n8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=AY2iF829; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=aBN2n5rb; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="AY2iF829";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="aBN2n5rb"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6918F1kh1712712;
	Thu, 1 Oct 2026 03:53:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=801DxRBXzmhveIqwdJYn+q5sZVjlgAABeWzo5AvuP
	SE=; b=AY2iF8296v5c1hcPKTeMGOG50lBQz4nKld+QDOm5dATo3q+Ch0ReF5GYD
	c67mUbFbkq8Pew2G2hUg0rCiVBYKvLfj1N19EoIMFs5VbbAHpqJY/sUpi9WY56Xo
	cL9F5nWy1OYXvF+p+2gzXF5HWQVi7zo7VOTlD57p/v3QnVNGENqUNDN6F9b3JXe6
	S5r8Dh3vIuzgjBCDLtE563zDd49wvsKTHgmWIsBILD+Lv0CCTFibOqpFEb8TCK+B
	4VPiirlgc1yI80yq0XZ8DB4GQmwNlpGA2tB5Eoku+YMfJVu4EqbxWwPM9qh7pzJh
	kGR9IL1asJn3kXUjdzFltbFA/gM4Q==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012041.outbound.protection.outlook.com [52.101.48.41])
	by m0384305.ppops.net (PPS) with ESMTPS id 4h1kufr719-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 01 Oct 2026 03:53:24 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fEnfnjV9iVUDXeGKvFjCOeI73eDty+dU7H3SZWa//FEzcFwBx+Itvly9risqxWZ65/Ekwi7gzIrO73dP2kP6tGQS6T4WmeikUrIhUBfm5hjOGDXktLMGgODnX1DX02hqbcsiP2zOZZZucceCFYMbyvsOFVRGN1WWM8ITIhS5ETJKfEx8a63Ce022KAj+xbTkTQhB1d+p+FADmfrxcjpyEKatoB6gnQ46gqYM3xAIi7KbBMVeDAxnZHbkhN++VjpbvXumlKhuL2EX2l3zxL1XMdWNT6CDMpiG481S6bZ8g+ZA56VlIJ7m6gO5s1Q+D9GTVma91Bl6v7oCf0SAbhqCjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=801DxRBXzmhveIqwdJYn+q5sZVjlgAABeWzo5AvuPSE=;
 b=Upoov+dCJbJ9KVkgP/26f6GOMxRrJcDBBVB37RnxdbvxbFET+qvbMEBUbEnDUXrb4QBZHliAxtnRxH4KkqRpu7zBnl8GCjoZjWZgmM25t+WD9MH/i8rErBw7Lo1Q6hJXhc70Tt4Wl9hL5yV9r0ZZDLAsIUciFrLw0pDVH+Cu2LKBulTVrEv1fEfXGE94DV57hg8y65TvTlAV+rlJq701H3Z2Ap69Q6iWG9BIYlzQjbmqtOvfVIvon4aIYlkWcTv+8r+lASiUVt2BIl1UTaJljNIYL60UsC2LYbnWPPfTTYAFmjwV5kpPIyntHMrbs9qH/d2pt8zvZjwKpqlOgACKRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=801DxRBXzmhveIqwdJYn+q5sZVjlgAABeWzo5AvuPSE=;
 b=aBN2n5rbDNQwqQtaVNJIBb+8e2reKmSmt3jzzcwaTRmvdVeou5cxwkeya6X+mCPA6yf5CpWiG11ktZMcraeB3pYLA4RI2Lvj+z2/w7OepicduCniqJrk5UHZNvwCJ7GZFO+WiJb394NC3hl7xZKwSvtL4JQYum/V6PxmyEylUGs=
Received: from BN0PR04CA0059.namprd04.prod.outlook.com (2603:10b6:408:e8::34)
 by IA3PR10MB8163.namprd10.prod.outlook.com (2603:10b6:208:515::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.12; Thu, 1 Oct
 2026 08:53:20 +0000
Received: from BN1PEPF00018075.namprd04.prod.outlook.com
 (2603:10b6:408:e8:cafe::d) by BN0PR04CA0059.outlook.office365.com
 (2603:10b6:408:e8::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Thu, 1
 Oct 2026 08:53:20 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BN1PEPF00018075.mail.protection.outlook.com (10.167.245.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Thu, 1 Oct 2026 08:53:19 +0000
Received: from DLEE205.ent.ti.com (157.170.170.85) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 1 Oct
 2026 03:53:08 -0500
Received: from DLEE202.ent.ti.com (157.170.170.77) by DLEE205.ent.ti.com
 (157.170.170.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 1 Oct
 2026 03:53:08 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE202.ent.ti.com
 (157.170.170.77) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 1 Oct 2026 03:53:08 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6918r6xv648434;
	Thu, 1 Oct 2026 03:53:07 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 07/15] crypto: ti - Separate padding buffer for src and dst
Date: Thu, 1 Oct 2026 14:22:37 +0530
Message-ID: <20261001085245.2922974-8-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00018075:EE_|IA3PR10MB8163:EE_
X-MS-Office365-Filtering-Correlation-Id: e7bc6f7c-2f6a-496c-9109-08df1f997131
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|1800799024|36860700016|376014|22082099003|18002099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	b6apLGbGddFXQ6bF37soJp+NOl1g3GyFrGQ94jv6vtnO6RX9gt98/XXXNj2VIWkJOKyoo5A2bvRj1MAFZPEthAi6yAb2OBx3MlVfhySW8YJPt92SGXOJ45lZBR1z9nquwIxTQGIMVIwg+I88rmgXdrTIRRvwJqyZFps92BIuFySDX9MZOnWUQXq9yFM8SQTAK/UPjvUtd0Z6zGf3AuP6C36aaQUb5et0QxwMrQ7/P6PHxUZPW8GzalJSOtlykpUa/3znh66b+8um6ZLsOX/nlpjlcl/15DHdJuenbVAHa/DJyGpHGsxF1F08S/bi+8mFPW1K4rs9AaHUxdZAk+IUAodc1bTLIIJZx++nkVAx81wzdHg2B7M0M2A8mBRroz4BMG8+6APV49fOydxvHuCV9qV3PRaPIV+BzRNTYVrv6g/SZNo1IEv9301uczktojeZJnK4hVBQ62FiUkT0roNgf54aMcvIb+GTzLPR7pN4VAFNOwO4qg7YvmeZoNwLOXZADlP+YonOtVk8bRMh/LJ0JAZM4FYGE3wNmO2aOalZtegEsuQ0tqbEBna+OmxP1m+1a79U3otruULXJCs+eEAmsYVx14tUmGzCDHJMkwUjdETmvViGzNqnfqfkLubBa7f5tMJsvv0xq3FajEmIzwb7tcu2apBgK13BXk2B9MERVYVdWPLhAI/umHh8X7MO05XWO4Vy7wRjlEXG40fqJaA1ZA==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(1800799024)(36860700016)(376014)(22082099003)(18002099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mKIpEF1oW+PHi+RGuEhiHTdyE7Nhi0+swvKiydC4IBAAwhxiewEmVxJMqpXgOvlZBIjcD+0BqZT23KALrN0e/b5z9A1M/a4SLQ/ROoHf7DR0nICYHky15tZ+FOV6g3rqlI68pjMj4UaJfBCb0jdfMQieKp5zEY//71yD6oRL5fWsZmF3nPyS5qtpxMUHX3lcrpJPsG9aoLL1Kc0rBdMY6++C4TWO7I6aCPGFGxKzDG4wPufweGVASztoUQY4if1px2b1aGKrlh4sh2N9my0UGxgz8x7V8g1rleXrsv6xkO536dV2At3OIjBrVMFoDaEv+F4GhhGnKa0dILiuXSXCxwQElKb4HpOpRgjn/CaufLfpuXa4SD5bK4BGT9lSNci/02AYzAgyA82+gDFmWehpHzqLUKWfuix0XsUMJ+UEr4SfR0j6jdv2iHJduK7SZLan
X-Exchange-RoutingPolicyChecked:
	Z9YdZ3Pw2tjUgoaFggCzHcptJo2qH28VEbEcs5lGysBvAh+hq48Jiwct3BLWqB3ZWP3om0twxdYvfvLnI/9AcwrIvznnkBo3oH33yuRKSk95NDMjEJfDeGcu+HPxPkxEfbT7pci82QsxvE3ngniWvn9PGK+0wfVJ1gDGF/GtF9nx3gjbTJFkxU/3kHNvMwPGz6E7IzPBZ2wE9EFkeC8gQjvHUzUzHGajsxd5eDFN6jOKEZZxjyvYRfqbdDk1vduAlGGXqk9+smz8ksFf7nGxNxk1sRu/3dI4tcS116r5jMILadtyIyBWtFn0c/GpnPBbOMy1ywxoOjJZDlpNFaMDrw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 08:53:19.8300
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e7bc6f7c-2f6a-496c-9109-08df1f997131
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00018075.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8163
X-Proofpoint-ORIG-GUID: 7ELd3iV2jWoAGub4Wf9zrKyO41FhJeOE
X-Authority-Analysis: v=2.4 cv=I+Lw19gg c=1 sm=1 tr=0 ts=6abe1f84 cx=c_pps
 a=LPv6HZ59J3TLgKTE/qPS5w==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=cnFjqbEhF75hnMYoCLMA:9
X-Proofpoint-GUID: 7ELd3iV2jWoAGub4Wf9zrKyO41FhJeOE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDAzNSBTYWx0ZWRfX97RSTolG7B+W
 tmjgHA5/lvSx4URIORISkNay+B8MYv4lSrAqOcYllMGsXCGjUwI1l8iSEu7raVMUFe3RTCrACNf
 uJ8Wy4DNTWw4BF0czD1k4eGWbdYKjHTlcAeH6qaYfPEWhk+97ShNNCTw+thf3iHGpKFJlxV2vZi
 QqThoujsAGlnj3Lzc8Jrnj/GEF9gqe3Y56AmkiWZ50tF3Q3C01in5I1PSRFxGg2z3mh2VLWvYcm
 a/hztWz9o+ofzDFKd9/SzBCEhurWnIDFm88bK1k21DR4X3qfzyXZ6OzE0gC8FpAGP1K7cOARIul
 TdYZT48Xh3iiCKp8yXDcCVPxLmn5C1/ayg+76qncr0wiSFvCR60juZU82hM4TYu54mSbQ0wQfIV
 pH51apIfqDiVZWW4bHT2cPmOOg5g/acwZ+MSQbHTcHgYbbTyUTizqjIq3eda/mZGOeulu3pYdXT
 MPf+XkTeAyfXoVxHPpQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDAzNSBTYWx0ZWRfXwbHNCxhDJuBt
 n8Ak+dhttBQQ4n5P6qlAa19F+C0HqpmaXBGTDNe7hX6KO3cGZx1m0Qd5aHTscTPu1ounYZfFg85
 NG29FDO9e2Hpa+Cj/e4PVQYYuP0CZPg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 malwarescore=0 impostorscore=0 bulkscore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610010035

Separate the padding buffer, which is allocated in the req ctx, for src
and dst scatterlist to avoid any DMA mapping issues when not doing
inline operations. In such cases, the current code was mapping the same
padding buffer twice which might cause issues. Also move them into
differnt groups in __dma_from_device_group_begin/end() to separate the
cache lines for transports of different directions.

Fixes: 35645ca63caa1 ("crypto: ti - Add support for AES-CTR in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c    | 29 +++++++++++++++++++----------
 drivers/crypto/ti/dthev2-common.h | 14 ++++++++++----
 2 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 5be1bcaeee5ed..83d964e884086 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -338,6 +338,9 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	int src_mapped_nents;
 	int dst_mapped_nents;
 
+	u8 *src_padding = rctx->src_padding;
+	u8 *dst_padding = rctx->dst_padding;
+
 	bool diff_dst;
 	enum dma_data_direction src_dir, dst_dir;
 
@@ -388,8 +391,8 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	sg_init_table(src, src_nents);
 	sg = dthe_copy_sg(src, req->src, req->cryptlen);
 	if (pad_len > 0) {
-		memzero_explicit(rctx->padding, AES_BLOCK_SIZE);
-		sg_set_buf(sg, rctx->padding, pad_len);
+		memzero_explicit(src_padding, AES_BLOCK_SIZE);
+		sg_set_buf(sg, src_padding, pad_len);
 	}
 
 	if (diff_dst) {
@@ -401,8 +404,10 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 
 		sg_init_table(dst, dst_nents);
 		sg = dthe_copy_sg(dst, req->dst, req->cryptlen);
-		if (pad_len > 0)
-			sg_set_buf(sg, rctx->padding, pad_len);
+		if (pad_len > 0) {
+			memzero_explicit(dst_padding, AES_BLOCK_SIZE);
+			sg_set_buf(sg, dst_padding, pad_len);
+		}
 	} else {
 		dst = src;
 	}
@@ -491,8 +496,10 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	dma_unmap_sg(tx_dev, src, src_nents, src_dir);
 
 aes_map_src_err:
-	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE)
-		memzero_explicit(rctx->padding, AES_BLOCK_SIZE);
+	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE) {
+		memzero_explicit(rctx->src_padding, AES_BLOCK_SIZE);
+		memzero_explicit(rctx->dst_padding, AES_BLOCK_SIZE);
+	}
 	if (diff_dst)
 		kfree(dst);
 
@@ -880,9 +887,9 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	int src_mapped_nents = 0;
 	int dst_mapped_nents = 0;
 
-	u8 *src_assoc_padbuf = rctx->padding;
-	u8 *src_crypt_padbuf = rctx->padding + AES_BLOCK_SIZE;
-	u8 *dst_crypt_padbuf = rctx->padding + AES_BLOCK_SIZE;
+	u8 *src_assoc_padbuf = rctx->aad_padding;
+	u8 *src_crypt_padbuf = rctx->src_padding;
+	u8 *dst_crypt_padbuf = rctx->dst_padding;
 
 	bool diff_dst;
 	enum dma_data_direction aad_dir, src_dir, dst_dir;
@@ -1125,7 +1132,9 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		kfree(aad_sg);
 
 aead_prep_aad_err:
-	memzero_explicit(rctx->padding, 2 * AES_BLOCK_SIZE);
+	memzero_explicit(rctx->aad_padding, AES_BLOCK_SIZE);
+	memzero_explicit(rctx->src_padding, AES_BLOCK_SIZE);
+	memzero_explicit(rctx->dst_padding, AES_BLOCK_SIZE);
 
 	if (ret)
 		ret = dthe_aead_do_fallback(req);
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index e2600447f217a..f6e02f33ef106 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -109,15 +109,21 @@ struct dthe_tfm_ctx {
 /**
  * struct dthe_aes_req_ctx - AES engine req ctx struct
  * @enc: flag indicating encryption or decryption operation
- * @padding: padding buffer for handling unaligned data
+ * @src_padding: padding buffer for handling unaligned data in src
+ * @aad_padding: padding buffer for handling unaligned data in aad
+ * @dst_padding: padding buffer for handling unaligned data in dst
  * @aes_compl: Completion variable for use in manual completion in case of DMA callback failure
  * @dev_data: Device data struct pointer
  */
 struct dthe_aes_req_ctx {
 	int enc;
-	__dma_from_device_group_begin();
-	u8 padding[2 * AES_BLOCK_SIZE];
-	__dma_from_device_group_end();
+	__dma_from_device_group_begin(to_device);
+	u8 src_padding[AES_BLOCK_SIZE];
+	u8 aad_padding[AES_BLOCK_SIZE];
+	__dma_from_device_group_end(to_device);
+	__dma_from_device_group_begin(from_device);
+	u8 dst_padding[AES_BLOCK_SIZE];
+	__dma_from_device_group_end(from_device);
 	struct completion aes_compl;
 	struct dthe_data *dev_data;
 };
-- 
2.34.1

