Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B14F4FECEE;
	Wed, 30 Sep 2026 13:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790773238; cv=fail; b=EI28ofD/LmadTxxena92mSoFqptQZK6lI+UcggMVd0oMRUOeIJUxSI7/7So3h7CmfjKwJ8PQneGvaEjdy1pfmqhZVzaZQueOjc5HYyrrWNqqWZlG97vfxozyuxC24D20gwFVR//MQO6asYdk70KRPIbJfjiSyJUC4l1Zb6j/ILo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790773238; c=relaxed/simple;
	bh=Fz6141O6onZO78SV7cw1hoqrEuLJOiXK6EO+PyIU2OU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=latMfWOyj+UJu7I6eVuwd6UgN0uX27D7905D9CVmEKser5TJuUn/qyKhL6oCqBS03QjzYy8nV+jliMBIiQL0DTStSEMsyLoUgP14hEUEbCh13lhElwbQYG5rHWwucOj50fAXO0m9wNwX4o3hfgx+O7HK4Pf8j4/ew5hbtwIx3o0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=JSdJ4nhW; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=IiaR+Oo+; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="JSdJ4nhW";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="IiaR+Oo+"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68UB5pWm3552705;
	Wed, 30 Sep 2026 08:00:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=t0WbCSWTB0HDYtz3eFDQ6ua+13hjlle1dIefZT9sX
	PY=; b=JSdJ4nhWa1niaGahW10F04hovCtWTqFSRBpSt1GKvxGYKsSaAXSgOGn9r
	IYTGv8xzn5DkpBSvJeKl8riiFY5eBBbC+ISE8iDr80r56Rz8fXAl9Oan/s9VyGpM
	Bl0eQ+bW907vk8RJR+DuilJ8mC5yrO24XlL45ps3n6GUeqWcrEU+H5WqqVwZLtQM
	y5qN3QngG2w4siKdW1CFy7n6hfKCXEaq5YRL/wYJgt6344DJQKwq17GSibwzzdUo
	65gLdJmI1yv9SdlDDqkqpL7Lnv/asVJdn4KIUv+p0WBOsPgw59FCol8xTzbeCZE9
	jEf9u8dQc2Gtw+rYDxwh48she/8jw==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010068.outbound.protection.outlook.com [52.101.61.68])
	by m0384305.ppops.net (PPS) with ESMTPS id 4h10s20qxn-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 08:00:19 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sY8zFFgpa2cMj0l0tJ3ODb+pbse0QY1xnDy5fbN8jMqcaUpG9h9INfR7yvGsEFEqq80rT61CsTlDEAYjiw3AZMqQzM+4ggG/r5vHFbAwyfzm52JOmNsDzFuHAPUG/3Zz8lzys/3rOQaIYPiocm6wvQ/vabk1sDN5qz+9uJnuwkcgEgzGRyXoXzgNnxxiH0SjelzYuWqvfsSlBmO3e2duHbYydW1Zz0BOhwQrXVVZJcHT6uiImbR97bjqyCAwiQsidYQluj6wZ5ri0oCOznY1qITWQM9JXaVeCuXzSo96Wb5hCN7rqL45P8eCuB3h31pUcFwYv4x8GmhKr+DFlc7tuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t0WbCSWTB0HDYtz3eFDQ6ua+13hjlle1dIefZT9sXPY=;
 b=OW3TS6xIDvnyw0Q+8MXI1DIypC8v2hDpQZH6RPuz4jX4irKa7UdOCQkMUfCPG8r7YyBKtSsXJcrvPNyhyWmRq0+YvjFdBXS4Z0Gd2RHibjn1fGbKBY12lNJQO4QR0+2J7T5VT50QtAhYlGZlB35Ei3+VC7YEXz6hXjyKxcKr+YDSdvxxcwxYsiKJSdTVyI50q81/DLlHg+Jm273JRVjZOW7UlL54dJ9FVSi0BP914qQX7CfjhCNIDFgz/c2731fI3fRS0SpIVKuHMigbko1cu8BuLEQ1aanN4CCact9t4IjCARVANwvfcJwHZvaqt5t5F3S2RXoSTWmNqcUubDBQaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t0WbCSWTB0HDYtz3eFDQ6ua+13hjlle1dIefZT9sXPY=;
 b=IiaR+Oo+z33nmiqEtCarUxmNKuBeBQEaDqwLs9BrookZtGZ62xTxmAUhWoM1dioeFZHd6Nm3/UUZAcYlI8CG/XgbOd+mr1lFqGHbdBkT7ejER/tjOippxr/CRpD5ehqeEZEMpNypBbQOC/IxRjohHAJ0tsGI7F6UwE9ZWQ+Bwa8=
Received: from BN9PR03CA0162.namprd03.prod.outlook.com (2603:10b6:408:f4::17)
 by LVWPR10MB997860.namprd10.prod.outlook.com (2603:10b6:408:3c1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.7; Wed, 30 Sep
 2026 13:00:03 +0000
Received: from BN7PEPF000000A5.namprd05.prod.outlook.com
 (2603:10b6:408:f4:cafe::84) by BN9PR03CA0162.outlook.office365.com
 (2603:10b6:408:f4::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.15 via Frontend Transport; Wed,
 30 Sep 2026 13:00:03 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BN7PEPF000000A5.mail.protection.outlook.com (10.167.245.229) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 13:00:02 +0000
Received: from DLEE202.ent.ti.com (157.170.170.77) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 07:59:45 -0500
Received: from DLEE211.ent.ti.com (157.170.170.113) by DLEE202.ent.ti.com
 (157.170.170.77) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 07:59:45 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE211.ent.ti.com
 (157.170.170.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 30 Sep 2026 07:59:45 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68UCxiZ64098515;
	Wed, 30 Sep 2026 07:59:44 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 15/15] crypto: ti - Change lengths in AEAD to u64 to avoid potential overflows
Date: Wed, 30 Sep 2026 18:28:59 +0530
Message-ID: <20260930125859.1749849-16-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930125859.1749849-1-t-pratham@ti.com>
References: <20260930125859.1749849-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN7PEPF000000A5:EE_|LVWPR10MB997860:EE_
X-MS-Office365-Filtering-Correlation-Id: 66f45d18-1073-4262-afc9-08df1ef2be1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|23010399003|36860700016|376014|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	prd67v6YCOlMCw6xCbB4t2gS0SGfhwozZqGmHjOGO//HqoG35cPA41xolB+jURx6qYBNoCOh598nCFUcRT3JqdJW1QcGEVDO5uxLexVgBgem2qd6PGVbGizu4vnqRbOI7ahh9foRZ7OT0eZ0sAV4bXBosR5jx5Mn948MrlKGBAKHdjPCZGzbJ5ah4g/xfIsbO7+h0nZKAUoFLZ20URvW1V/I/sC3b7HvTkw/ja+IlmnZOGuu9+f4dURnDBBHftn3PrTa41YWlzGRdlkkTL4wkdY334HJq5bbfelgDw9ZMGq5tg7iansEYcV83JNIU2IahQzz8hUe409rn8cDJUdXphGuVKKG+StevDkQ+E+OmR8ywXWXSo95QXqLTLJv12svSXtw7u/87tL7fN9Cd1GQujHSUM8HD/C20uiiYSew6vuh4NmJeT4WiLo5YKEGBCLpUzeuuhhznExajPShzl6x7xFnIHXMSasYvN8dZWfYlwfYUFbRgkxGyBXcwRQHFt21UR21lrSWv/MixY7ct81k9W/Ma4K8WgPHiL00GDCjDTHgDxZc9/iLMzqjfzHPgB+CIQIT6GHrapJvVvlyZOgxHghZm4gQe6i2b0Ai1ZwmEt0jwemV+jb6rYSNsEHzoQTeNQkDngym3Eb1Vy7RSD8lx/3vnzmg1F99R5wF1Y77vZI1Nh9nEdnmFBvReS5ktz0+C5ZcyLF3DUKdLf3hiDWyPA==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(23010399003)(36860700016)(376014)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	peuhuh+IQeD6iy5FGigfzWTqDcx0d29QXmnL4BKDqj0M2s9b4s9UyNXM2yO3gAWtmjHHj/i6QlYtDkCZtDXc9K/sxeph3U0CxjOjrxfFcvHeW04BTkPZDOqa+Cusj3HPtQsbMyS7V9c7WLt8EarLg+6qPC6Qc2QPXNa0Co5gt6+qbHeC2rooHyj/5J/yTkaf5a4par/Q5VP/EfJOI3knZ6SYGtWewtyOX9Rpe5LBRoER8o1/7MVLUmHsqReR0qhxLCdstf+TlhAafmthyQFEQJ3ujxeBjp5fSvFhUvhAZaiB1z3Xn/TRDXhw5m6DSGKTakZ7GWiCnKNet6Su8DaJboJSyT8l6BD44R2vJL/6rNUdkGO1YbT1l8ux9vZzcJSYeqBUKF62XQ7Cx3Rlh3bOvSCB0IY4m7Q8U66IwMzHALghA4T1OhbJ287cdiCTPbEw
X-Exchange-RoutingPolicyChecked:
	Qycr6cxV6MtzYVwazLnrjUT892Zj6fQDptFjZIglMBW7F3iyspJSSv/0+GaerjxMPB1oWOJm/ku8eHPEqhPOs3sOkH4lEZ1OIOIqyP8ITogiSm+lakPqZz2846uJ8ln2TsD6p9gtzdr8ti2DqnruIDzjtW6I1x5L+tndLddijcMTZcJpdxF9WQMAP9Q+LzbvsmVJPYUvIoncv+4J2I4IjrN5EaD/I/PJKSN6udJgy8wZcKxJSGWE/mZr0MOh0JE2VTJMlLCYZABFzPsRqpHFTi6hKYV0/3HySAARH0yYloZoGBjtI6R4ububNZ4clBFMWB746sOw/gZDjjy/fcANng==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 13:00:02.9110
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66f45d18-1073-4262-afc9-08df1ef2be1b
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF000000A5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVWPR10MB997860
X-Authority-Analysis: v=2.4 cv=G6aJgNk5 c=1 sm=1 tr=0 ts=6abd07e3 cx=c_pps
 a=UdDD+omNl1Ext3Jod4IcCg==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=rGLHzWtdNaH96TCHXsUA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfX/8ljGA4/XVJR
 hKnoNXGX0upaNnhfsx7O82/lGvvuAFz1n0gOjIC3GnMAXqLhKLVeeCXznk8upmTzO7xgBxjqy61
 j8Ws0tMwiSAtXNUPNl/sruYLCImTTzA=
X-Proofpoint-GUID: HO3PoOILMvaeltaZD-P-wBRBT4XU_aHo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfX1yEs9qFCGHRQ
 MQsPzOT8XLqpC92tbP9b1dGKF4rc+pumsZAo4v+3xW6Fl3/eVzocJdN4096Jn9FfiS8xG83zq7e
 KjDwBDW07r2dYbj+duQ8q9cvmPCCfyE/Acc0/XtWaYMUaCxAQnYMUbVT7h9UuVcQDgo1PJ6eH8Y
 OcILol68VGJcaYOSadVJd53FeQEhMayQGxfiUkHMrE4BGjOjgptu0+v28ma8Ix1x/V7E/dHhEJR
 eoQX9dKJAh1ZrOVNGiVjA7UYTf0bWolXGmYPvtZ5XaKwZIiKZ+nQcwRUeGKMnFQhG5hm+H5pjQk
 PpICN3MIkKMnagtwRfyfzK52l6vOkEWaf9EVNAXefE373EU2mdLQZkyXYHlGm9q6tKpNrMqo/5B
 oZvPO+H5pE3KFVfUlb0kW+kBnYnIaw==
X-Proofpoint-ORIG-GUID: HO3PoOILMvaeltaZD-P-wBRBT4XU_aHo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0
 suspectscore=0 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609300051

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

