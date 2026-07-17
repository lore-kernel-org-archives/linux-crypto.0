Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012023.outbound.protection.outlook.com [40.107.75.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84ED3DDB1A;
	Fri, 17 Jul 2026 08:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784275311; cv=fail; b=twPcvXVQ6GQrkh343MJ0wsqR8pY4e25N6Gi6zVUwILAO29wTPXjbx7udMieexqTBHUZ88FqMR15psNJFVXMdGJZW1fAbeEcQur80sdnHyqvnQRXDd0QcGOe91jrN/2uANCGZG0XxPP7jzHoQyHJb/ZRTsbsQChNft7cqJ5Hl0Vk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784275311; c=relaxed/simple;
	bh=iOVu+C7sFDzRDuRMyqzx73tMqj42PBCpdp8J9+irKV8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eGeFdP3oVR84AvYP7xZxo+m90w70ZHDY4DOa/NNUCB0fybD9IiDGLsGK1CzKaQfAk2Xqhx1HbHupKwTDgv99LG91wo1VIeIb0RN8H6Vo3dcz5f9dsEF3HBFYnSLkpChjGEBJ7jEeIOvdsaZ6cjmXD9SokNvCVk9/qDi0loCo94Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=nOeq2f4a; arc=fail smtp.client-ip=40.107.75.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="nOeq2f4a"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ruiq7AR5xm5nwWsKVzp2U/XPBRURkyTmzGdQUW+YU0W0pAezdRFvmqSdNRd2bmUsMIiQky933yx/AQ/HvmURNDhhC3K8uLjZ4EkrDAN3jeVxbfDx+Jx06C6XSHWVwW2XrEmksUQnwBDD/7V0ravK/B9koFrC9//n7dBu3PvqqIBs823kKLEge2WoIgyswyq/9UaJFawKCPSrz/D9Oq042ZuP0burwsnnc1Ruj+KtlCSX4dX8Oh0w3ONMYUniQ/v4f+7bzNa9w6VBI0sCvuTI1YX0mTEIp16I9bTAUYIDhq5FqBmxszJe+oei5ItiW53qLJ8Jxih5P4jP/v9BQByYyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ny0v79ofNQF27NvO515Uu4wtGWgYf/cGphRXPyucqjw=;
 b=n6rAYxi9E0SdW4ftWasJianA/2TcAu/1Yky4yxvrErlI2iLctBbqsY1WhSxx/PkMjJ2l08MOFB84VhFcKHvbVXBPVe6B58gmPymFPlwj59BQGlLH2qvcTBRckVzANPIkH3UIYnP66XIjdeVAfO4Idv+185HjGNkokE9WLv+PXw6uY1y20MSx/lEtl+9RNA6XZzT23Rd0KkW9VtzMzhLeWEQoy5/7nxmYvCgTEjlIscsjrmaIu/Qbh3pg9tpL9tQpxywZHyDu9/Nr3NIdy7hhh9kwodLdSRwrETjLwNUt16Cu+Cud51/XSBJUcMGAohO6j/bvr1uei0rPxl9YGa0Pkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ny0v79ofNQF27NvO515Uu4wtGWgYf/cGphRXPyucqjw=;
 b=nOeq2f4aBKty5DUNgMQuBaBtdzG31EqoY3789Rm7WfxV4dUfrDaGieqJk+CHFlHASlAER7CnpWfO8+Zn33HJnfesA++F21Ofxn6iF9IH50oJRgn6+Q4g3AKxN/XBF5HlLHhqTXzx+ywLHVCbVe+7ek6ny2TmL14sbYcS4FLLQFUDGRmRuQtghXkbmzBy1/Ilqu82K4bjirRDwhfI+7L8qtiIhIxXSPPiMG7fs68HiQ3JYeFQY3J0VL9jKsAR5NfZFwtYLDiLHo9liGxP6OiWxZWkHkteNWhkJftWaV2GoEqFE5ZjH7r4sc5twbf+87x3hQ9Mtn/t0Yslou6z6p/PTQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5832.apcprd06.prod.outlook.com (2603:1096:101:c8::12)
 by TY0PR06MB5104.apcprd06.prod.outlook.com (2603:1096:400:1b8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Fri, 17 Jul
 2026 08:01:48 +0000
Received: from SEZPR06MB5832.apcprd06.prod.outlook.com
 ([fe80::f98:5e32:4ccb:d07b]) by SEZPR06MB5832.apcprd06.prod.outlook.com
 ([fe80::f98:5e32:4ccb:d07b%6]) with mapi id 15.21.0223.011; Fri, 17 Jul 2026
 08:01:47 +0000
From: Pan Chuang <panchuang@vivo.com>
To: Neal Liu <neal_liu@aspeedtech.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Joel Stanley <joel@jms.id.au>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	linux-aspeed@lists.ozlabs.org (moderated list:ASPEED CRYPTO DRIVER),
	linux-crypto@vger.kernel.org (open list:CRYPTO API),
	linux-arm-kernel@lists.infradead.org (moderated list:ARM/ASPEED MACHINE SUPPORT),
	linux-kernel@vger.kernel.org (open list)
Cc: Pan Chuang <panchuang@vivo.com>
Subject: [PATCH 03/12] crypto: aspeed - Remove redundant dev_err()
Date: Fri, 17 Jul 2026 16:00:17 +0800
Message-Id: <20260717080045.191538-4-panchuang@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260717080045.191538-1-panchuang@vivo.com>
References: <20260717080045.191538-1-panchuang@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TP0P295CA0054.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:3::18) To SEZPR06MB5832.apcprd06.prod.outlook.com
 (2603:1096:101:c8::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5832:EE_|TY0PR06MB5104:EE_
X-MS-Office365-Filtering-Correlation-Id: 38470627-dabf-493c-761a-08dee3d9a6a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|52116014|1800799024|6133799003|38350700014|18002099003|22082099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	bc6yaCzVTxwRS1yyqAZuTfQ24SZauUgbzJNAUgkhs2MaidpNMVClJGpjjdcw8ieIF4mrVOyzPc5TI78pLtmS1eEbFWNw6HuzZISMqLEnc7wNEH/jSuwRGTwDCnGZA2XdXw7Dg+mAoQ7EG3j2VB5pAnExKfpRsasifaLhl+6Y0Lj/I3QJzamzFSsgF473KO54B2JfksBoTHSkPBT4N41XIfQn6xQXoEflKOqwJoRCKFpLupzgh9gBvr37rp3YzjCcbtqYgAhqi8uJkiESphYR66C1tF+Dszh/s6gObUWpHGEu4nygDDzh9lbbqZkI33U21mORD9/WzUvQanPsntv6HOP4MI4Ns1mFslB3id8xQo71h/AfneIVrhWK+Rty/KAWtxtUVcc1fxaMhLAGUbYOzo7oHPuMYruH7wWwfwOHHX8gAtPlPU6RcMiWNhgUMAk8OH8iz3x37RscyEPC8/WQ3nayhxXz9Vt0UxwbJiPlQfVuyE3ZsXYHGKEsdAX3wazChV+B3c2DKNc3L4Z0xB6TULU7QfT2Hvgqnxvc1nzhUm5cgQhtgSnsFRG6rFBrnczGg+0aXvTzsWxwVdIIoPVzXRM9DxnsdhUm3flkhCacMcNRqvjnDNGlDoIlS2Ph2w6wtiJrnZkDGeTyiVcnI36t5SyrZCGzk66C529x2CRL6MAsRLu2j30wBvkWljtRXVKXgHrdNHxtDz/MjmvW+5QkSVR1Q90X9e2K7usGv+ANFug=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5832.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(52116014)(1800799024)(6133799003)(38350700014)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nMvVYfPWPXtCG+qknbKm5KYVjGr69E8/qO9ibGSVGktodaUvciHKKE2ia100?=
 =?us-ascii?Q?+Vd62SMsZHHiWk4BeFIw397ERYaB9kFAAfM/WOACeqo8dhGMOQl/jpW7XZjG?=
 =?us-ascii?Q?xFFw8loOY8RAQ8YYvO2aAVBc13wrwxFZjFLAhvFwY7MR5iADiipZ+Vc7ZbI0?=
 =?us-ascii?Q?Ejyk58mPXIpAv2ME7biZFJX8fjaqlI6+qfFFPZHyV7/0czTgWYg70b0rGIMp?=
 =?us-ascii?Q?nwqH9s2eI2azB8esLdS7RymQ/jL9w+dnkpdBEZM1ByY+zEyx53p0YDAkHiOt?=
 =?us-ascii?Q?eXczr0Q9rkv4gTxUteZaobdzs/sLchOscebccQZuQ+1zbNeWFyMzTC4LSuhl?=
 =?us-ascii?Q?4nRNgfMzCw48nEjQzqllzi0JH2CmR46V4I54zCpJczY+Gdl1ofaxqND2nhGA?=
 =?us-ascii?Q?1c4nkY0DEiBs6YKU0TAVjvgQEyoa+/nddW9sLrZ9v4TttT4mTxYjZ9Cp6dRX?=
 =?us-ascii?Q?H4QywPLptWKaL0oUJ+7v3KiDw/lRvv6T7Fq4ju0J3obdApvMxqI/M9UT6GC9?=
 =?us-ascii?Q?C33W3XiqvEbZp6wfcJ/RBZYxuFkVNRzjzYE7VUPl12TZ2a4H7Einrs9rjF0k?=
 =?us-ascii?Q?YzjqvQppVRwk0bnk5x02q/YdKv+QoF6JzU1oJOPhuSDE6YH2ZyVYpkGCb4SF?=
 =?us-ascii?Q?wKfkoKPR2v4vT4tR6Rf7ibNmyAs4D5V4ng+N3otBXL1pfDFZftqRsQCh2HEz?=
 =?us-ascii?Q?FUrKBKo8ldbEDD6DDKhBeAHPr/QkP9Geh/XWs/6sCrNAT9dWtEMGKRzj8iei?=
 =?us-ascii?Q?XG1ZRtNSdhlXFE/RumuQq1hz/0ANBwmIZtOvedPbFficBZ1KIRwnDhSEOAs5?=
 =?us-ascii?Q?Gu9Bu/yT3uJhYH/pJKxBX+PzSunnpndvNJUK6n3a/aJtDutPBqrhINCBeIzF?=
 =?us-ascii?Q?MLkbcLouJbl0iT2cG4YEo1npBel9H4Dae0zQ2qo3xg0GVcAO2Elaqub3Xs2o?=
 =?us-ascii?Q?sd5gCrya9bTZHMJW5/IIOGahXIarJvU7mFDFN1hqUFncZjU4qyXftY2muvH5?=
 =?us-ascii?Q?66JKYb0W3VKz4Hb7OubGt2zrDvNlLpXdcankX1Ph1Jlt5G4QAi1/78H+j26U?=
 =?us-ascii?Q?t4CbCE/zGbmStmxjJnZfnT7948HhuQJM8poqZQbOglgpaoPZVSSyDh/3kRt7?=
 =?us-ascii?Q?liZK01VDNgqqL50fRygIp83Cx8UEG+aTkYkkdZY3SCoxjYfxD9JHiXR2og11?=
 =?us-ascii?Q?QaiUwgJ7Ae/IzHm4OhU85sd57Fpz63cviBsv+sccJ7ZjCEUjC8omKiw3K4gB?=
 =?us-ascii?Q?VnBRp5pF1KQG8fNFCGpVXeIQEwtexJh6/vWfV8AWCNFlzDWks7L2Gr0FZ1cM?=
 =?us-ascii?Q?ncLNnoUGx7GQW4dOaRRmdUHBYDLhfIpdp/OU6AQkuz8SOgdc6Qymd0XLa+H7?=
 =?us-ascii?Q?A6ZwRz6LkXL2pt9JHelX9AjDiuoDdykyay+O+SJAxd9EsrCfoum2nrJNvio1?=
 =?us-ascii?Q?8boHabIJebfBlNLvgV0RZZ4DQe4+nSs+gNNYzYQ+t1KPiNNRlrkhGqf/co/S?=
 =?us-ascii?Q?RRG4oZ3CnatKEoBfbT+EvJFoSnfkeGuDhNEAFzaIoz28jJ781SPcrASYAH/F?=
 =?us-ascii?Q?9ZMY4ApE/ZaAtz0k8U6bqsSmRoM7jAJ6o9KgzoAc7nBgvnMJHXwMOHzVyTXl?=
 =?us-ascii?Q?cxYSkVnT2agliN/ON1zsb+c6F/+utFpni/i3usNZzPt1amimD76E7xSKA0wU?=
 =?us-ascii?Q?rAQtxQDINGB9uKj6npiUimOTiKIK4wqQW1iBjZVD90hd6CK+0TdmBuaBNv/N?=
 =?us-ascii?Q?tTG0/gNLtQ=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38470627-dabf-493c-761a-08dee3d9a6a1
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5832.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 08:01:47.8540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VHePAsYrw+sAYDSYLahjbiQWyay73a0U+QQTeTKC3GVuO1wYcOcsCZNbVLJ+RZQwPHAcVuYC/LTF0EpUlXuEHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB5104

Since commit 55b48e23f5c4 ("genirq/devres: Add error handling in
devm_request_*_irq()"), devm_request_irq() automatically logs
detailed error messages on failure. Remove the now-redundant
driver-specific dev_err() calls.

Signed-off-by: Pan Chuang <panchuang@vivo.com>
---
 drivers/crypto/aspeed/aspeed-acry.c | 4 +---
 drivers/crypto/aspeed/aspeed-hace.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/aspeed/aspeed-acry.c b/drivers/crypto/aspeed/aspeed-acry.c
index 5993bcba9716..8d13f01e7a37 100644
--- a/drivers/crypto/aspeed/aspeed-acry.c
+++ b/drivers/crypto/aspeed/aspeed-acry.c
@@ -732,10 +732,8 @@ static int aspeed_acry_probe(struct platform_device *pdev)
 
 	rc = devm_request_irq(dev, acry_dev->irq, aspeed_acry_irq, 0,
 			      dev_name(dev), acry_dev);
-	if (rc) {
-		dev_err(dev, "Failed to request irq.\n");
+	if (rc)
 		return rc;
-	}
 
 	acry_dev->clk = devm_clk_get_enabled(dev, NULL);
 	if (IS_ERR(acry_dev->clk)) {
diff --git a/drivers/crypto/aspeed/aspeed-hace.c b/drivers/crypto/aspeed/aspeed-hace.c
index 3fe644bfe037..6677cba666d7 100644
--- a/drivers/crypto/aspeed/aspeed-hace.c
+++ b/drivers/crypto/aspeed/aspeed-hace.c
@@ -131,10 +131,8 @@ static int aspeed_hace_probe(struct platform_device *pdev)
 
 	rc = devm_request_irq(&pdev->dev, hace_dev->irq, aspeed_hace_irq, 0,
 			      dev_name(&pdev->dev), hace_dev);
-	if (rc) {
-		dev_err(&pdev->dev, "Failed to request interrupt\n");
+	if (rc)
 		return rc;
-	}
 
 	/* Get clk and enable it */
 	hace_dev->clk = devm_clk_get(&pdev->dev, NULL);
-- 
2.34.1

