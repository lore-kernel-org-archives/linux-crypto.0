Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB1C4E1C80;
	Wed, 30 Sep 2026 12:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790773208; cv=fail; b=Hty2p2ys02o7bhqQJx39enjX2/PKlINHuMV5wVuqdal8H5YlzhxP3BQAIECI+EnbSd7xL645Q25l7lfJR+JXQl7Lfids3lfBXhBmsaMMM3e1f6CN8/z8NvbL9GA7IffHnjyZ6Y/mJhr+b1U4AqQzug6fXGQloONRd/sm7gDz2s0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790773208; c=relaxed/simple;
	bh=9zpPK8JkgMlsnxK+gQdFmYtBkD8G/NRGvYjIz4N1AWU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L+rCAJ9DTqIwiJRSWb5KNXIwEMiYHu1LdMxFiUCskwUdnhpvbglCUBnXhnslAyTO+w28T4TqQOTg11wVJprwShqp+jAGeAr872kVDx5b3bE89lxIiVeJcUarZ+cUUP+S4PYT0R+2nmyR06BIWid9qgIUJb9ysWSTWO6KnsccGtY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=O3Srbk/V; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=CSX70BM3; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="O3Srbk/V";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="CSX70BM3"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68UB5oXR3552643;
	Wed, 30 Sep 2026 07:59:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=/TDA0JrN8gBVawxNVuij8vd/VXEfeszXyCvjant7B
	9A=; b=O3Srbk/VeKoHpUUmRHpcNzdMIj6tvd5jmXIbAwe0NJpcLuJX0FT8vTcMq
	k9cxG4aLO8fWkdxvqkiEkXgZjyEfJL7cAiY2MUDtp9gmYFZL/6haVoXriUyvl8Iq
	IVYQ7m6VlHqX6PAC+q03tWr2XqNhzrcElvcTi4D+8fz3IPQ7tv7hmyCYAm5CSpxR
	I8POkrXqbhZOyM8JtrCR5IWVw1J7FVmuuQT5IADU5qPFmPeJldfns3PDXce9nzNi
	QtllMnpkh25tjxx3i3nsbUtfn8PfIFXJRDakixKKlFr6euX32tpK9ahPeLzUBUxS
	Ees+Gt+8TA+9zImFv3elClgxLT9Mg==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013000.outbound.protection.outlook.com [40.93.196.0])
	by m0384305.ppops.net (PPS) with ESMTPS id 4h10s20qq4-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 07:59:48 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B7HLyokkfgTPoBPK83RaHG/L1TlmovLjJNx49lVlsw9XyjlGdDdHXqVMC9kUkPq+6nkdy1mSgjjCAlvujYdIWwTDWE8D1RcI6OUt2Xu1oOsS4ki37ihuXOKMTbFvFy9x8/iLq1fMsFVs9tOFQsMTEVSuhQJf6GTwVgYMwqBaq9zjcknQ+GvPxwEfYYV92xSgq9/QOQ+dr9HiFjqR56hHhJCJPBIR30Zs2MBDoMaJzXNLTjQqi5WNdNS7NzaIusLQFfO8yISWYxHtuCDpRLyELKywvF5KZ6n3B2A0xDjuCbcPQsSiHRWwqR20K4gPJmwshfmekfHbHUsWFHQWi4XKlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/TDA0JrN8gBVawxNVuij8vd/VXEfeszXyCvjant7B9A=;
 b=HNuXAhKHaZivhS/qhI5HE64ZScL3r1He7nQTCNZSXyakb0tf2WhQmu/rwCpqHzXKp6NNboO4HnwholsMnbPS+6fu4vDSqeZFibNmoIy6wG1/mGwOesXLcteos1vloiYREXvhrtnvI4upIQt93FYoCSb403bDXqBCraV8QYbht0gzOL15bhmO1anw+k+IR5EZ3aKTxSBJG5JL2blqBnXtILvhIy19AG0AkE6sNuFWchcikRp6XHYGxG7NMdti9LJ3YqodaSguZHC25Ah5EyNivyJrTw5yJgfOD+VdyPaP367yl6z66Tiq0fb+m57ebT9yk7k5AVtBAC7eP+18nclDRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/TDA0JrN8gBVawxNVuij8vd/VXEfeszXyCvjant7B9A=;
 b=CSX70BM3KH4Rd/kmfkIEAq+XChqb3gAr2Q1v3slqokWt4d2vgixlkDrKQsBkTdu29BZAgSqUGcYbTM2hemHvtUqdg6aq3vOQKXSjTyMTSIvG6Tx0vWJ+KNi6FHue1HDzwxt+02yu8BSLAsg5yHi6a+9FNn3MmCASm7tyMJCUucU=
Received: from BN9PR03CA0154.namprd03.prod.outlook.com (2603:10b6:408:f4::9)
 by DM3PPFA632C0238.namprd10.prod.outlook.com (2603:10b6:f:fc00::c3e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.14; Wed, 30 Sep
 2026 12:59:42 +0000
Received: from BN7PEPF000000A5.namprd05.prod.outlook.com
 (2603:10b6:408:f4:cafe::9b) by BN9PR03CA0154.outlook.office365.com
 (2603:10b6:408:f4::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Wed,
 30 Sep 2026 12:59:42 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BN7PEPF000000A5.mail.protection.outlook.com (10.167.245.229) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 12:59:40 +0000
Received: from DLEE204.ent.ti.com (157.170.170.84) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 07:59:15 -0500
Received: from DLEE215.ent.ti.com (157.170.170.118) by DLEE204.ent.ti.com
 (157.170.170.84) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 07:59:15 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE215.ent.ti.com
 (157.170.170.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 30 Sep 2026 07:59:15 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68UCxDIx4098047;
	Wed, 30 Sep 2026 07:59:14 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 03/15] crypto: ti - Fix potential memory corruption on highmem pages
Date: Wed, 30 Sep 2026 18:28:47 +0530
Message-ID: <20260930125859.1749849-4-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930125859.1749849-1-t-pratham@ti.com>
References: <20260930125859.1749849-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN7PEPF000000A5:EE_|DM3PPFA632C0238:EE_
X-MS-Office365-Filtering-Correlation-Id: a4bbc556-cc3b-4bf9-d973-08df1ef2b0ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|36860700016|82310400026|1800799024|10067099003|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	bEb8rogBkupTofCoFGFLAqq09vpAIZPC2r+ejWVLyKm+ZPlMDkZwjQTvmHFKbmdww1XFrmamO/WPgJ1F2YqhSeLai2JU9Rsfw6kBHCjEzMDpGWGakU/ghDgjo3vS+SM4gQJ8gsunpwP88Y05aggYdCygaWFWlqi9UurzejLMQnrTQPN0HDzgM5fnH2NfU9rEnNcNfJVV37HOsCjv07+mBaRULIgyl+1CGekmO8OA3oNtoIegM7tgTnUSHZpJt15+3TwhKIszqxSs/Nwiv/QB0DuiGS7hnrt4/dCrh3Ge4VQqa6wT9l2WuYpFAm274yy34DJtrviUQY7MJmGpNUSItNSedlffwa7qXLjFCXcj8B/8Tlu6uf4lMqzuC3wWH6efIPBGNgXhoIXztz+FhN3sM9q+v82nN8MrDUVoNWq2T8ZOUHciKrChQDeieldy51RjThkYsQInFrGo1L3HnKDPFTiFZfJ6NZ+V+Ch04KNR6cCwDhnDrMY0zX4DW/jlm/H82FyTtHQs0nJuqLQAtjsdsJ5cBzUdVG0TURyssxegzDyZUvSURCpwOlhsorkVZMXdh+dd3Po5+ERduuI7TyUrbG/D8c73t/MLroaWS06np5ofF3jN+iHybjsc8kd0DyPql1FayJHVzeNlJwE1Y/+bG+ZaY3yDftSVNC3pOW6DON69W5QZKzHLLyVYKwY44hB23tA56AhN2c3T6gn+P1hxtQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(36860700016)(82310400026)(1800799024)(10067099003)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2gNIYeoiQy9kNlzQVyumsIb4IhGjuEqb1Q/9xSlN7cRrlD5Bve4N9n2h3IeX9+Vk22opr0X0k7BXbowydC9vnEvE09DXmRRuFmTco939TYSoO8FwAo+iJXEB71/f7jZjoJMY/risVHY/t8E2OMSjaAXFVvHOv8esQ/DTg2g9or0jtP44Wezhwpq35/mA9rOgYwyv9/2c0Jh499Fhd6ZdhF50xcrxy501h6RD7arQ5ESLjpJ2b3awjD2p/ZE4451MaMaNDE2taPnNrCcCJqcVMkDq+9qR/B/R+0gXPhw5M/gPcxM8jwz9YLeXqJTMbhCBDQZrAtJnHrkVLgBX96S+OyXtW90vTsTZ7PMvgweEnujFl2foVL7a4UbDmNNya+V0v1mbGM8o1TnDWA7TXe+OkAOVw009y/oNg719PwOARMmCC9MzR7Aq+klrhpsVUy3j
X-Exchange-RoutingPolicyChecked:
	bLjCcQDVRPefRM5LJYZOmzKDl7h3ereFfKsau/oDVwfqhemPVQxZR7Dy/T9Dg5ytHtXVJWq4RflR1EuLAJZDfLzG+nTpdSCpAdVKIF28t5GnAJ4nc4a1c2dhH+kcbufzjrDEF3QyPanvPr5BjZClXlMhJpV7qWNdjdqR6MVtyOvql01PZTD+fayqISu/UQrpk51tQOKyNlrgLlFl1KGmd0us2sm2UvTQrfrIc/fDERXvIjVW1JcFhqOXM6wy0XijuFpTB0tIJLlrC3cQG0Cfzej1HGcpj3UkjwfP/rKhwpS3E7tzABhkCSkR2cELuubPPLuISDVykUHWmLtrYZb2VQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 12:59:40.7782
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a4bbc556-cc3b-4bf9-d973-08df1ef2b0ea
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF000000A5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFA632C0238
X-Proofpoint-GUID: yCtUBKTXzX5bEKM6aqW10gWK4OYxK2zL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfX5/jrm/GhsiCK
 1R8Brv+vZOlP3Ab5KwF9P9A8Ob0LXDpXriZzaLhBO4ToWftiGs9GAllkugIy6eI2d523CWzH16U
 RFMkOj1kNj5JaYQtbYo328ZbpozxhlrpQhkpygajK+H11xpd2zbC0cFKDY1r7TAjTz2l6wTJZr2
 1R8dTJErrUS/886j5gvhe9UkO4FH61aiC6r6NZwYAXuhWF6zCRtpFjhChcf0CVXaTWR61Nz8wpo
 dhqeMVYAGCxe7nPL/1HPyTwOSbeNHZ+NMDK2WMKpQL2HI6uAH2B3Zhfey/MQB9NG6/fCIuenpd9
 gdHLPZqSBsR7L1jem6FOMGmSv2AfV8IZhMjfeC9W3wxpOU28vPpAeqs4XcJo9WI0KqfzvHTriVG
 6JoI++SaZNObtACrRfssuy8GSNvosVZ7HF+OrKjB8zNMUghVb//LgnIB1wbiJftlG9D6/eJ47jD
 0BWqLYUxGvgg8R8yl8g==
X-Proofpoint-ORIG-GUID: yCtUBKTXzX5bEKM6aqW10gWK4OYxK2zL
X-Authority-Analysis: v=2.4 cv=G6aJgNk5 c=1 sm=1 tr=0 ts=6abd07c4 cx=c_pps
 a=9AjoWhdl+q7f6/Aw5qa/DQ==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=IXP722aH8NCvtdUuCEcA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfX2prY7A6GzYVT
 /288SgUA0pwEpFx7P/6Nksos7JvdFPVHE+AsEntmHPnesTZYO7KwLR53FeUeMkCiGX5yuS1qMF0
 G/245XmNIN7gVomz1ZyrP8LbxquUenU=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300051

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
index 1886538168103..b8b02b82317b8 100644
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

