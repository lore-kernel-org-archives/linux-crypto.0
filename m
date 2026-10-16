Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDBC4A4F1C;
	Fri, 16 Oct 2026 12:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154775; cv=fail; b=S0FDafrPAxRA9xbE6Px8byaZoLcGelyyNyOz9eI/INP9MJ9WDaYflBbsa6RCZgmhyMi+P3E15Y9amBVKhYEQ1wluKyLnImWnciQT3Ti4StzB7IdB7c95Ax5A7/yDwIl04jI1/p08pGgSceyUvr63VisNgv4h7SBYtdBUin3jvjo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154775; c=relaxed/simple;
	bh=krPhkZUy/lYMIa2GzJ+rUFawyJFH2xWoZZ9AkkuM+M8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p428RY8CQ6WS7WpTB9IYGUfrXuULDQDWpU8VS0QPl/GWDMExwVBpqfwBPBvVvVV8YiKgOAg9aOzZ99WSEoXGbe3PMM8sV+Nu2Cw0+PmFA3vOVmsTnyMf1lFN6KMDtjlUoUne6Mlx8zDeDydz3u8EQ7eggVFk4Uabt/kpJqPyMwc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=TJFGxqGR; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=V7YIoc4z; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="TJFGxqGR";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="V7YIoc4z"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 69GAChU03703809;
	Fri, 16 Oct 2026 07:46:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=NUlfrUMQ2lKjrS0XdcJrf5fmWf74rYC27gyny+W2H
	V8=; b=TJFGxqGRB5mHgAf4I7uCCjh+boGTuKo7QAmpNKeZbE41/CZYxCQxTRM+Q
	GjXqvrNGVIWLhToB4A5KzMZEHB59Lf8TFfGE6OnhhGX/21GLD9mfss4RIcNfvG8n
	mi4m6MK05qzMasjH55Tf9YFKuJQxZR22jTZ0+2nWsv0QOVlZQay94OX2aA71XMHg
	F4IL7n1aA8fQg72HFRxpJI+REaCecxrjiZQ8fv46pjvjUFlewOibR7D/HAT0QKe+
	WnuFWT8HTzf1OmcBz+7Rd1wOd3JxWMOZKJPsVkLL3S2JvvzanmPDMtYhM6mVI32v
	3r65Z5P1Oo1zuyyXFw97t+sroN/ig==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012049.outbound.protection.outlook.com [40.93.195.49])
	by m0384305.ppops.net (PPS) with ESMTPS id 4hbhbg8t87-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 07:46:08 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aJPxnTRgCvz2rxiyM4xNS8Ujw9Y7KII5WwKihGQPMLkS9SybEv/yJMaScS0FJtSqaeaDGpVE3QQO7TxlTl1Yn1yaYEPvfkGiTae8ZF8b7fpNQYAZCbSnoUYSXZ+YrcT48fVzlBypYqNsQttNiEr8GMF5bbTnd7qXaUXKxbOQFjIHS62iDBS+0U35L5v+nHquU0tdHDLrZLrbWHkynBYc0JkXsY29dMXJJkaWDZ2f/g8V/sT6hJgTTnPLWNE1XZ1eXqpHaixsQ4Z6phFNfm28bwtu5XJZVoCkFb4sb7S/0vvQpZbZFZEvMEOxBVdOWpFuWhQ6b3lw8xDd6lfkkbVq0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NUlfrUMQ2lKjrS0XdcJrf5fmWf74rYC27gyny+W2HV8=;
 b=w5pkPDOpEW04aMszxwEAGRsQiFgaXy9PP0+UnEFDRqoRVejbzVdyRb2Uh56lIyvy5Z7/5icBCzvtdj6LBBGddm8QwzrvT+YFoBM20uE7tCChWgR6H1Zp6b0klUD6H+ac9sgQf6r/Vh8HeImsuqCcTm2nE5C+fcC9N/RZK1gFuL//QY7lkqWMp+mF4rayaCzd4z0gKE5n4HVHMP37W5ghDfdUfC3oETqJhR2kKrKlvGCXK3KzG0Dl+MBsxF7mV3TeH0bVGMRfNOWP8PMNSszVymCpsKoai0k24ymMn5XVgi31vB7Rmgn9EH+dutXEzNT5LpMWOFGFp1o3AT7uVJbmQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NUlfrUMQ2lKjrS0XdcJrf5fmWf74rYC27gyny+W2HV8=;
 b=V7YIoc4ziQ+DvbGxrGSNECKHzfMU4A7VH/kRrP9PP+U4ef+GbhT01pS7d41P2me7bTQI9M8FImyiW9iUr7a3LaUCwZ8N/whBREQGNIkIXJrM5T6koNG2FoXTQnnfArxwn7HEM6lCNWCe+W7qFrNnYk3nR24x2V65uqvhdqq3Msc=
Received: from CH0PR13CA0037.namprd13.prod.outlook.com (2603:10b6:610:b2::12)
 by PH0PR10MB997640.namprd10.prod.outlook.com (2603:10b6:510:386::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.10; Fri, 16 Oct
 2026 12:46:04 +0000
Received: from BL02EPF0002992C.namprd02.prod.outlook.com
 (2603:10b6:610:b2:cafe::3) by CH0PR13CA0037.outlook.office365.com
 (2603:10b6:610:b2::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Fri, 16
 Oct 2026 12:46:03 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BL02EPF0002992C.mail.protection.outlook.com (10.167.249.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 12:46:02 +0000
Received: from DLEE215.ent.ti.com (157.170.170.118) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 07:45:34 -0500
Received: from DLEE212.ent.ti.com (157.170.170.114) by DLEE215.ent.ti.com
 (157.170.170.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 07:45:34 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE212.ent.ti.com
 (157.170.170.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 16 Oct 2026 07:45:34 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 69GCjX9X2531513;
	Fri, 16 Oct 2026 07:45:33 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v10 07/15] crypto: ti - Separate padding buffer for src and dst
Date: Fri, 16 Oct 2026 18:14:48 +0530
Message-ID: <20261016124456.1802080-8-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016124456.1802080-1-t-pratham@ti.com>
References: <20261016124456.1802080-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992C:EE_|PH0PR10MB997640:EE_
X-MS-Office365-Filtering-Correlation-Id: c244d176-6b8c-421a-ab81-08df2b836fd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|23010399003|36860700016|1800799024|10067099003|22082099003|18002099003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	jcVxrGHetv+OegSGQrteI9xX/89aseUfXPiReKRqeIxaf7UTNBZEXbvl2yuScIOR7VUceVuCyroK+JIW4IaetlTSfJffmqNBPncfdku6jHs1r18xIElFNQzDAVj4Te5UNpNaETWs/azRBs07VRBQ0PXkLMNmsrwVZ4djzq38Uij2lkfrb4qTy8wEx0QSzUPIGZYPxtjrtPj6XAUfpptXLCSJfT5tvzHC7J/MQo0349dCuEj2z2h87XFz+rP41Dq7QHCI8/0+FJ/+TTbcF0P0/eXxaqmH+yo1rpImF3ZM/K+ISr4G6ahigdjAtMEpYJQfQPFF0HKZphq8pnKmy8YYftQUgz+t2s0/bnJKKPn5Z2qYA288HnjBqhq9IV7cEuip6hXbhhT0JXS2Z/9uKOOnjfwPJqV+HYiagekt416MkrpOXn5IWqQNTmeusGfWXg49cqODABqV0F1DC4mijmI2UwPoYupKFiqVYK1Am9zm/gLgw1BKHLgrTUqA7nCpe9Zy74XbYxpglbGU9oGbVWTCp9dfXAw44/4+Za166GKrVf6Uq0/D0QEP4e+mf4ewdDm7UxS+nHcehn1fIn0t5pcZnZNkzq1C70JLpwG4M91AGB3gaBUVqsAb75V3DvfGdHWQpeqtn5Baa1GOH7gEKNn3w9lVM+ikWiarXntK9LIKn9M8HIjWKHGb7FDW8xeaeFMvrIZxFZhE4m/VdhV2MQCASQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(23010399003)(36860700016)(1800799024)(10067099003)(22082099003)(18002099003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	t4ennGEmI7atxLiwEwOYFX09B5ppcNIDzf1oW8FIKAmmxA1o9DU0LPl5Tp7iUVIkmyiLkSsL6Uv1cz1xpE2sibMfxmC14sTlKCIwrrXMvp7+eS5CoSvjyDiJJLidawhGzeWfWJX+C/q6SPCMgBrRwqYtujgRCCFqT04xdpqoXLvTnZRzVUMnD9WOOHc8n0uHWvfyURjjNQ44/H3Ksp9NTVW01hiHEh4Yp06EehoamZynoLdNbkCqPe18oLqeDJ6+Bzt9JvrvG5oxz4o3AKDKmOi9m4E3S1uocAwayAfhgh8LOdRa8J14+f0jh5UKKlWTwzvOhLKBTstFTPObK0jqbG7c3s3F9LCydhrtS4baPw5NsRuOWKAkbFQ+sYlN/dx0vf5UD2y41Q14lymhPlwx5xBS+EMmAlfRvlQ/Q1pKdIDAfpA3pslreUjzBuMpQrtv
X-Exchange-RoutingPolicyChecked:
	mEf1WYazU2sipSG9cbzAOvX04+xypZoqSQ13h3Acc/DxGa1k1iqmW+YlktBuryr0ji8RoHKAwOy6uWBY1N09nNR21Lnpn+wos7R0dtDovZ3eRvSJCDtuQCgq2K4PqDtIordnX8zkGKqpjaq066YRpObGIT788ODGrmx7D0dIMLtA+XI7cApZwVL15EW/QFkodFki053PYij/mnJeOJ04zn9J0/qHwI4EminRyyGkp8rXkGAIlkqts/Qnt3/JOXoT1a4ITXu6xZHvtvD1gztjBk45VRKZE7+AKxOq09/S4tPoIxGXSlAANBBltKc9Jwa5orhYgLuBQjCGf52W/Ahcnw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 12:46:02.6017
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c244d176-6b8c-421a-ab81-08df2b836fd9
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB997640
X-Proofpoint-GUID: id6MqzyUlRLdUpKec1iNy9voccboYV05
X-Authority-Analysis: v=2.4 cv=BuoIUoX5 c=1 sm=1 tr=0 ts=6ad21c90 cx=c_pps
 a=nvwb1BjkeYK3HDx+lqLWkw==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=cnFjqbEhF75hnMYoCLMA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA1MCBTYWx0ZWRfX5lGU3wsNZQ4R
 GdMyyiX/wzbYfOOyzpedQTe3S6tVKpEjt6mIZfVO0aiykQU1QLBYuwWvq7S7d8nR06/tvwjuC2v
 NzqWz3r0/5sp3a8ja8jeKNsr3kFijifNy21Dl8Mel2jvc3elUifzVb6uh33Om5pTRZbMwQ3yLEz
 jritGH4lMfZ4rjl8t1e1aeKkT6kfR1TGWnSGvY9IJag5tuyqoSVMBKw/a6YnAb80OlaM3GhISJM
 sWtGrf2IBpdkB1ylqmL1MN2LRGy+YDviuN0devRtek+16PKyNP52BLP3ZRwedv4g1xjThY6dtPg
 ojbEJfEmnb6gYAcqs2XfLPP/66roofBL0YBB3UhplzlymlFKqKbsQAK6yQPQ3A+S58YIQOwt8EL
 LRWkzmjs2ukrKj0GYzLl7dyoEfWiWTh44cTM0iVy3wXIKsmnSKANE8eO/Km/A9xJWHVHmF5Ryuc
 g6ydMc3OmMmRx8fDSyg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA1MCBTYWx0ZWRfXxKnETMlZu4HI
 540DEwejhUuteszrifr+enTtEXYCoNM+w9Y22mpZKutjIFSkkJe4yYkSgzlf60zVG0UvaF19N6o
 4VoWIWjsEkgd8pIjtmUvQ/2KQxUZuOY=
X-Proofpoint-ORIG-GUID: id6MqzyUlRLdUpKec1iNy9voccboYV05
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160050

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
index cc20538ad6f36..f1b0396b322a0 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -108,15 +108,21 @@ struct dthe_tfm_ctx {
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

