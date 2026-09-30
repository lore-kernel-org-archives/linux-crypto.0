Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11023095.outbound.protection.outlook.com [52.101.72.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40074F5E0E;
	Wed, 30 Sep 2026 16:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.95
ARC-Seal:i=4; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787323; cv=fail; b=lqcgV6WIJAziqLSJveC8mVxrzCKoShGW4Ciis18dAc1CyAuYOcsQcVqgKKyUPdiQHHLYlHLM0HMf6n9QIX9g3y5L6jaGZyJuHihxTr2lcEl5KCzQwGlqBh1TIsXGsanxsdNcwx8mKPfRpx1uSLwD6q1dKJYJ7KzsnuQOZIujHBw=
ARC-Message-Signature:i=4; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787323; c=relaxed/simple;
	bh=9DmtSaPxMkvH1pTyIW/o+OyGs/6/na7Bbtavwu94VtE=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=e3CZRAVtqanZNWYufP7ZIhPkIJaa6110thl4PUVlRudlR25aqDflccuXOhajACpYohZIFEnT/As4CP4CSsBokUSb8GNijUI40wDowCKCspVGuE4TwyE9aaU4fACEueBcbFJFt8xOoWiwgA6GrL0RJL2tM/82DjDwEsIs6ewjToM=
ARC-Authentication-Results:i=4; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=solid-run.com; spf=pass smtp.mailfrom=solid-run.com; dkim=pass (2048-bit key) header.d=solid-run.com header.i=@solid-run.com header.b=fmaTNboS; dkim=pass (2048-bit key) header.d=solid-run.com header.i=@solid-run.com header.b=fmaTNboS; arc=fail smtp.client-ip=52.101.72.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=solid-run.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=solid-run.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=solid-run.com header.i=@solid-run.com header.b="fmaTNboS";
	dkim=pass (2048-bit key) header.d=solid-run.com header.i=@solid-run.com header.b="fmaTNboS"
ARC-Seal: i=3; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=foNh/aiiS9je0HdW47avjdVqvm+t9YsS5pHHg3RRAjBnsW/lzq7Y6hztd8J6rKNeAl3VECwPN/970fXaQxYnpoBt0Norgai9cbMsdD0t1WJeYXXEci1eA9AetboCvakpZPYQKLYVb6syurHX32sBcz9LVeeP5eCg9RmgzdSN5BzXczJL2QwAyudzy8HGQ/0SsL9zIw834QtCNQapBfA7zFZL8PA3I2djfWjUcZWEOA9S9de+TqKlUifI8nbhJJDHclwZwHKhXo9k7X3yeUEKTxciibL117NikkzNog0g4z4bpuUctrrljkrn1wUaCzAvkiGMq7TBXMXcj8grHD/BGw==
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XQoXvhCFvKZx2yS6eXHkp5lVvT2hyDXkdAP6KUm1mLY=;
 b=ru1LjZgm0QyyEB4LwNIK4FAljCH4mRe50YzCkfZxuIQrR6ipFU0RefXSZuIHOWSA2tCSxjIiMYhD41PfMXAlpM+C2mNOm891chIJyWhr33O5BVEcoo+1knO95kFGm1PQZx6uF4CGuo/caQO+dm8BA6P4OrJUqQ59FVeHfe5+PrMFeIPItLawtrR5PCLCFuAdAZ9UL1FFqhYzMNusvOII43v7F9O4p0+KBhwmCwCTMQzL0KidNnRnfcoyot8FlXLefl/ORk2MyFaUod80kUunYWDl7JCa/3XO6At/PMZTwWnabltPH7JbwJtdiwQAUyVM+Tv634xgRyws/JbBzyJ80A==
ARC-Authentication-Results: i=3; mx.microsoft.com 1; spf=fail (sender ip is
 52.17.62.50) smtp.rcpttodomain=davemloft.net smtp.mailfrom=solid-run.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=solid-run.com; dkim=pass (signature was verified)
 header.d=solid-run.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=solid-run.com] dkim=[1,2,header.d=solid-run.com]
 dmarc=[1,1,header.from=solid-run.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=solid-run.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XQoXvhCFvKZx2yS6eXHkp5lVvT2hyDXkdAP6KUm1mLY=;
 b=fmaTNboSZ1uS0nAEvzTY2kwGD3E89qZGn+ATZtFVnbXaaEgPf96+haJedim+MWWXYsCG2Uh77Avj5o2Chz2tTxYGDIaWHzQ9Jv4EqiLPRy75PbJZrDZRzT8n9qsYgI7E3PtZwpSBP5Ej3JdXxQl0hEz5bs72PdJsCshdy12Iie/mlfFxZoC2NKDDmwHS2GaPlknic2800xuCtjxw+p2VHEVZLrbID6/ylJKzq1Y7xSIvOCn4zU8lVDYfI+tBr1Lf3gtnn1m7MMxlJkKCrn5MjCxNCs9rcsrrLruzpom2ntjTo7YFsEUexpKVUvomZ0yTWTT/qg4rszYq01r3PmMpww==
Received: from PAZP264CA0046.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fc::8)
 by GV1PR04MB10773.eurprd04.prod.outlook.com (2603:10a6:150:202::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Wed, 30 Sep
 2026 16:55:15 +0000
Received: from MI3PEPF00008557.eurprd05.prod.outlook.com
 (2603:10a6:102:1fc:cafe::67) by PAZP264CA0046.outlook.office365.com
 (2603:10a6:102:1fc::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.15 via Frontend Transport; Wed,
 30 Sep 2026 16:55:14 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=fail (sender IP
 is 52.17.62.50) smtp.mailfrom=solid-run.com; dkim=pass (signature was
 verified) header.d=solid-run.com;dmarc=pass action=none
 header.from=solid-run.com;
Received-SPF: Fail (protection.outlook.com: domain of solid-run.com does not
 designate 52.17.62.50 as permitted sender) receiver=protection.outlook.com;
 client-ip=52.17.62.50; helo=eu-dlp.cloud-sec-av.com;
Received: from eu-dlp.cloud-sec-av.com (52.17.62.50) by
 MI3PEPF00008557.mail.protection.outlook.com (10.167.240.11) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.14
 via Frontend Transport; Wed, 30 Sep 2026 16:55:13 +0000
Received: from emails-5762875-12-mt-prod-cp-eu-2.checkpointcloudsec.com (ip-10-20-6-124.eu-west-1.compute.internal [10.20.6.124])
	by mta-outgoing-dlp-517-mt-prod-cp-eu-2.checkpointcloudsec.com (Postfix) with ESMTPS id C491580FD9;
	Wed, 30 Sep 2026 16:55:12 +0000 (UTC)
ARC-Seal: i=2; cv=pass; a=rsa-sha256; d=checkpointcloudsec.com;
 s=arcselector01; t=1790787312;
 b=GsmLwuMCh0rQDYjjpUyPTXNUMW9H59n6feBNnAwVwVmblFVLH2DMvJABk/IDdsx4Tgi1p
 oJQp6wghnuP/MRdn39eAiwNXiAJqVcfX2TvPBNXeRprRbzEd5QH16riI6DyB3XQWhPGoodB
 cDBt/XDymWEUTinzmiaqagKR5qBT3dk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed;
 d=checkpointcloudsec.com; s=arcselector01; t=1790787312; h=from : to :
 subject : date : message-id : content-type : mime-version;
 bh=XQoXvhCFvKZx2yS6eXHkp5lVvT2hyDXkdAP6KUm1mLY=;
 b=bWAYDEFDt7KsevrtFSpNij7lZ5WNOT1MeniQbcIRHt5WC+QADphbTEZ1s0E5wLyiWsVXQ
 hIsZcTKqnsz2FT42SyS7F4DxbZQqFbDkrhmEcphHCa+748FXZZcBXbEr2I5ko54AS2DbTji
 G1MnncbzycQ6I/xgnGBdM4DksWoZRfY=
ARC-Authentication-Results: i=2; mx.checkpointcloudsec.com;
 arc=pass;
 dkim=pass header.d=solid-run.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=solid-run.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XQoXvhCFvKZx2yS6eXHkp5lVvT2hyDXkdAP6KUm1mLY=;
 b=fmaTNboSZ1uS0nAEvzTY2kwGD3E89qZGn+ATZtFVnbXaaEgPf96+haJedim+MWWXYsCG2Uh77Avj5o2Chz2tTxYGDIaWHzQ9Jv4EqiLPRy75PbJZrDZRzT8n9qsYgI7E3PtZwpSBP5Ej3JdXxQl0hEz5bs72PdJsCshdy12Iie/mlfFxZoC2NKDDmwHS2GaPlknic2800xuCtjxw+p2VHEVZLrbID6/ylJKzq1Y7xSIvOCn4zU8lVDYfI+tBr1Lf3gtnn1m7MMxlJkKCrn5MjCxNCs9rcsrrLruzpom2ntjTo7YFsEUexpKVUvomZ0yTWTT/qg4rszYq01r3PmMpww==
Authentication-Results-Original: mx.checkpointcloudsec.com; arc=pass;
 dkim=pass header.d=solid-run.com
Received: from MMZPR04MB400504.eurprd04.prod.outlook.com (2603:10a6:190:28::8)
 by DBBPR04MB7499.eurprd04.prod.outlook.com (2603:10a6:10:203::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Wed, 30 Sep
 2026 16:55:05 +0000
Received: from MMZPR04MB400504.eurprd04.prod.outlook.com
 ([fe80::2f52:2d22:c7b3:4292]) by MMZPR04MB400504.eurprd04.prod.outlook.com
 ([fe80::2f52:2d22:c7b3:4292%5]) with mapi id 15.21.0451.022; Wed, 30 Sep 2026
 16:55:05 +0000
From: Josua Mayer <josua@solid-run.com>
Date: Wed, 30 Sep 2026 18:54:59 +0200
Subject: [PATCH RFC net-next 2/3] crypto: caam/qi2 - skip isolated CPUs
 when setting up queue pairs
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260930-dpaa2-isolcpus-v1-2-66c13f4fd75b@solid-run.com>
References: <20260930-dpaa2-isolcpus-v1-0-66c13f4fd75b@solid-run.com>
In-Reply-To: <20260930-dpaa2-isolcpus-v1-0-66c13f4fd75b@solid-run.com>
To: Ioana Ciornei <ioana.ciornei@nxp.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 =?utf-8?q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>, 
 Pankaj Gupta <pankaj.gupta@nxp.com>, Gaurav Jain <gaurav.jain@nxp.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: Yazan Shhady <yazan.shhady@solid-run.com>, 
 Jon Nettleton <jon@solid-run.com>, linux-kernel@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org, 
 netdev@vger.kernel.org, linux-crypto@vger.kernel.org, 
 Josua Mayer <josua@solid-run.com>
X-Mailer: b4 0.14.3
X-ClientProxiedBy: FR4P281CA0174.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b7::20) To MMZPR04MB400504.eurprd04.prod.outlook.com
 (2603:10a6:190:28::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	MMZPR04MB400504:EE_|DBBPR04MB7499:EE_|MI3PEPF00008557:EE_|GV1PR04MB10773:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d4e1782-53bb-43be-1eef-08df1f139881
X-CLOUD-SEC-AV-Info: solidrun,office365_emails,sent,inline
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|23010399003|10070799003|1800799024|376014|7416014|52116014|22082099003|18002099003|921020|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info-Original:
 jqewYSZKTdxOvY0Duyl4fLxHf7V21X3zkMpaCPTLXn+7ZjrxvdGUx2qFIO173+qzeez9rqZrk/r80N0ROSx7BoB7mPGv4N5t7H0O48DpKdIWMzg9Zrb74zWBquCNBNAWquQ0K3h8g4b4vU/3SPxM8LcpXClILKKTRCfWmbv/PpSrqfeavvTsuqsQPx+tVdZuOl2DPDYFyzHfwiujSNYUBDCnzJJ60Al0SB/oWIuPNvzEQpSGyAdXVBLCKnBRgK60mLOeOQrKy/sdGUJLkxnCPQJcu+MlU5MU9YdgTe358b+4eHw/O2qojkSwdIwxvMUWM+KAs47aS4G1cuWcUp/CJH9JGugX24AAQyWaFtzzjeGtqadqeUgvhEsPcW8SrbOwQLi5hJsZ0/IXxiZ9UQNoTlxIV4CwmFC3vyS6oKzh9Wepd1WSjbd+FV9/Ui0LlWjL+jK2O83dfX6rbfsulWsBNfLpirz9XVhWSnR68e9iQzoeaTOalYKWt1MEnWDsCcHIqL9fMYbR5cyb+aPANLdxeHZXwPL2plPkUzvSIMLyNGoddmOEJBzHu73dPkyePCPo6dlxlhCk2TLdTRZeWEt2mCRN2GQvPKRAe3ZLIq6mGvWgjghkqA/uJ7+WQHphNyFIHI6r6nht8Bt3ZR8Zhi4jG5DR8Hz17BHNZBgQXDxjgnSPHfNsokIFAzzbidoWdXW5Omn9gR2W85Q7V0XcUAuheA==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MMZPR04MB400504.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(10070799003)(1800799024)(376014)(7416014)(52116014)(22082099003)(18002099003)(921020)(10067099003)(56012099006);DIR:OUT;SFP:1102;
X-Exchange-RoutingPolicyChecked:
 5zzwsgpZMwfrhHHSfFj/9AEbOVwKBu7BD4oMsPImFG5YT3AUHv6noQtEpjA+B/6VGVyttEPU7GfKcZO4jhfe1HtgfK6f/mKQNuFNPboetoI7MUJBN+Sy7YWzYZ7DxwiAVXaYAxAs3fXJFxoy0NbaMBzyhr4T2OG/CxTyFnKDzTwqb+wXBSAV9jx5ZgUTN63QR5jlXh8cvd1xKqWuVXmsOqz0OdvXsGk5gneU5NwN/W/AVlFD4w+VcT/Sql9Vn/tYjlAi5jJp6VW9NiQ783NV0uFiJVWup5L/Js6XChNSEJC5Buq6h0te84PYLLUeZSINkVci6X7jZB+hjxlMqGUDqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7499
X-CLOUD-SEC-AV-INT-Relay: sent<mta-outgoing-dlp-mt-prod-cp-eu-2.checkpointcloudsec.com>
X-CLOUD-SEC-AV-UUID: f51d70866ff647a8b260f07223314ede:solidrun,office365_emails,sent,inline:776544cf20a4f6cb347dc8a29c053d94
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oVNgXMtlh6pOjzzahecWOMRT/5nyD2Sm8XLtJkTBbudkTy8+/km9DhGdMzxnEwN2xtQosYqWMpjjbKSw8X3DM3/0dvqcN0cwmlOUixviz2qN+qZDZMqM1SWR0eGi6P0mg7csAibW36rvub+xhkQPe9Psw7xrRWYuHoa21ur4bwaCsmUF3S+YlUQ2dN5aUvbWbzA8JnVWky323vIhqsOB704utcMY7Aj/h7b1N068tmLp2j0n1yNWlnk5vsiGB3hQM7UEz53YIcza/1HZ7ydf/DbU5ovFO3fHSnTcPHfxNnREFjWK4ZV7q+ep6Db4VlvaE6Mf3nEwpAoahJKOKU2ejg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XQoXvhCFvKZx2yS6eXHkp5lVvT2hyDXkdAP6KUm1mLY=;
 b=DuGbSdC5Cxi8KrtjADC7CKQvnXHhLbHo72TIgLnSBSmdJ1iyXrqvfsVY4Ih02yA2m7nO0M0WWuSUDwNWIeMsl6w89BZqOvx6NS0aIOx3z47dbwqaB7bgLuCte1Ad2ZHnVzdvGGlqnwVF8KFh98tHTQyO32VNOMeJkBGvRs+f0bBtd5/nRuDDmX3mz1N2bEdu0kCRX5FMM5R6aqeVkw2Y/0x3ihama+BJmb+AQ2UO7nlOWpHeTlPUsbSvYL0Osci8CXC+gp0PclWLrGK9qu0mp6dbqHYyXEZTNGUcupWdonoz/6+flY9Wk8yARHVbO7Aje4ulAjK4Emxtf4v0PeOKlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 MI3PEPF00008557.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7ee1d857-d0de-4a26-0627-08df1f139357
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|35042699022|82310400026|376014|36860700016|14060799003|23010399003|1800799024|921020|22082099003|18002099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	+TON9pMx1VJxUXMzf0/DkNvhENdOWV5ESUu8HrWPEH86N2UenJFkMeQaC7DaPDITKYxbgvFJHR/T1xniyErAsoqWD8RFCS2duW0SR3CPAcXUt7pXEKKwESi/53e9hmCbHgv3UXyq0JBrN7pmw6wpCyCK3VJHfJ3SzrlwbERlwzyhRtYlK/Kc7EUyg+3bW8nfSy7zHhGEzkX0yV7s7mX0MLxsDKYO8vUVkOu2bkIIAzdsMEWeszUIWBlEEtp3yp82WOYU8s1XM5TLp3emZHY4oxLON/qj1PGrtJwSeVVNqhUnQgucrzrvIi+P0cbZHcfdQWW/x+mKTSV0Eu8Tkiup83ZSNFvoSp2X25ZNTLrgTl6o0BnBWpzubjtegnlOPRxp/a5cwDuMl90mXf2N6CrOZnh2vgzOgLW4Gpf2E5kGLLqTmR3Sg7GDAah8uJ5CLkNH/5oMY9v/NxJ0tx4PB02pnP0UIRS7NVcFBNLqVTutFPKZ55637ljkbBMhfZJBZhhRaG8rt5ouC/hgTeocdv+zVVOQSe6Pqd54neg43ztntp6QGTmpxXF9p5NsOWyQGZqBM282mP99+4l6ibhiKzM1ivGI0im5DQ5qcbWth6p824vcFH5uyAfYkfsgMN+74Ppl0TI34mRluRDBNfjT1lei02AfeT2tb4QiJRhUe+vGVlWZDXpaketvRU/5nWEQXIDNcXEQH0nPWgFOPF8PB5WF3Wxh6Mxu9Q2qozYQm/aDcUyHqa8tuq5GQcJKi96HT9MN
X-Forefront-Antispam-Report:
	CIP:52.17.62.50;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:eu-dlp.cloud-sec-av.com;PTR:eu-dlp.cloud-sec-av.com;CAT:NONE;SFS:(13230040)(7416014)(35042699022)(82310400026)(376014)(36860700016)(14060799003)(23010399003)(1800799024)(921020)(22082099003)(18002099003)(10067099003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	A/GG4jnD875mP+9PNsaN8w397yem+XxW7vB4/C73ORNmQH1cLw+fF2kaRvskm7aGc/a88FhzpVQ1rbKicDUZB1DW2VbykAeiyCLWlYxRLXjCXvWGfrbDsuU6siDneyBxA8StAbA9FSUr/6Mum7i60u0+WkH+I76HPdL4kArFazAgTvXS88DuEu0uNpQM28BIdgarcSd6piEu1vh3dID/Kx4v/Be/jygpoxRy/itmCk6Jg+cCFnixi9+mgUUayWQoE6KdN9jfBGtWsXVt4d+7hcNCDNmmMf73/9zgI+veUBRCari+4hNSCTrm1chey1HzDGaicppAimEX6cSipFTKBq/UYgbVCA+f9BFv0ummNdeFzZcf35BAoO+6Ms6Q9PqlyehhS4NL6PW187LthBzSYSjfDnIpLqRb/zULfW5VuTsCkXHZrE1JMxbfZMd83bc2
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 16:55:13.2012
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d4e1782-53bb-43be-1eef-08df1f139881
X-MS-Exchange-CrossTenant-Id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=a4a8aaf3-fd27-4e27-add2-604707ce5b82;Ip=[52.17.62.50];Helo=[eu-dlp.cloud-sec-av.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MI3PEPF00008557.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB10773

The driver looks up the affine DPIO and sets up one Rx/Tx queue pair for
each online CPU, up to the number of queues. Response notifications and
NAPI polling are handled on the DPIO object's assigned CPU. All online
may enqueue requests.

When isolcpus=managed_irq is used to reserve CPUs for latency-sensitive
applications, those CPUs are expected to be free of routine device
interrupts.

The DPIO driver assigns affine CPUs only from the HK_TYPE_MANAGED_IRQ
housekeeping mask, leaving isolated CPUs without an affine DPIO. This
defers caam qi2 probe indefinitely once DPIO setup reaches an isolated
CPU.

Restrict queue pairs, notifications and NAPI polling to the online CPUs
in the HK_TYPE_MANAGED_IRQ housekeeping mask, so that isolated CPUs are
skipped and don't defer probe. Isolated CPUs may still enqueue requests,
with responses handled on housekeeping CPUs.

As the dequeuing CPUs are no longer necessarily CPUs 0 to num_pairs - 1,
enable and disable NAPI based on the bookkeeping in clean_mask instead.

Signed-off-by: Josua Mayer <josua@solid-run.com>
---
 drivers/crypto/caam/caamalg_qi2.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 6b47bcc16a506..e9faaee009b74 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -25,6 +25,7 @@
 #include <soc/fsl/dpaa2-fd.h>
 #include <crypto/xts.h>
 #include <linux/unaligned.h>
+#include <linux/sched/isolation.h>
 
 #define CAAM_CRA_PRIORITY	2000
 
@@ -4683,9 +4684,10 @@ static int __cold dpaa2_dpseci_dpio_setup(struct dpaa2_caam_priv *priv)
 	struct device *dev = priv->dev;
 	struct dpaa2_io_notification_ctx *nctx;
 	struct dpaa2_caam_priv_per_cpu *ppriv;
+	const struct cpumask *hk_mask = housekeeping_cpumask(HK_TYPE_MANAGED_IRQ);
 	int err, i = 0, cpu;
 
-	for_each_online_cpu(cpu) {
+	for_each_cpu_and(cpu, cpu_online_mask, hk_mask) {
 		ppriv = per_cpu_ptr(priv->ppriv, cpu);
 		ppriv->priv = priv;
 		nctx = &ppriv->nctx;
@@ -4725,14 +4727,14 @@ static int __cold dpaa2_dpseci_dpio_setup(struct dpaa2_caam_priv *priv)
 	return 0;
 
 err:
-	for_each_online_cpu(cpu) {
+	for_each_cpu_and(cpu, cpu_online_mask, hk_mask) {
 		ppriv = per_cpu_ptr(priv->ppriv, cpu);
 		if (!ppriv->nctx.cb)
 			break;
 		dpaa2_io_service_deregister(ppriv->dpio, &ppriv->nctx, dev);
 	}
 
-	for_each_online_cpu(cpu) {
+	for_each_cpu_and(cpu, cpu_online_mask, hk_mask) {
 		ppriv = per_cpu_ptr(priv->ppriv, cpu);
 		if (!ppriv->store)
 			break;
@@ -4745,9 +4747,10 @@ static int __cold dpaa2_dpseci_dpio_setup(struct dpaa2_caam_priv *priv)
 static void __cold dpaa2_dpseci_dpio_free(struct dpaa2_caam_priv *priv)
 {
 	struct dpaa2_caam_priv_per_cpu *ppriv;
+	const struct cpumask *hk_mask = housekeeping_cpumask(HK_TYPE_MANAGED_IRQ);
 	int i = 0, cpu;
 
-	for_each_online_cpu(cpu) {
+	for_each_cpu_and(cpu, cpu_online_mask, hk_mask) {
 		ppriv = per_cpu_ptr(priv->ppriv, cpu);
 		dpaa2_io_service_deregister(ppriv->dpio, &ppriv->nctx,
 					    priv->dev);
@@ -4764,10 +4767,11 @@ static int dpaa2_dpseci_bind(struct dpaa2_caam_priv *priv)
 	struct device *dev = priv->dev;
 	struct fsl_mc_device *ls_dev = to_fsl_mc_device(dev);
 	struct dpaa2_caam_priv_per_cpu *ppriv;
+	const struct cpumask *hk_mask = housekeeping_cpumask(HK_TYPE_MANAGED_IRQ);
 	int err = 0, i = 0, cpu;
 
 	/* Configure Rx queues */
-	for_each_online_cpu(cpu) {
+	for_each_cpu_and(cpu, cpu_online_mask, hk_mask) {
 		ppriv = per_cpu_ptr(priv->ppriv, cpu);
 
 		rx_queue_cfg.options = DPSECI_QUEUE_OPT_DEST |
@@ -5012,6 +5016,8 @@ static int __cold dpaa2_dpseci_setup(struct fsl_mc_device *ls_dev)
 	struct device *dev = &ls_dev->dev;
 	struct dpaa2_caam_priv *priv;
 	struct dpaa2_caam_priv_per_cpu *ppriv;
+	const struct cpumask *hk_mask = housekeeping_cpumask(HK_TYPE_MANAGED_IRQ);
+	unsigned int num_online_hk_cpus = cpumask_weight_and(cpu_online_mask, hk_mask);
 	int err, cpu;
 	u8 i;
 
@@ -5070,10 +5076,10 @@ static int __cold dpaa2_dpseci_setup(struct fsl_mc_device *ls_dev)
 
 	priv->num_pairs = min(priv->dpseci_attr.num_rx_queues,
 			      priv->dpseci_attr.num_tx_queues);
-	if (priv->num_pairs > num_online_cpus()) {
+	if (priv->num_pairs > num_online_hk_cpus) {
 		dev_warn(dev, "%d queues won't be used\n",
-			 priv->num_pairs - num_online_cpus());
-		priv->num_pairs = num_online_cpus();
+			 priv->num_pairs - num_online_hk_cpus);
+		priv->num_pairs = num_online_hk_cpus;
 	}
 
 	for (i = 0; i < priv->dpseci_attr.num_rx_queues; i++) {
@@ -5151,7 +5157,7 @@ static int dpaa2_dpseci_enable(struct dpaa2_caam_priv *priv)
 	struct dpaa2_caam_priv_per_cpu *ppriv;
 	int i;
 
-	for (i = 0; i < priv->num_pairs; i++) {
+	for_each_cpu(i, priv->clean_mask) {
 		ppriv = per_cpu_ptr(priv->ppriv, i);
 		napi_enable(&ppriv->napi);
 	}
@@ -5180,7 +5186,7 @@ static int __cold dpaa2_dpseci_disable(struct dpaa2_caam_priv *priv)
 
 	dev_dbg(dev, "disable: %s\n", str_false_true(enabled));
 
-	for (i = 0; i < priv->num_pairs; i++) {
+	for_each_cpu(i, priv->clean_mask) {
 		ppriv = per_cpu_ptr(priv->ppriv, i);
 		napi_disable(&ppriv->napi);
 		netif_napi_del(&ppriv->napi);

-- 
2.51.0

