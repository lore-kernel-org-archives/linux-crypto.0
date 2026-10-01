Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CBF3EAC71;
	Thu,  1 Oct 2026 08:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790844816; cv=fail; b=p4K6B2qjXOmidH+Iqd6uKToBUE9jWLnV6e2+XjBauxx0dtBmLFTsbmvYRYqRp/WrjhK8iEhCe73OyhMflvEdhqyUIC8XakcSXC5MQvI4L3L7COfobSbydqJAr/M6gIQtjpjV32SC1RZtMOGlvaUqhJqLBsDiLTezepc4I4HVNVY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790844816; c=relaxed/simple;
	bh=oEievuPIK77sfBoMZW0FxLpzHM0QEpV0zn6Xmu5kz+g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hZSWtebzcj8XIZXiXHXe556mkkjVAEa4EZKY6ykJQsNt7bhip3HgcRM9OkrTVCvxg9Id8MIa/jHRPOhyz6uAP3XhfzlsENEy72mz1Ioep61MkqtuU0b88cB41QHMgOgX+FC9wDRw/jzRJNBRux3fwev2ZHNg6aApkynTKxKxeUo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=QF0gTHMr; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=KrWBopBV; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="QF0gTHMr";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="KrWBopBV"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6917127T1294644;
	Thu, 1 Oct 2026 03:53:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=te8/Mzw9RHyzNtoGLCjV7WKPoR3c0V5g+TIMjgC9i
	nM=; b=QF0gTHMryWjXOM44vwRu77PSLYHe+VtQvtAL7uAd2G7pqVHPbjcHsBb73
	9btJJG4uEyyP8kawQggDcUsYn9IrwE84izliLpqvREQkz3ylcH5aQsDb6VcRpNPb
	gkTTUq3KtNZ8nfpN7OkFrsfj+qQ4oIr1poXBn2rU1KsXpTlgZSE1q9jftFwBHnWg
	r8qstz+sWUdwSP6kEVZi+Y+7UNHFoQY7g3ZKewBb0mBx+9DJK8V8GX5maLZO+JVH
	6XIgDOnxmecZylu5van0sEHfkSfRvTqW7Zca+aGDwUsIdWR3Zs/GuFsueBgXgJVl
	C1PH7vwWzQldKLLrv1YWVttfCmr7A==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013005.outbound.protection.outlook.com [40.93.201.5])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4h1eur9t2k-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 01 Oct 2026 03:53:31 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PYTVfClyiUQx4n4ikdIReaAXB7I8QWoYjQAQxF3ovsE7gxyEvu0gzV/Y/OpSmxWrbix3NeefWwRiUPlw4aVoggojXycSrlVE1RtTi5Wod8KRmYYiX+mT0sIO0XATWTEXSIUCqJI0VHrh0XAqgTR7braWfRONjADouEQjBXkJs5iptciSf8dwrtHjx1UMehPhnJNVlqxklGCK8GzXbaaqU4k+AVK+gK3Myyqa63unvbdujIzW8jaCNPZOEh/M87g7CUwmjl/iLilWOMdBmCezystd+fzl/BYJ+cYLaNLOX0djS5aY0dzyuZX827d34tOu8kHe2WtJkFqnnpyf7cisJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=te8/Mzw9RHyzNtoGLCjV7WKPoR3c0V5g+TIMjgC9inM=;
 b=WwiaOcP3JKXUndTzZfFJkz8Nm+CJ78pW1rBvSscWQXIFTfwULll4fvlGIq+0COXeiDVQE4U8MOakeuO1m/ck8nTvlynlt347ZD+eLNYZJOH3KnMR4ivJa0oPMbzdp/+i7yqGhIv1sNXm5P5QoyM4CaQiTu9346Wfwp165q+WltLGQwrhocedmNG75OYotnHFKIG8IcNePza0HnAJQsEAltgocIfYm5bgXceF+ysN9A0aXllZKQEuTAMZyP1QAeXh5tiGsYx0M4L65R5+Tx8be6O5qJWpM5SPb9e47TjCp0LwuARbgcsA6Cs+4zQ51DSVBSs75yR3cmUoqdJyxhdNgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=te8/Mzw9RHyzNtoGLCjV7WKPoR3c0V5g+TIMjgC9inM=;
 b=KrWBopBVGOpGNbcyfWAJjqJESwQgiM1aG3gbCFNFcWEhhAPBJJ9BwUsrmr6x3Ocsyf3TG7u2ZeicNMvv9wXG6Ng+fNF8giWMVnCpXvtmwV881DCYSC8G+LNiltXK4OdTN1sLXimWOwu/RrulqLS1LyUQojvotY0lG/vdaW4axR8=
Received: from BN9PR03CA0594.namprd03.prod.outlook.com (2603:10b6:408:10d::29)
 by DSVPR10MB244415.namprd10.prod.outlook.com (2603:10b6:8:37a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.12; Thu, 1 Oct
 2026 08:53:29 +0000
Received: from BN1PEPF00004684.namprd03.prod.outlook.com
 (2603:10b6:408:10d:cafe::7) by BN9PR03CA0594.outlook.office365.com
 (2603:10b6:408:10d::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Thu, 1
 Oct 2026 08:53:28 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 BN1PEPF00004684.mail.protection.outlook.com (10.167.243.90) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Thu, 1 Oct 2026 08:53:27 +0000
Received: from DLEE204.ent.ti.com (157.170.170.84) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 1 Oct
 2026 03:53:10 -0500
Received: from DLEE211.ent.ti.com (157.170.170.113) by DLEE204.ent.ti.com
 (157.170.170.84) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 1 Oct
 2026 03:53:10 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE211.ent.ti.com
 (157.170.170.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 1 Oct 2026 03:53:10 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6918r9Vb1595122;
	Thu, 1 Oct 2026 03:53:09 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 08/15] crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AES
Date: Thu, 1 Oct 2026 14:22:38 +0530
Message-ID: <20261001085245.2922974-9-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004684:EE_|DSVPR10MB244415:EE_
X-MS-Office365-Filtering-Correlation-Id: e0b2693e-6019-4231-554e-08df1f9975cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|1800799024|82310400026|18002099003|22082099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	gSCvlltDvdFTD8DZ8x3D+wOYk4fyUydPFMp0JRWiLEeskijUsypULSOPDs8Ra+aHo7Q5UXWDmzHgRZNaW2TlaVZGAyNEcilZoIWvMHBsaGsKuW+NFjoqmPdL1xn1uX46G82CdgBcQTxALWHmjVZ5J+DrYtAnQvZnimHkoMhsTQexd+pBB3ggJwOn6yOR+ly4ePu7w9NRHIbln7Wa6/PouMBVvn/d1TV7+vug88n1ct5dfIusQ3PBBcvghx5NKxKbqGM5YTsOt5oFxA+xtsLRKj3Und1jhSA4GPrGnWzTDrRxEzRwmUWoNgWIds1fyayrYtWE7BTVO+lZSMxOHsDGtv8WmSHPDsBeQqiA39KFqX4prKxHnatKVh4uFYvLKk0rwwruuDPaiksK7W/Ty7mNTX34YiWKmLXMwBlMzqHm+vNu3XQ8/Njxtpo/Q2ZERv20qe1+L9mC6tUPR5hqBixUFljK2r58AzFIqAWP6rVYfL+bP8fxcQWJL8vCiQ8NhQ4PGJxg+zM2+eeqCmsjlD/Iiw+uc/7Xv60os3JrmN4LX0ZWiLzAiAvCKFj+cn5wUC9MUadp/A0pu5eMVK/t0OW/szODcir2zbRMIGWAYtzCh1OosNeeg7+//SPPRg8ZNZ3XWPzourJxQww/E8+BbTGXvl4ZnpQfWZ+vbd3mZZS6DqMoT4KQkn/652i95XgyEkauUEfx26Eso+omlmI7yUlkqQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(1800799024)(82310400026)(18002099003)(22082099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SOfQqUOtIeXtBLQpNn8ZdqpAb9if8lCoWx5b3PCYkCKWLIPvGLwqkSLEUb63v4Xl1fHBT4xgdr3kjIm/Sqv8JB3CtaaPz4AIWzwv1NS2vQF5mLlDff9MbLywycplKUmCiqQ5QF77cmk+OGdNQ2YJC2sIGGU/0j/c2Lr6NWAI5zoNJZFQs5/+O2j0xPoTd3s6vWftmewAkRp6HdkJGChivziBGC1REvGWQ7pzI240hqyexwMzh8r+zvSrkLicoRRVWD1BoJVsxjDfIYMgvokBTOpw3xXcdgQOFZgbxs8jhWjX5eBpL5wrueCdcocodH45aWJwI4HOjZ9cQhKUaborcKBMD42WeqzTUpCnUGFJquv+ZhOh9nvYn3auvR2oW966sPE6LtuAHs54FzsU5w414a8OvxdBZL5bG9E/4ibJuGnnJovZq9Vx/YKldn1PAAB7
X-Exchange-RoutingPolicyChecked:
	qjNMk4KEqxuTZgnjGWuF7sqsC3zDNCjuz/l0rDJUVwP+DY3Uxl5HsQWvplU4aFW+ufoM4KoXe7yl8NCB/4NZiRtQa8xJ6pqQvwf7zPFbMPcXtoHoM0bpsM4fVlzQTIH2PmsYmNIgcC2AuYAU+ZVoxpdy0R2qfE0otl3bD6rTQGpIXU4QMqWpS/BDtefOae8lPGWgExqDLa9vmj5Zk3Lii/Ha6F86tY6zQoxfe4CYeuDAV7DxO6T/lssJ2cKFiIO0YUbrwbkFlzFq1dQZPsRIO+Pl9w073iA09GMiseKKeN4/DDK6pFvlb8wu5EA9cGGdj8EV1XFHfG8tz+SQ9+kqtg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 08:53:27.5513
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e0b2693e-6019-4231-554e-08df1f9975cc
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004684.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR10MB244415
X-Proofpoint-GUID: F6hxwyHbwjMqMzyMjntWb0Evl27-LaEO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDAzNSBTYWx0ZWRfXzsGmhhZHrXC4
 V6vE/zcj7D6ri8NyyNOONieiyEb4IVs8ZTf3TZVH50Y6R6ukjPEF6pkv38ah9Cj31HO05T7FWPh
 tvJWAm6plXhW/psDzYr3tfhOb3Cg2R6E5fLGe92oPommepTmli1V9BOeZ+J9/IvouHzt3A/0VJ1
 QqmgbrxO90Snxug1w1fUYYDQO75tYSIvUycRzxGwcvro9QzRf3Uv8lY0+jm82D1DLWQQ8a/l3mm
 YV869LED7NdY+bzUaYIwwlXJlkpfxLGvJclTF2rDdbuxdxYV+gE5tx2lE7TyZw1AljxcsZCeOcE
 j5zQ9LVKSXbvF22JIL2B946gAOLylygE19uCQtXwMP6OA8+ifFlgVcjuny9rYOBxHaSFCk1bJBF
 fbfIE/kTC4EbdMAIHFRO9ez82nQllzpXX+x9l6rCmuRayQQURT3lIfWFHSXZHGXqmhw8CNOXHpr
 7Mp9n6L8LEYvDvlTkBw==
X-Authority-Analysis: v=2.4 cv=KvzYSmWN c=1 sm=1 tr=0 ts=6abe1f8b cx=c_pps
 a=l4G2nZJL/liaK5VsxlxrQQ==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8 a=wrH6CD59uMa574BPOq8A:9
X-Proofpoint-ORIG-GUID: F6hxwyHbwjMqMzyMjntWb0Evl27-LaEO
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDAzNSBTYWx0ZWRfX6sIdlcQeV7xi
 ccApHlleCs/HsO5GTgUsuTAfLuh3DGFrwU2NyMd+Xu37OWFtfZFs0K2hT9XIcuA+RLEG+YIbrgD
 gog8jB3r0cmmKg07TF8eNC7MccFqSrs=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610010035

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

