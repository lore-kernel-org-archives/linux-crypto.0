Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F664E9C26;
	Fri, 18 Sep 2026 10:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789727060; cv=fail; b=ba7quAmK4UNMWvQZsNSV21NtWVmMGPrE3L7usZCiyf5fUUWndUf9Me5Uy9fOzzlSlVBMik6i/Au2c3nuxIh3sQlJWVlz3JcfZ+PEH5hKoSCF4pQ7yO5pXYQEXEsEA3Kzklp+2b9telH/MTF0TD1LjDth5ChWTOCCuullB1bNwQ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789727060; c=relaxed/simple;
	bh=MmcuVvXYaMjero/AwfUHOm7TRDKEXBVAlucY5yNCKhc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rXbBKikm2+nckecjyoeOUmy7cdcGFEVV+rB+jaNnyJLCJGNNy0taNd099gTpFSHsRlPS4N1D8Nn9NuJxe7IgdD/Qm0efmKCAQL5yxbc7N/eA1hrCsGvJpRGPMdsgzpNUUTclhIQQGxCUwBaY3WHzMtWdyCs+7GM2CAeDg2+I78Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=mTkR5O1h; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=L9yQaHRc; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="mTkR5O1h";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="L9yQaHRc"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68I9d91s1233779;
	Fri, 18 Sep 2026 05:24:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=PqnJREAsaDSaK59bXYGlEMRqdohLFwctOvTZ9KWYh
	A0=; b=mTkR5O1hMesHaOydy6oBhv7fVTJWgn2AWLIxVj5W6xg45Tt21HPqegz3U
	mp00rXuu9ClFvJmuCm9N4q3hcyw0uwQq6YpOFeCK43Y9f6iAQZcBKhg4XD23tcah
	d/FgHBNuMIJuTUpeQ7MX9TtFhKPKiPhdc4Nhk6VsycggpZaYYM5v8Gkr7oOvNQnf
	QUD1eYfDFLK2MLrGbkx0LxhfsF5PLoiQfD+AhMBb7rkfQysoacgv7d+VKcItjATk
	ktwpPCZSlAFQ9NQkRBOfIEQk6EoBcwtdgJ2OxmBVpK6IxsLJP7mcGDcR55TUGMuL
	UYqOb6LkMmd0c9nGotgWyRanWdM1Q==
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012025.outbound.protection.outlook.com [52.101.53.25])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gs2ux07ew-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 05:24:16 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uyIfMJTu2c9652bsfTtGMYhaOE/krbWFx4Ayl0XwyLT0xMHR/6xbTo9v1uv9wmZe5jBOb/IMFdt+rfk1u1oS/C4OeaVpe5P9cCVX71LUghCSOH648t5EqrCuCApv+7zHUJAylDiRCtvIL/RhtYqWBH9lW1R1rablA7cWp4579Bzix/veaE4fMWSCn4makN8zKn8I+nCn/kNCvnxv47SnSSNkbgN8HTdSki+CTP+F2s8nkMrWBdEMHyllFbT1qGQ9/3dTo2E515oDpk8GoEr+FKgDOhvvKMdqAc7eE8d7FP7mEJBaj92yYMTiMloQXKl5Odbi7fyUhpiLbuTEwn+hDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PqnJREAsaDSaK59bXYGlEMRqdohLFwctOvTZ9KWYhA0=;
 b=YcrS1qnG8RVbl2lNmONQvvT7Nw+10prayP5a8yFhpI/337W+upqXMNHv7YUnQ325Wllk+A+H95lF6u0mfGXWygAhuAzxGwWktNFkM20U6Tx48Vgqas14CbHM1QYxnl59D071eukrY9tf77rt+FgA4VOJ335F5WfpyCYL6Voqlam4iyUacOFcia5plHyF0JRu4nXGx44ZIsd5R2FxFa8vfjdZn/BT1H/ATcg5m1KVCNkLp0gin+Ppx4gIQu29YnGrqD1MmfnhohNyljB9bezhGtWiQaV5/ZkX6PzgSDKPr/0rM7vk6RKyyQiDqaHv1Z7keork/mtDgsELBLK2ZxeYAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PqnJREAsaDSaK59bXYGlEMRqdohLFwctOvTZ9KWYhA0=;
 b=L9yQaHRcGWXaZcXoiK3KjsUt9/dZlWLoAhjPh9wj8e9Nr51ubnvpW5Dx584Z7PhRYhoIAcBp7Ym7Dbdv7/ga76f7Df0rq6fjH2c3dxnaoIRwyQHV5hopdCD2tQGf5LF+shyi2kAX+GdEGdixFtlB6DX4t8OngDriqxj6ADEMMWY=
Received: from SA0PR11CA0011.namprd11.prod.outlook.com (2603:10b6:806:d3::16)
 by SJ0PR10MB7690.namprd10.prod.outlook.com (2603:10b6:a03:51a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.5; Fri, 18 Sep
 2026 10:24:12 +0000
Received: from SA2PEPF00003F67.namprd04.prod.outlook.com
 (2603:10b6:806:d3:cafe::63) by SA0PR11CA0011.outlook.office365.com
 (2603:10b6:806:d3::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.12 via Frontend Transport; Fri,
 18 Sep 2026 10:24:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 SA2PEPF00003F67.mail.protection.outlook.com (10.167.248.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Fri, 18 Sep 2026 10:24:10 +0000
Received: from DFLE210.ent.ti.com (10.64.6.68) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:23:33 -0500
Received: from DFLE208.ent.ti.com (10.64.6.66) by DFLE210.ent.ti.com
 (10.64.6.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:23:33 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE208.ent.ti.com
 (10.64.6.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 18 Sep 2026 05:23:33 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68IANWOi1534932;
	Fri, 18 Sep 2026 05:23:32 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 15/15] crypto: ti - Change lengths in AEAD to u64 to avoid potential overflows
Date: Fri, 18 Sep 2026 15:52:45 +0530
Message-ID: <20260918102245.2784000-16-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F67:EE_|SJ0PR10MB7690:EE_
X-MS-Office365-Filtering-Correlation-Id: cfbfb855-1215-4b9b-c7e1-08df156efaa6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|23010399003|1800799024|376014|56012099006|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	wWXc+21+aNOn2CrFpubB0jsSQ8ckZqoQMrLfCMHCMFKvDLtssMkUgN8zychI4rwykFFjds/XftiQujwK9Pk6RATpNB8hP5TD8FIDbyJdAbIYPBQ1jOKRgiHEJjjI1J1jirvY2ZcVtNjYS+mfDF3dq44x8+IN49GX5JGXSa4/MbtAjl65AAUn2KSiOhhdNCZtvAgtqUlmtPqGEvgNtOPMPuQJ3ntFkeHT2frBxa3aHUyr6vuUe/yCb3m4/uAeBxV+KjTBytbN89rZuh1Mxvmk6uX4s5dvrbz9zb4qCeeaZ7Sjaef0Gt5pBnHLlHgmUdz6Y9wV1axe2y4AXudGBq7rs6c1yKAby+7dDGpEa1D+JC+eWAvFU9OApKXKEamqlMw9adxJWR69fCQMNw0Xx9f7YGORyM0lURr09nPUT80BOuBetJYYQ0Jtu1uOXZwuEzQsI53lGH0oDNYZM14B6a7irKbVY4QAhpPEGRnu3PNBH2Ra/NfCc7X057QQN4OYgkgTizaZQFXrSodiAhjdf5LyR3qNnBGtw0v2foHDpDRC50xzKXvhlq0v4ZECMY+zeH+tNq04emUSLE9qPaSdObBTX6gufoZldJYOrbR+VARtvXE1/kRoHfJ/yH4fVGMvw9O0FvDjTnCA8lJwRIg6DUlqIIB/EMImRwGEqPiLt/THVQMiEQXf4DyfrJUiTAtSic+9OR1fyLzuJ+68zS5vdTE0fA==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(23010399003)(1800799024)(376014)(56012099006)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	C7ge+P6J9cw8iVZD0LyJVHdn22SMtslsg7FcOVDVxz3AvienD+6oxedZ+fiHDDGbogLcG1umOZZJmttrKFdEbA00WChuScLI2C+P2vjZjCsJfpmAAIaXWLXf1wZOV5vXHjPzKLkciV5Z839qppPewP8p793ufrL0OiwhsmDVZdldtjn/qH+6wMt216zxaaW/4eOPIGPHbHbYPwyfraqbEn6wt5joiqCNmc9rbYEEYt58FyYEVLccoo/rOmhiVikxDqutoyu8HGpmu732bbbENglNVetTUQ9Z83pTK7ej6v2kxh+hhiT/+wrL9VO/QVVQZt7uDvnKy6CxmGNdpAaOniwaoNy7RhpdQPycDJquWkHsO3uboqfMQsazTzikspD8sH/7CThmmv9JWqpz4TYlFJQ2M7hIg7IeavV018eMj0ZITxWnwsxG/a9kEJ1Z14fJ
X-Exchange-RoutingPolicyChecked:
	KpwX7I3rJ5w1VnMJuBXdSLff0lJ8uiAnMhPDqEiLvVBOq6O7xPSJppG9Y23Jv2qWMdmxGT29lAFrqNbFrACsVcWuy4Z15oyBA8E6C1aN+FBbqlicDsW2AGNmU70tJ9YXeQ3NhTv4J49OIlU/11nz/XGZ8D8DNOjomFD1Iq2YwmtZEna/DXW2MTzwjcSGzSxcFB0Wd2EP4ScseIDbqFjU337tA1KMs6sUmu2QegpkLEgtwOr2p0XtRwgwz5ZW/DnJd0+1b3D6W2KGY0U4a+zTulY2yZFwLYC+wprqHG7xX4twLRd7QBJnkg02cERJ241LDaYNm74PDhNfwwXOSL63Pg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 10:24:10.5027
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cfbfb855-1215-4b9b-c7e1-08df156efaa6
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F67.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB7690
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfX0sPRZ/1rORij
 FuU5M11+c0B5KMBuchobE0G1lVbwnUY1JJfEWn8e0TbOkkDBdn/fllC2pW9OIvlEU5/08xEeLv4
 A/tUAQJYGf248bPmbtL6kzhlb/kjwt6INlU07vx3gqyIX32yZGkvFgfl6nXTwKzGbTFJ6pvUAQ0
 D4XGl3Px0OlbT3aMO8uow6/OUcuJW8KD70tOptqNLhmmOVzzNl9KY7osoyl7aRf4JX5PHzJKbqy
 iDPzjOnxpBby6OQy5xoY6JBKrTZHdRHtZxKMmjjFGqcng4APolUlYlOQ/BmaTJi43cnqem9KMaq
 JegthX1dZ+2g2miBfvbSUNiULF+TOMJEYbMpblOYAONaU/tTvC2apIpZel8u5W7gH5hTEdFdBMe
 csaE4TJP0JklWXaWDt9ID9MenDtF+hD3ST37DXN11h0nXhytdCpeHwIhSzP/VeWgujsiSRdO1UT
 9bicuns1IyvozgWuGHA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfXzqcddPKdI7AS
 9V/0LUuISQkpUleY1X9McTb1G0utJ00guTvTdFywOSDY5w5hgcbtBbwC6LcURt+5sMpTZtxk8Gk
 munKGk163hr9NEWmLgY9l3fMYE9NOR4=
X-Proofpoint-ORIG-GUID: HmImAOYihCkcQTRFmBhReust9lNt8lk6
X-Proofpoint-GUID: HmImAOYihCkcQTRFmBhReust9lNt8lk6
X-Authority-Analysis: v=2.4 cv=adH0Dhot c=1 sm=1 tr=0 ts=6aad1150 cx=c_pps
 a=DkeX3LL2/Oc4yJO52xFMkw==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22
 a=sozttTNsAAAA:8 a=W2mYDkbPwZfAYNH1kz8A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 clxscore=1015 spamscore=0 adultscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609180144

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

