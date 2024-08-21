Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2071.outbound.protection.outlook.com [40.107.104.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB99514D2B1;
	Wed, 21 Aug 2024 19:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.104.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724268120; cv=fail; b=WBlPkJ2JpUjzFf+FNgPs+rOcB0BkrR2X7Bl+YayOalwAMbr6ydQOPy8TAhQxubpYsXddujSzoM3mnzXtmxnKMYr+Z5vyB0Wrm0Och41rsU4A6MipyA0Ju9GHlV2hy7HtEr5E4WPfz7Nh6Zx/pdLiDESPOn4jSRwNwDmNXJOppIg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724268120; c=relaxed/simple;
	bh=PAawDgADKpW8HU62/+N9YVsrAyg8iFiI5XduELM4Ic8=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=CYXWOf9pWlQvjW3ylg0ToJ7DIfbsJ+UNy3cqqqXkSZpU42qLvEPnpAMHxCV0LL+SXXBZJ2qas7mGpPDyu+oqFYdGx1usJ3gcK17mVG8uekZ7EyjMQvSLXqbkoVwmT5FyN30igIRpVFNUj8qz5Dc0RiP7xQzleYgRN+jk0Id94Ok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=j/1OJscZ; arc=fail smtp.client-ip=40.107.104.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="j/1OJscZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=llRUz2ZYcA8UYVsob5aBHIh6yMoPGvyzUdmybifLsMpWYIiXsyEcdikU4Y+fswIUKtQ22h6Ccu7SJg02IPzGDK0ODHAs6Gztm7f74RAA8XYX2uTmHggkrZhP4fbXK1RLnk4i1byENC4YNQ4CZbbNBuBjhhaqin4ky2V/CanV5XKQnNkB8g1ewWmT1utyvtyIqQqbuG16Hc0R2f9Xaz/Wq4205DED2GICjuCUIpxThIwbG1svVW9dwjgRMLzcxxo5LOaEGqBeQBeYuEjKGwK1CNYFtDFRJ2lilGqqUiWnhESVj43/Dfhmwl170MzatfkRfvp9B+csG9ikIQwggyvEvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UPrtaNtAm5vBH6oyRVKChdXEE5O3WSjMHsN/w8emMXc=;
 b=YfU0gQ8Q0WcT84Fr5QMC/xWZObiWz85y63R4+mMgYhh+kVGkCpbANBjW1IE6ZMtjsne+NIqkDjI631hAkFptPL8zJaZEoSvG3wLgRAWIxIxmWmJQBUUIJEsPAZjQ1qV2KC90LHfFzZx/dzfxPmNZsinNz+D+Q1IIGnYlgI/5s37j3uQ5h1nPjYt/ui6zBL7XdjkZk/z8ZhagBW5S++1t0xPXdoO8j+peWrmkYo/ArK/KMRsI0LnEm34hJpd5Imnfk213EqAg0MTpD5qbpt/SjgUB2K+VMAcA3zagArnz2T1xcfea6j7Qwb2/E5saPiSjUgLC2hicTw9R+3fMKd2oYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UPrtaNtAm5vBH6oyRVKChdXEE5O3WSjMHsN/w8emMXc=;
 b=j/1OJscZrq/xgOAwiQDeOS4jIbk9sQ+EI5uiS0b6vlX1rvjL2IWuzw+REx7stY7IetN9hNqC7GNA8jupF+cNckAcY8F+TNe/uMeNs4faYl8pMaWsOFOL2Q8qCqePVRrgOm+9EmnEmeH4siljlMGdK55ayADnTRphxykh1iLfSuJSTnNNgd+DjLLP+ovLmhci8YS+RT0yG0u8cd2qSrIEKavFOa4R27Q1AD4iNGzHszzYg8e+LCrdHkrWZpkyQNnbMhofo/EpD4QaPQVDRvDP2wJthCc9zrs8QcgdQ0URSAchVMh/ZsRKCv3B1cm9UK57scXORWpEeKfnC1EfCl970w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9642.eurprd04.prod.outlook.com (2603:10a6:102:240::14)
 by GVXPR04MB10112.eurprd04.prod.outlook.com (2603:10a6:150:1c0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.18; Wed, 21 Aug
 2024 19:21:54 +0000
Received: from PAXPR04MB9642.eurprd04.prod.outlook.com
 ([fe80::9126:a61e:341d:4b06]) by PAXPR04MB9642.eurprd04.prod.outlook.com
 ([fe80::9126:a61e:341d:4b06%3]) with mapi id 15.20.7875.019; Wed, 21 Aug 2024
 19:21:54 +0000
From: Frank Li <Frank.Li@nxp.com>
To: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS),
	linux-kernel@vger.kernel.org (open list)
Cc: imx@lists.linux.dev
Subject: [PATCH 1/1] dt-bindings: crypto: fsl,sec-v4.0: add second register space for rtic
Date: Wed, 21 Aug 2024 15:20:48 -0400
Message-Id: <20240821192135.578126-1-Frank.Li@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY1P220CA0012.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::8) To PAXPR04MB9642.eurprd04.prod.outlook.com
 (2603:10a6:102:240::14)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9642:EE_|GVXPR04MB10112:EE_
X-MS-Office365-Filtering-Correlation-Id: 81c07154-aa16-4cd2-ad6d-08dcc2168409
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|376014|1800799024|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1JPOT40KcMpMSJ8zi/J2BiKYIrt/oSahoAl1rAsxFdRbitnDSwyxqkWvv+tW?=
 =?us-ascii?Q?zmgiZajIrXUBWU1o6R7AX2YsfvSApdi1bXWj+oQgArFJysID/gq/Kevj2TZ3?=
 =?us-ascii?Q?QszvmKkSU9ixWttZSNNH+3CxU+C24tFfkX339Z910I6YGzCXIjXMZfUhHV6d?=
 =?us-ascii?Q?nqoZs8QP1fyWL3NOQX59e+yPjVQgxghQG7WPphGqk1BzhFY/N4fyOSmmMUuY?=
 =?us-ascii?Q?m7gtN8FIyDDeNCMr5Kpum+6cwQnaRCgFZuvswfQv7iY2g+1swVUJiP8f1IvX?=
 =?us-ascii?Q?f9apD+VJwojeqjSsnNEiusv1r5uY6f56F3D3lYc51p+3DWlhKf96oYHcXMVs?=
 =?us-ascii?Q?k2CSaQp5IMF1nE4q79VvPXUJsvip6xdy3BywBPC8cMzdI+Mr0wOBQxjgQLkz?=
 =?us-ascii?Q?CNFSN88w4+S4avR8+FnbYpImAEbjRjkTrgX82mqno/bQ6jAxQXYnB1soyers?=
 =?us-ascii?Q?XIcBdYRzN/UTi+7jbZ7fW/EKfup0Vhksr8SLaQ+tCcPtzqQ2K42UZbZngWlt?=
 =?us-ascii?Q?d7FGah30MpNtgliTsGbYPqlLp84uIPKrBmrgxHoKiVa1/IttA85vwgCbYedQ?=
 =?us-ascii?Q?Wls99G0jNTN9p68tz/kJqPEGO16CqgS9v49gaopapaiVWOF7s2XJAZoQTLaW?=
 =?us-ascii?Q?bepFSpGY3CWRX655Fe6YQcqHRC2l68Qogt7nj9Jdg3P+HWrnBWw63t58IAYX?=
 =?us-ascii?Q?mAKO4LLfH4qhFcINbj2D4ASckbwSqUIIxNKM4CXXjKzVy7xUddgJnQhgK9IB?=
 =?us-ascii?Q?RthxfyFlIa34SkeqEsP5SJwFijWHCl8ynFED0GKT6N/8nvm2b1p/2Dbq6WAe?=
 =?us-ascii?Q?h4o2dQacJ+alsii7QyinC0EiMD700tQ3aDchx2frZbsDYQ0V6FUkyot1b58a?=
 =?us-ascii?Q?kvzTvpMCFwzbgTOELkFQnVH4jrzqCT5SkIkd9jaavbvSw76UQlXUB5EviVu6?=
 =?us-ascii?Q?j10OUGu6JZpXea88GfNZ1Hz2jiR4m1dj2OzANiKqDuPeBIfwNC9n3HOuEwof?=
 =?us-ascii?Q?UXo2PW8h63nfBTqwhmjsS36Qkc9z1DlMvlWQL2d/PE4saExu9KuDAGM9cwDk?=
 =?us-ascii?Q?0vNe8VhjdN/tatH+rAzd1dE/yHpXwCLIP5oyMqH0lcYVW8TBzmb93GkkDR+R?=
 =?us-ascii?Q?f5A/0rvtkS1v4A8UYgn/XTGBP1h+ghWJIcnRFLlNOfld8QmO9Wf6jIcVOSgl?=
 =?us-ascii?Q?vxGSFj5l2TN2hvJGJI0xJ80ST0Gcu22gy+PKaqzmh5AvDFrAym/i1QGtxBrT?=
 =?us-ascii?Q?66KZW1Ao1wgRqhl/msU6xrG0p7p+gKT9l3/mPGUrBH1kPkoTZlNtq3Cqt0Yx?=
 =?us-ascii?Q?Ngd21GBPpRtkUk8/vKn5aU1JMQLgpzGCbhUnobnNPo8n6MWTQcGlNo97tq7n?=
 =?us-ascii?Q?acRPefvvGoh0F0qP5GlSw8CH8SXh?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9642.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(376014)(1800799024)(921020)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?asbZrm2UazLU/peHCbEKPfct91wS4X0Ft/ZkMNR1ddDJaBfZyc7HTWfjA29g?=
 =?us-ascii?Q?qFZnHtEXmfnVjeyQe4UbRr0k1KlooRzJ82GkCMouRkDde/ATAX7wyQ0O+alU?=
 =?us-ascii?Q?tn/ZfQuc1mSTiPX50b64k2dej+HRdYB2OOGtSjv3h20U+pg8IqDYcxIdADME?=
 =?us-ascii?Q?rHhJFQ7siA9cNWmy2+TkiLTONWWy/vEwCpUGuIcbTaWd0f9RspGUJkTVOBYs?=
 =?us-ascii?Q?tTKudce+ANk3WdsI5qW5lm8WOLix3VHD5LSzDcCllSXmxz3+vUiIZgWNPZDq?=
 =?us-ascii?Q?CWVEIpSJ8++WVUYi3Y3t409pitGj7L9n+I2Pkz69EsNQQ75PS2DDPdfzk2M8?=
 =?us-ascii?Q?3PRdlliVPlyUmpC0+Ly6t6Tojx3sV8QWfj1a4dwNl8DxTfYY9wotBw9sjDuN?=
 =?us-ascii?Q?9iHcz81coVNULIPyi1ZJuoWzyXT3jdLKwSOxm7f900GdRNRtLleIRLomx6Mr?=
 =?us-ascii?Q?k2uFvwSv1pPtNC+pNNHY1QO1YoSjNI+h797peMoGJLoNXu5DTQAOky1zOxOs?=
 =?us-ascii?Q?R08dJ27R59M2J8dssu7C0s8pWvtNXyxDB2xVoqL7pVOpqbDbbtanMnNJXA6P?=
 =?us-ascii?Q?ih4/ujC2xipyvv7PRpQgtjYIUI/YnUr0Uq6TzPQoFsipkRipcfZdgf2Wan/t?=
 =?us-ascii?Q?2ERtKB5veTcUxlRB0T2o1zOJjMdQNfa74MxSt1MwK3hZmm2mDtsbUFhBbUhI?=
 =?us-ascii?Q?r+7hpl1vBPki1qAtt4ifZdyZbmBxUQcdTqcReX2VO8dyJYmymoAVO6btXYBq?=
 =?us-ascii?Q?+sHzfEIPPHq+o5b8tvdrqiFEo9IZLba9x+WC+tdqT+X6qa5qOewKkMphbw30?=
 =?us-ascii?Q?d1wrzlyDvHbTVWrS979jftgg87nmPBhoytwtB2+tVr0/sldgRoaxgH/hHuWw?=
 =?us-ascii?Q?fnIcE7/LsC11Pr0HDtj3T1f4oG5x7vidozQtW2aPV/AdIM9KqRcowh5At/0W?=
 =?us-ascii?Q?RDikgs06dzrMa7HFFBIiJpiPSKo1ryjLf+STf4m2gLxMqafUOyEDAvBzqiUJ?=
 =?us-ascii?Q?9rvMQHKa23o+/HyZpGkS0ulqtwRIGBs5WgXazjjUE1extRX5NffdJTi0gaX1?=
 =?us-ascii?Q?fQ/hFkPCGKLmQz3ByKhKIUzQs23h7e4fDIumht20K9kcp4kIa2Xi/NlcaShS?=
 =?us-ascii?Q?6vZ64QMFU1HaJQqgIoxz5R+9ELHI72DoVV6Ntj/lEsL99YxI6sRuzpSFgwCQ?=
 =?us-ascii?Q?8X+DjIb7G+jDlZeYqjOV9vINfpjAXnmmmhmg83VxN+GQwEJnjbRiykkeruXa?=
 =?us-ascii?Q?IS/8mqHPF3IV8JMs5njsdPykKBwb+RP5wX5OLmxa6vFxrRTu45M4KmBEmToy?=
 =?us-ascii?Q?rwmCT4QCEHQfwkkolY25+xQehOBxzeJ7wbWxRU/31Yhe6If4Ea8vbEVJ1PMg?=
 =?us-ascii?Q?qlm8Ku99YrxxlvKepRCXIrGTy1k02z+1qDAzm01usrY9GwAmFvOEKTHxPjQV?=
 =?us-ascii?Q?7bvC/mIBSOYCT+W5VrMhig3MCowwUA9JynerndkHUgHc1R4Ao4VCwcMfgTOY?=
 =?us-ascii?Q?9sEL+PNB9G6gdad3xmCK+k3Lz0QC0AhV+LdML3Cnz6yhYGpch7bG4qg4/OVw?=
 =?us-ascii?Q?D8gNPz8JcvRc1bVBnNQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81c07154-aa16-4cd2-ad6d-08dcc2168409
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9642.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 19:21:54.3400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6pmkxMhwGiJ+gZfosHHBOQC9QvJYJk/kHbZqYD+dsfrbPNJ+dq/5hA1ZE6JjGRjsQMVZEvcW7+FMx4ILLwLm0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR04MB10112

Add two description for register space of rtic. There are two register
space, one is for control and status, the other optional space is
recoverable error indication register space.

Fix below CHECK_DTBS error:
arch/arm64/boot/dts/freescale/fsl-ls1012a-frdm.dtb: crypto@1700000: rtic@60000:reg: [[393216, 256], [396800, 24]] is too long
        from schema $id: http://devicetree.org/schemas/crypto/fsl,sec-v4.0.yaml#

Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml b/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml
index 0a9ed2848b7c6..9c8c9991f29ad 100644
--- a/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml
+++ b/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml
@@ -137,7 +137,10 @@ patternProperties:
           - const: fsl,sec-v4.0-rtic
 
       reg:
-        maxItems: 1
+        items:
+          - description: RTIC control and status register space.
+          - description: RTIC recoverable error indication register space.
+        minItems: 1
 
       ranges:
         maxItems: 1
-- 
2.34.1

