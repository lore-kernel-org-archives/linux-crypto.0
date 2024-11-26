Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2043.outbound.protection.outlook.com [40.107.22.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9141A260;
	Tue, 26 Nov 2024 06:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732603618; cv=fail; b=BLQmZAN40piA87uSQ/B97UBHqrCE47WtGQFMusHJoKw2zxeIw9zDXC/X9rzN36aDkGmitPP8M7+pea85n5ZBZMU/5YAi/B8YUEeuwBJ13rg0QQdEJnR9M6OlR7yOchnRQmTSqpKGiX65U6o5yyhh4bMz5oupbD4ZWpkE8G14JFM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732603618; c=relaxed/simple;
	bh=as8hbax+gIKz7XMde+3qdDa0aRN4V4JLpGY4ChUlwgA=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=FS1vCC0p/9vYmWK8RHC4KpNLdMVv5bwgGxa0AaDTxl+k+NTMshAOfBmHku/jCkWtJHMRqYZRXtViiVnEBMDrcx3RVJaLD7IRVD+Z5kKNzpU1FshGn4iIH7ZFVdb+OHg5/27r8QEI21BRjouh9D3dpNF/GonKuWFbbcegbKQbKOQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=LdSzjXiJ; arc=fail smtp.client-ip=40.107.22.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="LdSzjXiJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CBbARKpBpO2zrxG34oyTgP08cljK2j75yCo9KKaYfuzGhyN+YewLgGzuD4CQsO7C3nHl74dyYHmCnzQyy+hmb3Z7IC1jck/OZkQsuzzQE9QA7Mx5fuuYtw381YlGLq2iAFE8ss3xZdd6jjnhXms8bLSHXTMNZNzC3SRI7dx6/Y5++zv53dH49bEQIQuUqqrnUOoGsk03UYHAX3b89ckoaWrM9j6ahNHovoLpyWpppdU0JZaIx8bZP+JwxGYMYvy5kZIS92+bQPHF+OAlwjVwJiQ3WOUiyaC2kA+xCHF0+UojHOOgQDaWl8e9hxYUkvx0McIvOCFzzo/eagtZGA7dmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZWHhSHA6Re1h7odoCdtFFT3xg/eI1jNwTEHtsyHEM/g=;
 b=MnQ3VUU3x2cMeA0FiTzNLd2RJtKcyDjBS8SdP55f9oSgcPY6PsY4BzFzWmV0YIhvszQFScjzSXfjF4gqgVN4aNs9q86awbTuZI0J9E/5xTShPNe4sNYZxg7lb+GURB0QTNxJKRLshO0OQbx3d0rCOaZRrObkJ5mcASu/2lVTJ96KwwTFEKD1QlIPKWggPJaB+k+xc9UrqtUy1MjRXs/JGHI2v3+vk/04oc8rQvt7uzHOeHL9L+dPCIV5yilZRuj4jT6hAiQNEDyavu30IfzgLvv3NSLWy8bNc34DDvGmXx7eELnkpzDeb6BGjN6l1iepBaAnWA2BkyoqWNSd55EAGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZWHhSHA6Re1h7odoCdtFFT3xg/eI1jNwTEHtsyHEM/g=;
 b=LdSzjXiJP0rahDm4M51c49Mvn/i7rCXjuWbKnO/T/DqeY1oTqlTWkgi0/eF4dRSMfHgDURidK0sFONrfnbJ12J0bEkXw7moIf/8DGJdRao0ztypKdNczfBWmo6iyaP6+RrpikjjzWa3gwWuOuuHmwxe1KN7vOOEFL3YApaxOG8cyj/vJJj7VVIHNHH1gGdKIetCRL3gAx9DlqbEuwokEYtmWkjdBKV7o6/s6Ykr4AImMgPq6TcfVXU861jUecnY6Y3KwLntI0iLgBRVlOSLyjwCSdp376dtodd2API49oDRVr077tBmj1/ounVMjkIyVq22eI5FePc3H25Pj3Ew2mA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8409.eurprd04.prod.outlook.com (2603:10a6:10:244::6)
 by DU2PR04MB9098.eurprd04.prod.outlook.com (2603:10a6:10:2f1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.19; Tue, 26 Nov
 2024 06:46:53 +0000
Received: from DB9PR04MB8409.eurprd04.prod.outlook.com
 ([fe80::1436:d8ba:25b8:1637]) by DB9PR04MB8409.eurprd04.prod.outlook.com
 ([fe80::1436:d8ba:25b8:1637%3]) with mapi id 15.20.8182.019; Tue, 26 Nov 2024
 06:46:53 +0000
From: Gaurav Jain <gaurav.jain@nxp.com>
To: Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Horia Geanta <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Silvano Di Ninno <silvano.dininno@nxp.com>,
	Varun Sethi <V.Sethi@nxp.com>,
	Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>,
	Sahil Malhotra <sahil.malhotra@nxp.com>,
	Nikolaus Voss <nikolaus.voss@haag-streit.com>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Gaurav Jain <gaurav.jain@nxp.com>
Subject: [PATCH v2] crypto: caam - use JobR's space to access page 0 regs
Date: Tue, 26 Nov 2024 12:16:07 +0530
Message-Id: <20241126064607.456633-1-gaurav.jain@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0014.apcprd04.prod.outlook.com
 (2603:1096:4:197::18) To DB9PR04MB8409.eurprd04.prod.outlook.com
 (2603:10a6:10:244::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR04MB8409:EE_|DU2PR04MB9098:EE_
X-MS-Office365-Filtering-Correlation-Id: 23c2019c-a2fd-4c4f-50c0-08dd0de61cda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|1800799024|366016|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZIZLTPViDVKE+rhPscHjuqfwn+idXmSIOHcyMEDsX/N7+59/QXa44EmjCJuz?=
 =?us-ascii?Q?UFJAqa+W0ZfmCgXX42veiF2wjtioBjMfCbmrdEY+YK0KcldyxGBXslK4xT+y?=
 =?us-ascii?Q?5ry44QaiGvHxz23UCPmV06nw5c23t1OymimAVX25qgooIei4Ty6S03sU7fbu?=
 =?us-ascii?Q?buzbBCgvLli4BXRNASyhH8hsksyovP9A9p2JlKFYkc4lFw3JVbHS2cr9uA0r?=
 =?us-ascii?Q?FNN9WUwBYaP4rRkwppuDXVegUHW+ZWbzGsyLTB4uHCmKmhg7nyB7PER+mrv/?=
 =?us-ascii?Q?MSRywWmiLK5gCUxBgPgufbVUnttWUcQSfUgzm7v21Q8N8pMPCaHNL7fxufrV?=
 =?us-ascii?Q?59OgRjaxq10BdjEzLA2biLHuRS2OF4lqSG0ahv5s5h8OHY4IDW5+YHkdof8w?=
 =?us-ascii?Q?47o+vHXFIO2lOdymau5Eo52Wj3+U0n06Up/05Q2P3KkYUCXnKoOS6GR9U1HX?=
 =?us-ascii?Q?TogKDJ0Wlk1VNW55Rp8kJM2PsF7MfaCfw2kAtLzagYsq4bM/r0cz167lPrNs?=
 =?us-ascii?Q?WfiIuViEV4PK5qtDJmIAFNdx9NZuiGiuuFFYuYy3Ksj4Jqqxflbw5Npc6kiZ?=
 =?us-ascii?Q?oLfnbpbUDY9zFfMiav+nvb0snM5yf1GScyGqGiVoMYcyxXWZYRqgBP/haY98?=
 =?us-ascii?Q?7zmDep4JTBijpVJA4Uw4LFTAt/9djgJPiPG3qTkW77/1ZeY6QOt9IN0kS9m4?=
 =?us-ascii?Q?PIUksS+7gMmRZpnMgX4N4tyvUFpCxEfblE6Vw0x4B8xIRrj/gN0+rYOb5fob?=
 =?us-ascii?Q?8bBsLjjrKgtlb7Au3IUI8uZQOnM+onkfqgxua2mJJsQ5jWRB8X8JECkH6v9X?=
 =?us-ascii?Q?BV3b2I0cJxSq4XYqOd8y6aGUicKNtZJuYyhtkAi5oAVaNFl51UsSFtEIntQu?=
 =?us-ascii?Q?cTJE/jtDruA9LfXfhX2QrV+XGvgetxQNpU1fBSd2qH5uTLI1kldybCceF0Xy?=
 =?us-ascii?Q?BwsrcX2uvKTv/OpcjYb/fHqX2cJ9v+bWajZA+5b4SUvgTQ1HOMkFuqVPuOzN?=
 =?us-ascii?Q?qxbRQQmiIqHejFLth6CAJh4rxdk8Vl2P8HZrmQ1b7OwxsLvTSfliWhIAP2Fp?=
 =?us-ascii?Q?bAw9i64Kw4HPTiOmm1jncoXRhX5bQhVFIk8U/fCgmM69NcnT4PM1xgrV5PXM?=
 =?us-ascii?Q?DKrKwt6cT3GTZfLVG4VZYCAukurhs7T0dOvDJJooUBrUB/2vPRCD8FArTvoV?=
 =?us-ascii?Q?Z9G7EXzm8gIzibjAT9hRhxzoRaPdipp5tTQl3l17zJS7ZoK9UZD3mairPwCX?=
 =?us-ascii?Q?nA3+b1GgBlsvlL2bkjY3fCxUeq8mRpeXvKvsqa/o83UWEyLtuXbyk57kgh2t?=
 =?us-ascii?Q?inAHDC/YYph20ifkRa/XLw6s36lRFY6CguTdBkMFuH6GslIgYdfqI9gNDZGD?=
 =?us-ascii?Q?vz7aW1VR4fnN2TRxU9JofiPpxUxn468sX3RSBRqKGDUmdy7uKZb5CAaeeDGW?=
 =?us-ascii?Q?VVo5oFp31hE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8409.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(1800799024)(366016)(38350700014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Taxjn17aPUyfIlxUM16HH2tycwLmYWZTFstAfvDErk9yoY2geD8yKI9DhIrT?=
 =?us-ascii?Q?FH7ycZ7BryZCAcHD39Ak3dtig+1/0CovWt6p/MPm+icKWkQQOFZS1c55hZXc?=
 =?us-ascii?Q?oJsc+0mry2ztXwicqipFejnJlf58hF8fU9qLFDAT5kQN2uwmXCAleZXEv5J6?=
 =?us-ascii?Q?1npqR2Ml/BHHVEjjehzAMPkUIXEYdLK/QqaziWtBNq6Cq38j8WWFTx/VrSlF?=
 =?us-ascii?Q?qYk1L6vdbo+pwOnAbupLsEnxiiTdIIri6OoikWc7FbOF3eOqx9YtBEg8y22e?=
 =?us-ascii?Q?ZL//TzLAukPZuJdBzd2ecSNsrBE1Ji3mOQ8/qIeRocIbNLToZCZfYw60GIWw?=
 =?us-ascii?Q?t2G0FtB1L7bbuuzsZ8Ktjxrx2JlB4AZORYgXCtHOZQNOp5fc+u3bfAKSOJDS?=
 =?us-ascii?Q?++G5U/GWkV/rEYQYe8YBrAk88ubl3ex/EPjJaIG1kKysJ4Joucp8EI7NJlkm?=
 =?us-ascii?Q?pMyO8QjfGIsJoz4HCYV4bLxoEmn3mnbNOagWEWERF9+siSLMlpyQuOrHlO9v?=
 =?us-ascii?Q?pxnMySJF31K5bKTBxTwG9IoZfyNdfwTvfgaB8yM4zR7wn9GgV4hPfplMz0Uc?=
 =?us-ascii?Q?VE2ttRWhnmwrV6F85FSs6w1JMWiHBwtCL2LzU0xPUPgJ3N+2VHo0SRe12psR?=
 =?us-ascii?Q?xuRBKePfyiOE/I4lAOulCCZMIIJUVslzDeGWekgr1Zu/TyE7vU29r5uCWMYl?=
 =?us-ascii?Q?6vvbAMnPII+5SFKYGxh/kq+uZACnBgr7FDG39qo2TKdfvHXa8/CbmetVCTSX?=
 =?us-ascii?Q?EkVZ5HyADJ/AL4TUS4q1ZmwRSi99a00Oc5BQXC/B/gOUOeSMD6FA4elGNg9M?=
 =?us-ascii?Q?Xwpkq7pOyHMxK5hQ3LYq7zkQ2WV4E2vq/VrDHuEnWcn9BSOemhY/6ES98ieK?=
 =?us-ascii?Q?0ZReyqWMJA6hvH+sKX4pMMUdM3oD/ST8hQGwOPb75NqGsVeIVFdLsXqm6sGu?=
 =?us-ascii?Q?J6jTyIpRCcaomS9FJ8OhHM11YK5N7K5inDQEW8G25fXUR1Jbl8NpdDXSIlOJ?=
 =?us-ascii?Q?CG+QXtnfLqFySzsa6q+aLA9ebstt0e6BO/WAN4u8lABz0+n0l+8u5Rf7DM+K?=
 =?us-ascii?Q?Q8aKr0R0EkuwwXYVsjIw8c/rWsL3qBI6UImrpp20WW2kYmEF9TXrjE6esqMb?=
 =?us-ascii?Q?N4m9UQ1Jt41G2V94ZfjzVn+BG8Zl9wehXgaXutE6oZibGielv18a9RPd+z9A?=
 =?us-ascii?Q?zAjU3h38u59UCuaBA79CcDEtJYlZd/h68mX7xBkHdooBSOadKz2cmXWYA3ak?=
 =?us-ascii?Q?lqqsFT3v8g+trFVBTOuZJn+6CK4lV9CMuBipD9gvnwe61NEgbAhJ3AsLaPom?=
 =?us-ascii?Q?xDue7kXmFm6SnnNM1PTWydEROI4JpoUoARdzGquU3MtAx1nFyG0ZQRz5RDDW?=
 =?us-ascii?Q?VgRCzrYmiP/20giEJB4zLdBkD0WgwtM3IFD1zADQ5YdCr1SG+9PPwM1tmxSk?=
 =?us-ascii?Q?nyMFw8ORa/RoW6FQpyyBzTacWA9YZkjtgOfQOb6+DpusrUlQhBnXxJLpoNdw?=
 =?us-ascii?Q?7l5/yds8qZMVOCN2MRuREAIp+vZpxMqQ5WnbbJ3oHg2oNtgC6yWt+y9uMc/a?=
 =?us-ascii?Q?EvBZC7T2OlM/n4yjaM6Y4HCW4rfjVwlhUVTqGfet?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23c2019c-a2fd-4c4f-50c0-08dd0de61cda
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8409.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2024 06:46:53.5874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +1AZe9qeSB0V+warpORcO+szGH/PMscgpGCBR8HqAx50AR5NmI3NX83bit+p/EAA/g6ZAsl0g/6xjThun5CgNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9098

On iMX8DXL/QM/QXP(SECO) & iMX8ULP(ELE) SoCs, access to controller
region(CAAM page 0) is not permitted from non secure world.
use JobR's register space to access page 0 registers.

Fixes: 6a83830f649a ("crypto: caam - warn if blob_gen key is insecure")
Signed-off-by: Gaurav Jain <gaurav.jain@nxp.com>
---

changes in v2
Updated commit message with SoCs details on which CAAM page 0 is not
accessible from non secure world.

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

