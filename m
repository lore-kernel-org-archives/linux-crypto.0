Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A995013A9;
	Wed, 30 Sep 2026 13:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790773242; cv=fail; b=WHkPPrPAf68zgSvB0SaOmjuH7LRsMEoywnVJJbGli4/7JLcldBiCyJhnEcILak1ydHMlSk6IXTRAy6EfloW+CPqwBx0eldb75dDq+P6xk2oFZ8e/LUaBGZDTThqTrd5WQpJqE55ZnQguKKsqvYgGAXaajBszyvM7Qtsmf8sM4U8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790773242; c=relaxed/simple;
	bh=MzuPGd7CtTyEUkT4iY/z7NasQEtGNPf4RFeoIlailh0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MfSJ2NT7BYiru7wdsqErxyFX8kmcycdtoSY98SCIirqAITWYEYfzqdQFWqRR7tl25vFa77jjkXGiqjzvM9Fnqkli5Y3ABRLdt1iTi7mB4EXtXtJDfgefZ6Wz2MgsVdgFgI6WgP6C/wZc0QgStN47sADJu2gL66DeveD759+mKXE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=OCM6vtRb; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=Qno9i8xl; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="OCM6vtRb";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="Qno9i8xl"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68UB5cn83552438;
	Wed, 30 Sep 2026 08:00:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=kw0bYOZqo3sutisalqPSgov/smSOlio/s829GS9jG
	vA=; b=OCM6vtRbpdUP8O3fWlqCuqjGfUZ9Qf1G5RTrL0NfMUqJORmEKyTQCBt6z
	XECTYlJGO3ldOlxGiASQ15UM84Fz+IhIbOS8g5DrKAjybSFhGeVFPGRDNvCas6Un
	hhcGVZq0Q+7h+K/HNXGKB+hx6ojcCjLs9En/zvnNpJisvLwaGowiL562w2j4nHch
	eKnmoGqHses2VqK24iZUnQeELzz4Bidle1jUgUdJONXQmr79gSPCaQF9AQzdEkuS
	UpNjys1vl8LLEpwFbAYknyaebR3J/CccQXzB8PPnJFxLq116Ka8D6iy+9ZTUOEie
	kIUQgJgwMU965Pzn+umKUMABMl0KQ==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011004.outbound.protection.outlook.com [52.101.62.4])
	by m0384305.ppops.net (PPS) with ESMTPS id 4h10s20r10-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 08:00:30 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RRM/vWzjE8GIbJWxNp7l7ZDJIJIE24khAIlslCSgFEHA11AdogPL2TmUUdtAJhJj4fJNAnQ8dGtCeaxiClI+uA1sR8nnoqnvANlsQ0SdaATSA2xJFmLl5QSS8lPGgivbCF/M9ywi9BXOWJW0zQWBTFlYAPO59n4HXTF5zwA9TsVhQuq32LVMxH6ymB2BV46GUCa6jI4Cd1wiTGIixudpp9vJ9ogd2yKQcvewkxB8/eLiPGsPuN8HR8nTCuyeSvjKM3UDmL6T/dti3PnX4xvsnonBvCzDdQZoc28JlHAdKv9FWDV29RGfAcaEJw1e35qaE2W4MwaxjoFZY4oIl0uREA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kw0bYOZqo3sutisalqPSgov/smSOlio/s829GS9jGvA=;
 b=fvrmm2L3iINmHWUkNV9SVPO1+Do8FM+F0GENQn+aPLuG+T6T4q8pB2lSAJzTZ4QuoGRupWJ6cYfJwbauYp7M4uR3jUA9T1Ky6btd//goU8x2tLcu+6wm6YRA4MnEbiiqpCDmIKg1sZ1TwWSAtsjp9B1gO15JVgeDM2ZiNz0yDKLq74ZsqI97RcNr+UKf2+6w9amSiGmR75Htq3d2PrufaR5SWfMtk0Y5OTn4Byrrwhd9kwdV5ZA3CAAUUIPbz2a/WumQsXz/qOvjh518/jRju4sckfj+EdUxd1xWv5DOFWhbavHx0bmGbo45eQr31xk7ix0DvW5EanChEvPyZD5xwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kw0bYOZqo3sutisalqPSgov/smSOlio/s829GS9jGvA=;
 b=Qno9i8xlP2+fCZEIpfy2+/AgtkE38JTbPCGoI7dlRiVPKW2aKarOMJ8hxcVYF7TRx895hFNZddyW+U5rzuEZ8IRu9ldQkn2Cr1W86RIfQcehKw8xZUMNc7MJbifq1LOKOtZbBU1w/SFIPj0WTh15GzO4snkbVsnKlqdlR/sGbhA=
Received: from MN0PR02CA0009.namprd02.prod.outlook.com (2603:10b6:208:530::12)
 by DS7PR10MB5022.namprd10.prod.outlook.com (2603:10b6:5:3a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.9; Wed, 30 Sep
 2026 12:59:56 +0000
Received: from BN2PEPF000055DD.namprd21.prod.outlook.com
 (2603:10b6:208:530:cafe::29) by MN0PR02CA0009.outlook.office365.com
 (2603:10b6:208:530::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Wed,
 30 Sep 2026 12:59:56 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 BN2PEPF000055DD.mail.protection.outlook.com (10.167.245.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.3 via Frontend Transport; Wed, 30 Sep 2026 12:59:55 +0000
Received: from DLEE202.ent.ti.com (157.170.170.77) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 07:59:41 -0500
Received: from DLEE203.ent.ti.com (157.170.170.78) by DLEE202.ent.ti.com
 (157.170.170.77) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 07:59:40 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE203.ent.ti.com
 (157.170.170.78) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 30 Sep 2026 07:59:40 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68UCxdp03154159;
	Wed, 30 Sep 2026 07:59:40 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 13/15] crypto: ti - Correct AEAD tag operations against dma cache invalidation
Date: Wed, 30 Sep 2026 18:28:57 +0530
Message-ID: <20260930125859.1749849-14-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930125859.1749849-1-t-pratham@ti.com>
References: <20260930125859.1749849-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DD:EE_|DS7PR10MB5022:EE_
X-MS-Office365-Filtering-Correlation-Id: e1d3a22a-5974-41b7-3e80-08df1ef2b981
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|376014|82310400026|23010399003|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	wD23bB+6u7h9X1G6QJ0yDub111ElKMxBRdRgRWDUmv7nn6JWp+CQ1sinl0kpFzxS4vUHnn4QiUy0HV6xVChxd0EL9wOudDMf6tjtn3U70h9YMvRavRQY2RL4fRezWZLcOiiE0pQppu04QKXsx7txbx8k1yr00HYkslSuEG4jZfQl6Nox/WZKKRYg/fb6x/C6b+YXpWWArP4Qdvt54HfCxu52XLVEdGDKwnSxcN267BWuDHHpg7LSjNgWipQiM347xpXI5C4Jl9teYqaoSg2s6WnUZfbfpgSZn0aKwj7UuyEdryrHXcHYgS1RvV2UWoQC+TlRgFgy6gb0koIOUAfFoJel0UmIg/0qwvd8+9y+h+Vixk9jFBx3ICfl7fUD+8h/LZ49m2D5WPMNsEgNrukJ1YnUGW9ALv8lcdJ5pDejpcl8vfEwV2vphLTMSQcgvWDb7xFYMJBX6iIsdCxLuihmS+i5aZEb0bNqGIXKkx2B3SbVvl0vTUcgxTBhlciNqWbLUNA0i78pi5uegOem6j4Ym3xGJEGSAFteVRz+dAm/PwKzUD8wChyqmF7R7y4tEkUbX4wyX+cAPQO8avHNpNC8DD8r83EbdMtklGwi8fjwJ8F/rvy5MiFnX7hO3iXSTv91UY++mIs3+wQfkyfprRw/Q8v738qtyIQG2bqqzA4G0TylFIAg6p3+Q30aeLG4hwpIsU0LiIyNqW3hrrt8pudrgQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(376014)(82310400026)(23010399003)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	fT7ZalLemXB2Ugmm2yG5fjZyNxe3pLo6gIPaXiKRdQoExNGpi+OtopfYyRntBzbT2a+DAEcSWyySuGPSHSHUB3owiaT68XvDR9XzFNdeLGFR2mTscQ7yRaArk4K+2yOa2b7YuDm5bTVjc0xkqE/OXbkBKMhw8S5ehTlpe5CC52eRAranViNbTDZHKqK7p9zVTTrFEMlMUwZpXy8Z8RWUAK1oXB9G5uPwaxX/6usKuBEp+XyugyH7ycl6znoBTL3USjX+KihvBKBmZ8JeRzwzjFEjt8pjWJfILMsw8isFvy8aJS0y6CBHp/xzO6ABs6Z3YXwqnwmiLv37qzOODfbFrtg9Ca+lw6OHHPMh2+oLUy0uEX262qiram8dS4gxElBL8xdJTRAZsFU+aO+S8+Mjo61hq6Eak0b21/oeRIwu3bcI5TJX68YL00Dh2MZryz4b
X-Exchange-RoutingPolicyChecked:
	xSdltoylyGSh62BpZB9AeAvhWurtJv8GktFJC0XdVl1V2/DHdxA5a2EMo7108h5X4S8mu1UHdYAJ+tbStb1qF8ocU/x8IK3NsRqpchVcfK5TmXoZFFcSwdNRyGuQvKjzGOFHvlPBwieWsb6MAipGnWje0tOHKbry0g52V3L7ZuwrbBEHqU2cCNgWo1EZzx8Rfd5+RMjnvzA2pFwM/8fhCQu4yvhg4+p7hc+zhFP7Nr/IqiYnLU6MvvOpx5XVvEPODXAyN+ASYIbwzX9EWVCIu01Td8vND5WQGgg5FAKUx+ufaYSn4DatNLrYlaLNchuCLaMWY7UPBpTSIVG6svBr7w==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 12:59:55.1859
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1d3a22a-5974-41b7-3e80-08df1ef2b981
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DD.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5022
X-Proofpoint-GUID: okKdlK5u_g9-bhe8A-4OEe4NhiwLD-E3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfX3PjA+/cnXJB0
 zMQ/22IUxCXXZJ4N/mynY8yauBYhVjrVG4/xbaiMvPw7biQ37eBhn0X/iIhNxIvDGrLYYoInkTB
 oz37w+r68WngqtcUsIAzN5zsN2JLNCX0EQmz1KG5f8PAQCKfd1W8cH74oM1AIXvf/HXo9gsQEer
 vOvPrK1LeqQ3ECwJ1vjRpztq43R9JEyGghu3ihg0P3H/0ul85WiCOrC8HEL/tsmlFObL9KYm6Er
 FXftvQM2iVvC58IYOkfamappWAMBVR94eTC4VS34SaMHTLUzOS+d0GwVehe4c6FmtOfQlzyj34s
 ZsnGbtnNDF+EQTaLziaP8dOxcSxW7VJtZjlqAUwN675a98uw/mslvb72XRgYlwkKLKdVVw7xumt
 Qz7Yt59YB6G1+z6N0wXyCsYw+jkWCnZ/17eFV4juLykMQPiYaqiM/WxFs8wh3M8ifW1mAPfriOF
 RELBrSXA5gRSXi9pp9g==
X-Proofpoint-ORIG-GUID: okKdlK5u_g9-bhe8A-4OEe4NhiwLD-E3
X-Authority-Analysis: v=2.4 cv=G6aJgNk5 c=1 sm=1 tr=0 ts=6abd07ee cx=c_pps
 a=7APEvFnVlBjFtWv3F9ubqA==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=BSBB0G2mMgAadyb2BJkA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfX6NSsZNV5Y6g3
 N3nfgFG2jL1IOOJiQutvx61mpcQZX8Cy+d/yzmy2y3xHU8s+MQW2CVJZJ/DkyMqjcMKQrGT1Tjv
 fhdSsoxL0yXYG5+nlfmhAlNrJUSECNk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300051

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
index bd26c3f438e34..657653d6c62f8 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -915,6 +915,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	struct device *tx_dev, *rx_dev;
 	struct dma_async_tx_descriptor *desc_in, *desc_out, *desc_aad_out;
 	bool cleanup_tx_chan = false;
+	bool do_tag_ops = false;
 
 	int ret;
 	int err;
@@ -1138,15 +1139,11 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
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
@@ -1162,6 +1159,16 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
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

