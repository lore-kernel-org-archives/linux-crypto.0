Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7836415F1F;
	Fri, 16 Oct 2026 11:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792151389; cv=fail; b=C/V7bjf5q2GENcNP87RHRKkSYsaEP5tIuQ7flyT6QetZy39IUL8mIYaea5KZfRfvOpNDncKZRK9jHr7y/dV1OFqbm2BwkenzPhOHEo6i6rDc6Ds3iv0QXt3hwB87DnkfV4Xzyvd6xJ7soNi6CHszPyB18+0DsooUqfQruxmi2+A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792151389; c=relaxed/simple;
	bh=MzuPGd7CtTyEUkT4iY/z7NasQEtGNPf4RFeoIlailh0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dnlUfTHo753fiYyNu8jFSv8vcdsf5QamAl/R960Xr2G1XzRFs2A2QeY5EHSJ/AOhggrq6+QZdSHfTiEfTs3OoEJdYG2tCfLaTkaUcW0UlJFshjoIhuWS0k6e/27uy4PCQaJFFaDjqHdRtuwNQ7JycVsUIK7SrvnjZG+BXz/8bgk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=j0w6L+5+; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=LL8xYsfV; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="j0w6L+5+";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="LL8xYsfV"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 69GBNxTT491294;
	Fri, 16 Oct 2026 06:49:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=kw0bYOZqo3sutisalqPSgov/smSOlio/s829GS9jG
	vA=; b=j0w6L+5+zx+7+dZyKe5wfUUiqn7boIZMSar6mhWF8tybiEM/ESBjlvzC1
	imCfDIFqJ1521DbiRLXMNYRBa0c3NFzST/EUOaxLqAgymIIii9CO/7VrULfq5yTE
	Yd52sk6bCkjQK6c+nOyxp9EuVcuaTq6CvXCOPQZTtCpOH73ReuIop4klqBI3BRsi
	dCFosCylVXJpWMqGEicsAhMdRJoQK7t5pGMcWtyfiTF/zrP4oZ1ouJ4xr/183nT8
	KWL1MtCdrCDY/Crh3+yshf967/gpmpA23qvma6dj3HsCUEjVP6EdNuUrWxeTUpmM
	L2cRhw858XXXUJQPrkReaurupqW6A==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011050.outbound.protection.outlook.com [40.93.194.50])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hbk12g3p5-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 06:49:45 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E7c3ouLAIAhEjXBOJL+StAUM+Uj2h8Lw5OfSwUvepn+2OlPxc2gB8RZf5/Zfltsv+3nF0opyXScrAnjvIlZgnszaS9R+LsaX7AInD/ZGK1QGoGt9nRpqtY/G4nQeteftb+LXYXkX1AllwquUAlHOxDqAPoO7+6nsPSa2yjC+YSlGC6P2jT8HMTqZNIaKsU9DPKl7sNvBOK4lXkGWOo5AmOMYd6N0R6XdbYoVQ743ztnQH7O+IeTEAKIX/3k57w2effhsOPm8LD0jkefAcinBhrVvczfVbUXPVYrv3EV8Tw5IRXZUNTv0T6PhCyfDQW6fYSOldfQ4SQx6/F9ICjv4HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kw0bYOZqo3sutisalqPSgov/smSOlio/s829GS9jGvA=;
 b=IGgD369tkArl8pDLNFHqmIP2c19RBjiHq04Bw1rnr/LkYnT5fF59NOCXfgpN5Bk/bkSwY+6RyhxYsopKc+N9/sWZhvKUe0/ja94zaZtzhPtfz95w0hlBRwWHZzZG2EdITu9+RKB9swpH2gerbw/LIpP7PaRkcSrdNUVKRYnVqpzoA8v6j02q2S1wDyOlLdkdeDg1aTQBVOKmmJ4CW7V2jGggfXRG/lzHzlPJO9g9abklSbpjiae8BeNeMO9dWy7VFtc0k6ufPVBcqeX7ZX5AjLAvu1GQ6dKh48Ur0mSn6T19v9COjJQ5OisNWot+dp6zgDg1EaeEh3fJk85mZ49JOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kw0bYOZqo3sutisalqPSgov/smSOlio/s829GS9jGvA=;
 b=LL8xYsfV6QsDAWFKocwezIiIWinkZ0+QF6iZdnsyI8ptGB0PwjVeamLrtBCEKVKx03zYkLklaMCnD7s3BMY+RZ4bUUjiHw+RHW9du2Dp1+uiyV2fVprZvQhAuGtzhfJQbLmqqsfCIVumHlLHJnRliFs+YAV9VORXakT/NXvEvP0=
Received: from DS1PR03CA0017.namprd03.prod.outlook.com (2603:10b6:8:233::16)
 by SA3PR10MB7024.namprd10.prod.outlook.com (2603:10b6:806:318::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.12; Fri, 16 Oct
 2026 11:49:29 +0000
Received: from CY5PEPF00000E74.namprd02.prod.outlook.com
 (2603:10b6:8:233:cafe::5e) by DS1PR03CA0017.outlook.office365.com
 (2603:10b6:8:233::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.17 via Frontend Transport; Fri,
 16 Oct 2026 11:49:29 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CY5PEPF00000E74.mail.protection.outlook.com (10.167.247.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 11:49:26 +0000
Received: from DFLE206.ent.ti.com (10.64.6.64) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 06:48:56 -0500
Received: from DFLE202.ent.ti.com (10.64.6.60) by DFLE206.ent.ti.com
 (10.64.6.64) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 06:48:55 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE202.ent.ti.com
 (10.64.6.60) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 16 Oct 2026 06:48:55 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 69GBmsq51508911;
	Fri, 16 Oct 2026 06:48:55 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v9 13/15] crypto: ti - Correct AEAD tag operations against dma cache invalidation
Date: Fri, 16 Oct 2026 17:18:04 +0530
Message-ID: <20261016114806.1749515-14-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016114806.1749515-1-t-pratham@ti.com>
References: <20261016114806.1749515-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CY5PEPF00000E74:EE_|SA3PR10MB7024:EE_
X-MS-Office365-Filtering-Correlation-Id: 37d8312c-819a-4b6b-aca8-08df2b7b87cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|82310400026|36860700016|18002099003|22082099003|261009223027099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	Gpnoeu8cbXTZgi8HthPA4e6CB4w4XdAW3ZWIxLkpgtvum4WJ2HYarVYMWY7u+kqq0ROuoqZHTjX2Gd4dbVjFt4M9xKQVJKsGITib6ts1R+3BC/jRYIlrVkR2kT2/7lOaRLub/S1ogHSz6AY8ssilIrW0xzgT5UYJXNoIoA/NOkI5ow+zIrzkepcGrdEw2naLoXF+xq754fZlApTnX3HRqKpM49FjBNeU6vO+K636Edrtt9Jx13yUY89do6g5wgHiJxjw7V/yfBnaSpUWUDGWmA40msnZcaVJC5l0eHFx1cO37EVTbRpXBAglS1iml0H2Yjd/RAN9YwaOFOszyR1Bsighxv4XtehHx9IcvTjO0qSGt74K72VezuBigxzwh0l+PoRzitSDsfmJOuM/ZQzODkHys2rEuWfCimEhUvlqAJfZkpSClG3i6vxOya9ZotOKVoFyQkZSpPs0ICZe3Ejh3WY5vSiyodQu09El4AUOSQm6ZCyAT5Z2pdpw7l5bOPWjDuAj1BspE/6BDM3Atg0c0YaODrrgq10PbTl5QLz+39mBysduAVhTn1FWOQU7pYMvkwL3frho+C6rr2TcM5DxmVETlXDPdGMKgP7yjmJCfphWsdsK1PIXDrPDITflGfJ9Z6SJC2qBz8JK/OyoKk8l1YfudazUCOfouI7GJdeTmxVOIBszWv7gljKDoNjlx1VpLFDVI40LWQMc+NlvoURfTA==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(82310400026)(36860700016)(18002099003)(22082099003)(261009223027099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CtgbcsH3fPH8vPXqOLVslxt73hbbXnIrQApe90CZfM/PUpHJxS5fHIqSyfNs11go88oy9Hulw9Achk7+3nVYYl8HNEAJOd/fPmuGexMntLWNglM/5k+plAmO7A0l+9n277tojT+JHUTJ6lF7AC2tTlAumfgi8cITKLUX+mXoG5LLbXnxR/MMFVQqlm+IJMiUwq1sR6yhdoNht9dgoGaOH2XM/i1uNayc+ziTe87jtNgYMzXCDPcBi3Qt2tyMvPO2BsdLccUN7ukFYU7UiDO3b5iNcpiETc11SHccYMQLZ3sCpt9SxsNCzK3sno+XKkpFmivgn1hHkRn9r0p0POeIVK0BP1UbLRK6ZUGDsdAJhRaDTIywly/eNH+MFBAMCZTeVaibEYQTTXG6J+RCJdtui9XOk9dGrFaMjDfoChl7Cp7uYh8ZLLaLocSae+KX5v9P
X-Exchange-RoutingPolicyChecked:
	LChCX2tlK0+rBIrhhZ5YOXsAwS4BmRegdf08B5ALaW0QRdLdK/wbhQ6LdC7jrv484aDD5MgE7tg9nmfXiaYhKaZxQP8D1ZC6M7AQg8YlQBNgelSduJu8i0iJp7CcHYfgK05nNKLEGcEPwvK8oS4zmQ3BrOBS5iq1TF32W26Fnvirw0LTcUSOlmiMDtmImz0bpQpmFgO8JL4Du02EiMbRacNhZo6HekPGP4s5c+TWFEUVSsVr+Qk4yIH4avQ+BeOGiVvDJrohgo17QIAiRSOoBkrnCDiU87qpOq4jigi92ub6B2caBBFa0pwUwYm7BybdgCTF2fjgni977T2WXhriOA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 11:49:26.8589
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 37d8312c-819a-4b6b-aca8-08df2b7b87cf
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY5PEPF00000E74.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7024
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA0NiBTYWx0ZWRfXzbIjW2XHpDQ2
 ByH+SaLapZf382sQYaEC5cib0W25tfQcnncjkjFQ0m46Qo/ldfqgP/56kYI8hEYTnd9eFiNSoqE
 YX33r56MeR1aHWFe4aLu6elZpTX2y6ATYlH9X0oPjCYUSHY/hCPC5Tfk5vwQWJxWwA6t/ZuJfRP
 /4qGl5ZP8/DDnvSE0AZefB4oEzC8JC4jvjeZxZ0laSzxYuUXITwcDjPrUTWr8IjLUV8lfrdn8Sw
 MqusqOQCSt5P2Zn8HMUfnEWBs5SSLZi/Uuteobx9f2BLnIJfQws5FdQJcU7Ry/h+NiB1svQSQUl
 gdEUb9sPmq25MoGX9bgnj+AqQG5rSnR7m4eNsbdegM5diKxVxlBUnR6xMlFQIr0Rit9LqdugBSr
 E2c6/6mKdqVFk50yErG4nRX7wqvFyV3Guuzi8g4IvAx1m3Y8iRZXkeRI9at3uZN32nD9f0PZOHY
 UtYyujHo1XVEoKzT9NA==
X-Proofpoint-GUID: cOZqEr4ZNHJxp_DuEFxzWPxzh_4ZpmiP
X-Proofpoint-ORIG-GUID: cOZqEr4ZNHJxp_DuEFxzWPxzh_4ZpmiP
X-Authority-Analysis: v=2.4 cv=fspJ914f c=1 sm=1 tr=0 ts=6ad20f59 cx=c_pps
 a=UNZgSj2+zgRPHH//f1mBVA==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22
 a=sozttTNsAAAA:8 a=BSBB0G2mMgAadyb2BJkA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA0NiBTYWx0ZWRfX5jT1/iUGdwOK
 l0zHZm0kLHPIekAEhi2nj4VLfsFNH3ijg4ZOBX7NT1hUDW8VCPpc1XO8bhL/Ge4bhqRd1cgOrhf
 qE2ojhiLUcHPo3qSQlR2RtlxdIe0kjU=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 suspectscore=0
 spamscore=0 phishscore=0 impostorscore=0 bulkscore=0 adultscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610160046

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

