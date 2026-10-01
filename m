Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB20C47C10F;
	Thu,  1 Oct 2026 08:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790844815; cv=fail; b=lrlTe9BvfNy09AQQQECrRI1/dqyAKUqG5pIJ/ai+WvolhuSDvvecHM5UkW7IT7PedaPtQdrfXn8EG4B5jnTQGPJX1bOb1P6Ad5ZFTuCGopK4XNeA/0lU+svTbtupbrJWYObiyAESx5FGVwlaQI+wPIG1IOqffAx8s9qLBUKfJ3c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790844815; c=relaxed/simple;
	bh=Zd+YFyNQlDgh9XjZ8Jbmlxiyyyvl7EPV0mQcbY6y4h8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k2tU2FuDwCQz+MboYUNFrhk9ir9GEYLahyZOzQ6I2FlUntlog/4903RGjLhgVZDOvzH2yjhZ/TCDic0qZeajvEsDWT3jXohZscc2xGB3+JsLLJXDUM19ZfM2YmLQ2TmWq1Fv1qA8gEl7wRD17SYujuslH10MuU+toBi3w6LVL2I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=C8rCApgn; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=r5VhFslQ; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="C8rCApgn";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="r5VhFslQ"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 69187TBi1207743;
	Thu, 1 Oct 2026 03:53:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=0NmAorX5lMN6twOw6KKl2WtZgSmXV9LsQvUb9367J
	Q0=; b=C8rCApgnjkJmf2x9pZVXlwCQ1j2NQ7incEe24lIqoosELdLxxqBxTlO8e
	bV5bJDrnPqRYJhVigixHqGqetnB1vvJe+WncIrwOfTDwh52vr2ac58Of+TcPSopc
	jMN/Gbg2BAMIpR++vqBtbkfCEsXxgTFkzqyjc95EpEld4PQ7fBQmhuzYK9JZwf9Z
	k51xE0+vqmfumG8yQlmDZ7mvuorjrcQB5RRjDOY0AMtAuR3ZUk2a52bJN4n0VD1M
	yW3aS4vaEblqu9b/BK/XppMchqOL4vgsQhrgtu/j18Z66gMrAsnqgL/RXlGGXrej
	Vx6e8t8fJFpQ5OfgT1ZmazSooIzPw==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012040.outbound.protection.outlook.com [40.107.209.40])
	by m0380145.ppops.net (PPS) with ESMTPS id 4h1kqyg8wv-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 01 Oct 2026 03:53:30 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IJK4Uc0r19yrxeu9NCrcbonHm3gkMdU5namfWqkE69+hwcSRxpEBYe4MiI3Jt0sWLTjrg2vEmq+o9x1sIQiVCqDcZsfYjZJ7OG1WwK3mSdov5U92VxkF1W6wOBTfGe3eLtQOZuULUfStTJk+T5yiUoBCBGqG44To3vdG/MS47sl/aLrsVxcaffDn03UQ1k7aOlWWd8geIPWNqOzk4nuG46CxB8WvTKJUYqZ34fwYrzRdez9E7nXUwH/NQg/1uxORvla2xuZ5Uun7m7sVrfxKM2NKM9nfh+kqyPRmRk1XwaeoR6yencQIT2OcXGTB4uB8k9r0lCAMrhL+zHcRuiyUoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0NmAorX5lMN6twOw6KKl2WtZgSmXV9LsQvUb9367JQ0=;
 b=LMzVcOw6j+0HO+jGQa6NUtmUp+Qs6FL6PPc8EJT0PczIJwoSAOQIWHQFM5/QtwZIZCJ19c7xpYUCGZotsYUbC0nrtUZeCru3jcSsQOx4UtfHO+7aKA5H8VUrEUdRSQQc2LDmLRMVUYiu2TYEkqiSKTCiqDhxKsYAyD1givvsmj1VkNH2TglVf+5s7UWZQ9YM249dKv5e3vSmRdnYwyVN6dvacy3/8BqLW9pGZfa+RkZ/UYUxPBFukPgW3BIJKCDZ9DD0e4p+LxLGm1KWG1AZ3XyZ9AFeKfnvqvbaSZ/+ZjyEc2tMcNydOfHm0SziDDLDzaick5qKec8RUdcxKfHjzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0NmAorX5lMN6twOw6KKl2WtZgSmXV9LsQvUb9367JQ0=;
 b=r5VhFslQND3TlJ4I/WcxabREGRAvys1QMu1vqn1D7GEK71EPEe2CRMawM3xGP7v88tLBbSDutPf/sETEJMw00cutvVMNt/kuM0A1hQUL2c86DgZqjiATquZgdZe5Vozc4DnZcMIiOAv2983rt5WB4vw63q41Yhh/6bbmudNpEyA=
Received: from BN0PR04CA0045.namprd04.prod.outlook.com (2603:10b6:408:e8::20)
 by CH2PR10MB4216.namprd10.prod.outlook.com (2603:10b6:610:7d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.9; Thu, 1 Oct 2026
 08:53:28 +0000
Received: from BN1PEPF00018075.namprd04.prod.outlook.com
 (2603:10b6:408:e8:cafe::41) by BN0PR04CA0045.outlook.office365.com
 (2603:10b6:408:e8::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Thu, 1
 Oct 2026 08:53:28 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BN1PEPF00018075.mail.protection.outlook.com (10.167.245.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Thu, 1 Oct 2026 08:53:27 +0000
Received: from DLEE204.ent.ti.com (157.170.170.84) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 1 Oct
 2026 03:53:17 -0500
Received: from DLEE207.ent.ti.com (157.170.170.95) by DLEE204.ent.ti.com
 (157.170.170.84) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 1 Oct
 2026 03:53:17 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE207.ent.ti.com
 (157.170.170.95) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 1 Oct 2026 03:53:17 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6918rGKT1595391;
	Thu, 1 Oct 2026 03:53:16 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 11/15] crypto: ti - Terminate DMA on all error paths in AEAD to clear descriptors
Date: Thu, 1 Oct 2026 14:22:41 +0530
Message-ID: <20261001085245.2922974-12-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00018075:EE_|CH2PR10MB4216:EE_
X-MS-Office365-Filtering-Correlation-Id: fd63cd34-0892-487f-a721-08df1f99760a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|23010399003|1800799024|22082099003|18002099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	B0opC6FlCfA/N2jw0vr7MBVKIUqKyTfLETQYslSFJKS85l3H2sWcabT/QSVyuqUqTiJ4ang6qqCVZiQe5tJrGPcP84owr1YlRAqwU862W43jdQUUSkLueUz6j2QFlA4Pzt9J8Z1cy/cNXWUNjYv4Yo04TJD8lYPNKsVng3WJ8xPNz0MAFl9mNhlgnsE/77dHb2La1gsNNo9WbfEEC/1+Cgm4z27BWqGxWg/C/pjjBrNn2MersUjp6kKtDHhknkjpGT/WCx2pd7Wf4hQ66kmylZrWsP9HTT9Co6lS46Pei7h5Z/8qOaKEcYO68ENXEDutWnGGjpaMMlFBy964G9WmylrKvyxL74fl99+aAa5fY/o8Qj63gbjpkFzQos1YObqPlA1P+IejHNY0GNwjT0hZUeaN08aL5nUUVPdkDMxRWNm+JJyQuPDawRXK4MZt9hEKLtq4WfiBbxA8lejp1v/wiQBRrNYx7RyU8z85pwOW55is94z/s4A6f0YP+SvbGb8pW+6NSFxHgQ/EbiuRSVmR2fkckPeG/J1okIab4lKm/gM4bcwHO2hZpg4Xat2AceQQwmo6rzwALYC1Kymqjwy2QRQdUvq6JtVbCKl2PuN4DK5TDaqomPwNbnxc2ws/4OZKTE0DR9pZ1stynfNPHqM5COgqMadj6GCwLCX/bRr/RvR7Ws9HMiHv43WCNpOPDrHKuMsjlcyamQxnKX+J/ZnUlg==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(23010399003)(1800799024)(22082099003)(18002099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	sg0NEs71p8PXnAznauiUT0br1aSJLmmtlyjg7C2I6YB/zr5+41AcctXuWqbp5XeLnGcTmpqvfynabYtAJNqxtoel9/QTDhOQGpK/lANIhMcNkftqr1kWwxe49xmihhG5wBnycxqvnr8IHHRDL7zy28NlOof5nUDYhgSUTtqUx4gJLNM0JnkeGz6t3l9X6yCU8Liaslml+Obg9HOpUCSpsQLhrxnnQLnjp4QVDILGie35qjLorvbDEa+PuOs91WuagD8N99Wg5nw4EVHQRX//hg6NFwNURt1P8Oh6/HAf9vs02BHGuK/DzhCiQIW43NDUloiFWLdA0XhUZsNYQDTWIzLDvggBUieC1mBNfiDl0b1nuW6GyEmusYZA5CSOzx7IgJhSqPj61gwUoTTKy3a3dBajKwgmuH0oGfpu1sX3Cn47RVrwLQo+9zFSm7g/MpvZ
X-Exchange-RoutingPolicyChecked:
	uJipK8sTJZA44lfHkih0sfN5WwiliZVDM0XkjqH20HN2liRsG5NnFOVQy9OGnl1iT8Ty339C1INhiZXWi/F5DhUn4YQot57XH7RUL3UAMcR6SLYwvSv5AErH87KOumdMSfCsswONLR7mR5azpnnz5kR+bz2YgbIzaqmaon9X9cBZwsuZs/flKIygDzGZAGLLdDhVtCtzOyvQhPerN+YHxUelNGrEApBrWlMhYSoCqarcLNE4M03owiF0Y+PHet63/OxXPtNlz4wk/72/ZZgdBD8A1DU0pLkJtkXsl/oVUC/NHjoU/2220zQfZoVc4U+ubI3qjyHP5tX0+h8L1hbEdg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 08:53:27.9612
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd63cd34-0892-487f-a721-08df1f99760a
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00018075.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4216
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDAzNSBTYWx0ZWRfX8tyF5ZvmxH7X
 NO2PL22ngo7MnIa76ljgcHa2Lw61OUKD9KGXYgDtYq1JujdUkRaDgfz8tSLrXF1d0KVm02Pfcoe
 9jseKgiWfDSs3rDRzzPUAV9X9jk2N9M=
X-Authority-Analysis: v=2.4 cv=a6alZkSF c=1 sm=1 tr=0 ts=6abe1f8a cx=c_pps
 a=n6quz47VtcdWtWxmUgX64A==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8 a=noPYQ3j_lezN9luSq70A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDAzNSBTYWx0ZWRfX6pqKL+Uj/O6u
 bGD1USrRsCPba1+GxK46FKL3yO0ROX7PkzTf6A+S2/X0K45uOyLM0Web3avBdYtAQlN+Dg+zG50
 m6ibUSGGAo52rJKjOqIlP/WK+TM/dXqdX73qrRFdKSQwsZ0oGC+kzzg5TVDz2LAlmFA9JORKIRs
 A/x7QsepMapJ+ULMrBhK9kfqIDJne1nbQC0z5ug0VCTbPEmuA3UvxBPgCWiTOLu2CzBl8ntFsum
 J3QTCS9ja7FQ5Ko8l6QASiO7YTf+M4V6b2kBrgZ3DuIq6BHtL7wLjLul6WcmGLU8W8H4SkPq73c
 fjybQh6JnKD13iPABETuEO40k7TleyvUxPKjqbGWun0CkqSId2hD+2C7Qx0xYZIvXESUpG2DiFT
 BfaKAImeWEdYrI9eip/enyG17fEo88BUdOsdMPGwEXzUP/PhQwWtVEW86a5V6iIHX8FZRnIsSbI
 sbRPiyh04w/dMHI5MPg==
X-Proofpoint-ORIG-GUID: fwKunR-aBI0v8GJ-HZgEIaWKw3ZxMD8K
X-Proofpoint-GUID: fwKunR-aBI0v8GJ-HZgEIaWKw3ZxMD8K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 spamscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2610010035

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

