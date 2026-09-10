Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21683468C12;
	Thu, 10 Sep 2026 10:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789037025; cv=fail; b=KyWC6GNv1rZybWJNBHP9aTfxaLuQWOBjVDJOgjOMYrZq8G394CeaaZ57+dVBIK1+i2M2Twkhc8jsiLsoSHn0uqm0ekOoGbq3Ny0xSaq+p+qxfSgfHucd6gBhCditOrjrdvdtGs/aEKR+RaDIu/AKtzFztJEZeIz4HUYAjIZ2fEM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789037025; c=relaxed/simple;
	bh=rMIHH7q1HiGvJljbcET80ADog5KoEWbz8PeiVhRv+ks=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZBUBkLcIWQW6FmhCbpsfVGOALZ51oV7PQVPIoYZbvNbl8WVodqz8vHhat/BdsNHqADJlLFJKGTAw8g5lRzcZkN9DqnBrpaKVdjIdAs8Q4Oh3VxL3RUW50vsKezz4iZM307G5CoKQEdh4uGmROGnJcUdwmofX89uU1Pu9iW3yXGg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=aShbBFVz; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=omgudF/x; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="aShbBFVz";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="omgudF/x"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68A8oIbU712662;
	Thu, 10 Sep 2026 05:43:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=6E/G/PUZN0NxwZbEDin4ADqQv2DLFI8Xgpfze4sUr
	Gk=; b=aShbBFVzFmcyp8nWfShYy1XNjLp1W0gHtDWoJ1ZrO7vzuwZj/m0se4nI4
	lgAGiT16oKGgbGTdgGPio7reSFDP6k3Mu4vyPiPQnPdaENfEk4xuYcwYzuLoJRLw
	zGgiqL9JIDgDA3Sbx7DAX/kQYQ26OgI0zy82DuBbXXTW1vzAIiV3AFrL/IGaztVc
	bfJiJXouI1rm98H/VEJ+cCR4VFTJjRCMUkATDSkrBP3L5W4eChBXcCZohh8ckcFf
	YocMlO/CwPXkx+f/kvoy36CpoDwvuPoDoQKygf6TpGUuF7IUMAl4kax/mocZgfko
	ulxDa8cOiunjUmN0In1YlYT6WAipw==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013066.outbound.protection.outlook.com [40.93.196.66])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gkcxgcp0r-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 05:43:34 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fCioPxFAeHON3ATeq1IabP+Hp6SlAGTIuJ5DSkB3tZXCos4kkaGOgDS+Mo7IdZlBfR3F9LJchZSLCiZUGpjuSzyiv1lKm+9yEoOR70TrRERkSeOOYVurge7a7P9mny92YLbRdNnZftPvZsesiN5xktNS3tEO+7FTHynuHZt7Os0YBLET2NzcXrqasFrxNJ89/YV7GK6nsfaeK31SdPJmjLovFZByqaA2KkFjDnzEpSsFPESmXLospWBe5SihaviK2j8z5N7tK5a2Y6etqjFogpP1dtjOf3E8qBpAUxfRyi6MAIF2dnUSfGsP/q56QWf6ARLqpRB3q5GwzIWCkRB23g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6E/G/PUZN0NxwZbEDin4ADqQv2DLFI8Xgpfze4sUrGk=;
 b=fznWOHuF7A/QR6Krp12mLMNbe7POWY8Ygee32hC0/W222mnwFhYdBejGaAiEqU9vqsvLJGMKW3Vpqr7SwZzh5TBJ9JmPlkUX8jgQkpF2A6lSUdTMRmgPR9SJ+ttbyW1RPk8RprIaXJ8c8ucCyfOz8upZensX4Kj5NkuomMB+Wgs2KP29ncgmgxVTORjo8ggCCZg0/nfDOjx0xVAPDgcKib/TopgCZJF6PQ57JNOKr4mX6ODYQuw4dH3dTwSJCaiml9alLIWo+BswXJpHX9+H+e8vU4s/rxRhwZWs0cK0RT9a9fGb+ezz2XLRsX0tUUdRPcgYSdYRt9AcATzaAh0Zww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6E/G/PUZN0NxwZbEDin4ADqQv2DLFI8Xgpfze4sUrGk=;
 b=omgudF/xE2QIg/ifzE1NAZJRk6DEHGGlKa642Lb76EpYSlHJMXeJL2RHsuPrwUpSpUXAq8EJF5EVmtS+QXQO37PbM+ZEaij6mZwMHUxLMQWiezoWdnMRojehrkSkdIHMPn3Cc8X9Xj3f5qwhoDdNZBJSegLVRaYPLVVnItefB3Y=
Received: from BY3PR10CA0011.namprd10.prod.outlook.com (2603:10b6:a03:255::16)
 by CH9PR10MB997856.namprd10.prod.outlook.com (2603:10b6:610:345::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.4; Thu, 10 Sep
 2026 10:43:31 +0000
Received: from BY1PEPF000264B2.namprd02.prod.outlook.com
 (2603:10b6:a03:255:cafe::4f) by BY3PR10CA0011.outlook.office365.com
 (2603:10b6:a03:255::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 10:43:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 BY1PEPF000264B2.mail.protection.outlook.com (10.167.242.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 10:43:30 +0000
Received: from DLEE215.ent.ti.com (157.170.170.118) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 05:43:05 -0500
Received: from DLEE212.ent.ti.com (157.170.170.114) by DLEE215.ent.ti.com
 (157.170.170.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 05:43:05 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE212.ent.ti.com
 (157.170.170.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 10 Sep 2026 05:43:05 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68AAh4tH2178405;
	Thu, 10 Sep 2026 05:43:04 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 12/12] crypto: ti - Do AEAD software fallback on only ENOMEM
Date: Thu, 10 Sep 2026 16:12:02 +0530
Message-ID: <20260910104202.1537226-13-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF000264B2:EE_|CH9PR10MB997856:EE_
X-MS-Office365-Filtering-Correlation-Id: f5031b99-1c2a-44cd-9b86-08df0f285ab3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|376014|23010399003|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	eJhZjaOK+UI1os9VZK1woaJmke/NgWDrvybSzeXp8P4PZmVvUfNKqs1TspYWe70e3vCL+rAQRFROFA88hAupda5gC+HFa5VFmsFbVN61LjLEL/sNNLyijb5lSMRyTurzAuGK9ZQB41/uXZob3WJ3dTtHGeIRTAPIXYYU5an/LSCuaK/Yj4Rjtww3tOgyNjfu1d4kCvGgkEM1ElfFtUocJXYARwVS8nZMz9rJbp4AeoftyGZyrjLcB5vtY94n5zuPntkod2nDEeqkjNbOvgfBeT1yzT/oV4IPEBcEODenB+AdWQoeptHwW1hoPfzg4EUYCvPhpvMXNgBVYnNyQtohG51+QRMg37oWA7amI3DTtcFk21MMoCZP5b9f8+zJxWgHVpM2A9gAiwaCLJX71pVV6w4W1WVqQDUeVTdl+n9nyXj6UcfMLSM9xysycPRjhciyxAf8gS2pIX2k+XO8AgERIXlF9pT6VVDeALGJdO8TuK37NJ2DAA/fGY1Abb0DKlRSMD/hMp++0Q8hZB0sdtO5amJg8Ce+lcshjo1JBSpwbin4phPRuaVX9ePG5Vq0jabECqw+Z2nNnJI9oiQOntkXQCdVWfUgUbVEAn9H0KeYji8XqPjP1DtDtbBhnGBQptA4EOvy5p1Zw+9gxAc/YiAGRuXlVnTAQkxJL7+fAUSqyWjnGPDNGOmeIn5pw00xL9GFdWNHCbsGn7TMHUsYfCWPwQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(376014)(23010399003)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	OuAFGj/fAENJb20ksCzCc6FWlv9+WCEmmne1vPduneuo1Ql1LY373R6AlMj9gKbvr1QojmpA/6qJZV9+POVU5injUr6wUp3i5O+iJ3dN3nqVDq+f7Ax6YIlfolqbdsABbsa/WTJZNhOtJuYKks2aFDaHxdsIfMC5hnLhWnJJmyV+xHiV55MPa+iP9LYhUEbjwPW2/MumV+g3gGtoGL4fTMUMx54YZqncU1LN1us1sRzC9DJd+6GDMhIy8MLGWwtR3T4QT8jbWMmLHTfkdUl0Q5RQuYjkKlJoXiimtbGs9m/RPU7Rm583XE0e9AlRzfIZNUPmy5EOcpw8qnnn+1fOzeUjViU/VwyxIERtATYZ4xxmIX1OGFIuATRLwELxAghBsg1quBL/Z9UB9pvcoLAbCZJL7v0pwwa74Pf9dufH3Au43y3312Q7neLok7yvqIiR
X-Exchange-RoutingPolicyChecked:
	dcqngKIzE6lKEKTAwFMzOTd7FMQCPam2gpIcKIKIAYc/X9UIw1wNP99yfDAx1ayi9aZ0pC5MZJzqUqE/NcvgPdfCNKRiMXen6kbwiIF+Mvd6S1IK9KFGGB7cWWJUPH9fQ/R7QTtZucUKq9rju9nSJgk0CRcJEkGznMhJ521cR9eZpSeS+IQ2UtlsYwbrayLWM3q25l3VkYFCHXXdhB57MAgIx2uXo2vm/nr6DFLq255ojf0ZqXQUdrYq7u/SYa7CUXNgFQmNyggZ8zVI0WTzVQGqfFvBol48C4nvckV36RJYTSRKYxpnbRUZoBaeZJ70d/ccVhuDPvCegpgEeacftw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 10:43:30.3438
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f5031b99-1c2a-44cd-9b86-08df0f285ab3
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF000264B2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH9PR10MB997856
X-Proofpoint-ORIG-GUID: W06FCjCssl-GgLzPgrlewWI_Mdp0BZZC
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDEyNCBTYWx0ZWRfXxWajQRHdPZAM
 HvBLdC6HG3fWCvpnMrwskQq4iUaz6LXzZdxYD4sJUQR1IqcgLAJFGjDMncJDgB1+iVC50MTfPlx
 lBW5JqEbX5ncchXbMue9GRDXIHq7l6o=
X-Proofpoint-GUID: W06FCjCssl-GgLzPgrlewWI_Mdp0BZZC
X-Authority-Analysis: v=2.4 cv=MqbHeGae c=1 sm=1 tr=0 ts=6aa289d6 cx=c_pps
 a=yvofFnGdSAaTKL5iNkS0vw==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=4oUWx8CZaJwu3DmIChQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDEyNCBTYWx0ZWRfX7N2tA4dqsgHz
 awWk3AV9UBTLAC5gKcXrX+FjyFksrd27gs0w4r4Prnd7wH/iumgTEW0FBUKz9irKyomGfnVYPfl
 i/QUWRYYDSBmlIwjp/mFQQn7AaqKzfsV4XB2X3Ds2a1TWn33GB9nYkgYvNadKqNwlNELZ1mScCs
 uqA9joPzu/CGboWk2Od/7+cncgxNHqQdzy7UBJ3BdR3LUVlRWIrxvsUw6l4toj0puwMb8boaIMU
 ByibR9F/KWyiB1MFGMP1KaRdoqcY7rBOjHO6gkgRYvSvGDVhO6myz6p8wdSISZf592kzxukoz0s
 9mzE6gcK/LSGx+eYGQgrolHR8Cg96lc6rUsDoDsex/2VjUopuqZ/dUX0lzYjQnrLHobkBhNDE39
 Eq5EgE2QJmiTR5Gsbw6bI5Nld+m5zDSl4E5YU8bCxmIZNRadliIDi9+Ypy6VDCt8TRq/mjAxXlB
 nFAOs5D17TowUKhyXQw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609100124

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
index a034c1c8f20ed..150ce65f613fa 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -1173,7 +1173,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 aead_prep_aad_err:
 	memzero_explicit(rctx->padding, 3 * AES_BLOCK_SIZE);
 
-	if (ret)
+	if (ret == -ENOMEM)
 		ret = dthe_aead_do_fallback(req);
 
 	local_bh_disable();
-- 
2.34.1

