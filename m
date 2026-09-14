Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013038.outbound.protection.outlook.com [52.101.83.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8851632DD;
	Mon, 14 Sep 2026 04:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789359290; cv=fail; b=g/X29AWdEY5jDsG0mEQH+/SJIujCKFZqT3XWHOJYERKHQ+oBT03FRcxjmWWnx9vQPAmNUp3LHnc+f5cKFk2FTXR5ejbNRViEYQVNTxvaPTesRkLldb8R1Ec0cmd3nLqJ5NJNkXuhJ63c507eEeCU0QJkmUsHZh5/UoLSKY8dL0A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789359290; c=relaxed/simple;
	bh=mk5G6HP2MRQGInjO+vieTSrbKC/Guj2J7CVXSX8WBQo=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=C4d1R3R6+yJvq5PyiT4lu6S4aJbUMvskcwscuJz23cRsbD1Kay6ksnJBlA7S7MiaXERgAG7bP75T39egKdXXpa+NfcXBstZ0H6QtBSqWpYqK1r6MUdFchA03pfkQ7d9AnAYkSenyNwQrNBgjahPKu50KiIODq1/sxTOcJVDYA60=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=h/odShjU; arc=fail smtp.client-ip=52.101.83.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="h/odShjU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mWmmuzBSjWRlauejTyG0VqoQxM4hN05VWhliw5ok6JsB33Mn3oJSWoi3gzuq+AiWbyk6JH74tZMh7KPGDeDggUMAX9A2eUTMKzXxNi+qJQP/d0hVCufnbZfysd6I2x+qnd9aJcoxA83KUXEj5Kfj9N4AnW74wlbqMwdZQZtGthSRKnxOFhUApUvuAEvT3kvO2xGTYP1g/mQvoWFbKjx824PavWl0fUlSnwz+JdTacX2ZQKFWoN6gi/AUlJTsRgHzJBp/0bkF/S1k/wNZTp/GCpqidp8wTPYA1i0p2nqn7oWAdBzrkZh+2kibb3sZkr/gTCbWFqtL7lw9PsfdXV/E6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Kzfy/eX4WxXZs/USimvIu3Jo2+tuMIZXA/427xm6Pw=;
 b=Gd9lUiq2Hf2RCY7qlNL81jOoQFEB8/CKxB/0Q2BawLiNXD5IBRCM4oEETFzTH8JGV+NjNWHCvb0R0H3ktSaa4+kQLsbZO3d2oGskIAnNE17cLFBu+I9HHYTUWTumAJZmwSOuyhT1bzrOoxkoKcgfzIsmyYHkQT+bm/iJe+Xb5ODYJmxt0uj35z+g8ctkVKHynM8tQhgpIQsTqzB1jL7HF1uBr024z/mFCymauEB+Et7e9Ac55mqJJKleYqNAu5LdFXrczEyUbcSskEuLZweyPSt2mNKaaugrTNDdaxwVSxR1i1nOvcsWZGooljVXZfE+jmIKtfW9XZwzU2jKL97xDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Kzfy/eX4WxXZs/USimvIu3Jo2+tuMIZXA/427xm6Pw=;
 b=h/odShjUaf2GlzAVF4iSHuHTUguKAHC3zvcIm3mlGfOj2dgXFplaBvjVwXQrPfjFHCq9DErNMF8D9H3spBi6Q0ZaL9sKwQQadgcoU/sEx7jfBekgYIjDd6xlcp7yGWuMOUN9/DYXqjODqEgIwkj8qtS8U3UOueuU4epVruAwz6gRis7b9Hux2IfH6JAnsSQk37VTv0pzKWX/Q6Ku5b6CX0SKvl5T385oeOSP0Cyb48HDNrAN5mogBgZ8NEjXl1IRlO3N22S94YN2lsEVXhdGcgYo9StYQmZ3XG36PWoeAla1H2db/Y0/IXRA511lvYRQNoUAgMdZgJ28L83rjej0kw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AS1PR04MB9358.eurprd04.prod.outlook.com (2603:10a6:20b:4dc::19)
 by VI2PR04MB11273.eurprd04.prod.outlook.com (2603:10a6:800:296::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 04:14:45 +0000
Received: from AS1PR04MB9358.eurprd04.prod.outlook.com
 ([fe80::677:d5bf:c3ce:3ad4]) by AS1PR04MB9358.eurprd04.prod.outlook.com
 ([fe80::677:d5bf:c3ce:3ad4%4]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 04:14:45 +0000
From: sahil.malhotra@oss.nxp.com
To: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sahil Malhotra <sahil.malhotra@oss.nxp.com>,
	Varun Sethi <v.sethi@nxp.com>,
	Sahil Malhotra <sahil.malhotra@nxp.com>
Subject: [PATCH] MAINTAINERS: update caam crypto driver maintainers list
Date: Mon, 14 Sep 2026 06:14:36 +0200
Message-ID: <20260914041436.3910000-1-sahil.malhotra@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P195CA0041.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:65a::13) To AS1PR04MB9358.eurprd04.prod.outlook.com
 (2603:10a6:20b:4dc::19)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS1PR04MB9358:EE_|VI2PR04MB11273:EE_
X-MS-Office365-Filtering-Correlation-Id: 378719e4-be2a-45d8-dfe1-08df1216b588
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|19092799006|23010399003|18002099003|11063799006|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	1btLP1N6+zo768i2jR5NNvWby71fM9UhPPpQnDGyzkv6SvhiTUOLkBt3LCHMj37F+sCBOtAZ2pLxLvkdTVoM+HyqBvBON79VGIuxjomqIxrk1bzTX+QhZDWFp9nJjDpl47aQMGQcL4JA5lMctjj9W497Tl9qwOjq2bNQQmB4Q6ZxHKGxnYV3OngGS4Ivd7hU+ecGuTQkW9/djlgDDTjYUinAvQOchvVzaTkOPZLwQu5D4U/a/W9qwmzgVU3zPwsdzhAp65vqNfE7lYAwO9EFD89r+fRRfRvF7GsW3Bllr/QauO1hJ3oA5Lr7F2QFh1pyB6xbue2kwPFBaPOzAVbnitXOA74GPwEQz1di+cR9GrKa0ggx4Ovw3pBEIxW7S3VROTX3n3FEospdxDIJnEH5yoM5V3eNn/ho6nzAx+XuhCwu++x31G6qxik458NPO0b833byjJm8a/yafWD8yZ9bGxwyykF/ekeON3pv+VdaqCSC0yqwLCOxxOmRDJFdyYNHwDw3aPGMuUTyn/H1ESsAP1Mp4tutum11IHoaSc4B/x9+I053/rOZrxqHkxDDCgp8WilmONeMawue6pI2d6PWPqxq8SRujNP9W0XS4iWORepI+bq/R8HbTEAVzAbf6DMXSZW+E4Y7P8Gxl3v4DgJCxZ8HG0GPAgTjskTtTiqaO98=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS1PR04MB9358.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(19092799006)(23010399003)(18002099003)(11063799006)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TDdqZUpLa25mTEVSR09WbDh0TVRjK3YrZzE0UWlrSk9DWGh3cXE5RlFQUkNG?=
 =?utf-8?B?Wmc5c1U0d0JIVHI0TUx0aG45Nzl6R0w0bTlQUnJ4a2poZHBYbFhqbndkNUVN?=
 =?utf-8?B?VVB1Z2ZmYmJOb3BzcGRMeWVDdFpJdEtjR2d4RGdQM3ZOVlZoQnJNaWFCa1M5?=
 =?utf-8?B?Rlp1aXBKeXFSYUV4YXMwcWZSVnI5WndFTlFMWVFjbmtlNE5oZjRNbS9sY0w4?=
 =?utf-8?B?bi9UUGVDWEZwUWJBMlNUZ0lmTEJxcWs2emhZc1VIUFJOck8yU2hNVEF0VENM?=
 =?utf-8?B?K2s1cSsxV0JqNmh2dGtxOE82WlFHTkhTU3htNzA1ZC8xOGJFZElZblFUWjU2?=
 =?utf-8?B?a05qYjNSL1o3K3lnTHROeEcyNlpNbnBGa2s4d3ViaDNKaVRPRFdVUXN1UWhD?=
 =?utf-8?B?YVh2NVpFWTVuOGJuQW1yQWVlcWJoMEZpeWR2UXZLc1B6OWJjSk1jOFBwYndY?=
 =?utf-8?B?bzArdDZxVGpmNGV5U2FwRlFqeGtMaDE2TjQwa3RVVm13ODVKbjVCWDVNeW1J?=
 =?utf-8?B?cHVQeGJ0cUxIeDVoTFlvbWIxN0NwMTlXdHVNTldKRVd6blR5aEFTK1VERDZy?=
 =?utf-8?B?Q1NnVENqeWVsSUpXL2RmZzJMUjZ5YjR0VDFUVXlMZnZUWUFnUWpaeThDV0J3?=
 =?utf-8?B?dk9ud3VMRDgydXJnTVFDcHRqT3RQN2dER0d4MkdDa05FYmQ0MExFbTRkYnJB?=
 =?utf-8?B?WHo4MGprRy90cWQ1RmhXUjd2M0RKOWorUXkxZDlMa3h2aUh0KzFKeGpYckd4?=
 =?utf-8?B?TUlTQmlCWEx5K2RkejBEY1NCUi82RWhlYUZFMXRnUVZwSVRqamJDZ2hjUDFQ?=
 =?utf-8?B?QTB2K01oa2ZaMkZGRkJKcThNYml3aWlBNzZ2b1l4UEJSYitPL3lpTTRMU1hN?=
 =?utf-8?B?UXFOY3pyd3dGc1ZvQ0ZyTjZkN3lXTlNBbjlHSkVUaEpxclRVRmVYY0xPVFQ4?=
 =?utf-8?B?NGRUS3NzWG1VYm42KzdydUtuRlNhM3RwcGNmQnRoclRZSUN6NEJKc0xYc1l5?=
 =?utf-8?B?TTBlZDd3VTFKQmM3Q08xcVkrb3FvcFVkU21waTVCclArM0JvMVNOMzlieWNV?=
 =?utf-8?B?dGJkVFdkRnl0QjEzM2txNXJXenBmZkRVM0UwczZia3k2c3krcnV5ZlMzczNY?=
 =?utf-8?B?WTFOZnlBeDRzSUdYMko3Wi9MN3pod0lyZjRoYXpXT3hDenVvazg4dkxCd0lh?=
 =?utf-8?B?aWxhclliODl0UGlmWFFOQWlMT2JqaUZNU3MvYW1jUHFoY0U3ZWk4eE02MGx4?=
 =?utf-8?B?dmVENjhaMlZZOUI3R2ZMa0s1d3lmeG9yUmMydFBkdjBzSnVWWUlmWmlLamUx?=
 =?utf-8?B?eG9yRFZldTlMUFhtczJSd0x5L3VHZ1RNYnBrTXZybnlnR01yVzQxTjVTT2FU?=
 =?utf-8?B?c3BDb3huNTB1R3NCZTdKK3R5ako4d0VtbmhqdDRuczVGWm56YkZuendDYmFi?=
 =?utf-8?B?cXB0ZGI2ODlLOUJEMlNrZ0JQeEsxTWp5WDA4RFVoZkJtUzBXSlZLbkxrUGU5?=
 =?utf-8?B?cHFNVGc0Mm1SamcxbGhlaVUwZHFMb2VETjlyNHlpOHU4dUVVaE9yUE4zM0pG?=
 =?utf-8?B?Vm5WcW1jMDd3ZnFDSHY3U2VIQkgybWxISFY4ZkEvNjJEbkhYa0JudVpBQVZ1?=
 =?utf-8?B?MmRhSlpLaWJ3aFc1OHVITEJWSVVMKzhvUm9MTTdxZHFzL1k1Q1dDQU1BMzlP?=
 =?utf-8?B?MkhVRGFJQUZKLzU4M1loVk95NlExZGhUN1F3OG1uMjVRajJnZzlzSHJmRjh0?=
 =?utf-8?B?VWJNcDFBYjJBYWw3UWtMWWY1Q29FQjZIOFFHc3d2Q1dDUWhlZHFHSVpMWklJ?=
 =?utf-8?B?R0hWblFVMFBWUlVBaTlHR3dwOU9wZkN1MWRLaEhLeE5HK3o3MVAyWWZJYlhK?=
 =?utf-8?B?eWl2Qmw4VlMrOEUwZ2pDYkRTR0d2ZzRTUnY0L011VzJXdEpsVW9jVHpidDd5?=
 =?utf-8?B?NnBxeERQR2lJdHgwMlVCK1Ewd1JsdmNEVHkvcU5EWnVTSlZPRm1TclR4aDJa?=
 =?utf-8?B?MUJzZ2NsNENOL2NPbjc1RldwcmJUNmdkZ0cyOSt2Zm5hSWJBVGJ0UC9DeGJG?=
 =?utf-8?B?QVNYanpBUG5EQjNWcUc5MW9lSDRJd0pxVEFTNUp3M2hhOVluekc3VzByai9q?=
 =?utf-8?B?bEtRY2xpS3ErQTRLTE03TXlhYVpJcE1XWnBlZFJ4ekhiK21rMTNpRXQ0Mmlu?=
 =?utf-8?B?aTEza1pSRXM2WTFTS01pV2xIYXd5WVhHdHVlUURrbDVCS01nZGlJeUwvOWNx?=
 =?utf-8?B?d2NiUm90VGxibmF2djJpZG1Wb29reW42VjdQUVdNT1A2SU5lQmYyRUowV3pW?=
 =?utf-8?B?Uy9FMFZvK2l5dmYzM2g3WnpPOHRPa1FpcFNhTXdVSjZ4QXN3M2tNU0VPdGc0?=
 =?utf-8?Q?53eS+ev+j/b+rF1M+gh0LKi/oTXSLXyIk+Hp5?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 378719e4-be2a-45d8-dfe1-08df1216b588
X-MS-Exchange-CrossTenant-AuthSource: AS1PR04MB9358.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 04:14:45.5386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gh26G2Xtyf53VRGU3fEffMtKBta31hG/IdqSc+8Iz7gdHnA2oo7Z1RWJFEaI02IN18O0nlX2Dcsx/5mJNcCPEZ//XF+yI1hXZZNsymzkrQY0vVZpzGHRxxsDD2lV6Z13
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI2PR04MB11273

From: Sahil Malhotra <sahil.malhotra@nxp.com>

Adding Sahil Malhotra as caam maintainer and removing Gaurav Jain.

Signed-off-by: Sahil Malhotra <sahil.malhotra@nxp.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index da3e42d2d190..52c9c0bdc1eb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10349,7 +10349,7 @@ F:	include/video/
 FREESCALE CAAM (Cryptographic Acceleration and Assurance Module) DRIVER
 M:	Horia Geantă <horia.geanta@nxp.com>
 M:	Pankaj Gupta <pankaj.gupta@nxp.com>
-M:	Gaurav Jain <gaurav.jain@nxp.com>
+M:	Sahil Malhotra <sahil.malhotra@nxp.com>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/crypto/fsl,sec-v4.0*
-- 
2.43.0

