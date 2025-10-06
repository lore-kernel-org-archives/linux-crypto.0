Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011061.outbound.protection.outlook.com [52.101.70.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFA125742C;
	Mon,  6 Oct 2025 07:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759735113; cv=fail; b=WoEXxpN4G9Om9B/Qih+RkSbubDyojhR5o9PmbByJp6cxma4yW92i4gRLCLM9ipDsUHFk0ZaPEPu5RWaH4bb3NtRkGFITKZOIlrNhj9LhLV2ofK8guHEBKihT2kP3p0jxjNnL855cJd6HushfB7p/2BhJ1LQrtdKnK68FBuXuo5A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759735113; c=relaxed/simple;
	bh=QHNBaQ4Fl2/pgR8ZDjJtRsVUvz5wp0Te6J3tRiGBR8c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FWxD79+c8CYvH/DA2wGT3E89XdxdYm8S0K+ge2r9PlwE3EZhHkbyshgUji9lqC9+fT7ZJHCs6INxzFPueKhk9X7sM8dOHXhcayKFpzaHRBpOR8rD3e8seU6Q86WLBBdkbd1Wnm/9aR97fWFnLj2QxRcxsiblj4PdZeQfHB+HI+0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=oKZ2pRba; arc=fail smtp.client-ip=52.101.70.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="oKZ2pRba"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aAo7HnN9n2rQcnVJWn6P6OlNgdESzL3I2khu1QPyrHqGzvp8cIkodsCoxT48xGNpvznoKidJd8JTx9lvJtpqk+dt9cADNAhcUw6L95TvyTU+EjLTkUcS/hOHwNj80X+j/K9SntHMvONkIZ/5/9h4ms31skbm4osb1i0hqNLIMpaIWRYi8zCtithDkzSOGY68jfGPuFRyqAoEUJMDq9y0YduxJVaZLnrFu9bDPbQtObbffe7xBgw9uv+6q+9LQwIeduv9V5LJRidU/41h8sscQeiRMy47z/5ijhiZ3e1DYeKbm46HOI7diUYSd0SjLI2vK/z3ulIKje13XgYgCdI/Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gdRs5uQWVRLEuWZTZ2F1G7Rf0afj9MNEMXndcZr6OHA=;
 b=Co41YiGBwNTNph7D3QEu5rEATyAgXY27q6WG1GkbN9BYfU8lSeO1y9ZZhX8pgCZjPYrhGqocgIYWKUR0U45FGL3bVWv1MZQWJaNyHg5LcP+W1LcwA6EKZC3Ss59zNoBqwW8ft26Li1PBCuU4yTu4S997L81aWn/EtqzcnELPiWlhOBUgM9ao/HLatyhxcU9rfAkx62cVwNc3xve8jOVqCPqMe+uu32Nj8kzvwbwcV7kLfRq0B/WRrjvwh/45nOhSvbc+G6tmuvgCXky5p3ZlefSRPXQhBtGQeJ/nucJLbEmyGq4F2ihJTrqw7Qk32qbp2Dzq0drLqOlMjxAwoov+4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gdRs5uQWVRLEuWZTZ2F1G7Rf0afj9MNEMXndcZr6OHA=;
 b=oKZ2pRba+WM7yPCHKWksBAZKLoUMbrOFaP5CkM8Lpekz/dDMtwCZmUoas86t0jMDmUFm0DQEYkC/aLj+twsWrZdinqARoFZcP70EFRNbINpFhpXsBMaHGiNoeoO78/8pxir0n+UqEKJOxtx4X1U/vjJM5LMSxyxHivbsRGt4ilKBHNHtyoeTKLgG2CkQpvFiLRJSiop/QkhzV1YBbXtqnLV4DDzcH2YzZXF1E3QagZz1h1J7FwE9jioMFV+ai4hMssdWNjOipS1KIK1ZI4KCyaNCaSBVYV+2IwGnlDLiQiQ0fwHZ18WUWrF+FOvFMtfPujC1D8b+Xf0/GJRn5wF31Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB8301.eurprd04.prod.outlook.com (2603:10a6:102:1c5::16)
 by DU4PR04MB10864.eurprd04.prod.outlook.com (2603:10a6:10:589::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Mon, 6 Oct
 2025 07:18:22 +0000
Received: from PAXPR04MB8301.eurprd04.prod.outlook.com
 ([fe80::85de:cf79:69cf:4833]) by PAXPR04MB8301.eurprd04.prod.outlook.com
 ([fe80::85de:cf79:69cf:4833%4]) with mapi id 15.20.9182.017; Mon, 6 Oct 2025
 07:18:22 +0000
From: meenakshi.aggarwal@nxp.com
To: horia.geanta@nxp.com,
	V.sethi@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
Subject: [PATCH 2/3] KEYS: trusted: caam based protected key
Date: Mon,  6 Oct 2025 09:17:52 +0200
Message-Id: <20251006071753.3073538-3-meenakshi.aggarwal@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251006071753.3073538-1-meenakshi.aggarwal@nxp.com>
References: <20251006071753.3073538-1-meenakshi.aggarwal@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P192CA0003.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::13) To PAXPR04MB8301.eurprd04.prod.outlook.com
 (2603:10a6:102:1c5::16)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB8301:EE_|DU4PR04MB10864:EE_
X-MS-Office365-Filtering-Correlation-Id: 009ffddb-91a0-4ccb-32b7-08de04a8888c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|19092799006|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sjNq6qC6EaWn6dtHxOMfVocb312rzaP/r96QgFWCx/8SoKCL/iBvxwHUL4CI?=
 =?us-ascii?Q?bJJF3ezcFMZSum238Jc4vaO4NK4WN56Mqu0VSUqdVEkcdG3HAswPVb/WM9t9?=
 =?us-ascii?Q?dQI3KXH299JW0Zm9RqnpIV7YguY/tlHTQULDuHH9A/O2PcMFla8MNup4H3gH?=
 =?us-ascii?Q?U3sfLS/B/u4+I2zahnngighnV7CVbNhEHKrcKcihZsSjfPZsY5apr5yY4Wht?=
 =?us-ascii?Q?g8B5tYSz2rtMx3sjMr48spFVF0IOle3wVgkGMvNPkwr2rI9uU6ZRkLVmXqOh?=
 =?us-ascii?Q?RWHfxkPwJe+uwIT0tz/PNa4aPhOsBiIpgYL1uHHi4+PHfn0mX6nznXGxr0/R?=
 =?us-ascii?Q?XmhX5xLhV0n6AOF/eLw2ICJtrTXGco6dXJSkNovDPja2vG5nm+GaczrGfXc+?=
 =?us-ascii?Q?ySgIEyYK9sKja3i+VGaay8SXmw0A61ZDYMkyzHZI+OntFOGghkmA0ntmAkWm?=
 =?us-ascii?Q?/JnngOADqOZ+l64ZnGCzYmALXovY/Y3t4db4hQY7QSQk8ahE80CHk+Of87/Z?=
 =?us-ascii?Q?edrcG409cHoyg2bYEQ3jnNQu/hRydDyj4J05TA+o09xhrehUGs+/p497Kr0y?=
 =?us-ascii?Q?WEQHDigbjTpApf6ircjwN51AEjNudJHCpNgvA7hZ9yQ3CBvNp97HjWtG/0hk?=
 =?us-ascii?Q?xj6HzUvEzXpJVuBhykG5Fr3DAhvhMsI8jBMDXs5Z6qCHY0xWPU5f3CLukxP4?=
 =?us-ascii?Q?Z1AcgsETjLIlsdohR6WsgGVRl0KPYIIiQhCDKYhbe+dbHSyPBR/RO6JrOXMV?=
 =?us-ascii?Q?q/LiyqcDH5SHQkvarh4MVCLTj0j93QsyuVNPWlzq/W+x8xY/ubv9c5MuzUMA?=
 =?us-ascii?Q?0FJ3S4MTVe57GCas3Zpb3OMaGp8Z6vNWvKZPzQWyEERNwsNkSZhWpPwkfB2A?=
 =?us-ascii?Q?UFpyBpXjzpd9SxJ26MZ0WJ1qAiQbi3UgQXWj7pdmVvA1DcJ/WIrvxvPTFxpZ?=
 =?us-ascii?Q?4NpLNwixli8SKKiH7NWEXkqeMLUl50MH2gAGwmk9dr04pym+J62r+vowmu/U?=
 =?us-ascii?Q?inF97ZrFv0eUWVzHY7Hc0IIhpD85drhv8qfnVb8+BeOOh9JI8fFK6dP7usJY?=
 =?us-ascii?Q?lFDcQk2q4oMy4uMypr0frkltHkpWPfb7ePRc7S+OMltVv2IkpFTebDheeHvM?=
 =?us-ascii?Q?vFL6cJmWeLfgRyXve/8Wgzrh3QB0FDBHLeZu2N22Iq4mPpzhHkSxuRXGUOj4?=
 =?us-ascii?Q?ot0NarduEFtQ1WAIDqW5zw1GWiBEp6NC2xXQveR/ge6E8jSEttQStflOuDfA?=
 =?us-ascii?Q?vjEqRjv+adVL1fAFXvvyouvHSmkiiOWZI4j2sz0cr7Wn44lByyS+9Bkr6tyc?=
 =?us-ascii?Q?pjpYjZR8hcdq9fdHl0L0KAxXvU/7cv4omenTfBgeTwDZQNx3nVZBq914zuLX?=
 =?us-ascii?Q?r6ynmyFuRh7bhesZsEANLiuBR9PqvMgzFYS6MgGUTcbLXKsrtSmuzV21orFH?=
 =?us-ascii?Q?4TL/RlQmSYSpbn9VpmT5jHr1BcCeDNx6ZqWq2GNZwan+SdMrmG1rTI0/aqxg?=
 =?us-ascii?Q?LJnnQez/0VIKfaAvbgPbCu+HnEfY5ijWXmM5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB8301.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(19092799006)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sacFwuvKBN5YvIs/QoAjd2mIGBhaMJMCNhNtRfIlnfHCeEdWplR8dq8HyWaw?=
 =?us-ascii?Q?YTzyfE9XEuKNT4S08DO+VstF8zZJJOpQF5AXaW0FPoDXUwneTx4jVYx72VZh?=
 =?us-ascii?Q?GTrvswsLXwmBOahnro4xA32NRvpuEQKNnHFpasBglixi2XBWDdNeCoOImGOd?=
 =?us-ascii?Q?nGSwc8Zy6hBkrV0YfAL65juQ82jNhqigNQWIkm7lBcYenKKTlwcQx4jN6S8N?=
 =?us-ascii?Q?JXgw0ZbMur8ULHKKt5gSJj5ESqylBPVWS6tj2xtX3EyPoVujhtZrpvNleItU?=
 =?us-ascii?Q?3WOGuKfn25XzRiJ7OaAGf8VUK0jmRtfEDiqjM/CF7aAPeWZeqPbMJxmE/2Tn?=
 =?us-ascii?Q?wjxpTssU9yQCtiuB992hMgqk3mVrTekbHj6BJXgYuSCdJ4VQLPDiHgwRxUN1?=
 =?us-ascii?Q?gkcOp4amwQ0Npqobd/FnauOyevX1QtiHEW7JL6LNG7Ugv8ZkqbWfKMadqk9h?=
 =?us-ascii?Q?4A8tKSLnw3SpZ0z69j4ft8spPSz140OWhtNBIjnoirFl7xvwkciH2YPVAENU?=
 =?us-ascii?Q?A32rXzngSDdbpkMgROmyg8qfLbItMa5n8UA8OaIOfP3/dF9p9vl2w6FTJmug?=
 =?us-ascii?Q?07uRIlYqY35yEuhO/OMXoRdhZm8wAnSeK6rRGsQOYKS/gFGpai0O4D3MYOkI?=
 =?us-ascii?Q?09McqMoClTWFXL7EGpz6zy8Gf/q1V9htiL52K5MBHwKnj2i2CKbtFjYvVs88?=
 =?us-ascii?Q?zWO5KZSDskeY+iBhPXS2IA8JohIu0y9Olh6uQgEmBfnUvun4jUmZezg9vKaV?=
 =?us-ascii?Q?uEPxR3WuOl4qrXNZ6TR/QddEMqXyPqD784c+kb91Zgk7I/VZqxVZejINJ5SG?=
 =?us-ascii?Q?zPbW/GKt0OP6LnEw6WdhTpWMJsjG3Cxnyh/q/0DILXzYigzBDf4UdnuetPbl?=
 =?us-ascii?Q?N7cjVcqEvD8JX3q0/Fn9r2mfQq6rQ7Jdu2ioTWmyZ2DVjO9IR6BU9Nn6uRO1?=
 =?us-ascii?Q?RJNybftXHcX0TCCz9T4/qpilGag2J6Td4h71KE6pDz2qkZ5ggkq4RQ5xZsWS?=
 =?us-ascii?Q?Yhu28lfOEN4c0OTVMKq3jxPNBbKVHO79km/Hi7dStG/vOzfCoJf77xExBTZx?=
 =?us-ascii?Q?ihix8uShLAFY+qcCP4TX1WkN7kxvguybBDppt/W5r9w39kYikANeLn3BGY9v?=
 =?us-ascii?Q?5NHHmJlOgYtem+7uQ66iuSz7fV7izYXpmWnPDNKBtKB/JBg3VdZl8qZ1YmvI?=
 =?us-ascii?Q?OK1B/rjGgwpuV0wDGy39XKDxBhNio5o/iVha46VSlUSc+MzmIGILmizCpccJ?=
 =?us-ascii?Q?3Wm4tbCRJm3TPPSjJ2ap/gLVFOcDiJ1VqReZ06GM5sthhTOMFSAfuYYlI2oh?=
 =?us-ascii?Q?AlzwR3wA3bL5j98Qbd4gHeJmfP8Zuhx0sQTdBET1kxqorUH4w1NcX7vjBjm8?=
 =?us-ascii?Q?rx+IXDy3S1m96u5ZwvBCHadULXLUHzQslhYHlq73YG0Pxdxoom0zGE3ceMYb?=
 =?us-ascii?Q?U7OUCtB4/uDCWdPzykcU2rAf0UFbKCf3kMskwIPnjoYRzCV3I+4ZhbO2TJDc?=
 =?us-ascii?Q?2yccKdfOLTLJ1WZ9RG2N/s3Px6+SFMdtYuzhfpmy9SwfmMekLsK7gFHA03Zh?=
 =?us-ascii?Q?+iKg9/hXFIGxKDBCOSDGjNyCQ9sqnVd9I3anA+v3Op0OBiHvoU97RARDg2GF?=
 =?us-ascii?Q?/A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 009ffddb-91a0-4ccb-32b7-08de04a8888c
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB8301.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2025 07:18:22.7120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8dWbnuzGYOlTxAb1ppBQb/Shgh7GYAHkyAMtm24CoFHoxaECp1KGulqmerMHFhu96yvtXS+OwzimG73b8eIO0QlvMFbUfQzCLPFieTrRaeM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR04MB10864

From: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>

- CAAM supports two types of protected keys:
  -- Plain key encrypted with ECB
  -- Plain key encrypted with CCM
  Due to robustness, default encryption used for protected key is CCM.

- Generate protected key blob and add it to trusted key payload.
  This is done as part of sealing operation, which is triggered
  when below two operations are requested:
  -- new key generation
  -- load key,

Signed-off-by: Pankaj Gupta <pankaj.gupta@nxp.com>
Signed-off-by: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
---
 drivers/crypto/caam/blob_gen.c            |  86 +++++++++++++----
 drivers/crypto/caam/desc.h                |   9 +-
 include/soc/fsl/caam-blob.h               |  26 ++++++
 security/keys/trusted-keys/trusted_caam.c | 108 ++++++++++++++++++++++
 4 files changed, 212 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/caam/blob_gen.c b/drivers/crypto/caam/blob_gen.c
index 079a22cc9f02..c18dbac56493 100644
--- a/drivers/crypto/caam/blob_gen.c
+++ b/drivers/crypto/caam/blob_gen.c
@@ -2,13 +2,14 @@
 /*
  * Copyright (C) 2015 Pengutronix, Steffen Trumtrar <kernel@pengutronix.de>
  * Copyright (C) 2021 Pengutronix, Ahmad Fatoum <kernel@pengutronix.de>
- * Copyright 2024 NXP
+ * Copyright 2024-2025 NXP
  */
 
 #define pr_fmt(fmt) "caam blob_gen: " fmt
 
 #include <linux/bitfield.h>
 #include <linux/device.h>
+#include <keys/trusted-type.h>
 #include <soc/fsl/caam-blob.h>
 
 #include "compat.h"
@@ -60,18 +61,27 @@ static void caam_blob_job_done(struct device *dev, u32 *desc, u32 err, void *con
 	complete(&res->completion);
 }
 
+static u32 check_caam_state(struct device *jrdev)
+{
+	const struct caam_drv_private *ctrlpriv;
+
+	ctrlpriv = dev_get_drvdata(jrdev->parent);
+	return FIELD_GET(CSTA_MOO, rd_reg32(&ctrlpriv->jr[0]->perfmon.status));
+}
+
 int caam_process_blob(struct caam_blob_priv *priv,
 		      struct caam_blob_info *info, bool encap)
 {
-	const struct caam_drv_private *ctrlpriv;
 	struct caam_blob_job_result testres;
 	struct device *jrdev = &priv->jrdev;
 	dma_addr_t dma_in, dma_out;
 	int op = OP_PCLID_BLOB;
+	int hwbk_caam_ovhd = 0;
 	size_t output_len;
 	u32 *desc;
 	u32 moo;
 	int ret;
+	int len;
 
 	if (info->key_mod_len > CAAM_BLOB_KEYMOD_LENGTH)
 		return -EINVAL;
@@ -82,14 +92,29 @@ int caam_process_blob(struct caam_blob_priv *priv,
 	} else {
 		op |= OP_TYPE_DECAP_PROTOCOL;
 		output_len = info->input_len - CAAM_BLOB_OVERHEAD;
+		info->output_len = output_len;
+	}
+
+	if (encap && info->pkey_info.is_pkey) {
+		op |= OP_PCL_BLOB_BLACK;
+		if (info->pkey_info.key_enc_algo == CAAM_ENC_ALGO_CCM) {
+			op |= OP_PCL_BLOB_EKT;
+			hwbk_caam_ovhd = CAAM_CCM_OVERHEAD;
+		}
+		if ((info->input_len + hwbk_caam_ovhd) > MAX_KEY_SIZE)
+			return -EINVAL;
+
+		len = info->input_len + hwbk_caam_ovhd;
+	} else {
+		len = info->input_len;
 	}
 
 	desc = kzalloc(CAAM_BLOB_DESC_BYTES_MAX, GFP_KERNEL);
 	if (!desc)
 		return -ENOMEM;
 
-	dma_in = dma_map_single(jrdev, info->input, info->input_len,
-				DMA_TO_DEVICE);
+	dma_in = dma_map_single(jrdev, info->input, len,
+				encap ? DMA_BIDIRECTIONAL : DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, dma_in)) {
 		dev_err(jrdev, "unable to map input DMA buffer\n");
 		ret = -ENOMEM;
@@ -104,8 +129,7 @@ int caam_process_blob(struct caam_blob_priv *priv,
 		goto out_unmap_in;
 	}
 
-	ctrlpriv = dev_get_drvdata(jrdev->parent);
-	moo = FIELD_GET(CSTA_MOO, rd_reg32(&ctrlpriv->jr[0]->perfmon.status));
+	moo = check_caam_state(jrdev);
 	if (moo != CSTA_MOO_SECURE && moo != CSTA_MOO_TRUSTED)
 		dev_warn(jrdev,
 			 "using insecure test key, enable HAB to use unique device key!\n");
@@ -117,18 +141,48 @@ int caam_process_blob(struct caam_blob_priv *priv,
 	 * Class 1 Context DWords 0+1+2+3. The random BK is stored in the
 	 * Class 1 Key Register. Operation Mode is set to AES-CCM.
 	 */
-
 	init_job_desc(desc, 0);
+
+	if (encap && info->pkey_info.is_pkey) {
+		/*!1. key command used to load class 1 key register
+		 *    from input plain key.
+		 */
+		append_key(desc, dma_in, info->input_len,
+				CLASS_1 | KEY_DEST_CLASS_REG);
+		/*!2. Fifostore to store protected key from class 1 key register. */
+		if (info->pkey_info.key_enc_algo == CAAM_ENC_ALGO_CCM) {
+			append_fifo_store(desc, dma_in, info->input_len,
+					  LDST_CLASS_1_CCB |
+					  FIFOST_TYPE_KEY_CCM_JKEK);
+		} else {
+			append_fifo_store(desc, dma_in, info->input_len,
+					  LDST_CLASS_1_CCB |
+					  FIFOST_TYPE_KEY_KEK);
+		}
+		/*
+		 * JUMP_OFFSET specifies the offset of the JUMP target from
+		 * the JUMP command's address in the descriptor buffer.
+		 */
+		append_jump(desc, JUMP_COND_NOP | BIT(0) << JUMP_OFFSET_SHIFT);
+	}
+
+	/*!3. Load class 2 key with key modifier. */
 	append_key_as_imm(desc, info->key_mod, info->key_mod_len,
-			  info->key_mod_len, CLASS_2 | KEY_DEST_CLASS_REG);
-	append_seq_in_ptr_intlen(desc, dma_in, info->input_len, 0);
-	append_seq_out_ptr_intlen(desc, dma_out, output_len, 0);
+			info->key_mod_len, CLASS_2 | KEY_DEST_CLASS_REG);
+
+	/*!4. SEQ IN PTR Command. */
+	append_seq_in_ptr(desc, dma_in, info->input_len, 0);
+
+	/*!5. SEQ OUT PTR Command. */
+	append_seq_out_ptr(desc, dma_out, output_len, 0);
+
+	/*!6. Blob encapsulation/decapsulation PROTOCOL Command. */
 	append_operation(desc, op);
 
-	print_hex_dump_debug("data@"__stringify(__LINE__)": ",
+	print_hex_dump_debug("data@" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 1, info->input,
-			     info->input_len, false);
-	print_hex_dump_debug("jobdesc@"__stringify(__LINE__)": ",
+			     len, false);
+	print_hex_dump_debug("jobdesc@" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 1, desc,
 			     desc_bytes(desc), false);
 
@@ -139,7 +193,7 @@ int caam_process_blob(struct caam_blob_priv *priv,
 	if (ret == -EINPROGRESS) {
 		wait_for_completion(&testres.completion);
 		ret = testres.err;
-		print_hex_dump_debug("output@"__stringify(__LINE__)": ",
+		print_hex_dump_debug("output@" __stringify(__LINE__)": ",
 				     DUMP_PREFIX_ADDRESS, 16, 1, info->output,
 				     output_len, false);
 	}
@@ -149,10 +203,10 @@ int caam_process_blob(struct caam_blob_priv *priv,
 
 	dma_unmap_single(jrdev, dma_out, output_len, DMA_FROM_DEVICE);
 out_unmap_in:
-	dma_unmap_single(jrdev, dma_in, info->input_len, DMA_TO_DEVICE);
+	dma_unmap_single(jrdev, dma_in, len,
+			 encap ? DMA_BIDIRECTIONAL : DMA_TO_DEVICE);
 out_free:
 	kfree(desc);
-
 	return ret;
 }
 EXPORT_SYMBOL(caam_process_blob);
diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index e13470901586..c28e94fcb8c7 100644
--- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/desc.h
@@ -4,7 +4,7 @@
  * Definitions to support CAAM descriptor instruction generation
  *
  * Copyright 2008-2011 Freescale Semiconductor, Inc.
- * Copyright 2018 NXP
+ * Copyright 2018, 2025 NXP
  */
 
 #ifndef DESC_H
@@ -162,6 +162,7 @@
  * Enhanced Encryption of Key
  */
 #define KEY_EKT			0x00100000
+#define KEY_EKT_OFFSET		20
 
 /*
  * Encrypted with Trusted Key
@@ -403,6 +404,7 @@
 #define FIFOST_TYPE_PKHA_N	 (0x08 << FIFOST_TYPE_SHIFT)
 #define FIFOST_TYPE_PKHA_A	 (0x0c << FIFOST_TYPE_SHIFT)
 #define FIFOST_TYPE_PKHA_B	 (0x0d << FIFOST_TYPE_SHIFT)
+#define FIFOST_TYPE_KEY_CCM_JKEK (0x14 << FIFOST_TYPE_SHIFT)
 #define FIFOST_TYPE_AF_SBOX_JKEK (0x20 << FIFOST_TYPE_SHIFT)
 #define FIFOST_TYPE_AF_SBOX_TKEK (0x21 << FIFOST_TYPE_SHIFT)
 #define FIFOST_TYPE_PKHA_E_JKEK	 (0x22 << FIFOST_TYPE_SHIFT)
@@ -1001,6 +1003,11 @@
 #define OP_PCL_TLS12_AES_256_CBC_SHA384		 0xff63
 #define OP_PCL_TLS12_AES_256_CBC_SHA512		 0xff65
 
+/* Blob protocol protinfo bits */
+
+#define OP_PCL_BLOB_BLACK                        0x0004
+#define OP_PCL_BLOB_EKT                          0x0100
+
 /* For DTLS - OP_PCLID_DTLS */
 
 #define OP_PCL_DTLS_AES_128_CBC_SHA		 0x002f
diff --git a/include/soc/fsl/caam-blob.h b/include/soc/fsl/caam-blob.h
index 937cac52f36d..922f7ec3e231 100644
--- a/include/soc/fsl/caam-blob.h
+++ b/include/soc/fsl/caam-blob.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Copyright (C) 2020 Pengutronix, Ahmad Fatoum <kernel@pengutronix.de>
+ * Copyright 2024-2025 NXP
  */
 
 #ifndef __CAAM_BLOB_GEN
@@ -12,11 +13,34 @@
 #define CAAM_BLOB_KEYMOD_LENGTH		16
 #define CAAM_BLOB_OVERHEAD		(32 + 16)
 #define CAAM_BLOB_MAX_LEN		4096
+#define CAAM_ENC_ALGO_CCM		0x1
+#define CAAM_ENC_ALGO_ECB		0x2
+#define CAAM_NONCE_SIZE			6
+#define CAAM_ICV_SIZE			6
+#define CAAM_CCM_OVERHEAD		(CAAM_NONCE_SIZE + CAAM_ICV_SIZE)
 
 struct caam_blob_priv;
 
+/**
+ * struct caam_pkey_info - information for CAAM protected key
+ * @is_pkey:		flag to identify, if the key is protected.
+ * @key_enc_algo:	identifies the algorithm, ccm or ecb
+ * @plain_key_sz:	size of plain key.
+ * @key_buf:		contains key data
+ */
+struct caam_pkey_info {
+	u8  is_pkey;
+	u8  key_enc_algo;
+	u16 plain_key_sz;
+	u8 key_buf[];
+} __packed;
+
+/* sizeof struct caam_pkey_info */
+#define CAAM_PKEY_HEADER		4
+
 /**
  * struct caam_blob_info - information for CAAM blobbing
+ * @pkey_info:	 pointer to keep protected key information
  * @input:       pointer to input buffer (must be DMAable)
  * @input_len:   length of @input buffer in bytes.
  * @output:      pointer to output buffer (must be DMAable)
@@ -26,6 +50,8 @@ struct caam_blob_priv;
  *	         May not exceed %CAAM_BLOB_KEYMOD_LENGTH
  */
 struct caam_blob_info {
+	struct caam_pkey_info pkey_info;
+
 	void *input;
 	size_t input_len;
 
diff --git a/security/keys/trusted-keys/trusted_caam.c b/security/keys/trusted-keys/trusted_caam.c
index e3415c520c0a..090099d1b04d 100644
--- a/security/keys/trusted-keys/trusted_caam.c
+++ b/security/keys/trusted-keys/trusted_caam.c
@@ -1,12 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * Copyright (C) 2021 Pengutronix, Ahmad Fatoum <kernel@pengutronix.de>
+ * Copyright 2025 NXP
  */
 
 #include <keys/trusted_caam.h>
 #include <keys/trusted-type.h>
 #include <linux/build_bug.h>
 #include <linux/key-type.h>
+#include <linux/parser.h>
 #include <soc/fsl/caam-blob.h>
 
 static struct caam_blob_priv *blobifier;
@@ -16,6 +18,77 @@ static struct caam_blob_priv *blobifier;
 static_assert(MAX_KEY_SIZE + CAAM_BLOB_OVERHEAD <= CAAM_BLOB_MAX_LEN);
 static_assert(MAX_BLOB_SIZE <= CAAM_BLOB_MAX_LEN);
 
+enum {
+	opt_err,
+	opt_key_enc_algo,
+};
+
+static const match_table_t key_tokens = {
+	{opt_key_enc_algo, "key_enc_algo=%s"},
+	{opt_err, NULL}
+};
+
+#ifdef CAAM_DEBUG
+static inline void dump_options(struct caam_pkey_info pkey_info)
+{
+	pr_info("key encryption algo %d\n", pkey_info.key_enc_algo);
+}
+#else
+static inline void dump_options(struct caam_pkey_info pkey_info)
+{
+}
+#endif
+
+static int get_pkey_options(char *c,
+			    struct caam_pkey_info *pkey_info)
+{
+	substring_t args[MAX_OPT_ARGS];
+	unsigned long token_mask = 0;
+	u16 key_enc_algo;
+	char *p = c;
+	int token;
+	int res;
+
+	if (!c)
+		return 0;
+
+	while ((p = strsep(&c, " \t"))) {
+		if (*p == '\0' || *p == ' ' || *p == '\t')
+			continue;
+		token = match_token(p, key_tokens, args);
+		if (test_and_set_bit(token, &token_mask))
+			return -EINVAL;
+
+		switch (token) {
+		case opt_key_enc_algo:
+			res = kstrtou16(args[0].from, 16, &key_enc_algo);
+			if (res < 0)
+				return -EINVAL;
+			pkey_info->key_enc_algo = key_enc_algo;
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+static bool is_key_pkey(char **datablob)
+{
+	char *c = NULL;
+
+	do {
+		/* Second argument onwards,
+		 * determine if tied to HW
+		 */
+		c = strsep(datablob, " \t");
+		if (c && (strcmp(c, "pk") == 0))
+			return true;
+	} while (c);
+
+	return false;
+}
+
 static int trusted_caam_seal(struct trusted_key_payload *p, char *datablob)
 {
 	int ret;
@@ -25,11 +98,30 @@ static int trusted_caam_seal(struct trusted_key_payload *p, char *datablob)
 		.key_mod = KEYMOD, .key_mod_len = sizeof(KEYMOD) - 1,
 	};
 
+	/*
+	 * If it is to be treated as protected key,
+	 * read next arguments too.
+	 */
+	if (is_key_pkey(&datablob)) {
+		info.pkey_info.plain_key_sz = p->key_len;
+		info.pkey_info.is_pkey = 1;
+		ret = get_pkey_options(datablob, &info.pkey_info);
+		if (ret < 0)
+			return 0;
+		dump_options(info.pkey_info);
+	}
+
 	ret = caam_encap_blob(blobifier, &info);
 	if (ret)
 		return ret;
 
 	p->blob_len = info.output_len;
+	if (info.pkey_info.is_pkey) {
+		p->key_len = p->blob_len + sizeof(struct caam_pkey_info);
+		memcpy(p->key, &info.pkey_info, sizeof(struct caam_pkey_info));
+		memcpy(p->key + sizeof(struct caam_pkey_info), p->blob, p->blob_len);
+	}
+
 	return 0;
 }
 
@@ -42,11 +134,27 @@ static int trusted_caam_unseal(struct trusted_key_payload *p, char *datablob)
 		.key_mod = KEYMOD,  .key_mod_len = sizeof(KEYMOD) - 1,
 	};
 
+	if (is_key_pkey(&datablob)) {
+		info.pkey_info.plain_key_sz = p->blob_len - CAAM_BLOB_OVERHEAD;
+		info.pkey_info.is_pkey = 1;
+		ret = get_pkey_options(datablob, &info.pkey_info);
+		if (ret < 0)
+			return 0;
+		dump_options(info.pkey_info);
+
+		p->key_len = p->blob_len + sizeof(struct caam_pkey_info);
+		memcpy(p->key, &info.pkey_info, sizeof(struct caam_pkey_info));
+		memcpy(p->key + sizeof(struct caam_pkey_info), p->blob, p->blob_len);
+
+		return 0;
+	}
+
 	ret = caam_decap_blob(blobifier, &info);
 	if (ret)
 		return ret;
 
 	p->key_len = info.output_len;
+
 	return 0;
 }
 
-- 
2.25.1

