Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A9A463B85;
	Thu, 10 Sep 2026 10:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789037022; cv=fail; b=R263L3kWg0sLjkZHEkMKes++sgYh4lYMQ+Ej9IYzI1qAtwD62PsXZwLLs9qRSQDdACj62CWErI9XBcLuYTWcTm3QS0zSUp9sqO2uSLSVTSQDfNKWUNkh12ST81UmqA4haqIUqasLfhuqZxc0qnBrKfVdctnbGGxve6txmOgF/nc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789037022; c=relaxed/simple;
	bh=OuWkyrSAYLpUMGWtwqp0QtAQW2fMadEqcmQ2cP2XYgA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OLdQaIIPABcRyFI9u5F0a19RZGoejFa+UN8k8VHaqzS9x4G0m90rxXIg9A20JlLP/hEAE+WZVqqliyE0a6CohZd/16FfvRU2SUsybJd6rr/hPjIi4ya9MFGl189GUF35HGfs90ey75baobMmH4m2PCwI6RriyQMRuUUjylsvLg8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=lOZ4wSrB; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=i++KzF9Q; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="lOZ4wSrB";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="i++KzF9Q"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68A9KLXu2786572;
	Thu, 10 Sep 2026 05:43:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=kZD+OiTUMOfEPNZVRM9b0rd42p1/v7GDAJbNfg0tE
	ug=; b=lOZ4wSrBc+jAEHA6RbhOgiJzB36DdbvayZZuySbGrpUI6SQQuzKekDZqt
	JvWy+WuriNC7o4M+6+xeUhJBmq97kXiGViqiEpyadl/0UD6zptPrChnQXLWQU4cQ
	b50RotEJtvRA30dYInsCIqJVdSfpZJzzVBmw+G5vdPvcTbC3XGx7eTQI0gYxsUTc
	h1g8kD7Nsf3SPHmqP1jpLyIflob7sZYYLHkzuXDCbSPDeAtdJT3sfgVhYFn3vrJF
	v7Gvq2rgjf6ue54A2rw39mr4w+/npGdaFqgayHJXzldmtdIdhKxNTwh9gcOV+t+p
	1unMZYm7/3jF+R3H4nXnCNRrIPU9Q==
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012058.outbound.protection.outlook.com [52.101.53.58])
	by m0380145.ppops.net (PPS) with ESMTPS id 4gkstv8ba8-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 05:43:31 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=goYMwk/pbML48Hv09fUGcCndUG3l8+yqhBpYzWW60b35Bp94iL2MZCn5R1jb0FyKuGuY7ROnFAipo6ZK/Sqm6k2FxGW3JLTtYJwVDECTgSSEs1C+1+Jc/qFnwB5xz//cLviUaNC4PWjyv3yW2gKAyl+EF6HrvejX9HaalXSjCNWskpJlDVO5ZFcdVf5FvNv71jOZ5J2ESd9sp4dEPwpsN85iEM3/VIjksUjIYrnJIaG34yuM0kHvZef8aC0EBxQe5lY/vzcCd6ipcgEhe1AA7o6+LZVoNkiUPSlga5KZGo+WgQmgVl5y39BsUBvCBWRCgcOxV1gSCfyZ2vXp08je9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kZD+OiTUMOfEPNZVRM9b0rd42p1/v7GDAJbNfg0tEug=;
 b=LFo/9kWKtVr2FVg9dPmFh6WXDwp5OyfR17AuGH/gZ9tv/zx99DpAmhYJ/KpfWZeEJzHTtAaWM4NMDNvfu8YzLGR6gwXPjTeba/6HHSa+KTL6Of2EKVuiauI6rFwaivZBkP66s+AZvZ/qak6DVgGgLax0Ellch7NyyQeT46nwLUtIAjETE7JqR99Q67ADePIR1eUUKw343dLPSqW3Z94PDPhoSscuKydJVI5TrqBStqAmzBaHYEc1u03S93paE+9ChmHGAYbzJdgoGM1HMI/QaCTfwAtbWmMvDFJspSxaztZGi8otdAyhTSFR4ZMW3mnxs7GCchstISHbAbfPZMCEuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZD+OiTUMOfEPNZVRM9b0rd42p1/v7GDAJbNfg0tEug=;
 b=i++KzF9Q3rxmy8QU68RBw12bMlHKuCEpSdVrBsdgMl5fL8dCt1svooU4TvU2tI4h0ASSJ3SIh8C3VG+C1rWY8gyiQA+LECZ0MrSWCy9/P78MqoqROWp5lupvvu4ntUvQyBT424jpEkSILIiG9Uo15C86Ha0sKdBKp1nPFYWcGLk=
Received: from BY3PR10CA0016.namprd10.prod.outlook.com (2603:10b6:a03:255::21)
 by DS4PPFC31902354.namprd10.prod.outlook.com (2603:10b6:f:fc00::d47) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 10:43:27 +0000
Received: from BY1PEPF000264B2.namprd02.prod.outlook.com
 (2603:10b6:a03:255:cafe::39) by BY3PR10CA0016.outlook.office365.com
 (2603:10b6:a03:255::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.7 via Frontend Transport; Thu, 10
 Sep 2026 10:43:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 BY1PEPF000264B2.mail.protection.outlook.com (10.167.242.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 10:43:26 +0000
Received: from DLEE206.ent.ti.com (157.170.170.90) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 05:43:02 -0500
Received: from DLEE205.ent.ti.com (157.170.170.85) by DLEE206.ent.ti.com
 (157.170.170.90) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 05:43:02 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE205.ent.ti.com
 (157.170.170.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 10 Sep 2026 05:43:02 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68AAh15A2178264;
	Thu, 10 Sep 2026 05:43:01 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 11/12] crypto: ti - Terminate DMA on all error paths in AEAD to clear descriptors
Date: Thu, 10 Sep 2026 16:12:01 +0530
Message-ID: <20260910104202.1537226-12-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF000264B2:EE_|DS4PPFC31902354:EE_
X-MS-Office365-Filtering-Correlation-Id: 14d52b36-2d0f-408d-cdb6-08df0f28588c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|82310400026|376014|1800799024|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	POPizgIvSve7bt8WdOq6TOYNXMjS+YQtSuqGr5luVv15tQviMTsI7s884CShmtG88+6XQKYDj9Wqtx6/yw7XTdTpgkPkN6Ukrjl2vb0XkHI0ocviiVpUOZuB9Q2HY+9b8T0ttQveC+8Ce1EBKg8q+gzKPbxwpX9s4j2uhwXjS6SVnutwfFMJypDNPOnvtaDzAsh7P+grAVy5SNwszgBebsmfnvki1vjcM1NzwU4V1VMn+b+6TYuHwEdCOTnnZrKkNlelIntFcHSJv43OR6sQNYJUbpVl5+qMweBlsIJNFWESoiqxRzAgP7r+S2oOYNPWSL+mk0PyQI0cL9kzIMT8P8pk7qopofPKTPKYrZ4gtd1VzbFfAqM6QxAVjzKn3ulNnKXgfvKxBEyQ+CGwMq4w0KCYRZGFdQ8wqZDujO8KhgJWiHnsVRUN2HEdy8P76esiexxEonnu04DsR0d46h+1dKZhHOwLnR1FRIzC0AaHgTG+BeckHVre54sp5jsTRlp680MELwXfpwnBczoEdFFKr8Cv2+QCQOcIGzaMq6lLGeiqKj2bX9JiOOrwWs08zkVSgKyvDu90I+x6cimtbF6c6aywlMd4YCDBw/Hif5Ma3CdhE9ZvBqLrEmRFSy02PRhD58fViP9/pYhNvx0HsQCjcNFK4DkXOYJyCJkyeL0D8QeWVMra9wFsmlgeWhpzSfC8AaoT9xv/9fZyuScSFx1lBQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(82310400026)(376014)(1800799024)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	tuy/R1Dds9WQw8B3SDvxRocHjOkhnFuc+NXtxboxJla+3eSR1h3dFk2Lg/OdX9uYM5d3LECXp3pF1hbQeFhQB3AyXlcWhjw8gWUvI9q7G+lOirdTT+ttirRasGxWOji7lRFPJhszCrhS7+zht6dXtVpR48/Hf6DQuj4agnYOdrQbLrkc8oyPxZ+/jw2FfmVhkv0G7YU8EicKD9A2XHWGR7xD1quB5Ue3bVJHYSOZuKaMYgTlpM4vwOznGHKuks3TJzDNUZLOw6HCJ1y8oScfIk6dVJbK/JA5Q09hmVp5zrfBZaME8XIH0YcIKXmzA6S9trUZaqa9zu6jMKi4BV7J9cALWi+fbVf9Kd9kGzBHmkAsIVR4pmw0wPJTVFQXtIWu2SmOCnRBI0B2uAWqWPV0oHPWH7sDdIj9W9dq/pw7GV7hvmRnmwH8WKUms+J0FSwg
X-Exchange-RoutingPolicyChecked:
	NaYvyFPvFfDvu8l5qFt6aiz7JJCZe3NNd8PtN9MMWiOQWFfBms79R124i6lBdLdbAu0wIWYd9Shn9KRqHcGRDur3YDF9ajmKSxYj7qUzwvdrNM1uPgRWVpCGyJV1TZcCn0y8cGjMK/VtitdzPxKzLvohi6QxRosJhHGb10glPLrtnJ6N5JKmAL2DvgKaBj/I1UIrMhhqMHagFLFD+bnoHpJq54VQkOJHfxR/21fuQAaaRBpP63AqSpWaGRsGa0oPe34EwWaUMOgrpoxnhX89cbB2rJ6iXhpiGMwwtvkefGdA7HZWPdmSjV+hsAnwLLmMjuHoGAC64s2/8kxQL4LkyQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 10:43:26.7317
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 14d52b36-2d0f-408d-cdb6-08df0f28588c
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF000264B2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFC31902354
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDEyNCBTYWx0ZWRfX9Ufronlfocc4
 0ncaaQAQaQtBdJEHWKq0V+gWeRv8HEwekug3uIajgY0DaSKI3odyAGNQY48AXHJzZ/hHhYh/1S7
 Zm6zQ3T08xmQwTmzu10JmWnIwU6MX9s=
X-Proofpoint-GUID: uvcbVPbigFN6wlx83RsitA2llsAXphrX
X-Authority-Analysis: v=2.4 cv=VvG2kO2n c=1 sm=1 tr=0 ts=6aa289d3 cx=c_pps
 a=eaWElexNrpfURq8UtOOyIA==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8 a=noPYQ3j_lezN9luSq70A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDEyNCBTYWx0ZWRfX3hyGviuLTS8Z
 SOYtrMovFfyv5Qm43PK3bL4bQmZRNPnHs/ihs2SOGqa/d5BQcXi6+Ww91TWAdy5C6mmQzSpl4Ry
 fZUvgkEi9wfRqWBG+er4Ej0sLJVetme1bTclSD8miBbha0zYDqDmJLoY0cc1s8AFLbt0MEwFy1z
 s6sg/Vy6cNQ77o+sg5uExypPdN6ooB/D7KRhE7jGYaIV99U3Ut+hP7Xq0eAT2Ap8d94xLC4AsUL
 Am1jWFgGepE6GXHRqw9jkp2/BPx59KNn7f6HDsRcjK4dYkAH36zXTmNkPuTHV4Gg2DArBsV9vtY
 WY2pDwwfmhkskgQqHFWTqAGGoi6WRXjUprPPhSPH7VMCavj+r1zkJRxvxos50yKQw+cxIcaY93k
 OqZLwnjSdNy41+OFPibCm+yDz9MjMKL5CuMDpup0cv8ZPMR9Y9Uno11EqkuxivznxsUdhj8jwCR
 ISZ4K+ASlk189MT1sTA==
X-Proofpoint-ORIG-GUID: uvcbVPbigFN6wlx83RsitA2llsAXphrX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 spamscore=0 phishscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100124

dmaengine_prep_slave_sg() allocates a DMA descriptor which is freed on
either successful dmaengine_submit() or on dmaengine_terminate_sync().

The error paths after descriptor allocation was not clearing them,
leaving the descriptors orphaned and leaking memory in case of failure.
Add terminate calls in dthe_aead_run() to appropriately clean the DMA
descriptors.

Fixes: 37b902c603042 ("crypto: ti - Add support for AES-GCM in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 10073bbeca113..a034c1c8f20ed 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -912,6 +912,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 
 	struct device *tx_dev, *rx_dev;
 	struct dma_async_tx_descriptor *desc_in, *desc_out, *desc_aad_out;
+	bool cleanup_tx_chan = false;
 
 	int ret;
 	int err;
@@ -1012,13 +1013,15 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		src_nents = sg_nents_for_len(src, cryptlen);
 		if (src_nents < 0) {
 			ret = src_nents;
-			goto aead_dma_prep_aad_err;
+			cleanup_tx_chan = (assoclen != 0);
+			goto aead_dma_map_src_err;
 		}
 		src_mapped_nents = dma_map_sg(tx_dev, src, src_nents, src_dir);
 		if (src_mapped_nents == 0) {
 			dev_err(dev_data->dev, "Failed to map ciphertext src for TX\n");
 			ret = -EINVAL;
-			goto aead_dma_prep_aad_err;
+			cleanup_tx_chan = (assoclen != 0);
+			goto aead_dma_map_src_err;
 		}
 
 		/* Prepare DMA descriptors for ciphertext TX */
@@ -1028,6 +1031,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		if (!desc_out) {
 			dev_err(dev_data->dev, "Ciphertext TX prep_slave_sg() failed\n");
 			ret = -EINVAL;
+			cleanup_tx_chan = (assoclen != 0);
 			goto aead_dma_prep_src_err;
 		}
 
@@ -1036,12 +1040,14 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 			dst_nents = sg_nents_for_len(dst, cryptlen);
 			if (dst_nents < 0) {
 				ret = dst_nents;
+				cleanup_tx_chan = true;
 				goto aead_dma_prep_src_err;
 			}
 			dst_mapped_nents = dma_map_sg(rx_dev, dst, dst_nents, dst_dir);
 			if (dst_mapped_nents == 0) {
 				dev_err(dev_data->dev, "Failed to map ciphertext dst for RX\n");
 				ret = -EINVAL;
+				cleanup_tx_chan = true;
 				goto aead_dma_prep_src_err;
 			}
 		} else {
@@ -1056,6 +1062,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		if (!desc_in) {
 			dev_err(dev_data->dev, "Ciphertext RX prep_slave_sg() failed\n");
 			ret = -EINVAL;
+			cleanup_tx_chan = true;
 			goto aead_dma_prep_dst_err;
 		}
 
@@ -1145,6 +1152,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 aead_dma_prep_src_err:
 	if (cryptlen != 0)
 		dma_unmap_sg(tx_dev, src, src_nents, src_dir);
+aead_dma_map_src_err:
+	/* Free any descriptor prepared on dma_aes_tx but never submitted */
+	if (cleanup_tx_chan)
+		dmaengine_terminate_sync(dev_data->dma_aes_tx);
 aead_dma_prep_aad_err:
 	if (assoclen != 0)
 		dma_unmap_sg(tx_dev, aad_sg, aad_nents, aad_dir);
-- 
2.34.1

