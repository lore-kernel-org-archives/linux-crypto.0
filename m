Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CE54A68B7;
	Thu, 10 Sep 2026 17:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789063094; cv=fail; b=C/BaL/WTu2pG3LfJ/F1HtZKhGeqcJ58nB1Hk5y4Pnfz0f0LTIeRkKp64xc2I1SqzxcLa4sqc7yJiOqJNFWCO1grIPfKIX/4HG0n101blp5yWrMbRh5QVXVKAaTLFhUgq8ZWOwKBhOyZUL2huQkSzOPkq7AZanN995qYmRqnLJvk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789063094; c=relaxed/simple;
	bh=ysoPploXnsuJRmYnZ19/V+M8zWYzeuUXCUMX2vd/iFI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P/4w+kou4V4TjfIjftUUMeNgyKmFnKgRRkw22MtcYdhM5MynaeIdss+VXdTA4Hafg4gIL78w1YKLd8zwYSX4TUcdB9LetVu3EBh8zXkTw3uMDGXjuv1wESYOVxcOWjr+6zkwbE7Wd0Xi/q2xaOpnmPMHl/OMlrakBjVbMYpuaMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=X7Th8BQq; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=YRDOs2iP; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="X7Th8BQq";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="YRDOs2iP"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68AGEWqT3808363;
	Thu, 10 Sep 2026 12:58:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=IioPKfS4scmDQFvt8IjnJCzYXdhpHsv53wGTOOthe
	AI=; b=X7Th8BQqfDJYic3CPL4Mtuyt32XC1VtqqOo13a3GVb/Jn4ArOPoSS/6KE
	vjU/Rc2Izx9i+lrk6PDdq9kaIvQ8IPaTofIPGcy27MbNqKR+XC3GfTaLdEVae6jX
	HqkFsrO9UHZfgcNTDfkEFK6u6ztkSHCMEO60xP9uip11L3WkuutdzjqLeknm6Eyn
	yKkWiMs6Fy5dsBusYn/FIKrJkFe4I1eBo4YC4kFzj4aRTeFP8KqfCb6aCEsK6sHY
	Remb8+FciOwazzmGEbaGVczJ67B4EZqKLr01ky1FNbdqJoXjYzS/R2wPd28C26YY
	gel12bRNxGi8DB5mVNB2QhEsOhVWA==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011046.outbound.protection.outlook.com [52.101.62.46])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gkyw9gp74-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 12:58:09 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gupbi5zl9g3U+WylQYPRlmahq8a2Z5SqhLVCyeGnqFyO20zbRmySXYHyjHgRZespKtXqc9edIjmrAXxrOOVqK2Cxlr9zh2tBrLUc37Rt1duDbIxhnLOTv1hLDMdB5lln56nIEzC8qz/outQc8Yt2VCunUIf2OeSDksq9QpOHdXU+mZ3murCv4CcTjGTDd9wjIaNR0mKI6Z5C8RUQ6V8wDYXtQ12HwqfHbWaQGygd0M7J69AtyHlrc7NZTnpWYgH+X6rIVVSPY08/7MgKfnpcC4d+58gMr+FpvnxbNXupWhPfCqMRbzW/+zg14TLgAAtstobzeZw4WWrzr/3erIAyKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IioPKfS4scmDQFvt8IjnJCzYXdhpHsv53wGTOOtheAI=;
 b=dl0+Hti/duixUra9kZ90Iylo93NRqqgzLGR2nKyJzq4N7xRPpfXfP6dEVzekyP/SvjI8IrjZiA1hx4PILVqZ3KZamN7z55iqk93TSt4ZdnnmJp2XB2xmuLYdJ/qTzHN8DrQ5C70ZUmRGsrrqgJYX0EMBBN3+w3q4VLqb42hWmfSJhghqO7tbURsfMw1GuzzBqRaSBtgiKqzn0DqLn9G04ZEUjs1BO23zsq+vl17FyjEaUDPb9IgFjwi1jkNslFqcfeqXU8o2qevBXoiwputn0+WYOSpDBp1AkjPxVy4lgaQ3wNj+s2lG/gQM+w4C0ZqxOmybf63izS1KyaeJ4SuB6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IioPKfS4scmDQFvt8IjnJCzYXdhpHsv53wGTOOtheAI=;
 b=YRDOs2iPGrZVhSZNSvLG8E8tCE8LaJzpho7YfePQhfo9X7VBL+EMOqY2et9Uh+D9rd2YChja1Xmro/P2CO4euGNtxS4pYG8whg0QRRH7144kdpuYIRpu507nR1jN5jUEfGE753uzPwFOVjL4TB+CLcQQeWmZDVaYS0kaBOEdeKw=
Received: from MW4PR03CA0011.namprd03.prod.outlook.com (2603:10b6:303:8f::16)
 by CO1PR10MB4657.namprd10.prod.outlook.com (2603:10b6:303:96::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Thu, 10 Sep
 2026 17:58:02 +0000
Received: from CO1PEPF00012E84.namprd03.prod.outlook.com
 (2603:10b6:303:8f:cafe::7f) by MW4PR03CA0011.outlook.office365.com
 (2603:10b6:303:8f::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Thu,
 10 Sep 2026 17:58:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 CO1PEPF00012E84.mail.protection.outlook.com (10.167.249.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 17:58:01 +0000
Received: from DFLE211.ent.ti.com (10.64.6.69) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 12:57:06 -0500
Received: from DFLE211.ent.ti.com (10.64.6.69) by DFLE211.ent.ti.com
 (10.64.6.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 12:57:06 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE211.ent.ti.com
 (10.64.6.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 10 Sep 2026 12:57:06 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68AHv52M3764019;
	Thu, 10 Sep 2026 12:57:06 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 13/15] crypto: ti - Correct AEAD tag operations against dma cache invalidation
Date: Thu, 10 Sep 2026 23:26:17 +0530
Message-ID: <20260910175619.2122149-14-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E84:EE_|CO1PR10MB4657:EE_
X-MS-Office365-Filtering-Correlation-Id: 74346524-a579-4236-5861-08df0f650e41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|1800799024|36860700016|376014|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	qCzpTiBLx/SClSAL3yqrv9bkhDSa8Ue/IND6tuJVu6fndZijVRmKNsjQlvaYamYu3W3FGc0hRzKADST1rOwyxBENyQSEdl5Uzb9wH4gtooHef3UAY4RrCR3clNADZG/xYc5IbDCwomHH5iC+SsbHp1drJH+Q4VW10BRgVky05KO7qhuGyOZeKT0vfxzu0vFN0gKVF776UZlO5CGWvwGQyfXhJfoe/PipogPFv5sN7W92E9tbmZgB8wOrMwBqEEWwMRo4a7h4aEMqA5yDmYbika28ey0Uslgw8ThmlHWF9eVvlQCDm0HYfIfyPPN7XEYdD2musasCXGiC72JplsaXUh4D/vEvVFQS2kQTJaX/uzKZH1kDPSEDp5a5jX80wfvIkZc82aFCw+/oU2j3Xoo9uATqZMKHueCRYlxyfcLrMd7CiDbQUEliqm5effGO43EyMFjesSzX94093oNkWElACJHDU43P0VAsPt3yN0yz9ES9iNoThQQNalRF1RXQ2CPJsx5g1g/zP2zrOOuhMk3cDUrcR5YSBN9xpHK7HatdC6sAm+zgsB/gq5KOkf2ifD5ehX1o3iga/ZrHYce1a8LcbjmM87Vn74dWGPZ+b82G0cubG26u6C9sPBhW6EimSYn/r9Dh7OlVYOMC/VvqGKjTQUlZa9es7qY7ta5abrdjBAeKL5Qj6YZMWaLyIJe8xqS0/aYgJvVQ1wpw5vmhpu69Zw==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(1800799024)(36860700016)(376014)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HA1UhxDpni0Vfdxb3GCi8tnXIPuMQYVRFkeCHyCmPBAsyJuNu9cqcPadg890TOgue9vKJi03ztPIb1N14o0IclDvtHv/ccKvYy2pmQNq1vAvb9uBBVEWnBW0FaFDw+FeS7W9iO80u9hzx4sXai4z78ceT/2SwTAXO7S5rgcNbG7UaTYEz8P4swhclPNCDobpfATFbHTuW01s024/013fy54eCR9KREEPDRAWsUTtI+WdAD9Z+MqJJ9MpGxw6SRpvsI6lUEpLcrIf29jg2GFSWaS2OEmH70QqDP7qT083ulnRh8yI9o/9GJgh34EvOhNK0LO9HmcZ4X15RxnK0sFw1oI0/P9L36wjFpSUolqgkETp2IeRqMXmnDZs2ai4eNEkW1yHLVlisJnW7lFTj3NoeWKbzdYFoptu9vpLU7T6iKGf4oZSmA4JsElf6Jx8HSDg
X-Exchange-RoutingPolicyChecked:
	DRhh69TF5NyFJf4C3mYbVAakZIMUoTdMiYw8JgFO6EIc35dnAcuRkw9liCm47QiBJYtIwaqte+9Z8LZ18Q0RCOSQOHjXPa/XS8HsE38SXr2JrBtmiCy/rIF/Vs5wgdSz6ZT2Hpad0TfNr0/Fgz1uHZKbW3G9XUyFLRD6L5t70CwQQ6ibbAMoG8BjpdmZzTHLFEoL3swJiClG0EmxqahdBTa6GiZoWYaPWA5HWuE3okVHUwurYpXdh9HJjxzX36qYsYymmVD3q+Hu2cVtSoFw2aVcYEt5lcc9Es1Dd3C0rt8WgynbK0P0O/ZzQLHPNMxLtJzccpUXLtA/mczHlxtSsg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 17:58:01.3757
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74346524-a579-4236-5861-08df0f650e41
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E84.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4657
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDIyMCBTYWx0ZWRfXxuHU0OrLe6wF
 4E2QBqmC6zhq3NiH5mbQTS9m3AOIGqm49rykQhSYILcFGdEch2IdkM8C7KhX86pgVgukMqdMpOa
 DNI0bXyz9v+FH892OWvMc+L0VBrkKRg=
X-Authority-Analysis: v=2.4 cv=ON6yTiaB c=1 sm=1 tr=0 ts=6aa2efb1 cx=c_pps
 a=m/LAOfpIcXRJv0ug5Ru3ZQ==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22
 a=sozttTNsAAAA:8 a=BSBB0G2mMgAadyb2BJkA:9
X-Proofpoint-GUID: BhDAHAzh4LzEU1UQzar05I4brt5kiYgW
X-Proofpoint-ORIG-GUID: BhDAHAzh4LzEU1UQzar05I4brt5kiYgW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDIyMCBTYWx0ZWRfX9pyULTpyvKy/
 SEtwILABpvDHIIm89Q7W51bpj2/+WzNDdphX125pb3G0CS5LL/u9mOVeMG3btQn6I9x9l0Ts2gw
 Qx9nksiWlZh2IwsksWmeGBikRaBwmLbe5ksUy1BS7OK8DsDN9S+lnRllVzNjECSsUL0efKq2Hvs
 DlAcX/Aeb5tIrYa2Nw9Apro7JIOASdXy1YRCexz4OHg/oC5CnAD49WmuW8FXWaF/yp2B48GzlWj
 T2swoW9vJkua7Tgzi/vQibfpqqu5RWmSyYxrcQ8RfTLp+bgeRU0G2RAXcCmnZvtnf1X8Q1PiS1k
 4zQXh+D335UwG1vbiGByyopDWX+Fgpq9z19cdp6qsDqDxr4Fht2zrpNzBwYE/omVaL4mAcrC0Ys
 QhtjyMO5g1EHK4h2QN13MnY0WFSjFxYhjhRBcGhuRbGgUZEi8OCJ/AzihAgH1MN9sQxqiDeiwgw
 8B22cl4RTnzF3sHm1vQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_05,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609100220

There are two issues wrt tag operations (tag read/write in AEAD
algorithms) pointed out by Sashiko:
1. dma_sync_sg_for_cpu() before tag operations always uses rx_dev. But
   dst is mapped with tx_dev in case of inline operations. This is
   "technically" a no-issue right now as both devices use different
   channels from the same dma device. But it is nice to be correct.
2. dma_unmap_sg() is being called after tag operations. But between
   them, there is no synchronisation step. So tag operations writing TAG
   into the dst scatterlist could in theory be lost in the cache
   invalidation done as part of unmapping scatterlists.

Now, in the current code, we can correct both of these with some
conditional logic and repeating the sync (this time with
sync_for_device). However, it felt more elegant to move the TAG
operations to occur after all the scatterlists are unmapped. This
ensures all buffers are properly synced as well as avoids unnecessary
repeated syncing of caches.

Fixes: 37b902c603042 ("crypto: ti - Add support for AES-GCM in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 150ce65f613fa..150ba73776aa9 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -913,6 +913,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	struct device *tx_dev, *rx_dev;
 	struct dma_async_tx_descriptor *desc_in, *desc_out, *desc_aad_out;
 	bool cleanup_tx_chan = false;
+	bool do_tag_ops = false;
 
 	int ret;
 	int err;
@@ -1136,15 +1137,11 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		ret = 0;
 	}
 
-	if (cryptlen != 0)
-		dma_sync_sg_for_cpu(rx_dev, dst, dst_nents, dst_dir);
-
-	if (rctx->enc)
-		err = dthe_aead_enc_get_tag(req);
-	else
-		err = dthe_aead_dec_verify_tag(req);
-
-	ret = (ret) ? ret : err;
+	/*
+	 * Need to read TAG registers if data is submitted, even in case
+	 * of DMA timeout, to clear the hardware states
+	 */
+	do_tag_ops = true;
 
 aead_dma_prep_dst_err:
 	if (diff_dst && cryptlen != 0)
@@ -1160,6 +1157,16 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	if (assoclen != 0)
 		dma_unmap_sg(tx_dev, aad_sg, aad_nents, aad_dir);
 
+	/* Do tag ops after scatterlist unmapping syncs caches */
+	if (do_tag_ops) {
+		if (rctx->enc)
+			err = dthe_aead_enc_get_tag(req);
+		else
+			err = dthe_aead_dec_verify_tag(req);
+
+		ret = (ret) ? ret : err;
+	}
+
 aead_dma_map_aad_err:
 	if (diff_dst && cryptlen != 0)
 		kfree(dst);
-- 
2.34.1

