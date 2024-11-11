Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2086.outbound.protection.outlook.com [40.107.21.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C675C19E7FA;
	Mon, 11 Nov 2024 12:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731327158; cv=fail; b=bRbTKGw6x4Sm7/TCRZYSa1SAnpHu9O6k+jQvYw8ejS5FkTDoWLQgTTyBkJ7YZ4JYlKNFkX9DLfzdYmvLcz4f3XkDekMgn3pQL5KuMrKJDf85fj+2n5NccX5ip8kzqh4c5tOzSilDe4bhdDr54tumDPjjJRxd1Oo2lBdjUhhQTIw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731327158; c=relaxed/simple;
	bh=RUB4zyGxfIayHq3XuknMTd7GF//9SnsSrvMTUKZzAl8=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=RlIfc9Q5miLXglK3JPFfNmktEPXSqom+1bC6/aESIjausGFOmRqbFhQ8HHgcUyU+inGpdvpiUcbR6daTfYhQ6HqPc4fGUstXyxRe47nN/fyXPdByE2HZ171jId7OrYDVVbl92C/LEB5BOk2Es251/Gh73IWUk5Q6EqlHb1b+g1A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=PG8wdx2Z; arc=fail smtp.client-ip=40.107.21.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="PG8wdx2Z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WXxoBT/l6LENbgFuGH1PKuYkiZLa1ZNRTFLyCr7IWXjC8lDshIDxE8F5XLzXSc06J90SzC+zUNMdzbTUCm8t7+YBAUQhmwIxAqTNFtYoZ/4VPR64UILVjUe2cqzrut5swROP3kBUFnZYzaVaeEyPosduGkgYJtjkjmfIzIgX7CfquFa0AwhJB+77CHG2r1gfmaDrtt6RMdNxcvKdQbr7uELVIthF2I5advQWgtzOxp17+RhzluI3ZMDgX3/7d8mcOZDX1VPI/xLql3NxcG3weVOCeT/hvYh5pNiLGYZL8FeoC1EkSbFJ/rbmEIjbVVu12sKloquxWSpqYE5nhImG3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ieqSFTh4KeBwa53tpwp0iUAhMivK7HpaO5ro7AW5n08=;
 b=YTEx2jxsQ6rIARXMQCsEb4a3TIHWQN3btwArRmlM/gA/7OprohdzcqFWFtC3tEx19PZ4qvWYKCInJmxw4g1alT8S0a2YkgTIf5Br6Q/4AjhgEMOnrzNXEK7ZTrWPVCiU0yYGGI7q6TFIgj2Kbdu0m/M3YZH2D5DT66W75RMKwUDjt3X9Fm7oR0Q6RR9m7iRhiiVlQ8ZoiW2RsS1RVY/QrWplpgDKKdsUB6fQ2MmYvrKwqoCf7zrvagMf+1BwAKiX1h+gYesjulvms1dI1fHxynVJsq2sqJ8VGo/EuqnsRoKSqh0IZwfsr/TtKYvHAq4AQs9HK1qKcznN/x4T/fkuXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ieqSFTh4KeBwa53tpwp0iUAhMivK7HpaO5ro7AW5n08=;
 b=PG8wdx2ZUbz6MAkk8IEVTztm/PsAEwqrPdW1K/Lz1lvFmxGJestr9oaYmQ4Avu/xEt01zKsPWK1ivpjarToTUxBLhRlPUycxFSNfRoIleA65SVeO4J+6V1ZFt347Sj1ei9QVBJGN9yI6DJ72LnhiyZyofbn1jcck5lb4OEyDCEmsspnkuImR+VIBVkaQp5I+0DiGal2x6WKOpn2DK5Rle557KIP4Sct002jgeR5ZWeJ2QFzJIeHKdcphCwkffKKFYjvcYCsqcPW/F46mUK5OWOce/RBmwfkeVJYS3JApXEhXXzxiDSnLCDivfciUl6YHC6MgHpQi77MXDTSLxrQGHQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8409.eurprd04.prod.outlook.com (2603:10a6:10:244::6)
 by DU2PR04MB8776.eurprd04.prod.outlook.com (2603:10a6:10:2e3::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Mon, 11 Nov
 2024 12:12:33 +0000
Received: from DB9PR04MB8409.eurprd04.prod.outlook.com
 ([fe80::1436:d8ba:25b8:1637]) by DB9PR04MB8409.eurprd04.prod.outlook.com
 ([fe80::1436:d8ba:25b8:1637%3]) with mapi id 15.20.8137.027; Mon, 11 Nov 2024
 12:12:33 +0000
From: Gaurav Jain <gaurav.jain@nxp.com>
To: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Silvano Di Ninno <silvano.dininno@nxp.com>,
	Varun Sethi <V.Sethi@nxp.com>,
	Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>,
	Sahil Malhotra <sahil.malhotra@nxp.com>,
	Nikolaus Voss <nikolaus.voss@haag-streit.com>,
	Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Gaurav Jain <gaurav.jain@nxp.com>
Subject: [PATCH] crypto: caam - use JobR's space to access page 0 regs
Date: Mon, 11 Nov 2024 17:42:14 +0530
Message-Id: <20241111121214.4013608-1-gaurav.jain@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0010.apcprd04.prod.outlook.com
 (2603:1096:4:197::11) To DB9PR04MB8409.eurprd04.prod.outlook.com
 (2603:10a6:10:244::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR04MB8409:EE_|DU2PR04MB8776:EE_
X-MS-Office365-Filtering-Correlation-Id: 20222349-4dc9-4fcf-d4a5-08dd024a1f25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|52116014|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5foiKkKTxAxkpzX5uEtKUAtYfXB2EFqQNOB71pBHU5VNlysbgQa0h5vosxbs?=
 =?us-ascii?Q?6QQkcJKLN2VF/rdB6iNb3EYqtP/gVM4mX0mmnDVNZM38XKE37uYF1Qx/LwKy?=
 =?us-ascii?Q?KRBXJtOEhVBTM3bw+Kl+FpqGg+aacEtQd3a966DWpJqWnxN7w6H5+i/GhBv2?=
 =?us-ascii?Q?RRNE6jSRwicOUa7p/3cntMhOOfxLynODopJxzxDGvFI9lZ4qX1dlXpfWU7n1?=
 =?us-ascii?Q?pYtisyzS5zrdb7ledGAGSLEtSCye8R2/PIPja5moExc1GqegM7hm+n7IEOGr?=
 =?us-ascii?Q?JW6QFg2ILUhOV5vV1VBgiH8aNB5+p90wKSS8N4BgBiBty6+pKJSoJOgBcrnH?=
 =?us-ascii?Q?PHwNnJ9VChinwS7+A1mXRMkobcAld7wsOUnHypc9xqohzNp3WheC5bOmEyJ2?=
 =?us-ascii?Q?Rb0sNo6GQbCKseuWGc64IXqvbVX9Vm9DSd1ufGvUsbv14UXbX/2Rziv65/08?=
 =?us-ascii?Q?YgdSmowM0pIaZppT+mHTBFvEwWVK3p4+Y6EdpvWaazCPQyLNw/tahgV/0O8M?=
 =?us-ascii?Q?mYjhTNvKSMwCJX50rTCPImgKbAwWBkuLr6KUP2WAr+lqWrv2VmXpBy3UusW5?=
 =?us-ascii?Q?0aAheFjiCzGifgkAsx1nPEt7Lbo+jF8r5Y7d4OcKMc2AmmWNy/M8rT6jzpKo?=
 =?us-ascii?Q?R9mHcv7SUyEprPHEhczdyFu4RuBItoSQhEIXHf3xfBJAZtg4Isv56kDAkD4U?=
 =?us-ascii?Q?hqlJXUKUHWI/ZI+K3bi7h9ntNj9cr9wIJAU4G5D2/tD/uJXDLE939eE1945Y?=
 =?us-ascii?Q?D0KdznbzkzoW/jga2u9cFfqM03ymeTDdONI2lyUlOY6TWGFyRDs3NkOI8mbz?=
 =?us-ascii?Q?5CEkfwnIlTN1DJIpGwUQv3CBjfCDNS5/B5zWhsnP6II6bjWKkTImwf+1bP0B?=
 =?us-ascii?Q?BF6VPnTruOHMr9Tz0TStoVO4FhiNIajN/2nwN/WXuIX876jmRYtmH5x+XjSd?=
 =?us-ascii?Q?9eEIoruzbwLLODMduj4FVEFgM13H57hcRPIvUL4p/CcyaNkhiqh98jrz2msI?=
 =?us-ascii?Q?tCJ6JI2r08f2WRWJtjDpYV1paXXUnMc0HLDzuUahztPHiXSj5haNg/ETVzAI?=
 =?us-ascii?Q?pmQyKpSpIpXWWE5EiX+Y8fiDjh154mISV+Rvxij46O8RA5PiEyPs5L0/v2UE?=
 =?us-ascii?Q?nr2CvkDVGciwfF9DrqvklJ904u7YDFQc7YCxPI9hT4Xl8ZJCAB3X70F0yTmd?=
 =?us-ascii?Q?ImYb50dvQv6rbIh9eA3zGIu2iexPkklT9dJd8vZxfiERLGeCpNm5//De74uw?=
 =?us-ascii?Q?0HS8gS4O4oXx7hddomxMfBnRZnucvB0F9U+gUcUZFujex7RLSEnflIiiSJNE?=
 =?us-ascii?Q?W+xvxoWhUH0I8TSGOea/Cs8TD7jawjjJhtnO0lPvPV59YzkPngR8fJ69s9x/?=
 =?us-ascii?Q?cu1mJnI2qdH+EfSj8zhGCgN/61JR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8409.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(52116014)(38350700014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?x7E0u707qk+LwL8cMWOPVDi7CFblVrJrEkJhlsPO/L57Gmicfs0Z1BlRwOKv?=
 =?us-ascii?Q?B0hQKH74jh9NNw5fwWiIF/28Rlb3vmJyAQHcZZ87mPz2YxBdc/Ng+CGwJrGB?=
 =?us-ascii?Q?2upBHNvaXiX0VFwJI7xxt3sdWqBa2TZkgP51F8RZGHudcLT6jTdtxmYojulD?=
 =?us-ascii?Q?L+SwmJT8Qfudd6cXgqlFGi4zT7P4mU0naHoeyhSQpFUiAE5EBCnLM+66vsKs?=
 =?us-ascii?Q?lEfE7oYqfHRrA7wPuPArSDYq+uHlzW2NX7F6E84dQheV1nWWyqytlAD6CW8I?=
 =?us-ascii?Q?NCnSDpq7eGr2eXH+iQJ3I0bkg1fVuFPw8GoG0aglEQk8W8vOM/5NgfS3z8Bq?=
 =?us-ascii?Q?0c3N62Wl3IZ20eifQHa/UNWEsJLhlt6XqLWkkAyfDliSVPN81IjoNZzdfeiy?=
 =?us-ascii?Q?HRCSMgq/p+hTdtAPM83BSmC079gMkBCyOxG/Z6g8tZCK/C/Zef1P58Ksyadf?=
 =?us-ascii?Q?x+jlhCGXCJToB/GdDv6jyWw/lAtH4S0tnk5yDo2psc8oPMeG1mwnRiF9RE7s?=
 =?us-ascii?Q?kirsmaCUEliPCyOy/UFHLjx8jvZUyg+QKStIbPVgiRHgKh7ga2/QzI2FoEtZ?=
 =?us-ascii?Q?BPcX15kUqfkOX4DrQzCOG2fXbqhAiaRQdPdB5tmwhDD1dSRJziJ+qlrrKwOT?=
 =?us-ascii?Q?EaitG+GU6/XhtySa93mfj3TGeA9+zNIWagkLjL0kgLlKN2CixlV3Z396soe5?=
 =?us-ascii?Q?csqFrDRXY+zSWQvMxuknA8tRE/H6Bxcxr5s26uHqNXnaUpuoZYf4dbqXzZER?=
 =?us-ascii?Q?xFWiXiOwH5Etw6vF+qKuJ1hCxpMuw2wbBvdzwkL9tgzHR4ijGep/OloX69yx?=
 =?us-ascii?Q?RaAKa0A41c64mSqKsGl69NbPPMj+TGRUge1C/9ObSJzIPxKnQjiLzSwQrOgF?=
 =?us-ascii?Q?qbnQe9/MpKD6feWbfbLnvJcpS33dlyN9EwlUlYScC1zOShV1ei8KFmYkTBPe?=
 =?us-ascii?Q?EgDqo7ncF8npUX+nwEkK4x62Lyd6bARz6wqE+3hE9F5fiZhDJXdgIB8eZuPp?=
 =?us-ascii?Q?5n4jo5fabqbbWEAspPezYebnBwYIKBqKbdB4wHoJdYu5VgFEypLOxurkUGyP?=
 =?us-ascii?Q?AguQBq1uVqhoAMyMtWKz4KB/duFTQyI7pZX/US2v41aMq4AOn9FWPThLX/R2?=
 =?us-ascii?Q?XNUbzHBX90BXBwMWmBTAADFBBy76792ytIvY5rbYa6XB6yEoMX69t3yaVOBF?=
 =?us-ascii?Q?miVlLlEmJPlMGEUZdModDoVkb8FIZaXFNLiAMxu/Om5M7YMkqkD7kQxyprUc?=
 =?us-ascii?Q?DCcdQqE9fvNI1i/HhoWovckkxAftEUjX/Mdn6taSSs2UDgg/dZ+Yts6LQrzW?=
 =?us-ascii?Q?n0COzONB7HK8LHNeg38epQHYdfsF1SaObyy44IXjGPeKVBHOOriytOW/BS3v?=
 =?us-ascii?Q?fLOM6x67nypF2w1B/MAbER7n+KupkxFsJUfjxk3KSymMjaLIsz19GUjHTARO?=
 =?us-ascii?Q?hSQaoOnZFHaV4fPr8Pr5hlslatDCofb6qaM3S47D9W4vtnVInsrjLYZcQw7D?=
 =?us-ascii?Q?T5pb197HWxCyVXIRftt7MxN/RvxKEf4ydm6NBFawBEB8mzV8ERwv0XSM8OMi?=
 =?us-ascii?Q?44VHIhpJuprJdW0RD4+OLLVM+2Cj6JFPKLvrvyuL?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20222349-4dc9-4fcf-d4a5-08dd024a1f25
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8409.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 12:12:33.3431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QJ+3/vbrPW5YwwCrLKTBi24r+07wFzbr/SwebZ1ZHBiF2yNIGKt3vBjZzB5jvPQcnmXISnJW6qmBlRD/+FUK5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8776

Access to controller region is not permitted.
use JobR's register space to access page 0 registers.

Fixes: 6a83830f649a ("crypto: caam - warn if blob_gen key is insecure")
Signed-off-by: Gaurav Jain <gaurav.jain@nxp.com>
---
 drivers/crypto/caam/blob_gen.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/blob_gen.c b/drivers/crypto/caam/blob_gen.c
index 87781c1534ee..079a22cc9f02 100644
--- a/drivers/crypto/caam/blob_gen.c
+++ b/drivers/crypto/caam/blob_gen.c
@@ -2,6 +2,7 @@
 /*
  * Copyright (C) 2015 Pengutronix, Steffen Trumtrar <kernel@pengutronix.de>
  * Copyright (C) 2021 Pengutronix, Ahmad Fatoum <kernel@pengutronix.de>
+ * Copyright 2024 NXP
  */
 
 #define pr_fmt(fmt) "caam blob_gen: " fmt
@@ -104,7 +105,7 @@ int caam_process_blob(struct caam_blob_priv *priv,
 	}
 
 	ctrlpriv = dev_get_drvdata(jrdev->parent);
-	moo = FIELD_GET(CSTA_MOO, rd_reg32(&ctrlpriv->ctrl->perfmon.status));
+	moo = FIELD_GET(CSTA_MOO, rd_reg32(&ctrlpriv->jr[0]->perfmon.status));
 	if (moo != CSTA_MOO_SECURE && moo != CSTA_MOO_TRUSTED)
 		dev_warn(jrdev,
 			 "using insecure test key, enable HAB to use unique device key!\n");
-- 
2.25.1

