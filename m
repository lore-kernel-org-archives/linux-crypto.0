Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60534CDDDF;
	Wed, 30 Sep 2026 11:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790767610; cv=fail; b=A1rsn6yCTzkwoz+qFu/XgozWfA+x8or2KRt0qwhC31d5ToEbWSvHcKYOQEntCqzymTDBxMzbCcq5M0R6qzMhOpygOXWeKfE9ep8zIdT415nI5Z5J2DcPf5tFbCjhFAsg96jgzxpAIxk39PCw46knkMElfTOh4a+Yeys/wm2bQ0Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790767610; c=relaxed/simple;
	bh=Fz6141O6onZO78SV7cw1hoqrEuLJOiXK6EO+PyIU2OU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N82Hv5X0YmFBhtxnY3CujoQCg+ebfi+u70GkSH551zPiEawitNC/fiBJRBjrseCXm85TqR7h7jfhpi5g1XO/DYK68bWa2pkGCiDEO237EgAcYJxft2+KE+A6dw78JfJSOmADRJ/gEIiGkVjtSDny4su2b8PW66LcPJCLopl4xEU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=QdP6aFSK; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=EfPXuZYh; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="QdP6aFSK";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="EfPXuZYh"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68UB69Zu2715438;
	Wed, 30 Sep 2026 06:26:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=t0WbCSWTB0HDYtz3eFDQ6ua+13hjlle1dIefZT9sX
	PY=; b=QdP6aFSK3MNrstaUPr9buBPdvWurIHgoQ18IxfE/idjaq4rZjmmgl1al1
	pNvXdq48yVbBit/2M/oUrwJo+Fqa8T9icYMdiqnGXtO0/E6VC7YdoNnSlukbh3TZ
	PnO/WvoKsH/7dBW+5lf3NwoffHp7kTsf6wuzY5NxDlcTy3Uh8ctN6EMo7vl+PYOc
	EfOeR+di/v0P0PtS74BJi/HiOXLDiGrJWTHhJHunsXrlMvZ7O6OidWxfFnBoW0gG
	2efFnGVwM+oB+SZV5SZYiO9diqdfXZr2Wt8GUhivDhfymDJMPa3YRXJXGpm4w/Bi
	eCkuNuYdeLzNNIx2a8I8JfkBeozEg==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013031.outbound.protection.outlook.com [40.93.196.31])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4h0m9fcuqv-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 06:26:39 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tFVy0TrXy8VC9apRR6mj45WU+K9CC51yv8yL0UQ5eH/LftF6tl3k5pnW14XoFu9kq9P4JSv0FwaGdlRayw3LFFbXCTOBLww1iayyScTU5nb+1CV8ueLaSylg8/m4cMg2sGfm11b9BzNk4DTcupNmLbdsgOiSM4swk2+GkcOSv7RtgD7pgr+mszz2OGcFO/18o6xe+gLd93D19A3y0N0U3ipQRmuqN1YcuwBOMiVb7+RPpcIIoYd2/JEAGFuoM58Dyyp8ln5FvCIcHsYmwdqWtaf1zJhQ2sF6EARVmDSEJjNpoW4YYdmdTWVnFMCmebBPhGVLgGarbR/i0VeBxPY0fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t0WbCSWTB0HDYtz3eFDQ6ua+13hjlle1dIefZT9sXPY=;
 b=OQum610Bol1WukqugfpWdozHJY4VOeEGoguEtQ7LC5eISGchpgOefCPFx6GDz/z7nGqQeaqIiR4HCkx1Di8gnlbNMLgWFQTpWrtYVozVuhagw+kS2lfs+G91vDgT3Uj4tpdVlpnNhKqijskimqF5UfFr4q3YQ2JjhEzEVaaup/3u8VKCaLz8il+F9jdk9smd8UQJLxwWLOj/VEAYxMn7iB5fEwOoUWZpNAInvYSR8dN/Xm0OBDoa7yJI0T+UYGajrIIrQUNN4xJEaS7yrW5m6wEHy1+KUH7Z/1LevdO412LjdeH8YQndAmgqn/T4zIbWVKwaHRKqS8MIACpRSt9dfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t0WbCSWTB0HDYtz3eFDQ6ua+13hjlle1dIefZT9sXPY=;
 b=EfPXuZYhhvwK14Ue9o+h3isebW2zg+CvntAEt0OPD7DjCD2cmbcr8IS40pAAcgNTGSlb6vMkz4XmXgk1dNVL2tmJuJnEGFcxPgh06Ij6BZ3zIVS6IIiWVohG1NGreHUcxA+KTOqLa5LYVHn2qhqkSU7f13tFdnXyZI25tgyH62U=
Received: from CH5P221CA0002.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:1f2::27)
 by DS0PR10MB6221.namprd10.prod.outlook.com (2603:10b6:8:c1::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14; Wed, 30 Sep 2026 11:26:31 +0000
Received: from LV8PEPF0000005B.namprd02.prod.outlook.com
 (2603:10b6:610:1f2:cafe::49) by CH5P221CA0002.outlook.office365.com
 (2603:10b6:610:1f2::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Wed,
 30 Sep 2026 11:26:31 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 LV8PEPF0000005B.mail.protection.outlook.com (10.167.245.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 11:26:31 +0000
Received: from DLEE208.ent.ti.com (157.170.170.97) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 06:26:21 -0500
Received: from DLEE201.ent.ti.com (157.170.170.76) by DLEE208.ent.ti.com
 (157.170.170.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 06:26:21 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE201.ent.ti.com
 (157.170.170.76) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 30 Sep 2026 06:26:21 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68UBQKio3025665;
	Wed, 30 Sep 2026 06:26:20 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 15/15] crypto: ti - Change lengths in AEAD to u64 to avoid potential overflows
Date: Wed, 30 Sep 2026 16:55:33 +0530
Message-ID: <20260930112533.1593952-16-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: LV8PEPF0000005B:EE_|DS0PR10MB6221:EE_
X-MS-Office365-Filtering-Correlation-Id: b790afd5-c055-4a3b-0f17-08df1ee5ad69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|23010399003|36860700016|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	l1lZSpggxh1nwmQlJ1XtWwGTELdPa2n1zzpzNlE65mzolgi49xrAeewhNKorRlPVyxuHUyq8TNM124MzFPfGcmpxrxkti1CG7VEAWm4PEz9AXoy5cWVKRMZ4PNmmKLyFYIoZJoWVTWnPu+V02vhL3JnggMzPM8AIpWZ9j65mLJO4K5oaGxFsWfRODiDprCXyPVV0mtNafIa5V/8u53EJGtpVQLAfuic/6lbfLO00wTsIDmexD/sqb/lA40Vgk0ajG/c8kNaKyTztk/Z3Lr8/VBL3W1T/CCfB5Wgi2eJAiwZB4I2Un115EUuu2Qw8MkVd6ZlPMly4v0puq53zIUJqEepKC4+/ZhlcM7ICQ7Kbl6GgirlgDIMaBrSQwik28iZN/MlTkASIhWpRI0BsmPyRqEKQmkRmykuH05dqCC5uadBcIBuQRQriq424vszRExs0mtnF3XcZOvfnqGtYDFS7CpBasIXEyRB3GHtkfkkbzfgJufxzQkmDLtzxUOQdi9x2/jBkPRI1jQ30lyLv0NuAKdNSIInlMF/ZHO+fXJthz2GKSCh3xu5Kq4+WQnshj/wneMTIgHJp0f9zMcqfXxzAR1Pu07S4A5S3TFAZ6yQcJGaQY36nUEkx+ffbC8G8pmDRUEtr4aRddKEN8r2HINHfdTCNZ6krNE6cd/0fDtueixUqC13M1Pn4v+7jIEkHoOcUiVcysKycV8GoNJoS01V6yQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(23010399003)(36860700016)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	l+9tlCI0TgEvHY6M6D3tgL5Ey9ua/+8kTJxqHGCQMqk2r5SUGyPtC/QLrPZHYafzrijqR0ujqGrx1Eg8j6K9b1n0/ktQwdCNwY5ydGv8L66FhPz/m9uErVB/S7yvNH1t2rx3i1/ZkufdHI9yMH98aHUEpMvE4f+wj0Gi9UDhOXq0ej989ebxG2HIahVbuDUPet9OslmELl3MWHGuxvMvog8gel/Ruz+w1pVE3m9u5huLH84TNKKsm5Y0qXTVVuCan3+Y4IaTuM3fFQ91YylOlA6D2tTBBK0zc1a+IuYO/32L6hSaXuv7hBXvkHir5jtbs6J0j8CfC9xC61yZl4U3pnSeqG02zuUNCO+aklurpiRcLndyXk+TXW6Jbuuy9oFxKLxrMbeb/EZrXJEwgJQ6wMbOj5y4v02qKV2p6ZF0hREck2FAnIVvP+8g2GhgFgtR
X-Exchange-RoutingPolicyChecked:
	q0yQ1X4lfbbuMJy07QIXlA8NCYHyi9PFjoY/Jx79+FGRsSdDtD9co/rOaTBvn1clqWETcD5bgE2g62KQxEP17KK8gLdbB+FUvxhEiNoAe07QPmxThEWUlUZE5RCPhAoNVahRiPZV/g8Un8XBIVX1AUm1UB2gjYCjakW64fE4mn8S8Cty2/m3+WU6A3QyIqtSJoorirj4p+xEmndGaj5/FALFq38by2jx1Qaon6Yf19kzi4j6DNR/ws5D2J6B8JCsz4QRrDi5JomiVDtf+foi83+hUpBZZQT5Jbgi6YThvG+pbTCFZ5TySnZ0V7QLWqqnPX3FNTAunqzpcEWU+kQ6rA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 11:26:31.4415
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b790afd5-c055-4a3b-0f17-08df1ee5ad69
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF0000005B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6221
X-Authority-Analysis: v=2.4 cv=VfRir1p9 c=1 sm=1 tr=0 ts=6abcf1ef cx=c_pps
 a=GI5TgwD/LrSAXmlNZGMSjA==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8 a=rGLHzWtdNaH96TCHXsUA:9
X-Proofpoint-GUID: wJoNKS88ISoZ67zsCzvY1hGOsfdioVr2
X-Proofpoint-ORIG-GUID: wJoNKS88ISoZ67zsCzvY1hGOsfdioVr2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA0NSBTYWx0ZWRfX3ByQ+hw9QK12
 eHX/rD7d5BklcqkjWnPRPXIvvIbu7Ht/EOMG8VdOCtyHJjYZEoY9wQSxI4Tze7jjBp1M4ZTzL+t
 EBURH0xmNno7kJQ7x8/x+ljfduK4ml/vpwnB+6JZcFxp2aUUJLIHKVPo/AMqCYHtFDm24GQkD9C
 uzx4vGbwqOuaKDimvAuEVy7tZcNiciihgCN2zZBYSYc458TKukXG6vB+u/1YT6r7cZ3mI/r4lEx
 jLis31d/d+BgZ1NCOGGeZ2EEECD4adarfK21Eu3unesDzFigsqMKJiqIJCBdJOOZk1Fqqn+Q3zM
 YVcqEEUcZ2Pk7nSGrNv1BMyYCDXtPDjr5TvgDSdqzW5iWBtCx7QUU+srEkhvBirKwjKGtJCWr20
 3bBawN4Z702RbM9mxkjPe5X/RmhPTuGRGG3DjwDjR6cP6kyAFr5ZQ91eGqwrLxCqaSsfU6BKql+
 GDLWt9z+D/HV5vfDZuw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA0NSBTYWx0ZWRfX0TJ4G8W5p+hV
 HlQOBCeQ17ZpLYWPfTuXrL8YcLq+XMzHIIIrQg6FzlgP0lTnSbcXMBeBK/QTExfZfy+8PvASpas
 CPa7QBw7dv5/0k8hna9zmoUGF7oNyn4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300045

Change assoclen, cryptlen, authsize from unsigned int to u64 to avoid
overflow when they are added (in TAG offset and padding length
calculation)

Fixes: 37b902c603042 ("crypto: ti - Add support for AES-GCM in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index e141ab8980000..2d7fd335b770c 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -758,6 +758,9 @@ static int dthe_aead_enc_get_tag(struct aead_request *req)
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 	u32 tag[AES_BLOCK_WORDS];
+	u64 assoclen = req->assoclen;
+	u64 cryptlen = req->cryptlen;
+	u64 authsize = ctx->authsize;
 	int nents;
 	int ret;
 
@@ -765,12 +768,12 @@ static int dthe_aead_enc_get_tag(struct aead_request *req)
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
@@ -781,6 +784,9 @@ static int dthe_aead_dec_verify_tag(struct aead_request *req)
 	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 	u32 tag_out[AES_BLOCK_WORDS];
 	u32 tag_in[AES_BLOCK_WORDS];
+	u64 assoclen = req->assoclen;
+	u64 cryptlen = req->cryptlen;
+	u64 authsize = ctx->authsize;
 	int nents;
 	int ret;
 
@@ -788,14 +794,14 @@ static int dthe_aead_dec_verify_tag(struct aead_request *req)
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
@@ -889,10 +895,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
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

