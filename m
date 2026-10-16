Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1CB4A482C;
	Fri, 16 Oct 2026 12:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154794; cv=fail; b=AldlQlCG0L/2m9+2UMYPLBZBt1LUe6Nd2mEyLf2T/i0d/QDebazkzjgHvzITL6RlegvUCRJ84K+HO/e/gcdLzLGIxHBA1UWPrEqCcQucQVsDYC4pSHUyWZ4DQmLCmzKT9wurI4Q9q+5Ri4uQETUaLEWMOnyyEEJapPpwTW/KtM0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154794; c=relaxed/simple;
	bh=Fz6141O6onZO78SV7cw1hoqrEuLJOiXK6EO+PyIU2OU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YBwcDngIH4t2zrglDjBhufwcnip05vj5/izJ5zSr0d3YZ8NMRZMXi9s3w81o7w5ghZYlXkBvZhH1rsllyzNWi3m2WsfSTYNrnYriQCBhm0clLpXCqK8/TG2XNxk0khR2+MZu2z2QP4H5pBBfELiUfzfU/DmaGH23q6XSqNuY9Do=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=CXCKeAu+; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=MKyJW4fc; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="CXCKeAu+";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="MKyJW4fc"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GAD0Jg4171219;
	Fri, 16 Oct 2026 07:46:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=t0WbCSWTB0HDYtz3eFDQ6ua+13hjlle1dIefZT9sX
	PY=; b=CXCKeAu+VSG9qQp+qEXNlMowbSxhvhEaVlzDI+HxufVwm9H5zGBE5VWsM
	5OQjJ6nai0ZiQCTPPDw1ztz4GerfXHMqAEGhxwArBfy4kZ1g1/cXAnL2wKE0P4Rg
	qEtKpRcuwHarcusOjG7YUgvo6C2BXfc8SN7GjM5UJpXuquojThOsV0Xp8gRgbLmt
	XfP+1NOmqYcHEXIDvtspyeyHn98ypYkzue5XB1GwR5tuAwBbjsZvWX7gwH8cvK0S
	3+W07eoeaoKfDZX+chPor4yJ8OwmRwOfaNHctgMGlV+n32cwa3Kg6fNbe2Ue+VKv
	FRwBl0Z+3QUgQX+QW52wqq1tPP/Lg==
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010051.outbound.protection.outlook.com [52.101.85.51])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hbhanrubr-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 07:46:27 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YPtLBmcTUN4i8viLtva72VNwDqsQ5kuvr7u9bJHHGwTjtVuuwb/gwTa1wSrn0A+6w+hGKT6pd0XpQtiBRTpj8+a2QSMeXrhV2OXBELPiPnK6JtLk1U+nRQ4n1PFezDNk4WnyPNddjeJCj7a5/W3eVNAw1Tht+jdsKa8NPBk+4J6jV+8SI077n0/J76A4CPC3wuLlSLlP58i86XgzfLk1s50FCBSfOlEJ59XN4ucTlup+f91P85MBqcFfZIsikryaWX85zz9b7IW8lNIh+iWqidprn2BJ1rfQ09TNYiJDyJZ9yeyz45nNWERVWnCz5mx3Iu9GQSk4xJxdR9qD3JpbZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t0WbCSWTB0HDYtz3eFDQ6ua+13hjlle1dIefZT9sXPY=;
 b=Qx6fmYmKx5kUCOAUrYwCnY+NTX5XrzLX1clZo92gGLHjEIn4w71It3FUooGQ0twjlmmnSNB0VLFKdmYiMnlGAmmqrRJSwsqdPSuAM7En/S9v0LqAyjBsU17UYL5PY1EuGyqdAjiqOcxoNO4Ge2xtlpP2HMkPnCd1ZCPv415l2XG4mfhQjeVIFX+yJcX25LR7xoi9Vns7PioKFWMKt/7brxnOZNuzgtoEgxhMl51nRGJu3B3Z1Arz00QJmhN1rfkbHJ6CFOH0OO4xtLusovs0Rz/MhplMDAQTlIjZyDq1RCblWiwpZ1+wvR8yMSBEw+ehqbH1OS44WjvRAM4NUHqKBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t0WbCSWTB0HDYtz3eFDQ6ua+13hjlle1dIefZT9sXPY=;
 b=MKyJW4fcpvhvp9rPYssIp4KVoLCo4oMdqSI59noGinDp+RTR/5VMO/i7mOohR4fxBt+B6C97yNhrzmrlJcvNmf36+gtegPaypAZHY4dNOcngMhcMrRl2ka0VS+8Kzja8NDJLjdD3aWiZTEa3h88jS2gYvCvCKokhOzIFmq86ylk=
Received: from BN9PR03CA0937.namprd03.prod.outlook.com (2603:10b6:408:108::12)
 by BL3PR10MB6090.namprd10.prod.outlook.com (2603:10b6:208:3b6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.7; Fri, 16 Oct
 2026 12:46:24 +0000
Received: from BL02EPF0002992D.namprd02.prod.outlook.com
 (2603:10b6:408:108:cafe::67) by BN9PR03CA0937.outlook.office365.com
 (2603:10b6:408:108::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Fri, 16
 Oct 2026 12:46:24 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BL02EPF0002992D.mail.protection.outlook.com (10.167.249.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 12:46:22 +0000
Received: from DLEE200.ent.ti.com (157.170.170.75) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 07:45:53 -0500
Received: from DLEE206.ent.ti.com (157.170.170.90) by DLEE200.ent.ti.com
 (157.170.170.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 07:45:52 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE206.ent.ti.com
 (157.170.170.90) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 16 Oct 2026 07:45:52 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 69GCjpC62531896;
	Fri, 16 Oct 2026 07:45:52 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v10 15/15] crypto: ti - Change lengths in AEAD to u64 to avoid potential overflows
Date: Fri, 16 Oct 2026 18:14:56 +0530
Message-ID: <20261016124456.1802080-16-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992D:EE_|BL3PR10MB6090:EE_
X-MS-Office365-Filtering-Correlation-Id: d7bb03e0-c710-4e89-e72f-08df2b837c01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|1800799024|376014|10067099003|22082099003|18002099003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	vgbixFQmFmPj5fbzLb6YLM9URAwXtjN7e0a5Y/jMtIMHKLzdiT9X419hAfVZ/b9ymxxR+c4xuQzrQSIVW7oAPK3aV7YEZuEk73uPdbCq7VAknWdGsjsXx+BSwPv0+4S9m6JDeYtTFSDS/HhFXb+bGb7i+4ny7BAInt/Sej0v5ac0rVVGEDLt/HJl9uQqJNLivxIB8lMnjG3AdSPLK87e0qtfPRMo0Mbr+dVvqDF5v8ucs8RsSp0KINtrbV4qt5q8BM24CZHm3zSKKJ7gXxMH7wv6W4MRbQEMrZv+JfgZZbszhW541ftGitLR2l5J8TWW8K0fVcqiB0Xp2X82hDAYJZQyXJFYvjd5msdqwZ0LElkea3HlQiCfPwU6Qu+vUZrYPtdAam1I/hGw3uEnvbqO0DGPDWSBO+qIFR3GMJ8+wC3TPAcZ4Mz+tzT1rxDLg13t2FjXNSxQP06Ways0a5qJQKHfmQ8vvm1NgNFBdg3UkyBJSKTOr5GlQyPHR9CrZFxaXQqS2IpF7xwd/p6Bz+7yiV0qVeFNVoZnttSTT8pFnux5yymAQinndgmU054n1iA3RhTMmnQFuhXIK0LFvtrvXWE7AtvCKg0L4L1vLlVdKC6tooN2X8UlAK9URnKF9hxpEN0CjpMk6l82+kZW7W9k8XvH0eWla1qMak8Dol4eO76kQpzTi8zM1hqxpieD1AhvMXSM45CuEvhsPszoUDb4AA==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(1800799024)(376014)(10067099003)(22082099003)(18002099003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	o2kLwWUUOyNAlLOxTR0Nn+QNkW/Y2L2jnkfi+gxonq6u5ZeEyfrd4f/g3tjwmpZGvicWKd4C7ZuCrOSwWW1JO2skC8/Njb7IDEaJq/jEVWOUrH95mNqMo76VVOQRrB8brDaocMyJ7jDsgXWPOq2Zg5Uqh2vio7l7sGWU3shS5wDdu9OfyhQYfsyeI8AGkW4rPfLCvWqDcOpdUhbLfkJHuikez16TxEowaXQlnoM5YhlKoofeuXBvPAQHHKgvNcJOTjRcHZj/jne3czfPGWWWEx4kaFqDF+hSZlnIQ5NKOReRMS9ycVzmnFJnWoAQpWg/2nhMvh8Ig+SpkqfwEfaB5WXuK0oZ4Ec+1yGjEZpceLANQIN1hfvPUGblkE2kyY9J75dATdFxfYkxu52XHQgTzG9e+o6UPv9c/tNwsglzmMi+yEuK8nwcTbkld9mHPK2e
X-Exchange-RoutingPolicyChecked:
	xwG/JWHXmvhhIwEY8+R4laxt9QlPPFuZPtLcM5mIGxAmxhMfonKHFzGaKPSDf+3xKg5drfxi55ozSVaSddJT2W9rekVuvrJ2Fr1FcgeBOE2MMaGuBSGlFXPO1AIbUg/8GanfXZhM1ikt5L7Y4+inWFziOT6AxQAmPB1GgO1SYEFJJCqktXY6s+M9ttFQ7NERJkK6BtmZ6O5j0l4Y+cPmzn89raDxc0VfmTkDGo7NOwlNp4+J06vs9AWWpi37aDxO3AJAXY5d/kAvazXPks53SI+ujp9zmuv325xrCl+OHUMOiCPRJa5OEIT7o5dlpeospace9BT1Ho/r5/6LCSOgEQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 12:46:22.9851
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d7bb03e0-c710-4e89-e72f-08df2b837c01
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6090
X-Proofpoint-ORIG-GUID: 0iqGCkh77cIyfetnOAX_tqqSUPK-_6Ti
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA1MCBTYWx0ZWRfX8ptdeuaDZVae
 Y/Usz8EffB6F+MGzhxQE7qvpdFsr4aGBLNTet7PKlcxUtgtV1I3sF+VqPrRbtL6ZW7kfH6yLOsC
 wvqOMZotlgOPNDE/9fC4b9LDx8j6zDEEDPgrLKDr7ofcIjPwyE8mrJ9Ihn0o6kGJuVcU8uHf5Tm
 NmDH4k94sBp2403HueNM/wm99CSSrkL3anl73/q3fUoJ8ATkp1FcEPvOAsz/S5Wv40wbcTZ/bWr
 z9a89FvCwP/pFZ/4Nu2q45zcwihlFhjPutZjX24S4RXQicxeTy66nBMDYGda767gq1Miiz01vUZ
 Hfx9pcKXl5Z6q/SCtTA/OBNoRHOabA+tUstgMj17lTXqOrFcQa4+5vvYvvhggSJfOi/R8hpgFkb
 Dc6JYr75dlKiTkrIiXvRRdjAC1N+9/bm3P3Aaj8T4ZjlNYM/oNFxuIHFCdvZSfiLVd4FUWkSjDC
 TNDLXbJQGyrvMasw5oA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA1MCBTYWx0ZWRfXy/qp4eYRMGWQ
 g4vDqbVU48LCHHwQ/wnrMjgvCfSJl5s1bQ+9T1HWesbn/wlwPwEXrZvW+Xt3HSvWorDdX/gmIxz
 fXiQl7rq/Yf+e0Fpa+33ASRNiSgc1Pk=
X-Authority-Analysis: v=2.4 cv=NvhE4MdJ c=1 sm=1 tr=0 ts=6ad21ca3 cx=c_pps
 a=QABtpIB3qQ7RK8WoHHm5GQ==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8 a=rGLHzWtdNaH96TCHXsUA:9
X-Proofpoint-GUID: 0iqGCkh77cIyfetnOAX_tqqSUPK-_6Ti
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 spamscore=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 phishscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610160050

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

