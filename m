Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55E74B2031;
	Thu,  1 Oct 2026 08:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790844816; cv=fail; b=SjqIRKFOfHbFjpR5zlpgNLydhzGKCd76Z5f1xsVo9fbtuA+0YpMSAcox7JQhgP4jdbeK8t50Tss/Zt51ewuZtGKy6KM7qW20MG6B2foEm4dJz+EjmHPVBySvQI1hPEKCc7b5Png+cZhXJaXHzmwi8nBIUBPymt2AejdIo9P4buk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790844816; c=relaxed/simple;
	bh=2ZFeHgvDd9zsO8LboNh2Zby9keNhh1vjlhrYROuwMfo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XUsw+x0Wdi7qs/XDTOu3JnBgG2LU2P7vhIyDtkrOi5Io9sx+prLmMqIzpqs/AkOT5bsMVzsj7AHdUOtuXULO/8kzuyFVNCcpc1l3QEf5tUftTL/SCkj9SKerixwY9KhZgJrPin112T7C4gsN8mwH55VZ6GKqXBOpM3ZuvjEF4eA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=SN5QIqZG; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=jCnEYkxi; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="SN5QIqZG";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="jCnEYkxi"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 69187S171207690;
	Thu, 1 Oct 2026 03:53:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=5uyqidOPTX9t66qhT6RFwwMn9BS4fd66ncsDfiGDk
	PI=; b=SN5QIqZGhJW50nArfiXjddHsLpXt5T4Uyi29Twbsm5M7BUZfpeF9IMk72
	hBmppP/O2E/yWaqpzBC6mHCmfUdhG7M3j+3SThya/omu8GnLkTWke166jGlYT/Ph
	RC7Hx22NvKDrAf4uMJizoihthp46udwEhX+c48KtwKa79zIMQdAhf30yD2CVp1eZ
	MJvdHRSoJLSXitg6IIgY/GxkXD+fAxJiaItkjVinNDdZ9UZpMz+6KPdkRz+7D8ww
	8iDkKKPFL5rJcdhxB9cddStzn7sdBb6GtivAV1x48svqFRGhcrqbV+sf30RU7fbp
	K4etel5PJlJDObIbn/OmY2cy3MNjw==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012069.outbound.protection.outlook.com [52.101.48.69])
	by m0380145.ppops.net (PPS) with ESMTPS id 4h1kqyg8x6-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 01 Oct 2026 03:53:32 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vBtQCNjALDZFS5Li3DMcazZToYuP7ubxfUi+lGNt+A6zZLn5mLLIlCJgtlF7W+3CyM6jslOfpm++XdDzBdYDNOsSJObVX5eYqr/pkPRryl8rqpvbq9uIX6ukSo/L4R359X9Jk+kgZOW7QjZXVtIY+TuL45/VfpGOsQPhbBDJZ5X7q1qoFwG13tgrXzZyHFydH91K0OpQMzNWG1nL1nKaS2B6utS5xoAfviK34vNBsWrwYl0MFCENgPkuR90VHC3JZWrtow0ZW6anpj1XI5E70LZAH/pngbvA0ZQ4ooog5hQQuAK/Mv9sWsZN+NAqc7FrmeZOCtDIhSwmTvA0Lx8uNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5uyqidOPTX9t66qhT6RFwwMn9BS4fd66ncsDfiGDkPI=;
 b=L6qhT1CdmW6M1xlvc4yjUF9jJDjsC0rgyNn2feKCo3Qq+zds+vh5l6jOITrYJliHPmKPnpOHJwlJvq24anSHZMpaphHJPIOUQy8qOylrqE4KzMboNuvmv3im7Q7eirk25cKcRSZfy2yP1K44Cf0oaS5JtQzMNSCeLMwpGPZsx76k9zX0OpJWlJo9hDNXlDTFrPfvqmnbgYQmR/GiEfE5/Y/sboov0/mrdzQLeeF53aDoU4ubge1YpRmr8Upt0Bi2wF3VZ04/8cThqzouqJDY2gFKqC+h8nxlBZ2FZNDITDYN26NM/9YggCJtLLDJVKL9vyghO4KfodZPGnVaZITt0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5uyqidOPTX9t66qhT6RFwwMn9BS4fd66ncsDfiGDkPI=;
 b=jCnEYkxiJbLWcfX1XJWhIJ/5ip0T5fCyLuf/YB0sA/Huyz82Ku9/rWuoX3K9irgkr+8Le7fzhq/WdZvjxtXsIgscu0nC4GWNZtilg10DBaXOkhg1ATBA0MMaWhB5Klk5pH1w2Y69G5cVORn9Yol9xUfdGrkzW0xoVJtlh94V3VQ=
Received: from BN0PR04CA0035.namprd04.prod.outlook.com (2603:10b6:408:e8::10)
 by PH3PPFB448A336C.namprd10.prod.outlook.com (2603:10b6:518:1::7c1) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.14; Thu, 1 Oct
 2026 08:53:26 +0000
Received: from BN1PEPF00018075.namprd04.prod.outlook.com
 (2603:10b6:408:e8:cafe::99) by BN0PR04CA0035.outlook.office365.com
 (2603:10b6:408:e8::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.17 via Frontend Transport; Thu, 1
 Oct 2026 08:53:24 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BN1PEPF00018075.mail.protection.outlook.com (10.167.245.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Thu, 1 Oct 2026 08:53:24 +0000
Received: from DLEE212.ent.ti.com (157.170.170.114) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 1 Oct
 2026 03:53:13 -0500
Received: from DLEE209.ent.ti.com (157.170.170.98) by DLEE212.ent.ti.com
 (157.170.170.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 1 Oct
 2026 03:53:12 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE209.ent.ti.com
 (157.170.170.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 1 Oct 2026 03:53:12 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6918rBes1595245;
	Thu, 1 Oct 2026 03:53:12 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 09/15] crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AEAD
Date: Thu, 1 Oct 2026 14:22:39 +0530
Message-ID: <20261001085245.2922974-10-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00018075:EE_|PH3PPFB448A336C:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f33511f-a85c-4438-bd2d-08df1f9973ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|376014|1800799024|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	lxlwX7zRnDt6QE9iU0cWxJ2j6atOqQBy2wgmUcPFLx4xgUcoxIzV1MxQs0TwVRpuVI34ZJwhsxkuP6ZkFbI+cmG+nzbCdai/CphZr2l2Bxnzr8MkpIiWXHBw3snl6ZEJoDLcJgMyo80ZJPuwQFVCQHzAGEDg+KHKmy6c3SvgvsUL+Rv1FRAC6JER1nlU42pEvz117PkSu5lae73wiK7dHWatbU+cSOnDLM0J7stxo7ikKXgoxlEVt4co0xaZk5uTwqrDm3DFgvDupBWLphCMKx36/yU16TPKX0rFEf+CKeIv1YbrcgjW2CLcx3ZAsQCVaAp7XQZ4E/Mwzr7XrMT6YGGwjtdNwsKOcKgJ+/2aJhJ5ypSOTP9e1W6yox1VAB079jw3jThcpN0oQgkvwGnm59uoLKn5ksZLYQxzY3dEV7WFkmovJ6N0FR0t+HJrFvAvKngPrfutk8w7xxW7fuMXSOvgjV+HohKmQFgXt+LKggqIfe+vbPJLN+mS4LmSWLSVW2Y3dOP38/ZQ3yCMaqKLlMAb3OUmXcHl4kFLTc7HexCdQPfAw3BU6GptnjkTkH0GGrDkcFUd/NPIOqA5LCe6qGXo+q09qkszLl9pgFITN/WW9S9WeMVo1S+55aV/2E3s7FhVbG6F9L3v4VUMWyabcJgGOTRAPj+GS1LTg3xsU547hWCXBLjLvQRoDzHPfLgU/gBgwWyablkbxXpHj8g46A==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(376014)(1800799024)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	uXmAqJq0GHDqGUqtVDdsh7ON07yh29aoaXhaGvRSgGUkqdfnxtYrrPCBW/XyNY2rGscGjkK8g8eYX4ZcVguVmAJZzZAl6pASkFMu5SJG/PMy+uHD7iTm5k9NxKvCXa0OcGdbrX2YCdbnFjdp4fBuTRW8s7NmRLXK5lsGwxwObMNm+aBpJmI9mETTUrJ/BRgQt1qMBpsLMUeTXskKT169QMFBxSFOc68ekOP9WBFawvgmTIutsaPYAI+3Gya8XD5gh5BiIP8iHdKtW6GhvEtCMbQ5AF/6rSkwVRF/YjLF+/cA9fCTPsGJXWFmHpMIpDjY8rfAhL7gyEA1mEadtY9/gfq1qtWdOAEIUXNBjAg5BDK6QoT+WB7AMliKItfD8BioJjPIIrKCohpCT9zP7cLM4qmsAYScrAG2ZHDfnYqt+LRQyF1l3ZkIumIMpfXIv7FW
X-Exchange-RoutingPolicyChecked:
	KPREpMEuK9Ux0WKjNWZagp6M7boc7taU4unqgK6t3AZ/O9+0nUHkbjYFKPj5qukKo2t4UGMZ5e5JYlpsJ9U6tYwZycuitKUJar385gBKsm2/qmX/u9WWIBOol/5lx4A+yiKj6TWc2x+4v2za5EHDCbJFNPM1KEtb6YN5si0AX6pdlInZ9Xd7ZroyLDxeM3IolGl1+yv4gph8njsYOn2LKgehEw8VPwa2cDh8P90RiG59dY1EV0wFDX0lHu83f/I3Ld5G5mxvk+JFHfPWV3TvZNNqaoqy4LFG4oa0EwfCvK+7/Y6eut9uAHFVaRsPTlCtDHY6TdA8XckRoiGDNx2oZA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 08:53:24.2058
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f33511f-a85c-4438-bd2d-08df1f9973ce
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00018075.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFB448A336C
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDAzNSBTYWx0ZWRfX4QRHAqNwhqHC
 eLzLBQYDb5oTP2u0YY5IL+AI2mqGe/eD/251foC+dr7ieKKkb+PzDlOQbr3l04H3EQYTbrJRSoD
 mgGle07wtX/vWz/uWn/Q9A5uQGLkLuU=
X-Authority-Analysis: v=2.4 cv=a6alZkSF c=1 sm=1 tr=0 ts=6abe1f8c cx=c_pps
 a=fm8IUWXzr0h7QqFIpCBYEQ==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8 a=iMD6g9N4YQ2QoEUmFGwA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDAzNSBTYWx0ZWRfX/3f6UFihDq9k
 HpmI4CLiGDFThVrDap5XoJwkKxgP6UoR63l7nOoy6TBOZM4dY22VTASZMFynVIgtA/cX8ld8p+p
 XW6grKWN7bq5DzXwHcq3CZhUwOhNCx7hYW+6MiiVTPnjoDez7cuIrD/ijO9NUx3Y/yBQz+rpNkq
 UWpaVD6JO9Y/FCqR9PiWRZ61UuGHX4M7OiSBYsMGkq2XPFTWtqzX0pL67EgSnlgl1Cmpb8BHH1I
 hTJB0rG5oX+93Z6fvWrVPmdkuXfKaa5th8N4sXOBTu13mr055DKRbnOZKzpPx1JlHACtvzGj/IW
 ViWeZU0VvMbmYPTWKjotdh9yOQBVweet+D6r4bMB70w6LShz2AqVs22c86406Ml9/Lahiym707N
 B4nVuRqDp/A3lJetrJXsAKR+qNmNCeAII06kmj1Y+qLorDa2fZ2milZqLiASfRjBDqgval3As7T
 LrYuPfiQRWoxh94212g==
X-Proofpoint-ORIG-GUID: 8nmIBdF2p5I2qjjExtaHrlltcru3kJuI
X-Proofpoint-GUID: 8nmIBdF2p5I2qjjExtaHrlltcru3kJuI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 spamscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2610010035

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
index 0447144b77ffe..d75b074ca1e39 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -643,6 +643,8 @@ static struct scatterlist *dthe_aead_prep_aad(struct scatterlist *sg,
 		return NULL;
 
 	aad_nents = sg_nents_for_len(sg, assoclen);
+	if (aad_nents < 0)
+		return ERR_PTR(aad_nents);
 	if (assoclen % AES_BLOCK_SIZE)
 		aad_nents++;
 
@@ -699,6 +701,10 @@ static struct scatterlist *dthe_aead_prep_crypt(struct scatterlist *sg,
 		goto dthe_aead_prep_crypt_split_err;
 
 	crypt_nents = sg_nents_for_len(out_sg[0], cryptlen);
+	if (crypt_nents < 0) {
+		err = crypt_nents;
+		goto dthe_aead_prep_crypt_mem_err;
+	}
 	if (cryptlen % AES_BLOCK_SIZE)
 		crypt_nents++;
 
@@ -758,6 +764,8 @@ static int dthe_aead_enc_get_tag(struct aead_request *req)
 		return ret;
 
 	nents = sg_nents_for_len(req->dst, req->cryptlen + req->assoclen + ctx->authsize);
+	if (nents < 0)
+		return nents;
 
 	sg_pcopy_from_buffer(req->dst, nents, tag, ctx->authsize,
 			     req->assoclen + req->cryptlen);
@@ -779,6 +787,8 @@ static int dthe_aead_dec_verify_tag(struct aead_request *req)
 		return ret;
 
 	nents = sg_nents_for_len(req->src, req->assoclen + req->cryptlen);
+	if (nents < 0)
+		return nents;
 
 	sg_pcopy_to_buffer(req->src, nents, tag_in, ctx->authsize,
 			   req->assoclen + req->cryptlen - ctx->authsize);
@@ -975,6 +985,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
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
@@ -996,6 +1010,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
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
@@ -1016,6 +1034,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
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

