Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE014D2ED9;
	Wed, 30 Sep 2026 11:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790767624; cv=fail; b=QWytNFD9YXhMWtR5MBz4/8kfqfkF5HfisMArWNckO2JTJIH52d+jBr3x7KxEsNHaN6z8RvCSJppIGzo7l38M8QqDrqPQgrOANijsxZJR8x5Oexpt5kmtdmdWAb25bT53pYPKX8A4uwvKJmEev+fm1QhUOeQfW2wlyGzZHcFoowU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790767624; c=relaxed/simple;
	bh=Zd+YFyNQlDgh9XjZ8Jbmlxiyyyvl7EPV0mQcbY6y4h8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GSbaaNP3fqymRclBhVT9F/e2CrHV358wGDxThPi+PlCK3yCgufHNWshW5vuOipdHT3trNRd5b0USYpip+If5kr+uVVr7hFbELszl/zQ57uX1L0lcTeWzvX+cuz8fxOmk7SMdWwUs+zEwJQQ7cmJ3uCiul5W6NLLoOB5TPiAYsX8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=d+Ytu8lh; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=S7PmEUU1; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="d+Ytu8lh";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="S7PmEUU1"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68UB5wnu3214062;
	Wed, 30 Sep 2026 06:26:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=0NmAorX5lMN6twOw6KKl2WtZgSmXV9LsQvUb9367J
	Q0=; b=d+Ytu8lhe+qnqXPr/zGyGfF6Ya7wUZjyJF4ZaURuelWquZZc8Ng0BXwzz
	YzEzhRCrDXqZCEsUdDScjkaaFzvrIERRKTaUkOPNU6KnEzrwbeOzj1mqP/B3XAh0
	9Fmr1atpVS8ze7VjbDdAe/qTRT1IS2iXUJteeMl+BjWukPdBV0/HR8Jf/bePBWv9
	nm833paiITw+6NA62XCHYRSBpLdzTCBENSAUiPoZGAMY3EeE5BFVDvIBx0NNpLv2
	o1QBYdjoH9M7qCuvpOPidTP4uCCJz2QpdxQuZFyaxfRMy5EmUXNxydrCsVIhleCM
	0hG0ZjhiT7DacvcZdDd++pOM/eN7g==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011039.outbound.protection.outlook.com [40.107.208.39])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4h0ydv8q64-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 06:26:57 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RgJ8JKaQu+9pbkgsVEd1qnVCosForHsJo0usP6wL/nmgb77xUq7E9oSoiljnn2eFkcnE0q3HIr4gPRRMeAa5NwVzYeRhF+o/bABSEQPvknnplIKPMKOi5lSoEGsO1PDOgyZ/ZvOmUlQz6IKK9JDUBhoU/fIhaW8BDugZLwcUYzpw5fx9/MR+Lt3P7f426b4T3PL9/QH85s8wY0zHjx13vSxZMgiMTEllVRaOoXui9J/jp9dGRBSXQ066W3uq22dIurG0tIewb2gS5lY1ny1ggoLZPs6nYGKVdNWqhoN7YgrsdTfboaLmN504NwiLaD20nP8mlmsJPhMUz3lQuooT3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0NmAorX5lMN6twOw6KKl2WtZgSmXV9LsQvUb9367JQ0=;
 b=tt1QvWeesF6Gw9eCW+c7C3kRQl/B3sGmgvdAytE7vKlSzZQj/ARlfg7kIPlIOP+HOLV9pfgObtzpDyixtFS/6Bq61dVB+5gtdt1DQ2848qEHLqRZcSdNJPgeKmo63j8904rKYc7lGfWRNelE5N+j/uXmbPVEd64egmkdm0j8O7VLYAKEGMaNSuFDs7i07C6Mg+k1tHaBmLawG7vvimAbauZvwWHq7mtqqNPtma7oMFbGVCrejuR1EeKMieho108bsZz9I7mCx4A0S2H2z9seDYZWW+cyGgc3J4abJIYGGe3qbVvlGf2mBv5VB98GZArXimFOFgLZmoocNgMl4WXP7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0NmAorX5lMN6twOw6KKl2WtZgSmXV9LsQvUb9367JQ0=;
 b=S7PmEUU1v1oyzRT+lwzBUc4Qg02et9xKBZWr2r3jadwGioJAS/TJYYcZMS6QI7xpqXRyirO/feX9bDwXGZGUyKpVBM2rJJypAMcwSdXzl4jTyhUgmWOcPBQqR8zY0LWIvTTeWWFisFVSSP9uZZSSxwxrpLlX8SD2fWALi+DEo3k=
Received: from CH0PR13CA0054.namprd13.prod.outlook.com (2603:10b6:610:b2::29)
 by MW4PR10MB6677.namprd10.prod.outlook.com (2603:10b6:303:22f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.14; Wed, 30 Sep
 2026 11:26:53 +0000
Received: from CH1PEPF0000AD7E.namprd04.prod.outlook.com
 (2603:10b6:610:b2:cafe::59) by CH0PR13CA0054.outlook.office365.com
 (2603:10b6:610:b2::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Wed,
 30 Sep 2026 11:26:52 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CH1PEPF0000AD7E.mail.protection.outlook.com (10.167.244.87) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 11:26:51 +0000
Received: from DFLE201.ent.ti.com (10.64.6.59) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 06:26:12 -0500
Received: from DFLE201.ent.ti.com (10.64.6.59) by DFLE201.ent.ti.com
 (10.64.6.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 06:26:12 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE201.ent.ti.com
 (10.64.6.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 30 Sep 2026 06:26:12 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68UBQAlN3969971;
	Wed, 30 Sep 2026 06:26:11 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 11/15] crypto: ti - Terminate DMA on all error paths in AEAD to clear descriptors
Date: Wed, 30 Sep 2026 16:55:29 +0530
Message-ID: <20260930112533.1593952-12-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930112533.1593952-1-t-pratham@ti.com>
References: <20260930112533.1593952-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7E:EE_|MW4PR10MB6677:EE_
X-MS-Office365-Filtering-Correlation-Id: 3282ddb6-4c0c-41a6-fb26-08df1ee5b90f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|82310400026|1800799024|36860700016|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	puMrRFGJo9MMaGFm/q8n/Xi/KrqdFkg3v5B4hz4gbvA4nBvNc5RDVwZCj95/HLIZoS5ZwmQ1bHpW1dgPLOGntksn7QvFwWC14EfmfK1v+49vZgLFP0VDo3tn0qllQYdXXQzjqlbg9PI8N4ELPS1UD4WLGgFwaz3q0nfMUZazeqaPiw7A5+qm09dN+xojcOT44WBTomN7TBJjS8AmyITHme3v0YMWI2zxtyVakRl3gQbUF/fLvTkVx6sokUEEmJ7VVRtsfExmJJ9/a+yE/zF8/5r5yaU/XqKyY6kIxQrif+OXHeq+FgHcXExWyi+Hbid7RHsw2g3XBTf74KSihiuMdudrrSLgjBwB9lsn8yjp6WgtFCcRr9UrU6tozDBpbSPjyySBsz/WC+arcmXoB1mWxF3I3T89iLWNKEOatpykAdh5GzFxi8iDpQ93AKAL30b+VxZJisu4ebL7I6s3oWCRUgult9p32sAPoxh7NsnRTX7VGvTvzmwHdzDoxftPe6gHKibgAmB0coIZk4lG1vG/B5t1TAxep6H6Gwd+aYFv9FXcejjIVfjigDC51tmKVJNfLNOvpK5hu2gwiEVzb+FQ2qa3FohH34pL18ZJliTo8CskzGxoOOY+eiXd7d/kEd2EGRing8l8YFu4uJ8ZJomi5ForEZaNaj9Qnr3Ggof3DXD8dpUNzrlyXyG0qIhghjfqJ2mIbIyPkM5gSsuCkSOEyw==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(376014)(82310400026)(1800799024)(36860700016)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	NCJyYoZVvjluQpC2oHgbZtljZF7zdjsaYqo10uwiT4v+ZRhM6IIzprSZtBmyaTAkRiG3Ax/8gXUS8IAeTXMZzNInM3sjnit8nZxUdOo1ll14/gRB3PiLcfT7P5A4Xx/gg6I5W5WGwL1jB6OYTkl454aKiiyNmLDuDJou5i1uUNlRYEvdsygHnK3EsNcq3hkMxcWOBPYx92PWJYYjZy1w3Li52zPX8cqOgEzQQJIdwFIQlo002xla7EOqyjUxBLSrCCiZWdniTJ7C0joBmaAmu2fWsfzxF9WjeqijifqJ+C+JYVjE6ITonTEkMgXPL6V/a3Jz208kZXmq3J0pq8ocxb0FHg3+6ME7U84Gkuc1VxlY07F2+FW6NigesuOn1+SfZwLY/24NZytfz1q6Xf6Q0hd5BOKS1F0Fwe7CJet6xjMSWOR5vRua3CcED+sftxkD
X-Exchange-RoutingPolicyChecked:
	aanV+WoHusx5+h/3fABhkg8gI3b4SZ4+W4pDCv09qwAzlpxojQ+LtCS2LaksozBCQR3XFs2v58F+T9GRWHL+4/Xkr3Dss4VjOvLjate1crB8pxQxokk8ef87nkxzrxj7TzJzwiChVDJyHkXym6CW/NTaR04het4IgYj88/ibekhFR+CZx0KisfEg41iMVVILTN8CbCuLmdPYpNtqs23E01T992KH0ApvJ/ST/Hu900uWP7PkycjC97tdLP7ny99dAiHfeuJOO0jIYpzlQI9dRWWnFM0a/U2ICQHww1Zo18n2E9umhvljB2IgbUSnBuEgDBQnEmUShv92V8fB/G9s6Q==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 11:26:51.0102
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3282ddb6-4c0c-41a6-fb26-08df1ee5b90f
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6677
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA0NSBTYWx0ZWRfX+bzBtBfNqgdF
 ZnzUdhdpYVgT50mfN3XDVBh1/sRJiElduA6oN+qBYGGrQC7rp+k4e8oXJopR71fOplZ69NdHnnO
 Hb442+HrGHt2e95hpewAnknkqwl7ll8=
X-Proofpoint-GUID: uZKpKzBLhgyPfxOnl8-nblMEsKeNcV7g
X-Authority-Analysis: v=2.4 cv=TegDJhQh c=1 sm=1 tr=0 ts=6abcf201 cx=c_pps
 a=ILySzFF5iTKX7yzk26Ee5Q==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22
 a=sozttTNsAAAA:8 a=noPYQ3j_lezN9luSq70A:9
X-Proofpoint-ORIG-GUID: uZKpKzBLhgyPfxOnl8-nblMEsKeNcV7g
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA0NSBTYWx0ZWRfX6hVyIBBIZWnK
 +S41O1XXT0y1c8v8uCvCnXNgDbL1MG3n9LxmIhz0o48vXzPToGUPE2SRZhUWjk7t59HlZS32Rz+
 9V8vwrPFbDcA26pl2ZE/b1xPjRaimldzHnKjPkk/RIf25jneXboiOq53NGxCtmITfLXDfA5/R+9
 GXay867msOv9OyfqRjMbf6JTe/rddrFyNgw+03PoiXa62VQImit9Yln3OzbZifeuXRvi4Iq+52v
 kCNQDXSQ7tNmDZSm7WYDqd+F1IoaM8FoNM5Opb8Z2jxFq3xT2oPjxPUGLI0SiXaO8XiWXfoRWIh
 GhnnIwDsNs7VgpRmvnO7+w42P+opFtuLoZtWLeTtwqMzzgn6l/jtszRtDpbekKYW8ze0Qkz4sbD
 yatq8QcjWimmX2PIjm/JaZFs7vKhJrs61RbJExkTMyzUJObnNUIPxoU9dCBZ+hooPzrriXG9LQw
 k67eM7/7vNgF6N8gT0g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300045

dmaengine_prep_slave_sg() allocates a DMA descriptor which is freed on
either successful dmaengine_submit() or on dmaengine_terminate_sync().

The error paths after descriptor allocation was not clearing them,
leaving the descriptors orphaned and leaking memory in case of failure.
Add terminate calls in dthe_aead_run() to appropriately clean the DMA
descriptors.

Fixes: 37b902c603042 ("crypto: ti - Add support for AES-GCM in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index ccee60800a664..ea6e3b246ed1b 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -914,6 +914,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 
 	struct device *tx_dev, *rx_dev;
 	struct dma_async_tx_descriptor *desc_in, *desc_out, *desc_aad_out;
+	bool cleanup_tx_chan = false;
 
 	int ret;
 	int err;
@@ -1014,13 +1015,15 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		src_nents = sg_nents_for_len(src, cryptlen);
 		if (src_nents < 0) {
 			ret = src_nents;
-			goto aead_dma_prep_aad_err;
+			cleanup_tx_chan = (assoclen != 0);
+			goto aead_dma_map_src_err;
 		}
 		src_mapped_nents = dma_map_sg(tx_dev, src, src_nents, src_dir);
 		if (src_mapped_nents == 0) {
 			dev_err(dev_data->dev, "Failed to map ciphertext src for TX\n");
 			ret = -EINVAL;
-			goto aead_dma_prep_aad_err;
+			cleanup_tx_chan = (assoclen != 0);
+			goto aead_dma_map_src_err;
 		}
 
 		/* Prepare DMA descriptors for ciphertext TX */
@@ -1030,6 +1033,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		if (!desc_out) {
 			dev_err(dev_data->dev, "Ciphertext TX prep_slave_sg() failed\n");
 			ret = -EINVAL;
+			cleanup_tx_chan = (assoclen != 0);
 			goto aead_dma_prep_src_err;
 		}
 
@@ -1038,12 +1042,14 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 			dst_nents = sg_nents_for_len(dst, cryptlen);
 			if (dst_nents < 0) {
 				ret = dst_nents;
+				cleanup_tx_chan = true;
 				goto aead_dma_prep_src_err;
 			}
 			dst_mapped_nents = dma_map_sg(rx_dev, dst, dst_nents, dst_dir);
 			if (dst_mapped_nents == 0) {
 				dev_err(dev_data->dev, "Failed to map ciphertext dst for RX\n");
 				ret = -EINVAL;
+				cleanup_tx_chan = true;
 				goto aead_dma_prep_src_err;
 			}
 		} else {
@@ -1058,6 +1064,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		if (!desc_in) {
 			dev_err(dev_data->dev, "Ciphertext RX prep_slave_sg() failed\n");
 			ret = -EINVAL;
+			cleanup_tx_chan = true;
 			goto aead_dma_prep_dst_err;
 		}
 
@@ -1147,6 +1154,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 aead_dma_prep_src_err:
 	if (cryptlen != 0)
 		dma_unmap_sg(tx_dev, src, src_nents, src_dir);
+aead_dma_map_src_err:
+	/* Free any descriptor prepared on dma_aes_tx but never submitted */
+	if (cleanup_tx_chan)
+		dmaengine_terminate_sync(dev_data->dma_aes_tx);
 aead_dma_prep_aad_err:
 	if (assoclen != 0)
 		dma_unmap_sg(tx_dev, aad_sg, aad_nents, aad_dir);
-- 
2.34.1

