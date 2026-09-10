Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1042394792;
	Thu, 10 Sep 2026 17:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789063070; cv=fail; b=AHnJKIZ+aNNh5pBcoOxoQvw5c22Bl8XjAVk29BuKq9OT/gMJYO8jj5xFtRatnUP7vmvHjhDN//MleNGDyOgDOvIGG4X3bo5Fj/mmxH+uSyL5DcBcE1mT6RnYBACuaPlGZbl8yOK/mAv7qtgIFd4wfnbJupBTEbnGx3HnUhrpQ3Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789063070; c=relaxed/simple;
	bh=8AiEGfb8lJzH+XTUake6thyKV3Zd4kzDjnDYuThYIjo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H8p9ZACC7ZbmJQe2hJvOYKq2+HTzHNfHYuxGZJ9do6QxgO0ewyBuDZKZtU78HGmqvu6L6HS7eHOfZN6M6QF1kYI4amUdT+4BPQH7EVEVXtASxHiDCIhjJk7yEPW+HiYz7xmwbeZcttYt35Cx4YD6QknJ4f4+LHeuzg/6Sa1YQBI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=QX0v0y3A; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=AUhC3S/B; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="QX0v0y3A";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="AUhC3S/B"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68AGGC3P3546611;
	Thu, 10 Sep 2026 12:57:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=w5beXwKfniW4zqbzhimEbX0XKyemxYErkY0Kg3dQT
	7Q=; b=QX0v0y3A5Bk4DT7teTVE/KZgY8IhbAw9wPQOf7u56zuIktOcy6dlyaSRv
	YTAWjyKA3ZBFPNptzn+awqZzGVfnpKns4vW7mllxs7MtTKS9uBZoXk6EVJ4kTmbG
	9rRtBlaYALPR7T+snCxUH7IS2cJmvGcYRkkmOo/jCrWn2bm41oxSYPn3Q52vdLnW
	2MFfKH+PrG6kpJ0YHRLptQvvYFQySz7McIhk1HmiplJo2dkBaFAJq5mPMoQOkeM2
	gLsyP7OUKWByynR86b5hxjja5OLQUtliHYhqky+DMJKEyzCsI8g5uvhWrMg2aIVe
	hWkP8yNC+IpvnYp+bgFMxhzQR910g==
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010055.outbound.protection.outlook.com [52.101.85.55])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gkyx20n7a-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 12:57:33 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eLIHEeK4Z87V8sZaxyWNn9czZx941iDDXaq+VESdpc9LsRoQpSwej4wu5OyrF4OlNGXHslmHJlxOpXseHdBLEXTVsbl2UkYa8BRktVDV/xMYDfL5uegdOF7frXmt/oZPzqLVZ5AYASIfYN9OnaXs055sxfP1HJA/MxuApCDaI1kd0LoC+HVSeXYWMHzRpRDs2SvTPoQ7rN1rCEgIAZ0JyeJylBKO39mXsjBv5rrjGR3A3ZbJ2PSIjaq04WsrUEOzP5vVtHdULIq+jJZ97GXM5yu0KGM++tFNtpFQ06Ont4l2TzyDpaYjMxntv7UuwzeVkLho4kt4dqyWgmAmKB2gGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w5beXwKfniW4zqbzhimEbX0XKyemxYErkY0Kg3dQT7Q=;
 b=gRwJQz7V0mBUbJdbzPDaXgV6Ej4XrXt/+J//8sTzL0nzK4TOk0pe3ZWm7h5jITwP3XK5Sfx357AwevwFCj6o2WB2s3jakwwXe5n81ndKQiqT8yB0RMc9k+tmsIXQL/Y59cyAgpwRUjNwn3XU2mqroXIvKxV76KJxI0bj52uvwvqMULZpfIGPlvCK+B7olM1VvwJZmbGNrKV++V9Fdgl8N9uLQAewnq6NbmqHveL61tB3oosB4nYlWxWWh0lZfx0Ofns0V07pUrbE5G3vDGlFb41ZY1bKpHIKS4j2+fjY0Lz6l3kVWKJrkEwtyPgM2YGsnuVkwAKjSBJA+4SSdcF59w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w5beXwKfniW4zqbzhimEbX0XKyemxYErkY0Kg3dQT7Q=;
 b=AUhC3S/BGybExczZiPXBGpgrlEX6bESla4Jhz6mh90J6SIiuRN6XbpjgZGiWx83Y+mfZcjPDwAolW8Km3DgCZ6uoe7aOsqdR6Yd8XK0S3bLKYBfy1IrUaE7HPQvA9MjgKgl/IW9l19hQPZVwBp9jv4CSTcNm9OlKWsDRV5K9PsU=
Received: from CH0PR07CA0011.namprd07.prod.outlook.com (2603:10b6:610:32::16)
 by PH0PR10MB7099.namprd10.prod.outlook.com (2603:10b6:510:26d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Thu, 10 Sep
 2026 17:57:29 +0000
Received: from CH1PEPF0000AD81.namprd04.prod.outlook.com
 (2603:10b6:610:32:cafe::5b) by CH0PR07CA0011.outlook.office365.com
 (2603:10b6:610:32::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 17:57:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CH1PEPF0000AD81.mail.protection.outlook.com (10.167.244.89) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 17:57:27 +0000
Received: from DFLE213.ent.ti.com (10.64.6.71) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 12:56:57 -0500
Received: from DFLE215.ent.ti.com (10.64.6.73) by DFLE213.ent.ti.com
 (10.64.6.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 12:56:57 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE215.ent.ti.com
 (10.64.6.73) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 10 Sep 2026 12:56:57 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68AHuu772793780;
	Thu, 10 Sep 2026 12:56:56 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 09/15] crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AEAD
Date: Thu, 10 Sep 2026 23:26:13 +0530
Message-ID: <20260910175619.2122149-10-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260910175619.2122149-1-t-pratham@ti.com>
References: <20260910175619.2122149-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD81:EE_|PH0PR10MB7099:EE_
X-MS-Office365-Filtering-Correlation-Id: 900a9bfd-8b67-41a8-2862-08df0f64fa21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|1800799024|36860700016|376014|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	O8vqYosgBwGNQCLX8nql0StA5XbhijvgR4a7fblrjIFNFg88MA0ddhsxxdmAaMNLr/TlvIBuXPUB/jNjlEiQAhQTZOcXE+A2fEGTUfXf/6ElqIAkbQqE8YBwAImHSqYtCncBerT5FB+Du9r2AHEWHuDezlkuV16qOsFYz7P/0NfLF76N/+hgJ/C0QQ5UGY1ONs82m8HCMGvM6p2SwX9kVgPWZMMitw4s1rNqyhf9WUXNEyFbp3OYYVqomsSXwx+VtfT2YCU0HVw2Twoh9qpZyN7TW6Uv/5yI6W8+bIx39e8tz+SfybsfzvKup1a9vmXk2y02yRHOA4R7B1pIbilDCjnQz9tj2oqzOjmEjlwXzkCJiP9y7gvPs1/QarPzOiqkb+ZEdk/rhS/C9VvS6CtpDXIIEg51oE3Go0qa8W4biiJ0x4NBH4pRuXtCkEBC4ZXOboh41Q6mtaJuO8TPptY/dJsvjsDuAQvx0VTfsK7QuPkoGo1dM1cBt9V+MFKYCELIPzGiW6khBWGaI/YE6/Y5SxWLYKjJgD+dSgj4XrJCFLU90CDpOM03V92zXMo+V9bYq6OEWskfwXODAKS8nTNYoYUF2tX6qEa8rDsFh9386s5tNQ1i+ZmlIzNvXyS0HiE+QDZNtQpL279yPBOJkyxz8etGlo9byjRnKMYbIqeF9EkoOU4c89n7nCFzegguoVoMJMret0X0N/SGQVymIleaOg==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(1800799024)(36860700016)(376014)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	A3wQC6x4MgltuyB7CTtF1rJRTMIK1ftgHo8NyACz66PkJfqviogbufLWKgHN+KBUrbgzB+xp70jQbaOQXtiIUfBWgjaufA6x2zRGxTItbni2/8PeNa9Z3/yMvxnrRchXlJDLwG0+NmVdvupgZPBXTIQ/l5h/TqjOvYkCYBSR9rBz9qUxIOPM3vhNblblC16JhGabhBQQVGMqdV0rX6oEY9sPdWJeC6YyhkGDSZiNpWLFQM6wjZAF5DesD2oiburzFgL9JKmRbIPQ3tkVrnKlOAOALMgNAIJbjS43Cu0NV7eKTtNcFEo6mJdcSUmyd2zuuVo1QzI7ifkPAE/+MxKLIk4FoqpAFStqToyrUijB05clyy0tWaaZKjGkX8P1z+Sd36t+AqO9kt50oMElgZl89zJu7pUyoMXNqinZJN8ooWkEPpe3XJUiMwlB61PBiuuv
X-Exchange-RoutingPolicyChecked:
	5qPPYaMlmNsnhhkCHorayz6rE09R6g2BQCzGkuR4yEX7eUS3h3ufVWVJPN82x5TT49lBlvFIycuINAKUbwxOMkF5lplrYJafkJRHj6C8T+toTsCYTzy3Brb0/x+FeNVudAkW+O81QIejmnU7Vp34+1CrneqEZvFlB/kt+MTNXI32zmBqpjJlSCwjLaHLGADhoBu+MXaUcLjenBz7F+XOe3vnXHHvSZ1tLW/1H72wQ0J3X5eEFdMOfLlS9LAyi35P47FaEruJdkeXDnIbEYvzR7cRoOYwtTgF23BIwBXzflen3iEUXaMAD/1CrzBhGNCl0KM8uoBWJQxG6ct/dxUYYg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 17:57:27.6482
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 900a9bfd-8b67-41a8-2862-08df0f64fa21
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD81.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7099
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDIyMCBTYWx0ZWRfXxgaXptNakaY+
 Kzv7fyDX5UM/xKylwZcVBtNZzKDedCpzxYYBwyNk1FenCrZ5jFfPWjDtEpx2DgfA6VtYS9xXwF1
 O6mFgv3HgoOmeMjQ3OsWE0ZDwfeKLy0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDIyMCBTYWx0ZWRfX3Vw5bIX6WWEC
 o7rMgHc2ywUTMUwDLcrUL1oACtL8WrpYiITd4aTJCut7HBxZ5cphhD0seNOee222/ajbcrwj6nY
 TNTqjc3ekuNB0gzjXeenCt9twR6JRxTCiHoLn+ngeRP4ZPlzILJjX1aEwJowjA/MZLv7hrHsej8
 TxIFVohajINEhg8njgNkCFrc0Qcf3kXBeLxQ+ch2fNIfWmka7EI6GBgnchNBj6/UtardpniQV+A
 lBISK3nGhSReB9PL5Y0H3MjO+2z4AETHvVxL1xuBb2+j31ZbOMXMOalZvNG//8XZCwqxZ6ykZBM
 T/g+ZjuCD8LeOaH2XYiXazD/Zd+OaxdUEafeEO6EXyicNb9gAwPXIr0Sq9e/pelEcGwa/oKFoQ0
 8ritQAAJ668lk9JusSkGL1yN1H6+Gznx9LzMSvghVHgtH1MenJ+c9ZvvAy5nn4j09AK5OEHTav6
 V+p0Wma9RJxxntZgwdw==
X-Proofpoint-ORIG-GUID: 86JtwtqgSEV_07C0JBhTJZrWOt4FuCk9
X-Proofpoint-GUID: 86JtwtqgSEV_07C0JBhTJZrWOt4FuCk9
X-Authority-Analysis: v=2.4 cv=UJ5Ijyfy c=1 sm=1 tr=0 ts=6aa2ef8d cx=c_pps
 a=25083kmBgh9d5ln0vqlIEw==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=jwouBfj2j3NM8CExmVVE:22
 a=sozttTNsAAAA:8 a=iMD6g9N4YQ2QoEUmFGwA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_05,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 suspectscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100220

sg_nents_for_len() returns -EINVAL if the supplied scatterlist is
shorter than the requested length.

Add explicit checks after each sg_nents_for_len() call in DTHEv2 AEAD
driver.

Fixes: 37b902c603042 ("crypto: ti - Add support for AES-GCM in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index bc3591ec58a1c..65a53fcf80467 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -641,6 +641,8 @@ static struct scatterlist *dthe_aead_prep_aad(struct scatterlist *sg,
 		return NULL;
 
 	aad_nents = sg_nents_for_len(sg, assoclen);
+	if (aad_nents < 0)
+		return ERR_PTR(aad_nents);
 	if (assoclen % AES_BLOCK_SIZE)
 		aad_nents++;
 
@@ -697,6 +699,10 @@ static struct scatterlist *dthe_aead_prep_crypt(struct scatterlist *sg,
 		goto dthe_aead_prep_crypt_split_err;
 
 	crypt_nents = sg_nents_for_len(out_sg[0], cryptlen);
+	if (crypt_nents < 0) {
+		err = crypt_nents;
+		goto dthe_aead_prep_crypt_mem_err;
+	}
 	if (cryptlen % AES_BLOCK_SIZE)
 		crypt_nents++;
 
@@ -756,6 +762,8 @@ static int dthe_aead_enc_get_tag(struct aead_request *req)
 		return ret;
 
 	nents = sg_nents_for_len(req->dst, req->cryptlen + req->assoclen + ctx->authsize);
+	if (nents < 0)
+		return nents;
 
 	sg_pcopy_from_buffer(req->dst, nents, tag, ctx->authsize,
 			     req->assoclen + req->cryptlen);
@@ -777,6 +785,8 @@ static int dthe_aead_dec_verify_tag(struct aead_request *req)
 		return ret;
 
 	nents = sg_nents_for_len(req->src, req->assoclen + req->cryptlen);
+	if (nents < 0)
+		return nents;
 
 	sg_pcopy_to_buffer(req->src, nents, tag_in, ctx->authsize,
 			   req->assoclen + req->cryptlen - ctx->authsize);
@@ -973,6 +983,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	if (assoclen != 0) {
 		/* Map AAD for TX only */
 		aad_nents = sg_nents_for_len(aad_sg, assoclen);
+		if (aad_nents < 0) {
+			ret = aad_nents;
+			goto aead_dma_map_aad_err;
+		}
 		aad_mapped_nents = dma_map_sg(tx_dev, aad_sg, aad_nents, aad_dir);
 		if (aad_mapped_nents == 0) {
 			dev_err(dev_data->dev, "Failed to map AAD for TX\n");
@@ -994,6 +1008,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	if (cryptlen != 0) {
 		/* Map ciphertext src for TX (BIDIRECTIONAL if in-place) */
 		src_nents = sg_nents_for_len(src, cryptlen);
+		if (src_nents < 0) {
+			ret = src_nents;
+			goto aead_dma_prep_aad_err;
+		}
 		src_mapped_nents = dma_map_sg(tx_dev, src, src_nents, src_dir);
 		if (src_mapped_nents == 0) {
 			dev_err(dev_data->dev, "Failed to map ciphertext src for TX\n");
@@ -1014,6 +1032,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		/* Map ciphertext dst for RX (only if separate dst) */
 		if (diff_dst) {
 			dst_nents = sg_nents_for_len(dst, cryptlen);
+			if (dst_nents < 0) {
+				ret = dst_nents;
+				goto aead_dma_prep_src_err;
+			}
 			dst_mapped_nents = dma_map_sg(rx_dev, dst, dst_nents, dst_dir);
 			if (dst_mapped_nents == 0) {
 				dev_err(dev_data->dev, "Failed to map ciphertext dst for RX\n");
-- 
2.34.1

