Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D2247884D;
	Thu, 27 Aug 2026 13:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787837148; cv=fail; b=A/vAOB3rcCfPb/VGjokwlXYPXp3xCro1WEiCPSWxEtyS5wGo8KRU6cCCmy5E6p5DVupFX0WpEak6OO8JpFQgaIdMZeY5XrO6A7QBTAtg/rO+2s56rxYS24pnSoC4rPTniryrPIVkfd+m8ddYEQzfe+qbVOPxsF9oZpohjaBw/Sc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787837148; c=relaxed/simple;
	bh=jTYoPoOhly8dkTl47Kzm10+YJ0U9qfjzd02BRFKGedQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NJ0R4eJFWTcYTx0LZjSIn9Yg3mixBdMhHobqjSn4eG6y6LlSEMFl7x1lauxVF3khZXL2+G2nbVOzfCv/20qzSJ/Y3g0ODqrpi8x/S2bwNeaARMRi8amvXnivrX0unBUptE4vI9A2JFnNcXtOOSObGHkJEfAv7loFMufY1FojY7A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=iUTarMVe; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=qppSJYRR; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="iUTarMVe";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="qppSJYRR"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67RCAbno3085580;
	Thu, 27 Aug 2026 08:24:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=YUETm1FHVRgLRqlPL+dlFq444iqcLJEPmcytpsRYU
	lg=; b=iUTarMVe5IpUwpffDm7GyaCUi6YV19xeMVSDa8RAkoh5dA3wWq13xoqNp
	vM9D+284ClxGbVzhkAGwCp6qZTFeNg2+/d8GmM3ZHeOzNWWQilGHwHIx/G1pTimD
	UaJpBd5NTA+cl9/j2FdNMYUih6tpJU6li0lGSwWyvdWV7DUsu7yX7/3CDUTo/YRI
	66ghZYHsa1uk8ClsHSQpud9MWXTK87gJo6tk/Sa/J2lnGdxuBU+eA1QnLkrtZwuR
	EUFR2hPLShkCvDKrh3IcUTXSCPw/Gha5/3F0Hs0lQh8vYar6AY0XGqbt9AjQaARA
	SR+cAXI1LsZ52xweyljHmUOvnuxwg==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012010.outbound.protection.outlook.com [52.101.43.10])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gajhhs3ww-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 27 Aug 2026 08:24:35 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xa2xb9+k/yTC2n7BSKO6M7K712wnUsrudeYQHHS/lMe8JSWDLNrC/femMTSS2zwuU7h5GglNcp+NKrLIONzJ9cC70Jv1Cvfq9dabjkg4/BG5a9t7LH+NLsNTREPCA8Gm5mWsUUE1EIj5z1vtl1hi65Qqn4jydUwtq88+Xeyn/yYw+YG2DEWJ6uzxAZixgOVDyHO4YyxJTpvufIzEFegaDJNRuhA9AOHCkh4x2VvNM7h0VxgEcpcLRFSFFJeclQIptAG2yvgroB2a73tN/WAhQ3F/tOW7BLUwh8vDVvddQFKhVCZAp4zQUf2lNDoBeYOmQCl3AQFJqkDKzl6uB6rS9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YUETm1FHVRgLRqlPL+dlFq444iqcLJEPmcytpsRYUlg=;
 b=Y2MVNhE+NguOwE6zXoHQ1tt1TusyPZNxWLUq0xKjrj54c8LCQNTfS7fAe7tg2fBx/JfEQOg2QKBcymz3oXXLsmHIj64z/CXlaWkTxe6LrgtKxWwswnkgvQsKSAuVC8VW4G3b3InmylRs4VfFUr9qCM/WBYmdhpLlCOhLV9csx6K0S1yElsCPQJd+UYkQX6/3a5TfNDpe17+Z6655Gh5mxVwNOfuwcylT8T8lusygvE8vX5tCEcLwzlrN09OBp+wTO4R3a6P6xk+dv54BOxiDKdM20y0wqb8YQA0DZOd6kQT51k4T/i5AQiX0C1I6K9iTj9RnhWADFzp0C6heKjydqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YUETm1FHVRgLRqlPL+dlFq444iqcLJEPmcytpsRYUlg=;
 b=qppSJYRR8kSAHVFHdIcw2L17NM2kxlnygoT9DN81MHpddFb8IR5y2ohUARZf3CsZDc1nYi9DrLJayv7jOqf0at8HK29in2+q7xlx6FzRctqt2zp4bymcWV/6mzUR+iqx3Ct7/un8led/8/UeBwzzpaOrLiJAXTPapZyUBm+nihs=
Received: from CH0PR03CA0200.namprd03.prod.outlook.com (2603:10b6:610:e4::25)
 by CH9PR10MB997859.namprd10.prod.outlook.com (2603:10b6:610:341::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Thu, 27 Aug
 2026 13:24:32 +0000
Received: from CH1PEPF0000AD82.namprd04.prod.outlook.com
 (2603:10b6:610:e4:cafe::47) by CH0PR03CA0200.outlook.office365.com
 (2603:10b6:610:e4::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.10 via Frontend Transport; Thu,
 27 Aug 2026 13:24:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CH1PEPF0000AD82.mail.protection.outlook.com (10.167.244.91) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.3 via Frontend Transport; Thu, 27 Aug 2026 13:24:31 +0000
Received: from DFLE203.ent.ti.com (10.64.6.61) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 08:23:47 -0500
Received: from DFLE211.ent.ti.com (10.64.6.69) by DFLE203.ent.ti.com
 (10.64.6.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 08:23:47 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE211.ent.ti.com
 (10.64.6.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 27 Aug 2026 08:23:47 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 67RDNjMs894272;
	Thu, 27 Aug 2026 08:23:46 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 6/7] crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AES
Date: Thu, 27 Aug 2026 18:53:17 +0530
Message-ID: <20260827132318.613876-7-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260827132318.613876-1-t-pratham@ti.com>
References: <20260827132318.613876-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD82:EE_|CH9PR10MB997859:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b267fe9-b807-4db1-6f6e-08df043e8755
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|1800799024|376014|36860700016|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	bNoC6zBxWOZD1b8eYHfi1a8YXWvLROtfZmKZ+WXYTHU8X0nTkJ04TqL+pqfD599nURefsEGTMtfRI+YMxu0IPkcbR8KZOJ+bPQ5ENSCSTSY9+FxyfaKCD+UbtX7GNRCSuY0UeltsJm4uwARY9oybbDjG2Ro15rUQPF0FhsXit+7gasyjL+vvlrRMsvaN/r6ymH6tHFUKJnD49spinwyaMvuSHO5w5o0arfkOT/mZ30QkV17sWtuDp1UdYGcmJH1hIIqNFTZHWaPVCDSTFXJkZt1L1JR95WcjKFirLxkizviG3qHkyv3UQ1tO7nbGG7Z1tYgNpgbKlvFIWv/1jF/MetiPx6heZmx5X/8gXTTQGmRmUGTDf8/cSZj6y6OMYP3+wn9twFSKtlzzbPoQ2zj2aDmzcttiZteHMXvMsJP7OhIB+P2spMMmMemjNuXEXBG3akygjal8h4CJlMYtTXFnc3R7XGYfuKLBxCCl09WlrkPrDomlT/3OXsOqGMSe84fIk1q1zYWyyn+t3RhA8EEzUDb2Vx8kW6YhmVS+JEc31JdAk0AN6jECwBHF/BraHA0jApu+txi5GU/GslrnQg3LwRP+GaWGDJlgPmfHlzKiclbsH33N4qKljfVPFAi3TJvgK5sRTMUWhAVTXwW3rqUvp4CJUmmX2WpBKgGN+Y3dWMpERmVBqAwgq5qKut9qM4GT1aHtYXuXz0gIOCvZZUBlxw==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(1800799024)(376014)(36860700016)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2LsfrVW5yaEMYl3j7KCcDXlaXwYgX+tDiCHHrGTNsfDFvvltYECzhM2Sc7/hU6Fe9LGtvQ1uJyuIOV/qrSbVfR9XQAPkoHQDp9sjEDZkb0aTid3MgwKo4Y+1asc/D8JhgyxpyU5K6Ch9rpAR99SpnqKCoby1OhVAkgRFKYb88jTFUW9RHQyOUybUAXC+L/pv8WBCw8AeKaTtv2lkpnJ4zgKcaegpDkWX2fCv09uvjePPd6e89MYryfxtuzvSlKB64zDdV3cfEjCJ7L/ybA4utT20WCXt1aV2rkUjxCL2kz12TBq3wFpwDsc/g+bVWI+lrZ90/WKJdpzHbf4OKuuMEMSa3UnHB6QJeo7aMF/V5jg68aIpmuB+FsvTAqkQsHoSXtPPMALR/tlJi3mXkjvEPPC8vrVLveGdxrdQ/sZeOARcVml0HiIywOYVcfWWrk4S
X-Exchange-RoutingPolicyChecked:
	zCK2dv1bl8i6qdv5QnPbFqGEhYshRnztWGikl+3gH4OtqsdnSiRnJycrBR9G9wk3aSS3J1lr/TFfC4dbEe6qVhMQvZgB2LmON/Cye4zBdgbneEZzdH+nUb53aPGYRQlYEPJnw1ltvr46JiJudxXuJ2Sp5NAdSavWbpbOC6t7nG7rnHhWbqe4srDLTnu/FQLzxxF0vmNIOasOjTI94l68Rffo7MauNYrkbPKReNcHZxPDOSWjqiyZ3CfrtQpk93Pq5YJm39ceHLus4fFDDuwl+Rxuw9XuPB2IxSqE2fq7HZ+66/7RGBi9aWcJoqVc+bD1Xt01yqLObszTRgG5g4we4Q==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 13:24:31.3943
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b267fe9-b807-4db1-6f6e-08df043e8755
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD82.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH9PR10MB997859
X-Authority-Analysis: v=2.4 cv=Fu01OWrq c=1 sm=1 tr=0 ts=6a903a93 cx=c_pps
 a=a15oepxCFtbapkdjUscCyA==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=Sv0fKeRqtYgA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22
 a=sozttTNsAAAA:8 a=wrH6CD59uMa574BPOq8A:9
X-Proofpoint-ORIG-GUID: h4USEeP7be2RE5kpyq7VomdgsHfn0y-c
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDExMiBTYWx0ZWRfX/eCxLH05XCUR
 Sx/F3iPE3qcz0cFMstl+CWzrGeXysA330ByL0YKlcLCosJem/xmDk3fyRAih93TDJHC690z7Rx5
 thzUZgJ7Sj54E9VXGUf/Ky+mqlsxtt+qNkitUwZ4VIDe4QxUny5hyYra6e35wEG0S1lWPJSdKN4
 gJnQS84j+Yps1jJNhxx+K7/ke4Rtfkh5k+k/I1cPHCHfwZw4dwGcKC0ZMdgeSw1vBEFP7PwBIeX
 K8/YGPX9JIUMojxXjbS5qjmFjJbojA1wNyzYbk2ldFCGSKW4pPEdO0qnqs9ZWEbaBa0O40RTquw
 dJIl1dkdz0bCFP5ZYpRu32OmpxRxYYavEKEHrgI3Q1de49cuun4MA0jysfX+lQKgqySlp8owfNN
 luiBcDDNpYHK/6pj7fy2Awo++EDbrEjt8gqHj24yOacYwQkP9OP/89mcb2+GVZJChCxWV5JY7tp
 Tjt9QGk2QAhjTtJmz2Q==
X-Proofpoint-GUID: h4USEeP7be2RE5kpyq7VomdgsHfn0y-c
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDExMiBTYWx0ZWRfX+DL+iy4LlaZF
 PooOY4BGVWFPp9RDYZE0bX6yMc3VXHGKU4XKAOLUEoCxQIOMtsXMLxk6fNoJdu+JdEBpaA3QAQX
 gkhsQpjdPUOjKjd+w1ZpZ33RxqhQ868=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_05,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 adultscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 clxscore=1015 bulkscore=0 lowpriorityscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608270112

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
index 8ef54dacf63f2..99fce19de81d3 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -353,6 +353,11 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	u32 aes_irqenable_val = readl_relaxed(aes_base_reg + DTHE_P_AES_IRQENABLE);
 	u32 aes_sysconfig_val = readl_relaxed(aes_base_reg + DTHE_P_AES_SYSCONFIG);
 
+	if (src_nents < 0 || dst_nents < 0) {
+		ret = -EINVAL;
+		goto aes_inval_nent_err;
+	}
+
 	aes_sysconfig_val |= DTHE_AES_SYSCONFIG_DMA_DATA_IN_OUT_EN;
 	writel_relaxed(aes_sysconfig_val, aes_base_reg + DTHE_P_AES_SYSCONFIG);
 
@@ -507,6 +512,7 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	if (ret == -ENOMEM)
 		ret = dthe_aes_do_fallback(req);
 
+aes_inval_nent_err:
 	local_bh_disable();
 	crypto_finalize_skcipher_request(dev_data->engine, req, ret);
 	local_bh_enable();
-- 
2.34.1

