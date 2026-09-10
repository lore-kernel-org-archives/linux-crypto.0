Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCCC3E4106;
	Thu, 10 Sep 2026 10:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789037001; cv=fail; b=tC3c+/vESQNHXk+/pWN4FhYCiERBACqVNXqwlPATjtLbPEfncfTQnTmjwbG6goF4/Lh7lZzJTwko3Pd5tBOWDWr//w5m4ZQnlvBQdE2znI76O6j4MajiXk2I9OAqDKDBOoBdMbo5Ali3HlECfr8mBFkveDMr9gzICIWFS3np0QU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789037001; c=relaxed/simple;
	bh=L6sJTGbxYKzCcew0gputMowl1JIkjqKkuQGwSODlbjs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PXJXEbIODZpXV8qw7sHhZy/aR1mneDwh5zhE3Euu2Jo12HlDXJqpxk1RgFBhRhkyR4tdB7fIls0SiwnvzJRx6frQNXMZAnh0vfKyGBaQszegyNHr4NWqys1CUM3bN6w0s+wOjf1W7jptKrKpIJSpq3LKWypVJq5rrGmkp+6GVbw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=e97Enfsr; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=AaUJTKfh; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="e97Enfsr";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="AaUJTKfh"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68A9KRdk2786667;
	Thu, 10 Sep 2026 05:43:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=1XOuYy4Cz02k59FK1p12uZ+MgDqx6sx09AI8IDLaQ
	7A=; b=e97Enfsr8AhQMAUsQFcFUCPcSBLqOYyFcGdn/w8FhuJMTp5sGKWET9RHT
	84Gp3luaisRdJOCeUXfaBEQ3xyLzgkaExxzGnj1HewWOp/kO/jLvHe+HKmGTlytG
	fJyXi9k5vC6MWgCoZ+uQLaLhuz5ne0BUY803rIZj0kpTBHmZw/f9CJg4/YITRMeW
	Qno4oR3gGa31Lxa45rdtGlIH1VAPylOadHnZYWYK/z9RcqDDLji8a/376v+Es9/O
	t3g4icCoXl21EHdp1UevPNDxpakvU0sVO/BkjrLf/jFYCmz557enrEKDdJWId3NS
	84xa6fYAiKbBXFrXO0CRXUCgJo0xQ==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011035.outbound.protection.outlook.com [52.101.62.35])
	by m0380145.ppops.net (PPS) with ESMTPS id 4gkstv8b9c-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 05:43:15 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bTq1guQMX876JZp3GDe4yXKofqz0btlPKkikuV2Uvomwl50RYtpC7wp1CxVtmIDSp5LZtSD+PVJyHPntcQItQ21+roKeS6QHsVyZuHeSoFRhtfTGLhtlFS8TPyYQrdFyeZvSZ36wyQy8crr9CUHk26Vm38pHru97qPozif8S/EHgp/dAXSfHhyGfhN4K5Eb55yQAhfVhQDyahC8AtvJvg0dUvBiq5MAoh+XA+UWsiF3LVG7LFCngr9++riCWI130IYJKZ0Vj9gHq0VxJBsUb6C0mSc1Dl9xDSqg8jJTsCTD6zJKzmqHxw/uaLsH92LlXUDvDiu9eytRSr7AUbZpMsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1XOuYy4Cz02k59FK1p12uZ+MgDqx6sx09AI8IDLaQ7A=;
 b=XZocU0rq+YxKu+yvJhrVyXtf7s25+MdZGePaqq4/CWaMcUpF+BWf9WG6W0Ih5bYe81J/mcFpAVggZ0g2zy5/DldM3xhjkH9iNcAJpMhKhwBw1Z5TlmONZH7SDDtujVLyBerTyWv1zuUSNEzcafFkmG4rIQirPnYEmrP3vK4KvsyCOT5l264ks0zhvWB80Z1WJ2Fxhp3plBgdROg2od0cWSSxY04Fm9ccU83tIh+HT7xGQYvMdFWXAw/Z2TkqW4ejskNkHnXY0RoognNrSgowFyWrV/woZrax9QpsZRnwDKcIuvxs10lql9s2Hv/1NhnIYwav0MJJfx90UhN/hTNNYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1XOuYy4Cz02k59FK1p12uZ+MgDqx6sx09AI8IDLaQ7A=;
 b=AaUJTKfhobJIvGjrafQKgqeVL0SoJqxnSHO51zsp7ECwTKP21C3Zv2FKrZWlwwxNKTHOP21Wx/h8IpUH/rQbMz6nB7EyXNq7UyQ/HvY+ogYIeFkhgKCx47uYjbpnjHXzRmbjFaMJMvzaTJpIQi5pTT/g1WnPB97207EyzlPI2lk=
Received: from BN9PR03CA0768.namprd03.prod.outlook.com (2603:10b6:408:13a::23)
 by DS4PR10MB693589.namprd10.prod.outlook.com (2603:10b6:8:3ed::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Thu, 10 Sep
 2026 10:43:13 +0000
Received: from BN7PEPF00000092.namprd03.prod.outlook.com
 (2603:10b6:408:13a:cafe::ab) by BN9PR03CA0768.outlook.office365.com
 (2603:10b6:408:13a::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 10:43:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 BN7PEPF00000092.mail.protection.outlook.com (10.167.245.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 10:43:12 +0000
Received: from DFLE211.ent.ti.com (10.64.6.69) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 05:42:50 -0500
Received: from DFLE210.ent.ti.com (10.64.6.68) by DFLE211.ent.ti.com
 (10.64.6.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 05:42:50 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE210.ent.ti.com
 (10.64.6.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 10 Sep 2026 05:42:50 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68AAgnCd2177942;
	Thu, 10 Sep 2026 05:42:49 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 07/12] crypto: ti - Separate padding buffer for src and dst
Date: Thu, 10 Sep 2026 16:11:57 +0530
Message-ID: <20260910104202.1537226-8-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN7PEPF00000092:EE_|DS4PR10MB693589:EE_
X-MS-Office365-Filtering-Correlation-Id: 7742eb01-2325-4512-2d59-08df0f284fe2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|376014|1800799024|22082099003|18002099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	APkBdnCFFefP7uxNpepAx0qhzJahgiR9qNc/ZTItHHi+4UziBfUql3tWMo8uofv7Xcz/FbLHaaJ4jZ76w3lNKcCayoH63o7WFypaFs0H5qkod5yoBnQG2ei+hKnyuWRSF2k0zijAmsZlF3aY4YCi55pp1hyLgerphNWgRQhs/qxTrz8wcZcT4qqw7a5ADKwS2Sz+6kLt3372rYjlc/dcIwOXxyVNm1uN+eI07t3Sderj0xOz3IQcL+tdz3FDdHwQFED7jEPiTQYsFIgpQgy+f0+oI9flAuOz02tTGYub/J4cHjq0D6X96y7SSPPUslt0p0yvP4y2E1DEmh/ek23uXJFXduJ3Pj8zKW6ALG7xia9fUpcuasClZc2FUcj9KPp43gzv8fRBBRea+qExhBPucwMrZxTanJ4jIpBlviBM52pQl3qB0+OiGvI8RkCCYK7iXz2d6ulckuxZ/RdaSVqkxKqzeyq3ERjcVo+I13/b5mq2aH4Vm1k2L3Brs9lA/ews3sODfiABzt2K0jlXDnX12gU/4uCw699gQQeu43pevuf7A1FhnkGgssTV556CZhGdOxFhVttGrvRyFu8x4TMjXvT27kqTSL5RO3tH057Lf+9DDePA+NQjkUO2E8n+TMgMYlY+enNJBjtrekAtpTEypM265B0CSZKvX3cRId6Y8Nw/SeagXmxdjzmsN0qOQhv0n3rGKqm+WR4+A/rq1cVYTg==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(376014)(1800799024)(22082099003)(18002099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	X0eVPHV+8PHBmXR2Ay0oYgSoRuhuINz/EFmNU2GkHYcNCRghGQPWKGkFJ9M1HFJshIvX8qknSi0vciJ/KMD02aUpnumoov+h2rFjRxbst53WDGWJo9ngj5FCiIyNDUedl+0wjikq/3qU8HfFuBs8EScEQ590NhIxAuKKqIa8LTl0oT645g/IDqzR95vLrJq33JeT8QBMKSHgp/cUcb0V32lW/j+e0K0xrLPU/tXLn4Fz8NR6P/JESj22HYV6nhAsPhMfRrissptiyLMsY8TSGegx7tDoK8bFASpb3mZrjmkuBj6SJXWvEfRTe3uOyfba2PHWGB1pLEpOWKGMcCsORcvwAR5eLOoJbhCfYBUeMlCTpF4FB4OO4ArJp9eZZKUnLWITe0DWYfdzh/WBfRNs8hyfpmWA3y8yzlGaJpJdUEICuP5+H6clXAHP+u1hfDG5
X-Exchange-RoutingPolicyChecked:
	Bz1GezlgbBqP9KxZPOPO5KZG6Ee5wkNPHtCiGe7IPYFLEenJ+zl6JUCFZehYa/9KmRyVaGL6or7u4EoIbGnDuDN7BwEuWpyYJTyLFqLsYesy/TiPoFK9vW+8XYzm+jATSGulERhIl2OEE9vNBsW/7QgKduGTwAqTB2k9g0mUze5HIN8STu5oSyV21E+gS+JcBV/kwosIfEIQ5S18/dn9Z577FdWysqjjZ8j3P4/UzUiorAKNzq+dnEieoBQU2hfXR22cEYHwOkqX0J5mQGzy/ew2N1X4ctf5Oqm8F2FfELav7y8EOdVMkz+Q0PV7kVew47k636qhyN4TnabyEi+Xbg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 10:43:12.1997
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7742eb01-2325-4512-2d59-08df0f284fe2
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF00000092.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB693589
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDEyNCBTYWx0ZWRfXyD6hc/oUJiOb
 fDXYj2Umdnt9dYXXs4nSj56uLM+5eM4FJp1WYJB6/e+J7RcPoHLgezIlYBKGIF00V7d+zfzuora
 MM0GTY0bNNY0h39RAMKFK5pHV1l2LKY=
X-Proofpoint-GUID: n5imDquV77g8KmZ3mljIDX_JoInOVs3O
X-Authority-Analysis: v=2.4 cv=VvG2kO2n c=1 sm=1 tr=0 ts=6aa289c3 cx=c_pps
 a=YQq2SbcpNRFTj3qt8lmqwA==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22
 a=sozttTNsAAAA:8 a=pcghVQDwmu1mgjzKNFMA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDEyNCBTYWx0ZWRfXwe15EcL4msNL
 4QGsygd0MlOko/ywbEuKE9wkBYZbzS0lBc8GB9kOmA2dEUhCyswhegtWWOSgWritieiVgcrizfm
 vi59n6QRFc7roOpBBiHG7x9YM7xkImop2XiCkueS8fHw1mVmN7fRJVoB3ooqxsgdhZM1ptAAxZD
 RpNJFciBZ8f/5K1xvWSYZIOq44xAXFFqWLBpSi/ifEUnZ3b6G15dprQfAG+ykEHXfs9/5VdUiXo
 /kApMXOUgkfdv9d+I2pwltnGlMkeTROKcDp3eCs8BevzGuczkYzTqaSiEcPmhxkVf+efzOyhNC/
 r7s+JGTiKcoz7Fq9MEer/QL8j3tmRzIjtobJbv/gO3n25VJryu89W/y1VuYcw4V/PlEmW23e6BK
 b30A8IQk/owZnTHuj3emHfRJ8oSC5bc8FANjByzrxD49KTf9ujido7nStWHrTzdtYH1G/iyKmh+
 lmgGNP6QPPPrfrUX23A==
X-Proofpoint-ORIG-GUID: n5imDquV77g8KmZ3mljIDX_JoInOVs3O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 spamscore=0 phishscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100124

Separate the padding buffer, which is allocated in the req ctx, for src
and dst scatterlist to avoid any DMA mapping issues when not doing
inline operations. In such cases, the current code was mapping the same
padding buffer twice which might cause issues.

Fixes: 35645ca63caa1 ("crypto: ti - Add support for AES-CTR in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c    | 19 ++++++++++++-------
 drivers/crypto/ti/dthev2-common.h |  2 +-
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index be7ec62ab2513..aeccc235cb667 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -338,6 +338,9 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	int src_mapped_nents;
 	int dst_mapped_nents;
 
+	u8 *src_padding = rctx->padding;
+	u8 *dst_padding = rctx->padding + AES_BLOCK_SIZE;
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
@@ -492,7 +497,7 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 
 aes_map_src_err:
 	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE)
-		memzero_explicit(rctx->padding, AES_BLOCK_SIZE);
+		memzero_explicit(rctx->padding, 2 * AES_BLOCK_SIZE);
 	if (diff_dst)
 		kfree(dst);
 
@@ -882,7 +887,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 
 	u8 *src_assoc_padbuf = rctx->padding;
 	u8 *src_crypt_padbuf = rctx->padding + AES_BLOCK_SIZE;
-	u8 *dst_crypt_padbuf = rctx->padding + AES_BLOCK_SIZE;
+	u8 *dst_crypt_padbuf = rctx->padding + 2 * AES_BLOCK_SIZE;
 
 	bool diff_dst;
 	enum dma_data_direction aad_dir, src_dir, dst_dir;
@@ -1125,7 +1130,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		kfree(aad_sg);
 
 aead_prep_aad_err:
-	memzero_explicit(rctx->padding, 2 * AES_BLOCK_SIZE);
+	memzero_explicit(rctx->padding, 3 * AES_BLOCK_SIZE);
 
 	if (ret)
 		ret = dthe_aead_do_fallback(req);
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index cfb50255a5dce..f78420ba871e2 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -115,7 +115,7 @@ struct dthe_tfm_ctx {
 struct dthe_aes_req_ctx {
 	int enc;
 	__dma_from_device_group_begin();
-	u8 padding[2 * AES_BLOCK_SIZE];
+	u8 padding[3 * AES_BLOCK_SIZE];
 	__dma_from_device_group_end();
 	struct completion aes_compl;
 	struct dthe_data *dev_data;
-- 
2.34.1

