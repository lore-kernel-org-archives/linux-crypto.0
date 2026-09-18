Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A7F4BD34B;
	Fri, 18 Sep 2026 10:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789727046; cv=fail; b=OIItZ8BpLCI/4IqB5qTP+UKx6sTuSldeWI2YhDNv29mVDiywvXTPap4cLJYdho4Vw9PCQvOl9AnCcuutqwE3he4/6Wz6Vqy5AmHwa6GRRk3o9Y4mxDnQ6AQrQJYznk5jzbVb+Z2iFaJw/pomG48Wpv1ec9NtvFjKPV4G0xtj6q8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789727046; c=relaxed/simple;
	bh=Xj5n2GVqsJvcefGEwXsaxhsOWs63LUfndOX4wp+k6c4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CqK2b0TXcQi/lImX3uHohP+3aK+G/5qc21ezWKxtzlYcD5YNHzHGqMA99rv3x/mB9LgGnnabiSLSME5myXhe+D3vvM4EgswPieWf1r1K0Ou4H2PqPNN1mS+3xra/YNRGfzIyVLEiDiZe7VuNW1a3bEUOgJ79kCj1f17Cb/k2QTA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=KHUEORSI; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=Gvq6k5/r; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="KHUEORSI";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Gvq6k5/r"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68I9dBtK1233790;
	Fri, 18 Sep 2026 05:24:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=FYCkMb8oUWMLmdB4yXRpk+rbOGGjOkqEpnuQX29Sv
	MM=; b=KHUEORSIqeZHkrLmP8F5CxzGjRZDG0zRvrCrl0TNcHm6YbLrFFW01UjHA
	FNJaznpXBiJdhCDhb6mlgqjfk3RdVAlkNagtjBGsGdzIy4mvZF0hBRACiLGEO/KH
	Y1zJTvDEzUut12mRw63IEilbKilr6JaS/JW7BwDbu4Qb14Od7U4eVEzd777BHsXh
	lsKyinT0yWIcuFSP3q/hAyANJWwzVAi9EPJOGu4pPhDm00Sz7sW01jmDHDMwVfG8
	u41PiqIHq+765nrPdgVS9ejvfG+P8Wsx5+YvHAnD+iF//7yjQGHYHwk7ir/vnoKs
	u+tDj1OIOQ7xYvZtglYMYwMgqdyqQ==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013068.outbound.protection.outlook.com [40.93.201.68])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gs2ux07dn-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 05:24:02 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ehyCJWlZP4VdgZu8Eml3e4es4cIWaAImv3dopv3GxiBj2FIt3tyKdqtao4llMcA8brB6K6FmM/dbohYe9JecBPIjcCsFfOC2kEHmoZQNTe59ldTcv4r2jmkm3VWQqasalTHw+zn91qC6ch25bbFEKQR6h2VE+Uos9wmYiKIPWB/sMuvblpimiuY5bkBss+uN1PAzJicSbcaVVeUO6/8hPkI1bwlm37HSjucHFcnMJVz2+2SX9DiPi87TsrIMo1Dsla6ezVpuHZvObIu2LG3vc4Jt7ZD+OAy5Oism/seQXqWDR0Rxi4SQY48ooKNY9G5+kixooK7cFc4XrjK4Jc9nKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FYCkMb8oUWMLmdB4yXRpk+rbOGGjOkqEpnuQX29SvMM=;
 b=cy0W5a5L06FOsaQvQkEUkf6T6dVLo3EpGyStfZdhkOP0+JBGQ8vzxXbbVJ0vzQaG7235FpkTbJsdzoHkEGffz3YYUakPTBm4ZMgaPVL8h3QjHx+PWXSrJ77YwA94ZhQveOpgOZy+DydPv+dIKjDRM7tbyUAlkOSVt3DsPaNYEs5Oy3a0t1rjqLoatN/6f1nO/OWXEX41bOU2rrIbNy5Si4vbK14BBbPwBtboWqjkQY3hFwfItC7X/knDGxt6YAlt1xiu17CA5/4CWOE6YJoFUskUSlWlffvGdyX+j5h9+B+CUGNjGil6i1EenTuBjtWlu9RpH3ZGs11eZTE0zk+55Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FYCkMb8oUWMLmdB4yXRpk+rbOGGjOkqEpnuQX29SvMM=;
 b=Gvq6k5/rMngTyqcaCURQDOBJY5LMHfG/paKtaS9V4yKharVWEuCJqHjsyfe5WpdRbUwKq+11+1TrMoRQSNPA+y4vGVvlFEq147J3lB+qEqZfWPbaxMDIt8Bbc6wipuxwToMM+hvU/1AB/cvs0Kv+kCYwYQVeyKKtbUFMETKgKGk=
Received: from BN1PR13CA0019.namprd13.prod.outlook.com (2603:10b6:408:e2::24)
 by DS0PR10MB8152.namprd10.prod.outlook.com (2603:10b6:8:1fd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Fri, 18 Sep
 2026 10:23:59 +0000
Received: from BL6PEPF00022573.namprd02.prod.outlook.com
 (2603:10b6:408:e2:cafe::48) by BN1PR13CA0019.outlook.office365.com
 (2603:10b6:408:e2::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.9 via Frontend Transport; Fri, 18
 Sep 2026 10:23:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BL6PEPF00022573.mail.protection.outlook.com (10.167.249.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Fri, 18 Sep 2026 10:23:59 +0000
Received: from DLEE211.ent.ti.com (157.170.170.113) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:23:31 -0500
Received: from DLEE202.ent.ti.com (157.170.170.77) by DLEE211.ent.ti.com
 (157.170.170.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:23:31 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE202.ent.ti.com
 (157.170.170.77) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 18 Sep 2026 05:23:30 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68IANTbV600779;
	Fri, 18 Sep 2026 05:23:30 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 14/15] crypto: ti - Change lengths in AES to u64 to avoid potential overflows
Date: Fri, 18 Sep 2026 15:52:44 +0530
Message-ID: <20260918102245.2784000-15-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00022573:EE_|DS0PR10MB8152:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ec06f7f-2555-4454-5f6a-08df156ef3d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|82310400026|36860700016|10067099003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	lKCqRAGFY5CcP/21HOC6dl3zF/GGbozRs6NdGHU6bsBJKUwpKM0sn+879KJqS1QvFHEvLUK5KrcFA8sxZwT/64NwTuGZoh8XknJ2+r2nzgkoo8TnlYgzkCkhx1XQujAhlMXwBXtEG3wH6i8gAdBKnM04QtSRKYs+pbGRpoaLiu2gr6xYMyYxInPdqh2K8KtjoEICv1OlQZQUdkZh3xufpOulsLX19P4Yyhp5cC945a4dbYfwVCDQxoyVRYcfUmC6ZeE0VkWsDWg59IJxPXpBfZNMybXqVTlaPWJDXCKNIZ4vsMWQiRZg1oU6G9RtoevsD6YolWA8nQxJE1P7Doubp0Pginn38bTbO3t0pgpKlEfoGNtnrA5B6lVUFIrkS8feudwiz+ePWqMO69EpD9tmaXyryt42BGhmAsw0Q38RhDftNuLiYv0TauoZllpAdefUERdvPoq05WMzkEc3VwQf7Fc1Xn7R9cSwjkkFugyjWmiZ3cW5M2o/BRCeiaA1vUgPpgEzFDffXxPZfDNoQ8Xt7eqqrafKry6Um+lvXYTbXmJ5DPhKQs2CzA34poHgfBWGGzDMtau79cC+CFF/zN9U+91GG+1LkDa5FbjxHzSvzFp4xIZl3OFXYGFJqP7BXLiu9PJNYSrTDgbYlMNnY1yXRQEpGDfMztdjWjtvt3HQ7S+6Lz2pTa6Qf+2aVX7BI14tCfAPWk0ZebpC+7XoNGNRLg==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(82310400026)(36860700016)(10067099003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QJNHiKrx6GzO2Dgp7KjxYzL0rkJ9g38DJF4QtEi1OS3eF7VBjVsgcU6Cp5ywS0A0t0ZqAcPKjIlIyr70es4DFYUsmE6nGSTK2Wh/0ifQrNxAKKyUgUS70GJJcwYkJyMvPIJwSRMlUpOOi51ZMTWYVkZ1gGe2M43IbXWxyd5+l79qbKuuCEgNchX+IW8hU/MbF9Mxg8pMaXyITvaMYHV9FVL4Dni086zx05Gq51q5SI5yC8OgUWcU7awfoMRep1mJDqwpR3vn0K8t1SzQgFG+Ov8ksAqOqKli0H5kSVsBWuyzmJ3R06l8uwOX5pIT/SfIgGM1YFOVImgG71nbcyp0uj9AA5cVaUqy4V5JJNUEINC46wC3DnZ+fqAWUXh7IiGyYxKN0BDO80+V9c+F/HlPLJStRweStURc59P4WUZXP63Tb52j8hYNxYIPGCa34k8c
X-Exchange-RoutingPolicyChecked:
	CUrehhgL0lbB9DZEGErXngDorMcCjPlOTQSAlaqGVUUyZZIUxfTPiY5zqPa1Ltv2NZeAHOheAIjCg/AzHuCUXrabr5hUSg4XQOmKgrag9iaX43pKUyVEv8FspZogzeoFnG6suEvGNIqDB52nwGZZdml9iQlX7ELjOWtsdw1gL4csY6xioA6tWVMMOpD2VI53YrxbOGFPl2is2vKITMT1h3NGcEkWnyGeoJp3dGqFGn6uN1tlQeCirb5R6/g0HABk/bOr2CFzaoXoNiBppTY03rHWBFY0KAV1Avx7wAhuqfvXvzel/WUwreweIP71bxXsL5J2+F5I4+FbNlg4h+JYDA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 10:23:59.0431
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ec06f7f-2555-4454-5f6a-08df156ef3d9
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022573.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8152
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfX74VcJ8OUzUeT
 eZHv0PbfszF6MZlveMtmrH81aVssxWjYkALF9sWvxCXw3lOsWUgmlR6faQLSMP4A1Ms3WGXxXVR
 N7Qgx46PXpdlhEkvZU4OBiUX7aL6O8VaJyYESpcY7Tps0ucgceu9swBTJ2HSOb+27+OB9QMpQ+I
 C4gmjdapjcvFWWMFYH+B94+HYUNhWjH6YUvNAZ+8ev35EhkEwNfBk9haq1p8ZsJf1aqpcpiv4BB
 rR7l0jrlQNFYJlXRG+LPSzhQyvjpZfJcrdpEgovkX8gM8ClstGprKuhsz88rVt7YHbH7W+Fbp2I
 G90I+UtY8ztSUb7SJHDwFTkkuUJosyq+fEpP9j6p4kDFbXCVQh3971l85pN6WTENPEzyG8jqp2g
 TqmbMduKrkDojN1Bk7gf+83raw+mCPXjoj//KCYVY46zHmPCkxtgpT7nQD4cSxM1tHtoboHAAal
 AWVbayPJ41RvlCSyhhQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfXxT4dLxEwTLBq
 MJOEMndizUOkkre+7CyCfFAbrS1eZlRYsE9qJvpz1QQOUQs/IsBoGhQ8UkneO32i90SCaop796/
 xkOOe+VW5xSDPdf/A2pcTV74AkFMijw=
X-Proofpoint-ORIG-GUID: H_KzZibGTw7FKfGtcrCKAegTIPHpBQeb
X-Proofpoint-GUID: H_KzZibGTw7FKfGtcrCKAegTIPHpBQeb
X-Authority-Analysis: v=2.4 cv=adH0Dhot c=1 sm=1 tr=0 ts=6aad1142 cx=c_pps
 a=THEAVZb93WkyejmpPpFvRg==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=sQKIhDeqCqRtbGPzpkwA:9
 a=zZCYzV9kfG8A:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 clxscore=1015 spamscore=0 adultscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609180144

Change cryptlen from unsigned int to u64 to avoid overflow when added in
padding length calculation.

Fixes: 35645ca63caa1 ("crypto: ti - Add support for AES-CTR in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 150ba73776aa9..9b982ca4a7730 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -326,8 +326,8 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
 	struct dthe_data *dev_data = rctx->dev_data;
 
-	unsigned int len = req->cryptlen;
-	unsigned int pad_len = 0;
+	u64 len = req->cryptlen;
+	u64 pad_len = 0;
 	struct scatterlist *src = req->src;
 	struct scatterlist *dst = req->dst;
 	struct scatterlist *sg;
-- 
2.34.1

