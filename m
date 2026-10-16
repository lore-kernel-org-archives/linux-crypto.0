Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CC647A0A6;
	Fri, 16 Oct 2026 11:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792151353; cv=fail; b=X4aOa92iwhEPRVIktlp3+7KTWQqPT76zn+sJ1h2xwfQtaKncM6Z+JTDrUq/ARe8EhvbTCfJBfQbBrb3r55jgViOmWN4DLCGupbDY/ZzMRErRX8HyJKArFEzjUqjkkQ7cRN4QncwJKfv6ByQhsjDMQxVpaB+HVpMTq3t8G4M+oU8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792151353; c=relaxed/simple;
	bh=GR+qrnrjIRtaBAzReHzZ8r2pxiuFtvxoilH6uNxhHvs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QQ30Cf4QzTlub1yqXIcjY4T9vsN/2YCSxv8oNUjVhvR/3dT3zdLbvCdWmekqrUkHdtn1Srfh2SOkC8Zssv6RXQ+oZgmEsVsAjxAMwrhVxpzXJNeBF52TTgmFvxSbd0B7ShH4jOxk5GtDEdRfmlFvC+x0SemWsSldiQbo3kUaq5k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=j9lpJhok; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=X3xLzlBs; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="j9lpJhok";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="X3xLzlBs"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GACkaK559681;
	Fri, 16 Oct 2026 06:49:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=tvFqDckfZT85PyrkHGhKkwSp03EnO9FSYviBJkcVe
	7A=; b=j9lpJhokM4bGrEYfjAZI1f/Q0dDbi00iGYAF8wVEEFec2Lc95DcEmwGCL
	KXSyUhpB2m9RYYh45axjwVdOLDqsY2tuv8rXJst38FY12L0N03qHSBiVpD5jLSJq
	jEVq+btAd9QG9rCLqimraOz3Tz/Zr+eyB0kWv8hTKxXFBuBRdWUVh3bPZu/AUgNs
	PtPQB6VUhSJGM4EkVkhPak5W/EOqRE6jY6hIZgSNT8EW1NCmG3zqHA5vte8JyuF2
	bFKDqrZulkNIP13k8twU3cgyoB6MYv2wFAZTEkjoqHWIyq5Pt3k7DLZembLuStda
	NRr7bXlnCRGrW7ErdnbcaRAXtbKNg==
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010032.outbound.protection.outlook.com [40.93.198.32])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hbhbd8gv2-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 06:49:07 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pp1QV3bG8QCeeYDlYxHmMqrCKZLuI9OeDN6i2VBwWuLqLTtA9nVgIaCohCLKrnNnmABEf86sEoDAv+R2ajM003YtT4YlRU7mP6bZHQ2gw3EsGQaOTOsEgOkKOAlsD2r5gJrWl9Ch5fAOJhGhcJXIhs/2U3K+Mtxqa0ahcdDEbLxv96d7Y2ZG7P7fOXEBJNjWaqQYqcyOFyF1ZG+NIi0sQBAdQlBszQWqvFNcrzSZv/Z/FcMKUoHoMI8uv0kg5zjlCHbTnpAm8CYZaeEli6crs67ok7n8APU390An+EBf3v/zp2qCluvH6hkFdG6Uutp/AeEI+4nDwSCbNxigdQI8GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tvFqDckfZT85PyrkHGhKkwSp03EnO9FSYviBJkcVe7A=;
 b=riwugsKs/2Ecrg3ctIySYLcA/42j8eIZx5p4IIQ0Qn82hSv00w5FBXei+PoMuzpSH+otA3QyfuGvkOzHn0APSeA8pvlmAKNBmsCyVnXEVb5Q7f7+cctIiW9dbP+C64wAVhteUcnrNxI5dgtLzmdsepDXJmP5YXxQbnsM3DBj7ok47R03O5R309RoQ0xGor0u05ohnwY3L7ZQh504ch8Q4tDnoNsltdpbpFakpiLrVlIqOc7ocDCqWd7+wiglaUH/LrYzK1jqfG2P8UNbmXLzs+1CFWHh0aouAK9lA0kU5hY/ig8hilOwO+5wkT1UrQDT8ufDvrP9y79KiT3duGE/iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tvFqDckfZT85PyrkHGhKkwSp03EnO9FSYviBJkcVe7A=;
 b=X3xLzlBs3xCn3h2jaAfqmB8ldIo6wLC0+HFsjIvKdSTN4ULmtb/0Nin0yBvOHi4aj/LMfugyDWnPLZlFVyC0FA3nB8rUzSFowgKdmblBcXduxUva7kF/NXFIjFBdN+WOlgjO3CS+F/FqPX9QBEt5HbpsDXsZ2jwQomFRujUp0Ic=
Received: from DS3P221CA0010.NAMP221.PROD.OUTLOOK.COM (2603:10b6:8:45e::8) by
 PH0PR10MB998142.namprd10.prod.outlook.com (2603:10b6:510:3bd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.7; Fri, 16 Oct
 2026 11:49:03 +0000
Received: from CY5PEPF00000E78.namprd02.prod.outlook.com
 (2603:10b6:8:45e:cafe::2b) by DS3P221CA0010.outlook.office365.com
 (2603:10b6:8:45e::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.17 via Frontend Transport; Fri,
 16 Oct 2026 11:49:03 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CY5PEPF00000E78.mail.protection.outlook.com (10.167.247.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 11:49:02 +0000
Received: from DFLE205.ent.ti.com (10.64.6.63) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 06:48:31 -0500
Received: from DFLE207.ent.ti.com (10.64.6.65) by DFLE205.ent.ti.com
 (10.64.6.63) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 06:48:31 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE207.ent.ti.com
 (10.64.6.65) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 16 Oct 2026 06:48:31 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 69GBmTTe1508585;
	Fri, 16 Oct 2026 06:48:30 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v9 03/15] crypto: ti - Fix potential memory corruption on highmem pages
Date: Fri, 16 Oct 2026 17:17:54 +0530
Message-ID: <20261016114806.1749515-4-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016114806.1749515-1-t-pratham@ti.com>
References: <20261016114806.1749515-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CY5PEPF00000E78:EE_|PH0PR10MB998142:EE_
X-MS-Office365-Filtering-Correlation-Id: bddbe6af-6432-422a-91d5-08df2b7b7961
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|23010399003|82310400026|376014|6133799003|10067099003|22082099003|18002099003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	4OJYtsm1dDfTZoH7tDdU9l4CbQUDV0ltn3B4nJ2VZf/5v7Ud45FZngzYyxhu+vjQuUw8DZafT/6rO3MIGEb166mvF7/BgzMrkFrPWIF6cdkwf6KLfyBaANSbCvYOcG4jtdFSlK4y/kL81Hej802FkeCQAej85NHWSsdHnDEbRwTS119NXCUb5T1LkVZ6JBUg9yfWU4msiWl8J2E0R3Qdo+k8jLT+9NBoPNmC5nm1VLpQxs0HWCGSky80Kkxk8fLJwb2GanPl7h5l8JJUOLoCXOThUAH2SiITBCffpmMd0nk6S09hAOwyGWocOTpCXAi3QMpR6w0nkRkh3xItrB0MQcM3c9ax3k513nE8zdjEmFK1VpF2EFmIGIp77qxZxATw9qy0vQSVSILo6lrK6qmAGD/dozek9av1ud93E64CJks1OAZ4E06SXSrfHBrXz/HORS3elvl9Wve5yvfMh3WhF4fqT1JdUCPeQ2tL7+ZiTDwfv7wInZXFqdU9AxnWxko5oAJdsl13jEKsh+xOyImEe/xj//RnSAGtuoimI9x8R9jM4wzg49abmHO3c3F32LMk1WlAs5beJ4oz1MIxw4aT+mYex1jPCxLTsOQmWqo4tkSM7OowaNrXQrmKQTc01on4Voe2ccc2cTjSx0Yf9uiH+ObShL3kxjLazqaNpK9LXO2XjobU4xilZ6V+btOFq58Cd7PDsxJWKvSWQrz9Tq+xww==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(23010399003)(82310400026)(376014)(6133799003)(10067099003)(22082099003)(18002099003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	L7ISZNV7A0KlWPJvxgUPSmLqU6Y40rspkYBhRH36jmbTFK/7Pj7NNHYvumOpl9H+Z+b7uLrhoTCcQCZ8tcwQL4FAnva9xJAYvBOGNbWHEizG4dikTFtU7Sbbqhcs1syIZ4DiSS4pPVhxObFwb6riy+/TG4PUEC7WpfTns9QwwpUcts7cRIvD0gf8/ejkirofii4jv/Y8jMTLF0oJ2e1p+mP0staVsO4luNGcKJDDZhmHeotSH993yTORGTQGn4pcxp09gp9Kn+Rbr6nDDCL8FPLCYSJuE/kbvKTc0l3oxr0dhjaGKYEo9HEQjVEIw2M8FTNd4Nwnoh9fQsJln2njqOZRPQSDO8N6PBVvSUyyGVq8hAQaEn+HVrpGX/1ZUs/e5iq0HG8qE3FuCA7fdJybZIdSVbwV8TtFV+vheb/DNQrFPEZ0VQYvZr6VzC5Z3iTL
X-Exchange-RoutingPolicyChecked:
	ChrgX9ZhewT2zkZaEc9ptOd1pKwZatu/Y7cvKXojxKz9gW0n54/qRxjMl+pMZo8bwi8NYnx/k/RfGHSocd8Oa/K9sXcDjUPNjvsk/6Rlyc63q5VtsjYOIUBEz0I10JL3LjmVUsuLMURizqZHvgxGNKOyJcoBT2iJ8ucofcBfl5fpyf2wRonPPrj/vE+ShI3waFBIyW6qj4vK0pg03e387H/x5mrYdOa2yeVVb02FrUGrp6ulWtuqEPXEw6nh2e2821YeFUs0IKur8m0Mr3uHO9WFcM8yoJ+dWo3RrLtnhlVzIULmDrHu6XzMbq3Qs7UMe7PfBBq1rbr0TwCaIobSew==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 11:49:02.6455
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bddbe6af-6432-422a-91d5-08df2b7b7961
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY5PEPF00000E78.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB998142
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA0NiBTYWx0ZWRfX2eb27etiRHt4
 OGfKFZmmiwc1fvr6983+w+3PXe5aP0l39ltOfLW6O330AVDawkGTckkyfAnL01B/d6o3VyRIWdK
 RLQbv09w6j6FOFaQ3R7zkgUhRIqoBXg=
X-Proofpoint-ORIG-GUID: w3-xK0TIKRZTtVj-K2FzTiZIHgGzP6ox
X-Authority-Analysis: v=2.4 cv=BooIUoX5 c=1 sm=1 tr=0 ts=6ad20f33 cx=c_pps
 a=A8yAwjBYovhlCeyetBcGtw==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22
 a=sozttTNsAAAA:8 a=IXP722aH8NCvtdUuCEcA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA0NiBTYWx0ZWRfX3k+8LyMuqrxc
 oJ+P/t1sWzmAjbRP6FqATykFBP+1iMYRFkl/gT5ZywJOmIFopHe4tU85OC6O6xpYKj7AT0a43LV
 rtDPgXzwxOMWoImqmzwiL8PDfBTyqOdsVLEwU2T1KZnYS8ZdJNvcx78vi5CYl6K4WJNwbH2jAF5
 ZCc1Qmkkff1HiE7AWEcJqlFFaXR95bLFLMR4oaO7T3knPSKaeWb90mKYmkW8ncHetO2T56Ia+hV
 Xr7bphMohPs+HQRSDualioApqmb0y/QplBwsl1F3R2HD4jCfe8xo4PDhiGQlcuSPQiHYndy/mb/
 D0iRFe0z0RhZTjlm3+CmOtpbo0PQzNqBRgRE4nuvrdyIgRDyIFybAtda/PUOwkGC8Ri7oAo3K3E
 bu7lGIgeQRJfE3GWL9e4Dg/3eSoHc5p7KKrLX+MYJHACYj794KdIqQBKcxSzszhgx038yYeJRJZ
 gqrgij8D+vuxTBk4lJw==
X-Proofpoint-GUID: w3-xK0TIKRZTtVj-K2FzTiZIHgGzP6ox
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 phishscore=0 adultscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160046

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

