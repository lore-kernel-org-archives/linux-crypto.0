Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.132
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793691194;
	b=4MxAtpl/QMtcp4OSys5OSCsKFY3P+VdU34vGi4NxDLeG6193pC5MG1GsfE7Tjhu+a2pc
	 lvasjC9INyusMm2nsQIsAsv7q0JHoEGKLfwidU+OzeQNNqwqEQw0JmzyHvhY4FdP5W4Ml
	 kH7RTwJT/SYOea9kBbx7/oStTTa7PckIswpaj9GYlRX5MTeFloh30Njd36QEcmr7AG6Hd
	 gBl4oY210XauC8wyhrIjZl2EAwOgYKGggejx7qO1qSUwxQ/FpeHWu5gFA11ezO3SYX13P
	 lpg89tTnp+6M2rJUSLaqvjnIu9FpKjgKJaIt8qkDpG865gASysfgbDsRXch51vNo9mA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793691194;
	h=DMARC-Filter:Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=BYeiqVioAvu2AAjmCUZfwu6UVT2OJxDF97usFNixLAQ=;
	b=2E80wxARdpvuQNRoiRT5TiuZ5Z4xizfTliQ5fDFQ7IHTs0btEmyDVo1hSW7ieUBtfyMS
	 iBg9LSLoYY/IuuroHEUXqpaI1C4lZjNnmUf9kSA7j0IzZzntf8bfVHGnmyiS+SSCMaQxo
	 uFHyLWjJ5CIka+VvuicrG6pYaCZCqwQBYCZM1IQlhGYYbzJVU+QStqzqyNb1Xvg8WrQdy
	 S3Vx0tDtQoWCYVRBOZGa6YOGY1Xwx9mTmTFTLBJgS8G+T669E8KkrHYwOM6bQPALstsDK
	 a/KwlAsiFqVJorqqV0gVmJuV5b3RSMtbWzimS6/JD4DLJtU4vsdGvOVtIGZn4uUJZLg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=starfivetech.com;
	spf=pass smtp.mailfrom=starfivetech.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.132
Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2132.outbound.protection.partner.outlook.cn [139.219.146.132])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB124606A32C;
	Tue,  3 Nov 2026 07:33:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB124606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y5ZLSlglU5RRavx9f7wUnqt+1B7IvtHcGvH0NAf7MdaPR3ZVVL8kEqWoKkK9VAfRRWm3HsbRC96OoEW27cGrNX4530HF5P0V3nAU/Xo4sm4v7YDGcsanjUZMrrykn/c3liWasgNdSXPYeVR6q7jB2irFC9T5wNC9ZFaoaTjBPrW1ijw/XFMeWSPql0iQuxHA4gFCS/CILmUCnkZxDpxx4x8ymdPX1gx/FasSK36eVeOle0a8DEoRrnSc9GATqSC/3kN24X3WLClAexMXXSq++dmv08e2paAVQfPGMoPOIGYZh1k5qpcy6+s+i+4guJtxopGEfPQpNpJoYtV351uJJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BYeiqVioAvu2AAjmCUZfwu6UVT2OJxDF97usFNixLAQ=;
 b=XIWT5Nmia9jqo82THaAVVTAitUjw9QOca3LO2Df/4rQSonhhHjmLGjN3e9tKZcxelwkxsf9kbqIgh6ARamszlEEvNXkfXgyAW/ONveA8BZNhkvowKBLG/tZP48kYT0QFe8Aj6sqeS8is5uJkoGnzSFUDm/VrZLvU7EcuPZwsNWwmNEqeZ7MLHvMUylunshkMW8CxwrUh5I187WQgWQMN5DTVZcKNTyQKLTxplh20VbotMGtDb+Js87UDnY5Bw0wLCIJyHQ7DiElo/j++xaAX5wqv+tVNBy+kyxMpNVhsK6CKbst+Zspa+IY4cJSl7QD7w3Nss8Ec+EPQubSx8KpXCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1032.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:c::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 07:33:00 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%4]) with mapi id 15.21.0569.011; Tue, 3 Nov 2026
 07:33:00 +0000
From: "lianfeng.ouyang" <lianfeng.ouyang@starfivetech.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
Subject: [PATCH v11 1/6] dt-bindings: rng: starfive,jh7110-trng: add jhb100, drop jh8100
Date: Tue,  3 Nov 2026 15:32:47 +0800
Message-Id: <20261103073252.3028-2-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261103073252.3028-1-lianfeng.ouyang@starfivetech.com>
References: <20261103073252.3028-1-lianfeng.ouyang@starfivetech.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: NT0PR01CA0008.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510::13) To ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB1032:EE_
X-MS-Office365-Filtering-Correlation-Id: 2de92709-4111-4f69-9164-08df397cafd8
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|52116014|38350700014|261021123027099003|56012099006|261009223027099003|261028144727099003|261022075727099003|261026121527099003|261021121427099003|261026140227099003|261022105027099003|10067099003|18002099003|22082099003|261102123227099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	mxJkKXvjRcooyJe0HdDNZBAEfQvcpRiid4N2inrF8b3olyfM2HEjkwjBDSDkymG0bNj2feFgIqYsMkr4X8nIHIcF56+zzwyc8qIr1F4Ya18vSN8U4TG32A/jqhhT7gvGKarfzRtfygzG0/zAF2xZxBfEBQQYNbSGRZFMOaEOIHYH13CFHO+ei2CNmB9gkS3XiMhjjPg9fU6kYhAyhVeUzjLxXGCG9HmPgM6wBCLqxwqRZ7O7onqs6llxvKInh5B3Ezs3mD0ILcR3KgXaEHmI9L0tb9p/iw5/TlDejgUz42L6UGUtpwrg34a+7sXgJETkkOB/XPNkcHsW2uTVz9Zrn1OMFl67XdOiSr3h0iSxdjeu1yHeGtmiex1lh3JixX7tzoH4AxnvkJ1NpHcvI23Smdej2q6lilKFWsM5gn61fSZL1idxbn7nMgDj5ySFJTO8k3nDTiv6oy5UbKyJ2qsMR+U3dGhckGJk3XofL9KiLjD+EWz5SShvScIAyQpn7DoS3vgJkAOgxZZlrIrYn7t7vjSm7wm89NtXnmBjBEv+tjM2jTKt9JUctwGleph1GzhL
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(52116014)(38350700014)(261021123027099003)(56012099006)(261009223027099003)(261028144727099003)(261022075727099003)(261026121527099003)(261021121427099003)(261026140227099003)(261022105027099003)(10067099003)(18002099003)(22082099003)(261102123227099003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?52tR4EUThfSR9qBfg8B4PPPTQM3a8Pt2Lrs/XJ7TLy1B5mQxjf5tWkgLEzT+?=
 =?us-ascii?Q?miqbqexQ3R43ScXK7b51G5OEImUReEdpNp4Sw26vaiPd0UhzBKxPH56Wzyu3?=
 =?us-ascii?Q?Jbrsg8qHuqjx+2RXpD3SErvWaZWoNO4ziMnykfc8g9vP3dIpv70+48dDIgfv?=
 =?us-ascii?Q?Br3DN01581MwTxkYMBmY2US4H3tpU01bE9Md5idKLCDcajlNyVFYv70e4BNZ?=
 =?us-ascii?Q?VDM9JkVyP7tfJ+owoA4KcKtyIFVU2b9Ml5ya69cDuKZeOZyafyehEcIkh+Bm?=
 =?us-ascii?Q?oIkexMLW9fQN1hFoWCRatcpCor7tuqIln/nDqb3pqZk+5wain+wKZKpNIcHo?=
 =?us-ascii?Q?x9T5qBdtKCbQASppaAFH9Htc7a9nDN7sGPi78XUWinWQlzRGwEd3fp5NSBKt?=
 =?us-ascii?Q?eNena6FrTfkurhnY+hl9+Kv6Ni7V2Pd5Yo7Jp6tm3mOjyn9CKmGFkvaLbELt?=
 =?us-ascii?Q?/R3u9U4mZ2ddve4/MtufqOh74ByzQidVX1Vsj1LY0bIhWkDuv+y3b/K2O7LH?=
 =?us-ascii?Q?/qvRFvmb28oyriBUK3742cgsjE/gdm0MSl8/UiUR/iLBbYoZB6iF/8kC2uRW?=
 =?us-ascii?Q?rUJUqLgglJVvlwLhmGH2iJw5pnt3szI1YpbEttzAmimInBe0jIgAbSk8vqAP?=
 =?us-ascii?Q?BpW6oWwuiM9F41jyc+MZbsymB1n+AIREDX/r92ooaj3GYfUUEryhKt7bkdvR?=
 =?us-ascii?Q?pQ/s3cNseARI8IPjnj1Pu3FNqy+3g+bxxJWl7u9L9v9pVAe4wlbQqcPhuRb9?=
 =?us-ascii?Q?BRuRBTaDofxCQJpkjvo9KEGdUmGDsq5RFz4kufJFGnGlBZyQ2hf1kRjAlN6d?=
 =?us-ascii?Q?JStG9W2HZcjhtxymjtpxXB9IOPq5gazbLBbG6+tmApoqSgcuOYIiIErllckj?=
 =?us-ascii?Q?h/B+j814KrfNKvBNW6gEYvoRk2K2eUOFBV7k+ye+whrsMhZf8sKykxeh6hnB?=
 =?us-ascii?Q?hiWb70g7Ptu6vreZz+LwGQYuewYU6mu7/MAvJLMmQeKty6RYQaAFvsOziqg5?=
 =?us-ascii?Q?QmB77nljSRHqDvgBIO5E/++PSuD1LsM3bluc4FglRtk7F3VwPUSbZtGMR4Zg?=
 =?us-ascii?Q?QtNVyqWoWfW0zFLU4f+SUDD7AYujBg7PZ7V+K25pbsaY+8NuGCmxvFpq0we+?=
 =?us-ascii?Q?yZDo7N2PE37Hg39Vp2qXG4G5mDrVMglVnTqlEy3a8A+kPc0RAVHu0hustadz?=
 =?us-ascii?Q?s9G4NceomSu77xLcSB/1EGE0JbbNumIVtUs+u39P1mVQOsjhrDiCixEFrxcF?=
 =?us-ascii?Q?fX2xSMC0moy/KC+HhvBU1JLMqulIW8IakPHHIsdXzk45XNfVP9QW5NgnLhF7?=
 =?us-ascii?Q?B+wsYEFJ6KUlUEIQVozBgkhMqlzzuNrXRPQgDCU1DL1XccW+GnHa25nE2zQv?=
 =?us-ascii?Q?DcngnQ0G1GMNdBVOPKlLXIPl+FxpOe2sahYHpjDankScKEOubaXrjbE3QjnM?=
 =?us-ascii?Q?oP7qOZf1Ao0fLiHuU6PWZOtaeU8/d5T/MPhj+UGQrxyq3Moi4P58XxdJM6vO?=
 =?us-ascii?Q?eRV+RDtEoGSFcDY5HQQjBIAxxkgA4cfA3fFB9xTerZFEXPcpOKsAwUQ7rAAm?=
 =?us-ascii?Q?BmcLLVREGrRQrG5dFmPstz7V9bIErDgNPCBXd1R4OUZquN4l0DWAzqNWuGtM?=
 =?us-ascii?Q?rEKwRy6gWiasIXqoOS3wlMYvZFTnyCMocWVRku6BIkElpNhtwCjHMGiVjNX3?=
 =?us-ascii?Q?ttrdXsS0JCJrCWNQcZ1ZXCJK7S+oC2A+J5fyidmG5R3jhz1MoM+W5JX8qKml?=
 =?us-ascii?Q?+CvIthpiztA+fOxleO/s/J8hWOdh+YgExyWyM+0ZGgSjfAz9pDVL?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2de92709-4111-4f69-9164-08df397cafd8
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 07:32:59.9720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b053Efitxby4xWtlWtlcwgKQu0bSTQjPUgQ1mmDUjuQbDIeWsMmF+PFOuDU8GnIjbPJgvCu4Y2D2j0sqp93NUHtsTZKkV+t+4sANKCc1ysbuwWuP3Mya+fq0gdL2RB62
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1032

From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>

Update the StarFive TRNG DT bindings to reflect current SoC support.

The obsolete "starfive,jh8100-trng" compatible string is removed since
  JH8100 SoC is no longer supported. A new "starfive,jhb100-trng"
  compatible string is added for JHB100 SoC TRNG support.

The maintainer entry is also updated to reflect current ownership as the
  previous maintainer has resigned.

Signed-off-by: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
---
 .../devicetree/bindings/rng/starfive,jh7110-trng.yaml  | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/rng/starfive,jh7110-trng.yaml b/Documentation/devicetree/bindings/rng/starfive,jh7110-trng.yaml
index 4639247e9e51..d21769b7d54e 100644
--- a/Documentation/devicetree/bindings/rng/starfive,jh7110-trng.yaml
+++ b/Documentation/devicetree/bindings/rng/starfive,jh7110-trng.yaml
@@ -7,15 +7,13 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: StarFive SoC TRNG Module
 
 maintainers:
-  - Jia Jie Ho <jiajie.ho@starfivetech.com>
+  - Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
 
 properties:
   compatible:
-    oneOf:
-      - items:
-          - const: starfive,jh8100-trng
-          - const: starfive,jh7110-trng
-      - const: starfive,jh7110-trng
+    enum:
+      - starfive,jh7110-trng
+      - starfive,jhb100-trng
 
   reg:
     maxItems: 1
-- 
2.43.0

