Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63F54E3EF3;
	Fri, 18 Sep 2026 10:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789727029; cv=fail; b=jfhGuH06mMhnaQy4KI4thfDY9lYUYOYK7LtaXyxLfslNRK0sYJpuslej7zFQAM43IKif7DeZ79J+6WOQy7U9fqQL+J0lGYMWEfrTNYyK88zWJtW9QB9MdXmsLP2AsLNjd1KkpIHEV1aU//CmKsQi2cydIlz1kVo0enx8KVRC5D4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789727029; c=relaxed/simple;
	bh=rMIHH7q1HiGvJljbcET80ADog5KoEWbz8PeiVhRv+ks=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fvzALaff2bxI1qkPnbdVUGsLXoekZVD76ETZTrWii49J7lzxm8MBPS+UnVq7NRpOEkjQyBcksDFrUiiqzMSRAAwicY+1UqCjJ1/ZsP1MKfZj0QUdhC+MPIgInFsQ86zOFjlcpULF2MGUF+BYBMfesP/DnF3Pj+0pjV38QLdy8cQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=BNAsgrjK; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=ZWdOU7z7; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="BNAsgrjK";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="ZWdOU7z7"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68I9cRIH3870217;
	Fri, 18 Sep 2026 05:23:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=6E/G/PUZN0NxwZbEDin4ADqQv2DLFI8Xgpfze4sUr
	Gk=; b=BNAsgrjKOLhg8xkblT686fE2ERHAxMv7482Mbm+U5ql4Vl6jHuivg2sVR
	KU8wHqPAjccM35p7CpyG1bCbj+e+ja502LjOfva4eWwSGWxAyHjo3tCDgE1sAvBC
	Ffw/WQcGrDVjCpzSxd8kmCDjbqCRTmxcS7iDr/uL3Kw/Q1RuWkzcoMRaMqutqJi+
	RY+qfky/zum1cltjwt8jppxHBQDuAfWwliqXvCNgi7n3SwMf/0AC6o9/seGurffP
	tqujFX2ypsX1RtZHjPgPI4f3Gj4bKVVODsIR3FY8XnueWKyYEcn0YWGPO4NLYnq6
	3ypo7V36BO5ByrTBr+agET2VQUDOQ==
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010063.outbound.protection.outlook.com [40.93.198.63])
	by m0380145.ppops.net (PPS) with ESMTPS id 4grx6d9yn4-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 05:23:44 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MPO+439+AAzI+2HwuW96vzSNy8DENaJpTFb8upNwTfC88QzKWq59DtERxvbC5YwCTFsMMLQZz/G8+xAeZ812T/uCscdHDJgjHByMPppC5Z3oM/5Z4PnfHa7GKSU5AwNUjL/l4IcGL6xjViR+YvutCdJaXmRpQLyj632sBdKvaO04CqCf9IrAb6mhu0NYiVWahQLxSSOvkVDNP8zQ0KiKnRlGNHg2zC6PT22i1ddZMfvuVm/imUzyoKBd3D9sLxyaBqiDAwvzybxYIlA5RAQn/Q2Q5v1lfQGrI4Ncv8fBZLnvoqnjqStABjegEsStRzgjd/Q2FFf/lYhCujaUL3rBtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6E/G/PUZN0NxwZbEDin4ADqQv2DLFI8Xgpfze4sUrGk=;
 b=iJTKmoXWkfYHh8QKJVultIUwyEIVsEytUXNkEMtTCEsVAS1aNLg6RjMEU3TsilEwqPwYJPKYKaB5ItpHz/qk5lvUDGev9I1G5wu9ZpUrGMjWfxGs0peDmm2yeInPYDOXNWvvcjXu3FsD6s6MJDkVgzgu9/LZa0GuF2AA4qc7K204yO3XgqIu6s8kYSedh11B7Z7b0ptJA1zjPXQhWdqtnyH3CDYXk6VDsEmFilAsd0b5WM9awKZtSlaz533Hp8N6Xdn/9IXgrQ98zMdcc530sZoQJr9TFUGBR57NxsfpmNnO/+nejDfcO+xqEU4ANq7JQz6tv9Hi7mpcXjJF5bonUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6E/G/PUZN0NxwZbEDin4ADqQv2DLFI8Xgpfze4sUrGk=;
 b=ZWdOU7z7kDZj6P5+K2XR0oveNjcjzrfHxG2vgLWyWCr5I+lFJv86ZB+oNfW82X81o+azx/7bkyCa6aY3bs4H35VP8KMGHpi19N5hle7snCgMQMBj1u9ZjY8Sc6lb4tfiO5WPtOjlqrxi1lBgqa5bddJCNtkWkigDgzZFJeKpTe0=
Received: from BN9PR03CA0928.namprd03.prod.outlook.com (2603:10b6:408:107::33)
 by IA0PR10MB7384.namprd10.prod.outlook.com (2603:10b6:208:43d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.5; Fri, 18 Sep
 2026 10:23:42 +0000
Received: from LV8PEPF00000059.namprd02.prod.outlook.com
 (2603:10b6:408:107:cafe::1e) by BN9PR03CA0928.outlook.office365.com
 (2603:10b6:408:107::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.11 via Frontend Transport; Fri,
 18 Sep 2026 10:23:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 LV8PEPF00000059.mail.protection.outlook.com (10.167.245.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Fri, 18 Sep 2026 10:23:42 +0000
Received: from DLEE207.ent.ti.com (157.170.170.95) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:23:26 -0500
Received: from DLEE203.ent.ti.com (157.170.170.78) by DLEE207.ent.ti.com
 (157.170.170.95) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:23:26 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE203.ent.ti.com
 (157.170.170.78) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 18 Sep 2026 05:23:26 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68IANP721534811;
	Fri, 18 Sep 2026 05:23:25 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 12/15] crypto: ti - Do AEAD software fallback on only ENOMEM
Date: Fri, 18 Sep 2026 15:52:42 +0530
Message-ID: <20260918102245.2784000-13-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: LV8PEPF00000059:EE_|IA0PR10MB7384:EE_
X-MS-Office365-Filtering-Correlation-Id: a2a33cc9-c456-41ae-957e-08df156ee9db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|82310400026|1800799024|36860700016|18002099003|56012099006|10067099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	1/7/fxNLWadLGmthcYd0CfyNXMxo+OMZHweuEc6Gk5cm0FyQ7CrkCVgYTUpcrm543ZtPoNCAJBpCozj1LdFVzqAuoHkT9YsJfYBcU/W7ADTQLOhD0VyCa6Yuzpf7JVagJq87p9E/cJphXSXXeqOqwidtkrfW+9eqpDT67ynzxrXQLwQo8N2NU0GUtAg1Ig37rIC9RFgAgnfzrNG5icBkXa6PIlWETQmkKjhy3dX0bwgeEHcSFNatBkIQemri9Fsh+HhO5k8/Qwt4z9QNeOaEvtZmGehfF+mGxlEwSChJKbt9Wv+3gBzmAMAoFid5FGsfpHUVR0UD5kzQ6LjuEzg/xVaAQrtrmtMtxGK1afzpRO0f6v5P0vYA9ag61XiAE1dgOgCeC1FfHze65Dg+Jw6P/R9y/YJYUD1/JwQSlUo3Ou1IzwJ+a2aOy/6dOn27Av5sFQbYSyZZBJSNRbl+gZVktU0Fm0OyLMdvu9dE9IKrNkMVP3F7boGpSGuamrb1pIqf4kYJXcJBlQreTN3mtuSbqwmDk6Jt6CrTkMuCY/YfM80glI7re4UvbOdoVRaIoLSKHrCy/d28qGEbLvsCvhJP/YbbqzqPFMg2Y8kQELwbeTx/4VQsVaO+MXVC7zdVUgd7OkqtQA0r4jhyemejYVNtnZBWXGPiAKrHOCcPzgbT0TPPBMhSTXFcyqsox3bUZXXRPug4YeHt09Y4QFHMn0LDCQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(82310400026)(1800799024)(36860700016)(18002099003)(56012099006)(10067099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	rmWNqRs8ZZwwsn5LM2SqkRQefUht44vx91QAQESb0dP5Mxq56ExotZFUsRJ9CkzS6xvaijVvMQB0QUT2acmIHdyJgoyAmk6iz6RQD/wO5tUCK972tqiE4SVUJFuLuHBBziX7eIgscno5S7kfqDdnTdWxBw51URAZFAtgoO89jQtzcKQKuZtIx0dI2YltRJevJ1JdqP615UjwNoLnRe1QEZ38P93MloWydNs95L9V9r2uznOyv9KuyyQ+U7vIbwrUTdNVt1Bv0+V74+bNoEYu5fLMJi6Y4vN/MU8LTSRx4k8qSMNASsqO1XCy8osLKrWVR0U1dzkL21Lz1F52BVQ6a+Q9qWONdSlW3xEGQ4aRgzQC3thAVfx6Ei31EZzAXQE4Or1d0YTLyf2HD0lVgNPyERqzLxg/zUPN1DEPfpnOoCAUnKoQo4j1WAl4xxTYAOSh
X-Exchange-RoutingPolicyChecked:
	lYDukkgbPtOVhWbfkWo2/tKa/YlgK12rLuW7wsH/JYbrQjsLxdgSRzlw1d48tNwhClOisIufccrrIUtUPgfsytoYOBgJIAlVl5JJd2lGbaGgyTfOjlqzg8hURo7KN0VJqhmJ1c1Bp3YdT1fLXTH73rAnFyoG+q9CnmhzhEaK/Cu5x5h8qt9qBSe1Fz5VzetgZmWrpN5GlOh3AEjdh3Yqg+yIGC8OWPVwbK1rn13mo4wpf0sKstBkUEF2kA6UkMg7rR65DyeEg1FolX+s/gGAYrQmMh59CnMdKXCQA9/2b8kiqqxmTK7b3oke2O6SZBo9L+XEFgGOjJiNmQjlDFT8pA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 10:23:42.2809
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2a33cc9-c456-41ae-957e-08df156ee9db
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF00000059.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7384
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfX2CusMF+uepnE
 ePWa7vUfXu3ZfSh0HjtaSUE7a0SI27+trkQd4BeF1UOAmFfCH6Dhx7S1mucfkvmFN19VSJk86eM
 wBZ7UyhSoJ0J++0pbiSY867VVxEnTOI=
X-Authority-Analysis: v=2.4 cv=Cswq4X4D c=1 sm=1 tr=0 ts=6aad1130 cx=c_pps
 a=nBoeifw3k4y6eW1CqgP3Vw==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8 a=4oUWx8CZaJwu3DmIChQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfX219uUjLNW+En
 lbAyipQPfoDMzbzSC2cjdyDug8r2OG9xazb3BtVGDKLRHBXho6XyFFy5arkigohjwAi6Yz/fl/h
 Y/9Tq+Xso+Lq6l38vsbN7TR1V/Xxm0MbkS1fJig7NlGnJO2HsgeooIF0JjWMeBYK1sqUqC0zv4s
 eBqGyXYxwruJ80GAMyjmaiFS6J/JJSlsWHVXPFjmgL82bkbY/TExkKmqnq15bsBleHwD28bI/OQ
 pEEyy8fPfQ1NwCileRU+k7RADa6qWYpiHbb9H0ed1TTUwDp/USfNjIPgh4Dnal/GVmcfQ260LeY
 byA4rYTzLmcCYBCnP71G7KP9zcz06N5lncdOAZl3+6AGdIPLTvvLkXZ1jbH8P/DsXSVHvmJLfj9
 4Qyx/Wfe3KzSry9XbnvTwuzhAO1n3R891k6VMspJxbt2leQr9VbygbCcLmFGLiR6eretwepp3t2
 IOAbddEbzkTEts5ggPg==
X-Proofpoint-ORIG-GUID: 9Hy3pqMXI8MVVsNVG2_fb3GOM13WjKLU
X-Proofpoint-GUID: 9Hy3pqMXI8MVVsNVG2_fb3GOM13WjKLU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 phishscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609180144

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

