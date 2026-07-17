Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013016.outbound.protection.outlook.com [52.101.127.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889B13DFC9C;
	Fri, 17 Jul 2026 08:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784275332; cv=fail; b=rL+ccQ38Ry86pgFkvn7l57wvRAdqjX/I+qcyMI6m+nvUmozv0haivsdgCwnXnttzquZIfKvpUfbgyszLYm0+Jx+x+aefsLDoysW5iV3oYfwI5/rEizUArbbkolD45gKy937Z2wPA9ppfwp1Xx1g4WdJWeqdUnsrQajftYtiRIP0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784275332; c=relaxed/simple;
	bh=ZGLa/tCP1i2UpDghWUHIzkDp8umdBSD6J/+FNr5zUjQ=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rxxWL2eeliHq5KhuF225tmK4sZ8pVXDVAbGbuotImOn/V6HtzqnNtrTEcazQ30Ry7zLL9y9kCTbMhi/MK27wAwX4NunkzHGXaN0i66o68SGP03rnwWJdRtRzoGNXPE8lAObM+A6gbC8TeuLOcklrHDcI9QKU5BHJ7nNStY5ZkyE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=X40IlpPY; arc=fail smtp.client-ip=52.101.127.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="X40IlpPY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CxB21m8BQcjOYSeunXnHH35RHai4o68Ow9Smu15neh1H5wS5B1rVc7cruVPkoC4uH+X6AdVl9otGtprLSE/eNTHc5O4XqZO1+I3MPrR7v9UrMWVvZWwZf+QCnpdK/ywTj6lQGvQY+d5t7I0rA0CGOJVRmPtDUupN2DGcX/EJk/ZpNN1DuKbeKhxUgZE+wt3VEE0jJz+13mN5YeOgBP1OOm0fDbI/kGOvehxyj7XAJkl5f1uZOToQ7Y1IRDz61hgzNt56eU1yvNbhOdv/nDzw0v8Fq4kaTdSu+90ub0L9/al2eh88E5dKnsQ5C7FAJTV474KbW84Gm0BsWY/9tfOMzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5HxhaYDqNqfpsvTrdVAJ8lFe/FBqfRPp7Wp7FcU0ELM=;
 b=jJr72mq6+p82I8Lb4aY/1otMkzJBkeXPtQ+IY2qr1W9bKml2H7QuZcmz/SKhD/NXyy6dOqzPOLTxaCagY98cbWLInkZGCmkdWOtvA8XFi6jEqS6xEZmZvX7UnLQfY/YyiZ631bYY2N19ruHPGZSVKem6RWnZLJkiMaNb0VUaIWR1a1tvWiQ+wg48mlXmsGOtloJ/YHFQGRG8fWndGgNsrX+2v9uFGF+fSjGNg9lj7s0WYD8P578193VZRmXB7TgKqEdw5KEkcyIVc79xwoekaNY2+nEKIa8tdcEHXKv6x6Phz9Tk1ISEubyy6noMTV9eRO2RbXnS59/TVf+RHzyuNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5HxhaYDqNqfpsvTrdVAJ8lFe/FBqfRPp7Wp7FcU0ELM=;
 b=X40IlpPY4oRjpQsKCM3MI+rwmMjRuxxs2Lg5RZNTognaZhSlM/H42USKqCJQnqWjOfVdrcTXroh0fxTcgXkbtHXaklhl95R6IUjWqcpW8fNkRteMPVfnjSsG4PamKqDYNfLVXXRCWNHsonQk1K8H0qw3NVZIiI/DlHJKjB7wN3fgZJHOMNvzycnw285uTXNtRtddOIxAtlFVt6kDEbw0XHCd8DOXGbHaqAL9XM32VRWshEc2Fj7dzHvGxBYri1fsVnGygLfkgNVaJpKSpLjJ2/brpySs7PhKl/HxWc9tZNlNAyF6vniwfDV8K2NUT4CM7Tl+YGVrSSX3qvf6GVl+1w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5832.apcprd06.prod.outlook.com (2603:1096:101:c8::12)
 by PUZPR06MB5620.apcprd06.prod.outlook.com (2603:1096:301:ee::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Fri, 17 Jul
 2026 08:02:07 +0000
Received: from SEZPR06MB5832.apcprd06.prod.outlook.com
 ([fe80::f98:5e32:4ccb:d07b]) by SEZPR06MB5832.apcprd06.prod.outlook.com
 ([fe80::f98:5e32:4ccb:d07b%6]) with mapi id 15.21.0223.011; Fri, 17 Jul 2026
 08:02:07 +0000
From: Pan Chuang <panchuang@vivo.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Prabhjot Khurana <prabhjot.khurana@intel.com>,
	Declan Murphy <declan.murphy@intel.com>,
	Ijae Kim <ae878000@gmail.com>,
	Pan Chuang <panchuang@vivo.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	linux-crypto@vger.kernel.org (open list:CRYPTO API),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 09/12] crypto: keembay - Remove redundant dev_err()
Date: Fri, 17 Jul 2026 16:00:23 +0800
Message-Id: <20260717080045.191538-10-panchuang@vivo.com>
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
X-MS-TrafficTypeDiagnostic: SEZPR06MB5832:EE_|PUZPR06MB5620:EE_
X-MS-Office365-Filtering-Correlation-Id: 934def57-87f2-4c77-4226-08dee3d9b256
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|52116014|376014|366016|10067099003|38350700014|56012099006|11063799006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	EFeevBbWuSRKu1ksljpP3ccFzg4D7S6EXmEVrDljxgrAKsXBojicNhetVdZGoYSW7nN93QrpBdClSA7UGkVsZtO8DHSqcYSotWmAVg6slayj4l2jLPtXZ6XgZ9htrjzLgRvpsnlPPiu3Kc1isyz0PRaWMj6uGjpBAnUPuwt0MpKGbLvADVbndRCkqvGhNbQnUfqEPeaXsLWIMFKvPMlqIaPgrW3xwKFGFcoJzkZ2uQkUhs1bm35QP+L/2dGX3xMu0zPStTQQh7/A2Yqoerwbd97xqs3f+PFOTV20VTH2xzTHk1mxi9w27s9QhD7Uj563K265q9wtEgrhFfKctJ1ljQby/l5q49FvPvDSEfxcBiU/3YUWS++erEBG+vwPSFYE2VJzjsxp3YXRMbJYks3tUsAmMJPZJQnBQLNb2AfMMfqq3g3fi05Fp2K0Oh/OqIpoK8JSA0YcT6c8oIy4RUKOtIzDWoL28HdC16Ye+vnCG81fyMi+KKO/h+v+1tqLDuO4CtVGk8R9GTtdUOa8PzJFQpU0qdQvCP4UZuI4phikIwarF79JXg2vo7LqYSz5rE6wMpzsf54YTDo0jh9Q8hFyQWIrsmOKWJ1KMyY4xQxc2atlrG3fm3aI5EnO9v58d1A9APFJUDMnDmHT9OeUo9HIG6wsyWGw9YB4yK86UGgYPd/qA/hz4rWsIoqPWq+7yrwULafAlRrI7BBde4uTq8Nm7o3+ml06dkcAKoColYgdI9U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5832.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(52116014)(376014)(366016)(10067099003)(38350700014)(56012099006)(11063799006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ghWi1BGrIHYMpmBySjF6NnfRXON/KQv+57Rc8mQfET+duuwKK2zwO84wOTW2?=
 =?us-ascii?Q?x1xGANl1aM5AvUDGPHNaIauHSOJUUEKAVt94Hfq5fMyu9de40Db2CzyLGGaQ?=
 =?us-ascii?Q?C7v6fS1lI4Zbs2L1GHiIt7ucSSnb/cYfYaE0wVM6ZuTaCXbMhBmiwmDo3FGU?=
 =?us-ascii?Q?sk+xkZ68yhSVp7SKpU+FsqLYMxo8HoFYjLH15Zi1ly399g0quYKlYXjhpZg/?=
 =?us-ascii?Q?/ifOHR/7zVeAPFyp+XR7coJzuM487w47lZW69V6sHauM2VljGWZtsjtvjUXt?=
 =?us-ascii?Q?itDpTFzISa2hHkJNO9AEmKJ6rAl45YaCmlHBBOl5rnISctpXJjocpwsOKYbo?=
 =?us-ascii?Q?CcjkzfaQdroEB3Ypx38I9GkFcp3wkDEDEAYTwTfbSf6Ja/qyCPCF4duaw8Rq?=
 =?us-ascii?Q?KRvpxI5v64VG2VROnJEjD9xTAuEJng5CK2bBbcdJihCxbhpZBoPPAFhXivzl?=
 =?us-ascii?Q?TwfDz++LB6hQW9tZgV435hA8VzIecuCF4LuOiKDNGkFmmtG3k8CtXlE00efn?=
 =?us-ascii?Q?auRVJLqieJ4hY2/iZcKjqVf4on1WvnWqWDFZpFk28t5HroR0zpOiL1wxmLeC?=
 =?us-ascii?Q?riDoyGu3bePnx2iIugsDBQnU8aI3CQFwBNEIyRPl/lQTlWZWOBb4rwn3U1hs?=
 =?us-ascii?Q?q+WOeS+un/SGSjBlensi0V6i7525PwS4fwq34eJFZzpZyocA5iAFhLvw8Udp?=
 =?us-ascii?Q?VAIsimSCwHe75A3YI4KftSHLKZIoPHpsW9A1Ow9DQk2ojZ48v0Phidt5C/g6?=
 =?us-ascii?Q?b6Dv4aCq6dW5siOy9uYWN7Cl6C3ieLvIxfLyYq/ls+Lj7iKvopfVSsOAo9ag?=
 =?us-ascii?Q?0zBAZ966gvPruCVdZruloC0v8Sxv9xiYrJVKLKL2bgOSXjM2KuTT0rJ1vfIi?=
 =?us-ascii?Q?ztoFs2zLXNg5JNaviujEFLDv3TtJJOhU8K3THM6EXcBul/mmb+T6BqAJH5Rs?=
 =?us-ascii?Q?QD540Ke5s/q0Vu96fVwXnu9Z/I14KYqaLtz7cTgcb+PrtHhSdSB7nfUEFvwH?=
 =?us-ascii?Q?VhCJ/NLpVbkdOK3zAsLJ4cXh2E6ooslmZjTcZKkRByfAytv1yRjggS3fHW6Z?=
 =?us-ascii?Q?cg0T7w7+DbQkdEwPQOfA+Rfs7aaU53KDItFQnUQhWjyCMhb00Y7tnGZwac0L?=
 =?us-ascii?Q?pywrKp0CrQVkfJo/H1K1zrjWCOonFtrQ4v88yzbxDGOgwmeAOn59PUZcuvSr?=
 =?us-ascii?Q?jW4y8A1kGWESzkQuBbtNPrMd81Xklox+Ye/risshjkle6UZX/BRaSi5ZF+uk?=
 =?us-ascii?Q?YctEnW16emeYpg6pBIaIrHU9MuFWh1YqRjMaM1/bkSEfTK6LyFgzMDXz7CKC?=
 =?us-ascii?Q?aw0jM7y4Nfx+s6Y/CW6mv9yICTtLMPLxvXIKrQ0opzO3TGd7tC5aXUrpqH+z?=
 =?us-ascii?Q?BPk2bUwg6wg6XTBnwk9/qahto7/M/oYXsVcSbqrKHuv6gCu5j27KKnPGmKvo?=
 =?us-ascii?Q?eZR5I3y890HvUTDp8iZ6VgMPETqfByWOYV0SPPcRAvLMMU6+le9HuX0gtptf?=
 =?us-ascii?Q?oYXy0MAHCo38qPjYlVa0D/XnL8+VJtCO74m1Qg9QEFh1INzWkxqnT7DVT4Mi?=
 =?us-ascii?Q?lyaEQEa7dIcAaYTaVLPFMj8zp1/RELX6+flhENsNOGaTSaXQ2zuY8QgSfu0Y?=
 =?us-ascii?Q?FrBKttx0G/OM5zPJy+G42pbwQCB4xZknyNMn3JSIl/TG8Wjai1HzYWh81fj5?=
 =?us-ascii?Q?+/VlAh2E71aYc1tC4fjOc7Xr8mnIzKR0VLyR6L3mUYomF7GNw5dYdvUq4IHG?=
 =?us-ascii?Q?Kua1S3lTQA=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 934def57-87f2-4c77-4226-08dee3d9b256
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5832.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 08:02:07.4298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +GSQmcUkTbNdMfxjI616Vn4REl7ygZ31txJ/n4WtHdgxwn46l4cYb6HUpQatDlcbOYJLUj3wuni8TIMAjjVRgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR06MB5620

Since commit 55b48e23f5c4 ("genirq/devres: Add error handling in
devm_request_*_irq()"), devm_request_threaded_irq() automatically logs
detailed error messages on failure. Remove the now-redundant
driver-specific dev_err() calls.

Signed-off-by: Pan Chuang <panchuang@vivo.com>
---
 drivers/crypto/intel/keembay/keembay-ocs-aes-core.c | 4 +---
 drivers/crypto/intel/keembay/keembay-ocs-ecc.c      | 4 +---
 drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c | 4 +---
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
index 0e424024224e..6de6dbdcdbd0 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
@@ -1609,10 +1609,8 @@ static int kmb_ocs_aes_probe(struct platform_device *pdev)
 
 	rc = devm_request_threaded_irq(dev, aes_dev->irq, ocs_aes_irq_handler,
 				       NULL, 0, "keembay-ocs-aes", aes_dev);
-	if (rc < 0) {
-		dev_err(dev, "Could not request IRQ\n");
+	if (rc < 0)
 		return rc;
-	}
 
 	INIT_LIST_HEAD(&aes_dev->list);
 	spin_lock(&ocs_aes.lock);
diff --git a/drivers/crypto/intel/keembay/keembay-ocs-ecc.c b/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
index 9e555b02086c..9bdee39dc4e1 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
@@ -900,10 +900,8 @@ static int kmb_ocs_ecc_probe(struct platform_device *pdev)
 
 	rc = devm_request_threaded_irq(dev, ecc_dev->irq, ocs_ecc_irq_handler,
 				       NULL, 0, "keembay-ocs-ecc", ecc_dev);
-	if (rc < 0) {
-		dev_err(dev, "Could not request IRQ\n");
+	if (rc < 0)
 		goto list_del;
-	}
 
 	/* Add device to the list of OCS ECC devices. */
 	spin_lock(&ocs_ecc.lock);
diff --git a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
index 87b67060c77b..9a67bb4ecc82 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
@@ -1204,10 +1204,8 @@ static int kmb_ocs_hcu_probe(struct platform_device *pdev)
 	rc = devm_request_threaded_irq(&pdev->dev, hcu_dev->irq,
 				       ocs_hcu_irq_handler, NULL, 0,
 				       "keembay-ocs-hcu", hcu_dev);
-	if (rc < 0) {
-		dev_err(dev, "Could not request IRQ.\n");
+	if (rc < 0)
 		return rc;
-	}
 
 	INIT_LIST_HEAD(&hcu_dev->list);
 
-- 
2.34.1

