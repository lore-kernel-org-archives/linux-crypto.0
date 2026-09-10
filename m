Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D6B3DAAD5;
	Thu, 10 Sep 2026 10:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789037007; cv=fail; b=ZPDkcQSINWX0xpKtITWOJ9YCJWslj5eGMTrW5U1IdE3YFtbi5w6Ku+NC9r6WGjfEqaMexfOT/JQZKKUD0qKWFan6FIHffzNgNkBpdx1EHPMvrocig1XrBBsHCQFSt1k95eKa79rNJEL/H62NokeSQQZLPqbEdoutrthI9eU10oA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789037007; c=relaxed/simple;
	bh=xb+vL0JDbiPKN7Wt2F5InRrdoz1YYUcDoCoOu4uU4Hg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AeJcQT1ZqsZ5E0OB4uw4taa1NaHEOHrRPMhnVjHYf9nIq7DVy4q0MQMhuJoHJygyBPtrabAZ2w7xpFAjuKGGKvhbC7IS3L3tX/2fcuHmzumihLiKVoN2sZw0sb48jslRdZ+HP993iPXfZQ7Kg0H/r6S/QVU9SrO7qqZQfCXZmFg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=TKYyykG6; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=LbHMWyVm; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="TKYyykG6";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="LbHMWyVm"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68A8oHTO712620;
	Thu, 10 Sep 2026 05:43:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=9AAog4xG5I3fqrRUyrRYVntKwYPVthg9NlLstka6J
	8o=; b=TKYyykG6a1PoHFTM9AlcaEWXUmG32llKndz+uJLFjeraZrst7oonghicq
	74eTmbVcBr+gYwNn6hWcgWYXDpIWRKa7ucrFKKV2cRffbWk6W6bbESP1QsScGDJZ
	2k80k5unwsZk1cSYQ6ijSCDzY8ff52wGubTf9ndnJPhOjaxouHet9n1vjbCB9Lsl
	NQf+qmFzWuSYLtFLNGzBMZjro+tZRz82Sac7fJcy22dR1ZrpopS6Fq8r8uGCDgxH
	fvzFwM9Ap2osWzxQ0HFmhgSgUaq2KxX9xfB3hqwF08/mwtPj0o7FYR0QbdQ94pl6
	uz0mYc/boOe5lTC/MP2tUi8iNKfNQ==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013037.outbound.protection.outlook.com [40.93.196.37])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gkcxgcny7-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 05:43:18 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i7E9g5WeHgp4ifH4+Sp4uWpqpmw8QUTgIzcTdnBGT83RDPafP1F9si1CzmewSFMlfoOJ8AexvpyBIsUX4w8Q0D/yLaLTYugkB0rJAmivrjSrnnQqpq26F7blQXZ+Yu4KbgBQYwMK7enGc8jJsOpPGwX5xFjOCDRu/LGwiNgZa2fvATSYjS0Cb9fRfqR5X09vHA8t69HYPDIrRc5IC+De3DblGYbyePlX25GYLCSjwuSP33cimhrL5he6Z3tdLlLL8bYbt13VzPusspXK/04+mwxV5CmeLUruYXQiSQkdXV4vcqIBSOuaE0O1ou/SE7u+5DkgRjjjrU/Bp465ennFCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9AAog4xG5I3fqrRUyrRYVntKwYPVthg9NlLstka6J8o=;
 b=bRoCtc17tRG4lK0PZt24HOC6o3BG/pkAcfNaoI80WuhDwFjoI7nGCQNWxmWM7a3Nm4fNjsD2bzgscaMfW0oYL+y2/bjXU48ddPZ8ZbatnxLTQ3YyHhsQHTpVFAK15XeaJsw6RCJLHujRu3Trl8L+1iWpT9kfktLhfU/vLtpoq9he1AcFfPBXZyneDCF/UitZUJM0bdM4MrpL1tg28j48DxS4xHv61L1dWmXl889fe8scW+mU8c2b7cwVDXVb9OViFVU0LZtSI/DUrRLexLkl0la/NA5MbS0Ir0fqXKOGGZGAQmxCRgJQsGBtKyQcYtjnbegrWh4Ok87+4fpT5CXuwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9AAog4xG5I3fqrRUyrRYVntKwYPVthg9NlLstka6J8o=;
 b=LbHMWyVmjeN4ED17zzB+IkNyqAPKhih7l+rWWMxOboyPOrghZwegO3mOQVFUgKOTeOcZsWl1gUdcHK6620bU5BnXF/EUGDEKh9dDqlk9/h4U8LEZvvFN1loFyH38luCBFHVgH9vBZikvEQLn1abeCaWS0CSxL+xvNhpBgYFLD2c=
Received: from DM6PR07CA0088.namprd07.prod.outlook.com (2603:10b6:5:337::21)
 by DM3PPFE23691A9C.namprd10.prod.outlook.com (2603:10b6:f:fc00::c50) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.5; Thu, 10 Sep
 2026 10:43:15 +0000
Received: from SA2PEPF000015CA.namprd03.prod.outlook.com
 (2603:10b6:5:337:cafe::a7) by DM6PR07CA0088.outlook.office365.com
 (2603:10b6:5:337::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 10:43:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 SA2PEPF000015CA.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 10:43:14 +0000
Received: from DFLE208.ent.ti.com (10.64.6.66) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 05:42:45 -0500
Received: from DFLE211.ent.ti.com (10.64.6.69) by DFLE208.ent.ti.com
 (10.64.6.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 05:42:45 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE211.ent.ti.com
 (10.64.6.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 10 Sep 2026 05:42:45 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68AAghjw3150321;
	Thu, 10 Sep 2026 05:42:44 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 06/12] crypto: ti - Align buffers to cacheline for DMA
Date: Thu, 10 Sep 2026 16:11:56 +0530
Message-ID: <20260910104202.1537226-7-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015CA:EE_|DM3PPFE23691A9C:EE_
X-MS-Office365-Filtering-Correlation-Id: 488a8695-c4fa-4957-47fa-08df0f285136
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|36860700016|1800799024|376014|10067099003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	KjzDA/3RTseycG5GeFJSeprYyRn0h4aGXE+ECvZnQVZXdHu/FKj1N3ojwWuf6PJVe8vdemf1YwBtD4UIOXuSTM+mZO54+RnueWA/xqpae4OVj8Z6UBNWrilPL+aFzPjR2tVPORnZ596HV6hpjRfbIIfnLUqSUTWYUgPFg1/2hExi+vbIvY5vhp1IVRNAgSA7KcT88LOs1KVm62LbXbyADhlwE+k1GuNd/HkaD2rZpfUum/ngUzhbdV+astJks/aIg3sHCOrxIuVnCjkR+8VmWLynPqqdPLZZqG6okjAD5RlME8nURaT0PuuoghP+B73/IQ+ItkXhlns/TKtd+8lIN4Bkj6mXKgbW0CWVQoGBaB/k2BZws+iCXvnuo6hiWEIT/c3aT1lGGB5XSUWQQDZePczf+UKspwjpM9BiJMawqvkiImnrOzRNtm7r3vacrbFhYrC3RbrlJig2vA6alUwqIVhDwrKbknjTqcNGFmXWY5arQVLYjdh8q1khE2Wp2k8Hn//SXo3b6CfxRxBP0AdPkoAkn2gCQHqkxJs3PxhX+AUA75gZvc1RhHXh76i/mYmW/f0Ko8zuEqDW1xJ6IemQSu+UgDV7tbJmTOfX3+hWHYYE0MYVRgOoy4ZbPF/u8SpdmbQdbs6ksQRHv5dlmsNzVpz7/Qxs2VPETUzl6n7PycWzfxRJM6caoDqxXG5Ilrna
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(36860700016)(1800799024)(376014)(10067099003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	H63xekvsfEguPBzexael771Qze8fUMzhdfj5ZZt0dKT3VQyQrNoJU0HK8A5+mGog/AK7zlN7KfyyrSlOCPOmWypeJDCub2b8FdpaFB/+qGIwsDolU1txXoKmP8fiq40iq5KKY5yNd+bjePhTkUlR8b0bOQc/D43RIE0bNB8io1Cyks5jHQgal59bIHKiTYpp/N9C9QKlTtKcrMaLXmdffeEy8yZI/XZxXI/k3251fSnfJLk7xFdII4i0EOsxVniJj/Uoit3A2MArFb1sWLQ8S4RWFbBNrxsIAwTGDrSLijCqezGFMTYUrVmQH0avF0F984Gq0V7YExWa1iP4S3TrF8FsQp1U3DKh7QsBpvUhQEaAgY9F5OPXVTiHvEMUyPM5DVu4NwYax603J6vgxztfhaKbnTLKhOS0xUEi+AK4mQqsFZ1fghy0MrhlwNZ964me
X-Exchange-RoutingPolicyChecked:
	QXkHc3f3y4hoU4CohGCdm2jj336FqRbyxlrSopYP4OOrk11G75ChziAZgAqkW7xhMGgTigjNhU1HVrS+ubMh4EmEA+/n29drQVoYaS6ov4AWoZbsFu/XpZ+He8bbssPJOwMoj2Kmt43MoZ3J/5ndacB0YiP9S5T8IUHJFoXduvk7MWgj/8NWit5tqG3cI7epJRBiCtg/othnYm/ZQ/L3DUpDZES6G4Rpd2BqBSQiZTK1yACT0pqhO/OWCtzlCCAu4V3LsJaT7bNuUnyuDfzzFy5hqVaGKC7C5U/CPX4jctTvIBTmECrpwINxLTrQxm0c9jGMW3TLsN4vR4A7U50Vdw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 10:43:14.4761
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 488a8695-c4fa-4957-47fa-08df0f285136
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015CA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFE23691A9C
X-Proofpoint-ORIG-GUID: ZYZfh_RZ4xE76MTfl2k1D3gvKQIOfv_r
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDEyNCBTYWx0ZWRfX+lsmQpl28JQ7
 C47gEou5do9OG0w0jgCpv2hFT9LGs/dnSVCNcYSrG5pEaeS5vK85cnsVJk1QKyBWBeDp2l7O3h4
 MTg/PIIRS+f9EG346o8C0Ftm5yta/bs=
X-Proofpoint-GUID: ZYZfh_RZ4xE76MTfl2k1D3gvKQIOfv_r
X-Authority-Analysis: v=2.4 cv=MqbHeGae c=1 sm=1 tr=0 ts=6aa289c6 cx=c_pps
 a=S19i2aQNi83ZBCZ28RB3Sw==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22
 a=sozttTNsAAAA:8 a=8TpikKgA1nL99BGwQjsA:9 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDEyNCBTYWx0ZWRfX81BY7VX4Kumm
 AD8iLm9gn8kEBQFSu3I/iwgc27fOy+diKUP7vmTbhSNYx5x7cnfaL7UIRfzMj0aKJNbGAXdk3/r
 Ye+f4aFU/rRV5TXWjbcElk0UnabHImXHnCkBEeM1dQqQMTZfPmrOpxGY0jlTglrM7RfmUC2/anB
 DupFnTM0E83uK8fI4BaD/KKqse2JiUYk36XkbdQ7wfhzCsAWI/E3P7qr/gZliN1trKvVKLKHeRV
 jsUaiozGha818+cnqxp78cx8aN6C2cJ21/h+blNwjW+ysj8YI3ZWUSmdObYRIIELEbrp9ESwMBG
 jxmxNKBq5RaQ2KhX/TXUSGZSy35A1TIaIL6pLpV7S+KTwXc/CpeolEbuhehnda/LpYvHdu4tee5
 qi6pyzoS/IoBHyyWzgDzi/EVjw0nySyjbl1bCVDJxJc1BOvU/LAjxfBD6/4uPuxr1xsAcFVrCmA
 17h3LZ5V2NRZcJCVNgA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609100124

Align padding buffer which are DMA mapped to cache line to avoid any
potential cache coherence problem.

Fixes: 35645ca63caa1 ("crypto: ti - Add support for AES-CTR in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-common.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index a827817e8119a..cfb50255a5dce 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -114,7 +114,9 @@ struct dthe_tfm_ctx {
  */
 struct dthe_aes_req_ctx {
 	int enc;
+	__dma_from_device_group_begin();
 	u8 padding[2 * AES_BLOCK_SIZE];
+	__dma_from_device_group_end();
 	struct completion aes_compl;
 	struct dthe_data *dev_data;
 };
-- 
2.34.1

