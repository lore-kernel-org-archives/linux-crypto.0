Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238444C7538;
	Wed, 30 Sep 2026 11:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790767597; cv=fail; b=GRvgAJWDwjT5QSYidLGI75dnEttbeuAHiBudvVfCayPLcFCspH7iwxeaWbwIw96p0a5iKsUE+2hvS787DLs8Zbv/DZ8bxhUKBb/4wcfWvh+BJVT3sZx6pqn8fImYAhTVQON3KoY0XhNuKAfgYgIIWm70B64sC1WfQRTdr1TFcHw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790767597; c=relaxed/simple;
	bh=oEievuPIK77sfBoMZW0FxLpzHM0QEpV0zn6Xmu5kz+g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XAV3iK/hwpHBDXLdcP6XZrL4YHdfs0n993+0MDw3Uh9smipbH++PzNmXJAvE449qvJyOrSYIo8OS2ffCtEQ69fq92UaGBPQqHy4QGR/FWsTP9t3OaJu31IsYvHVAF/x27EIpy5sU1mH0zujSjAxNZE4atNyrDPVWLhQ8S3W9QZg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=caMs7LMy; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=T/++dx1U; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="caMs7LMy";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="T/++dx1U"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68UB6NHQ2715600;
	Wed, 30 Sep 2026 06:26:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=te8/Mzw9RHyzNtoGLCjV7WKPoR3c0V5g+TIMjgC9i
	nM=; b=caMs7LMyBgjKiZN0Wy0lag1TjsRGli/DPl7bUDUoDnDiQREhSJTQTCRAA
	/d9/ZtLx5mmEIboYRJ0qKxD/ky2xPmiZF6N8NSPVx8jWiiao0ZFONxwgCOBh2p5a
	jdS4oERryxdWyW4IKBh2iFSFX2o8Vk+VZz1LWoGGYKtNmc6W8uIZrHiAEsGO1EjH
	wZpVDQsVsvCzK95Tmzi8LD0yOGVawUL+6OdyPohDyAPjwbMGNCkJzf4c61DKo9y4
	tWbZdPqreFKjyLTt19kBI7cGJ30Hzs3JBUuFmixmim1JHxAzMYHWGDNHXUwkYWRP
	DFgmJBxPf5FAlPVr8EQu4ZistFjYA==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011062.outbound.protection.outlook.com [40.93.194.62])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4h0m9fcuqc-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 06:26:30 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d1QcSobeFQ0V7dOsesle2hVqCBaRExwDd+Kdq1teepoJLAe854F3t4CnueqGNiwuJdYlXGF8Dp6gMWeIM0cKYapobpcSnyx2M46Mr6Q4oBfx3630HbO0f/usgVEZhOdW24fPjZLhFenAtfrigL44tpesLYendwp1k11ltbpk0Qi77dsg3vVhPnMiUSM3Qk1nfpHY6eaA1TD5bHX7Uxs8tV6zv99Cy1Z+UQKg+o9XglK88bSdVxFUWeQ9dY73H0kSBHsl0ixzJkfznd4/QJ4wcZYxDnpXDyhk5Z1dRRkx952Ab+jhRAAkfLw1Gav5P3x3YHUiGxX5aGT50t0FXblBnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=te8/Mzw9RHyzNtoGLCjV7WKPoR3c0V5g+TIMjgC9inM=;
 b=K/nmqd1htsdVeLzPx/uJOV5MW6aikDy29pvUQDIQMAheJV3RHcJHhsIgEgv1u5D+vfXPUCTjGub9yDolIXBtQpC14iFFHV6K+/I2tEaNvj9KIpCzbvEDn1BrKClaLlWY5X6AUl5lM1YD6nq6WKeSHurCnVCouY9Zfv4Wrh9Yut3zfGsY4kLk2krowj+wSj+xIqVjVfEIR+MT82j/8cTww6il3lioydWQMHCIuHRfAcxMFdB6Jb5ND5P/PMf3UbwnYkiebTzx0nhJzQ6f1EnYHVfVj/nWeB33pPSGojJx6SaiKFodW4j3sYR3r4pM4fRFG7n76KghzJGLWKtyn997KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=te8/Mzw9RHyzNtoGLCjV7WKPoR3c0V5g+TIMjgC9inM=;
 b=T/++dx1U8/+EWbApYdKmONYEBlDBYB5h83qd42LTIf79IGIW4I0C5rOB/InMGED3WzZjIrch0stSUx6xwRSmDD0DeY+ksyiZPd39qZevwPpjvZDx9RHWSBTR/gcmVSJ+USCA/K1E7DSCTIqbsudGG3hcTsWzUL8cnIXlOVveMsw=
Received: from PH8PR05CA0009.namprd05.prod.outlook.com (2603:10b6:510:2cc::26)
 by IA3PR10MB8735.namprd10.prod.outlook.com (2603:10b6:208:576::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.7; Wed, 30 Sep
 2026 11:26:26 +0000
Received: from BY1PEPF0002696B.namprd05.prod.outlook.com
 (2603:10b6:510:2cc:cafe::ab) by PH8PR05CA0009.outlook.office365.com
 (2603:10b6:510:2cc::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.15 via Frontend Transport; Wed,
 30 Sep 2026 11:26:25 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BY1PEPF0002696B.mail.protection.outlook.com (10.167.244.155) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 11:26:25 +0000
Received: from DLEE214.ent.ti.com (157.170.170.117) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 06:26:05 -0500
Received: from DLEE206.ent.ti.com (157.170.170.90) by DLEE214.ent.ti.com
 (157.170.170.117) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 06:26:04 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE206.ent.ti.com
 (157.170.170.90) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 30 Sep 2026 06:26:04 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68UBQ3qT3025350;
	Wed, 30 Sep 2026 06:26:04 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 08/15] crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AES
Date: Wed, 30 Sep 2026 16:55:26 +0530
Message-ID: <20260930112533.1593952-9-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF0002696B:EE_|IA3PR10MB8735:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bb232b2-2a22-47a4-66b5-08df1ee5a9ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|376014|1800799024|36860700016|10067099003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	ZbrqV9WgHX27fHjRWUfsJmLeraCym/+C4lx9Jhy1y6OfZpu2rE5hu4VQ7iEvnPuF6sEnXh2yDwJZAy/a6iXNt48ajZK2iuAsJtSfux5UiBCfjXETCLsKp3qgON3LbhMf/w4rfvPC3YJWjdwMWfu0mkxYjUcRWy4N8un44JLBjJT0NbvYlu1iRyQm/OgcjlcDgzSwS/7SmbDHx+98+5nNr4zTNxKae3e4W8/ZUtVIT1T41fp1Gsu5JoKx57cw0QabVCnGq6UULyu7Dk+kZC9JGmPA0XdpsOqpiJMlpELNpCr8srIS/xod+gR3sgvnhA2EZwo0aGwCPEnWVgOxZdUsc4vZCJH18Z7McB7vDpodQw6DkMSkmwvlmAbbXLs4bTzVWCfaQ5XJPq/WXZOmIt/PRWXqRlJyvWqp1kZh+lKtZLiqeH47pgFYUa502ZJ7ivwbMvDF6rrirQ71s5pXV1YvC+LeF5nd9Gx39jFja6ARpNg5/Uitl1K5SMn1wrKeWPQXt4Yi5hIQ1yZS4UooJVLSJTvBPnhfTtAktu7Z7svHDMtTdM8wcPCSlNtgXiLNMY+syySwNowXGREbyPggD3SNyTnnbC3DM6RrvcqzuFCvrXWRgQZFaCZ3REj6+fDdhErnf3HCCMQJdv0tYLSW3v32AsyIoieWqCPfP4WgBTZlCFSVAmhI2Lkywn2nPFFwOoC6m6XMrgDAkZEMgyRiIGm0Vw==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(376014)(1800799024)(36860700016)(10067099003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jQOYXtcVog6wSSP8EIU8kS54NcmO0/zTUcz1CRbIbqzWC2kFMYm9P29Nohqh4CXFKTRi4UJcFGqCbcUCGBIGXVL/XsVfNuW3YvfT5f7HkC1rgDj37Xq5bku4YA9382l5AatOYegdygRg1gAsEhHqs3l2aASQCp5+cTD/hbX0QN6iOM4bIMZzfBMJuxzw8Y5oiKdOMnXFuIciEj1+BbWzqw0F5Au/lPFku/PwPaTDQYa42DDWbwAjt0sj8xMz+q5K2pn0X0AAsDwy1VBNPTHbl9VbeWVOPPnR1EjuRCv/dsm5ln+oH0LoiTOcYQi/jGclCMxQmJf3Ku6oHpul9UbFXEd7AmIcgOm79lE30M0IxijGyRw/B8iCXpuGSlrma5Cnqklrd9XMfXJV0ejgP5KeVn+DLx5ZmL/J3mTNs1taMe+WFzjteMHxNaeOU1lFVAfQ
X-Exchange-RoutingPolicyChecked:
	TI+YPpltB/8Vr8Fa3DZfUa5FaEyAWvuDfQqHYQ84WqnbWATJll1a5fSo/3ZMG7CdC8WwDTsFwk6bFfvydHiv15Ok4uLgJZRq8CXKq05Nlg7ApPRxTAPCaV4tD52cuKcj8sENuq0dFybk5SishVL0Z50Wm2Xs0dTMv325igWLlhoiIjz32GCigOj8J88X1pwmIwxgYEeu7zDL1ML32uJv5FRgfLqW7oe5/9d0klQb0su2MigRBUvWZJ2bhme9VUNQfMqMWtIkkTvbANWx23iee8jAj6b36zONnZpqDlVKOfabNvlYh9Wk8ruynmgRnI97MpHTMk8YrSlzhxUCXHeOEQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 11:26:25.2439
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bb232b2-2a22-47a4-66b5-08df1ee5a9ba
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0002696B.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8735
X-Authority-Analysis: v=2.4 cv=VfRir1p9 c=1 sm=1 tr=0 ts=6abcf1e6 cx=c_pps
 a=MAgfROEylrrND5Jw8NuT2A==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8 a=wrH6CD59uMa574BPOq8A:9
X-Proofpoint-GUID: C55hErea6Dgm8FsN9Sgau_RNiJQfGrMN
X-Proofpoint-ORIG-GUID: C55hErea6Dgm8FsN9Sgau_RNiJQfGrMN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA0NSBTYWx0ZWRfX/lKuv+Qyx8XL
 yRf/BLCCAZFVMMzJUB4zo/ILsCfyrD6UwMjCK0CxdtdT8M6xsMsy0iuWiTyajNCRl17OFUibhvc
 +6DewRVlOJIFgTvQDvOdFlOgQW/asNrRwoqZRozY2EpjBuj8yd0Ylb6kTW0kfE5uzysaWd6azlx
 YD+x4OUSf2H8pjlEXP9cs4z9mvlXmcd5ikIGWjnv6rp77LSXWlIJq69OqTbbfiXe3VbZtfns9Uj
 ajMyhPoO5ysSpF/bNbcrVtSasHP0ZZbhn1ZshPXqZFtke98fLspsA4xtgXFMB44gMuofUmXK792
 hYe4nPNT3g++yyWzqo34dyqhEkYYprGIlqakQtBcWY5s2lP/vR3sJQ6dNy+dzfvXCxIbg82AHkI
 mvq1fNMLgAM4fMx4zPEZX387g0XOX+Ttza1Wc14SkhLWMC7IOdO3eUBCPj23hFomOcX/QgMaqfI
 dPxx3hvHXlPf7mdUZnQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA0NSBTYWx0ZWRfX2dimciU0cIRv
 g6Gii9AV+RSngSHqrMM/wMaSO1SAohZxIiz1NsUvLSNykAKAxFtokSPGjttuegtfD6QPLaowZp/
 Gf81vLDQrTSONqegCwlUcmiyZsO9030=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300045

sg_nents_for_len() returns -EINVAL if the supplied scatterlist is
shorter than the requested length.

Add explicit checks after each sg_nents_for_len() call in DTHEv2 AES
driver.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 83d964e884086..0447144b77ffe 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -354,6 +354,11 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	u32 aes_irqenable_val = readl_relaxed(aes_base_reg + DTHE_P_AES_IRQENABLE);
 	u32 aes_sysconfig_val = readl_relaxed(aes_base_reg + DTHE_P_AES_SYSCONFIG);
 
+	if (src_nents < 0 || dst_nents < 0) {
+		ret = -EINVAL;
+		goto aes_inval_nent_err;
+	}
+
 	aes_sysconfig_val |= DTHE_AES_SYSCONFIG_DMA_DATA_IN_OUT_EN;
 	writel_relaxed(aes_sysconfig_val, aes_base_reg + DTHE_P_AES_SYSCONFIG);
 
@@ -512,6 +517,7 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	if (ret == -ENOMEM)
 		ret = dthe_aes_do_fallback(req);
 
+aes_inval_nent_err:
 	local_bh_disable();
 	crypto_finalize_skcipher_request(dev_data->engine, req, ret);
 	local_bh_enable();
-- 
2.34.1

