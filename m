Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013033.outbound.protection.outlook.com [40.107.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3352EBDE0;
	Wed, 20 Aug 2025 12:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755693489; cv=fail; b=A9U/24P91ftZQAgWMhuI9EmBJPgU/2lHbxjqCNrQuf/eLldVeM7SWL/PK/j/FKGxVKGpe2ARz6srWwmyQTPUl/bZM7u8/A8iM0MSL0gt7QFQxDTz4BnU2viph6v2Y4tiomSRrrHEC1RcNImXG9IRnB5o/HAVl5hT2LstCZmmlE4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755693489; c=relaxed/simple;
	bh=mo8PvlVNZ3Xi9Ug+ldNygfQMUT3Ck6Wqx2TT2t0QlyM=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=DpGZscI4h/5M1jweQte49ePtnVAsu678vNRAikwNgjbaz8ONYLD7T9vxKXhG3TakrkldL+haTqc77MuvjL+Z5HqpOW8hw8+3v/YnQpmKRPLqFsPT5jrle1YajlOIRJpIG6gZWdzFG3TGGG8UCN5E9azoUd0kLSM/WdjrMKalmmI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=gBxZT6Qe; arc=fail smtp.client-ip=40.107.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="gBxZT6Qe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rAjBHnz//UFI1BHgs3QQ6ICzGkFEK7Z6dRWZxkESWmDCsSYrkgQLNJnHbs/ZzASGPDLhRNJ0vm4qGLh5E8LR2OLsxwfwBFpWMDkVVtxM7nRo0j9gfcQylPGTR6SpwDjr3DUbbs8HX8I3GJcpel1+t6LI7yfP7snyYHGKlS99gBDzI6+/zsFPmiMxa6QZLgJqN8u9gRscA9PEgO6FePDYPG2KqssjW5qHlLaAlNYNRQf8oafKT2VhRot0tKNqT/kFBOMqQzyPWTHbYnGLzgQBFXPI46XfJQRXGrlqj5xfJURFNBsMHU5vFYQXeFT6SKS5zVBpkgrISN62dqP5fLjKsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5UbJbCMRRdrVMhWppMFhzNWTEDVGchRpt/6bb5Xk7XU=;
 b=nZVDIeXtTbuo0tiQ03Ma3LSvWyJYU6ctBPlSfM2+IGKG7lqCPs2RiXz/wI9N1qiAk1hEgPYxSr3j5WQ671Zkx0uPd5Hkc1BXau7BNeQcW6FG4z+AyyEx+frD89hrt3Gii6IRqD0ZbyjlE4B+R9ALwJ9YuCcpror3/mXpVRiGhssprpJZeHDqgRA/lhqhwv1J3k/6g10IK8yAga4ckuG2ltcZbt9s6hpJUcHawpU9k3+CCivL/Ja4V39qDI1ngj1I+CkiRo+8gSH0QXsvejn2EgOK3XVZ2uHGr16GdUUa+2iZASrZiprHSy5wAlgdlBQW+U+pw9iADnf4jeOOHCdQzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5UbJbCMRRdrVMhWppMFhzNWTEDVGchRpt/6bb5Xk7XU=;
 b=gBxZT6QeluUl7MJtvXTT0DHQJYy41AsG6BLqZeRZHHJxQUlNfqWm1IisV6Tpk9PphExbHRHbRMqLJGRNhzTFbgZ5+MKYNZ4h6BBW7TEhEUVuCwgiyRzcy+ICFwEzXQKpJVv6agE9eJmElycnNdpr1ucTJEXWHuzdn1OOObGPt4MiCdIY8YGLTCI1v/z2E9D2ly4eyoIC16QDDcZzVTGp2RN4xX+HE+U6yQP/71B3qa0zJxuUGq+6GDQa6UpWy2HdpPFpfUxnu+/XByHCakz5CHB7rQne2kZJ8Q3t6t384Nw0SIf7KG+aICdMXMSB5W3QBT27EFoHcLuJ0S2Ca8TU4A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by KL1PR06MB6448.apcprd06.prod.outlook.com (2603:1096:820:f2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.13; Wed, 20 Aug
 2025 12:38:05 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6%7]) with mapi id 15.20.9052.013; Wed, 20 Aug 2025
 12:38:03 +0000
From: Liao Yuanhong <liaoyuanhong@vivo.com>
To: Akhil R <akhilrajeev@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thierry Reding <thierry.reding@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	linux-crypto@vger.kernel.org (open list:CRYPTO API),
	linux-tegra@vger.kernel.org (open list:TEGRA ARCHITECTURE SUPPORT),
	linux-kernel@vger.kernel.org (open list)
Cc: Liao Yuanhong <liaoyuanhong@vivo.com>
Subject: [PATCH] crypto: tegra - Remove the use of dev_err_probe()
Date: Wed, 20 Aug 2025 20:37:52 +0800
Message-Id: <20250820123752.473172-1-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGBP274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::27)
 To SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5576:EE_|KL1PR06MB6448:EE_
X-MS-Office365-Filtering-Correlation-Id: 68607ab4-e245-488e-f449-08dddfe66787
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|52116014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WpNDcMdobQLjGNDQb6rnLsY31SFE4EgHuHdCgDiJH3UyEXpfxrOgp7PNx+W7?=
 =?us-ascii?Q?V8S9hgXmKT0w5inIstaeZ2sVPH3OxLKK6DBz8HmEZi07YSAgirn5g/IYeJgC?=
 =?us-ascii?Q?ouBZn3fzgGi6KcEspCIAhvtfRwwtvmwSzS1f8Ep2KLOjm6z1v+czSvYEe2u+?=
 =?us-ascii?Q?nSP/RK0V7K8yvWhq/xQS/hVjp/gQMKsKGYsU/roelcFD/WuP8BOvjIf+P2hV?=
 =?us-ascii?Q?7P8T8pwKGwxvVEfun3kobO24j8LLVvovL4COaqysahMqoIx0+rFTBNHod1Vj?=
 =?us-ascii?Q?5xBBC4JHusa2wr2dhXa0Pts+lYRSHyKe58DZvNhaFjr/8+LutFdBxC+of24E?=
 =?us-ascii?Q?5th1vDoSWKfjRG8ExcIoWloH5SEKgKchgixitm+qoErNwiJc2tVdDnqlOMTn?=
 =?us-ascii?Q?Kxs9ZAMby3UKcFNCwCGeZSaxEScGIAERXQc6vKok2qXf49cCsF+wzJxjUAyC?=
 =?us-ascii?Q?02klh4bUkgvVtx48NIXwrP23JM1QJi3EPWcQSCziNrA04Em4+VQUgVQpgyK4?=
 =?us-ascii?Q?Z66ZpqU95EWKcoGe3SxbNOSvE3ftk5iCHxqvueWGjJ0tZ/5zWwnbEv/17n2q?=
 =?us-ascii?Q?v3TJ4B710FKMXZa6tPP396X6Q45+DLkcOVYxx97/6bSPUtUvBS5+xhy2zaLd?=
 =?us-ascii?Q?X4wqMcrXnQN6hBRala3IaZgO5v1V6RiWVICiq7JCSLtWjSnYhcAFXsjf9F3i?=
 =?us-ascii?Q?6w81knux9/lkJ0Kq+3O0RGmHtBxU9nI6PzkF4/N1c6+iC75K/C++omsev+T2?=
 =?us-ascii?Q?u25pMtXsy3PQx6DEgr5Id4hnup/J7CRYECIFyDV5Yl1J6miECwHjDTwoKhtU?=
 =?us-ascii?Q?0c4QnzVbF9wUP+11UsiZzi5hNjAdho/0TEXBrgQMY9yj1KhxzI4t/RGj4szz?=
 =?us-ascii?Q?zLZWkQSKDAy06gvZVdABcTt7Y2DFCViKpVeBr0qItrMiWE0hSrLq7pV5WZ8A?=
 =?us-ascii?Q?2Lz+s+Deo+fR2igtfRFTmzxIcLmjeGVKBBfA6TvgxyW/69i9yXaKSWnhVk50?=
 =?us-ascii?Q?vxak105qq3Ed9BpdzZIB2sTScNMF4OddN/BvwMwhMzzuTkMXFsd630HZ92We?=
 =?us-ascii?Q?8gk5f6tP1l3rOCo2FH/vtLsZ0VycFWryzIdf1cI/Bkmpek+jXAkV/GuWQgW2?=
 =?us-ascii?Q?UehTY2AMGuBcVT7GkF14+bXE8YE4VD++2hPQlmI1lze9I8fhGjt9jcXzdj0Z?=
 =?us-ascii?Q?61cVY9SJpYw650UgQCakMAkBKIw3QbJuowXVtqE52uWuQXdKTAhEi2RKwU+s?=
 =?us-ascii?Q?Ajo10n6qi3QQ27bD+PdC3KWjq+ovOJeq794YAdnJFjPJbJJZjvXwHfhpE80Z?=
 =?us-ascii?Q?d7FvlK+aNYd6924RuiwoJlsrfucrJlWPBA5FJ2lczBDl60qLYTI23ZC42orF?=
 =?us-ascii?Q?kdqHaulMA4mPB8iJvMDoS0JiS/yM/SQPVYV3iPv2aJ3UJ79Ut3Qj4YPUWO63?=
 =?us-ascii?Q?UQw8UnGHv1/i4IwCDAAs/QfYLtjaInh9V112unimi+lCb7WIUdCNCagd9739?=
 =?us-ascii?Q?aZhOKZEzm0YjPoA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(52116014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xhaiIF2IvdjFHu2P5KaNWm7GSahAwndQOU3/RmII2NbUxTshwC2iiDEQG2Se?=
 =?us-ascii?Q?C2fW8FpI4XgxhrsXn9WjQSV7Gii1hCxJG99Q+5Q407iup5paFfbpHnyPXJd5?=
 =?us-ascii?Q?pq4OjcOi+xHW6kEXWP1nVIqoy277Hrij1KD6rvxXcBXej7Qzg22Mym/3TdKa?=
 =?us-ascii?Q?ezXwwyGzseyNaAbAs2rxJQLGVjtvzW+tAB/9NB8hS4yc20wO0GMLWxMbvv5b?=
 =?us-ascii?Q?bE6iPMY9xrFGyLVocVXU/Wsqldw6Ymk9R/6wILG1xrGQTANNCyOk63CaJ3y+?=
 =?us-ascii?Q?WB8ds+rlZVUqT/HQtCfvkNIInP0KUHC1QcPOF4ERdwUCexE+Un3ygnex7Jzx?=
 =?us-ascii?Q?Y7s1L/OpgBsCiG9Xhk4Hd27/dD0zuitIsGdCwc28zSZCSuHNZkZPcK36eWca?=
 =?us-ascii?Q?apZITqBsnPRA6JcfgnRtoHW20b0xFpch0M8ptoCgYJY/U12V6zUtitd81pGm?=
 =?us-ascii?Q?ADvTqHFVLTlte7LsGAL69eYG/GnZyWUVAn0aghW0TpC3aA7JbsHP9HyA9JxD?=
 =?us-ascii?Q?XI3YDym4YgFJFUriLZNgzP8lRe/FY9XffVagPV/oR5USJbwJN+zN37pWMyKc?=
 =?us-ascii?Q?UkkDrvblWm6xTC8biYadulTUSU0cL56OZBealR2zhmbg/Jh6a8K4FXx8ngTS?=
 =?us-ascii?Q?LHJUy3Cn0xxGC1+9zaoeJz4xTH0+qyGI+xjvuI77Kahe7hyRwpIpK4hzaIqm?=
 =?us-ascii?Q?BLm88Cn1ZFQ1REGEswSRkkbIiRW1s8Pg+fHbQ7tRdQ//MBftF4ziBA7mP53L?=
 =?us-ascii?Q?AszfpEAe6hzte9NH6qWrqhcJE8B3H7l680fhvycQwwarnJ38Jq/oO2P8MwZ5?=
 =?us-ascii?Q?fgTzz1hWuYk680UChM8nbgnM47OuvTezeQZVpfVvv4Ye9zJwTFkGVMwEo6C8?=
 =?us-ascii?Q?X429ubXcxbeZGv5fDD87HNcji1KI1o4rx8QXToElEP3kqrNmO4D3suXAl7dx?=
 =?us-ascii?Q?vGXNPmRHC6OkZ/nMQJueY9V/LOJGMd00T2C9jXO3EHvyGYa57/KqWIxPdVNp?=
 =?us-ascii?Q?F4AA9/YicVSAvTmWqmSAeOQM4iLDFaNewL86+Mq3EyQ+2kjNfSe/fT2VccK4?=
 =?us-ascii?Q?t/L3T9WuDK5CEkkXYuqKv1lyg8p5CUK2zSB406zfZ/bilTqfANs6zpRwEzZl?=
 =?us-ascii?Q?s+P//q/gyDZDL3kuCGwb5YqAYEPPGN9vQcMq+z/huW4C+e+pNxL654QkKYVy?=
 =?us-ascii?Q?vmpAFU0mvbBUy/RdTfZtPOk6eED3HZpgvfN+SemT4Y4pLGmq7SEK7nWI3gHL?=
 =?us-ascii?Q?liCPGnaH1l+qM1huLiMx48Ep8X2hytF7fi21Lnl2qb2SjptQLcF/yAv4v0FS?=
 =?us-ascii?Q?1Qt56vY3p5lhJFm8z/3nC5YlZbMyfZ/qWrD/ucYI1PoBU3v9bc86ka9u4NYJ?=
 =?us-ascii?Q?u32CDngbPDvs8LP12/j93E6Qko73t5SoDXS15KWyRX41CFdhpdvz6l9xpOJk?=
 =?us-ascii?Q?fqNxw9dDrcXzh3CBCWvu00RU5rhVeOpOsGWCC0vOFJIwXfJJEozYT6tDiUXf?=
 =?us-ascii?Q?mB6WOM6cWhCny4Kii41AAT/3BV7B1sUZrc7Q/VsHsmbqlZzAega0iVnkZWiK?=
 =?us-ascii?Q?InngieQRFny0IZYM56sF38nQPMW/1kDn8R+RsQxa?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68607ab4-e245-488e-f449-08dddfe66787
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 12:38:03.1243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dDKGGoNXJUWukZ44484by/LHgqY1DLApBHgXkBXBM2tDqZx5iAzX41QUnxm+ODtP/cq7QIQhli3+KGbmJ+uDpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR06MB6448

Logging messages that show some type of "out of memory" error are generally
unnecessary as there is a generic message and a stack dump done by the
memory subsystem. These messages generally increase kernel size without
much added value[1].

The dev_err_probe() doesn't do anything when error is '-ENOMEM'. Therefore,
remove the useless call to dev_err_probe(), and just return the value
instead.

[1]: https://lore.kernel.org/lkml/1402419340.30479.18.camel@joe-AO725/

Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
---
 drivers/crypto/tegra/tegra-se-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/tegra/tegra-se-main.c b/drivers/crypto/tegra/tegra-se-main.c
index 1c94f1de0546..7237f14eaf5a 100644
--- a/drivers/crypto/tegra/tegra-se-main.c
+++ b/drivers/crypto/tegra/tegra-se-main.c
@@ -310,7 +310,7 @@ static int tegra_se_probe(struct platform_device *pdev)
 
 	se->engine = crypto_engine_alloc_init(dev, 0);
 	if (!se->engine)
-		return dev_err_probe(dev, -ENOMEM, "failed to init crypto engine\n");
+		return -ENOMEM;
 
 	ret = crypto_engine_start(se->engine);
 	if (ret) {
-- 
2.34.1

