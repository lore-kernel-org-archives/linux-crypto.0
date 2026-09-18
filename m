Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461404E2F0B;
	Fri, 18 Sep 2026 10:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789727021; cv=fail; b=gDgoGTenRbAz5JPLzMR0apZD9x+A9Wf1Ug0HiAS2aYYwobqG5BRZnOkY/s4qbH1T0CqYrPZ9/wsIyjhv1129pjPE7Kr13Jp+Etfht+iGuET9XA3EXdFjtnIPh020xc5zou++W5RX1qYZBoXwRbSiStubJB+qC0LLa9XPr7Kxj6U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789727021; c=relaxed/simple;
	bh=8AiEGfb8lJzH+XTUake6thyKV3Zd4kzDjnDYuThYIjo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lLKL+pxVI3aa7NaRXrqaTrk/8qItexqk2uLkRlLVEFZQ31/sy3HVB1MImUybskgkqv7APgc9QS6lWlvOuLRbJA+fc2PEPXVWTFwxoqFvpkYLd+iDMk9DhUOdXtA+tH5jnD5rs6BVSr7XwKod34NdmZqaUboQWcjjLg1AwyIf5vY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=njpWlSvC; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=pS1rEU7a; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="njpWlSvC";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="pS1rEU7a"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68I9dBtF1233790;
	Fri, 18 Sep 2026 05:23:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=w5beXwKfniW4zqbzhimEbX0XKyemxYErkY0Kg3dQT
	7Q=; b=njpWlSvCiO8u3HYzch8UKBLGSzgEES9zF+ju87mINC+XYT0d9NB40c+rC
	3Skyjdjuwfzit01FdtOtFbZku7/T8NqZ+GCLkTadwv85NdLLrY67jLS7n2MDa3ql
	8QoFcV4MvncEM7uo9y40F3WKO+4FjC5/IWTPOw6rn8wM0Dg7vMGe6S4TF/LNaV3y
	bEHiwnKKXBOHCg7f4HXwDLKvIzE+JFoxp0s6hSlnLkkhvBl4yY4/yVffSe+5Sjza
	fHgWGvSrBZK4kZYMyKD8WUHuPhYb7VPIfcUXVOEAeDx5aIpOpQKFeax7H3B/aFBA
	aIo/IBlPPZhxPHjkDKEmoIBhiYhmA==
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010066.outbound.protection.outlook.com [52.101.56.66])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gs2ux07bd-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 05:23:37 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NqzSNt/4oaeZR78bSaf/pJOzEggHpZqRPHPYFEG7QmKLitqzMudvV9vydR7cp+355URZaOmCrb3bazxn/J/MCz0y6Hb/oXngV6RW8DmCgoXussmANLA+whaiH3Y7WssGOdakoBygb3aQC++3zv50wcqqb7T0YgzXh1ryXvd0L4PBFEs+9LOx3OXds+pQpEg1ipBzxE4OPGjJ6+HSh8HMadXWjCE4pQ2bXe4J82jGMi5iFuczPSTbqJtAo9IYY58SJToUeLhr1kF44Q+WrSejT2uqaCOEBW+PDcPfNMmrRt8VY5vyIplMs3uCcLFOyYAEvoLuQoFBY5k5YY5z1hFjsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w5beXwKfniW4zqbzhimEbX0XKyemxYErkY0Kg3dQT7Q=;
 b=kn4xVsqrNhcTHeP+kP9GI2TkOPpx64d7h602qql0bdweCa+oBc4sACE3aRRh+uMdDnQJ3z3co+qE9PqX0M3g1CGbUnMtxwu3RVryumEPhQzKBU7xj8D6DGOEzwsois6bY/HQ2a6B2BxMMubrkfHe4W1v0+6+4EbPEkjmQZvVzoidW5xzUkrcTw2xHCmbbaw8jIt+TaEER0aD31iOeHkbZeD3tNqBv3cnJfq2+oODMa4hUJH1SWshNU0lLg5LvFIWTzR+v1AL2/twxo2ZGc7zL6I7ko/SBmY8xfk14UjTq7ulf4TMD+dKy6dFNzelGyA7+otWGeG+z4fwKlP4rUMxug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w5beXwKfniW4zqbzhimEbX0XKyemxYErkY0Kg3dQT7Q=;
 b=pS1rEU7apHQypmNQrX7McJXdwY4KIIOfs/lCjZelaqeDuek8Sjmh2tKoamFK1uLaTYbEexU2rILfr69RbcELOIvzDHTIQxQxu9IyE/ynx9OeX2DAt1EvNibh1nBUh1enLMm3XXsSwEQ4aOcEcf9S7gBufk/qHalXIxS2tCppCyE=
Received: from BN0PR04CA0056.namprd04.prod.outlook.com (2603:10b6:408:e8::31)
 by IA3PR10MB8092.namprd10.prod.outlook.com (2603:10b6:208:50d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Fri, 18 Sep
 2026 10:23:33 +0000
Received: from LV8PEPF0000005F.namprd02.prod.outlook.com
 (2603:10b6:408:e8:cafe::12) by BN0PR04CA0056.outlook.office365.com
 (2603:10b6:408:e8::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.13 via Frontend Transport; Fri,
 18 Sep 2026 10:23:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 LV8PEPF0000005F.mail.protection.outlook.com (10.167.245.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Fri, 18 Sep 2026 10:23:33 +0000
Received: from DLEE201.ent.ti.com (157.170.170.76) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:23:19 -0500
Received: from DLEE207.ent.ti.com (157.170.170.95) by DLEE201.ent.ti.com
 (157.170.170.76) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:23:19 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE207.ent.ti.com
 (157.170.170.95) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 18 Sep 2026 05:23:19 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68IANH4q600519;
	Fri, 18 Sep 2026 05:23:18 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 09/15] crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AEAD
Date: Fri, 18 Sep 2026 15:52:39 +0530
Message-ID: <20260918102245.2784000-10-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: LV8PEPF0000005F:EE_|IA3PR10MB8092:EE_
X-MS-Office365-Filtering-Correlation-Id: fd0f4688-d27f-4eb2-7d5f-08df156ee4ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|1800799024|82310400026|376014|10067099003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	yqh5GQmFeHH5djnRUvYERCxk8fGXnNXMr6poUYF1RJIXxpb0iKvEhEzZtSVsC//wQrW8XrxSHUk/P6gQoF2EEa5L3zOk9dmCD/HzO+vs3oSvDIlk/dDkfWyu2QO4KN87Q6FAMGAkFCH3UcGtFEnHPKrBbhmb+8BXgVnvKwQTZBXKWmzHeR5Y1RPSfpyNKI7nifZyAXZ1ja4eeK/iT2rNSuWNtYq3aqTEuq68yh2OOrdgakCN47AHywldPoIXiILQaLP9Wor9alk8mbDIEWqWqGQ6CrziZjkSC4oSeWiFScVbyadK0o2IERAGrkuvD/ZPU0WeXmTdLMnUp0HWmoWO0ig7ED3SRke1GiCqUTaePdDlnCges2XmSe9vNwh7ry1s7xiq3p3mnszZZa0g9fpyeDsukmuEH2jDCGvIAodVbRHety0MmDHahNc6mMx3aU7becDhglOW6W+ZLzc728xLrKX3jKSw0C1SSIKoyymnvrKMlccFr9t7qkdSeu1nj0ahjXGV5uYV+VbYKNbjZ77d08vKIBnJUCJL5XaJbwQfyThWEEIyKS/9KskaLTt00Br00nz4X6118x9HIEElQ/zATtNtN5En7r+NNC5VuV2ZS11uWNGAdw7ljfYhCcPa6x37/bFRGMsEhtoYvmSXuQELiCwa4LZgWuDcbSrIRYPYu879u/j7QB6zCBmq+QSj6LjFkb3LZpXIteYF1VgIqqyt9w==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(1800799024)(82310400026)(376014)(10067099003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	D8ZBpMUB2pgEiSpjFkI7ujdMA589LLYw6TiWOV25fkkJxtmOCswd4v2w7hpjDlwEQLN5wu4EzOAUKG6VqnJsLu+u7S3OM9T0WxqURHac5i83ELt92oEhmyTItic2DL+m68dbwppf9eOG7HgwrDc447vHlgBuo8VrWkradM/6zkkmcdmPEK/OCuSlPtQ2stPwpK9phAXfatqpcrwx8XiJ72LQXhbiR6kLbESROLUqJi0PMRqI4MTIt9dgMheS0k9iyhggke7Zy7x/ckkl6yRgHhNO7MBYj7eHFxqXsoE+gW0S3ud/kH92KtxwniyPDoAcI6tZsOQhPhHraeCksKd9DKqJHP1FynelcUEm+CaoHCstN5MvjfH42zHAckD/AlbJhRtgC3e9CNeCRxP4DZQWUGR2dWy70gx6C3ma9Yc8NOOJKI8GoSyuw1BfTIyaXk1W
X-Exchange-RoutingPolicyChecked:
	2tFdPz2N5ZwRABBUUP4/P8WbVllhrmjzSAlPGeDwcuHoacreqbTi6DFjcKYVmjcDZKeRzgzXiZta3L+UAxIRGhb4R4YG1uaqpG25Mquf6N1yszbVo2EnIiSb1J3SrNcbYPTJtOXl4iknX59FzWK4Xkur8HtFXLUvu0zYNn4l2DfTpPGi48T34GWthb20s+ovYs+C2btPR6zM19TDSIXmkdsEbK7pbUssJfZS3GQRjTI5PV1uNTejKTeXduKA/7Xm07gjbwYHLKC8mcvabnfNFvUNgmLZG02tm/5tko24d83HDlzd9QW7H6XbPftDtiyM/NjV+MTkRhDSGChIJSOLBA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 10:23:33.5675
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd0f4688-d27f-4eb2-7d5f-08df156ee4ab
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF0000005F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8092
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfX9h3+qiAoWdTx
 BwNRWP4yYlmXnFu/0PLGw1D0XI3+JCmD9aluetFXWNSgUaP+No4LVqMX1lWd/QlnXpTuyP+HRer
 /guB6NJ7QIsRR7exnjZLsTaxaQ1QUTI1oUuLe3bJq6/I5RTi6BLI09x0PXu2miCDxY00wlLjcbR
 g1qaWDYfmnDKqGzMMrY/5b7vg1vSyAZ9VfLNo/YfnGk+JSKpoC8rkcgTSTZ0GFlFxSTCwScrtt+
 IPLYUp3nlD0VjFXu1SSv8g1Pt7WHeeVOmghoh7p900mC5hfDtsPwC9fsMMS2/aKpu+2XB6yloMo
 79vV/m+faEn3GOmX39qSGH5wdvLBduC6PHsIeQD9aO6MAYRnhOYqcMi4P5kfOAWDdbS7cNgxeGQ
 OFMEyGf9Bh1aMRoDPim1nkyM03TVaif62Rcme2TSw83tgNwpTzOoq721frHBwVkXJ3qEmjXDlzm
 WA6+w6jg9acE/bChm1Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfX8wR5tQB4aLP1
 uKeLEpALGvEqof4ID3jOsu/BCuXMVUIZ0itXbGkShs7FpHWHr1D+Shz5bM+ZAbvMKxPQ40tuDcD
 QN8aGJA39aX3Xv5eM9g6OlmpfF5RLkM=
X-Proofpoint-ORIG-GUID: Qf_yq_xxKVGCBMnWbWB2THqybwk2itHi
X-Proofpoint-GUID: Qf_yq_xxKVGCBMnWbWB2THqybwk2itHi
X-Authority-Analysis: v=2.4 cv=adH0Dhot c=1 sm=1 tr=0 ts=6aad1129 cx=c_pps
 a=gd7JxMPBqN93mtTmHvcGFw==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=iMD6g9N4YQ2QoEUmFGwA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 clxscore=1015 spamscore=0 adultscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609180144

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

