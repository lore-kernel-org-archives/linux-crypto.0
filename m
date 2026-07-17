Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012058.outbound.protection.outlook.com [52.101.126.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9D13E0C53;
	Fri, 17 Jul 2026 08:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784275336; cv=fail; b=lyKNzb8p2efEbho1QxwvEGDRDwf2qh/58ouCw1qqqlCzkqxLZDAdnLtdDMUm/bm5RIH7+B+yUY6IUsS7+l7nGTG7jyq8LshXHO6SWdPLFUGQfx0Hng026N4dwvHtCGZgs/pb7O50ROmoLyB+yjFdLDG2/YtUtUl6PBMVLFcynlU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784275336; c=relaxed/simple;
	bh=ijI3IxIaz+Y6epMW2yonWq30dU9ZAa+IHe+9BVwCp1A=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=B4PAbgqI0Wc1tCvzHQ2sadhGr20VBzpzRgg6/+KR/wj5X2Agr0jUTOpbJoO6zSAQYvO+aj3XQ9W8fiEfzUPTJMcwPVJOyZzhFGF8cOpSBr7bBgdH+imbJ4b2BbvS9GHgWkLYabpmd1N/lJDsu2N5hzQjz3aXTVXq3U57CHOQ2lE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=qXjqGBKh; arc=fail smtp.client-ip=52.101.126.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="qXjqGBKh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RsKN44Sn5pbvZGgBzazrAZ1z0W4IeoSh5Xt33av4OZUZURBzzDmmPjgWQCyHUWspol230dWQ9QL7djq5g3mGNQI1Uk5lfeQ1ZzNAQW+w4Fp8NU9J9MHOp6rj2mZLlSVSytY+wHOk3+HS+fN1OrbeJi6EzT1tv4vTluraMvNfRCDweuUP6H7fiTuskLrnMc200fWdMHTzv7+ozFSvps4U7O75kVeEbvF+c+vSEqz/p4123KUjxTWuL3J3I3ON5tp64OfVXW9wu4oO0SkU6j/VisYL23JaqIoeHcHcjIDSv/tVNB4pkTIW4Nvt3NlDGXFtkT32mb8AfIIiuVLbhex9Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8RJvZs71lr757tt655h6OQgZRBLczniaowR1EDB4cVM=;
 b=vjyowIfvOtJ49P5l31fU9KxCdo3hRdkLsW+8ENch+vdyMRtgpBXtA93J1EodnMizvEgJ1w5/ApUhLFVEaYlkqarzDoQQmbWIwuP4wXLWWv6qafzIjbVFoCFUFmpHu52fAQjdLp2mtFcPaTufilvoYZYgq2jB+qwPenvRVvgLQ9elxPK/+92tBbu5NqdkZStap+I9iiyA+xeCVIWpC4o+xrGgQ9JVVtDgtL/JNAOjUySxivSDzkBY4r2fCq5kUHVVZfQ21lRPKonDXKFYsPEp8RtZGStvXYlAtluQXVtPcqsu5F6URI3NSfbD76AvC2d/Pu+N99Oo0809HiZ6GDjRoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8RJvZs71lr757tt655h6OQgZRBLczniaowR1EDB4cVM=;
 b=qXjqGBKh2JSOIaZKTC696qlzH4I+C31jWXQ6q/jn5nnuKj88I2+zJyqVgPXTpTvxk8URQbX9bJPlz/A4d6i55ODK3fn2yFPWo+JjmCzr+SuWVgIkTizeASFro3GWbdCu9LZcEKnPYueUr4X38IXM/hI7kKpdKPCQpSys3qaiCRdWGDc1AW6uipe/9tuLhdhgwK+2Rzl30E2lqWRg5m5Gtguy+9U5iMIf6ZE9diWYfeoJgadEN3hB2eMGqr1pklDJ8ZIBYReuVIZOZ+HK8R1cCXZj3Ro+JZmljvkn15ZGtNpI8F8t7x4h6m1AXvy737s19m0U4HWu1em5umV0bhep9w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5832.apcprd06.prod.outlook.com (2603:1096:101:c8::12)
 by PUZPR06MB5620.apcprd06.prod.outlook.com (2603:1096:301:ee::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Fri, 17 Jul
 2026 08:02:12 +0000
Received: from SEZPR06MB5832.apcprd06.prod.outlook.com
 ([fe80::f98:5e32:4ccb:d07b]) by SEZPR06MB5832.apcprd06.prod.outlook.com
 ([fe80::f98:5e32:4ccb:d07b%6]) with mapi id 15.21.0223.011; Fri, 17 Jul 2026
 08:02:12 +0000
From: Pan Chuang <panchuang@vivo.com>
To: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Kees Cook <kees@kernel.org>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Pan Chuang <panchuang@vivo.com>,
	linux-crypto@vger.kernel.org (open list:MARVELL CRYPTO DRIVER),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 10/12] crypto: octeontx2 - Remove redundant dev_err()
Date: Fri, 17 Jul 2026 16:00:24 +0800
Message-Id: <20260717080045.191538-11-panchuang@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: 64312247-a4c5-46dc-86df-08dee3d9b54e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|52116014|376014|366016|10067099003|921020|38350700014|56012099006|11063799006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	QfMCR8gcE67g5LX4OvwWdeMildapIKh7ZrmE5x1UjupnYAq7FZgvSAVB94lVwmE55UxE1YXg0EAPALmzsGiyKgkARu3Wk5lLTbXVHkg7WS+JdFH1RsaaRfgp8t5gk/2TzNas/XLlb+4yqyhRjogXU/LxV9daGO0vhb01PaZec5hYDck33d3Oan4zs5SmvSnRwftuoY3JmV36YdED2oUqH/bsht5C2ykWl3UvWmArSLw/sx0p0nMlYhNthU0hfDd5bAaKqfB1/8aibtE+hkvcgksBfOY7L0XvyAoPMm/ajqKwQpfl3CO5nZgeVHON6UPcx/i5W8kbYWEAv75sKcxu/k1R33yeogNgijkjnnMszEMTOuFaAzqoiZijlmsLW6dNkK7WqbTXQgZTc+6gy7TKKWqcE65MSmLxNGI05Z80/D7MMaB8XuhmWhl1NHlbsmGlpCEzDO5+CdVHfEWKLRv8yiBwqnoKGPatvhTysLi+u5Tns12EOrO1G+N/2Jz2mktpkGSFH3ruySIICKwrK5ZwRDisYi6r5602i7lNgFtzJjkHpO8imlXVL+ayjDAz70BBfDrFL/51W0IdV7jWv0C2+yFgZ0RsRqhetAk6YbVrj6hfNgoUlJ41FTUt9GFZKcLAsfdzMCo+Iok7G6uTAZzGZvhEbxFdtrL51xA9AKO4FYiGjnVGaEEB4RsgXHNotOSK8emx1TlLTQvH7jctmt1HwPxoD2ciofbdlqOzlVXGoYIZ1gaFamcOp98SaY1j1PKy
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5832.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(52116014)(376014)(366016)(10067099003)(921020)(38350700014)(56012099006)(11063799006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KWV4iFR2guZb5Ey4dwLXovJE+6DTJ9z0sKTOKT5d1eFdSN11GMoMGHPeymxp?=
 =?us-ascii?Q?H9/NVZm2BKOZsSyQGscuGOeG4hqr+Fe8wVbxFOiDObr3sU6Bs2uld9LU7ndU?=
 =?us-ascii?Q?iGi+CuHxPuUnL9FXyppKF3d53002bN8O5uLADc9CQ89KSwP2sNR/QPTh97OG?=
 =?us-ascii?Q?n+XS7QRNuwhmKfFQ9sDU84h12Z8YdVH6/01VXtDHgTTyvP+nj2ugk324p4Br?=
 =?us-ascii?Q?FnAOr1FzxCc1b0JmQIlIM2TZiSIiemDK0uIK5DMBXMnmnvs6I0VOjkG2xeDY?=
 =?us-ascii?Q?T2s663RVp37gQTqoDLphzhAyqqpNlt5WWHiZKsv2g0l/aRoIz3CgX6f4l7Y2?=
 =?us-ascii?Q?DqrFFUKuu2eJV6rXL+n5RsqbImOIVXx7DQfnhR5QllZH5jQnFzL0QLxesDa5?=
 =?us-ascii?Q?/KnXTiDK8kVCE7kV0xesyWge+uDWaZNJlrB7T8jv29QOmhpjnIrQwhCJXk4F?=
 =?us-ascii?Q?/8Cyvm+AJhfqYSovv/1okIxZAeyyGXMrlRQo7T9hcfSyVnqx0NtgaHWquqPM?=
 =?us-ascii?Q?tPRoa53wGsgv6GBnOuf6aWbH6mXAZFffFOfo1+n5iR1UMxO2tmlEsB7qljt9?=
 =?us-ascii?Q?n+rWVTtnWDWpW/cuINVw8AzEUCt+/Nob3DaL+5frFvc3GJAu8FvHh1BO65Q5?=
 =?us-ascii?Q?yAFX/5pF3AE0zvqcbB00v1qU4LM0e4eie6QW31KSnr6H2dXmiyuBaz4w8Twk?=
 =?us-ascii?Q?iu+nODdA24myOlHkOW0IUUKUCgSdjmquXOPoJNrVXGK+RQ0WAKPJhYRf/Rd7?=
 =?us-ascii?Q?wVEKD9+vDV5xGTqNrIwzKQnk2HRYRh9bjjyTRbg8LnkGjrxdJR59oREjq3iN?=
 =?us-ascii?Q?JZBvnK1D137c75CfZrbXAf/xdQq1D5EFGJYoYVatDZ4vZipf0PtXO2+o6rcF?=
 =?us-ascii?Q?6lzFZFMUuSE9pYeBwNsDWsEOZvrgbBDdTe3k5txrSjSN/zh/6cOuyvLc4YoP?=
 =?us-ascii?Q?kOTe6Nu3fAuioQUL2wHFgkY2DuqfjWlHeC084ISArsYgE8LEbeobx0H2C611?=
 =?us-ascii?Q?Po9VO82ZBeSrDODzmTPyalHCfM7K2KjV1JIUTFiwXaG/MVnnbBC7tEU4ZW3h?=
 =?us-ascii?Q?s2Y2En9bAL2Cp2Cjid//TvseyLgdQQxa9rxUIc9AdaxZyH7SG/xkQ3kTxRCA?=
 =?us-ascii?Q?EnXRkx5WYkrTDM60PGTg7PJBK2Ng9IJJAJEeVS3OyyvQkq1ghQsc9d5+lniH?=
 =?us-ascii?Q?tFUr0iUrd9c+KqmpKs6e/NfpccfdgXK3vdZs5RZXucwqUm6V/lHokkaqkYL3?=
 =?us-ascii?Q?4YQ8mPRFGd3dkgnJ4qvj3ByySAWuFQuheSKIv2lCrusNYHI87lyKSwPytC0P?=
 =?us-ascii?Q?wLpZDB8Tu7E2hOLVJF93llBMaUOZgssoXRaAWLiS3n87+vTFyr3jj3gcJWGF?=
 =?us-ascii?Q?ok117wa5PtaJ3wrlaokcvExv3H6nuTbmW7D7C5lDLTDgmII/TIcuXIxJfOHE?=
 =?us-ascii?Q?aFdKQTK9rXSlvjrv/bp0nCu+lbMT/FNNX8+AcL1E3V0iPLpuEBcaLPicjLZ5?=
 =?us-ascii?Q?lm+osSWJvoLsn/w3dlINgEZf7PPqCopg4t82paDojagTWLkVrmnWDJln8h8o?=
 =?us-ascii?Q?NxhQ7f6h96qo3Rnj7wBpR7dNKaFcJDF4k0KigOt9H1f/xNgXnt8cTxXppsJH?=
 =?us-ascii?Q?0SKohv7ZiDqzlZWEaGddKHwbYj4spPH3QTbAm0GS0RWJAeP/B0uFMmmhy1eL?=
 =?us-ascii?Q?6Y4g+pdJnOx6R80FWTaWD7ubMqaNTf/4MJ9QVU329yYKDnINaam/Dh+r+PX6?=
 =?us-ascii?Q?JDtJ7M9qog=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64312247-a4c5-46dc-86df-08dee3d9b54e
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5832.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 08:02:12.4414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v7ztBkuKM+PHcndMw1uXeKg30n9yovwGVjhhBwB2HwjqSEts5J2P0qmMJJlVTJqO+nTp4dxq8hZ3i0Whk40g8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR06MB5620

Since commit 55b48e23f5c4 ("genirq/devres: Add error handling in
devm_request_*_irq()"), devm_request_irq() automatically logs
detailed error messages on failure. Remove the now-redundant
driver-specific dev_err() calls.

Signed-off-by: Pan Chuang <panchuang@vivo.com>
---
 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
index f6f47f4e5d83..79f6c2bb9d8b 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -430,11 +430,8 @@ static int cptpf_register_afpf_mbox_intr(struct otx2_cptpf_dev *cptpf)
 	/* Register AF-PF mailbox interrupt handler */
 	ret = devm_request_irq(dev, irq, otx2_cptpf_afpf_mbox_intr, 0,
 			       "CPTAFPF Mbox", cptpf);
-	if (ret) {
-		dev_err(dev,
-			"IRQ registration failed for PFAF mbox irq\n");
+	if (ret)
 		return ret;
-	}
 	/* Clear interrupt if any, to avoid spurious interrupts */
 	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0, RVU_PF_INT, 0x1ULL);
 	/* Enable AF-PF interrupt */
-- 
2.34.1

