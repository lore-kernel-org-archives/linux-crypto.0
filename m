Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013046.outbound.protection.outlook.com [40.107.44.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C123E022B;
	Fri, 17 Jul 2026 08:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784275324; cv=fail; b=WdC8/OJ1fEirmzlcWP6KbCnMS2JxEKyN5oqKe20jyaLAhijlTkwN/J9NI1tkyunVIRdgM7hbXA1KKOCjNckhWvHlfuHaNClzz6ifu7AgshEImMHi/8Dpk9DqEcACdW2U5CLQ12F1LV6mLsakYSjbsqkuAkK6o+SrtB6IEGk7uH8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784275324; c=relaxed/simple;
	bh=Q5voLxQ+VsFM/ZhMqRuHjHWXZYoFWNw5mnqabjo6BhY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QqIfDyc9GERWUfktcOkq9Q8mjOAuEkeFkEHa7OlAfV3IlX2g66xGixbFS9hka0xq/j4fS6SmczPO4rFnNc6uLxU+Cb/0H3CSGnGyDYuwFlK/neYdRtxV5hsGIalUFyykC/Cv4IEx8rUuTNZDtudMxSHHgOR6FIeBNZKZe9l0lNI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=jGENGwEs; arc=fail smtp.client-ip=40.107.44.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="jGENGwEs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LvObJBvANz2xbxlTH5wqHytVL54wlJ0rbakYE+vwYa42xatZMQr380xtiMDWeIm+Zl8WTVSxHFINttkCovjImbZP19LDR1cGqJrJbTlo/v6G1Iob7O9WxUV8Do9xsxrSzYID7jRYHEbrol1HSwLH1kDep1GdFj/sJsb8d8RmwcglH1dxFxXZyPT2s8MN1mjyEBHS/fGW0x6rsQuSHmezHcDL38yfOIBhgQO6t3Q3S2Oy2OePG8uq1OKeGdvmnAshi+3JdKfSQ7g3DaqeROzXYsxiea7J8sVVymATWrDJUrFVkKjJej9oH7yVWmJbdO3YF8t5kwk4G0MWGKfgJ6QOJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xO7fISC+DNqyKtVpz3gqMWIFDB/tG4UkU0exXu4TwFE=;
 b=HsSRPPyC9g2RQX72K/MVQ9DjvcI/qL3KZLD+7ZKVBrSPRbdCEmxWUzGsglvp8IbXPwQR88XQiqC49dPAau5kKvemBTmCrusWt/DRlhZJI+1IANPB9ekAeNpdgXskgaS7r1ucllEtpwukLCLP6txcGj2j2JKREFEQFnhiDjvGKLqRX2qCmwQsAdneYNAqbknxiTNt24jTS3JNIMlpN2eSy8ARF/KWkze6YJHTvZxBqXBY1vrcVNnWf8h+94Rv/5xAIxiKO7xUoO57OfSXIw2m3xf9LFNDVchcIQwaJTGmzMpE7Noru5XKOSZlPeCKvBVTu/qvkoaxLjLhvnEnKEzAKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xO7fISC+DNqyKtVpz3gqMWIFDB/tG4UkU0exXu4TwFE=;
 b=jGENGwEs1qqOKiO5Qnw2bbmDanznuL9gFsz6DQEp0ROem8Z0a/sCA/IP2T7SNAu2/DFJ8BB5Om/GDcX61bxKOOxXPDC2UBZl3ryr4UzOhZZWUgJaCtUIb6VDn4By17NYae/GDXDKnqH73mKWU+/TIPRgjJyWkhJPt/CqMCEoq8FQ5zPeE/9411j1dZtTMFJmHhOk3JyHFcGOVI8sJQLFUOBoI+NfdXeubt4Rd81+GSGu8WE9HcAKr/toWhXoi98IW/vb1FryMT0oEHRghmVpWq3QaTE5qxs667ncAGdhGRjzrpoOcIqDn9Ns2EtRuUB5YyTaUA3rigsm96rWaqyvJA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5832.apcprd06.prod.outlook.com (2603:1096:101:c8::12)
 by TY0PR06MB5104.apcprd06.prod.outlook.com (2603:1096:400:1b8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Fri, 17 Jul
 2026 08:02:01 +0000
Received: from SEZPR06MB5832.apcprd06.prod.outlook.com
 ([fe80::f98:5e32:4ccb:d07b]) by SEZPR06MB5832.apcprd06.prod.outlook.com
 ([fe80::f98:5e32:4ccb:d07b%6]) with mapi id 15.21.0223.011; Fri, 17 Jul 2026
 08:02:00 +0000
From: Pan Chuang <panchuang@vivo.com>
To: Hans Ulli Kroll <ulli.kroll@googlemail.com>,
	Linus Walleij <linusw@kernel.org>,
	Corentin Labbe <clabbe@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-arm-kernel@lists.infradead.org (moderated list:ARM/CORTINA SYSTEMS GEMINI ARM ARCHITECTURE),
	linux-crypto@vger.kernel.org (open list:GEMINI CRYPTO DRIVER),
	linux-kernel@vger.kernel.org (open list)
Cc: Pan Chuang <panchuang@vivo.com>
Subject: [PATCH 07/12] crypto: sl3516 - Remove redundant dev_err()
Date: Fri, 17 Jul 2026 16:00:21 +0800
Message-Id: <20260717080045.191538-8-panchuang@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: bf310b14-4a27-4229-e5ea-08dee3d9ae72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|52116014|1800799024|6133799003|38350700014|18002099003|22082099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	NWngOLiV4OuZK2KXo10NYXCqdXHwN80jl/+3HyvakzI35p9BI3GZb0U8ipWLxXvBaOjDzhu6qnuIE4GUc0t7wB8JBXotbzYR5qrGXHdgcFXqxlZi3Nt4R8c4qex2h0o61kH07wD95CQJ2+ViycJV9PJfIk/eS2jvECAzqp1T0GuJkFS2pBAZvWbkTYKKv7vrK9SGh2g/t98xmO+KHoteYHlCSyU/7+k76AABZhcq0UhTpJLM1qvTA7Qi3wWcXM9gPnpweKWbkvVIt5J7l/T+dzM68YCQfpQ/ystp9juLe/MAZjdSISaPnT0lrkxSlhlF5kvqOKnd6gbaK17O6b6E/8zKtc+j7ZCqX8bEJetTIrGXDcTPThPzgjciN+Q4ncSDtbD78ixdBMMPU7ahgb4LfbPlgpsciRRyOlUprvZouNAn12VMAg78w8t3ZWCGzKMtqx0I9Sq/PXIyjJrcnuHRj1e3d9SPrENuLSmzjeFlCVKh8FSCVGnf/jcxsXOwYTnFiX3x/mRqc/ACoJR46HEjqI3NarVmA82EsnMMMRo8shG4i3x1zNGLDtd/uAkSrdxJ+Q7bfFkMKY/vR1kWm/+jKNenFW6P/6g+pUgnPV9D3GlFJJj2q8an0brMcvB+PyOQ04Lag9C63cuc3Gfgn74JpHpmLLsZZxDJapiidLofmdECgM0kD1h4UScWHUbooLtbfX8I+hA8dvAr0u7tA3jTribX7eJeTY/5hxTOWIJvH1w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5832.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(52116014)(1800799024)(6133799003)(38350700014)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kWE3Nrex5SOz6bL/NidMvte1+MdWNwUH+W2JGTBv3Pg7r+cXuxzpxVdM0aP3?=
 =?us-ascii?Q?/IydGaIsg2qMPCaE53Pm23vrBnIL6B6eQTs515Ai7ysSzvm7yXu5+9LTPF5y?=
 =?us-ascii?Q?xcSj49OKqxzB4VqR2VNGDnigBslrQ1J+oILhqc5UqRqcS77QApDvEkQkCD+N?=
 =?us-ascii?Q?axg18lzojzHq6msvBY1a0gf/tSY5ihkHbL+Ag+JI1ENsarCqQrjsZ6lmbaql?=
 =?us-ascii?Q?7sLWtZwp1fuin+FMQMN7tuF5e33FU28dEX6NyeSUS2A0At2Lwtzlay329e5W?=
 =?us-ascii?Q?eO1bZVaiX9zK9AaONRKtsMNPPszIimdrPKdVJ0DsiEmlXfZ5Sh+dYY6NnvlD?=
 =?us-ascii?Q?TlO9mORV5L99K2dTb0RADrGqGRNT8pkMaG1Cx6+4Dx4sFGm99kCHE0Q1Mdyu?=
 =?us-ascii?Q?YK9BaB7nMdbIgI0UA5HlGQoOxgINaZ8US7oWNFqZTw7bx9ZFa47qFiVhenwc?=
 =?us-ascii?Q?JhPuYPj9qjkg7LgBXSjX3Z0TXNtsecJME65c8n2haKBKZ9Y9UZPgPTc3veKI?=
 =?us-ascii?Q?xRLBf29GHOn4Z1JRPxxJCPc0mXZ3fruYq+AOJtB0nppTUKE96LB0inKXvcIq?=
 =?us-ascii?Q?1XNarWn1UGjb/Piqm5qn83/t8Lk3LxWzwGct5EDouB2qFti+gchkTAY1iQVu?=
 =?us-ascii?Q?ej6ufq00ceP0PNCChso2xXK+4Iss9Zs1muVYFrcDlfUFYhkYbEser8Y+4Z9W?=
 =?us-ascii?Q?YCcDWlse++LobT1qZoSE4zoAaZITyz2OZapscDJInkf/qy7FShENUfYqFJa3?=
 =?us-ascii?Q?WXlao/cKLggRdjiH2bwt8ToV6hVWGDB0w3Ps5EJ47caYwhRpNJgkKq1CNXP9?=
 =?us-ascii?Q?tNZTpn2UzAC5atiLQfe/Tqdb61FCPvCPHl4/JtKX3kNry0Pli3pOqiSX1Frr?=
 =?us-ascii?Q?GV3Cn8tvmUgyTtQG9f0QyT0iIWFx+z5QPNrAryzz9AtxPPLsfDmbic0yoxxC?=
 =?us-ascii?Q?9MSOlZQjQzxcAm4qAavqVL8IO54vG+JpvcfaepbN5WmGEmk7CwCi9LuKhdn7?=
 =?us-ascii?Q?o96qcNLVtxfuudUgNiLhLq3KXwhdawsiGfnEoWquhAkydiTcpyFRYt1cs77A?=
 =?us-ascii?Q?gmXhY9ZF7dl4Xv5iSvrLivZqwFnn54xhChCDu2cT82mS6FfCJmrYcn+FbBeP?=
 =?us-ascii?Q?oEuzKH5p+KzaJkefyDkV/9HBZQNYz7aAJ0L5G142gs+U5JkyLE8/2Fabka76?=
 =?us-ascii?Q?tRPfwaqgKDei6T7P1oo2zliJTg6trpcQr1TAkGI7UWXBWbM4iZNRI3vIlmVg?=
 =?us-ascii?Q?MISOFFhR2zDoVa5UkRcFfmMZbo2YsDjYEiR2F2j+Xo2wGj84vWLY4+SwaplD?=
 =?us-ascii?Q?Z4OroIPrLWxtUGmpxUQS43Qed9KxHmC6T8VA1zLbebDjX3Rl8y3falXhPRRw?=
 =?us-ascii?Q?ZHzCfKdoxym/6GI53U3U3XtowqbbkDrGhQ9QNUH46UGKDFR6X0W4BSrX0Csa?=
 =?us-ascii?Q?TD7PlGQYo2u/7vDHMOErmYjIY2hlLZtXvH8z2qRZJEMVqiPTULe22QKxJHMt?=
 =?us-ascii?Q?vhT6XNHh7JW+Knx+ZXUc9xOvmqbaItzve6++KOUNAzHN0H1oIGE/3yohspe6?=
 =?us-ascii?Q?BfIGdFCXgwuGAr6sx22dXfOZmvSAuhTo1h3XAaYkj3gcWNIPXvNp53rEKx7u?=
 =?us-ascii?Q?rB7HMVbdjhVVr/f95kHzSxj72m8+krqNi/C+V1uUoJqXAa9YwCFy5o9VQler?=
 =?us-ascii?Q?YJIb7tQqzu7SVRcRyJZ5R4lKASZsBuycagV8xoVz9QsojyRih39gB9MN0jf6?=
 =?us-ascii?Q?Uietl89FDA=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf310b14-4a27-4229-e5ea-08dee3d9ae72
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5832.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 08:02:00.9178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OiHBU2TJf4LIYjMqpzRxR/0JJEiJ1YyjQ3dpvOSknNvRmO+LXIK+ZOsFacu7QSg7FAQbgY1SP7XI+lS/ilLQ3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB5104

Since commit 55b48e23f5c4 ("genirq/devres: Add error handling in
devm_request_*_irq()"), devm_request_irq() automatically logs
detailed error messages on failure. Remove the now-redundant
driver-specific dev_err() calls.

Signed-off-by: Pan Chuang <panchuang@vivo.com>
---
 drivers/crypto/gemini/sl3516-ce-core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/gemini/sl3516-ce-core.c b/drivers/crypto/gemini/sl3516-ce-core.c
index f7e0e3fea15c..c1df5f96ea42 100644
--- a/drivers/crypto/gemini/sl3516-ce-core.c
+++ b/drivers/crypto/gemini/sl3516-ce-core.c
@@ -414,10 +414,8 @@ static int sl3516_ce_probe(struct platform_device *pdev)
 		return irq;
 
 	err = devm_request_irq(&pdev->dev, irq, ce_irq_handler, 0, "crypto", ce);
-	if (err) {
-		dev_err(ce->dev, "Cannot request Crypto Engine IRQ (err=%d)\n", err);
+	if (err)
 		return err;
-	}
 
 	ce->reset = devm_reset_control_get(&pdev->dev, NULL);
 	if (IS_ERR(ce->reset))
-- 
2.34.1

