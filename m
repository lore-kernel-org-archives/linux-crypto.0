Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A204BD786;
	Thu,  1 Oct 2026 08:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790844852; cv=fail; b=m+Ee7GZEZW/IVRloTC61nCAX1GkAVy0OcvTsnskJ1+zsh0Ce17Eb06HWFSdhuFff46fU5qsO6tnL2m1K6p8uDoDXw7nh/x7sHnbkVzchlMzFM36TY2/DXXyuXmo5FCI3bQrMhqpDcO1vFv3GMf8X7vxbNmMvhlJ5Xpiwh8AX28A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790844852; c=relaxed/simple;
	bh=MzuPGd7CtTyEUkT4iY/z7NasQEtGNPf4RFeoIlailh0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LB97ucQ13YTR/0l0diMlXjQvyxJEtWQW0XzRe5SMad2dTDetBW+dNRe4rSwO6VEy31lC9XA3nAQll4M0twolBC1wSOrpRvGFwLZHrfoOxp2tWfpMUYkfFN5Kwsn6c4+iyJLwl6WL+mRGTlu+4ouqxrEoDwc/llg79ClkcdqNwSQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=gWqmIfOP; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=EWQdU90b; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="gWqmIfOP";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="EWQdU90b"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 691710qB1294540;
	Thu, 1 Oct 2026 03:54:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=kw0bYOZqo3sutisalqPSgov/smSOlio/s829GS9jG
	vA=; b=gWqmIfOPg8rxb0WNv1+bgg32zLi4TtVUxh5TNWe1AFT4xG6DRVNpA9F+Y
	9VB0VbAU+4/nAbP5Zlgqxa3zWWabdbK6wpyX7nq5fuM3kkFwDLENE26Pl/cAyE9c
	jEVoYcN0X0Z3eCwfs0dm5WSV0d17fB4XTZD9FQMz232wFcXxF19pcO/ACoHsi1jJ
	t6y9LEWnjZiSwDEnOnwh0K0V83hbDdVDUOgQeyOr++0t69ytPKf84HBpYGSbaYbd
	1bPYwwPFvXl+VxPHyw9KzcQsMMpRIATbDYtoDKiLtAT9/C7awf/+deCCt1nHfg3q
	OEFYiZ8EStgC3J3gaJVdZ13y07DoQ==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010005.outbound.protection.outlook.com [52.101.201.5])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4h1eur9t55-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 01 Oct 2026 03:54:06 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GdAnBDEjTHYT52dCuqpGukLxV1AwmJAguLQggjcyKh5JMWeQuyLe3FD1h1H+Na8xJzg1tbCCU6X2J35ecvVD7Z0r6JlJJ4PwMOl5q/zGxGvL6tluy7E/N0rhPUnfv7L5RfGfcsJaBI14e0dTXxRSJJmzqeHpHTCbcCrzH7hFS0GxiwWmWJlB6qJ5f4jRHdGEYRAtHR47tmk8uc4apq1Tki0U3qBtkuy1PjQAEG0nCaYpR+YsJ/3g7RklTOPrUNEthY/Mg0QZHeWJ5C4UlNV003TTBpyciSqwMreSndFeP61O7KFZcmce42RkTLGSZBvpF7DeUjR5unm0vUT/2K/AIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kw0bYOZqo3sutisalqPSgov/smSOlio/s829GS9jGvA=;
 b=Yb54MZdTRe1Uws8qxQVJnyZqIGgjDzVRuJvJijjMsyy+GrNnj8kroa7vgf4i63ythbEEDRmNYxC0kfs8OVLf/n3ruIA1UMdYtM2tT1TDgfoYB4pBTYh6LgibtNRk9whHJYVHrRft20ke69s8VWMUrYSQZ1daAQTiQzIl17QfLAmPV2o9vRqQZ1MyFnAj0+YnJHF6jWg0hEWn2PLgvTvuUVyRDvCodfsgIWOcwl6JZeBEt2o6ge0qPDzT5oAKPDITkZYHwocBOM7b7Y1dOMo+76wWM3DFjpb53GMdOWAbhPXtoSiW/cUf4K+x28F6hoGhMSWSIXvnnF48Zi09XD40Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kw0bYOZqo3sutisalqPSgov/smSOlio/s829GS9jGvA=;
 b=EWQdU90bQqHAoi+ZCTF5kuRcFnWpwcytJ/nMUxWkEE2PrCYzmci8F/ErUzbQpoJS8suprgz0jWSrPxHCN8wYmfpgB4lk3hTHubMWtMCJv3jPbz4WTIx9RFnu8wos71sJIn1cGySKk3yFFPZNFvwV6i3q1mGIVG8G/O4pn0IQiyc=
Received: from CH0PR03CA0251.namprd03.prod.outlook.com (2603:10b6:610:e5::16)
 by SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.9; Thu, 1 Oct 2026
 08:54:03 +0000
Received: from BN2PEPF000044A4.namprd02.prod.outlook.com
 (2603:10b6:610:e5:cafe::37) by CH0PR03CA0251.outlook.office365.com
 (2603:10b6:610:e5::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.17 via Frontend Transport; Thu, 1
 Oct 2026 08:54:03 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 BN2PEPF000044A4.mail.protection.outlook.com (10.167.243.155) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Thu, 1 Oct 2026 08:54:01 +0000
Received: from DFLE214.ent.ti.com (10.64.6.72) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 1 Oct
 2026 03:53:22 -0500
Received: from DFLE209.ent.ti.com (10.64.6.67) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 1 Oct
 2026 03:53:22 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE209.ent.ti.com
 (10.64.6.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 1 Oct 2026 03:53:22 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6918rKKp1595442;
	Thu, 1 Oct 2026 03:53:21 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 13/15] crypto: ti - Correct AEAD tag operations against dma cache invalidation
Date: Thu, 1 Oct 2026 14:22:43 +0530
Message-ID: <20261001085245.2922974-14-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A4:EE_|SJ0PR10MB4589:EE_
X-MS-Office365-Filtering-Correlation-Id: f9ad49ed-946b-43f6-356d-08df1f998a4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|23010399003|1800799024|22082099003|18002099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	VMuzBrPHOFT9IAS+dlYEwATiI9r+Om8bKUhVBaJvI5N47HJKu1iSOdxB/Or6wcP+yaxZpeXJV+iEZg/iODmcB5CHoUhd2jkF4SEmuqFfv1otBxmvqnQ+25p6j+tuNtDXUF5qOFj2arOxEGzJJe6DmMhgY45vI0WYj4nVeZ9C2mA+jFa/WQTrYbqfmN309QfBhyyLL2EoM2AQ9epNjz+SJGTn/g3nsHTXWsjghAOkGE5KktXusNIuJn5LPhal8Mrab00oqG8rC7CgSJppYcJYy6A40QvN8Fe/7vIVHHqasT3rsL/o9cLDROFBt4HNyb0XLFaFTMwe080aQJ1aOm/0wQ9tMM1lpP3jigtx8dSjCUXAHqP19mE1tsSeMSw2Kus9xhXD7yZWhwm+fmEc4BZQIvaeCnnFrJDbW0OAusjShe+sXUCMiVrc42jSK33lPEmgk0i+PVftGaZjPpLXkaEKx6V4fSHSv3T1r4IkMkOShh3D5o1hRf9vNqfMGnxHA9kvAnCHiCQU2UAdJafAXQynxzrsoQ2T5/BG1jfX2sENgLv1ukuPohvHHzrvQVBj8Hk/xrnRuUvtEJ3j6+RVdv2SfYdCcTngqi1Kf3/x8Zbul7mkmBSzzTY1tBCM5fANajPMejiu+1AmKadKg/nNcp66Jngr0+/65idGZTls5CNjnvkojkx5XbFUYdSTQmXnlt2jF3139i/m+VvNE7KxVm/VMw==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(23010399003)(1800799024)(22082099003)(18002099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VxLLBVNzALhsE7666YMOOkEdwEFq8Bz+TFUf4B/efMp2hG/PUDMLCegNBOrmGBwFgllMK2TheupMU2TbEmQxzWj9ncllvXbZ2grGcZMyEhLSuCwS+ABDkCI99dYYOpOuivCQ8p8Oq3Gyo6X3qOpwKahtLKDw3csriWTWtM4Lu4YHTtGXFahcWVnzNM/DP0HEYQeHsRGwpZwSfVWHR2Db+etSlgOJK+emN27rBRG2P9LlpseicqKG9kiV1Iu+u/GtGjugId4sG0mfSSXFJ6FTuGCykPiu+i1Hb1Ggfi0QyXTV6Jd4SAaFj064ytudZiYm2csPAqeWJ2wbbKgcMF+q/gBfENUaDqpYS/4PBtH2fCMgPpCcbqx6U0drlx+IgWPCmdk5/j5CJvfKYgrLpQvRpx/Px4XC0/PkA7ROdJx0zK+vDYIs0siwsotyL+IBEcFn
X-Exchange-RoutingPolicyChecked:
	aNgxyAXAiq3T/qwBuu8r86+G9+P+n4OMVdWqCrZkdz8UntJCbcnN6JyAN3Pk2viprI1wDvkyNOeApn+FflSZrR0Q8CiWrAnU9xTyrv1iyC+PEjAXxOE/zaFCCsSXR/HRE+Y7Fk42MdLwTsHWafT6wthRsV0KIEq57l8DHuyxrSEU4Rp7Sq3HGJqaUF+7zrUhog6PHNYJq/sGT/GfCe5kKEvdbh1yHk/EjBj4ypiJgsDR52Rs9MBc0sGYYyonmJQsMgogKc6d5JwtUBSxl3myNb7r9LfgTo8eoXkATZSsTw1Iql+TCuiTx4DNJpdRby9Np4nyb02RKuB0aPtRXwA3Iw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 08:54:01.9602
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9ad49ed-946b-43f6-356d-08df1f998a4f
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4589
X-Proofpoint-GUID: zp1CcQowIPpZmI7PPfoVTze9pux8Od2I
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDAzNSBTYWx0ZWRfX2n9wZ/icUCwc
 jFRWXs5Miz6ez/iY3KL8pn139zYde2/DSMkU+5Fx9xB2RPdTuY/9JQydrlK2Yw49HpF4kRFKVx7
 SZJq2D2LVYNR3cQwkBl6CIOsU9CN/5J01Cg+nJAvHSqJwmWWuVvJoB9LA4cfe330E41gjvTCEAm
 8U5g3x5x9Frr1phaFM8zQj7p8+2cDHZEF1nyGmpwCAOXtzMRifvKt1ZuuwcC9H13Bi9CGP0MnS4
 CflUb+UeGCF/VW8aDkQCnVv+vR5UrmvzwPUeMzMQ+Lz8BL7hdAKEx9KjLrPQJD29lK6mbEeIA+u
 PPHbFJlPChGcgng8PB4xGV+i7NijYDjVz8PeMo7Dus5Mz+RqMAM6APWT0cGmZPiROSs//Q8tPw7
 30MHxi5KMOOA+tnbzvB/Wl7XfWy50txQ7tnJv79y6KuwL2vqYtDTNtGNWEoCj4BjsCNacD26Kdw
 90NGT4p8vs1dx1NSprw==
X-Authority-Analysis: v=2.4 cv=KvzYSmWN c=1 sm=1 tr=0 ts=6abe1fae cx=c_pps
 a=q0do3moUNMjvKVsQ3EtoVg==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22
 a=sozttTNsAAAA:8 a=BSBB0G2mMgAadyb2BJkA:9
X-Proofpoint-ORIG-GUID: zp1CcQowIPpZmI7PPfoVTze9pux8Od2I
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDAzNSBTYWx0ZWRfXwurIQoJULOsL
 Am02LTJz671oq1XEZfQ3dYfl8loIqE3N4ddCOlfM4IHh3tpt2ZJFDjdp8NJap5wX7KJvO1f6gh+
 jHl9glZjvslvezdEOLknKSRF8gixPq0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610010035

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

