Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E53D4E73D4;
	Fri, 18 Sep 2026 10:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789727054; cv=fail; b=rrLPzhO3QNpF6Ik1GOO2kQxYaq6Ca58Ipz1y77QW83TakcrFcHncPggtw3zVx1wFO6kpOPhJbESj1oFJKgBpRpe+qetAB2eyAzdr1QOLku7Te2XDce5Jf0ZD726E6g2dzJTllTyqudF0L3oVHjEJCTd1FfHUZoNd0AD5tVGMzeY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789727054; c=relaxed/simple;
	bh=ysoPploXnsuJRmYnZ19/V+M8zWYzeuUXCUMX2vd/iFI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QG1vlPkeNyLXxfKjENZP8Vey23YEj7LKDlSdx83qTYghU3BKp3kTlMsNpPbhoKaZ18z+DbwXccCJWVWLsmw0QqbXozT7yKDZIxX1gAGIehZ47UhNQxw6mgmw+cC36CeT6FrYnB7bZ0KLZqZClTq9W7z39B5lsY2GE7iDyoegzL4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=MVvlTN3L; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=Rtuwu6OT; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="MVvlTN3L";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Rtuwu6OT"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68I9eKiN3768408;
	Fri, 18 Sep 2026 05:24:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=IioPKfS4scmDQFvt8IjnJCzYXdhpHsv53wGTOOthe
	AI=; b=MVvlTN3Lgeg4XQZODyuPGLOsM6VWDRoIMTLHFzNx5/gdR5mwG4LW4yLHI
	kEK8jlHGvAgLYeGVq33MqQhbULpx3cQxU7FEnGncgrSS0NoYSCVihLZYv0iX7EYq
	aZ2NoVr63aOmPS35Qp33wSfpfyUbpVTn8Zw/yTdbvmoPfF+eZ/+ZGXvcZyzlrjsG
	8Gwsx+ekGmOk7xdHkqg5zbecWRsIX9zLrdolVd8pfXA4qgSuBiALCeO+c6m3RmEU
	ECuBlaYpDFx3/N+yXqWsYs3mybVOUVTFp2Wtap4QhVlMubLPVElAphuaxSEBKkJh
	QMGemzF90oTZS7q/Pr5/UWdNIdRgw==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011050.outbound.protection.outlook.com [40.107.208.50])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gs16cgsq0-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 05:24:09 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pIhPF4mkBb43sHNPLjcalnDqisx782jR7a/8LHN2vWfiZ2NSZLUM79F1GXb7H/jS/XccBU7hHf2pVTiCWdKr2x+ZTBO5hTvOCV9eGC8Zz18hh+jmcsjZVNP40Dar39gCbi8jEecE9Hp8BIEksIa1qS7SUMQPXIryJnT7MxkxJbF6/fxQkvZnM7FuTqZbW/d1FXZ7fLYPtlb+NnED3vtpw4MIV/l6dUBXbWycPhPVikz9WLW8TmyfFnl9Rl2EUIgJXmRSfjiZ7ertdcVuA1o5DwX8mRhcVmSKrWo3hqwC6Z9lmjVAtP1xkxaLTXBY0mO/LHUk3kbOkH0GcC+CY3Uymw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IioPKfS4scmDQFvt8IjnJCzYXdhpHsv53wGTOOtheAI=;
 b=kXXK9YYFheKzfPE/hHiW1WuQp8an5h9iRf4fTsBzeMi+pDgxwBX5Y227vCsqf7ul5ipFtKgmV2PLz2/bUvWxSLQfR9zw4sRqgOejkysRXWiFk1s4MDLMrY8vKOoRPdDn6XnFyu+2OwZ9dQPyZF2YtSW5Y1AAMgQyHdljoAhra323fBx0P6MGcrUle278M7ntxlMKFXNfZYOoO2k+NN67Dno6mgGtLvhzvLLvW2V2fT1e1cJaf8HfIQ8u8d3oTsswKOK8nRWypxIm2kCqJjYbwILvWBId669A1MreADv0E+58gNBQX+eMA9KaCBdilRsGi2rONCLxBB0zX46LOaLO2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IioPKfS4scmDQFvt8IjnJCzYXdhpHsv53wGTOOtheAI=;
 b=Rtuwu6OTV/Qpj/8V3qxvtKATx4e5kGe6rjsElN3fRM2hrFlL8qJVhLxkaWxWGYmQ1sel+8XNKaQp5CMri3KnFDzEuKPflCcYHH4N1B0KXHd92H4Ktd3YyNyyWmwOUiR9eYnfMapCwQfxNXe9vMVW1/wi24oalI5AQ9F+1dVBhkA=
Received: from PH7P220CA0015.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:326::20)
 by DS4PPFA0EC85B6E.namprd10.prod.outlook.com (2603:10b6:f:fc00::d3b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.5; Fri, 18 Sep
 2026 10:24:05 +0000
Received: from SA2PEPF00003F63.namprd04.prod.outlook.com
 (2603:10b6:510:326:cafe::55) by PH7P220CA0015.outlook.office365.com
 (2603:10b6:510:326::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.12 via Frontend Transport; Fri,
 18 Sep 2026 10:24:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 SA2PEPF00003F63.mail.protection.outlook.com (10.167.248.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Fri, 18 Sep 2026 10:24:03 +0000
Received: from DFLE205.ent.ti.com (10.64.6.63) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:23:29 -0500
Received: from DFLE202.ent.ti.com (10.64.6.60) by DFLE205.ent.ti.com
 (10.64.6.63) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:23:28 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE202.ent.ti.com
 (10.64.6.60) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 18 Sep 2026 05:23:28 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68IANRrE600734;
	Fri, 18 Sep 2026 05:23:28 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 13/15] crypto: ti - Correct AEAD tag operations against dma cache invalidation
Date: Fri, 18 Sep 2026 15:52:43 +0530
Message-ID: <20260918102245.2784000-14-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F63:EE_|DS4PPFA0EC85B6E:EE_
X-MS-Office365-Filtering-Correlation-Id: df5f47f3-fdfd-4e04-d5be-08df156ef6a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|36860700016|82310400026|22082099003|18002099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	P0T7jG9BWbXi2JA5ybtD05q59+hQr8RC2zES5xctpC2j1skSIzaRy3eCIbWVFKH2rZcrlgPKT0tUj0IsGgBGgB0AciAACnzPjE95fzfCSgsSwiGQnlIKylo1q/xItlkIfof3mFI1e5M7MBhwhfUe2sDdOqHrUa7JyNnYMrQpZgNgfbuXMGoiz+6jMzQIt4p1CGJztC+FUaQG4oXtf5BZiFc6hAMJTaDj3NqrB9fvI5rvmRabfQZRHeRA7azqBqfgTYhkLdvkbJYqRivTuDoDfK3PDYulvvBM9fdTdlCSl2kL3RxkyB6ON/3EjSOilGSBsWFbSPjTqnfasUCnnIvS4ZHK0q5UugjTVV++XFLVsJ0Y4/BLLPnzlDNX/zWKTllGIS2EcgfMqz9eQMpW/umjIW0rSvVVgI/Na+SskBw3B2XhzG0X9TjG232qglODls/QQ4iMelx23jvcT5ds5qibAxmqJfWgALd62oPMLSHC39/+pGbx3foh5R8WNVtwFsTPIBVkF18alP3tXLE5W2RHqUWCX4kUQ9xMVlOHnbIkbsdZ7TAsHj2SPnmvmwq9V2ACdQ0bJ4KqVrmuqatw9AoIpv6xNnOxGaPQV9VWKwDYDMkz0okFy7w6E3BJHd+hU7KNwNc4A0o5uZr0OdG0589kDoXu89ia2/Ox0WUSNSS9pCYd3ptfJfK0TbBG0MB9NEktp94d5uk2CoQwu4ZX0ilGyA==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(36860700016)(82310400026)(22082099003)(18002099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	OFrsdeEZPK08kmJC47+YSY97Q/1j1tnhcNKNQSariGQuKPAm300Vg0Gj77jXA1fLYY8p18FiepOWSp9mxFWKYWyCfiYnLvJjDg0BeXMbFcaAYG1+iX/KT6gRn9ImxdBBc6/lBolLi7dbujNMQHdcKsPXR+TkAEPMT/5flRurdbQOiEoTgNNH12tbdd0QiH/SHDztT4R9B4ULWiAR+B3Yhb/9uR7N7sAGJr84owmCt5pwXKyoVKQjJp33YVEPWeZSqsfCjyzS7DTMRkxXHxjLEAL0hI7QG+zxKyo6Mvq7jLKLImmEIhHn4ywzvbAKaMnI/CpH3Ib+KseA4DDvCSNiK9gLyd+A4wBt54NLK8ShJachS88R8nemTDENAOfavrZOprZmAgvn++btKHlUcPRjJJbc83lzPxNI/twHn3rFimHiO/TrIDYPtTxJrIZCJ1YS
X-Exchange-RoutingPolicyChecked:
	KsVdR9UV9L86Zv78XBO1UClPE8XzKtOdkxIMU7uxEUTfa6OOX57XI7reMsYpzTlulfIN6C+a/v4gjKd9DpjScKFQe7IINeunOI1i2ePovS/5669MH7/lM1nBC59+5OBbzH4XqpwoRgVhYDJMygEs7GMVgCP9tFneLkoqXb6xBF1ZQpqh7nZjHnqm8H4qXYePgHFne1f9xMmw+iGRqjs44OWRHiax79Q95Um4YoJJ5W/6GDJmcthCKhRKtCUYe+XLTjbolVWMy4KajyLat6uX3x0JrvTRUR2HKuca80kWaXYrzD63INICp9xnsTlMEMUMUoCTYaxPeG2vYPQ5JEdBdA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 10:24:03.8167
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df5f47f3-fdfd-4e04-d5be-08df156ef6a4
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F63.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFA0EC85B6E
X-Proofpoint-GUID: NcFMqTXNathCJvAAd5ahgIG99ysNHRa3
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfX8DFYDACklLTp
 4XWQLwEeeWEBl/ivb7CdhPYk4uBnFp8ZTsMgaidM5XdoMA5BlqkgH697P4ZlQBxgxxjoszpE8Lh
 dL/yF5a7P8w67tB/4LikFOhGVUMJWhg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfX6VuXPZj6bCzy
 ocTnBbu/Wp/L3IfHtaRehFOTcWB6g+Wb/ErppcXoly2EUMqihqIaisVQxDSe7TqLT4LvP5gkFZP
 UIZ9tmUC3XTxGnvJuOT6u5l73m+96akz48eHo3k24+LhY8n2MxbBkzj0rJ2s/WWIHAYObfN9pDB
 /zTEOe4ZGcPpbL8WdTw/CA2g9Anrh7EahdsVz8LbCTfoQh4qyBfC0tKtaFz381ZKBKVUqMdyUxu
 twmH0od9bswT8furq1MuaaDcYkm+QYNIUgtWTw2ev5FZnJqzSjoHqh5ZNnzTgrta6vGnsq3jUQR
 aH5e0r/zKvfa5ZhrE/hjwwXRCisOuLx7uAVnSi4xHtANO2hbdE5UZInImsLHlo5tWHbYXDKxQCy
 hpyjWtXOF79DVcuSpg8M3PBLaLxTZd147vm8fAnsY9e07lHrd459mOQiWQYwMFsRDkiA1otdaAB
 zNU01kG7cuvuLciJ0LA==
X-Authority-Analysis: v=2.4 cv=cKh1IVeN c=1 sm=1 tr=0 ts=6aad1149 cx=c_pps
 a=v7DXidBSvHT+GL4JoI7fUQ==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=jwouBfj2j3NM8CExmVVE:22
 a=sozttTNsAAAA:8 a=BSBB0G2mMgAadyb2BJkA:9
X-Proofpoint-ORIG-GUID: NcFMqTXNathCJvAAd5ahgIG99ysNHRa3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 spamscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609180144

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

