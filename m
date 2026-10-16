Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FC3492181;
	Fri, 16 Oct 2026 12:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154792; cv=fail; b=akcYKjdz5Lkw2Yr4x2RVt9fIoxtW0zRfQbt6vZ+ZNp/e4i7izLss6hycsWjYXRjkjZalDxPhD0FW+xI4g0tIm4Xhf74Y0dpJy0r0gCUxEdspFNKCRDBP0KUel/SH+5De7MTHA3Yr97bTEN7iNRay3GU+N527RAIx7hMHV10h3u8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154792; c=relaxed/simple;
	bh=lCNQzFK9UJ37Sea3gL7rPWFDv6GNWE/ObV3aC8JhLeI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WE0UUNHWOPgnX0D23TwLnJSjiGoe+q1jUoxjo+313Oq9kUHKEVk+uD2nxnDfMR4PkRzp48A3DS8XOmHBCWo9pWbyCi5nPlR3kAyEdyH48p8rrWeOZiYjnylswychtRKwpcEYgz0UGqIVrG0Huo4IoYB95ep9yS87KJEsSrEGcXs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=cD+EEIhg; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=GWgaBxdQ; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="cD+EEIhg";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="GWgaBxdQ"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GACxoH4171208;
	Fri, 16 Oct 2026 07:46:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=nM6hlj3eUhOW4tQxIH3PY/P9g8fydftR0n2FkksJP
	dw=; b=cD+EEIhgDjY7ukIN1HLwabIUsACiRA4T8kMqRcHOveysm7apBU3yy6FfT
	7aCzWx6/GiaPNKBKK/qymHxwrRv1fEmdfW+XI47oK2U3YGr2wqhjaBkKdknck6Dg
	n2hJaqInvm7nKDxkv6n9tn7A126kPV0BRNIg2aZFOVYjJzENgkdAHYoSmu+Hievo
	X3QTTNVuy2q8cBuOye1N+mkht21PbhVxn5umnGOaCEDPK5jrHozQwU8a1RU6J+oA
	MShPUdZoka7Rl7rWbU5HyEx77u/luFtS6g8LAuwIH/FR6OHMUo6EPbTaiGX6Jysc
	67rvbXV54NlMeyXvacRCMJGbaOMnw==
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010027.outbound.protection.outlook.com [52.101.85.27])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hbhanrub7-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 07:46:21 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w/sWmpHSH8ZYPHKEPeZkxpmmbmDsrGXSzBiITn7xbvNRrVWeGYpYoN5JT60rQqBcijJ9+ZhQN3eXf6fCQjt90iGjFUboNDyylw99IuLYCVLHCZzL0IFxgD2hs13p4hkQyAskfHPLQ/5Y6fP3eZFqqkqBXXfoxCBIk5g0qeLRDJKPI6XashqW0mZYfPewE2GRR4WCLpAx/exH6Ig8L3M5zmqxhfO4aNHn9YUQUNkH4Nr3z/oNiDW733YZdXPzj1k9bPebEDtEfE1FnMAWBYyRWuOBhyWNgnj0Qzyx8eOhVT4PdHaQbxOoV3UtRS9RdNn8n/1ag0Hrd8ItrRQRIeAlkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nM6hlj3eUhOW4tQxIH3PY/P9g8fydftR0n2FkksJPdw=;
 b=MoXGWS/nu7BeUEJsJWdd5P+bZYzaYEVKoC+EclS+1X5t4u45YRnKVDxrzrzxiSRSiG7dqD1+BK9iHeNEPGlSQNdL9uhriPHt+UbOa3W4VK0/oLVTt4kGpEKc535gajWzxFf/26ezmsUQPhAE0bLYaDQak/loB0GvwrJ3L3YVgB+r98AwGR1HkTnPKw65HaGAZR+SjhoKst3G9tLGzXmDS0n27gS7EYehgwbD6dZ9fX+42X9+VI/03cOoakHJusrXOq4J+LJ2Y75MD7hQ8p+xRGK06Du/54DTyeIoo4oCaorDB3v1L1hzNfctPspICw4wXeldyctYEXrJB+9zgD/OMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nM6hlj3eUhOW4tQxIH3PY/P9g8fydftR0n2FkksJPdw=;
 b=GWgaBxdQI6pToWqEhQjAsTCYexpnsqmSqhU+nBOtt9e/78WaNUKsnlM+npcGVgimp9jJRHFnEQctOpI2rrCgyM6zSxgbIq7+WknEq8mEEAH8hNdJbORPYDpFn1DbXg/Tz3EmJjqVXUyYfdwmTE+2UD7fb+sSCq5JL2IwLeH2ljY=
Received: from CH0PR13CA0056.namprd13.prod.outlook.com (2603:10b6:610:b2::31)
 by LV3PR10MB8083.namprd10.prod.outlook.com (2603:10b6:408:283::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.7; Fri, 16 Oct
 2026 12:46:18 +0000
Received: from BL02EPF0002992C.namprd02.prod.outlook.com
 (2603:10b6:610:b2:cafe::b) by CH0PR13CA0056.outlook.office365.com
 (2603:10b6:610:b2::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Fri, 16
 Oct 2026 12:46:18 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BL02EPF0002992C.mail.protection.outlook.com (10.167.249.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 12:46:17 +0000
Received: from DLEE200.ent.ti.com (157.170.170.75) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 07:45:46 -0500
Received: from DLEE206.ent.ti.com (157.170.170.90) by DLEE200.ent.ti.com
 (157.170.170.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 07:45:45 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE206.ent.ti.com
 (157.170.170.90) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 16 Oct 2026 07:45:45 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 69GCji4E1588159;
	Fri, 16 Oct 2026 07:45:45 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v10 12/15] crypto: ti - Do AEAD software fallback on only ENOMEM
Date: Fri, 16 Oct 2026 18:14:53 +0530
Message-ID: <20261016124456.1802080-13-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992C:EE_|LV3PR10MB8083:EE_
X-MS-Office365-Filtering-Correlation-Id: 24c116a2-fdbd-4c72-ab16-08df2b83787d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|23010399003|1800799024|36860700016|56012099006|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	lOO2Xut5X3IiUlFpBqUc6X4flrRZje/af1f+jU0hxDfi9n5aCph+UAb48PBohXH48RvorfwYtVOmPHlSlECuTy7ZLc2vhFLcXQ1M6WGk/CZDYmfrxKiEK6pq4vEGOas+9ET7/yKL1X9dMykvHqRcejHLQtOL6dD8cgr0MzYrolMMwoQQ6IAtXSVKpjsX2Zphjq32AG9hCOWwEq0FzOP6sUV7PQpwdWXH3j/CgQ6Car4YSqvWj6xufOgn4tttFI7eNVgVnMeToqHenFd5nIijPRc4iAq8q49eXQhnSe2t6lJ9ZKVQbogoyAbpvrtwakZG5QTNF2PtZbkZPfUEJ+cIOk11NiwMMRv1Wg52aI+SxROddWeLmihyaQDeUQj0AhDDPZmF2iv173WYoIOe2q+DdPZRdOGhJgsmlTFVgiKYxNneiJLFRoK7PmRv0sqY+UvCCMM1WT3QEKZXu19Lqyh/8RqSBiQ0HgjpuQcdiAYKUjC2/g8OK0e3g4ABPZdJTmjDb/2VslJMLNn4X1RSukhOztOgokCHM6UD+ZxzLRbRk0jZ1ma0W2kMKrO3vR92g0NPU/BTE3pOi/MRMZdMA0tkFV3ZpQhWlLrPhbzSIkh3qYrukFvgSP9gNplFw6gnBbiCM4rvIj+8717KneytUtUtxWM4SYuSO3hQnxLSnh//ERUsrb+gE+cg5Xxm8Doc64+wgN7K3q6lHFYKui7wWhpj5w==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(23010399003)(1800799024)(36860700016)(56012099006)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7RCfneHrVgP3wO8rpn3A/e+83gxmJx3wE4TwOseiCkNY+cENh9ZJoOO+9LgzYe7nEkbeHfHGqy5y0AHqAKEMhZNBGmRLDcA+npesbGpPXM03aVpCrz7roPmGdD2eYTGZrN0EZHdRrmimEbMTgKRK2Tm/+SzY0XDqnsQMhrRD5Bgdwx/OTunUBx8/TJ9JTtzozlWwdvrz5vZyrSaMSWIvRTCWeBs3VM6kTI+bVWeoaz8/ya+0JzIK6ikUcqcl+y4jCxbooWKv85VoutRiDiD/fxbn7tX/oQoKXR92qzEjc0/WyU3OGn119YbNLdq0T7CzMJIkn9yQcD3triDrNly9Ih8uR3JeLQ959l0xSAbtAa6coXEj1+Dk5ybBCtTdG1CHdjuuxAtWGm4ZnI4n5BmCbedU50D/LvbLeY7YrVodf+8lqpBfx5YFst+2fqHOs/4j
X-Exchange-RoutingPolicyChecked:
	h6KlVZxNDZSlLAlIWZayC4JzSVcNI3w9d5y7TG7vQZKW/4s5ylEggO22+IPN6VpqVBpNXJNN8qbtcsxIo6dracXPqWZKdlbqKccYUmepc9cYL/q63khYUkMIlBLWIOFTtx0aiLjYT0ZyNYKqd6apcKWaIINvWgfWuXHfQpbTXLlPb6oQQMfgAzHgG5VLE4iQl82qKGwTMDHD5SZUr8oNI2rcyas48a83wzlI6Cxtt3mV/r25My4hFvQEtddDV7AMtbaCXR62dIwrIvorS+HYmOoqfiXM4ij5hemRRSIqw8pXNnEAPkqQ25J6TaAjM54zQkVNu/keAwNAoiLrNWUIIw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 12:46:17.0974
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24c116a2-fdbd-4c72-ab16-08df2b83787d
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8083
X-Proofpoint-ORIG-GUID: NRjm7JZwVOWQksvE65U_4Kyml_r3lMaE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA1MCBTYWx0ZWRfX/oFH0jrJIGpZ
 0VXkSV7JONiUBsK0lFGiBRNgEeu/xqp6/Q900EVaSXIMgS5/yIgUpeWT0XvZbI8x9FeymYMk9s3
 Nh/swmR6tU5Osg24qiBT/gwCpIkCHxH3/rkt7VG3Oudx5+zA7jvgHy2fRbpiM5lMv9TIkd7RAHM
 VYe1CRxtoEaXR86NbMgjCWQqWb3U/O3SFEGiaDSM1eeieVdV1C4pfePWBm9L2PDLBrIGeuOl2Ai
 WdXUmJ/nNZ/Bq/U+kriW8VOF7pQbtXv3DGmsATfVvWhhQOZJnxAqM75j6UizfCZ2N5Xy9AvDCS9
 ekQ23YhIvTsRgYblGO/qyyDyZlpmMr1aKb4TsY9NBBpBttAHoF2EyM0xnI1KjyWvOyuyGA0HegT
 q2nuyhFwONTaPxnug7W0szagM+9l138EcDs9B1msgNFnvD5p7d0ZPN0NR/lmv6cfrmpXWi7H/HL
 bcad+zGHM7g301RwBjw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA1MCBTYWx0ZWRfX5f8wtp7xPXwi
 Faz5+GYHxaRvZ1ilfeVh7J7wS1zsa/63X5Ex+AMR42jzGKOqLNQ7mp90RZEUr4SVyqgEn7e9937
 MD3zCNxJ/RSjPlDaqHfuFE+/Vj29/gY=
X-Authority-Analysis: v=2.4 cv=NvhE4MdJ c=1 sm=1 tr=0 ts=6ad21c9d cx=c_pps
 a=3isWwmYGSdluMw1j68YAZQ==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8 a=4oUWx8CZaJwu3DmIChQA:9
X-Proofpoint-GUID: NRjm7JZwVOWQksvE65U_4Kyml_r3lMaE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 spamscore=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 phishscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610160050

Similarly in how AES part of this driver, we are falling back to
software when memory allocation fails (we get -ENOMEM), fix the AEAD
part also to only do fallback when we fail only due to -ENOMEM. This is
because we are doing memory allocations with GFP_ATOMIC in the beginning
which might fail. Any other failure paths might have modified the data
or buffers already. Doing a software fallback on them might give
incorrect or corrupt results.

Fixes: 37b902c603042 ("crypto: ti - Add support for AES-GCM in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index ea6e3b246ed1b..bd26c3f438e34 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -1177,7 +1177,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	memzero_explicit(rctx->src_padding, AES_BLOCK_SIZE);
 	memzero_explicit(rctx->dst_padding, AES_BLOCK_SIZE);
 
-	if (ret)
+	if (ret == -ENOMEM)
 		ret = dthe_aead_do_fallback(req);
 
 	local_bh_disable();
-- 
2.34.1

