Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE754A43FE;
	Fri, 16 Oct 2026 12:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154792; cv=fail; b=bgTvOaFIgxPVIfcPk0ii0WUA0IabzSLeCwEkWc1vUpLu9RtnfK4JYw5nwoJjizNibdKZMrUqA3lO8wmnfxCubIfJB+Egivb30jSIfVE13WN5R+8IkHcgWdbOOiuuQnvUIKUaDb5Yk2Ei9UDkE6Z2OCTjtZvxlNJGZgXWUJXY00o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154792; c=relaxed/simple;
	bh=MzuPGd7CtTyEUkT4iY/z7NasQEtGNPf4RFeoIlailh0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F1lkTUx9Udp2Bw0sMzY2Luf/12y3ZzVQKKdDhqPehMseGLQ8XM0AUtsT15JVMxe4qlA6NDzeIytVWmw3IdaPV3vRE5UsSGdJYQfWCVo759BBzKMo7fM39dampJKWhXFaRD6rCbEqdwDaRAwo/SEo8qDG6YYpIvvzNdn8rJG/Cy0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=G7V4Wef0; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=nT0GZ4zs; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="G7V4Wef0";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="nT0GZ4zs"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 69GBNufa491209;
	Fri, 16 Oct 2026 07:46:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=kw0bYOZqo3sutisalqPSgov/smSOlio/s829GS9jG
	vA=; b=G7V4Wef0+SGilJT2J5A2O4QSg2SIuodfHYZ9eukpXiu4xsE1dkrFPFPzI
	Fbqg25GyOiAq6We3H9D9VOlh90EtrYESMnDwF/WisMoUR7vgIkjGulLX4Ht57DFS
	NXT54CV/yVrc+5R1MWe6BgoC46dBKlaFsU5RbyRE2ufj6no4AM65FM4w7CsZ99OX
	Txf5d036Dqz5XVQpeWJX2RP7tjDaB+2ZCkujIAgm3+Pt1y/xTKKyzYxaqPkxI2GO
	2RJR+0jWlLui0uWHwBTbDACZv6pEyXPayxAsTDS8+v5mBPIGuFFN65g0J5eJNqhx
	KY+it7vkTa6mHnjOBNuo433Q6UjIQ==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010048.outbound.protection.outlook.com [52.101.46.48])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hbk12gbrg-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 07:46:23 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DbNwkXOaSHcqHdZDzlbP0BpGZoSdGFebIlRkZBY3btMIaWtJsey8zMKa6t3smP4tzri1B/RcitGDE03YEyeLzXD24uiFsFvHgctTPSZswfqJ/gRk+y5udw1o1clRejaoffWMgjGpK7JS+fzB576WiGOkoKIxMLEhSuPbHKD+YMWB1DXpHd0iflt1egoERdpl7ezUJEo57w277WahFVwVRoq8UjxOmwCU+xiDmFsfgCjQbZ/9WkjOkDBUobuCe7+WYtZByDQXLK63YBZCnq2v6O9hl+0PJlp1bv0asc2atUOWm3B9v5Iv/PT2TTr1o9x6AB0F/7qd30HoIo0gqTqPYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kw0bYOZqo3sutisalqPSgov/smSOlio/s829GS9jGvA=;
 b=WjtUK+fHByJ0l8lfX5TmO4U8gtVjKqI2cRhqnD/wc5ba+7WWCYOMpwY7jvcQ1fowBHrvQWP9WJCxvkmTF/iQkA1gL1LtAY8oNewWQvBGQOK32L9xnpOB7TJNPTOeGsfenx2YJqZYTmXMBTA/IEd893RqMPZlyshArQcn8Ix1Osmo8LHSi6uG9a/tDG6wPQ49thqDo7ScbWxXFnht1opX4LEroWPV6oMo3VrPD0/l8Zd4M32+vfE4JQF4mxRVdSz0z42Rzp7TFqIniVI7YW/HR+HQ1h9Dl1Rh85RlraNngZ7RueLqoDbRKYJG0ZYJYz4HStFiTQ3Trmwfy55UwRJcjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kw0bYOZqo3sutisalqPSgov/smSOlio/s829GS9jGvA=;
 b=nT0GZ4zslB32gF/ecMwXtHqnkWKffG4ukuXnJBjSS1GiUMbJRBZFNTXwmhChWATW/NXKDhES8xqiZXvQxJtfhNRn0kZp9Y0/wz7Nu8afznzkRwkAA+az1Hzp5XizFEyxIQ/TQoekCJFbxEx+wMHbqpYDaz6B5Uz+VSVwXhSaBAc=
Received: from CH0PR13CA0049.namprd13.prod.outlook.com (2603:10b6:610:b2::24)
 by MN6PR10MB7492.namprd10.prod.outlook.com (2603:10b6:208:471::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.7; Fri, 16 Oct
 2026 12:46:19 +0000
Received: from BL02EPF0002992C.namprd02.prod.outlook.com
 (2603:10b6:610:b2:cafe::26) by CH0PR13CA0049.outlook.office365.com
 (2603:10b6:610:b2::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Fri, 16
 Oct 2026 12:46:18 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BL02EPF0002992C.mail.protection.outlook.com (10.167.249.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 12:46:18 +0000
Received: from DLEE213.ent.ti.com (157.170.170.116) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 07:45:48 -0500
Received: from DLEE207.ent.ti.com (157.170.170.95) by DLEE213.ent.ti.com
 (157.170.170.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 07:45:48 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE207.ent.ti.com
 (157.170.170.95) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 16 Oct 2026 07:45:48 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 69GCjl1J2531786;
	Fri, 16 Oct 2026 07:45:47 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v10 13/15] crypto: ti - Correct AEAD tag operations against dma cache invalidation
Date: Fri, 16 Oct 2026 18:14:54 +0530
Message-ID: <20261016124456.1802080-14-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016124456.1802080-1-t-pratham@ti.com>
References: <20261016124456.1802080-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992C:EE_|MN6PR10MB7492:EE_
X-MS-Office365-Filtering-Correlation-Id: 8098804b-15e1-49c2-3898-08df2b837969
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|23010399003|1800799024|36860700016|261009223027099003|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	xXZebaXW0ieQ8DTpxDG3zld3gd+vsoXpKRiEjnMXV3RvqhVwvy4oeyZUtBt/mfaK/TyLpBYsxEeAQRgSuC6CJbGthxJh7gVC2XiiEo1u1w+TlEABFq5RARcvFOG6DaBWpdfoENnktoohfGgVQCOWkt8E+/g+81INWMDAUlq60rnOYQ0KJdZtnqTqNlQKM0Muv9rDRy23MLMYz2MMB76uDigG8liFZb3kiddc3du+sXZBxmQh5Uifn/DuZzF0xn4y0mt+MnPsyNbC/VyJLDUgdheH/g/6tbTAyECVgSYZKwKBka24f9aJLnxniJHhkFKlefwUwAx5wZLF7WpqKmEcga7xgMgFMtgbZUJ9fdCr+5jplAH19+xBQJKhSowmRuSd0FYIw2dDCJ8ADIysrq/zjFjtYSXRTufj3lHKm9ugjd+GD2zu5V9IfpHqWApPbYuxH3N3giSSbNqY0YQjj/DYOZzjNDaQIOEl1KqmiF/DusB4SNEhFIesmw9HSF13//v0eE/1ZdgBCRS9rBe9Br9QxC0v4yFotmoC1IZIYHmxWb2eJEqHjLQD7xXbPpOuvqMWszFu7Dz5ZoHDQCKlwFFrg4W8g5fm/ql4vGtmiM/Z4zAG4qkohLNwjisnBGekgFrcbHE7tNwmXTl1lpkg9dbepO7tuuQzm/1IMsCcvH7sJZ7xf9iefOcWD6NczktU8scPsrxe19m6gI9iBYrNwY6bLw==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(23010399003)(1800799024)(36860700016)(261009223027099003)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	hOMRDDEb9bjFYdS6r7MrbEISd+/qe2mR78YN07CCSrIU6w2VSPiihngYwlYUU4TjgAAicAB8sadegUy3R+lYm/cPKl5IyDykQ0PrCvMlAYTV7SHvhfBNfm8SdDCOpK6AtEpd/9J/EmnjlCv7xtBGAyF4VIZAumzZEJUolc+uLD55Wm6sgqL+eXMyEevFhgazY0EL188Tlk0d3HsUawd4ffmmdKuJMrQOWRVXHca/G8Dn2BFtttfFJiaQR8a+1D9um1SsT9J/MFbKwS9/OWm6ZspA7m7xEeumtSzNkI2yj8OCdE1COXMLaF7znz1qiLFNm0tZwjgSh2p1n8mpcCysjbfoMK1KPacUop/AGQgnX+rMSEGuPnpWT+nVtS2FaUuCjbgrvk/Tc0kcYK+gZMOhZehjYB39tfa1rZ2YD0jOFtWWiPWmnhHXy4ED0/A27SVp
X-Exchange-RoutingPolicyChecked:
	lo8fDOfP5x8URbUMvshJcXm8Uudh2vZovr4mRpUQ5RlFUysdRu92m4pNVpr80EBgHNVGdJzuBgYDnDkfNb1KL56qSIUbDTgyI44ZmmlBREjmLlI9AjMKwQ4DH2h99qcA7V4AiAfTVMTZA8g+WKp1O00TFA55r4eyjFb3j+T0IsfVRA4s0XQyAX+m9a76COnWPijrQeTJFraTogDBjGCtEflBa5jWSS24kF0nDDu8C2W2YAMYsqBFxsL7sc3BIrT+Ac0xl8etVahoZ9ISQF9P4TJ63I+2UUrlx6jSwv7AIDitBXS60AYDeHtiidjjQO8pl+2fq8yCE8jBTLzubsruHQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 12:46:18.6377
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8098804b-15e1-49c2-3898-08df2b837969
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7492
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA1MCBTYWx0ZWRfX8Bvp3pRTx50s
 jhlDFG+NjvUVo8QdGo3+krmG/BUeNrxIBAj/yXM0nZ7MMNqDSV4tQIWcY9H1n3wSTDzwdtMn5KB
 R4/VSUur5oaa1O4H3MbXfxQwM+qh8a1iIDyM+JZZcquKoJRPhNuLLZ0s1U42NaEtn6MYgSKrIra
 wD/jAjuMa8MimmUT68sbgkzOYmdy+845zDur5IIzV7ZuY4D1wd4ZNYyTEsDFFCaY8t14XEAcG/4
 wlAdDGU7ExKhq83ozy6WWiTp+XJT6/65GKTRHXjbBvq0nDU/S29ZYB7rO+nb55q+v8UchNORIZR
 DjxSjsYG2Vq9RZZLGRrRAtpGluHQ5U043EJnuqoJuxHoM070ugpRffKUZdPOXTFC5jQ4NLJlutW
 ohPcZxKV03fNyQYU3Vimp7braTg6SOKlkPJGH31TYDr7o1ulFHg7zkEI9HjCp2EfZTMIHd3HDo2
 11x3ftm7X/Zx5TGSvKg==
X-Proofpoint-GUID: NchVzUh3RKqUcVqlosVaAflc2Mjc-rpJ
X-Proofpoint-ORIG-GUID: NchVzUh3RKqUcVqlosVaAflc2Mjc-rpJ
X-Authority-Analysis: v=2.4 cv=fspJ914f c=1 sm=1 tr=0 ts=6ad21c9f cx=c_pps
 a=8KrPlQlxEYnZEdstGaGrzw==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8 a=BSBB0G2mMgAadyb2BJkA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA1MCBTYWx0ZWRfX0rxpu5FsSrUl
 tyQQ6h/Gdkd8Dh8bZHvIyBQ4Oy874/LJPqOXoq4mr04D1Ab6rUsfwzyhXype/5NHjTFUyEgi0w0
 yll4yd2Pt9KbQGMrqPHxd8tlknB878k=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 suspectscore=0
 spamscore=0 phishscore=0 impostorscore=0 bulkscore=0 adultscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610160050

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

