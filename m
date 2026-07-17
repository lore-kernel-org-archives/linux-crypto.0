Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013046.outbound.protection.outlook.com [40.107.44.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17583DDDBE;
	Fri, 17 Jul 2026 08:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784275323; cv=fail; b=LyG4hl7vHrgP5qdPtKHsUlpK+Yyvs4SnrQsNROGGkOB2LmCuq8PkTM93h3I60MWt2K3BSqW/lUh77//oaLzW0kaFYc63O7KQ+JyKzlCIwUuZjMX7hj+8zXrge0KRIlLcUeeD8rTqF46/lumjXY0jblrqKLpB1MlnaNaqbnRZq7o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784275323; c=relaxed/simple;
	bh=4UOt09yKfnAXIcZ56wwcK0oy71scrwyM9441l+HUTaY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mj3hGq/291NwmZXsuvuDErt+5of/JPqKoKeXY5OPl8IKuh26+BqFl01WRKpJAnDmfcZLw7dNaec9/ktiK7b5T6qAtuJu2groJdZhA0q8YgNZn67PT8zsanfLydEXQ5JhDgDgibcgsnyr6HCFn9PJQrsKNtFGF1pZnI4dlD8hGAM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=kr5L5uIy; arc=fail smtp.client-ip=40.107.44.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="kr5L5uIy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vo4ZA5M+tSxSiocgrUgPJTpEzCDt/YBAIz+tFdDw3IMrCVA4gYWK3sZ3wUIRmy0UQmoUhL1oM4vi1GZFbMBpWSrASapOK8o73NMNrll4vuQY/sQABCU9RMGXfYf+0YYLVfQ1A3hlOyJhr7zQcxlJi8SwHASmeSXkXtmyTSRoxLVrfowH0B+sSV9LqIbDzaYqLKCb6CHcJLflQBRLt7blCTkMAOATlnA8b0bfQQU5b5dfdXzRZ+41DuMkH1oJ+WVkqyhmAMnQ892t8ReRVF+IGgoJLYft5wYp1d6BirLvGEqpubbP5G02ghEb98zTDlLODbvHP0RWlb2W1qOfr+hy1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k8zUZjI4MroTTRWh1jNpJLdbkqbz2xwV7MrVGAeHqlI=;
 b=v/qDRNv3d2N86PoR1ZYOb5oOwQeaYVMQ/OglDT/nfhLV7ZeMHSeWM44EkU0bvSpaG8QeSWoHJksipArK4dGXHzh64UA6Djw2wwawsoiZ85NtvTg4kxYrjbstWChct1QEgJaACtZMaDLefZBAxz0IxwIURutqlUy/NXxkKyfvMHR5nq2pXqoiRMqay0lQo1S+SD9xrGNxU8qM4+uVm/+UX1uZWymkCHdisu+LULZuux3ElWOYFxArNusOZH3Nnh/HNnq7nxaS70+L4zJA1EzmoBu4/Lf+K0byUukXGw30W0fLiVK0XVxkRXhKsky9Ami2NE+kfyk0TYsPThU2mVammA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k8zUZjI4MroTTRWh1jNpJLdbkqbz2xwV7MrVGAeHqlI=;
 b=kr5L5uIy8k/+qR0CThcfJfInIl9xb2Z/i8kxc/h/MVHqO6XZcRFHMVzU3XY1Reky+cPeVx9oNiE6/dsYBMnbSAJwemvISqrtipcQy3gm/9hAvFGdvWShg9XxPEXSegKQE8NvoNJUWXMOkpjY2b/pHucx7ItudzSudwd7ei25vfzZoqxiba8Nx9KEh8KxXrEFq7ZkESQLh5M085QfQ0DXNSyourNF0ZGQ10zWkbE1YcP6JEEVTHKckBB2RD2MDuzBpwZCLsh/DXBgB3ejY2vjolJtupDi3O0VP+8HKVnNuBfvqnz4wF0k1VyN6WGwXXl75SncpgKezyp7pEtdBBGi2g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5832.apcprd06.prod.outlook.com (2603:1096:101:c8::12)
 by TY0PR06MB5104.apcprd06.prod.outlook.com (2603:1096:400:1b8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Fri, 17 Jul
 2026 08:01:59 +0000
Received: from SEZPR06MB5832.apcprd06.prod.outlook.com
 ([fe80::f98:5e32:4ccb:d07b]) by SEZPR06MB5832.apcprd06.prod.outlook.com
 ([fe80::f98:5e32:4ccb:d07b%6]) with mapi id 15.21.0223.011; Fri, 17 Jul 2026
 08:01:58 +0000
From: Pan Chuang <panchuang@vivo.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org (open list:CCREE ARM TRUSTZONE CRYPTOCELL REE DRIVER),
	linux-kernel@vger.kernel.org (open list)
Cc: Pan Chuang <panchuang@vivo.com>
Subject: [PATCH 06/12] crypto: ccree - Remove redundant dev_err()
Date: Fri, 17 Jul 2026 16:00:20 +0800
Message-Id: <20260717080045.191538-7-panchuang@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: 87f0af6d-fd54-4ac5-aaa6-08dee3d9ad38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|52116014|1800799024|6133799003|38350700014|18002099003|22082099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	EjobC40fsRcdQK/PxbSSsRIF1i9y4WYTekCo0eT3bniIXIoWQnHl0RKTrOo5ugqmI9IHY/yia6VNs4W+VPaRdXPcwX+uPgGZDRhIkcrVdUqYAMYsfzdwvQMauKvuNBO0AR/WGKiG0sOcnBY0cdQ2XiI/6ZByYIqdMncoEirqeBymShZEdTRNNi6JeY9vHW6iy3+QKEL4TmbFoaqf3EwO3EYR0df4dplgKsdDZLMupkvmRiqKY8/MffHiiqrucEXONOPeHxjg4SCU3mp5ug1zhglUMXM6dhw0rWNzRZSvIgk3EKQURq/bZsbraPAnKP8OsYXuNbjIMSjHVHli942xN2xxWz++z3b7zAs039x6VuVmhzulgAsfpbB6LKfBbwac5mJkWDZAFaB45RVYQmjh3PJsvRBeNJ9VLGUCM7mIt00uAyDBkVHSAI1O3giAcFsWuCKHH9AXnrTM5L/BaNxZWnuYgET6yEUa2Pya7hkRJzSosXimURcOHV2GqrEZ/XnoOCX9qDkPbXTvi1rozge4wyn5K3wIl56E3bcWU6oKXlL5FG+R2265JcYhP8/twwqT/fOFoMxmIbLAHIZ3RCI5eZ9KG6Cy8aITeBM6H7FdQI7YiQSzsP9MWxKuYijYs7kuubW5jSMsEFludbNfhDU0ylLMyisD5IZHpuw5N83iBMkX+ionVuWBTkSkFLXYMSDolS8crVwBTpexStFZLTO8a03Ko2DO9Pw5Pv6z3Ab66c8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5832.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(52116014)(1800799024)(6133799003)(38350700014)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?y3rNvczg9L9FHr34x9uotbbV6cjtb3QaKfdzprBc/bPipFQX0QLrMq0mT03C?=
 =?us-ascii?Q?oRvnDgRd+B7Posta+jXMHm17iwrc5ArvLlpMwaGaih53eRu3QaXSnTqXjHrY?=
 =?us-ascii?Q?x1jlFJWEQrv/q6tEfZ39fSg+ZjuUJTVUN89GTt4kMswlbUHhVc0UXvQYNvdF?=
 =?us-ascii?Q?H3or7yHpTo/0TLKbZ0D4loR7pB0gtoX3BraUN+toA/CqrY5QjyyL9wL080XK?=
 =?us-ascii?Q?aJ/ylrYqfrMUUxgbyBp9Rq1aqPz7yQIcZ19YX41vZ2Q+7Ru5L3TKCSVQQBtu?=
 =?us-ascii?Q?xHBqTqESrTGPtuscL3sg7dzoO8GDAu+RNPJW/GLpF3p2WfFtfmfw8evkFiND?=
 =?us-ascii?Q?zIfwheDMXLoS8sRqrBn30EUUYccZDjGK8ni6IDXAfqZpKWzqawo/FUTGnnhD?=
 =?us-ascii?Q?LS1ZgpX4meq73bXdqsG+Ga3Is5Lap/E4ggqxAZ6wtZMtd7lJaoQ7EuGefp5E?=
 =?us-ascii?Q?vSWpfntZz3haBCKiG5I8Ez9dBwMvAuR0OM0gg0uZOt8z70bQ2HEut14Nx2b5?=
 =?us-ascii?Q?vwFmOoujIPIvtpytCjncUkbnmw9nmUd1cGsMSlDeoZsrGWnNvxOrCnFKfpyH?=
 =?us-ascii?Q?ddCjJauUrwop4a1vS/8iXV/4hxKjdqvJwBG4q5oaXhyQAB8RossABtO/xyuG?=
 =?us-ascii?Q?sNmHstJBU+PtovBeDkDjfMeQ1X1+TYmIfs8+MNOD/W1KqHP4v6BCdJKF3vIp?=
 =?us-ascii?Q?4ey+uYPvHnJaLDtKerO0RW7iWiWD6zf1PuG7nFWYOq3fw05Va/jiH07XmDWo?=
 =?us-ascii?Q?WW26DMsj7FyEG3ZWT4DoUgoSJsTK7g4Bi/fzghfdpIueGreb0vdT19aYy18z?=
 =?us-ascii?Q?qODBFPp+LJV2DYj7u5s2fZfqyYzqBrkgiSTvI5yasDmF3lEtJVDq9x76dfE7?=
 =?us-ascii?Q?r2rxY2c0LuOiuUTvFDMpnbiMHXpUIHDwkZMCb25J9+Yvh8uUlC+hoseJGCEJ?=
 =?us-ascii?Q?Ix0uq/xq6HOwcfyIvTMRuphi9Rd42UoT+co0nyjJH+pwvBW+BPen2DpqZLku?=
 =?us-ascii?Q?IZ/im+td980ELE/EZrWRQCxbdk8AclZmU3LNd7ihP2TTGSljFppks7pi+YxE?=
 =?us-ascii?Q?r1NoNbR7vT+AwHoy409FSqsoGksJ+cYVGTQK2ACivuB9/lljJljn9U47JOsT?=
 =?us-ascii?Q?jkf19vP8XDggBB+8eJnRXYQaczGqlkY9qQ+4JIFP+NyOfIop6/f/TxGvzNmK?=
 =?us-ascii?Q?cVf72IdnCK0hs/Cp2D4ZOAm75AVEW0l/DmV9MfYK5ESsob5KUDMieDmCiwfB?=
 =?us-ascii?Q?Y2H+ULqOG+HnZO7nr1fc6kdyVJY432TFHZlAooA7zYpij73nsVVjrP6Q6HCz?=
 =?us-ascii?Q?wZkz9ijJmVt0RQke1xtcE32utFiSVcjA9aVD8jZx8YG5Ej9YzjscKAna5DCq?=
 =?us-ascii?Q?OrP55bMOFJzUga2Xb1ndnIjeRa0mVjmziPqW2HMpqOGBmqh3mzRjnXO90FtV?=
 =?us-ascii?Q?jGByh2GIrL5V3seiLzLkQcftuBAu408yZ6mt0amV1CucO3Bn2le+2ZkJXk4e?=
 =?us-ascii?Q?ax+o4JcX2d7k/TJZ96+JgeDVj0IK2XHbRThbhh2rX/7u1jvWtOW5/zocGNaK?=
 =?us-ascii?Q?GXDqykaHobva78CebxnlPNh4Bzqgu6didj77MwkbP3REGW0FvAdNw+vLTSM3?=
 =?us-ascii?Q?ejM3yKZrlhSsm0W/DLPQjQwGu55ndFQXuaSFqcPsvD92fsU/vreW739mdUwZ?=
 =?us-ascii?Q?mOFi1UlzfCnnVdwiuE0gWx4LiP39KST19rK1WPo9D14sQc77KX27HOxSwH+e?=
 =?us-ascii?Q?JbkmOGPVeQ=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87f0af6d-fd54-4ac5-aaa6-08dee3d9ad38
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5832.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 08:01:58.8487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fSYYRxQKd7lvifyNu7fKec18HoWzH4MnDEA29GRXvClS/7AQSCF+QuX9Pm/4q2idXG88cJ7HHPU+YHG6MkARMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB5104

Since commit 55b48e23f5c4 ("genirq/devres: Add error handling in
devm_request_*_irq()"), devm_request_irq() automatically logs
detailed error messages on failure. Remove the now-redundant
driver-specific dev_err() calls.

Signed-off-by: Pan Chuang <panchuang@vivo.com>
---
 drivers/crypto/ccree/cc_driver.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index 061e68a31c36..28a23cd572d6 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -471,10 +471,8 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	/* register the driver isr function */
 	rc = devm_request_irq(dev, irq, cc_isr, IRQF_SHARED, "ccree",
 			      new_drvdata);
-	if (rc) {
-		dev_err(dev, "Could not register to interrupt %d\n", irq);
+	if (rc)
 		goto post_pm_err;
-	}
 	dev_dbg(dev, "Registered to IRQ: %d\n", irq);
 
 	init_cc_cache_params(new_drvdata);
-- 
2.34.1

