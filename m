Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012023.outbound.protection.outlook.com [40.107.75.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39BF33DC852;
	Fri, 17 Jul 2026 08:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784275307; cv=fail; b=jhC4XeH7msp5VWmQb/EQom33wyb/PQ5UFYN+vu7fcM1O2f6+Q/hgk+myaqJeiUftWDMpdZZ41rmMUiOxeJaHO+sLF0XTmVKP3RQcA5v+hft1CMMNk5iqOM//vYU67+SLeigQbac+mkFYBK2cvvSTV591zLCp0EqM8ZDuQcHyKHE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784275307; c=relaxed/simple;
	bh=VHGAZnZmWgWg/V8wog9wevwKesRZl5KAm4I+n+sr41c=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=d9aj6zQdHAqw2L+Xvs1mHYC729vBNNMiCLDPdkj7MxwoIFrjrHROHF2Usr/qDSEIbPzt51D4FlJP9pAlVvUyDc3qCfefEM/sF0QjFuwRsEI18jfHTWcUzBCN3GZ18roIRmAGFRL2NvWbjW64gONuv1Dc1teAgeoIZ7EPG96fym8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=IwtgQLl5; arc=fail smtp.client-ip=40.107.75.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="IwtgQLl5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eMC6M0zoqvIgIDo9w96VOe3H8fPgAzmEuxlbP2ezcOIRocFQitfwdcvZOcDUP1wkRVzOzMxrW387be106go/n4bZ6uvkPzXCUBX5FLlOFUZYDpR1BO0XABD0oeqTIu4OVIwlpOqDyaBFPnBH3ylSI3uKgzY9uT6ysUP2QqzpzXa1dozODEGeLUeGlgj0DzhclXAuN+Ap/8CbCHc3NVWPVGMPPYGr8CtQBPsVfh15zsAYdx4Qc2Q1a5DYrXZPDhvajHIUniXSiotW+D3z6ThZcqrevnVH3oArds0moexGv8cd62zbwCW1aX3DSKYKGnN8S0EAlAJErEd2WP80E7Fxtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yTzOXtvYwYjDyaMaHPrHloyzDCxfUsO1z92HLjAYQyA=;
 b=Yk+HIKt50wVbOyConZH+ePTFPiUzIh+h7h1Yio5FDWD6mKdIBOnFdWgdl4xrws9jCAoxS8aFbZ1WabpRj0MA/O720w5Vwg44ociIoQbDx001iuHMBQ5Zx/Aq2wF1dIxIn/TO45G5vc8quu7kcQhDQhyzSXlxmJbXxzLWhVrL5gtlEX4VF1EsYvPEIWo9CJ7K4S063LALMx70XpoiHKISK13w76e1ReRhy0Iv7kDTqO5s9m9muxkeeg9fA/VbtG7HIq6an5YDxYcjLEUTwAk9d7J0qcDZT6IZ9nZhT/GI4E/UZq4m4KBASsaugxxm9BBEWarO8Fcgtr+Dv9uNo+VMzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yTzOXtvYwYjDyaMaHPrHloyzDCxfUsO1z92HLjAYQyA=;
 b=IwtgQLl5mkGCdK0iWMTmgKiLJZHUwXHRnBk7fytPriKvo+2u1XT7cyS03wAb+1Mv0E39KqyTb2yfeDwLAlcOvI7vI1nqyy/xjziO4vIryH0Q50WHtSYo3D+D52FCT7A27g/DtFmathxALzoV3Mvpf+Sxo2gPSuNitQFYHqA8QfRjI/yCw0CgbVWcvYnUyofpaPB9DoXgwXaJwk1KqDU2FRoQ0iDz8Sg7mfME0UT3i/a5Kaz4DXZOcuHsJGvEAmOkbzUbSqTe1DisRjAnCeDyRnT+45HLXrKcHUImCnHyCXHXKzD8CUN33MMhYzOcQMST0Z+/NcSBF6wQMY+z2JCiTA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5832.apcprd06.prod.outlook.com (2603:1096:101:c8::12)
 by TY0PR06MB5104.apcprd06.prod.outlook.com (2603:1096:400:1b8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Fri, 17 Jul
 2026 08:01:43 +0000
Received: from SEZPR06MB5832.apcprd06.prod.outlook.com
 ([fe80::f98:5e32:4ccb:d07b]) by SEZPR06MB5832.apcprd06.prod.outlook.com
 ([fe80::f98:5e32:4ccb:d07b%6]) with mapi id 15.21.0223.011; Fri, 17 Jul 2026
 08:01:43 +0000
From: Pan Chuang <panchuang@vivo.com>
To: Corentin Labbe <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Pan Chuang <panchuang@vivo.com>,
	Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org (open list:ALLWINNER CRYPTO DRIVERS),
	linux-arm-kernel@lists.infradead.org (moderated list:ARM/Allwinner sunXi SoC support),
	linux-sunxi@lists.linux.dev (open list:ARM/Allwinner sunXi SoC support),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 01/12] crypto: allwinner - Remove redundant dev_err()
Date: Fri, 17 Jul 2026 16:00:15 +0800
Message-Id: <20260717080045.191538-2-panchuang@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: c50849e0-bd22-4af0-65ea-08dee3d9a412
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|52116014|1800799024|921020|6133799003|38350700014|18002099003|22082099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	ZnsdV3NSAAa8TugWVC0RDeCKVHGHR5pFK14LPWcYFAW9K3NjOn7XypBLHHxp+exEBv7DpraFPot9AjW2M2Vv0nmBN3faMeB5S4HlCgHHGShNpihuzAFA7tXD4MyQq+1/STBIELqbXT+v1cqZOl+DPX6viUDqqiKDR00338hDNo3KwISIA+7GCp3mfb3vfq09HA8myrtCyIMNpd1efVDa0NmanHkgsIJSnrUTCyPzAbZErd1CF/qE/2EYAnk+KOnXOTDzbwDpXUGrb/r9BLrCEjMTrlVeKqxv362K3PasFy+dvOHiZet51aD6drHbLzl2V9GbRA6VfMJKTBM/tXibVNMnLDr+Qhc3FflWJAgjpoey4cep8EdTnUV1Dbxpclr+QvtmYZx+OHlr3DTrRNY9GDU53pBUMXdKSQ2HX5TbevA0pKgKR7+/fP0myIbR2HEabqStvK8qCi3jRVe6muTqH+AiOYGRWvuP1MpQz8D1kY+XT2kRQK0s67tLwWR51XARPtyaYbiVLWDziXsDciO0fSR5EoQYxItyQyVUTWr0uwiYpqG4YIdNFw+XFx1ROG5FtVAy/1FCSyUTXY4AbKu2j4JVb6aiE7usbJ0PE+TdkCIzUftWu/bRoKwO0mvt9YECBxW+yeGfJOIBxG+o1hJUOETc6hZpP3m4tMxk/1prwX8TZI2ecufe12Xa3xTTfA7GvI6jKa3j+SVNLmJ6N2IBlcda31aL5EzApMWbz+Z1fzWAXqx4XHJ9GA0ySCOKP7rB
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5832.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(52116014)(1800799024)(921020)(6133799003)(38350700014)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0OtQjGgJ2j+qTI07d4RjQ8bfEZ1omPTCfk71nfL7GRurjZyXDR1QPf8JDWGo?=
 =?us-ascii?Q?1z1uTXYHVcSrRLifdgyUIt04+XZW1RnRLdMHteULLi5TfxcxbryvTayK+PMv?=
 =?us-ascii?Q?lCqzUTeVluNpzVkov+xkih8C/mJn38Kk2EDFtiXbIrJnoCBCbT6rpxyrAFlT?=
 =?us-ascii?Q?WZlqHe37xhKsTUGE+OujQ8arEqeXg+in71tCl/447lIIwNTpaBJ+jDRf6nzk?=
 =?us-ascii?Q?uD7OoeO+lcARRCZ2oJQuBfrk9+sSxBLa7xhPSpy2lloA5gkc8Js0tRSgrtNp?=
 =?us-ascii?Q?vPcg+3Qh0YeTmukYt3AfkZwLFSFv4ePnye0XCQzq8jxxm/ERNUwkvt+2v47s?=
 =?us-ascii?Q?/0c9A4HFwId1LazRCklNL55YyfYw2BPPfrSADKVG9epEpeGvoWQ3JNWqKMc9?=
 =?us-ascii?Q?o5On8poJGTQyRGCVcFaRjWME3yyCq/J39cgOgGZ3iel0sN+uFeg7cmJi7rBv?=
 =?us-ascii?Q?lRKAvFUaQWx+sGuDGRXO+2+mnzPZUQfi254dU+h8oYpi/R0wNnmp+thPnhuP?=
 =?us-ascii?Q?vyfsM9ZLxdZpyvVilgJsZ9En8v4rkC3gkf7F9Y2LfT8STKwyPhArlzCKggnT?=
 =?us-ascii?Q?/MrbPKxT/LQ+mS8ChHPRJwKxDguJwf7Ig2xrHHjlE6K0xnfGXb9EPfFWhGg9?=
 =?us-ascii?Q?/McrnOD96Pkx7ns6QjKtmsA4/5VxZqJCQSAKWx2PTKFniKelmnUCKsmqDnc3?=
 =?us-ascii?Q?yqY9yMd3Mj3hCYxmfnNpzLC1mWUqhiINTY3v8VJPzEiF9W6WzhMHs2qzmAut?=
 =?us-ascii?Q?CnlKeNmQlgXk4Ahxl2vwWStcbHALlFSAJFNPgsvjZ9B0vmo46ZAjqPeAUx0h?=
 =?us-ascii?Q?/gv6VR3Vjrge6sQM30QcXBbYRSyl/gxH22PGvwy4EorNFiaQlds1fpMnh+GP?=
 =?us-ascii?Q?jPXJNz7ngr0zzTJOFMSveiW029rmnN4utkmKQfEfsyrG7li5opbGOFsr5vjP?=
 =?us-ascii?Q?YkidIcYAGdCoK9u0bGKV1jCgmXDyIt1249YzlG1E0nInPAgS6wWjipqp9D4o?=
 =?us-ascii?Q?vD2GN4OmPpAM2BuuX/6SaIGsqk2Yt1lHfBpm46dykIGQrMEC67Q63DOeL4Uw?=
 =?us-ascii?Q?cw0sRkjrRBksYLCJqjALEUxJ/GpB82FYFZnFwGfmjR+vERB8WwfPpGo/NW8i?=
 =?us-ascii?Q?QhOsnM58iLFZM2bxbtB1KtnZVD+rAnFxKi4S2fLALDT9eLduBBWe00maInhF?=
 =?us-ascii?Q?1WjvWXFJAxi+hxWR7V01SZpim2oHh8MU8y/rvff9VFW+kVNzHUcGfrBJmsBY?=
 =?us-ascii?Q?8T/ZHH7sI60ImGhl65ITFm2MR370bE8L1zt9Bi17R9zM5Uzryu2uAoaDkefS?=
 =?us-ascii?Q?ViapDO9tqIUKHRwKNO/zzwX/EYhgk/uimYm3Ae+O3JvYm5Cc9mFvZNqEazwn?=
 =?us-ascii?Q?nMzbDvxUiL0TjpB51uzir21DBf6CGfZb8KnpbrjhuMZeVOETOD/PBXHLxtm3?=
 =?us-ascii?Q?g/ynW/Kj8e2NfBSr6FztwcCRqeaWWdZEkWm5ktLjtaj39NzbQYYTKTc4Jq7V?=
 =?us-ascii?Q?or7l2nI8XwvMLb9nSPn27KhXrgXSgaZU00i31BRUW1yeQngiIEWHUZhg25in?=
 =?us-ascii?Q?m+zqxT9VKg2wNydpu0IGF6hFEzpt6ys0e8sc81/zHFf8kwGnLSiudXr+Zz1x?=
 =?us-ascii?Q?nu8Ae62KkMW7E1nDe7fgvajw9GraiHTZoiA+Id6nqE8Lcfzq8DO3KDsPM5gQ?=
 =?us-ascii?Q?mZqaouc1VvwqiO72kZtk6rMiHSOCJgY/seF5XUfaercXp03ddVXI4lw1nXcb?=
 =?us-ascii?Q?NM8pImqM1w=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c50849e0-bd22-4af0-65ea-08dee3d9a412
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5832.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 08:01:43.5075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J0mNuOD9KVRFi1XMagiYCYK3GZKsJckIQhYnsopfMfihtPhblE+6FwfSAW4DmxtXXPRnQKa+rylXKGVqDHoc0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB5104

Since commit 55b48e23f5c4 ("genirq/devres: Add error handling in
devm_request_*_irq()"), devm_request_irq() automatically logs
detailed error messages on failure. Remove the now-redundant
driver-specific dev_err() calls.

Signed-off-by: Pan Chuang <panchuang@vivo.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 4 +---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index c6402e87f8a0..21762bd408e5 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -976,10 +976,8 @@ static int sun8i_ce_probe(struct platform_device *pdev)
 
 	err = devm_request_irq(&pdev->dev, irq, ce_irq_handler, 0,
 			       "sun8i-ce-ns", ce);
-	if (err) {
-		dev_err(ce->dev, "Cannot request CryptoEngine Non-secure IRQ (err=%d)\n", err);
+	if (err)
 		goto error_pm;
-	}
 
 	err = sun8i_ce_register_algs(ce);
 	if (err)
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
index 0b22fcddb882..2167dd9f44c7 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
@@ -824,10 +824,8 @@ static int sun8i_ss_probe(struct platform_device *pdev)
 		goto error_pm;
 
 	err = devm_request_irq(&pdev->dev, irq, ss_irq_handler, 0, "sun8i-ss", ss);
-	if (err) {
-		dev_err(ss->dev, "Cannot request SecuritySystem IRQ (err=%d)\n", err);
+	if (err)
 		goto error_irq;
-	}
 
 	err = sun8i_ss_register_algs(ss);
 	if (err)
-- 
2.34.1

