Received: from HK2PR02CU002.outbound.protection.outlook.com (mail-eastasiaazon11010070.outbound.protection.outlook.com [52.101.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49A218E364;
	Tue, 20 Aug 2024 09:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.128.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724147255; cv=fail; b=uTVHl5HUvvu8zyD3eq+GIqQ2nkbrmLmW1wJ73TQyDDn0EXnIz3muf9nJdM5CX6+huI5yTYKJw3slpx43KOUwEgkHf5sy2e/z/VRoIWWafqqB/skPUehIQdR7+qZU2QG4eZQN51JP73qiAd7hmfRDouCN88nrAx0FpBPAuMmEjAU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724147255; c=relaxed/simple;
	bh=nevVacbRQEB8+hqNntaJuueHr0WTi7IGVGdaWjF5hWs=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=mS3h03qfb6EcdtiP6i1IQ25TScB2FHwhGIQGxiid9HcdRcygm8tBDhUZVwu9mUGkyXBXeldlPohmL336WeEBIg89iwVH4SIkskDJUE8zeoHhCb+bD9v74iPtNSsHGUzM+GYlTUFb9iG/zMkv2SW/InfIjFrM+xSkFOiKCeAMVfM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=dnb7PKBN; arc=fail smtp.client-ip=52.101.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="dnb7PKBN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tCSXJz7AuB7vnlhSAmOdBT/JfHck5ni/JvSPgXjqPajB16KmU2qVYzcmbUb1Eop1LOI1yKozhjxFfgVigE86zcdb/XD0PQqv5eoqlN4oDmotzp7mKNePIBZ3nhl3AE8i2wdt5+8P5kurDPHpF8F2bej+QuMNrarf+rP30DGeQO4hWTqU6JrerqoJXeiBmYe4RzlU3VfLLLs5vLDOzmgxaRDaTV0fY3JrZrCyCMN4MXO98FMzfsdopk7ImFASXZgDDlmCA87r4LDGgg+R5ko8xj78vBXZCLLkfnDkDAW6Ln/7USAmhbzjFoIvlOf8MnalaAFJi/e7+GUsVW+m0snbFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aMoKELYixF3R6yjwcIcefbBqHsecTgV7Oqx2VNWCz9U=;
 b=Af1HGsS5gLfbg714mLCBBM7ddAlf1+jIGofCYG0na0JaMI7+ZScFhId+sxHgRYFBKGU9OAvAJWu1hP6WjmQ25Up0+FD+6yIXfl0MLqC9twCHLgQC29OBA+pWY6y9sSjLwxc/+8SFVRVsOHgvbASnp3FfRUmWoy9CV3JlAHCayger1109rlfYBF6HylBd4n+RY5+BLcht+nxa262EmP9GEOZFWrvZpPOH5B+wrEuUhraLIijrizxTLJ95OsFvutf9mhp3mYXuutslAgCfFiIxyonSQAHnlqEvVYDoraW/KfXBRJGZRUafORtagVvJ9PenXrM3U9D5Vb9wmTB2PX1yMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aMoKELYixF3R6yjwcIcefbBqHsecTgV7Oqx2VNWCz9U=;
 b=dnb7PKBN5sh7S3T090Y3BBOMTtbLIg6zBlodjU32AaO3o6cPHLOnHqgpr3Wj9osfUn+N1U84hTB4bkgKCpb4v4/YqseB7nma6ZDkdDH/i1I96TsiCO157vUzLoWKrf2KQixvCScWaDVRbbg+lJn5U7HlamSSPSruvfTAs3ObITOR4DjsrmQCBuHHsIBiVAwzC60uCbBJhPa4peeN1S507Wfn1dUFehBwvNon12hZGGoFVw1rohSE+BcqgfUOkm1kIePq/scy1yjCY2eFKAKoDLRaRwWzoyeE3iVdik5xaga99njzIehnKbM7xz1HapFSf4+lgYoReB2DH+knqHTW7A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from PUZPR06MB5676.apcprd06.prod.outlook.com (2603:1096:301:f8::10)
 by SEZPR06MB5829.apcprd06.prod.outlook.com (2603:1096:101:c9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Tue, 20 Aug
 2024 09:47:30 +0000
Received: from PUZPR06MB5676.apcprd06.prod.outlook.com
 ([fe80::a00b:f422:ac44:636f]) by PUZPR06MB5676.apcprd06.prod.outlook.com
 ([fe80::a00b:f422:ac44:636f%5]) with mapi id 15.20.7875.019; Tue, 20 Aug 2024
 09:47:30 +0000
From: Huan Yang <link@vivo.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Huan Yang <link@vivo.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: opensource.kernel@vivo.com
Subject: [PATCH] char: mxc-rnga: Use devm_clk_get_enabled() helpers
Date: Tue, 20 Aug 2024 17:47:11 +0800
Message-ID: <20240820094715.104998-1-link@vivo.com>
X-Mailer: git-send-email 2.45.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0095.apcprd02.prod.outlook.com
 (2603:1096:4:90::35) To PUZPR06MB5676.apcprd06.prod.outlook.com
 (2603:1096:301:f8::10)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PUZPR06MB5676:EE_|SEZPR06MB5829:EE_
X-MS-Office365-Filtering-Correlation-Id: e8f0d1b2-f941-448e-b7f2-08dcc0fd1b9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|366016|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tN4OJK9qBap8SdzJVnnQRjL2DaS9NDWngSBKqqgZuHcu6b5mq6ZBrIHmgTFX?=
 =?us-ascii?Q?ud8b2reKBlEQ98QkMUqtv/G0vtcU/gP6dP3RxM/w7TgDRBwAjP8zdiNG1cbh?=
 =?us-ascii?Q?/SVNJecARrVwIk1HI1JT3VqK95HpL8LNXh1hc+fR33KZJ9sLwjnBtNOgLUU7?=
 =?us-ascii?Q?pmEf8GzQ+fpCwOKRaSmEJDiHU/8vJ1T5Au+Y/EwfjXZtKqYMgM7hpLrrJ4xO?=
 =?us-ascii?Q?3fqmemAYduPJy1AQWYHSHbmbpIB8ubkN1fMe3nIY8YXiio/gXb2HRJr8fLCJ?=
 =?us-ascii?Q?tTvgEl0cvDrLJ8l044InDKiv0V+nWD+e+F3Ei3t1jm9XRyTqQRw5qe/2uM/h?=
 =?us-ascii?Q?LIvy3MU9Pq8QrG2od1uQ6Mp6FshVmnyDdPG7z39UZtSFmap0EhErRVj1m3JG?=
 =?us-ascii?Q?iiyOzR1C0gt94xJXBLhXUkxEZevOmfBMHBo19B0Z2PtRxGt0fllcB0SG4MuG?=
 =?us-ascii?Q?usA0BoLrotwrGFrucb6izqXIfrQFL4JXQCQIJlHZ5nm94rXE3bly7I2GvIoF?=
 =?us-ascii?Q?Vn5otllcmYsk5Pqpm2FBl8ciCWG9dhm1ql2NlUvL8pF9jcTlcCrFEWt55kEG?=
 =?us-ascii?Q?4XVpWNUyl3cUCJWacO6OMuDsNuCdGrjci29aOKHcm4sksOWDk5vAzqEiWAiv?=
 =?us-ascii?Q?Q+fcmRYTr+LdbrRzi1+X/64+06jC6hwMbq/2A9wPNpLi50DUjsqE5z9QYSDn?=
 =?us-ascii?Q?4Uckp/K0prCr0OFreRzuOWA0VyYG/eDkV1H/ZDkDH6blDtkDG3HXHryBdpyv?=
 =?us-ascii?Q?BcLe+EoJso/E2ZImrIR5tjD3DJvqTj0yEMr1eGQy2V/RwhmqvsqBO/EJg5Wf?=
 =?us-ascii?Q?CIPrsCkSmz6/Irxsn+Knsek6CRLIPJz5OzotkO30S5Ewgc0VWl5n1Fe3Sb2t?=
 =?us-ascii?Q?rmM7GHjKm4cEXx2mOlZciWydFyO/GuH9uB5mWQV6tv8RFT0hcgC7NMtJd4ND?=
 =?us-ascii?Q?uPnZoXyKHdNdG5LozhluBYo6rqXtsyFNmN9eYxQpKxigamRrXV11uHKJ59WO?=
 =?us-ascii?Q?UW5jnowCxO3sAMSBVW2oXmz0a45MDDihDeGNjP+TLl26q169x2OxDJV2uWR9?=
 =?us-ascii?Q?2Tx8YK0ntvIi3qwZgzSPFOgrwTlcJQYffYjmFk1xdPjfwo7PNyDjzJKVjxhU?=
 =?us-ascii?Q?N7Iwh5rCcZVkkYKrixynok09s3koxq5gAR2nqFGTmmXKF3OICrc9fPRKpfcp?=
 =?us-ascii?Q?UTGt9W4MGleU2WbpBrwpKr7wNxwcSIzDRyZCxSaPHXPaW7VlPHPqqre0zmG1?=
 =?us-ascii?Q?PRYtmqti9pms0E8eE2Yc9DXci0Di20Y7JtbafYP6ncyi/UpuHVMF6toLjF+d?=
 =?us-ascii?Q?20Ae6Du3xHAGvJMzMeQc4RWVed4u8tyQGrjL1Z5gif0aTZC3OfvsjGSbhIt8?=
 =?us-ascii?Q?Xfx6o1mGoZmfIbb+2gj2956XCe5N98ReY1+y5CHB9xZ94b+clA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR06MB5676.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(366016)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CVUpPD5Z6Itf9/jiuS81hs1BwqDQYHOGDBHzLtiAFIKkJxvKXCu6P0HpOhvr?=
 =?us-ascii?Q?1o3m7B9eMqwSxKNu30v9o+WDR8WRWrFuZwqEPGGncd8h9vNY+73I2Aw5fS0o?=
 =?us-ascii?Q?GMcERaudGm8vDFHMfkSTI7eCbarOyAOnqqxJu1RyYXis+wZJTd/8StAfU55O?=
 =?us-ascii?Q?8L1EYG9RqZGZJVWRWLpa4MTMjvzmY9LYuKGG60onvWIzYmhbk2EglmNAxInQ?=
 =?us-ascii?Q?ME0rb+APb5OEeas6CPRRUkGBhkTtfEK3w80WZlgBTqA3ebcCblXbahm5W9Yu?=
 =?us-ascii?Q?CtnvKgbei2rOm1BK0zPs56mLC7Gq+k/UvV4S8gnHTfhULVkE/LMdAeEVkrau?=
 =?us-ascii?Q?j1B6TJGUh2wZX4G5j6IWxKMdf/puKLBoy1BgYqkDUBWYz3Q8OEo5EwQ2+5o3?=
 =?us-ascii?Q?PuXwy1y6zATNHe+5h110nzd/cXcmGXAYIBMij7gAkAXv5EXw/2WuJu+KO/8H?=
 =?us-ascii?Q?ZGM6q9cqY/B9vD+bWe6FMnO/65ikOhgEoyNy5JBdeDEfkK8LxTs5XVctGM2r?=
 =?us-ascii?Q?Rd8GU1YktdmT4a1SVuHX4hGsWWsiVDP3BvEaoTCz6RkESc8HVazQ/Pt62YrP?=
 =?us-ascii?Q?QHPHBDV0no4vEFGdw/zDKri1s6cLKjn4dFKZcs9GXCgfx+h4NXZzyOMkfa52?=
 =?us-ascii?Q?urT7D+DWwF/Pl20ssUhHC1uIjox/GWy+MvpjxLC6UTHpGg7K56khq8AyZoxL?=
 =?us-ascii?Q?4hWHbc+z705t4JiENm8OMHTIs0rdbG7T+e0RsAJBnUtJn503g6uYy8SBMmh+?=
 =?us-ascii?Q?1zZTVpkrXvokKx5rD+gPqtNpxQUmrbj5qf1NkQAglEuevH+170GXDrn2jIKX?=
 =?us-ascii?Q?1JCgoj1qOc0w7/AhC74s95ywaK/VrfzdXrjtXLJcLjbeP4XhviEX0rW445pe?=
 =?us-ascii?Q?hGY7cSgqeiJHBPnjpphrwvypbN+6xOlBNHuVUNX2wLgjukTLHf3eSGlTbXG9?=
 =?us-ascii?Q?thRB0T02dY+EBql6OSuVC4QGUwETNJhTF/e+W9+NzIgZpP9FVbhnwbXFOyr8?=
 =?us-ascii?Q?lx/QD81BJfUwuO7zlQPH7cQ7a4CVzJCqO0nkHO0ASuGs4n0BSroBySSlNQpK?=
 =?us-ascii?Q?jB43YgYfyMvJloK4IoTZ+vcxrUUayDTN6WFQ/HDvdiOVJTRJrPOSYcHdrU9I?=
 =?us-ascii?Q?7R7cVia9FZE2LqtAAYLJTdcUYa6NqOu48PDT6spyXdNYRbeiF3u0SYl3S6Ex?=
 =?us-ascii?Q?ZvYTQOpo247Bt4g3xS/OoCgZfcqUflH8pJeP11YE1HffAbqXYkz0ypHn+zwl?=
 =?us-ascii?Q?TA+fgGb84SoDqQlqS+bco0XDMTPARs3LNNwQ1+lUYrE9j9Do2aiy0CxpMrHQ?=
 =?us-ascii?Q?gkvhrOiC4Oz8PdvUt4/tP4f5lvyLkRQ1WZ/mGNAasWcszcE0K1bul4OMBnTS?=
 =?us-ascii?Q?2KgmW/+DKadXJ7MiezLi60MIR0og4jpIOxFCBwAkzxsEsJXBhyjYRFMeYrX2?=
 =?us-ascii?Q?ZDIAVaM+xjS7+0QsGbO+y9Oh/NO3vw7w2omkEi+yqnpDGbziJ5uxeknQb81o?=
 =?us-ascii?Q?vkKobXUfvXFn94XycX9jaQWATxhL4hJcrYd72si1DupRsLQ1L7VaIRIEfnUv?=
 =?us-ascii?Q?uDHh5nq8xr1ObwGpPiWpCyMf2Uh3TaCf9q1v4N/U?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8f0d1b2-f941-448e-b7f2-08dcc0fd1b9b
X-MS-Exchange-CrossTenant-AuthSource: PUZPR06MB5676.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2024 09:47:30.3538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CPZw9upnYMEex7Styoc5pRA7/7N3ve0+jsvotxShn+M3VV4CZBLlNs8cLjmo6pILKaUZwkm26SFOnPKrfajt2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB5829

The devm_clk_get_enabled() helpers:
    - call devm_clk_get()
    - call clk_prepare_enable() and register what is needed in order to
     call clk_disable_unprepare() when needed, as a managed resource.

This simplifies the code and avoids the calls to clk_disable_unprepare().

Signed-off-by: Huan Yang <link@vivo.com>
---
 drivers/char/hw_random/mxc-rnga.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/char/hw_random/mxc-rnga.c b/drivers/char/hw_random/mxc-rnga.c
index 94ee18a1120a..f01eb95bee31 100644
--- a/drivers/char/hw_random/mxc-rnga.c
+++ b/drivers/char/hw_random/mxc-rnga.c
@@ -147,33 +147,25 @@ static int mxc_rnga_probe(struct platform_device *pdev)
 	mxc_rng->rng.data_present = mxc_rnga_data_present;
 	mxc_rng->rng.data_read = mxc_rnga_data_read;
 
-	mxc_rng->clk = devm_clk_get(&pdev->dev, NULL);
+	mxc_rng->clk = devm_clk_get_enabled(&pdev->dev, NULL);
 	if (IS_ERR(mxc_rng->clk)) {
 		dev_err(&pdev->dev, "Could not get rng_clk!\n");
 		return PTR_ERR(mxc_rng->clk);
 	}
 
-	err = clk_prepare_enable(mxc_rng->clk);
-	if (err)
-		return err;
-
 	mxc_rng->mem = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(mxc_rng->mem)) {
 		err = PTR_ERR(mxc_rng->mem);
-		goto err_ioremap;
+		return err;
 	}
 
 	err = hwrng_register(&mxc_rng->rng);
 	if (err) {
 		dev_err(&pdev->dev, "MXC RNGA registering failed (%d)\n", err);
-		goto err_ioremap;
+		return err;
 	}
 
 	return 0;
-
-err_ioremap:
-	clk_disable_unprepare(mxc_rng->clk);
-	return err;
 }
 
 static void mxc_rnga_remove(struct platform_device *pdev)
@@ -181,8 +173,6 @@ static void mxc_rnga_remove(struct platform_device *pdev)
 	struct mxc_rng *mxc_rng = platform_get_drvdata(pdev);
 
 	hwrng_unregister(&mxc_rng->rng);
-
-	clk_disable_unprepare(mxc_rng->clk);
 }
 
 static const struct of_device_id mxc_rnga_of_match[] = {
-- 
2.45.2

